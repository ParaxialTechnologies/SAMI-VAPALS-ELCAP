SAMISITE ;ven/gpl,arc - ielcap: forms;2020-03-27T17:45Z ;Mar 27, 2020@16:04
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: George P. Lilly (gpl)
 ;  gpl@vistaexpertise.net
 ; @additional-dev: Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;   Add label comments
 ;
 ; @section 1 code
 ;
 quit  ; No entry from top
 ;
FINDSITE(SAMIRETURN,ARGS) ; extrinsic which returns the site
 ; to be used by this user: ARGS("siteid")=siteid and
 ; ARGS("sitetitle")=sitename - siteid
 ; 1 for success 
 ; 0 for fail - exit; page to be displayed is in SAMIRETURN
 ;
 ;d ^ZTER
 n user
 s user=$$USER()
 i user=-1 d  q 0
 . s ARGS("errorMessage")="Error, user not found"
 . d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 ;d  q 0
 ;. s ARGS("errorMessage")="User is found: "_user
 ;. d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 n site,siteid,siteactv,sitenm
 ;
 s site=$$SITE(user)
 i site<1 s site=-1
 i site=-1 d  q 0
 . s ARGS("errorMessage")="Site not found for user "_user
 . d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 s siteid=$$SITEID(site)
 i siteid=-1 d  q 0
 . s ARGS("errorMessage")="Site ID not found for site "_site
 . d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 s siteactv=$$SITEACTV(site)
 i siteactv<1 d  q 0
 . s ARGS("errorMessage")="Site not active: "_siteid
 . d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 s sitenm=$$SITENM(site)
 i sitenm=-1 d  q 0
 . s ARGS("errorMessage")="Site name not found: "_siteid
 . d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 s ARGS("siteid")=siteid
 s ARGS("sitetitle")=$$SITENM(site)_" - "_siteid
 q 1
 ;
USER() ; extrinsic returns the DUZ of the user accessing the system
 ; -1 means user not known
 n rtn s rtn=-1
 s rtn=$G(DUZ)
 i rtn=0 s rtn=-1
 q rtn
 ;
SITE(USER) ; extrinsic returns the pointer to the Institution file
 ; which is the site of the user
 ; -1 means site not found
 ; zero means site not active
 n rtn
 s rtn=$o(^VA(200,USER,2,0))
 i +rtn="" s rtn=-1
 q rtn
 ;
SITEID(SITE) ; extrinsic returns the Site Symbol for SITE
 ; this is found in the SAMI SITE file
 ; null means SITEID not found
 n rtn s rtn=-1
 n ien s ien=$o(^SAMI(311.12,"B",SITE,""))
 q:ien="" -1
 s rtn=$$GET1^DIQ(311.12,ien_",",.02)
 q rtn
 ; 
SITEACTV(SITE) ; Extrinsic which returns 1 if the site is active
 ; otherwise 0
 n rtn s rtn=-1
 n ien s ien=$o(^SAMI(311.12,"B",SITE,""))
 q:ien="" -1
 s rtn=$$GET1^DIQ(311.12,ien_",",.03,"I")
 q rtn 
 ;
SITENM(SITE) ; Extrinsic which returns the Site name
 ;
 n rtn s rtn=-1
 s rtn=$$GET1^DIQ(4,SITE_",",.01)
 i rtn="" s rtn=-1
 q rtn
 ;
SITENM2(SITEID) ; Extrinsic which returns the Site name from the Site Symbol
 ;
 q:SITEID="" -1
 n siteien
 s siteien=$o(^SAMI(311.12,"SYM",SITEID,""))
 n site
 q $$GET1^DIQ(311.12,siteien_",",.01,"E") 
 ;
