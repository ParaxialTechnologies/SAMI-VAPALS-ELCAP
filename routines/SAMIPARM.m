SAMIPARM ;ven/gpl - get params web service ;2021-07-01t17:45z
 ;;18.0;SAMI;**12**;2020-01;
 ;;18.12
 ;
 ; Routine SAMIPARM contains subroutines for implementing the VAPALS-
 ; ELCAP get params web service.
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
 ;@copyright 2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-update 2021-07-01t17:45z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2021-05-29/06-05 ven/gpl 18.12-t2 46bab765,223b5900
 ;  SAMIPARM new routine to implement new web service get params,
 ; update for ssn in report, also, matching report; upgrade PARM with
 ; SYS overrides, add systemDemoOnly & systemDemoUseDUZ.
 ;
 ; 2021-07-01 ven/mcglk&toad 18.12-t2 cbf7e46b
 ;  SAMIPARM bump version & dates, add hdr comments & dev log.
 ;
 ;@contents
 ; WSPARAMS web service WSPARAMS^SAMIPARM, site paramters
 ; $$GET1PARM value of one parameter for site
 ; GETARY return parameter array
 ; ADDSVC init to install get params web service
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
WSPARAMS(parmsjson,filter) ; web service that returns the paramters to use
 ; for the site, passed in as fliter("site"), as json
 d  ;
 . n site
 . s site=$g(filter("site"))
 . i site="" s site=$g(filter("siteid"))
 . q:site=""
 . n parms
 . d GETARY(.parms,site)
 . ;s parms("socialSecurityNumber")="Patient ID"
 . ;s parms("socialSecurityNumber.short")="PID"
 . ;s parms("socialSecurityNumber.mask")=""
 . ;s parms("socialSecurityNumber.regex")=""
 . ; and so on
 . ;n parmsjson
 . d ENCODE^%webjson("parms","parmsjson")
 . set HTTPRSP("mime")="application/json"
 q
 ;
 ;
 ;
GET1PARM(PARM,SITE) ; extrinsic returns the vale of PARM for site SITE
 ; both passed by value
 i '$d(SITE) S SITE=""
 n ary
 d GETARY(.ary,SITE)
 ;ZWR ary
 Q:'$D(ary) ""
 q $g(ary(PARM))
 ;
 ;
 ;
GETARY(ARY,SITE) ; return the parameter array ART, passed by reference
 ;
 N SITEIEN S SITEIEN=""
 I SITE'="" S SITEIEN=$O(^SAMI(311.12,"SYM",SITE,""))
 N DEFREC ; default record in SAMI PARAMETER DEFAULT 311.14
 I SITEIEN'="" S DEFREC=$$GET1^DIQ(311.12,SITEIEN_",",.04,"E")
 I $G(DEFREC)="" S DEFREC="VHA"
 M ARY=^SAMI(311.14,"D",DEFREC)
 I SITE'="" M ARY=^SAMI(311.12,"D",SITE)
 Q:'$D(^SAMI(311.14,"D","SYS"))
 M ARY=^SAMI(311.14,"D","SYS")
 Q
 ;
 ;
 ;
ADDSVC() ; add the params webservice to the system
 d addService^%webutils("GET","params","WSPARAMS^SAMIPARM")
 Q
 ;
 ;
 ;
EOR ; end of routine SAMIPARM
