SAMICAS3 ;ven/gpl - case review cont ;2021-10-26t19:39z
 ;;18.0;SAMI;**3,9,11,12,15**;2020-01;Build 11
 ;;18-15
 ;
 ; SAMICAS3 contains ppis and other subroutines to support processing
 ; of the VAPALS-IELCAP case review page.
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
 ;@contents
 ; WSNFPOST wri-code WSNFPOST^SAMICAS3, post vapals addform: new form
 ; MKSBFORM create background form
 ;
 ; $$PREVNOD key of latest form including nodule grid
 ; $$LASTCMP date & key of last comparison scan
 ; $$PRIORCMP dates of all scans before last comparison scan
 ; $$KEY2DT date to put in prior scans field
 ; SORTFRMS sorts all forms for patient sid by date
 ;
 ; MKCEFORM create ct evaluation form
 ; MKFUFORM create follow-up form
 ; $$BASELNDT last previous baseline ct date
 ; MKPTFORM create pet evaluation form
 ; MKITFORM create intervention form
 ; MKBXFORM create biopsy form
 ; CASETBL generates case review table
 ;
 ;
 ;
 ;@section 1 WSNFPOST & related subroutines
 ;
 ;
 ;
 ;@wri-code WSNFPOST^SAMICAS3
WSNFPOST ; post vapals addform: new form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wri;procedure;clean;silent;sac;??% tests
 ;@signature
 ; do WSNFPOST^SAMICASE(ARGS,BODY,RESULT)
 ;@branches-from
 ; WSNFPOST^SAMICASE
 ;@ppi-called-by
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
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKBXFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
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
 if nuform="sbform" do  ;
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
 . do MKSBFORM(sid,key)
 . quit
 ;
 if nuform="ceform" do  ;
 . new key set key="ceform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:ceform"
 . do MKCEFORM(sid,key)
 . quit
 ;
 if nuform="fuform" do  ;
 . new key set key="fuform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:fuform"
 . do MKFUFORM(sid,key)
 . quit
 ;
 if nuform="bxform" do  ;
 . new key set key="bxform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:bxform"
 . do MKBXFORM(sid,key)
 . quit
 ;
 if nuform="ptform" do  ;
 . new key set key="ptform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:ptform"
 . do MKPTFORM(sid,key)
 . quit
 ;
 if nuform="itform" do  ;
 . new key set key="itform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:itform"
 . do MKITFORM(sid,key)
 . quit
 ;
 do wsGetForm^%wf(.RESULT,.ARGS)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wri WSNFPOST^SAMICASE
 ;
 ;
 ;
