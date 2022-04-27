SAMISITE ;ven/gpl&arc - signon & site access ;2022-04-11t18:26z
 ;;18.0;SAMI;**5,12,14,17**;2020-01;Build 11
 ;;18.17
 ;
 ; Routine SAMISITE contains subroutines for implementing the VAPALS-
 ; ELCAP 
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
 ;@dev-main: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org-main: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-update 2022-04-11t18:26z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.14
 ;@release-date 2020-01
 ;@patch-list **5,12,14,17**
 ;
 ;@dev-add: Alexis Carlson (arc)
 ; alexis@vistaexpertise.net
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2020-04-02/05-26 ven/gpl 1.18.0.5+i5 d36b7cad,36607664,521e0bdc,
 ; d018f52e,156be19e,476b2ff4,0a1538ef
 ;  SAMISITE add multitenancy, fix bug in logout, fix sitetitle on 1st
 ; time in, add superuser site selection feature, fix bug in cache.
 ;
 ; 2021-06-05 ven/gpl 18.12-t2 223b5900
 ;  SAMISITE upgrade parameter with system overrides, add
 ; systemDemoOnly & systemDemoUseDUZ parameters.
 ;
 ; 2021-07-01/07 ven/mcglk&toad&gpl 18.12-t2 cbf7e46b,bfeea24b,
 ; 1dd91fea
 ;  SAMISITE bump version & dates, add hdr comments & dev log; in
 ; FINDSITE add missing 0 to quit.
 ;
 ; 2021-09-17 ven/gpl 18.14  1d01f4bd
 ;  SAMISITE accept username and password as alternates to access and 
 ; verify for login
 ;
 ; 2021-10-06 ven/lmry 18.14
 ;  SAMISITE bump version & dates
 ;
 ; 2022-02-14 ven/gpl  2ea7f220,b47a5e01
 ;  add CRLF to site selection list for super users, add crlf for javascript
 ; at the end of the site selection page
 ;
 ; 2022-04-01 ven/gpl 18-17 7620d4ba
 ;  single signon prototype
 ;
 ; 2022-04-04 ven/lmry  18-17 258bc9269,b257e465
 ;  bump versions and dates, fix blank line and blank at end of line for XINDEX
 ;
 ; 2022-04-08 ven/gpl  18-17  c08224b9
 ;  updated single signon code thanks to Artit testing
 ;
 ; 2022-04-11 ven/lmry 18-17
 ;  add to history, bump dates, fix XINDEX blank at end of line
 ; 
 ;
 ;@to-do
 ; Add label comments
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
 ; $$SIGNON signon with access & verify code
 ; SUPER site selection page for super users
 ; UPGRADE init: convert to multi-tenancy
 ; IDUSER Identify the user
 ; STOREDUZ
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
FINDSITE(SAMIRETURN,ARGS) ; extrinsic which returns the site
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
 q 1
 ;
 ;
 ;
USER() ; extrinsic returns the DUZ of the user accessing the system
 ; -1 means user not known
 n rtn s rtn=-1
 s rtn=+$G(DUZ)
 i rtn=0 s rtn=-1
 q rtn
 ;
 ;
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
 ;
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
 ;
 ; 
SITEACTV(SITE) ; Extrinsic which returns 1 if the site is active
 ; otherwise 0
 n rtn s rtn=-1
 n ien s ien=$o(^SAMI(311.12,"B",SITE,""))
 q:ien="" -1
 s rtn=$$GET1^DIQ(311.12,ien_",",.03,"I")
 q rtn
 ;
 ;
 ;
SITENM(SITE) ; Extrinsic which returns the Site name
 ;
 n rtn s rtn=-1
 s rtn=$$GET1^DIQ(4,SITE_",",.01)
 i rtn="" s rtn=-1
 q rtn
 ;
 ;
 ;
SITENM2(SITEID) ; Extrinsic which returns the Site name from the Site Symbol
 ;
 q:SITEID="" -1
 n siteien
 s siteien=$o(^SAMI(311.12,"SYM",SITEID,""))
 n site
 q $$GET1^DIQ(311.12,siteien_",",.01,"E")
 ;
 ;
 ;
LOGIN(RTN,VALS) ; login processing
 ;
 n access,verify
 s access=$g(VALS("access"))
 if access="" s access=$g(VALS("username"))
 s verify=$g(VALS("verify"))
 if verify="" s verify=$g(VALS("password"))
 ;i verify="@demo123" s verify="@demo321"
 ;i verify="@demo123" s verify="$#happy10"
 ;i access="ZZZUSER1" s access="SUPER6"
 ;i access="" d  ;
 ;. s access="PHXNAV1"
 ;. s verify="$#happy6"
 I $$GET1PARM^SAMIPARM("systemDemoOnly")="true" D  Q  ;
 . S DUZ=$$GET1PARM^SAMIPARM("systemDemoUseDUZ")
 . I +DUZ=0 D  ;
 . . S DUZ=$O(^SAMI(311.13,"B",""))
 . s VALS("samiroute")=""
 . s VALS("siteid")=""
 . d WSHOME^SAMIHOM3(.RTN,.VALS)
 n ACVC s ACVC=access_";"_verify
 i $$SIGNON(ACVC) D  Q  ;
 . D STOREDUZ()
 . s VALS("samiroute")=""
 . s VALS("siteid")=""
 . d WSHOME^SAMIHOM3(.RTN,.VALS)
 else  D  Q  ;
 . s VALS("errorMessage")="Invalid login"
 . d RTNERR^SAMIHOM4(.RTN,"vapals:login",.VALS)
 q
 ;
