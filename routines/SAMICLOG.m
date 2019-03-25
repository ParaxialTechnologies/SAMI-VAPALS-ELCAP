SAMICLOG ;ven/gpl - SAMI intake form change log routines ; 3/25/19 8:51am
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ; 
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
CLOG(sid,form,vars) ; adds to the intake form change log 
 ; if changes have been made
 ;
 n root,CLOGROOT,var
 s root=$$setroot^%wd("vapals-patients")
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
 i ovia'=nvia d  ;
 . d LOGIT(CLOGROOT,"Contacted via changed from "_ovia_" to "_nvia)
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
 n newval,oldval
 s newval=$g(@vars@(var)) i '(newval="") d
 . s nvtrans=$o(@rootdd@("field","C",var,newval,""))
 . s:'(nvtrans="") newval=nvtrans
 s:(newval="") newval="null"
 s oldval=$g(@old@(var)) i '(oldval="") d
 . s ovtrans=$o(@root@("field","C",var,oldval,""))
 . s:'(ovtrans="") oldval=oltrans
 s:(oldval="") oldval="null"
 q:(newval=oldval)
 s entry=entry_oldval_" to: "_newval
 d LOGIT(CLOGROOT,entry)
 q
 ;
LOGIT(CLOGROOT,ENTRY) ; add an entry to the log
 ; CLOGROOT points to the log
 ;
 n logdt
 s logdt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 n lien
 s lien=$o(@CLOGROOT@(""),-1)+1
 s @CLOGROOT@(lien)="["_logdt_"]"_$g(ENTRY)
 q
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
 ;;sies^Have you ever smoked
 ;;siesn^Never smoked
 ;;siesp^Past smoker
 ;;siesc^Current smoker
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
