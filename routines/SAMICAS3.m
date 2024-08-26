SAMICAS3 ;ven/gpl - case review cont; 2024-08-22t21:02z
 ;;18.0;SAMI;**3,9,11,12,15,17**;2020-01-17;
 ;mdc-e1;SAMICAS3-20240822-E02krUP;SAMI-18-17-b6
 ;mdc-v7;B334055891;SAMI*18.0*17 SEQ #17
 ;
 ; SAMICAS3 contains ppses and other subroutines to support processing
 ; of the ScreeningPlus case review page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@license see routine SAMIUL
 ;@documentation see SAMICUL
 ;
 ;@contents
 ;
 ;  1. New Form web-route service:
 ; WSNFPOST wrs-code WSNFPOST^SAMICAS3,
 ;  post screeningplus addform: new form
 ;
 ;  2. main form-creation procedures:
 ; MKSBFORM create background form
 ; MKBXFORM create biopsy form
 ; MKCEFORM create ct evaluation form
 ; MKFUFORM create follow-up form
 ; MKITFORM create intervention form
 ; MKPTFORM create pet evaluation form
 ;
 ;  3. supplementary subroutine:
 ; $$LASTCMP date & key of last comparison scan
 ;
 ;  4. unused supplementary subroutine:
 ; CASETBL generates case review table
 ;
 ;
 ;
 ;
 ;@section 1 New Form web-route service WSNFPOST^SAMICAS3
 ;
 ;
 ;
 ;
 ;@wrs-code WSNFPOST^SAMICAS3
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wrs;procedure;clean;silent;sac;??% tests;port?
 ;@signature
 ; do WSNFPOST^SAMICASE(ARGS,BODY,RESULT)
 ;@branches-from
 ; WSNFPOST^SAMICASE
 ;@pps-called-by
 ; WSVAPALS^SAMIHOME [wr addform of ws post vapals]
 ;@called-by none
 ;@calls
 ; parseBody^%wf
 ; GETHOME^SAMIHOM3
 ; $$KEYDATE^SAMIHOM3
 ; $$setroot^%wd
 ; $$KEY2FM^SAMICAS2
 ; $$FMADD^XLFDT
 ; WSCASE^SAMICASE
 ; MKSBFORM^SAMICAS3
 ; MKBXFORM^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; wsGetForm^%wf
 ;@input
 ; .ARGS
 ; .ARGS("form")
 ; .ARGS("studyid")
 ; .ARGS("sid")
 ; .BODY
 ; .BODY(1) (e.g. "samiroute=casereview&dfn="_dfn_"&studyid="_studyid)
 ;@output
 ; @RESULT
 ;@tests
 ; UTNFPST^SAMIUTS2
 ;
 ;
