SAMIZPH1 ;ven/gpl - VAPALS PATIENT IMPORT FOR PHILIDELPHIA ; 2021-09-27t20:30z
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
WSDCMIN(ARGS,BODY,RESULT,ien)    ; recieve from addpatient
 ;
 s U="^"
 ;S DUZ=1
 ;S DUZ("AG")="V"
 ;S DUZ(2)=500
 ;N USER S USER=$$DUZ^SYNDHP69
 ;
 new json,root,gr,id,return
 set root=$$setroot^%wd("dcm-intake")
 if $get(ien)="" do
 . set ien=$order(@root@(" "),-1)+1
 . set gr=$name(@root@(ien))
 . do decode^%webjson("BODY",gr)
 . kill BODY  ; remove it from symbol table as it is too big
 ;
 ;do indexFhir(ien)
 ;
 set site=$get(ARGS("siteid"))
 if site'="" set @root@("SITE",site,ien)="" ;
 ;
 if $get(ARGS("returngraph"))=1 do  ;
 . merge return("graph")=@root@(ien,"graph")
 set return("status")="ok"
 set return("siteid")=site
 set return("ien")=ien
 ;
 q
 ;
WSDCMQ(return,filter) ; web service which returns dcm json
 n root s root=$$setroot^%wd("dcm-intake")
 n ien s ien=$o(@root@(" "),-1)
 q:ien=""
 n jary,json
 m jary("result",ien)=@root@(ien)
 d encode^%webjson("jary","return")
 q
 ;
WSDCMKIL(return,filter) ; kill all but the first entry in dcm-intake
 ;
 n root s root=$$setroot^%wd("dcm-intake")
 n sid s sid=$g(@root@(1,"sid"))
 i sid="" s sid="XXX0023"
 n atmp m atmp=@root@(1)
 d purgegraph^%wd("dcm-intake")
 s root=$$setroot^%wd("dcm-intake")
 m @root@(1)=atmp
 s @root@("sid",sid,1)=""
 q
 ;
MKSVC() ; create the web services
 ;
 d deleteService^%webutils("POST","dcmin")
 d addService^%webutils("POST","dcmin","WSDCMIN^SAMIDCM1")
 ;
 d deleteService^%webutils("GET","dcmquery")
 d addService^%webutils("GET","dcmquery","WSDCMQ^SAMIDCM1")
 ;
 d deleteService^%webutils("GET","dcmreset")
 d addService^%webutils("GET","dcmreset","WSDCMKIL^SAMIDCM1")
 ;
 Q
 ;