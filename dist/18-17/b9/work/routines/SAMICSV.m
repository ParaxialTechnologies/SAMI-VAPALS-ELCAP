SAMICSV ;ven/gpl - export csv; 2024-08-22t21:04z
 ;;18.0;SAMI;**7,11,17**;2020-01-17;Build 8
 ;mdc-e1;SAMICSV-20240822-ES+7xF;SAMI-18-17-b9
 ;mdc-v7;B104029869;SAMI*18.0*17 SEQ #17
 ;
 ; SAMICSV contains a direct-mode service to produce the ScreeningPlus
 ; CSV export.
 ;
 ; allow entry from top, fallthrough to EN
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;
 ;@dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2024, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@update 2024-08-22t21:04z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module Import/Export - various prefixes
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-17
 ;@edition-date 2020-01-17
 ;@patches **7,11,17**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
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
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2020-08-20/09-24 ven/gpl 18-7 9486abb2,5ae08772,ba0bcb82,1a2a1bf6,
 ; 16511893
 ;  SAMICSV new routine, test build for extracting form data to csv
 ; files, upgrade change site to handle patients without forms, audit
 ; report, select from 7 forms for extract, fix dictionary spelling
 ; for followup form, fix bug of line feeds in csv output interrupting
 ; excel load.
 ;
 ; 2021-03-25 ven/gpl 18-11 e28a34d3
 ;  SAMICSV remove line feeds from variables.
 ;
 ; 2021-03-30 ven/toad 18-11 7b14bb2
 ;  SAMICSV bump version, date, patch list, create hdr comments, lt
 ; refactor.
 ;
 ; 2021-04-15 ven/gpl 18-11 f9795a5,5aa13f1
 ;  SAMICSV fix double quotes in csv output, correct csv format no
 ; quotes for null cells.
 ;
 ; 2021-05-21 ven/mcglk&toad 18-11
 ;  SAMICSV bump version, date.
 ;
 ; 2022-12-11 ven/gpl 18-17-b3
 ;  SAMICSV include last5 and saminame in every csv file on every row.
 ;
 ; 2022-12-13 ven/lmry 18-17-b3
 ;  SAMICSV update log, bump date.
 ;
 ; 2024-08-17 ven/lmry 18-17-b6
 ;  SAMICSV bump version, date.
 ;
 ; 2024-08-21/22 ven/toad 18-17-b6
 ;  SAMICSV annotate, update history, update version-control lines,
 ; hdr comments.
 ;
 ;@contents
 ;
 ; EN entry point to generate csv files from forms for a site
 ; $$SAYFORM prompts for form
 ; ONEFORM process one form for a site
 ; $$FNAME filename for site/form
 ; DDICT data dictionary for form
 ;
 ;
 ;
 ;
 ;@dms-code EN^SAMICSV
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;dms;procedure;clean?;dialog;sac;??% tests;port?
 ;@signature
 ; do ^SAMICSV
 ;@falls-thru-from
 ; ^SAMICSV
 ;@called-by none
 ;@calls
 ; ^DIC
 ; $$SITEID^SAMISITE
 ; $$SAYFORM
 ; GETDIR^SAMIFDM
 ; ONEFORM
 ;@input [tbd]
 ;@output [tbd]
 ;@tests [tbd]
 ;
 ;
