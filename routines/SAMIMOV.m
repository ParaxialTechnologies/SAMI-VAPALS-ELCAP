SAMIMOV ;ven/gpl - VAPALS CHANGE PATIENT SITE ; 2022-03-24t21:13z
 ;;18.0;SAMI;**7,15,16**;;Build 2
 ;;18-16
 ;
 ;@license: see routine SAMIUL
 ;
 ; allow fallthrough
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
 ;@last-update 2022-03-24t21:13z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.15
 ;@release-date 2020-01
 ;@patch-list **7,15**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2020-08-24 ven/gpl 18-7 915b85e6
 ;  SAMIMOV create utility to change patient site
 ; 2020-09-03 ven/gpl 5ae08772
 ;  SAMIMOV upgrade CHANGE SITE to handle patients without forms ... also
 ;  AUDIT report
 ; 2020-09-07 ven/gpl 498e57d5
 ;  SAMIMOV tweeking the audit report
 ; 2020-12-11 ven/gpl 92138cdb
 ; 2021-10-26 ven/gpl 18-15 d12b1b10
 ;  SAMIMOV parameter detection routine for identifying VA systems
 ; 2021-10-29 ven/lmry 18-15
 ;  SAMIMOV insert section 0, bump versions and dates, added semicolon after
 ;  PICSITE for XINDEX
 ; 2022-03-24 ven/gpl add ability to create a site index showing patients and
 ;  the ability to automatically move duplicated entries to another site to fix
 ;  a problem with inputting data from a spreadsheet.
 ; 2022-03-24 ven/lmry Update date and contents list
 ; 
 ;
 ;@contents
 ; EN entry point to change a patient's site
 ; DEDUP move duplicate patient records from one site to another
 ; SITEIDX generate a siteid index in the patient lookup graph
 ; MOV change patient PAT from site FROM to site TO 
 ; SETSID propogate the new sid to all forms
 ; PICPAT pick a patient in site SITE
 ; PICSITE()
 ; AUDIT()
 ; outaudit(rpt,ln)
 ; 
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
EN ; entry point to change a patient's site
 ;
 n FROM,TO,PAT
 W !,"Pick the FROM Site -"
 S FROM=$$PICSITE()
 IF FROM="^" Q  ;
 ;
 W !,"Pick the TO Site -"
 S TO=$$PICSITE()
 IF TO="^" Q  ;
 ;
 D PICPAT(.PAT,FROM)
 I $G(PAT("name"))="" D  Q  ;
 . W !,"No patient selected, canceling"
 K DIR
 S DIR("A")="Confirm change site of patient "_PAT("name")_" from "_FROM_" to "_TO
 S DIR(0)="Y"
 D ^DIR
 ;
 I Y'=1 D  Q  ;
 . W !,"Cancel, no change made"
 ;
 do MOV(.PAT,FROM,TO)
 q
 ;
DEDUP() ; remove duplicate names from a site
 ;
 n FROM,TO,PAT
 W !,"Pick the FROM Site -"
 S FROM=$$PICSITE()
 IF FROM="^" Q  ;
 ;
 W !,"Pick the TO Site -"
 S TO=$$PICSITE()
 IF TO="^" Q  ;
 ;
 K DIR
 S DIR("A")="Confirm removing duplicates from  "_FROM_" by moving them to "_TO
 S DIR(0)="Y"
 D ^DIR
 ;
 I Y'=1 D  Q  ;
 . W !,"Cancel, no change made"
 ;
 d SITEIDX ; insure we have a site index
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 q:lroot=""
 n site s site=FROM
 n gn s gn=$na(@lroot@("siteid",site))
 i '$d(@gn) d  q  ;
 . w !,"Error name index not found"
 n zi,zj
 s zi=""
 f  s zi=$o(@gn@(zi)) q:zi=""  d  ;
 . s zj=$o(@gn@(zi,"")) ; ien of non-duplicate record
 . q:$g(@lroot@(zj,"siteid"))'=FROM
 . f  s zj=$o(@gn@(zi,zj)) q:zj=""  d  ;
 . . q:'$d(@lroot@(zj))
 . . m PAT=@lroot@(zj)
 . . q:$g(PAT("siteid"))'=FROM
 . . w !,"found a duplicate "_zi_" "_zj
 . . do MOV(.PAT,FROM,TO)
 . . K PAT
 D SITEIDX
 q
 ;
SITEIDX() ; generate a siteid index in the patient lookup graph
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 q:lroot=""
 k @lroot@("siteid")
 n site,nm,ien
 s (site,nm)=""
 s ien=0
 f  s ien=$o(@lroot@(ien)) q:+ien=0  d  ;
 . s site=$g(@lroot@(ien,"siteid"))
 . ;q:site="XXX"
 . ;w !,ien_" site: "_site
 . s nm=$g(@lroot@(ien,"saminame"))
 . q:nm=""
 . q:site=""
 . s @lroot@("siteid",site,nm,ien)=""
 q
 ;
