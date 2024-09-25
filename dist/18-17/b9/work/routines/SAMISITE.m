SAMISITE ;ven/gpl - site signon & security; 2024-08-22t21:17z
 ;;18.0;SAMI;**5,12,14,17**;2020-01-17;Build 8
 ;mdc-e1;SAMISITE-20240822-E3+ep6+;SAMI-18-17-b9
 ;mdc-v7;B212460993;SAMI*18.0*17 SEQ #17
 ;
 ; Routine SAMISITE contains subroutines for implementing the
 ; ScreeningPlus site signon and security.
 ;
 quit  ; no entry from top
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
 ;@dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2024, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@update 2024-08-22t21:17z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module Site - SAMISI
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-17
 ;@edition-date 2020-01-17
 ;@patches **5,12,14,17**
 ;
 ;@dev-add Alexis Carlson (arc)
 ; alexis@vistaexpertise.net
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
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
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2020-04-02/05-26 ven/gpl 18-5 d36b7cad,36607664,521e0bdc,
 ; d018f52e,156be19e,476b2ff4,0a1538ef
 ;  SAMISITE add multitenancy, fix bug in logout, fix sitetitle on 1st
 ; time in, add superuser site selection feature, fix bug in cache.
 ;
 ; 2021-06-05 ven/gpl 18-12-t2 223b5900
 ;  SAMISITE upgrade parameter w/system overrides, add systemDemoOnly
 ; & systemDemoUseDUZ parameters.
 ;
 ; 2021-07-01/07 ven/mcglk&toad&gpl 18-12-t2 cbf7e46b,bfeea24b,
 ; 1dd91fea
 ;  SAMISITE bump version & dates, add hdr comments & dev log; in
 ; FINDSITE add missing 0 to quit.
 ;
 ; 2021-09-17 ven/gpl 18-14  1d01f4bd
 ;  SAMISITE accept username & password as alternates to access &
 ; verify for login.
 ;
 ; 2021-10-06 ven/lmry 18.14
 ;  SAMISITE bump version & dates.
 ;
 ; 2022-02-14 ven/gpl 18-17 2ea7f220,b47a5e01
 ;  SAMISITE add CRLF to site selection list for super users, add crlf
 ; for javascript at end of site selection page.
 ;
 ; 2022-04-01 ven/gpl 18-17 7620d4ba
 ;  SAMISITE single signon prototype.
 ;
 ; 2022-04-04 ven/lmry 18-17 258bc9269,b257e465
 ;  SAMISITE bump versions and dates, fix blank line & blank at end of
 ; line for XINDEX.
 ;
 ; 2022-04-08 ven/gpl 18-17 c08224b9
 ;  SAMISITE updated single signon code thanks to Artit testing.
 ;
 ; 2022-04-11 ven/lmry 18-17 3bf9c56f
 ;  SAMISITE add to history, bump dates, fix XINDEX blank at end of
 ; line.
 ;
 ; 2022-04-26 ven/gpl 18-17 89497ba8,3f6b6117
 ;  SAMISITE logout redirection.
 ;
 ; 2022-04-27 ven/lmry 18-17
 ;  SAMISITE update history & date.
 ;
 ; 2024-08-17 ven/lmry 18-17-b6
 ;  SAMISITE update history & date.
 ;
 ; 2024-08-22 ven/toad 18-17-b6
 ;  SAMISITE update history, version-control lines, hdr comments.
 ;
 ;
 ;@to-do
 ; add label comments
 ;
 ;@contents
 ; $$FINDSITE current site for user
 ; $$USER ien of user accessing system
 ; $$SITE ien of institution file entry for user's site
 ; $$SITEID symbol for site
 ; $$SITEACTV is site active?
 ; $$SITENM site name from ien
 ; $$SITENM2 site name from symbol
 ; LOGIN login processing
 ; REDIRECT extrinsic which issues redirect if any
 ; LOGOURL extrinsic which returns the logout url, if any
 ; SETLURL set the logout redirect url
 ; $$SIGNON signon with access & verify code
 ; SUPER site selection page for super users
 ; UPGRADE init: convert to multi-tenancy
 ; IDUSER Identify the user
 ; STOREDUZ
 ; TESTSETUP setup test environment
 ;
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
 ;
