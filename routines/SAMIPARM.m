SAMIPARM ;ven/gpl - get params web service ;2021-11-18t22:30z
 ;;18.0;SAMI;**12,15**;2020-01;
 ;;18-15
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
 ;@last-update 2021-11-18t22:30z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18-15
 ;@release-date 2020-01
 ;@patch-list **12,15**
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
 ; 2021-07-14 ven/toad 18-12-t3 e36d755d
 ;  SAMIPARM bump 12-t2 to 12-t3, log commit ids, date formats
 ;
 ; 2021-08-11 ven/toad 18-12 b16cd38f
 ;  SAMIPARM SAMI 18.12 routines ready to validate
 ;
 ; 2021-10-17 ven/gpl 18-15 b14fcbcf
 ;  SAMIPARM fix the param web service to provide SYS parameters if no site
 ;  is provided
 ;
 ; 2021-10-26 ven/gpl 18-15 d12b1b10
 ;  SAMIPARM parameter detection routine for identifying VA systems
 ;
 ; 2021-10-27 ven/gpl 18-15 a7274e10,a58c42df
 ;  SAMIPARM create SETPARM routine, upgraded SETPARM to add SYS if not there
 ;
 ; 2021-10-29 ven/lmry 18-15 89e3b74c
 ;  SAMIPARM update history and table of contents, bump dates and versions
 ;
 ; 2021-11-04 ven/gpl 18-15 cf282893
 ;  SAMIPARM intercept site=SYS and make it null
 ;
 ; 2021-11-10 ven/gpl 18-15 e97d42ac
 ;  SAMIPARM added SETMAP for setting records in the SAMI FORM MAPPING file
 ;
 ; 2021-11-18 ven/lmry 18-15 
 ;  SAMIPARM bump dates and versions
 ;
 ;
 ;
 ;@contents
 ; WSPARAMS web service WSPARAMS^SAMIPARM, site paramters
 ; $$GET1PARM value of one parameter for site
 ; GETARY return parameter array
 ; GETSYS returns SYS (system) parameters
 ; ISVA sets filter based on parms
 ; SETPARM
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
 . ;q:site=""
 . i site="SYS" s site=""
 . n parms
 . i site="" d  ;
 . . d GETSYS(.parms)
 . e  d GETARY(.parms,site)
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
GETARY(ARY,SITE) ; return the parameter array ARY, passed by reference
 ;
 I $L(SITE)'=3 D  Q  ; poorly formed SITE indicator
 . D GETSYS(.ARY) ; pass back only SYS parameters
 N SITEIEN S SITEIEN=""
 I SITE'="" S SITEIEN=$O(^SAMI(311.12,"SYM",SITE,""))
 N DEFREC ; default record in SAMI PARAMETER DEFAULT 311.14
 I SITEIEN'="" S DEFREC=$$GET1^DIQ(311.12,SITEIEN_",",.04,"E")
 I $G(DEFREC)="" S DEFREC="VHA"
 M ARY=^SAMI(311.14,"D",DEFREC)
 I SITE'="" M ARY=^SAMI(311.12,"D",SITE)
 D GETSYS(.ARY)
 Q
 ;
GETSYS(ARY) ; returns SYS (system) parameters
 Q:'$D(^SAMI(311.14,"D","SYS"))
 M ARY=^SAMI(311.14,"D","SYS")
 Q
 ;
ISVA(filter) ; sets filter based on parms
 ;
 n site s site=$g(filter("siteid"))
 q:site=""
 new ISVA set ISVA=$$GET1PARM^SAMIPARM("veteransAffairsSite",site)
 set filter("veteransAffairsSite")=ISVA
 Q $S(ISVA="false":0,1:1)
 ;
SETPARM(LVL,PNAME,VALUE) ; 
 ;
 N ien,SAMIERR
 S ien=$o(^SAMI(311.14,"B",$G(LVL),"")) ; locate parameter set
 i ien="" d  ;
 . if LVL="SYS" d  ;
 . . n fda
 . . s fda(311.14,"?+1,",.01)="SYS"
 . . d UPDATE^DIE("","fda","","SAMIERR")
 . . i $d(SAMIERR) D ^ZTER
 . . S ien=$o(^SAMI(311.14,"B",$G(LVL),"")) ; locate parameter set
 I ien="" q
 Q:$G(PNAME)=""
 n pien s pien=$o(^SAMI(311.14,ien,1,"B",$G(PNAME),""))
 i pien="" d  ; add the parameter to the set
 . n fda
 . s fda(311.141,"?+1,"_ien_",",.01)=PNAME
 . D UPDATE^DIE("","fda","","SAMIERR")
 . s pien=$o(^SAMI(311.14,ien,1,"B",$G(PNAME),""))
 i pien="" D ^ZTER
 ;
 N FDA
 S FDA(311.141,pien_","_ien_",",.02)=VALUE
 D UPDATE^DIE("","FDA","","SAMIERR")
 I $D(SAMIERR) D ^ZTER
 S ^SAMI(311.14,"D",LVL,PNAME)=VALUE
 Q
 ;
ADDSVC() ; add the params webservice to the system
 d addService^%webutils("GET","params","WSPARAMS^SAMIPARM")
 Q
 ;
SETMAP(MAP,VALUE) ; set an entry in the SAMI FORM MAPPING FILE
 ;
 N FDA,SAMIERR
 S FDA(311.11,"?+1,",.01)=MAP
 D UPDATE^DIE("","FDA","","SAMIERR")
 I $D(SAMIERR) D ^ZTER Q  ;
 N IEN
 S IEN=$O(^SAMI(311.11,"B",MAP,""))
 Q:IEN=""
 K FDA
 S FDA(311.11,IEN_",",2)=VALUE
 D UPDATE^DIE("","FDA","","SAMIERR")
 I $D(SAMIERR) D ^ZTER Q  ;
 ;
 ;
EOR ; end of routine SAMIPARM
