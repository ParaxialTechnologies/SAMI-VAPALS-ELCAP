SAMICLOG ;ven/gpl - intake form change log ;2021-07-01t16:28z
 ;;18.0;SAMI;**12**;2020-01;
 ;;18.12
 ;
 ; Routine SAMICLOG contains subroutines for implementing the VAPALS-
 ; ELCAP Intake Form's Change Log field.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@dev-main George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org-main Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-update 2021-07-01t16:28z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@dev-add Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2019-03-20 ven/gpl 18-t4 e1e7c136
 ;  SAMICLOG progress on intake form change log.
 ;
 ; 2019-03-25/26 ven/lgc 18-t4 12ab8234,b9a71a56,e0106403,fb73dfe5
 ;  SAMICLOG update change log & tests, repair var name, inhibit
 ; change log during 1st entry.
 ;
 ; 2019-08-03 ven/gpl 18-t4 bea65f7b
 ;  SAMICLOG fix bugs in Have you ever smoked processing in change log
 ; & intake note.
 ;
 ; 2021-06-18 ven/gpl 18.12-t2 68ebd6fa
 ;  SAMICLOG fix crash in processing text field for change log: in
 ; DOLOGIT add screens if "field","C",var node undefined.
 ;
 ; 2021-07-01 ven/mcglk&toad 18.12-t2 cbf7e46b
 ;  SAMICLOG bump version & dates, add hdr comments & dev log.
 ;
 ;@contents
 ; CLOG adds to the intake form change log
 ; RUNVARS ???
 ; DOLOGIT ???
 ; LOGIT add an entry to the log
 ; INTKVARS variables on intake form
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
CLOG(sid,form,vars) ; adds to the intake form change log 
 ; if changes have been made
 ;
 n root,CLOGROOT,var
 s root=$$setroot^%wd("vapals-patients")
 ;
 ;If samifirsttime is true, then this is the first submission
 ;  for the intake form and we will not need to check
 ;  for changes
 q:($g(@root@("graph",sid,form,"samifirsttime"))="true")
 ;
 s CLOGROOT=$na(@root@("graph",sid,form,"changelog"))
 ;
 n old
 s old=$na(@root@("graph",sid,form)) ; location of saved old variables
 ;
 ; date of contact
 ;
 n ndoc,odoc
 s ndoc=$g(@vars@("sidc"))
 s odoc=$g(@old@("sidc"))
 if ndoc'=odoc d  ;
 . n entry s entry="Date of contact changed from "_odoc_" to "_ndoc
 . d LOGIT(CLOGROOT,entry)
 ;
 ; contacted via
 ;
 n ovia,nvia,zg
 s (ovia,nvia)=""
 f zg="ovia","nvia" d  ;
 . n zn
 . if zg="ovia" s zn=old
 . if zg="nvia" s zn=vars
 . i $g(@zn@("silnip"))=1 d  ;
 . . s @zg="in person"
 . i $g(@zn@("silnph"))=1 d  ;
 . . s @zg=$s(@zg'="":@zg_",",1:@zg)_" telephone"
 . i $g(@zn@("silnth"))=1 d  ;
 . . s @zg=$s(@zg'="":@zg_",",1:@zg)_" telehealth"
 . i $g(@zn@("silnml"))=1 d  ;
 . . s @zg=$s(@zg'="":@zg_",",1:@zg)_" mailed letter"
 . i $g(@zn@("silnpp"))=1 d  ;
 . . s @zg=$s(@zg'="":@zg_",",1:@zg)_" patient portal"
 . i $g(@zn@("silnvd"))=1 d  ;
 . . s @zg=$s(@zg'="":@zg_",",1:@zg)_" VOD"
 . i $g(@zn@("silnot"))=1 d  ;
 . . s @zg=$s(@zg'="":@zg_",",1:@zg)_" Other contact method YN"
 s ovia=$s(ovia="":"null",1:ovia)
 s nvia=$s(nvia="":"null",1:nvia)
 i ovia'=nvia d  ;
 . d LOGIT(CLOGROOT,"Contacted via changed from "_ovia_" to "_nvia)
 ;
 ;
 ;
RUNVARS n cnt s cnt=0
 f  s cnt=cnt+1 s var=$p($t(INTKVARS+cnt),";;",2) q:(var="")  d
 . s var=$p($p($t(INTKVARS+cnt),";;",2),"^")
 . s entry=$p($p($t(INTKVARS+cnt),";;",2),"^",2)_" changed from "
 . d DOLOGIT(.vars,.old,var,entry)
 q
 ;
 ;
 ;
DOLOGIT(vars,old,var,entry) ;
 ;Input
 ;   vars   = name of array with new results (e.g. poo("sildct")=1)
 ;   old    = $na(@root@("graph",sid,form)) ; location of saved old variables
 ;   var    = name of VAPALS variable whose value changed (e.g. sildct)
 ;   entry  = prompt for entering value (e.g. Patient opted to)
 ;Exit
 ;   sets new "changelog" node in vapals-patients graphstore documenting
 ;
 n rootdd s rootdd=$$setroot^%wd("form fields - intake")
 n newval,oldval,nvtrans,ovtrans
 s newval=$g(@vars@(var)) i '(newval="") d
 . q:'$d(@rootdd@("field","C",var))
 . s nvtrans=$o(@rootdd@("field","C",var,newval,""))
 . s:'(nvtrans="") newval=nvtrans
 s:(newval="") newval="null"
 s oldval=$g(@old@(var)) i '(oldval="") d
 . q:'$d(@rootdd@("field","C",var))
 . s ovtrans=$o(@rootdd@("field","C",var,oldval,""))
 . s:'(ovtrans="") oldval=ovtrans
 s:(oldval="") oldval="null"
 q:(newval=oldval)
 s entry=entry_oldval_" to: "_newval
 d LOGIT(CLOGROOT,entry)
 q
 ;
 ;
 ;
LOGIT(CLOGROOT,ENTRY) ; add an entry to the log
 ; CLOGROOT points to the log
 ;
 n logdt
 ;s logdt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 s logdt=$$FMTE^XLFDT($$NOW^XLFDT,5)
 n lien
 s lien=$o(@CLOGROOT@(""),-1)+1
 s @CLOGROOT@(lien)="["_logdt_"] "_$g(ENTRY)
 q
 ;
 ;
 ;
INTKVARS ; Varibles on intake form
 ;;silnoo^Other contact method
 ;;sipav^Primary address verified
 ;;sipsa^Preferred address
 ;;sipan^Apt#
 ;;spicn^County
 ;;sipc^City
 ;;sips^State
 ;;sipz^Zip
 ;;sipcr^Country
 ;;sippn^Phone number
 ;;sirs^Rural status
 ;;siesm^Have you ever smoked
 ;;siesq^Willing to quit smoking
 ;;sicpd^Cigarettes per day
 ;;sisny^Number of years a smoker
 ;;siq^Date quit smoking
 ;;sicep^Smoking cessation education provided
 ;;siadx^Lung CA Dx date
 ;;siadxl^Lung CA Dx location not VA
 ;;siptct^CT date
 ;;siptctl^CT location not VA
 ;;siidmdc^Informed decision making discussion complete
 ;;sildct^Patient opted to
 ;;siclin^Clinical idications for screening
 ;;sistatus^Enrollment status
 ;;
 ;
 ;
 ;
EOR ; end of routine SAMICLOG
