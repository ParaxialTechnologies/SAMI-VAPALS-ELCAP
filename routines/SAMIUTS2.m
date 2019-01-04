SAMIUTS2 ;ven/lgc - UNIT TEST for SAMICAS2 ; 1/3/19 3:54pm
 ;;18.0;SAMI;;
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 ;
STARTUP n utsuccess
 Q
SETUP Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTGTMPL ; @TEST - get html template
 ;GETTMPL(return,form)
 n temp,SAMIUPOO
 d GETTMPL^SAMICAS2("temp","vapals:casereview")
 d PLUTARR^SAMIUTST(.SAMIUPOO,"UTGTMPL^SAMIUTS2")
 s utsuccess=1
 n nodep,nodet s nodep=$na(SAMIUPOO),nodet=$na(temp)
 f  s nodep=$q(@nodep),nodet=$q(@nodet) q:nodep=""  d  q:'utsuccess
 .; ignore the one node in arrays that have a date as
 .;  we can't know ahead of time what date the unit test
 .;  will be run on
 . i $E($tr(@nodep,""""" "),1,10)?4N1"."2N1"."2N q
 . i (@nodep["meta content") q
 . i '(@nodep=@nodet) s utsuccess=0
 i '(nodet="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing getting vapals:casereview template FAILED!")
 q
 ;
UTHMNY ; @TEST - extrinsic returns how many forms the patient has used before deleting a patient
 ;CNTITEMS(sid)
 n rootut,rootvp,gienut,dfn,gienvp,studyid,uforms,forms
 ; get test patient
 s rootut=$$setroot^%wd("vapals unit tests")
 s gienut=$O(@rootut@("B","patient-lookup test patient",0))
 s dfn=@rootut@(gienut,"dfn")
 ; get studyid on patient
 set rootvp=$$setroot^%wd("vapals-patients")
 s gienvp=$O(@rootvp@("dfn",dfn,0))
 i '$g(gienvp) d  q
 . D FAIL^%ut("Test patient not found in vapals-patients Graphstore")
 s studyid=$G(@rootvp@(gienvp,"sisid"))
 i '$l($g(studyid)) d  q
 . D FAIL^%ut("Test patient did not have studyid in vapals-patients Graphstore")
 ; get number of forms on test patient
 n uforms,forms,zi s uforms=0,zi=""
 f  s zi=$o(@rootvp@("graph",studyid,zi)) q:zi=""  d
 . s uforms=uforms+1
 s forms=$$CNTITEMS^SAMICAS2(studyid)
 s utsuccess=(uforms=forms)
 D CHKEQ^%ut(utsuccess,1,"Testing getting how many forms for patient FAIL!")
 q
 ;
UTCNTITM ; @TEST - get items available for studyid
 ;GETITEMS(ary,sid)
 n rootut,rootvp,gienut,dfn,gienvp,studyid,uforms,forms
 ; get test patient
 s rootut=$$setroot^%wd("vapals unit tests")
 s gienut=$O(@rootut@("B","patient-lookup test patient",0))
 s dfn=@rootut@(gienut,"dfn")
 ; get studyid on patient
 set rootvp=$$setroot^%wd("vapals-patients")
 s gienvp=$O(@rootvp@("dfn",dfn,0))
 i '$g(gienvp) d  q
 . D FAIL^%ut("Test patient not found in vapals-patients Graphstore")
 s studyid=$G(@rootvp@(gienvp,"sisid"))
 i '$l($g(studyid)) d  q
 . D FAIL^%ut("Test patient did not have studyid in vapals-patients Graphstore")
 ; get number of forms on test patient
 n uforms,forms,zi s uforms=0,zi=""
 f  s zi=$o(@rootvp@("graph",studyid,zi)) q:zi=""  d
 . s uforms(zi)=""
 d GETITEMS^SAMICAS2("SAMIUPOO",studyid)
 s utsuccess=1
 s zi="" f  s zi=$o(uforms(zi)) q:zi=""  d
 . i '$d(SAMIUPOO(zi)) s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing getting available forms for patient FAILED!")
 q
 ;
UTGDTK ; @TEST - date portion of form key
 ;getDateKey(formid)
 n fdtkey s fdtkey=$$GETDTKEY^SAMICAS2("MYFORM-2018-10-03")
 D CHKEQ^%ut(fdtkey,"2018-10-03","Testing get date portion of form  FAILED!")
 q
 ;
UTK2DDT ; @TEST - date in elcap format from key date
 ;KEY2DSPD(zkey)
 n ecpdt s ecpdt=$$KEY2DSPD^SAMICAS2("2018-10-03")
 D CHKEQ^%ut(ecpdt,"10/3/2018","Testing date in elcap form  FAILED!")
 q
 ;
UTVPLSD ; @TEST - extrinsic which return the vapals format for dates
 ;VAPALSDT(fmdate)
 n vpdate s vpdate=$$VAPALSDT^SAMICAS2("3181003")
 D CHKEQ^%ut(vpdate,"10/3/2018","Testing fmdate to elcap date form  FAILED!")
 q
 ;
UTWSNF ; @TEST - select new form for patient (get service)
 ;WSNUFORM(rtn,filter)
 n rtn,SAMIUARGS,SAMIUPOO,SAMIUARC
 s SAMIUARGS("studyid")="XXX00001"
 d WSNUFORM^SAMICAS2(.SAMIUPOO,.SAMIUARGS)
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTWSNF^SAMIUTS2")
 s utsuccess=1
 N nodep,nodea s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i $e($tr(@nodea," "),1,10)?4N1P2N1P2N q
 . i @nodea["<meta" q
 . i '(@nodep=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 D CHKEQ^%ut(1,utsuccess,"Testing wsNuForm FAILED!")
 q
 ;
UTK2FM ; @TEST - convert a key to a fileman date
 ; KEY2FM
 n key,fmd
 s key="unittestform-2018-11-13"
 s fmd=$$KEY2FM^SAMICAS2(key)
 s utsuccess=(fmd=3181113)
 D CHKEQ^%ut(1,utsuccess,"Testing key2fm FAILED!")
 q
 ;
UTMKSBF ; @TEST - create background form
 ;MKSBFORM(sid,key)
 d CheckForm^SAMIUTS2("sbform","MKSBFORM",.utsuccess)
 D CHKEQ^%ut(1,utsuccess,"Testing create background form FAILED!")
 q
 ;
UTMKCEF ; @TEST - create ct evaluation form
 ;MKCEFORM(sid,key)
 d CheckForm^SAMIUTS2("ceform","MKCEFORM",.utsuccess)
 ; -----
 ; We need to add additional fields to the ceform in
 ;   vapals-patients that were deleted in SAMIUTH3 as
 ;   they are used in other unit tests.  This will 
 ;   not change the success of the test under way.
 ;
 n SAMIUPOO,root,vals
 D PLUTARR^SAMIUTST(.SAMIUPOO,"UTNODUL^SAMICTR1 data")
 s root=$$setroot^%wd("vapals-patients")
 s vals=$na(@root@("graph","XXX00001","ceform-2018-10-21"))
 m @vals=SAMIUPOO
 ; -----
 D CHKEQ^%ut(utsuccess,1,"Testing create ct eval form FAILED!")
 q
 ;
UTMKFUF ; @TEST - create Follow-up form
 ;MKFUFORM(sid,key)
 d CheckForm^SAMIUTS2("fuform","MKFUFORM",.utsuccess)
 D CHKEQ^%ut(utsuccess,1,"Testing create followup  form FAILED!")
 q
 ;
UTMKPTF ; @TEST - create ct evaluation form
 ;MKPTFORM(sid,key)
 d CheckForm^SAMIUTS2("ptform","MKPTFORM",.utsuccess)
 D CHKEQ^%ut(utsuccess,1,"Testing create followup  form FAILED!")
 q
 ;
UTMKITF ; @TEST - create intervention form
 ;MKITFORM(sid,key)
 d CheckForm^SAMIUTS2("itform","MKITFORM",.utsuccess)
 D CHKEQ^%ut(utsuccess,1,"Testing create intervention form FAILED!")
 q
 ;
UTMKBXF ; @TEST - create ct evaluation form
 ;MKBXFORM(sid,key)
 d CheckForm^SAMIUTS2("bxform","MKBXFORM",.utsuccess)
 D CHKEQ^%ut(utsuccess,1,"Testing create bx ct eval form FAILED!")
 q
 ;
UTWSCAS ; @TEST - generate case review page
 ;WSCASE(rtn,filter)
 n SAMIUFLTR s SAMIUFLTR("studyid")="XXX00001"
 n SAMIUPOO D WSCASE^SAMICAS2(.SAMIUPOO,.SAMIUFLTR)
 n SAMIUARC D PLUTARR^SAMIUTST(.SAMIUARC,"UTWSCAS^SAMIUTS2")
 s utsuccess=1
 n nodep,nodea s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 .; if the first non space 10 characters are a date, skip
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i (@nodep["meta content") q
 . i '($qs(nodep,1)=$qs(nodea,1)) s utsuccess=0 w !,"qs ",nodep
 . i '(@nodep=@nodea) s utsuccess=0 w !,@nodep,!,@nodea,!
 i '(nodea="") s utsuccess=0 w "at end:",nodea
 D CHKEQ^%ut(utsuccess,1,"Testing generating case review page FAILED!")
 q
 ;
UTGSAMIS ; @TEST - get 'samistatus' to val in form
 ;GSAMISTA(sid,form)
 n root,form,sid,ss1,ss2
 s root=$$setroot^%wd("vapals-patients")
 s form="sbform-2018-10-21"
 s sid="XXX00001"
 s ss1=$g(@root@("graph",sid,"sbform-2018-10-21","samistatus"))
 s ss2=$$GSAMISTA^SAMICAS2(sid,form)
 s utsuccess=(ss1=ss2)
 D CHKEQ^%ut(utsuccess,1,"Testing get samistatus FAILED!")
 q
 ;
UTSSAMIS ; @TEST - set 'samistatus' to val in form
 ;SSAMISTA(sid,form,val)
 n root,form,sid,ss1,ss2,val
 s root=$$setroot^%wd("vapals-patients")
 s form="sbform-2018-10-21"
 s sid="XXX00001"
 s val="unit test"
 s ss1=$g(@root@("graph",sid,"sbform-2018-10-21","samistatus"))
 d SSAMISTA^SAMICAS2(sid,form,val)
 s ss2=$g(@root@("graph",sid,"sbform-2018-10-21","samistatus"))
 ;return to original value
 s @root@("graph",sid,"sbform-2018-10-21","samistatus")=ss1
 s utsuccess=(ss2="unit test")
 D CHKEQ^%ut(utsuccess,1,"Testing set samistatus FAILED!")
 q
 ;
UTDELFM ; @TEST - deletes a form if it is incomplete
 ;DELFORM(RESULT,SAMIUARGS)
 N SAMIUARGS,root,sbexist,sbexistd,SAMIUPOO,SAMIURTN
 s root=$$setroot^%wd("vapals-patients")
 s studyid="XXX00001"
 s form="sbform-2018-10-21"
 S SAMIUARGS("studyid")=studyid
 S SAMIUARGS("form")=form
 s sbexist=$d(@root@("graph",studyid,form))
 i 'sbexist d  q
 . D FAIL^%ut("sbform-2018-10-21 not in vapals-patients Graphstore")
 m SAMIUPOO=@root@("graph",studyid,form)
 d DELFORM^SAMICAS2(.SAMIURTN,.SAMIUARGS)
 s sbexistd=$d(@root@("graph",studyid,form))
 ; now put back original sbform
 k @root@("graph",studyid,form)
 m @root@("graph",studyid,form)=SAMIUPOO
 D CHKEQ^%ut(sbexistd,0,"Testing deleting sbform FAILED!")
 q
 ;
UTINITS ; - set all forms to 'incomplete'
 ;initStatus
 ; This sets ALL patient forms except their siform
 ;   to incomplete.  We don't want to test these
 ;   few lines once real patients are filed
 q
 ;
UTCSRT ; @TEST - generates case review table
 ;CASETBL(ary)
 n SAMIUPOO,SAMIUARC
 D CASETBL^SAMICAS2("SAMIUPOO")
 d PLUTARR^SAMIUTST(.SAMIUARC,"casetbl-SAMICAS2")
 s utsuccess=1
 n pnode,anode
 s pnode=$na(SAMIUPOO),anode=$na(SAMIUARC)
 f  s pnode=$q(@pnode),anode=$q(@anode) q:pnode=""  d
 . I '(@pnode=@anode) s utsuccess=0
 S:'(anode="") utsuccess=0
 q
 ;
 ;
UTNFPST ; @TEST - post new form selection (post service)
 ;WSNFPOST(SAMIUARGS,BODY,RESULT)
 ; This call adds new forms of each type so must
 ;   be run after the above tests that generate
 ;   one of each type separately
 n SAMIUBODY,SAMIUARGS,SAMIURSLT,root,newform
 s root=$$setroot^%wd("vapals-patients")
 s SAMIUBODY(1)=""
 s SAMIUARGS("studyid")="XXX00001"
 ;
 ; now call for form="ceform","sbform","fuform","bxform","ptform"
 ;   "itform"
 ;
 s SAMIUARGS("form")="ceform"
 d WSNFPOST^SAMICAS2(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001","ceform-2018-10-21"))
 s utsuccess=(newform["ceform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 D CHKEQ^%ut(utsuccess,1,"Testing post ceform FAILED!")
 ;
 s SAMIUARGS("form")="sbform"
 d WSNFPOST^SAMICAS2(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001","sbform-2018-10-21"))
 s utsuccess=(newform["sbform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 D CHKEQ^%ut(utsuccess,1,"Testing post sbform FAILED!")
 ;
 s SAMIUARGS("form")="fuform"
 d WSNFPOST^SAMICAS2(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001","fuform-2018-10-21"))
 s utsuccess=(newform["fuform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 D CHKEQ^%ut(utsuccess,1,"Testing post fuform FAILED!")
 ;
 s SAMIUARGS("form")="bxform"
 d WSNFPOST^SAMICAS2(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001","bxform-2018-10-21"))
 s utsuccess=(newform["bxform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 D CHKEQ^%ut(utsuccess,1,"Testing post bxform FAILED!")
 ;
 s SAMIUARGS("form")="ptform"
 d WSNFPOST^SAMICAS2(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001","ptform-2018-10-21"))
 s utsuccess=(newform["ptform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 D CHKEQ^%ut(utsuccess,1,"Testing post ptform FAILED!")
 ;
 s SAMIUARGS("form")="itform"
 d WSNFPOST^SAMICAS2(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001","itform-2018-10-21"))
 s utsuccess=(newform["itform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 D CHKEQ^%ut(utsuccess,1,"Testing post itform FAILED!")
 ;
 q
 ;
 ; Builds the form found in 'form' by calling
 ;   the entry point in SAMICAS2 named in 'label'
 ; Enter
 ;   form       = name of the form to build (e.g. "sbform")
 ;   label      = the datekey to use to identify this
 ;                generated form (e.g. "2018-10-21")
 ;   utsuccess  = variable by reference
 ; Returns
 ;   utsuccess 0=fail, 1=success
 ;
CheckForm(form,LABEL,utsuccess) ;
 n sid s sid="XXX00001"
 n rootvp s rootvp=$$setroot^%wd("vapals-patients")
 n datekey s datekey="2018-10-21"
 n key set key=form_"-"_datekey
 ; delete existing entry
 k @rootvp@("graph",sid,key)
 s SAMIUARGS("key")=key
 s SAMIUARGS("studyid")=sid
 s SAMIUARGS("form")="vapals:"_form
 n rtn s rtn=LABEL_"^SAMICAS2(sid,key)" d @rtn
 ; ^%wd(17.040801,23,"graph","XXX00001",form_"-2018-10-21","active duty")="N and others
 ;
 ; fail if nodes not set in vapals-patients Graphstore
 i '$d(@rootvp@("graph",sid,key)) d  q
 . s utsuccess=0
 . D FAIL^%ut(form_" not set in vapals-patients Graphstore")
 ;
 ; Check that the vapals-patients node created is correct
 ;
 n temp,SAMIUPOO
 d PLUTARR^SAMIUTST(.SAMIUPOO,LABEL)
 m temp=@rootvp@("graph",sid,key)
 s utsuccess=1
 n ss s ss=""
 f  s ss=$O(SAMIUPOO(ss)) q:ss=""  d  q:'utsuccess
 . i '$d(temp(ss)) s utsuccess=0
 . i '($g(SAMIUPOO(ss))=$g(temp(ss))) s utsuccess=0
 q
EOR ;End of routine SAMIUTS2
