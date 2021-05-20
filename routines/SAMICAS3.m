SAMICAS3 ;ven/gpl - ielcap: case review page (cont) ;2021-03-17T18:31Z
 ;;18.0;SAMI;**3,9**;;Build 11
 ;;1.18.0.9-i9
 ;
 ; SAMICAS3 contains ppis and other subroutines to support processing
 ; of the VAPALS case review page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@license: see routine SAMIUL
 ;@documentation : see SAMICUL
 ;@contents
 ; WSNFPOST: post new form selection (post service)
 ; MKSBFORM: create background form
 ; $$PREVNOD = key of latest form including nodule grid
 ; $$LASTCMP = date & key of last comparison scan
 ; $$PRIORCMP = dates of all scans before last comparison scan
 ; SORTFRMS: sorts all forms for patient sid by date
 ; MKCEFORM: create ct evaluation form
 ; MKFUFORM: create follow-up form
 ; $$BASELNDT = last previous baseline ct date
 ; MKPTFORM: create pet evaluation form
 ; MKITFORM: create intervention form
 ; MKBXFORM: create biopsy form
 ; CASETBL: generates case review table
 ;
 ;
 ;
 ;@section 1 WSNFPOST & related subroutines
 ;
 ;
 ;
 ;;@ppi WSNFPOST^SAMICAS3, post new form selection (post service)
