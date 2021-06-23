SAMIPARM ;ven/gpl - vapals/elcap parameter service ;2021-03-21T23:51Z
 ;;18.0;SAMI;**10**;2020-01;Build 11
 ;
 Q
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
GET1PARM(PARM,SITE) ; extrinsic returns the vale of PARM for site SITE
 ; both passed by value
 i '$d(SITE) S SITE=""
 n ary
 d GETARY(.ary,SITE)
 ;ZWR ary
 Q:'$D(ary) ""
 q $g(ary(PARM))
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
ADDSVC() ; add the params webservice to the system
 d addService^%webutils("GET","params","WSPARAMS^SAMIPARM")
 Q
 ;