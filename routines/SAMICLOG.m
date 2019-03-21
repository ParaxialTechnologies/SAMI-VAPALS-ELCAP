SAMICLOG ;ven/gpl - SAMI intake form change log routines ; 2/14/19 12:10pm
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
 n root,CLOGROOT
 s root=$$setroot^%wd("vapals-patients")
 s CLOGROOT=$na(@vars@("changelog"))
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
 . . s @zg=$s(@zg'="":@zg_",",1:@zg)_" "_$g(@zn@("silnoo"))
 i ovia'=nvia d  ;
 . d LOGIT(CLOGROOT,"Contacted via changed from "_ovia_" to "_nvia)
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