EN ; entry point to generate csv files from forms for a site
 ;
 ;@stanza 2 select site
 ;
 ; first pick a site
 N X,Y,DIC,SITEIEN,SITEID
 S DIC=311.12
 S DIC(0)="AEMQ"
 D ^DIC
 I Y<1 Q  ; EXIT
 S SITENUM=$P(Y,"^",2)
 ;
 S SITEID=$$SITEID^SAMISITE(SITENUM)
 Q:SITEID=""
 ;
 ;
 ;@stanza 3 select form
 ;
 N SAMIFORM S SAMIFORM=$$SAYFORM()
 Q:SAMIFORM=-1
 ;
 ;
 ;@stanza 4 select directory
 ;
 ; prompt for the directory
 N SAMIDIR
 D GETDIR^SAMIFDM(.SAMIDIR)
 Q:SAMIDIR=""
 ;
 d ONEFORM(SITEID,SAMIFORM,SAMIDIR) ; process one form for a site
 ;
 ;
 ;@stanza 5 termination
 ;
 quit  ; end of EN
 ;
 ;
 ;
 ;
 ;@func-code $$SAYFORM^SAMICSV
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;pseudo-function;clean?;prompt;sac;??% tests;port?
 ;@called-by
 ; ^SAMICSV
 ;@calls
 ; ^DIR
 ;@input [tbd]
 ;@output = form
 ;@tests [tbd]
 ;
 ;
SAYFORM() ; prompts for the form
 ;
 ;@stanza 2 define set of codes
 ;
 N ZF
 S ZF(1)="siform"
 S ZF(2)="sbform"
 S ZF(3)="ceform"
 S ZF(4)="fuform"
 S ZF(5)="bxform"
 S ZF(6)="itform"
 S ZF(7)="ptform"
 N DIR S DIR(0)="SO^"
 N ZI
 F ZI=1:1:7 S DIR(0)=DIR(0)_ZI_":"_ZF(ZI)_";"
 ;
 ;
 ;@stanza 3 set up prompt
 ;
 S DIR("L")="Select form to extract:"
 S DIR("L",1)="1 Intake form (siform)"
 S DIR("L",2)="2 Background form (sbform)"
 S DIR("L",3)="3 CT Evaluation form (ceform)"
 S DIR("L",4)="4 Followup form (fuform)"
 S DIR("L",5)="5 Biopsy form (bxform)"
 S DIR("L",6)="6 Intervention form (itform)"
 S DIR("L",7)="7 Pet Evaluation form (ptform)"
 ;
 ;
 ;@stanza 4 prompt user to select a form
 ;
 D ^DIR
 Q:X="" -1
 ;
 ;
 ;@stanza 5 termination
 ;
 quit ZF(X) ; end of $$SAYFORM
 ;
 ;
 ;
 ;
 ;@proc-code ONEFORM^SAMICSV
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; DDICT
 ; $$FNAME
 ; GTF^%ZISH
 ;@input
 ; SITEID =
 ; SAMIFORM =
 ; SAMIDIR =
 ;@output [tbd]
 ;@tests [tbd]
 ;
 ;