WSNFPOST ; post screeningplus addform: new form
 ;
 ;@stanza 2 get new form
 ;
 new vars,bdy
 set bdy=$get(BODY(1))
 do parseBody^%wf("vars",.bdy)
 merge vars=ARGS
 merge ^SAMIUL("nuform","vars")=vars
 ;
 new sid set sid=$get(vars("studyid"))
 if sid="" set sid=$get(ARGS("sid"))
 if sid="" do  quit  ;
 . do GETHOME^SAMIHOM3(.RESULT,.ARGS) ; on error return to home page
 . quit
 ;
 set nuform=$get(vars("form"))
 if nuform="" set nuform="ceform"
 ;
 new datekey set datekey=$$KEYDATE^SAMIHOM3($$NOW^XLFDT)
 ;
 ; check to see if form already exists
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new collide set collide=0 ; duplicate form for today - backdate forms scenario
 if $data(@root@("graph",sid,nuform_"-"_datekey)) do  ; already exists
 . set collide=1
 . if nuform="siform" quit
 . if nuform="sbform" quit  ; do not create multiple background forms
 . new lastone
 . set lastone=$order(@root@("graph",sid,nuform_"-a  "),-1)
 . quit:lastone=""
 . set newfm=$$KEY2FM^SAMICASE(lastone)
 . set datekey=$$KEYDATE^SAMIHOM3($$FMADD^XLFDT(newfm,1)) ; add one day to the last form
 . quit
 ;
 ; code to not allow two same forms for a patient a day
 ;
 if collide=1 do  quit  ;
 . set ARGS("errorMessage")="Form already exists for today"
 . set ARGS("studyid")=sid
 . do WSCASE^SAMICASE(.RESULT,.ARGS)
 . quit
 ;
 if nuform="sbform" do  ; make background form
 . new oldkey set oldkey=$order(@root@("graph",sid,"sbform"))
 . if $extract(oldkey,1,6)="sbform" do  quit  ;
 . . set ARGS("key")=oldkey
 . . set ARGS("studyid")=sid
 . . set ARGS("form")="vapals:sbform"
 . . quit
 . new key set key="sbform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:sbform"
 . do MKSBFORM^SAMICAS3(sid,key)
 . quit
 ;
 if nuform="bxform" do  ; make biopsy form
 . new key set key="bxform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:bxform"
 . do MKBXFORM^SAMICAS3(sid,key)
 . quit
 ;
 if nuform="ceform" do  ; make ct eval form
 . new key set key="ceform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:ceform"
 . do MKCEFORM^SAMICAS3(sid,key)
 . quit
 ;
 if nuform="fuform" do  ; make followup form
 . new key set key="fuform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:fuform"
 . do MKFUFORM^SAMICAS3(sid,key)
 . quit
 ;
 if nuform="itform" do  ; make intervention form
 . new key set key="itform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:itform"
 . do MKITFORM^SAMICAS3(sid,key)
 . quit
 ;
 if nuform="ptform" do  ; make pet eval form
 . new key set key="ptform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:ptform"
 . do MKPTFORM^SAMICAS3(sid,key)
 . quit
 ;
 do wsGetForm^%wf(.RESULT,.ARGS)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wrs WSNFPOST^SAMICASE
 ;
 ;
 ;
 ;
 ;@section 2 main form-creation procedures
 ;
 ;
 ;
 ;
 ;@proc-code MKSBFORM background
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean?;silent;sac?;??% tests;port?
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; SSAMISTA^SAMICASE
 ;@input
 ; sid = study id
 ; key = form key, e.g. sbform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests
 ; UTMKSBF^SAMIUTS2
 ;
 ;
MKSBFORM(sid,key) ; create background form
 ;
 ;@stanza 2 make it
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 new cdate set cdate=$piece(key,"sbform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKSBFORM
 ;
 ;
 ;
 ;
 ;@proc-code MKBXFORM biopsy
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$PREVNOD^SAMICAS4 [commented out]
 ; $$LASTCMP^SAMICAS3
 ; CTCOPY^SAMICTC1
 ; SSAMISTA^SAMICASE
 ;@input
 ; sid = study id
 ; key = form key, e.g. bxform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests
 ; UTMKBXF^SAMIUTS2
 ;
 ;
MKBXFORM(sid,key) ; create biopsy form
 ;
 ;@stanza 2 make it
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"bxform-",2)
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD^SAMICAS4(sid)
 new srckey,srcdate set srcdate=$$LASTCMP^SAMICAS3(sid,.srckey)
 if srckey'="" do  ;
 . new source set source=$name(@root@("graph",sid,srckey))
 . new target set target=$name(@root@("graph",sid,key))
 . do CTCOPY^SAMICTC1(source,target,key)
 . quit
 ; end nodule copy
 ;
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKBXFORM
 ;
 ;
 ;
 ;
 ;@proc-code MKCEFORM ct evaluation
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$PREVNOD^SAMICAS4 [commented out]
 ; $$LASTCMP^SAMICAS3
 ; CTCOPY^SAMICTC1
 ; GETITEMS^SAMICASE [commented out]
 ; SSAMISTA^SAMICASE
 ; $$BASELNDT^SAMICAS4
 ; $$VAPALSDT^SAMICASE
 ; $$PRIORCMP^SAMICAS4
 ; $$CLINSUM^SAMICAS4
 ;@input
 ; sid = study id
 ; key = form key, e.g. ceform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests
 ; UTMKCEF^SAMIUTS2
 ;
 ;
