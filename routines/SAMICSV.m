SAMICSV ;ven/gpl - VAPALS CSV EXPORT ; 8/15/20 4:48pm
 ;;18.0;SAMI;;;Build 2
 ;
 ;@license: see routine SAMIUL
 ;
 ; allow fallthrough
 ;
EN ; entry point to generate csv files from forms for a site
 ;
 ; first pick a site
 N X,Y,DIC,SITEIEN,SITEID
 S DIC=311.12
 S DIC(0)="AEMQ"
 D ^DIC
 I Y<1 Q  ; EXIT
 S SITENUM=$P(Y,"^",2)
 S SITEID=$$SITEID^SAMISITE(SITENUM)
 Q:SITEID=""
 ;
 N SAMIFORM S SAMIFORM=$$SAYFORM()
 Q:SAMIFORM=-1
 ;
 ; prompt for the directory
 N SAMIDIR
 D GETDIR^SAMIFDM(.SAMIDIR)
 Q:SAMIDIR=""
 ;
 d ONEFORM(SITEID,SAMIFORM,SAMIDIR) ; process one form for a site
 ;
 q
 ;
ONEFORM(SITEID,SAMIFORM,SAMIDIR) ; process one form for a site
 n root s root=$$setroot^%wd("vapals-patients")
 n groot s groot=$na(@root@("graph"))
 n SAMII S SAMII=SITEID
 n cnt s cnt=0
 n forms s forms=0
 ;
 n SAMIOUT S SAMIOUT=$NA(^TMP("SAMICSV",$J))
 k @SAMIOUT
 ;
 n DICT
 d DDICT("DICT",SAMIFORM) ; get the data dictionary for this form
 q:'$d(DICT)
 ;
 N SAMIN S SAMIN=1
 N SAMIJJ s SAMIJJ=0
 N OFFSET S OFFSET=0
 I SAMIFORM="siform" d  ;
 . S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="saminame"
 . S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="ssn"
 . S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="last5"
 . S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="sex"
 . S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="sbdob"
 . S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="samiru"
 f  s SAMIJJ=$o(DICT(SAMIJJ)) q:+SAMIJJ=0  d  ;
 . s $p(@SAMIOUT@(SAMIN),"|",SAMIJJ+OFFSET)=DICT(SAMIJJ) ; csv header
 s @SAMIOUT@(SAMIN)="siteid|samistudyid|form|"_@SAMIOUT@(SAMIN)
 ;S @SAMIOUT@(SAMIN)=@SAMIOUT@(SAMIN)_$C(13,10) ; carriage return line feed
 ; 
 f  s SAMII=$o(@groot@(SAMII)) q:SAMII=""  q:$e(SAMII,1,3)'[SITEID  d  ;
 . s cnt=cnt+1
 . w !,SAMII
 . N SAMIJ S SAMIJ=SAMIFORM
 . n done s done=0
 . f  s SAMIJ=$O(@groot@(SAMII,SAMIJ)) q:SAMIJ=""  q:done  d  ;
 . . i $e(SAMIJ,1,$l(SAMIFORM))'=SAMIFORM s done=1 q  ;
 . . s forms=forms+1
 . . n jj s jj=0
 . . s SAMIN=SAMIN+1
 . . S OFFSET=0
 . . I SAMIFORM="siform" d  ;
 . . . n kk s kk=$o(@root@("sid",SAMII,""))
 . . . q:kk=""
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"saminame"))
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"ssn"))
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"last5"))
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"sex"))
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"sbdob"))
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"samiru"))
 . . f  s jj=$o(DICT(jj)) q:+jj=0  d  ;
 . . . ;s $P(@SAMIOUT@(SAMIN),"|",OFFSET+jj)=""""_$g(@groot@(SAMII,SAMIJ,DICT(jj)))_""""
 . . . n val
 . . . s val=$g(@groot@(SAMII,SAMIJ,DICT(jj)))_""""
 . . . s val=$tr(val,$char(11))
 . . . s $P(@SAMIOUT@(SAMIN),"|",OFFSET+jj)=""""_val
 . . S @SAMIOUT@(SAMIN)=SITEID_"|"_SAMII_"|"_SAMIJ_"|"_@SAMIOUT@(SAMIN)
 . . ;s @SAMIOUT@(SAMIN)=@SAMIOUT@(SAMIN)_$C(13,10)
 . ;b
 ;ZWR @SAMIOUT@(*)
 w !,cnt_" patients, "_forms_" forms"
 n filename s filename=$$FNAME(SITEID,SAMIFORM)
 d GTF^%ZISH($na(@SAMIOUT@(1)),3,SAMIDIR,filename)
 w !,"file "_filename_" written to directory "_SAMIDIR
 q
 ;
FNAME(SITE,FORM) ; extrinsic returns the filename for the site/form
 Q SITE_"-"_FORM_"-"_$$FMTHL7^XLFDT($$HTFM^XLFDT($H))_".csv"
 ;
DDICT(RTN,FORM) ; data dictionary for FORM, returned in RTN, passed by
 ; name
 K @RTN
 ;
 N USEGR S USEGR=""
 I FORM="siform" S USEGR="form fields - intake"
 I FORM="sbform" S USEGR="form fields - background"
 I FORM="ceform" S USEGR="form fields - ct evaluation"
 I FORM="fuform" S USEGR="form fields - follow up"
 I FORM="bxform" S USEGR="form fields - biopsy"
 I FORM="itform" S USEGR="form fields - intervention"
 I FORM="ptform" S USEGR="form fields - pet evaluation"
 ;
 Q:USEGR=""
 N root s root=$$setroot^%wd(USEGR)
 Q:$g(root)=""
 N II S II=0
 f  s II=$o(@root@("field",II)) q:+II=0  d  ;
 . s @RTN@(II)=$g(@root@("field",II,"input",1,"name"))
 q
 ;^%wd(17.040801,"B","form fields - background",437)=""
 ;^%wd(17.040801,"B","form fields - biopsy",438)=""
 ;^%wd(17.040801,"B","form fields - ct evaluation",439)=""
 ;^%wd(17.040801,"B","form fields - follow up",440)=""
 ;^%wd(17.040801,"B","form fields - follow-up",359)=""
 ;^%wd(17.040801,"B","form fields - intake",491)=""
 ;^%wd(17.040801,"B","form fields - intervention",442)=""
 ;^%wd(17.040801,"B","form fields - pet evaluation",443)=""
 ;
SAYFORM() ; prompts for the form
 N ZI,ZF,DIR
 S ZF(1)="siform"
 S ZF(2)="sbform"
 S ZF(3)="ceform"
 S ZF(4)="fuform"
 S ZF(5)="bxform"
 S ZF(6)="itform"
 S ZF(7)="ptform"
 K DIR
 S DIR(0)="SO^"
 F ZI=1:1:7 S DIR(0)=DIR(0)_ZI_":"_ZF(ZI)_";"
 S DIR("L")="Select form to extract:"
 S DIR("L",1)="1 Intake form (siform)"
 S DIR("L",2)="2 Background form (sbform)"
 S DIR("L",3)="3 CT Evaluation form (ceform)"
 S DIR("L",4)="4 Followup form (fuform)"
 S DIR("L",5)="5 Biopsy form (bxform)"
 S DIR("L",6)="6 Intervention form (itform)"
 S DIR("L",7)="7 Pet Evaluation form (ptform)"
 D ^DIR
 Q:X="" -1
 Q ZF(X)
 ;
 