ONEFORM(SITEID,SAMIFORM,SAMIDIR) ; process one form for a site
 ;
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
 N OFFSET S OFFSET=1
 d  ; start with last5 and name for all forms
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="last5"
 . S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="saminame"
 . S OFFSET=OFFSET+1
 ;
 I SAMIFORM="siform" d  ;
 . ;S OFFSET=OFFSET+1
 . ;s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="saminame"
 . ;S OFFSET=OFFSET+1
 . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="ssn"
 . S OFFSET=OFFSET+1
 . ;s $p(@SAMIOUT@(SAMIN),"|",OFFSET)="last5"
 . ;S OFFSET=OFFSET+1
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
 . . S OFFSET=1
 . . n kk s kk=$o(@root@("sid",SAMII,""))
 . . q:kk=""
 . . ;S OFFSET=OFFSET+1
 . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"last5"))
 . . S OFFSET=OFFSET+1
 . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"saminame"))
 . . S OFFSET=OFFSET+1
 . . ;
 . . I SAMIFORM="siform" d  ;
 . . . ;n kk s kk=$o(@root@("sid",SAMII,""))
 . . . ;q:kk=""
 . . . ;S OFFSET=OFFSET+1
 . . . ;s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"saminame"))
 . . . ;S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"ssn"))
 . . . S OFFSET=OFFSET+1
 . . . ;s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"last5"))
 . . . ;S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"sex"))
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"sbdob"))
 . . . S OFFSET=OFFSET+1
 . . . s $p(@SAMIOUT@(SAMIN),"|",OFFSET)=$g(@root@(kk,"samiru"))
 . . f  s jj=$o(DICT(jj)) q:+jj=0  d  ;
 . . . ;s $P(@SAMIOUT@(SAMIN),"|",OFFSET+jj)=""""_$g(@groot@(SAMII,SAMIJ,DICT(jj)))_""""
 . . . n val
 . . . ;s val=$g(@groot@(SAMII,SAMIJ,DICT(jj)))_""""
 . . . s val=$g(@groot@(SAMII,SAMIJ,DICT(jj)))
 . . . i val'="" d  ;
 . . . . s val=$tr(val,$char(11))
 . . . . s val=$tr(val,$char(13))
 . . . . d findReplaceAll^%ts(.val,"""","""""")
 . . . . s val=""""_val_""""
 . . . s $P(@SAMIOUT@(SAMIN),"|",OFFSET+jj)=val
 . . S @SAMIOUT@(SAMIN)=SITEID_"|"_SAMII_"|"_SAMIJ_"|"_@SAMIOUT@(SAMIN)
 . . ;s @SAMIOUT@(SAMIN)=@SAMIOUT@(SAMIN)_$C(13,10)
 . ;b
 ;ZWR @SAMIOUT@(*)
 w !,cnt_" patients, "_forms_" forms"
 n filename s filename=$$FNAME(SITEID,SAMIFORM)
 d GTF^%ZISH($na(@SAMIOUT@(1)),3,SAMIDIR,filename)
 w !,"file "_filename_" written to directory "_SAMIDIR
 ;
 quit  ; end of ONEFORM
 ;
 ;
 ;
 ;
 ;@func-code $$FNAME^SAMICSV
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;??% tests;port
 ;@called-by
 ; ONEFORM^SAMICSV
 ;@calls
 ; $$HTFM^XLFDT
 ; $$FMTHL7^XLFDT
 ;@input
 ; SITE =
 ; FORM =
 ;@output = file name for site/form
 ;@tests [tbd]
 ;
 ;
FNAME(SITE,FORM) ; extrinsic returns the filename for the site/form
 ;
 quit SITE_"-"_FORM_"-"_$$FMTHL7^XLFDT($$HTFM^XLFDT($H))_".csv" ; end of $$FNAME
 ;
 ;
 ;
 ;
 ;@proc-code DDICT^SAMICSV
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by
 ; ONEFORM^SAMICSV
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; RTN = output array name, closed reference
 ; FORM = form whose DD should be returned in @RTN
 ;@output
 ; @RTN: DD for FORM
 ;@tests [tbd]
 ;
 ;
DDICT(RTN,FORM) ; data dictionary for FORM
 ;
 ;@stanza 2 identify form
 ;
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
 Q:USEGR=""
 ;
 ;
 ;@stanza 3 get DD
 ;
 N root s root=$$setroot^%wd(USEGR)
 Q:$g(root)=""
 ;
 N II S II=0
 f  s II=$o(@root@("field",II)) q:+II=0  d  ;
 . s @RTN@(II)=$g(@root@("field",II,"input",1,"name"))
 . q
 ;
 ;
 ;@stanza 4 termination
 ;
 quit  ; end of DDICT
 ;
 ;
 ;
 ;
 ;^%wd(17.040801,"B","form fields - background",437)=""
 ;^%wd(17.040801,"B","form fields - biopsy",438)=""
 ;^%wd(17.040801,"B","form fields - ct evaluation",439)=""
 ;^%wd(17.040801,"B","form fields - follow up",440)=""
 ;^%wd(17.040801,"B","form fields - follow-up",359)=""
 ;^%wd(17.040801,"B","form fields - intake",491)=""
 ;^%wd(17.040801,"B","form fields - intervention",442)=""
 ;^%wd(17.040801,"B","form fields - pet evaluation",443)=""
 ;
 ;
 ;
EOR ; end of routine SAMICSV