FINDSITE(SAMIRETURN,ARGS) ; extrinsic which returns the site
 ;
 ; to be used by this user: ARGS("siteid")=siteid and
 ; ARGS("sitetitle")=sitename - siteid
 ; 1 for success 
 ; 0 for fail - exit; page to be displayed is in SAMIRETURN
 ;
 ;d ^ZTER
 I $$GET1PARM^SAMIPARM("testingSingleSignon")="true" D TESTSETUP()
 D IDUSER()
 n user
 s user=$$USER()
 i user=-1 d  q 0
 . n vals
 . s vals("siteid")=""
 . s vals("sitetitle")="Unknown Site"
 . s vals("errorMessage")=""
 . d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:login",.vals)
 . ;s ARGS("errorMessage")="Error, user not found"
 . ;d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 ;d  q 0
 ;. s ARGS("errorMessage")="User is found: "_user
 ;. d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:syserror",.ARGS)
 ;
 n site,siteid,siteactv,sitenm
 ;
 i $o(^SAMI(311.13,"B",user,""))'="" d  q 0 ; superuser
 . d SUPER("SAMIRETURN",.ARGS)
 . s HTTPRSP("mime")="text/html"
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
 ;
 quit 1 ; end of $$FINDSITE
 ;
 ;
 ;
 ;
USER() ; extrinsic returns the DUZ of the user accessing the system
 ;
 ; -1 means user not known
 ;
 n rtn s rtn=-1
 s rtn=+$G(DUZ)
 i rtn=0 s rtn=-1
 ;
 quit rtn ; end of $$USER
 ;
 ;
 ;
 ;
SITE(USER) ; extrinsic returns the pointer to the Institution file
 ;
 ; which is the site of the user
 ; -1 means site not found
 ; zero means site not active
 ;
 n rtn
 s rtn=$o(^VA(200,USER,2,0))
 i +rtn="" s rtn=-1
 ;
 quit rtn ; end of $$SITE
 ;
 ;
 ;
 ;
SITEID(SITE) ; extrinsic returns Site Symbol for SITE
 ;
 ; this is found in the SAMI SITE file
 ; null means SITEID not found
 ;
 n rtn s rtn=-1
 n ien s ien=$o(^SAMI(311.12,"B",SITE,""))
 q:ien="" -1
 s rtn=$$GET1^DIQ(311.12,ien_",",.02)
 ;
 quit rtn ; end of $$SITEID
 ;
 ;
 ;
 ; 
SITEACTV(SITE) ; extrinsic returns 1 if site is active
 ;
 ; otherwise 0
 ;
 n rtn s rtn=-1
 n ien s ien=$o(^SAMI(311.12,"B",SITE,""))
 q:ien="" -1
 s rtn=$$GET1^DIQ(311.12,ien_",",.03,"I")
 ;
 quit rtn ; end of $$SITEACTV
 ;
 ;
 ;
 ;
SITENM(SITE) ; extrinsic returns site name
 ;
 n rtn s rtn=-1
 s rtn=$$GET1^DIQ(4,SITE_",",.01)
 i rtn="" s rtn=-1
 ;
 quit rtn ; end of $$SITENM
 ;
 ;
 ;
 ;
SITENM2(SITEID) ; extrinsic returns site name from Site Symbol
 ;
 q:SITEID="" -1
 n siteien
 s siteien=$o(^SAMI(311.12,"SYM",SITEID,""))
 n site
 ;
 quit $$GET1^DIQ(311.12,siteien_",",.01,"E") ; end of $$SITENM2
 ;
 ;
 ;
 ;
LOGIN(RTN,VALS) ; login processing
 ;
 n access s access=$g(VALS("access"))
 if access="" s access=$g(VALS("username"))
 ;
 n verify s verify=$g(VALS("verify"))
 if verify="" s verify=$g(VALS("password"))
 ;i verify="@demo123" s verify="@demo321"
 ;i verify="@demo123" s verify="$#happy10"
 ;i access="ZZZUSER1" s access="SUPER6"
 ;i access="" d  ;
 ;. s access="PHXNAV1"
 ;. s verify="$#happy6"
 ;
 I $$GET1PARM^SAMIPARM("systemDemoOnly")="true" D  Q  ;
 . S DUZ=$$GET1PARM^SAMIPARM("systemDemoUseDUZ")
 . I +DUZ=0 D  ;
 . . S DUZ=$O(^SAMI(311.13,"B",""))
 . . q
 . s VALS("samiroute")=""
 . s VALS("siteid")=""
 . d WSHOME^SAMIHOM3(.RTN,.VALS)
 . q
 ;
 n ACVC s ACVC=access_";"_verify
 ;
 i $$SIGNON(ACVC) D  Q  ;
 . D STOREDUZ()
 . s VALS("samiroute")=""
 . s VALS("siteid")=""
 . d WSHOME^SAMIHOM3(.RTN,.VALS)
 . q
 ;
 else  D  Q  ;
 . s VALS("errorMessage")="Invalid login"
 . d RTNERR^SAMIHOM4(.RTN,"vapals:login",.VALS)
 . q
 ;
 quit  ; end of LOGIN
 ;
 ;
 ;
 ;