MOV(PAT,FROM,TO) ; change patient PAT from site FROM to site TO
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n dfn s dfn=$g(PAT("dfn"))
 i dfn="" d  q  ;
 . w !,"Error, patient not valid"
 n lien
 s lien=$o(@lroot@("dfn",dfn,""))
 i $g(@lroot@(lien,"siteid"))'=FROM d  q  ;
 . w !,"Error, from site not valid for patient"
 ;
 n pien s pien=$o(@root@("dfn",dfn,""))
 i pien="" d  q  ;
 . w !,"Patient has no forms"
 . s @lroot@(lien,"siteid")=TO
 . w !,"Change successful"
 ;
 n oldsid s oldsid=$g(@root@(pien,"studyid"))
 i oldsid="" s oldsid=$g(@root@(pien,"samistudyid"))
 w !,"oldsid=",oldsid
 i oldsid="" d  q  ;
 . w !,"Error studyid not found"
 ;b
 s @lroot@(lien,"siteid")=TO
 s PAT("siteid")=TO
 k @root@("sid",oldsid,pien) ; remove sid index
 ;
 n newsid s newsid=$$GENSTDID^SAMIHOM3(dfn,.PAT)
 s @lroot@(lien,"studyid")=newsid
 s @root@(pien,"studyid")=newsid
 s @root@(pien,"sisid")=newsid
 s @root@(pien,"samistudyid")=newsid
 s @root@("sid",newsid,pien)=""
 ;
 w !,"New studyid = "_newsid
 m @root@("graph",newsid)=@root@("graph",oldsid)
 d SETSID(newsid) ;propogate the new sid to all forms
 k @root@("graph",oldsid)
 w !,"Change successful"
 ;
 q
 ;
SETSID(newsid) ; propogate the new sid to all forms
 n root s root=$$setroot^%wd("vapals-patients")
 n zi s zi=""
 f  s zi=$o(@root@("graph",newsid,zi)) q:zi=""  d  ;
 . s @root@("graph",newsid,zi,"samistudyid")=newsid
 . s @root@("graph",newsid,zi,"studyid")=newsid
 . s @root@("graph",newsid,zi,"sisid")=newsid
 q
 ;
PICPAT(PATRTN,SITE) ; pick a patient in site SITE
 ;
 N FILTER,LIST,X,Y
 I $G(SITE)="" S SITE="*"
 S FILTER("site")=$G(SITE)
 S FILTER("format")="array"
 ;
 new DIR set DIR(0)="F^1:120" ; free text
 set DIR("A")="Patient name: " ; prompt
 set DIR("B")="""" ; default
 ;
 d ^DIR
 ;
 S FILTER("search")=Y
 D WSPTLKUP^SAMIPTLK(.LIST,.FILTER)
 ;ZWR LIST(:,:,"name")
 ;
 N LCNT S LCNT=$O(LIST("result",""),-1)
 Q:+LCNT=0
 S Y=1
 I LCNT>1 D  ; more than one in the list
 . K DIR
 . N ZI S ZI=0
 . S DIR("A")="Select the patient"
 . F  S ZI=$O(LIST("result",ZI)) Q:+ZI=0  D  ;
 . . S DIR("A",ZI)=ZI_" "_LIST("result",ZI,"name")_" "_LIST("result",ZI,"last5")
 . S DIR(0)="N^1:"_LCNT_":0"
 . D ^DIR
 . ;W !,"Y=",Y
 I +Y>0 M PATRTN=LIST("result",Y)
 q
 ;
PICSITE()  ;
 ;
 ; pick a site
 N X,Y,DIC,SITEIEN,SITEID
 S DIC=311.12
 S DIC(0)="AEMQ"
 D ^DIC
 I Y<1 Q  ; EXIT
 S SITENUM=$P(Y,"^",2)
 S SITEID=$$SITEID^SAMISITE(SITENUM)
 Q SITEID
 ;
AUDIT() ;
 ;
 n proot s proot=$$setroot^%wd("vapals-patients")
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n rpt s rpt=$na(^TMP("SAMIAUDIT",$J))
 k @rpt
 d outaudit(rpt,"cdate NAME  lien  dfn site  PNAME  pien  pdfn sid")
 n ln,lname,lien,cdate,pname,pien,ldfn,pdfn,site,sid
 s (ln,lname,lien,site,cdate,pname,pien,ldfn,pdfn,sid)=""
 n zi s zi=" "
 f  s zi=$o(@lroot@(zi),-1) q:+zi=0  d  ;
 . s lien=zi
 . s site=$g(@lroot@(zi,"siteid"))
 . s lname=$g(@lroot@(zi,"saminame"))
 . s ldfn=$g(@lroot@(zi,"dfn"))
 . i ldfn="" d  q  ;
 . . ;d ^ZTER
 . . w !,"error ",zi
 . . s ln="error, missing dfn lien="_lien
 . . s ln=ln_" "_$g(@lroot@(zi,"saminame"))
 . . d outaudit(rpt,ln)
 . . s ln=""
 . i $o(@lroot@("dfn",ldfn,""))'=lien d  ;
 . . w !,"error in dfn index dfn="_ldfn_" lien="_lien
 . s pien=$o(@proot@("dfn",ldfn,""))
 . i +pien'=0 d  ;
 . . s cdate=$g(@proot@(pien,"samicreatedate"))
 . . s pname=$g(@proot@(pien,"saminame"))
 . . s pdfn=$g(@proot@(pien,"dfn"))
 . . s sid=$g(@proot@(pien,"samistudyid"))
 . s ln=ln_$g(cdate)_" "
 . s ln=ln_$e(lname,1,20)_"  "
 . s ln=ln_$J(lien,5)
 . s ln=ln_$j(ldfn,8)
 . s ln=ln_" "_site_" "
 . s ln=ln_" "_$e(pname,1,20)_" "
 . s ln=ln_$j(pien,5)
 . i pien="" s ln=ln_"Not Enrolled"
 . s ln=ln_$j(pdfn,8)
 . s ln=ln_" "_sid
 . d outaudit(rpt,ln)
 . s (ln,lname,lien,site,cdate,pname,pien,ldfn,pdfn,sid)=""
 ;B
 D BROWSE^DDBR(rpt,"N","audit")
 ;
 q
 ;
outaudit(rpt,ln) ;
 s @rpt@($o(@rpt@(" "),-1)+1)=$g(ln)
 ;w !,ln
 q
 ;