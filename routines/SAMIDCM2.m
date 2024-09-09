SAMIDCM2 ;ven/gpl - import from siemens ai; 2024-09-09t16:42z
 ;;18.0;SAMI;**18**;2020-01-17;Build 1
 ;mdc-e1;SAMIDCM2-20240909-EcvLn1;SAMI-18-18-b1
 ;mdc-v7;B7818411;SAMI*18.0*18 SEQ #18
 ;
 ; SAMIDCM2 contains services to support importing a patient into
 ; ScreeningPlus from the Siemens AI.
 ;
 quit  ; no entry from top
 ;
 ;@license: see routine SAMIUL
 ;
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;
 ;@routine-credits
 ;
 ;@dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2024, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@update 2024-09-09t16:42z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module import/export - SAMIDCM
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-18
 ;@edition-date 2020-01-17
 ;@patches **18**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;
 ;@module-credits
 ;
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
 ;@project I-ELCAP AIRS Automated Image Reading System
 ; https://www.ielcap-airs.org
 ;@funding 2024, Mt. Sinai Hospital (msh)
 ;@partner-org par
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2024-08-28 ven/gpl 18-18-b1 a2470ae1
 ;  SAMIDCM2 (F2mxHuw B3750990 E3TEKrb)
 ; add rtn w/ADDITEMS,WSSHODOC,LOADPDF,VIEWURL; for 2nd bld, add
 ; viewer to case review + file upload form.
 ;
 ; 2024-09-02 ven/gpl 18-18-b1 c8d135d1
 ;  SAMIDCM2 (F2qWk B3750990 E2j7Bmz)
 ; file upload working: overhaul WSSHODOC.
 ;
 ; 2024-09-09 ven/toad 18-18-b1
 ;  SAMIDCM2 (F??? B7818411 E???)
 ; add hdr + subrtn hdr comments, log, bump version + dates.
 ;
 ;@contents
 ; ADDITEMS add Image items to Items array
 ; WSSHODOC
 ; LOADPDF
 ; $$VIEWURL URL to use for image viewer
 ;
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
 ;
 ;@proc ADDITEMS
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean?;sac?;tests?;port?
 ;@called-by
 ; GETITEMS^SAMICASE
 ;@calls
 ; $$setroot^%wd
 ; $$KEY2FM^SAMICASE
 ;@input
 ; ARY = output array, closed reference
 ; SID = study id
 ;@output
 ; @ARY@("sort",times,"image",keys,"Image") = siuids
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
ADDITEMS(ARY,SID) ; add Image items to Items array
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
 . ;
 . n siuid s siuid=$g(@root@(ien,"json","StudyInstanceUID"))
 . q:siuid=""
 . ;
 . ; add each image item only once to Items array
 . q:$d(images(siuid))
 . s images(siuid)=""
 . ;
 . n key s key="image-"_$e(studydt,1,4)_"-"_$e(studydt,5,6)_"-"_$e(studydt,7,8)
 . n fmdt s fmdt=$$KEY2FM^SAMICASE(key)
 . s @ARY@("sort",fmdt,"image",key,"Image")=siuid
 . q
 ;
 quit  ; end of ADDITEMS
 ;
 ;
 ;
 ;
 ;@dms WSSHODOC
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;dms;procedure;silent;clean?;sac?;tests?;port?
 ;@called-by none
 ;@calls none
 ;@input
 ; FILTER
 ;@output
 ; RETURN = output array, closed reference
 ; @RETURN
 ;@examples [tbd]
 ;@tests [tbd]
 ;
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
 ;
 quit  ; end of dms WSSHODOC
 ;
 ;
 ;
 ;
 ;@dms LOADPDF
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;dms;procedure;silent;clean?;sac?;tests?;port?
 ;@called-by none
 ;@calls
 ; $$FTG^%ZISH
 ;@input [tbd]
 ;@output [tbd]
 ;@examples [tbd]
 ;@tests [tbd]
 ;
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
 ;
 quit  ; end of dms LOADPF
 ;
 ;
 ;
 ;
 ;@function $$VIEWURL
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;silent;clean?;sac?;tests?;port?
 ;@called-by
 ; WSCASE^SAMICASE
 ;@calls none
 ;@input
 ; SITE
 ;@output = url of OHIF image viewer
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
VIEWURL(SITE) ; URL to use for image viewer
 ;
 ; for this site
 ;
 n url s url="https://viewer.ohif.org/viewer"
 ; 
 ; todo look up the url from the parameter file
 ;
 quit url ; end of $$VIEWURL
 ;
 ;
 ;
EOR ; end of routine SAMIDCM2
