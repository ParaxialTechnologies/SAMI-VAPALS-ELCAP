SAMIDCM2 ;ven/gpl - VAPALS PATIENT IMPORT FROM SIEMANS AI ; 2022-01-18t00:42z
 ;;18.0;SAMI;**16**;2020-01;Build 2
 ;18-16
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
 ;@last-update 2022-01-18t00:42z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18-16
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
 ;
 ;
 ;
 Q
 ;
ADDITEMS(ARY,SID) ; add Image items to the Items array
 ;
 new root set root=$$setroot^%wd("dcm-intake")
 ;
 q:'$d(@root@("studyid",SID)) ; nothing to add
 ;
 n images s images=""
 n ien s ien=""
 f  s ien=$o(@root@("studyid",SID,ien)) q:ien=""  d  ;
 . n studydt s studydt=$g(@root@(ien,"json","StudyDate"))
 . q:studydt=""
 . n siuid s siuid=$g(@root@(ien,"json","StudyInstanceUID"))
 . q:siuid=""
 . q:$d(images(siuid))
 . s images(siuid)=""
 . n key s key="image-"_$e(studydt,1,4)_"-"_$e(studydt,5,6)_"-"_$e(studydt,7,8)
 . n fmdt s fmdt=$$KEY2FM^SAMICASE(key)
 . s @ARY@("sort",fmdt,"image",key,"Image")=siuid
 ;
 Q
 ;
WSSHODOC(RETURN,FILTER)
 ;
 n gn s gn=$na(^TMP("GPLTEST",$J))
 s HTTPRSP("mime")="application/pdf"
 m @gn=^gpl("pdf")
 s RETURN=""
 ;n g2 s g2=""
 ;n zi s zi=""
 ;f  s zi=$o(^gpl("GPLPDF",zi)) q:zi=""  s g2=g2_^gpl("GPLPDF",zi)
 ;s RETURN=$$URLDEC^VPRJRUT(g2)
 s RETURN=gn
 q
 ;
LOADPDF()
 ;
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.csv"
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 S FD="/tmp/"
 S FN="OHIF as Viewer.pdf"
 S GN=$NA(^gpl("GPLPDF",1))
 K @GN
 N OK
 S OK=$$FTG^%ZISH(FD,FN,GN,2)
 Q
 ;
VIEWURL(SITE) ; extrinsic returns the URL to use for the image viewer
 ; for this site
 n url s url="https://viewer.ohif.org/viewer"
 ; 
 ; todo look up the url from the parameter file
 ;
 q url
 ;