MKCEFORM(sid,key) ; create ct evaluation form
 ;
 ;@stanza 2 make it
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"ceform-",2)
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD^SAMICAS4(sid)
 new srckey,srcdate set srcdate=$$LASTCMP^SAMICAS3(sid,.srckey)
 if srckey'="" do  ;
 . new source set source=$name(@root@("graph",sid,srckey))
 . new target set target=$name(@root@("graph",sid,key))
 . do CTCOPY^SAMICTC1(source,target,key)
 . quit
 ; end nodule copy
 ;
 ; new items,prevct
 ; do GETITEMS^SAMICASE("items",sid)
 ; set prevct=""
 ; if $data(items("type","vapals:ceform")) do  ; previous cteval exists
 ; . set prevct=$order(items("type","vapals:ceform",""),-1) ; latest ceform
 ; . quit
 ; if prevct'="" do  ;
 ; . new target,source
 ; . set source=$name(@root@("graph",sid,prevct))
 ; . set target=$name(@root@("graph",sid,key))
 ; . do CTCOPY^SAMICTC1(source,target,key)
 ; . quit
 ;
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 ; set baseline CT date and last comparison scan date
 do  ;
 . new basedt
 . set basedt=$$BASELNDT^SAMICAS4(sid)
 . if basedt=-1 set basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . new lastdt set lastdt=$$LASTCMP^SAMICAS3(sid)
 . if lastdt=-1 set lastdt=""
 . new priordt set priordt=$$PRIORCMP^SAMICAS4(sid)
 . if priordt=-1 set priordt=lastdt
 . if priordt="" set priordt=lastdt
 . set @root@("graph",sid,key,"sidoe")=basedt
 . set @root@("graph",sid,key,"cedcs")=lastdt
 . set @root@("graph",sid,key,"cedps")=priordt
 . ;
 . ; set clinical information line for billing
 . set @root@("graph",sid,key,"ceclin")=$$CLINSUM^SAMICAS4(sid)
 . quit
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKCEFORM
 ;
 ;
 ;
 ;
 ;@proc-code MKFUFORM followup
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$KEY2DSPD^SAMICAS2
 ; $$BASELNDT^SAMICAS4
 ; $$LASTCMP^SAMICAS3
 ; $$NOW^XLFDT
 ; $$VAPALSDT^SAMICASE
 ; SSAMISTA^SAMICASE
 ;@input
 ; sid = study id
 ; key = form key, e.g. fuform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests
 ; UTMKFUF^SAMIUTS2
 ;
 ;
