SAMISAV ;ven/gpl - SAMI save routines ;2021-05-21T20:47Z
 ;;18.0;SAMI;**5,11**;2020-01;
 ;;1.18.0.11+i11
 ;
 ; SAMISAV contains subroutines for saving forms.
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
 ;@primary-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-05-21T20:47Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11+i11
 ;@release-date 2020-01
 ;@patch-list **5,11**
 ;
 ;@additional-dev Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;@additional-dev Alexis R. Carlson (arc)
 ; arc@vistaexpertise.net
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
 ; 2018-10-29/11-09 ven/lgc&arc 1.18.0 3d36564,482f522,949f150
 ;  SAMISAV: followup report, new input form features, report menu
 ; fix, fixed submit save bug.
 ;
 ; 2018-12-11/27 ven/lgc&arc 1.18.0 3ceb74b,a14554c,8dd6f34,51eb163,
 ; f2738f8
 ;  SAMISAV: update routines for sac compliance, r/^gpl w/^SAMIGPL,
 ; update routines for sac compliance, fix accidental reversions.
 ;
 ; 2019-01-22 ven/lgc 1.18.0 5368121
 ;  SAMISAV: add license info.
 ;
 ; 2019-02-18 ven/lgc 1.18.0 7687431
 ;  SAMISAV: update recently edited routines
 ;
 ; 2019-06-18 ven/arc 1.18.0 9102248
 ;  SAMISAV: r/^SAMIGPL w/^SAMIUL.
 ;
 ; 2019-08-14 ven/gpl 1.18.0 d73fec6 VAP-417
 ;  SAMISAV: add communications log to intake form.
 ;
 ; 2019-09-26 ven/gpl 1.18.0 92b1232
 ;  SAMISAV: mods for smoking history.
 ;
 ; 2020-04-10 ven/gpl 1.18.0.5+i5 56bfaed
 ;  SAMISAV: multi-tenancy change.
 ;
 ; 2021-05-13 ven/gpl 1.18.0.11+i11 1c03fd6
 ;  SAMISAV: fix date save on intervention, pet, & biopsy forms.
 ;
 ; 2021-05-20/21 ven/mcglk&toad 1.18.0.11+i11
 ;  SAMIHL7: build hdr comments & dev log, lt refactor, bump version.
 ;
 ;@contents
 ; $$SAVFILTR saves form & returns key
 ; COMLOG add to communications log
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
SAVFILTR(sid,form,vars) ; saves form & returns key
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;function;clean;silent;sac
 ;@called-by
 ;@calls
 ; $$SITENM2^SAMISITE
 ; $$setroot^%wd
 ; $$KEY2FM^SAMICASE
 ;@input
 ;@output = form key to use for saving
 ; It will relocate the graph for the form if required based on dates
 ;  entered on the form.
 ; processing for multi-tenancy: if siteid not provided, but studyid
 ;  is, look up & set siteid.
 ;@thruput
 ; sid = study id
 ; form = form key
 ; vars = form variables
 ;
 ;
 ;@stanza 2 setup
 ;
 if '$data(vars("siteid")) do  ;
 . quit:$get(sid)=""
 . new sym set sym=$extract(sid,1,3) ; first 3 chars in studyid
 . quit:$$SITENM2^SAMISITE(sym)=-1
 . set vars("siteid")=sym
 . set vars("site")=sym
 . quit
 ;
 new useform set useform=form ; by default, form unchanged
 new root set root=$$setroot^%wd("vapals-patients")
 new type set type=$piece(form,"-",1)
 ;
 ;
 ;@stanza 3 ct evaluation form
 ;
 if type="ceform" do
 . merge ^SAMIUL("samisav","vals")=vars
 . new formdate set formdate=$get(vars("cedos")) ; ct scan date f/form
 . quit:formdate=""
 . new fdate set fdate=$$KEY2FM^SAMICASE(formdate) ; cnvt to fm date
 . quit:fdate=""
 . quit:fdate<0
 . new fmcurrent set fmcurrent=$$KEY2FM^SAMICASE(form) ; key,fm format
 . if fdate'=fmcurrent do  ;
 . . new moveto set moveto="ceform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ; w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . kill ^SAMIUL("samisav")
 . . set ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . set ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . set ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . merge ^SAMIUL("samisav","vals")=vars
 . . merge @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . kill @root@("graph",sid,form)
 . . set useform=moveto
 . . quit
 . quit
 ;
 ;
 ;@stanza 4 followup form
 ;
 if type="fuform" do
 . merge ^SAMIUL("samisav","vals")=vars
 . new formdate set formdate=$get(vars("sidof")) ; CT scan date f/form
 . quit:formdate=""
 . new fdate set fdate=$$KEY2FM^SAMICASE(formdate) ; cnvt to fm date
 . quit:fdate=""
 . quit:fdate<0
 . new fmcurrent set fmcurrent=$$KEY2FM^SAMICASE(form) ; key,fm format
 . if fdate'=fmcurrent do  ;
 . . new moveto set moveto="fuform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ; w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . kill ^SAMIUL("samisav")
 . . set ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . set ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . set ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . merge ^SAMIUL("samisav","vals")=vars
 . . merge @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . kill @root@("graph",sid,form)
 . . set useform=moveto
 . . quit
 . quit
 ;
 ;
 ;@stanza 5 intake form
 ;
 if type="siform" do
 . set vars("samifirsttime")="false"
 . do COMLOG(.sid,.form,.vars) ; add to communication log
 . new formdate set formdate=$get(vars("sidc")) ; CT scan date f/form
 . quit:formdate=""
 . new fdate set fdate=$$KEY2FM^SAMICASE(formdate) ; cnvt to fm date
 . quit:fdate=""
 . quit:fdate<0
 . new fmcurrent set fmcurrent=$$KEY2FM^SAMICASE(form) ; key,fm format
 . if fdate'=fmcurrent do  ;
 . . new moveto set moveto="siform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ; w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . kill ^SAMIUL("samisav")
 . . set ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . set ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . set ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . merge @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . kill @root@("graph",sid,form)
 . . set useform=moveto
 . . quit
 . quit
 ;
 ;
 ;@stanza 6 biopsy form
 ;
 if type="bxform" do
 . new formdate set formdate=$get(vars("bxdos")) ; biopsy date f/form
 . if formdate="" set formdate=$get(vars("rbmed")) ; mediastinoscopy d
 . quit:formdate=""
 . new fdate set fdate=$$KEY2FM^SAMICASE(formdate) ; cnvt to fm date
 . quit:fdate=""
 . quit:fdate<0
 . new fmcurrent set fmcurrent=$$KEY2FM^SAMICASE(form) ; key,fm format
 . if fdate'=fmcurrent do  ;
 . . new moveto set moveto="bxform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ; w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . kill ^SAMIUL("samisav")
 . . set ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . set ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . set ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . merge @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . kill @root@("graph",sid,form)
 . . set useform=moveto
 . . quit
 . quit
 ;
 ;
 ;@stanza 7 intervention form
 ;
 if type="itform" do
 . new formdate set formdate=$get(vars("rbsud")) ; treatment date
 . if formdate="" set formdate=$get(vars("rbdos")) ;1st intervention d
 . if formdate="" set formdate=$get(vars("rbdmr")) ; last intervention
 . quit:formdate=""
 . new fdate set fdate=$$KEY2FM^SAMICASE(formdate) ; cnvt to fm date
 . quit:fdate=""
 . quit:fdate<0
 . new fmcurrent set fmcurrent=$$KEY2FM^SAMICASE(form) ; key,fm format
 . if fdate'=fmcurrent do  ;
 . . new moveto set moveto="itform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ; w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . kill ^SAMIUL("samisav")
 . . set ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . set ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . set ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . merge @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . kill @root@("graph",sid,form)
 . . set useform=moveto
 . . quit
 . quit
 ;
 ;
 ;@stanza 8 pet evaluation form
 ;
 if type="ptform" do
 . new formdate set formdate=$get(vars("ptdos")) ; treatment date
 . quit:formdate=""
 . new fdate set fdate=$$KEY2FM^SAMICASE(formdate) ; cnvt to fm date
 . quit:fdate=""
 . quit:fdate<0
 . new fmcurrent set fmcurrent=$$KEY2FM^SAMICASE(form) ; key,fm format
 . if fdate'=fmcurrent do  ;
 . . new moveto set moveto="ptform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ; w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . kill ^SAMIUL("samisav")
 . . set ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . set ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . set ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . merge @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . kill @root@("graph",sid,form)
 . . set useform=moveto
 . . quit
 . quit
 ;
 ;
 ;@stanza 9 termination
 ;
 quit useform ; return form key ; end of $$SAVFILTR
 ;
 ;
 ;
COMLOG(sid,form,vars) ; add to communications log
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; SAVFILTR
 ;@calls
 ; $$setroot^%wd
 ; LOGIT^SAMICLOG
 ;@input
 ; sid = study id
 ; form = form key
 ; vars("sipcrn") = new comm log entry
 ;@output
 ; comm log updated to include new comm log entry
 ; vars("sipcrn") = cleared after being saved
 ;
 ;
 ;@stanza 2 add new entry to comm log
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 merge vars("comlog")=@root@("graph",sid,form,"comlog")
 new COMLOGRT ; communication log root
 set COMLOGRT=$name(@root@("graph",sid,form,"comlog"))
 ;
 if $get(vars("sipcrn"))'="" do  ; new comm log entry available
 . do LOGIT^SAMICLOG(COMLOGRT,vars("sipcrn"))
 . set vars("sipcrn")=""
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of COMLOG
 ;
 ;
 ;
EOR ; end of routine SAMISAV
