%wffiler ;ven/gpl-write form: file graph data in Fileman file ;2018-02-05T19:41Z
 ;;1.8;Mash;
 ;
 ; %wffiler implements the Write Form Library's ppis for filing graph data
 ; from html forms into their Fileman files.
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: George P. Lilly (gpl)
 ;   gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-05T19:41Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Write Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@to-do
 ; finish applying mash style to subroutines
 ; %wf: add ppi & convert entry points to ppi/api style
 ; r/all local calls w/calls through ^%wf
 ; change branches from %wf
 ;
 ;@contents
 ; fileForm: file graph data from form into fileman database
 ; exception: handle exceptions
 ; testFiler: test driver for the filer
 ; $$var2field = fileman file & field # for var in form
 ; $$field2var = var in form for fileman field in file
 ; retrieve: retrieve all form variables from fileman file for form & studyid
 ;
 ;
 ;
 ;@section 1 code to implement ppis
 ;
 ;
 ;
fileForm(ary,form,sid,report) ; ary is the input data, which has been validated
 ;
 ; ary is passed by name
 ; form is the form identifier which must be found in the form mapping file
 ; id should be the key of the targeted fileman file, for example studyid for
 ; the SAMI background file.
 ; report is optional and will contain the processing results. it is passed by
 ;  name
 ;
 ;  We must make a choice whether to process the file looking for fields for
 ;  which we have data or to process the data first, then looking for the 
 ;  fileman fields to update. We have chosen the latter so that forms can be
 ;  made which cover only a portion of the fields in a file, and will process
 ;  more quickly than with the former approach.  gpl
 ;
 if $get(report)="" set report="report"
 new fda,fdaentry
 set fda(311.102,"?+1,",.01)=sid
 new %wi set %wi=""
 ;
 ; zwrite @ary
 ;
 for  set %wi=$order(@ary@(%wi)) quit:%wi=""  do  ;
 . new fln,fld,combo
 . set combo=$$var2field(form,%wi)
 . ; write !,combo
 . set fln=$piece(combo,"^",1)
 . quit:fln'["SAMI BACKGROUND"
 . set fld=$piece(combo,"^",2)
 . quit:fld=""
 . quit:fld=.01
 . if fld["*" do exception("fdaentry",form,fld,report) quit  ;
 . if fld["+" do exception("fdaentry",form,fld,report) quit  ;
 . if fld=12.4 quit  ; field causes errors... need to fix it
 . if $$getFieldSpec^%wffmap(form,%wi)["D" do  ;
 . . new X,Y
 . . set X=$get(@ary@(%wi))
 . . do ^%DT
 . . set @ary@(%wi)=Y
 . . quit
 . set fda(311.102,"?+1,",fld)=$get(@ary@(%wi))
 . set @report@("processed",%wi)=fld_"^"_"311.102"
 . quit
 ;
 ; zwrite fda
 ;
 do updie^%wffmap(.fda)
 ;
 set %wi=""
 for  set %wi=$order(@ary@(%wi)) quit:%wi=""  do  ;
 . if $data(@report@("processed",%wi)) quit  ;
 . set @report@("notprocessed",%wi)=$$var2field(form,%wi)
 . quit
 ;
 quit  ; end of fileForm
 ;
 ;
 ;
exception(rtn,form,field,report) ; handle exceptions
 ;
 set @report@("notprocessed",field)=$$var2field(form,field)
 ;
 quit  ; end of exception
 ;
 ;
 ;
testFiler ; test driver for the filer
 ;
 new vals
 do getVals^%wf("vals","sbform","XXXX02")
 do fileForm("vals","sbform","XXXX02")
 ;
 quit  ; end of testFiler
 ;
 ;
 ;
var2field(form,var) ; extrinsic returns the fileman file and field number for the var in form form
 ;
 ; format file^field
 ;
 new map
 do getFieldMap^%wffmap("map",form,var)
 new fld,file,rtn
 set fld=$get(map("FILEMAN_FIELD"))
 set file=$get(map("FILEMAN_FILE"))
 set rtn=file_"^"_fld
 ;
 quit rtn ; end of $$var2Field
 ;
 ;
 ;
field2var(form,file,field) ; extrinsic returns the var in form form for the fileman field in file file
 ;
 new root set root=$$setroot^%wd("form-map")
 new groot set groot=$name(@root@("graph",form,"VARIABLE","FIELD"))
 new return set return=""
 if $data(@groot@(field)) set return=$order(@groot@(field,""))
 ;
 quit return ; end of $$field2Var
 ;
 ;
 ;
retrieve(ary,form,file,sid) ; retrieve all form variables from the fileman file for form and studyid (sid)
 ;
 ; ary is passed by name
 ;
 new tary
 new ien set ien=$order(^SAMI(file,"B",sid,""))
 if ien="" quit
 do GETS^DIQ(file,ien_",","**","IE","tary")
 new tary2 set tary2=$name(tary(file,ien_","))
 new %wi set %wi=""
 for  set %wi=$order(@tary2@(%wi)) quit:%wi=""  do  ;
 . new var
 . set var=$$field2var(form,file,%wi)
 . if var="" quit  ;
 . ; write !,"var= ",var," field= ",%wi
 . new usevar
 . if $$getFieldSpec^%wffmap(form,var)["D" set usevar=$get(@tary2@(%wi,"E"))
 . else  set usevar=$get(@tary2@(%wi,"I"))
 . if usevar'="" set @ary@(var)=usevar
 . quit
 ;
 quit  ; end of retrieve
 ;
 ;
 ;
eor ; end of routine %wffiler