MKFUFORM(sid,key) ; create followup form
 ;
 ;@stanza 2 make it
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 new cdate set cdate=$piece(key,"fuform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 ;
 set @root@("graph",sid,key,"samicreatedate")=cdate
 set @root@("graph",sid,key,"sidof")=$$KEY2DSPD^SAMICAS2(cdate)
 new basedt
 set basedt=$$BASELNDT^SAMICAS4(sid)
 if basedt=-1 set basedt=$$LASTCMP^SAMICAS3(sid)
 if basedt=-1 set basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 set @root@("graph",sid,key,"sidoe")=basedt
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKFUFORM
 ;
 ;
 ;
 ;
 ;@proc-code MKITFORM intervention
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$PREVNODE^SAMICAS4 [commented out]
 ; $$LASTCMP^SAMICAS3
 ; CTCOPY^SAMICTC1
 ; SSAMISTA^SAMICASE
 ; $$BASELNDT^SAMICAS4
 ; $$VAPALSDT^SAMICASE
 ; $$PRIORCMP^SAMICAS4
 ;@input
 ; sid = study id
 ; key = form key, e.g. itform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests
 ; UTMKITF^SAMIUTS2
 ;
 ;
MKITFORM(sid,key) ; create intervention form
 ;
 ;@stanza 2 make it
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 new cdate set cdate=$piece(key,"itform-",2)
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD^SAMICAS4(sid)
 new srckey,srcdate set srcdate=$$LASTCMP^SAMICAS3(sid,.srckey)
 if srckey'="" do  ;
 . new source set source=$name(@root@("graph",sid,srckey))
 . new target set target=$name(@root@("graph",sid,key))
 . do CTCOPY^SAMICTC1(source,target,key)
 . quit
 ; end nodule copy
 ;
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 do  ;
 . new basedt
 . set basedt=$$BASELNDT^SAMICAS4(sid)
 . if basedt=-1 set basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . new lastdt set lastdt=$$LASTCMP^SAMICAS3(sid)
 . if lastdt=-1 set lastdt=basedt
 . new priordt set priordt=$$PRIORCMP^SAMICAS4(sid)
 . if priordt=-1 set priordt=lastdt
 . set @root@("graph",sid,key,"sidoe")=basedt
 . ; set @root@("graph",sid,key,"cedcs")=lastdt
 . set @root@("graph",sid,key,"cedos")=lastdt ; it's different than on the ce
 . ; set @root@("graph",sid,key,"cedps")=priordt
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKITFORM
 ;
 ;
 ;
 ;
 ;@proc-code MKPTFORM pet evaluation
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$LASTCMP^SAMICAS3
 ; CTCOPY^SAMICTC1
 ; SSAMISTA^SAMICASE
 ; $$BASELNDT^SAMICAS4
 ; $$VAPALSDT^SAMICASE
 ; $$PRIORCMP^SAMICAS4
 ;@input
 ; sid = study id
 ; key = form key, e.g. ptform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests
 ; UTMKPTF^SAMIUTS2
 ;
 ;
MKPTFORM(sid,key) ; create pet evaluation form
 ;
 ;@stanza 2 make it
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD^SAMICAS4(sid)
 new srckey,srcdate set srcdate=$$LASTCMP^SAMICAS3(sid,.srckey)
 if srckey'="" do  ;
 . new source set source=$name(@root@("graph",sid,srckey))
 . new target set target=$name(@root@("graph",sid,key))
 . do CTCOPY^SAMICTC1(source,target,key)
 . quit
 ; end nodule copy
 ;
 new cdate set cdate=$piece(key,"ptform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 do  ;
 . new basedt
 . set basedt=$$BASELNDT^SAMICAS4(sid)
 . if basedt=-1 set basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . new lastdt set lastdt=$$LASTCMP^SAMICAS3(sid)
 . if lastdt=-1 set lastdt=basedt
 . new priordt set priordt=$$PRIORCMP^SAMICAS4(sid)
 . if priordt=-1 set priordt=lastdt
 . set @root@("graph",sid,key,"sidoe")=basedt
 . ; set @root@("graph",sid,key,"cedcs")=lastdt
 . set @root@("graph",sid,key,"cedos")=lastdt ; it's different than on the ce
 . ; set @root@("graph",sid,key,"cedps")=priordt
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKPTFORM
 ;
 ;
 ;
 ;
 ;@section 3 supplementary subroutine
 ;
 ;
 ;
 ;
 ;@func-code $$LASTCMP
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;??% tests;port?
 ;@called-by
 ; MKBXFORM^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; NOTE^SAMINOT2
 ;@calls
 ; SORTFRMS^SAMICAS4
 ; $$NOW^XLFDT
 ; $$KEY2FM^SAMICASE
 ; $$VAPALSDT^SAMICASE
 ;@input
 ; sid = study id
 ;@output = date of last comparison scan
 ; .retkey = key of last comparison scan
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
LASTCMP(sid,retkey) ; date & key of last comparison scan
 ;
 ;@stanza 2 calculate date & key of last comparison scan
 ;
 set retkey=""
 new fary
 do SORTFRMS^SAMICAS4(.fary,sid)
 ;
 ;new tdt set tdt=$piece($$NOW^XLFDT,".",1)+1 ; start with today
 new tdt set tdt=$piece($$NOW^XLFDT,".",1) ; start with before today
 for  set tdt=$order(fary(tdt),-1) quit:tdt=""  quit:retkey'=""  do  ; 
 . new tmpkey set tmpkey=""
 . for  set tmpkey=$order(fary(tdt,tmpkey)) quit:tmpkey=""  quit:retkey'=""  do  ; 
 . . if tmpkey["ceform" set retkey=tmpkey
 . . quit
 . quit
 ;
 new retdt set retdt=-1
 if retkey'="" do  ;
 . new fmdt set fmdt=$$KEY2FM^SAMICASE(retkey)
 . set retdt=$$VAPALSDT^SAMICASE(fmdt)
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit retdt ; end of $$LASTCMP
 ;
 ;
 ;
 ;
 ;@section 4 unused supplementary subroutine
 ;
 ;
 ;
 ;
 ;@proc-code CASETBL
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port
 ;@called by none
 ;@calls none
 ;@input
 ; ary = name of array (passed by name, will be cleared)
 ;@output
 ; @ary: see code below
 ;@tests
 ; UTCSRT^SAMIUTS2
 ;  note: CASETBL can't be moved to routine SAMICAS4 until
 ;  UTCSRT^SAMIUTS2 can be changed at the same time to call it there,
 ;  or call it as a service in SAMICASE.
 ;
 ;
CASETBL(ary) ; generates case review table
 ;
 ;@stanza 2 build table
 ;
 kill @ary
 ;
 set @ary@("siform","form")="siform"
 set @ary@("siform","js")="subPr"
 set @ary@("siform","name")="Intake"
 set @ary@("siform","image")="preview.gif"
 ;
 set @ary@("nuform","form")="nuform"
 set @ary@("nuform","js")="subFr"
 set @ary@("nuform","name")="New Form"
 set @ary@("nuform","image")="nform.gif"
 ;
 set @ary@("sched","form")="sched"
 set @ary@("sched","js")="subSc"
 set @ary@("sched","name")="Schedule"
 set @ary@("sched","image")="schedule.gif"
 ;
 set @ary@("sbform","form")="sbform"
 set @ary@("sbform","js")="subPr"
 set @ary@("sbform","name")="Background"
 set @ary@("sbform","image")="preview.gif"
 ;
 set @ary@("ceform","form")="ceform"
 set @ary@("ceform","js")="subPr"
 set @ary@("ceform","name")="CT Evaluation"
 set @ary@("ceform","image")="preview.gif"
 ;
 set @ary@("report","form")="report"
 set @ary@("report","js")="subRp"
 set @ary@("report","name")="Report"
 set @ary@("report","image")="report.gif"
 ;
 set @ary@("ptform","form")="ptform"
 set @ary@("ptform","js")="subPr"
 set @ary@("ptform","name")="PET Evaluation"
 set @ary@("ptform","image")="preview.gif"
 ;
 set @ary@("bxform","form")="bxform"
 set @ary@("bxform","js")="subPr"
 set @ary@("bxform","name")="Biopsy"
 set @ary@("bxform","image")="preview.gif"
 ;
 set @ary@("rbform","form")="rbform"
 set @ary@("rbform","js")="subPr"
 set @ary@("rbform","name")="Intervention"
 set @ary@("rbform","image")="preview.gif"
 ;
 set @ary@("ceform","form")="ceform"
 set @ary@("ceform","js")="subPr"
 set @ary@("ceform","name")="CT Evaluation"
 set @ary@("ceform","image")="preview.gif"
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of CASETBL
 ;
 ;
 ;
EOR ; end of routine SAMICAS3