REDIRECT(RTN,ARGS) ; extrinsic which issues redirect if any
 ;
 ; returns if redirect exists
 ;
 n reyn s reyn=0 ; default to no redirect
 ;
 n url
 s url=$$LOGOURL(.ARGS)
 i url'="" d  ;
 . s reyn=1
 . s RTN(1)="<html><head>"
 . s RTN(2)="<meta http-equiv=""refresh"" content=""0; url="_url_"""/>"
 . s RTN(3)="</head><body><p></p></body></html>"
 . s HTTPRSP("mime")="text/html"
 . q
 ;
 quit reyn ; end of $$REDIRECT
 ;
 ;
 ;
 ;
LOGOURL(ARGS) ;extrinsic which returns the logout url, if any
 ;
 ; returns the null string if none
 ;
 n url s url=""
 I $$GET1PARM^SAMIPARM("testingSingleSignon")="true" d  q url
 . s url="https://vistaexpertise.net/"
 . q
 ;
 s url=$$GET1PARM^SAMIPARM("systemLogoutUrl")
 ;
 quit url ; end of $$LOGOURL
 ;
 ;
 ;
 ;
SETLURL(url) ; set the logout redirect url
 ;
 D SETPARM^SAMIPARM("SYS","systemLogoutUrl",url)
 ;
 quit  ; end of SETLURL
 ;
 ;
 ;
 ;
SIGNON(ACVC) ; extrinsic returns 1 if signon is successful, else 0
 ;
 ; Sign-on
 ;
 N IO S IO=$P
 D SETUP^XUSRB() ; Only partition set-up; No single sign-on or CAPRI
 N RTN D VALIDAV^XUSRB(.RTN,$$ENCRYP^XUSRB1(ACVC)) ; sign-on call
 I RTN(0)>0,'RTN(2) Q 1 ; Sign on successful!
 I RTN(0)=0,RTN(2) Q 0  ; Verify Code must be changed NOW!
 I $L(RTN(3)) Q 0  ; Error Message
 ;
 quit  ; end of SIGNON
 ;
 ;
 ;
 ;
SUPER(RTN,FILTER) ; returns site selection page for super users
 ;
 n temp
 d getThis^%wd("temp","blank_no_nav.html")
 q:'$d(temp)
 n cnt s cnt=0
 ;
 n zj s zj=0
 f  s zj=$o(temp(zj)) q:temp(zj)["Insert"  q:+zj=0  d  ;
 . n ln s ln=temp(zj)
 . i ln["PAGE NAME" s ln="Site Selection"
 . d LOAD^SAMIFORM(.ln,"","")
 . s cnt=cnt+1
 . s @RTN@(cnt)=ln
 s cnt=cnt+1
 s @RTN@(cnt)="<ul>"
 ;
 n gn s gn=$na(^SAMI(311.12,"B"))
 n zi s zi=0
 f  s zi=$o(@gn@(zi)) q:+zi=0  d  ;
 . n zien s zien=$o(@gn@(zi,""))
 . n active
 . s active=$$GET1^DIQ(311.12,zien_",",.03,"I")
 . q:active=0
 . n name
 . s name=$$SITENM(zi)_" - "_$$SITEID(zi)
 . n link
 . s link="<li>"
 . s link=link_"<a class=""navigation"" data-method=""post"""
 . s link=link_" data-samiroute=""home"" data-siteid="""_$$SITEID(zi)_""""
 . ;s link=link_" data-site="""_$$SITEID(zi)_""""
 . ;s link=link_" href=""#!"">"_$$SITENM(zi)_" - "_$$SITEID(zi)
 . s link=link_" href=""/vapals"">"_name
 . s link=link_"</a></li>"_$char(13,10)
 . ;n link
 . ;s link="<form method=POST action=""/vapals"">"
 . ;s link=link_"<input type=hidden name=""samiroute"" value=""home"">"
 . ;s link=link_"<input type=hidden name=""siteid"" value="""_$$SITEID(zi)_""">"
 . ;s link=link_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 . s cnt=cnt+1
 . s @RTN@(cnt)=link
 . q
 ;
 s cnt=cnt+1
 s @RTN@(cnt)="</ul>"
 n zk s zk=zj+1
 f  s zk=$o(temp(zk)) q:+zk=0  d  ;
 . s cnt=cnt+1
 . s @RTN@(cnt)=temp(zk)_$char(13,10)
 . q
 ;
 quit  ; end of SUPER
 ;
 ;
 ;
 ;
UPGRADE() ; convert VAPALS system to Multi-tenancy by adding siteid
 ;
 ; to all existing patients - runs one time as the Post Install 
 ; to the installation
 ;
 n lroot,proot,lien,pien
 s (lien,pien)=0
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 n site
 s site=$$GET^XPAR("SYS","SAMI SID PREFIX",,"Q")
 i site="" d  q  ;
 . D MES^XPDUTL("No default site returned by SAMI SID PREFIX parameter, exiting")
 . q
 ;
 n cnt s cnt=0
 f  s lien=$o(@lroot@(lien)) q:+lien=0  d  ;
 . q:$g(@lroot@(lien,"siteid"))'=""
 . n nomatch s nomatch=0
 . n dfn s dfn=$g(@lroot@(lien,"dfn"))
 . i dfn="" d  q  ;
 . . D MES^XPDUTL("Error, no dfn found for lien "_lien)
 . . q
 . s pien=$o(@proot@("dfn",dfn,""))
 . ; make sure the first 3 chars of the studyid matches the site
 . i pien'="" d  q:nomatch
 . . n psite,psid
 . . s psid=$g(@proot@(pien,"sisid"))
 . . i psid="" s nomatch=1 q  ;
 . . i $e(psid,1,3)'=site s nomatch=1 d  q  ;
 . . . d MES^XPDUTL("skipping record - studyid "_psid_" does not match site "_site)
 . . . q
 . . q
 . ;w !,"lien "_lien_" being set to "_site
 . s cnt=cnt+1
 . s @lroot@(lien,"siteid")=site
 . q
 ;
 i cnt>0 d  ;
 . d MES^XPDUTL("Multi-tenancy upgrade successful")
 . d MES^XPDUTL(cnt_" patient records set to site "_site)
 . q
 ;
 quit  ; end of UPGRADE
 ;
 ;
 ;
 ;
IDUSER() ; identify user
 ;
 n pivroot s pivroot=$$setroot^%wd("piv-credentials")
 n secid s secid=$g(HTTPREQ("header","secid"))
 Q:secid=""
 n secien
 s secien=$o(@pivroot@("secid",secid,""))
 i secien="" d  q  ;
 . s secien=$o(@pivroot@(" "),-1)+1
 . m @pivroot@(secien)=HTTPREQ("header")
 . s @pivroot@("secid",secid,secien)=""
 . q
 i $d(@pivroot@(secien,"DUZ")) S DUZ=$g(@pivroot@(secien,"DUZ"))
 ;
 quit  ; end of IDUSER
 ;
 ;
 ;
 ;
STOREDUZ() ;
 ;
 Q:'$D(DUZ)
 n pivroot s pivroot=$$setroot^%wd("piv-credentials")
 i '$d(HTTPREQ("header","secid")) D  ;
 . I $$GET1PARM^SAMIPARM("testingSingleSignon")="true" D TESTSETUP
 . q
 n logien s logien=$o(@pivroot@("login"," "),-1)+1
 m @pivroot@("login",logien)=HTTPREQ
 n secid s secid=$g(HTTPREQ("header","secid"))
 q:secid=""
 n secien
 s secien=$o(@pivroot@("secid",secid,""))
 q:secien=""
 s @pivroot@(secien,"DUZ")=DUZ
 ;
 quit  ; end of STOREDUZ
 ;
 ;
 ;
 ;
TESTSETUP() ; setup test environment
 ;
 S HTTPREQ("USER")="CN=VAPALS,USER"
 I $D(K) D  ;
 . S HTTPREQ("header","secid")=$P(K,":",4)
 . S HTTPREQ("header","K")=K
 ;
 quit  ; end of TESTSETUP
 ;
 ;
 ;
EOR ; end of routine SAMISITE