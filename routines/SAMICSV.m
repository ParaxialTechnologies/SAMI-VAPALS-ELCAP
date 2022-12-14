SAMICSV ;ven/gpl - csv export ;2022-12-13T02:38Z
 ;;18.0;SAMI;**7,11,17**;2020-01;Build 4
 ;;18-17
 ;
 ; SAMICSV contains a direct-mode interface to produce the VAPALS-
 ; ELCAP CSV export.
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
 ;@primary-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2022-12-13T02:38Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11+i11
 ;@release-date 2020-01
 ;@patch-list **7,11**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@module-credits
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
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2020-08-20/09-24 ven/gpl 1.18.0.7+i7 9486abb2,5ae08772,ba0bcb82,
 ; 1a2a1bf6,16511893
 ;  SAMICSV: new routine, test build for extracting form data to csv
 ; files, upgrade change site to handle patients without forms, audit
 ; report, select from 7 forms for extract, fix dictionary spelling
 ; for followup form, fix bug of line feeds in csv output interrupting
 ; excel load.
 ;
 ; 2021-03-25 ven/gpl 1.18.0.11+i11 e28a34d3
 ;  SAMICSV: remove line feeds from variables.
 ;
 ; 2021-03-30 ven/toad 1.18.0.11+i11 7b14bb2
 ;  SAMICSV: bump version, date, patch list, create hdr comments, lt
 ; refactor.
 ;
 ; 2021-04-15 ven/gpl 1.18.0.11+i11 f9795a5,5aa13f1
 ;  SAMICSV: fix double quotes in csv output, correct csv format no
 ; quotes for null cells.
 ;
 ; 2021-05-21 ven/mcglk&toad 1.18.0.11+i11
 ;  SAMICSV: bump version, date.
 ;
 ; 2022-12-11 ven/gpl 18-17-T3
 ;  SAMICSV: include last5 and saminame in every csv file on every row
 ;
 ; 2022-12-13 ven/lmry  18-17-t3 test
 ;  update log, bump date
 ;
 ;
 ;@contents
 ; EN entry point to generate csv files from forms for a site
 ; ONEFORM process one form for a site
 ; $$FNAME filename for site/form
 ; DDICT data dictionary for form
 ; $$SAYFORM prompts for form
 ;
 ;
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
 quit  ; end of EN
 ;
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
FNAME(SITE,FORM) ; extrinsic returns the filename for the site/form
 ;
 quit SITE_"-"_FORM_"-"_$$FMTHL7^XLFDT($$HTFM^XLFDT($H))_".csv" ; end of $$FNAME
 ;
 ;
 ;
DDICT(RTN,FORM) ; data dictionary for FORM, returned in RTN, passed by
 ; name
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
 ;
 Q:USEGR=""
 N root s root=$$setroot^%wd(USEGR)
 Q:$g(root)=""
 N II S II=0
 f  s II=$o(@root@("field",II)) q:+II=0  d  ;
 . s @RTN@(II)=$g(@root@("field",II,"input",1,"name"))
 ;
 quit  ; end of DDICT
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
SAYFORM() ; prompts for the form
 ;
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
 ;
 Q:X="" -1
 quit ZF(X) ; end of $$SAYFORM
 ;
 ;
 ;
EOR ; end of routine SAMICSV
