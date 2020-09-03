SAMIMOV ;ven/gpl - VAPALS CHANGE PATIENT SITE ; 8/15/20 4:48pm
 ;;18.0;SAMI;;;Build 2
 ;
 ;@license: see routine SAMIUL
 ;
 ; allow fallthrough
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
 S FILTER("site")=SITE
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
PICSITE()
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
 d outaudit(rpt,"NAME  lien  dfn site  PNAME  pien  pdfn sid")
 n ln,lname,lien,pname,pien,ldfn,pdfn,site,sid
 s (ln,lname,lien,site,pname,pien,ldfn,pdfn,sid)=""
 n zi s zi=0
 f  s zi=$o(@lroot@(zi)) q:+zi=0  d  ;
 . s lien=zi
 . s site=$g(@lroot@(zi,"siteid"))
 . s lname=$g(@lroot@(zi,"saminame"))
 . s ldfn=$g(@lroot@(zi,"dfn"))
 . i $o(@lroot@("dfn",ldfn,""))'=lien d  ;
 . . w !,"error in dfn index dfn="_ldfn_" lien="_lien
 . s pien=$o(@proot@("dfn",ldfn,""))
 . i +pien'=0 d  ;
 . . s pname=$g(@proot@(pien,"saminame"))
 . . s pdfn=$g(@proot@(pien,"dfn"))
 . . s sid=$g(@proot@(pien,"samistudyid"))
 . s ln=ln_$e(lname,1,20)_"  "
 . s ln=ln_$J(lien,5)
 . s ln=ln_$j(ldfn,8)
 . s ln=ln_" "_site_" "
 . s ln=ln_"   "_$e(pname,1,20)
 . s ln=ln_$j(pien,5)
 . i pien="" s ln=ln_"Not Enrolled"
 . s ln=ln_$j(pdfn,8)
 . s ln=ln_" "_sid
 . d outaudit(rpt,ln)
 . s (ln,lname,lien,site,pname,pien,ldfn,pdfn,sid)=""
 D BROWSE^DDBR(rpt,"N","audit")
 ;
 q
 ;
outaudit(rpt,ln) ;
 s @rpt@($o(@rpt@(" "),-1)+1)=$g(ln)
 ;w !,ln
 q
 ;