REDIRECT(RTN,ARGS) ; extrinsic which issues redirect if any
 ; returns if redirect exists
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
 ;
 q reyn
 ;
LOGOURL(ARGS) ;extrinsic which returns the logout url, if any
 ; returns the null string if none
 n url s url=""
 I $$GET1PARM^SAMIPARM("testingSingleSignon")="true" d  q url
 . s url="https://vistaexpertise.net/"
 ;
 s url=$$GET1PARM^SAMIPARM("systemLogoutUrl")
 q url
 ;
SETVAURL() ; set the VA logout url
 d SETLURL("https://ssologon.int.iam.va.gov/centrallogin/centrallanding.aspx?appID=VAPALSELCAP&target=https://vac10devpal400.pal.vaec.va.gov/vapals")
 q
 ;
SETLURL(url) ; set the logout redirect url
 D SETPARM^SAMIPARM("SYS","systemLogoutUrl",url)
 q
 ;
SIGNON(ACVC) ; extrinsic returns 1 if signon is successful, else 0
 ; Sign-on
 N IO S IO=$P
 D SETUP^XUSRB() ; Only partition set-up; No single sign-on or CAPRI
 N RTN D VALIDAV^XUSRB(.RTN,$$ENCRYP^XUSRB1(ACVC)) ; sign-on call
 I RTN(0)>0,'RTN(2) Q 1 ; Sign on successful!
 I RTN(0)=0,RTN(2) Q 0  ; Verify Code must be changed NOW!
 I $L(RTN(3)) Q 0  ; Error Message
 ;
 q
 ;
 ;
 ;
SUPER(RTN,FILTER) ; returns site selection page for super users
 ;
 n temp
 d getThis^%wd("temp","blank_no_nav.html")
 q:'$d(temp)
 n cnt s cnt=0
 n zj s zj=0
 f  s zj=$o(temp(zj)) q:temp(zj)["Insert"  q:+zj=0  d  ;
 . n ln s ln=temp(zj)
 . i ln["PAGE NAME" s ln="Site Selection"
 . d LOAD^SAMIFORM(.ln,"","")
 . s cnt=cnt+1
 . s @RTN@(cnt)=ln
 s cnt=cnt+1
 s @RTN@(cnt)="<ul>"
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
 s cnt=cnt+1
 s @RTN@(cnt)="</ul>"
 n zk s zk=zj+1
 f  s zk=$o(temp(zk)) q:+zk=0  d  ;
 . s cnt=cnt+1
 . s @RTN@(cnt)=temp(zk)_$char(13,10)
 q
 ;
 ;
 ;
UPGRADE() ; convert VAPALS system to Multi-tenancy by adding siteid
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
 n cnt s cnt=0
 f  s lien=$o(@lroot@(lien)) q:+lien=0  d  ;
 . q:$g(@lroot@(lien,"siteid"))'=""
 . n nomatch s nomatch=0
 . n dfn s dfn=$g(@lroot@(lien,"dfn"))
 . i dfn="" d  q  ;
 . . D MES^XPDUTL("Error, no dfn found for lien "_lien)
 . s pien=$o(@proot@("dfn",dfn,""))
 . ; make sure the first 3 chars of the studyid matches the site
 . i pien'="" d  q:nomatch
 . . n psite,psid
 . . s psid=$g(@proot@(pien,"sisid"))
 . . i psid="" s nomatch=1 q  ;
 . . i $e(psid,1,3)'=site s nomatch=1 d  q  ;
 . . . d MES^XPDUTL("skipping record - studyid "_psid_" does not match site "_site)
 . ;w !,"lien "_lien_" being set to "_site
 . s cnt=cnt+1
 . s @lroot@(lien,"siteid")=site
 i cnt>0 d  ;
 . d MES^XPDUTL("Multi-tenancy upgrade successful")
 . d MES^XPDUTL(cnt_" patient records set to site "_site)
 q
 ;
IDUSER() ; Identify the user
 n pivroot s pivroot=$$setroot^%wd("piv-credentials")
 n secid s secid=$g(HTTPREQ("header","secid"))
 Q:secid=""
 n secien
 s secien=$o(@pivroot@("secid",secid,""))
 i secien="" d  q  ;
 . s secien=$o(@pivroot@(" "),-1)+1
 . m @pivroot@(secien)=HTTPREQ("header")
 . s @pivroot@("secid",secid,secien)=""
 i $d(@pivroot@(secien,"DUZ")) S DUZ=$g(@pivroot@(secien,"DUZ"))
 q
 ;
STOREDUZ() ;
 Q:'$D(DUZ)
 n pivroot s pivroot=$$setroot^%wd("piv-credentials")
 i '$d(HTTPREQ("header","secid")) D  ;
 . I $$GET1PARM^SAMIPARM("testingSingleSignon")="true" D TESTSETUP
 n logien s logien=$o(@pivroot@("login"," "),-1)+1
 m @pivroot@("login",logien)=HTTPREQ
 n secid s secid=$g(HTTPREQ("header","secid"))
 q:secid=""
 n secien
 s secien=$o(@pivroot@("secid",secid,""))
 q:secien=""
 s @pivroot@(secien,"DUZ")=DUZ
 Q
 ;
TESTSETUP() ; setup test environment
 S HTTPREQ("USER")="CN=VAPALS,USER"
 I $D(K) D  ;
 . S HTTPREQ("header","secid")=$P(K,":",4)
 . S HTTPREQ("header","K")=K
 Q
 ;
 ;
EOR ; end of routine SAMISITE
