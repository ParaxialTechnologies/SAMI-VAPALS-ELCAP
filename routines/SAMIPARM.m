SAMIPARM ;ven/gpl - vapals/elcap parameter service ;2021-03-21T23:51Z
 ;;18.0;SAMI;**10**;2020-01;Build 11
 ;
 Q
 ;
WSPARAMS(parmsjson,filter) ; web service that returns the paramters to use
 ; for the site, passed in as fliter("site"), as json
 d  ;
 . n parms
 . s parms("ssn")="Patient ID"
 . s parms("ssn.short")="PID"
 . s parms("ssn.mask")=""
 . s parms("ssn.regex")=""
 . ; and so on
 . ;n parmsjson
 . d ENCODE^%webjson("parms","parmsjson")
 . set HTTPRSP("mime")="application/json"
 q
 ;
ADDSVC() ; add the params webservice to the system
 d addService^%webutils("GET","params","WSPARAMS^SAMIPARM")
 Q
 ;