MKSBFORM(sid,key) ; create background form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
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
 ;@tests [tbd]
 ;
 ;@stanza 2 create background form
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
PREVNOD(sid) ; key of latest form including nodule grid
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;
 ;@called-by none [commented out in MKCEFORM,MKPTFORM,MKBXFORM]
 ;@calls
 ; SORTFRMS
 ;@input
 ; sid = study id
 ;@output = key of latest form incl nodule grid
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; used for nodule copy
 ;
 ;
 ;@stanza 2 calculate key of latest form incl nodule grid
 ;
 new retkey set retkey=""
 new fary
 do SORTFRMS(.fary,sid)
 ;
 new tdt set tdt=""
 for  set tdt=$order(fary(tdt),-1) quit:tdt=""  quit:retkey'=""  do  ; 
 . new tmpkey set tmpkey=""
 . for  set tmpkey=$order(fary(tdt,tmpkey)) quit:tmpkey=""  quit:retkey'=""  do  ; 
 . . if tmpkey["ceform" set retkey=tmpkey
 . . if tmpkey["ptform" set retkey=tmpkey
 . . if tmpkey["bxform" set retkey=tmpkey
 . . quit
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit retkey ; end of $$PREVNOD
 ;
 ;
 ;
LASTCMP(sid,retkey) ; date & key of last comparison scan
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;
 ;@called-by
 ; MKBXFORM
 ; MKCEFORM
 ; MKFUFORM
 ; MKITFORM
 ; MKPTFORM
 ;@calls
 ; SORTFRMS
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
 ;@stanza 2 calculate date & key of last comparison scan
 ;
 set retkey=""
 new fary
 do SORTFRMS(.fary,sid)
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
PRIORCMP(sid) ; dates of all scans before last comparison scan
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;
 ;@called-by
 ; MKCEFORM
 ; MKPTFORM
 ; MKITFORM
 ;@calls
 ; SORTFRMS
 ; $$NOW^XLFDT
 ; $$KEY2DT
 ; $$VAPALSDT^SAMICASE
 ;@input
 ; sid = study id
 ;@output = dates of all scans before last comparison scan
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 calculate dates of all scans before last comparison scan
 ;
 new retstr set retstr=""
 new lastcmp set lastcmp=""
 new fary
 do SORTFRMS(.fary,sid)
 ;
 ;new tdt set tdt=$piece($$NOW^XLFDT,".",1)+1 ; start with today
 new tdt set tdt=$piece($$NOW^XLFDT,".",1) ; start with before today
 for  set tdt=$order(fary(tdt),-1) quit:tdt=""  do  ; 
 . ;
 . if lastcmp="" do  ; first find the last comparison scan
 . . new tmpkey set tmpkey=""
 . . for  set tmpkey=$order(fary(tdt,tmpkey)) quit:tmpkey=""  quit:lastcmp'=""  do  ; 
 . . . if tmpkey["ceform" set lastcmp=tmpkey
 . . . quit
 . . quit
 . ;
 . do  ;
 . . ; next add all previous scans to retstr
 . . new tmpkey2 set tmpkey2=""
 . . for  set tmpkey2=$order(fary(tdt,tmpkey2)) quit:tmpkey2=""  do  ; 
 . . . if tmpkey2["ceform" do  ; convert to external date
 . . . . set retstr=$$KEY2DT(tmpkey2)_retstr
 . . . . quit
 . . . quit
 . . quit
 . quit
 ;
 if $extract(retstr,$length(retstr))="," do
 . set retstr=$extract(retstr,1,$length(retstr)-1)
 . quit
 ;
 ;if retstr="" set retstr=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit retstr ; end of $$PRIORCMP
 ;
 ;
 ;
KEY2DT(key) ; date to put in prior scans field
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;
 ;@called-by
 ; $$PRIORCMP
 ;@calls
 ; $$KEY2FM^SAMICASE
 ; $$VAPALSDT^SAMICASE
 ;@input
 ; key = form key, e.g. ctform-2021-05-25
 ;@output = date to put in prior scans field
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 calculate prior scans date
 ;
 new retstr2 set retstr2=""
 new fmdt set fmdt=$$KEY2FM^SAMICASE(tmpkey2)
 set retstr2=$$VAPALSDT^SAMICASE(fmdt)_","_retstr2
 ;
 ;
 ;@stanza 3 termination
 ;
 quit retstr2 ; end of $$KEY2DT
 ;
 ;
 ;
SORTFRMS(ARY,sid) ; sorts all forms for patient sid by date
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;
 ;@called-by
 ; $$PREVNOD
 ; $$LASTCMP
 ; $$PRIORCMP
 ;@calls
 ; $$setroot^%wd
 ; ^%DT
 ; ^%ZTER
 ;@input
 ; sid = study id
 ;@output
 ; .ARY: sorted array of all forms for patient by date
 ;  ARY(fmdate,key)=""
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 sort patient's forms by date
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 quit:'$data(@root@("graph",sid))
 new froot set froot=$name(@root@("graph",sid))
 ;
 new zi set zi=""
 for  set zi=$order(@froot@(zi)) quit:zi=""  do  ;
 . new ftype set ftype=$piece(zi,"-",1)
 . new fdate set fdate=$piece(zi,ftype_"-",2)
 . new X,Y
 . set X=fdate
 . do ^%DT
 . if Y=-1 do ^%ZTER quit  ;
 . set ARY(Y,zi)=""
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of SORTFRMS
 ;
 ;
 ;
MKCEFORM(sid,key) ; create ct evaluation form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$LASTCMP
 ; CTCOPY^SAMICTC1
 ; SSAMISTA^SAMICASE
 ; $$BASELNDT^SAMICAS3
 ; $$VAPALSDT^SAMICASE
 ; $$LASTCMP^SAMICAS3
 ; $$PRIORCMP^SAMICAS3
 ;@input
 ; sid = study id
 ; key = form key, e.g. ceform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"ceform-",2)
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD(sid)
 new srckey,srcdate set srcdate=$$LASTCMP(sid,.srckey)
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
 . set basedt=$$BASELNDT^SAMICAS3(sid)
 . if basedt=-1 set basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . new lastdt set lastdt=$$LASTCMP^SAMICAS3(sid)
 . if lastdt=-1 set lastdt=""
 . new priordt set priordt=$$PRIORCMP^SAMICAS3(sid)
 . if priordt=-1 set priordt=lastdt
 . if priordt="" set priordt=lastdt
 . set @root@("graph",sid,key,"sidoe")=basedt
 . set @root@("graph",sid,key,"cedcs")=lastdt
 . set @root@("graph",sid,key,"cedps")=priordt
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKCEFORM
 ;
 ;
 ;
MKFUFORM(sid,key) ; create Follow-up form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$KEY2DSPD^SAMICAS2
 ; $$BASELNDT
 ; $$LASTCMP
 ; $$NOW^XLFDT
 ; $$VAPALSDT^SAMICASE
 ; SSAMISTA^SAMICASE
 ;@input
 ; sid = study id
 ; key = form key, e.g. fuform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 create Follow-up form
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
 set basedt=$$BASELNDT^SAMICAS3(sid)
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
BASELNDT(sid) ; last previous baseline ct date
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac
 ;@called-by
 ; MKCEFORM
 ; MKFUFORM
 ; MKPTFORM
 ; MKITFORM
 ;@calls
 ; $$setroot^%wd
 ; GETITEMS^SAMICASE
 ; $$KEY2DSPD^SAMICAS2
 ;@input
 ; sid = study id
 ;@output = last previous baseline ct date
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 calculate last previous baseline ct date
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new groot set groot=$name(@root@("graph",sid))
 new items set items=""
 do GETITEMS^SAMICASE("items",sid)
 quit:'$data(items) ""
 ;
 new bdate set bdate=""
 new bkey set bkey=""
 new done set done=0
 for  set bkey=$order(items("type","vapals:ceform",bkey)) quit:bkey=""  do  ;
 . ; write !,bkey," ",$get(@groot@(bkey,"cetex"))
 . if $get(@groot@(bkey,"cetex"))="b" do  ;
 . . set done=1
 . . set bdate=$piece(bkey,"ceform-",2)
 . . quit
 . quit
 set bdate=$$KEY2DSPD^SAMICAS2(bdate)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit bdate ; end of $$BASELNDT
 ;
 ;
 ;
MKPTFORM(sid,key) ; create pet evaluation form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$LASTCMP
 ; CTCOPY^SAMICTC1
 ; SSAMISTA^SAMICASE
 ; $$BASELNDT^SAMICAS3
 ; $$VAPALSDT^SAMICASE
 ; $$LASTCMP^SAMICAS3
 ; $$PRIORCMP^SAMICAS3
 ;@input
 ; sid = study id
 ; key = form key, e.g. ptform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 create pet eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD(sid)
 new srckey,srcdate set srcdate=$$LASTCMP(sid,.srckey)
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
 . set basedt=$$BASELNDT^SAMICAS3(sid)
 . if basedt=-1 set basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . new lastdt set lastdt=$$LASTCMP^SAMICAS3(sid)
 . if lastdt=-1 set lastdt=basedt
 . new priordt set priordt=$$PRIORCMP^SAMICAS3(sid)
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
MKITFORM(sid,key) ; create intervention form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$PREVNODE [commented out]
 ; $$LASTCMP
 ; CTCOPY^SAMICTC1
 ; SSAMISTA^SAMICASE
 ; $$BASELNDT^SAMICAS3
 ; $$VAPALSDT^SAMICASE
 ; $$LASTCMP^SAMICAS3
 ; $$PRIORCMP^SAMICAS3
 ;@input
 ; sid = study id
 ; key = form key, e.g. itform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 create intervention form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 new cdate set cdate=$piece(key,"itform-",2)
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD(sid)
 new srckey,srcdate set srcdate=$$LASTCMP(sid,.srckey)
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
 . set basedt=$$BASELNDT^SAMICAS3(sid)
 . if basedt=-1 set basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . new lastdt set lastdt=$$LASTCMP^SAMICAS3(sid)
 . if lastdt=-1 set lastdt=basedt
 . new priordt set priordt=$$PRIORCMP^SAMICAS3(sid)
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
MKBXFORM(sid,key) ; create biopsy form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ; $$LASTCMP
 ; CTCOPY^SAMICTC1
 ; SSAMISTA^SAMICASE
 ;@input
 ; sid = study id
 ; key = form key, e.g. bxform-2021-05-25
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 create background form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"bxform-",2)
 ;
 ; nodule copy
 ; new srckey set srckey=$$PREVNOD(sid)
 new srckey,srcdate set srcdate=$$LASTCMP(sid,.srckey)
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
CASETBL(ary) ; generates case review table
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac
 ;@called by none
 ;@calls
 ;@input
 ; ary = name of array (passed by name, will be cleared)
 ;@output
 ; @ary
 ;@tests
 ; SAMIUTS2
 ;
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
