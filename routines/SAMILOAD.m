SAMILOAD ;ven/gpl - VAPALS PATIENT IMPORT MAIN ROUTINE ; 2021-09-27t20:30z
 ;;18.0;SAMI;**16**;2020-01;Build 2
 ;18-x-16-t2
 ;
 ;@license: see routine SAMIUL
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
 ;@last-update 2021-09-27t20:30z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18-14-16
 ;@release-date 2020-01
 ;@patch-list **16**
 ;
 ;
 ;@module-credits
 ;@project VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding 2017/2021, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org Paraxial Technologies (par)
 ; http://paraxialtech.com/
 ;@partner-org Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2021-09-20/23 ven/gpl sami-18-14-16-t1
 ; SAMIZPH1 develop method to import data from a REDCap data system used by
 ; the Philadelphia VA.
 ;
 ; 2021-09-27 ven/gpl sami-18-14-16-t1
 ; SAMIZPH1 fix bug where Cache was putting the TSV records in overflow
 ;
 ;
 Q
 ;
SEP() ; extrinsic returns the separator character used
 Q $CHAR(9)
 ;
LOAD ;
 N SITE
 s SITE=$$PICSITE^SAMIMOV()
 Q:SITE="^"
 N FN,GN
 ;S DIR="/tmp/"
  ; prompt for the directory
 N SAMIDIR
 D GETDIR^SAMIFDM(.SAMIDIR)
 Q:SAMIDIR=""
 ;
 do
 . N DIR,X,Y,DA,DIRUT,DTOUT,DUOUT,DIROUT
 . S DIR(0)="F^0:1024"
 . S DIR("A")="Enter filename to load."
 . S DIR("B")="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 . D ^DIR
 . W !
 . if '$data(DIRUT) set FN=Y
 quit:'$data(FN)
 ;
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.csv"
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 S GN=$NA(^TMP("SAMICSV",$J,1))
 K @GN
 N OK
 S OK=$$FTG^%ZISH(SAMIDIR,FN,GN,3)
 D  ;
 . ;
 . ; Normalize overflow nodes (and hope for the best that we don't go over 32k)
 . new i,j set (i,j)=""
 . for  set i=$order(^TMP("SAMICSV",$J,i)) quit:'i  for  set j=$order(^TMP("SAMICSV",$J,i,"OVF",j)) quit:'j  do
 .. set ^TMP("SAMICSV",$J,i)=^TMP("SAMICSV",$J,i)_^TMP("SAMICSV",$J,i,"OVF",j)  ;
 K ^gpl("CSV")
 M ^gpl("CSV")=^TMP("SAMICSV",$J)
 D TOGRAPH(SITE) ; clear the load graph and read first line to key
 D UNWRAP(SITE) ; parse all records into the graph
 D IMPORT(SITE) ; do conversions where necessary and create SAMI patient
 Q
 ;
TOGRAPH(SITE) ;
 N GN S GN=$NA(^TMP("SAMICSV",$J))
 d purgegraph^%wd(SITE_"-INTAKE")
 n root s root=$$setroot^%wd(SITE_"-INTAKE")
 n zi,zl
 ; first row
 f zi=1:1:$l(@GN@(1),$$SEP) d  ;
 . s zl=$p(@GN@(1),$$SEP,zi)
 . s @root@("key",zi,zl)=""
 . s @root@("key","B",zl,zi)=""
 q
 ;
UNWRAP(SITE) ;
 n root s root=$$setroot^%wd(SITE_"-INTAKE")
 n proot s proot=$na(@root@("records"))
 n GN s GN=$NA(^TMP("SAMICSV",$J))
 n key s key=$na(@root@("key"))
 n zi s zi=1
 f  s zi=$o(@GN@(zi)) q:+zi=0  d  ;
 . n zj
 . f zj=1:1:$l(@GN@(zi),$$SEP) d  ;
 . . n zl s zl=$o(@key@(zj,""))
 . . i zl="" s zl="piece"_zj
 . . n data s data=$p(@GN@(zi),$$SEP,zj)
 . . i data["""" s data=$tr(data,"""")
 . . s @proot@(zi,zl)=data
 q
 ;
IMPORT(SITE) ; import from csv stored in SITE-INTAKE graph
 N root,zi,croot,lroot,proot
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 s root=$$setroot^%wd(SITE_"-INTAKE")
 s croot=$na(@root@("records"))
 s zi=""
 f  s zi=$o(@croot@(zi)) q:zi=""  d  ;
 . n onepat,ztbl
 . m onepat=@croot@(zi)
 . s onepat("siteid")=SITE
 . i '$d(onepat("saminame")) d  ;
 . . i $d(onepat("last_name")) d  ;
 . . . d RCAPHACK^SAMIZPH1("ztbl","onepat") ; this is a REDCAP record, convert
 . i '$d(onepat("saminame")) d  q  ; we must at least have a name
 . . w !,SITE," error, name missing. Record=",zi
 . s onepat("site")=SITE
 . i $$DEDUP(.onepat) d  q  ; is this a duplicate? if so, set studyid
 . . w !,"error, duplicate patient. Skipping ",$g(onepat("saminame"))
 . . n siform,sid
 . . s sid=$g(onepat("studyid"))
 . . i sid="" d  b  ;
 . . . w !,"error processing duplicate record "
 . . . d ^ZTER
 . . s siform=$o(@proot@("graph",sid,"si"))
 . . i siform="" d  b  ;
 . . . w !,"error finding siform for sid ",sid
 . . m @proot@("graph",sid,siform)=onepat
 . d CREATE(.onepat)
 Q
 ;
DEDUP(onepat) ; extrinsic which identifies a duplicate patient
 ; if found, returns 1. also sets onepat("studyid")
 n lroot,proot,dfn,lien,pien,sid
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 n inname s inname=$g(onepat("saminame"))
 w !,"inname=",inname
 s lien=""
 n tlien s tlien=""
 f  s tlien=$o(@lroot@("name",inname,tlien)) q:tlien=""  d  ;
 . q:'$d(@lroot@(tlien))
 . q:$g(@lroot@(tlien,"siteid"))'=SITE
 . s lien=tlien
 q:lien="" 0
 w !,"lien=",lien
 i '$d(@lroot@("last5",$g(@lroot@(lien,"last5")))) d  q 0 ;
 . ;w !,"last5 not found"
 i '$d(onepat("dob")) s onepat("dob")=$g(onepat("sbdob"))
 ;zwr @lroot@(lien,*)
 ;n inlast5 s inlast5=$g(onepat("last5"))
 ;w !,"inlast5=",inlast5
 ;n last5 s last5=$o(@lroot@("last5",inlast5,""))
 ;w !,"last5=",last5
 ;q:last5="" 0
 ;q:last5'=lien 0
 s dfn=$g(@lroot@(lien,"dfn"))
 w !,"dfn=",dfn
 ;B
 q:dfn="" 0
 s pien=$o(@proot@("dfn",dfn,""))
 q:pien=""
 s sid=$g(@proot@(pien,"sisid"))
 i sid="" s sid=$g(@proot@(pien,"samistudyid"))
 w !,"sid=",sid
 q:sid="" 0
 s onepat("studyid")=sid
 s onepat("dfn")=dfn
 q 1
 ; 
CREATE(vars) ; create a patient record and an intake form from vars
 ;
 D REGISTER(.vars)
 D ENROLL(.vars)
 q
 ;
REGISTER(vars)
 N saminame
 s saminame=$g(vars("saminame"))
 i saminame="" s saminame=$g(vars("name"))
 i saminame="" d  ;
 . n nxtdfn s nxtdfn=$$nxtdfn^SAMIDCM1()
 . s saminame="DOE"_nxtdfn_",JOHN"
 . s vars("saminame")=saminame
 s vars("name")=saminame
 n varscpy m varscpy=vars
 N SAMIRTN
 D REG^SAMIHOM4(.SAMIRTN,.varscpy)
 m vars=varscpy
 ;s vars("dfn")=$$GETDFN(saminame)
 ;m varscpy=vars
 ;B
 q
 ;
ENROLL(vars) ; 
 n varscpy
 m varscpy=vars
 D WSNEWCAS^SAMIHOM3(.varscpy,.SAMIBDY,.SAMIRESULT)
 ;ZWR varscpy
 n sid,sikey
 s sid=$g(varscpy("studyid"))
 s sikey=$g(varscpy("form"))
 s sikey=$p(sikey,"vapals:",2)
 m vars=varscpy
 ;w !,"sid: ",sid," sikey: ",sikey
 n root s root=$$setroot^%wd("vapals-patients")
 q:sid=""
 q:sikey=""
 m @root@("graph",sid,sikey)=vars
 ;N NUM S NUM=$$GETNUM(saminame)
 ;D MKSIFORM^SAMIHOM3(NUM)
 Q
 ;
FIX() ; look for bad patient records and fix them
 ; doesn't delete unless DELETE=1 is set
 N lroot,zi,proot,pien
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 s zi=0
 f  s zi=$o(@lroot@(zi)) q:+zi=0  d  ;
 . n site,dfn,sid
 . s dfn=$g(@lroot@(zi,"dfn"))
 . if dfn="" d  q  ;
 . . w !,"bad lookup record, no dfn. lien=",zi
 . . q:'$g(DELETE)
 . . k @lroot@(zi)
 . s pien=$o(@proot@("dfn",dfn,""))
 . s site=$g(@lroot@(zi,"siteid"))
 . if site="" d  q  ;
 . . w !,"bad lookup record, no siteid. lien=",zi
 . . q:'$g(DELETE)
 . . k @lroot@(zi)
 . . k @lroot@("dfn",dfn)
 . . zwr @lroot@(zi,*)
 . q:pien=""
 . s sid=$g(@proot@(pien,"samistudyid"))
 . i sid'="" d
 . . i $e(sid,1,3)'[site d  ;
 . . . w !,"error, sid does not match site lien=",zi," site=",site," sid=",sid
 . . . q:'$g(DELETE)
 . . . k @lroot@(zi)
 . . . k @lroot@("dfn",dfn)
 . . . k @proot@(pien)
 . . . k @proot@("dfn",dfn)
 . . . k @proot@("graph",sid)
 q
 ;