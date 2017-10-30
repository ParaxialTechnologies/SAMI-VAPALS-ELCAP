%wffiler	;ven/gpl - mash forms utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
 ; All the public entry points for forms are in %wf
 ;
fileForm(ary,form,sid) ; ary is the input data, which has been validated
 ; ary is passed by name
 ; form is the form identifier which must be found in the form mapping file
 ; id should be the key of the targeted fileman file, for example studyid for
 ; the SAMI background file.
 ;
 ;  We must make a choice whether to process the file looking for fields for
 ;  which we have data or to process the data first, then looking for the 
 ;  fileman fields to update. We have chosen the latter so that forms can be
 ;  made which cover only a portion of the fields in a file, and will process
 ;  more quickly than with the former approach.  gpl
 ;
 ;
 new fda,fdaentry
 s fda(311.102,"?+1,",.01)=sid
 new %wi set %wi=""
 ;zwr @ary
 for  s %wi=$order(@ary@(%wi)) quit:%wi=""  d  ;
 . new fln,fld,combo
 . set combo=$$var2field(form,%wi)
 . ;w !,combo
 . set fln=$piece(combo,"^",1)
 . quit:fln'["SAMI BACKGROUND"
 . set fld=$piece(combo,"^",2)
 . quit:fld=""
 . quit:fld=.01
 . if fld["*" do exception("fdaentry",form,fld) quit  ;
 . if fld["+" do exception("fdaentry",form,fld) quit  ;
 . if fld=12.4 quit  ; field causes errors... need to fix it
 . if $$getFieldSpec^%wffmap(form,%wi)["D" do  ;
 . . new X,Y
 . . S X=$get(@ary@(%wi))
 . . D ^%DT
 . . set @ary@(%wi)=Y
 . set fda(311.102,"?+1,",fld)=$get(@ary@(%wi))
 ;zwr fda
 d updie^%wffmap(.fda)
 quit
 ;
exception(rtn,form,field) ; handle exceptions
 quit
 ;
testFiler ; test driver for the filer
 n vals
 d getVals^%wfhform("vals","sbform","XXXX02")
 d fileForm("vals","sbform","XXXX02")
 q
 ;
var2field(form,var) ; extrinsic returns the fileman file and field number for the var in form form
 ; format file^field
 new map
 d getFieldMap^%wffmap("map",form,var)
 new fld,file,rtn
 set fld=$get(map("FILEMAN_FIELD"))
 set file=$get(map("FILEMAN_FILE"))
 s rtn=file_"^"_fld
 q rtn
 ;
field2var(form,file,field) ; extrinsic returns the var in form form for the fileman field in file file
 new root set root=$$setroot^%wd("form-map")
 new groot set groot=$name(@root@("graph",form,"VARIABLE","FIELD"))
 new return set return=""
 if $data(@groot@(field)) set return=$order(@groot@(field,"")) 
 quit return
 ;
retrieve(ary,form,file,sid) ; retrieve all form variables from the fileman file for form and studyid (sid)
 ; ary is passed by name
 new tary
 new ien set ien=$order(^SAMI(file,"B",sid,""))
 if ien="" quit
 d GETS^DIQ(file,ien_",","**","IE","tary")
 new tary2 set tary2=$name(tary(file,ien_","))
 new %wi set %wi=""
 for  set %wi=$order(@tary2@(%wi)) quit:%wi=""  do  ;
 . new var
 . set var=$$field2var(form,file,%wi)
 . if var="" quit  ;
 . ;w !,"var= ",var," field= ",%wi
 . new usevar
 . if $$getFieldSpec^%wffmap(form,var)["D" set usevar=$get(@tary2@(%wi,"E"))
 . else  set usevar=$get(@tary2@(%wi,"I"))
 . if usevar'="" set @ary@(var)=usevar
 quit
 ;
