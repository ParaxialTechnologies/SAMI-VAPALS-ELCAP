%sfv2g	;ven/gpl-dataset format: vista to graph ;2018-02-11T14:06Z
 ;;1.8;Mash;
 ;
 ; %sfv2g implements the Dataset Format Library's apis for converting
 ; data from vista format to graphstore format.
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
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-11T14:06Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Dataset Format - %sf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@module-credits
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017, gpl
 ;@funding: 2017, ven
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log
 ; 2017-09-24 ven/gpl %*1.8t04 %sfv2g: create routine w/$$fmrec & fmx.
 ;
 ; 2018-02-05/11 ven/toad %*1.8t04 %sfv2g: passim hdr comments, spell out
 ; mumps language elements, add do-dot quits & white space, license &
 ; attribution.
 ;
 ;@to-do
 ; convert entry points to ppi/api style & put in %sf
 ; r/all local calls w/calls through ^%sf
 ; change branches from %sf
 ;
 ;@contents
 ; $$fmrec = extrinsic which returns the json version of the fmx return
 ; fmx: return an array of a fileman record for external
 ;
 ;
 ;
 ;@section 1 fmrec & fmx apis
 ;
 ;
 ;
fmrec(file,ien) ; extrinsic which returns the json version of the fmx return
 ;
 new %g,%gj
 do fmx("%g",file,ien)
 do ENCODE^VPRJSON("%g","%gj")
 ;
 quit %gj ; end of $$fmrec
 ;
 ;
 ;
fmx(rtn,file,ien,camel) ; return an array of a fileman record for external
 ;
 ; use in rtn, which is passed by name. 
 ;
 kill @rtn
 new trec,filenm
 do GETS^DIQ(file,ien_",","**","ENR","trec")
 set filenm=$order(^DD(file,0,"NM",""))
 set filenm=$translate(filenm," ","_")
 ; zwrite trec
 if $get(debug)=1 break
 new % set %=$query(trec(""))
 for  do  quit:%=""  ;
 . new fnum,fname,iens,field,val
 . set fnum=$qsubscript(%,1)
 . if $data(^DD(fnum,0,"NM")) do  ;
 . . set fname=$order(^DD(fnum,0,"NM",""))
 . . set fname=$translate(fname," ","_")
 . . quit
 . else  set fname=fnum
 . set iens=$qsubscript(%,2)
 . set field=$qsubscript(%,3)
 . set field=$translate(field," ","_")
 . set val=@%
 . if fnum=file do  ; not a subfile
 . . set @rtn@(fname,ien,field)=val
 . . set @rtn@(fname,"ien")=$piece(iens,",",1)
 . . quit
 . else  do  ;
 . . new i2 set i2=$order(@rtn@(fname,""),-1)+1
 . . set @rtn@(fname,$piece(iens,","),field)=val
 . . ; set @rtn@(fname,i2,field)=val
 . . ; set @rtn@(fname,i2,"iens")=iens
 . . quit
 . write:$get(debug)=1 !,%,"=",@%
 . set %=$query(@%)
 . quit
 ;
 quit  ; end of fmx
 ;
 ;
 ;
 ;example
 ;g("bsts_concept","codeset")=36
 ;g("bsts_concept","concept_id")=370206005
 ;g("bsts_concept","counter")=75
 ;g("bsts_concept","dts_id")=370206
 ;g("bsts_concept","fully_specified_name")="asthma limits walking on the flat (finding)"
 ;g("bsts_concept","last_modified")="may 11, 2015"
 ;g("bsts_concept","out_of_date")="no"
 ;g("bsts_concept","partial_entry")="non-patial (full entry)"
 ;g("bsts_concept","revision_in")="mar 01, 2012"
 ;g("bsts_concept","revision_out")="jan 01, 2050"
 ;g("bsts_concept","version")=20140901
 ;g("bsts_concept","ien")="75"
 ;g("is_a_relationship",1,"is_a_relationship")=2
 ;g("subsets",1,"subsets")="ehr ipl asthma dxs"
 ;g("subsets",2,"subsets")="srch cardiology"
 ;g("subsets",3,"subsets")="ihs problem list"
 ;
 ;
 ;
eor ; end of routine %sfv2g