WSNFPOST ; post new form selection (post service)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@web service
 ; web service SAMICASE-wsNuFormPost
 ;@called by
 ; WSNFPOST^SAMICASE
 ;@calls
 ; parseBody^%wf
 ; GETHOME^SAMIHOM3
 ; $$KEYDATE^SAMIHOM3
 ; $$setroot^%wd
 ; $$KEY2FM^SAMICAS2
 ; MKSBFORM^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKBXFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
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
 ; SAMIUTS2
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
 n collide s collide=0 ; duplicate form for today - backdate forms scenario
 if $data(@root@("graph",sid,nuform_"-"_datekey)) do  ; already exists
 . s collide=1
 . if nuform="siform" quit
 . if nuform="sbform" quit  ; do not create multiple background forms
 . new lastone
 . set lastone=$order(@root@("graph",sid,nuform_"-a  "),-1)
 . quit:lastone=""
 . set newfm=$$KEY2FM^SAMICASE(lastone)
 . set datekey=$$KEYDATE^SAMIHOM3($$FMADD^XLFDT(newfm,1)) ; add one day to the last form
 ;
 ; code to not allow two same forms for a patient a day
 ;
 i collide=1 d  q  ;
 . s ARGS("errorMessage")="Form already exists for today"
 . s ARGS("studyid")=sid
 . d WSCASE^SAMICASE(.RESULT,.ARGS)
 ;
 if nuform="sbform" do  ;
 . new oldkey s oldkey=$o(@root@("graph",sid,"sbform"))
 . i $e(oldkey,1,6)="sbform" d  q  ;
 . . set ARGS("key")=oldkey
 . . set ARGS("studyid")=sid
 . . set ARGS("form")="vapals:sbform"
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
 ;@stanza 3 termination
 ;
 quit  ; end of ppi WSNFPOST^SAMICAS3
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
 ;@input
 ; sid = study id
 ; key =
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
 ; used for nodule copy
 ;
 n retkey s retkey=""
 n fary
 d SORTFRMS(.fary,sid)
 n tdt s tdt=""
 f  s tdt=$o(fary(tdt),-1) q:tdt=""  q:retkey'=""  d  ; 
 . n tmpkey s tmpkey=""
 . f  s tmpkey=$o(fary(tdt,tmpkey)) q:tmpkey=""  q:retkey'=""  d  ; 
 . . i tmpkey["ceform" s retkey=tmpkey
 . . i tmpkey["ptform" s retkey=tmpkey
 . . i tmpkey["bxform" s retkey=tmpkey
 ;
 q retkey ; end of $$PREVNOD
 ;
 ;
 ;
LASTCMP(sid,retkey) ; date & key of last comparison scan
 ;
 ; passed by reference
 ;
 s retkey=""
 n fary
 d SORTFRMS(.fary,sid)
 n tdt s tdt=$P($$NOW^XLFDT,".",1)+1 ; start with today
 f  s tdt=$o(fary(tdt),-1) q:tdt=""  q:retkey'=""  d  ; 
 . n tmpkey s tmpkey=""
 . f  s tmpkey=$o(fary(tdt,tmpkey)) q:tmpkey=""  q:retkey'=""  d  ; 
 . . i tmpkey["ceform" s retkey=tmpkey
 ;
 n retdt s retdt=-1
 i retkey'="" d  ;
 . n fmdt
 . s fmdt=$$KEY2FM^SAMICASE(retkey)
 . s retdt=$$VAPALSDT^SAMICASE(fmdt)
 ;
 q retdt ; end of $$LASTCMP
 ;
 ;
 ;
PRIORCMP(sid) ; dates of all scans before last comparison scan
 ;
 n retstr s retstr=""
 n lastcmp s lastcmp=""
 n fary
 d SORTFRMS(.fary,sid)
 n tdt s tdt=$P($$NOW^XLFDT,".",1)+1 ; start with today
 f  s tdt=$o(fary(tdt),-1) q:tdt=""  d  ; 
 . i lastcmp="" d  ; first find the last comparison scan
 . . n tmpkey s tmpkey=""
 . . f  s tmpkey=$o(fary(tdt,tmpkey)) q:tmpkey=""  q:lastcmp'=""  d  ; 
 . . . i tmpkey["ceform" s lastcmp=tmpkey
 . d  ;
 . . ; next add all previous scans to retstr
 . . n tmpkey2 s tmpkey2=""
 . . f  s tmpkey2=$o(fary(tdt,tmpkey2)) q:tmpkey2=""  d  ; 
 . . . i tmpkey2["ceform" d  ; convert to external date
 . . . . s retstr=$$KEY2DT(tmpkey2)_retstr
 i $e(retstr,$l(retstr))="," s retstr=$e(retstr,1,$l(retstr)-1)
 ;
 q retstr ; end of $$PRIORCMP
 ;
KEY2DT(key) ; extrinsic returns a date to put in the prior scans field
 n retstr2 s retstr2=""
 n fmdt
 s fmdt=$$KEY2FM^SAMICASE(tmpkey2)
 s retstr2=$$VAPALSDT^SAMICASE(fmdt)_","_retstr2
 q retstr2
 ;
 ;
SORTFRMS(ARY,sid) ; sorts all forms for patient sid by date
 ;
 ; and returns in ARY, passed by reference
 ; format of return is ARY(fmdate,key)=""
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 q:'$d(@root@("graph",sid))
 n froot s froot=$na(@root@("graph",sid))
 n zi s zi=""
 f  s zi=$o(@froot@(zi)) q:zi=""  d  ;
 . n ftype s ftype=$p(zi,"-",1)
 . n fdate s fdate=$p(zi,ftype_"-",2)
 . n X,Y
 . s X=fdate
 . D ^%DT
 . i Y=-1 d ^ZTER Q  ;
 . S ARY(Y,zi)=""
 ;
 q  ; end of SORTFRMS
 ;
 ;
 ;
MKCEFORM(sid,key) ; create ct evaluation form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ;@input
 ; sid = study id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"ceform-",2)
 ; nodule copy
 ;n srckey s srckey=$$PREVNOD(sid)
 n srckey,srcdate s srcdate=$$LASTCMP(sid,.srckey)
 i srckey'="" d  ;
 . new target,source
 . set source=$name(@root@("graph",sid,srckey))
 . set target=$name(@root@("graph",sid,key))
 . d CTCOPY^SAMICTC1(source,target)
 ; end nodule copy
 ;new items,prevct
 ;do GETITEMS^SAMICASE("items",sid)
 ;set prevct=""
 ;if $data(items("type","vapals:ceform")) do  ;previous cteval exists
 ;. set prevct=$order(items("type","vapals:ceform",""),-1) ; latest ceform
 ;if prevct'="" do  ;
 ;. new target,source
 ;. set source=$name(@root@("graph",sid,prevct))
 ;. set target=$name(@root@("graph",sid,key))
 ;. do CTCOPY^SAMICTC1(source,target)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ; set baseline CT date and last comparison scan date
 do  ;
 . n basedt
 . s basedt=$$BASELNDT^SAMICAS3(sid)
 . i basedt=-1 s basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . n lastdt s lastdt=$$LASTCMP^SAMICAS3(sid)
 . i lastdt=-1 s lastdt=basedt
 . n priordt s priordt=$$PRIORCMP^SAMICAS3(sid)
 . i priordt=-1 s priordt=lastdt
 . i priordt="" s priordt=lastdt
 . s @root@("graph",sid,key,"sidoe")=basedt
 . s @root@("graph",sid,key,"cedcs")=lastdt
 . s @root@("graph",sid,key,"cedps")=priordt
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
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ;@input
 ; sid = study id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create Follow-up form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"fuform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 set @root@("graph",sid,key,"sidof")=$$KEY2DSPD^SAMICAS2(cdate)
 set @root@("graph",sid,key,"sidoe")=$$BASELNDT(sid)
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKFUFORM
 ;
 ;
 ;
BASELNDT(sid) ; last previous baseline ct date
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 n groot s groot=$na(@root@("graph",sid))
 n items s items=""
 d GETITEMS^SAMICASE("items",sid)
 q:'$d(items) ""
 n bdate s bdate=""
 n bkey s bkey=""
 n done s done=0
 f  s bkey=$o(items("type","vapals:ceform",bkey)) q:bkey=""  d  ;
 . ;w !,bkey," ",$g(@groot@(bkey,"cetex"))
 . if $g(@groot@(bkey,"cetex"))="b" d  ;
 . . s done=1
 . . s bdate=$p(bkey,"ceform-",2)
 s bdate=$$KEY2DSPD^SAMICAS2(bdate)
 ;
 q bdate ; end of $$BASELNDT
 ;
 ;
 ;
MKPTFORM(sid,key) ; create pet evaluation form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ;@input
 ; sid = study id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create pet eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ; nodule copy
 ;n srckey s srckey=$$PREVNOD(sid)
 n srckey,srcdate s srcdate=$$LASTCMP(sid,.srckey)
 i srckey'="" d  ;
 . new target,source
 . set source=$name(@root@("graph",sid,srckey))
 . set target=$name(@root@("graph",sid,key))
 . d CTCOPY^SAMICTC1(source,target)
 ; end nodule copy
 new cdate set cdate=$piece(key,"ptform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 do  ;
 . n basedt
 . s basedt=$$BASELNDT^SAMICAS3(sid)
 . i basedt=-1 s basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . n lastdt s lastdt=$$LASTCMP^SAMICAS3(sid)
 . i lastdt=-1 s lastdt=basedt
 . n priordt s priordt=$$PRIORCMP^SAMICAS3(sid)
 . i priordt=-1 s priordt=lastdt
 . s @root@("graph",sid,key,"sidoe")=basedt
 . ;s @root@("graph",sid,key,"cedcs")=lastdt
 . s @root@("graph",sid,key,"cedos")=lastdt ; it's different than on the ce
 . ;s @root@("graph",sid,key,"cedps")=priordt
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
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ;@input
 ; sid = study id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create intervention form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"itform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
 ;
 do  ;
 . n basedt
 . s basedt=$$BASELNDT^SAMICAS3(sid)
 . i basedt=-1 s basedt=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . n lastdt s lastdt=$$LASTCMP^SAMICAS3(sid)
 . i lastdt=-1 s lastdt=basedt
 . n priordt s priordt=$$PRIORCMP^SAMICAS3(sid)
 . i priordt=-1 s priordt=lastdt
 . s @root@("graph",sid,key,"sidoe")=basedt
 . ;s @root@("graph",sid,key,"cedcs")=lastdt
 . s @root@("graph",sid,key,"cedos")=lastdt ; it's different than on the ce
 . ;s @root@("graph",sid,key,"cedps")=priordt
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
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNFPOST^SAMICAS3
 ;@calls
 ; $$setroot^%wd
 ; $$SID2NUM^SAMIHOM3
 ;@input
 ; sid = study id
 ; key =
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
 new cdate set cdate=$piece(key,"bxform-",2)
 ; nodule copy
 ;n srckey s srckey=$$PREVNOD(sid)
 n srckey,srcdate s srcdate=$$LASTCMP(sid,.srckey)
 i srckey'="" d  ;
 . new target,source
 . set source=$name(@root@("graph",sid,srckey))
 . set target=$name(@root@("graph",sid,key))
 . d CTCOPY^SAMICTC1(source,target)
 ; end nodule copy
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 do SSAMISTA^SAMICASE(sid,key,"incomplete")
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
 ;ven/gpl;private;procedure;
 ;@called by : none
 ;@calls
 ;@input
 ; ary = name of array (passed by name, will be cleared)
 ;@output
 ; @ary
 ;@tests
 ; SAMIUTS2
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
 ;@stanza 3 termination
 ;
 quit  ; end of CASETBL
 ;
 ;
 ;
EOR ; end of routine SAMICAS3
