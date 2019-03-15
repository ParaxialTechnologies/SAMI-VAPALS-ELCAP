SAMIUTNI ;ven/lgc - UNIT TEST for SAMINOTI ; 3/15/19 11:27am
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
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
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" q
 d EN^%ut($T(+0),2)
 q
 ;
 ;
STARTUP n utsuccess
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n SAMIUPOO d PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 m @root@("graph","XXX00001")=SAMIUPOO
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMINOTI
 d SUCCEED^%ut
 q
 ;
UTWSNOTE ; @TEST - web service which returns a text note
 ;WSNOTE(return,filter)
 n SAMIFLTR,SAMIUPOO,SAMIUARC
 s SAMIFLTR("studyid")="XXX00001"
 s SAMIFLTR("form")="ceform-2018-10-21"
 ; pull text note
 d WSNOTE^SAMINOTI(.SAMIUPOO,.SAMIFLTR)
 ; get array of what text note should look like
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTWSNOTE^SAMIUTNI")
 ; compare the two
 n nodep,nodea s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i (@nodep["meta content") q
 . i $E($tr(@nodep,""""" "),1,10)?4N1"."2N1"."2N q
 . i '(@nodep=@nodea) s utsuccess=0
 i utsuccess s utsuccess=(nodea="")
 d CHKEQ^%ut(utsuccess,1,"Testing web service return a note FAILED!")
 q
 ;
UTNOTFLT ; @TEST - extrnisic which creates a note
 ;NOTE(filter)
 n SAMIFLTR,root,SAMIVALS,SAMIUPOO
 s SAMIFLTR("studyid")="XXX00001"
 s SAMIFLTR("form")="ceform-2018-10-21"
 s root=$$setroot^%wd("vapals-patients")
 s SAMIVALS=$na(@root@("graph",SAMIFLTR("studyid"),SAMIFLTR("form"),"note"))
 ; kill any existing note
 k @SAMIVALS
 ; build new note
 d NOTE^SAMINOTI(.SAMIFLTR)
 ; pull array with what the note should look like in global
 d PLUTARR^SAMIUTST(.SAMIUPOO,"UTNOTFLT^SAMIUTNI")
 ; now compare the two
 s utsuccess=1
 n nodep s nodep=$na(SAMIUPOO)
 f  s nodep=$q(@nodep),SAMIVALS=$q(@SAMIVALS) q:(nodep="")  d  q:'utsuccess
 . i '(@nodep=@SAMIVALS) s utsuccess=0
 i utsuccess s utsuccess=($qs(SAMIVALS,6)'["note")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic which creates note FAILED!")
 q
 ;
UTOUT ; @TEST - Testing out(ln)
 ;OUT(ln)
 n cnt,dest,SAMIUPOO
 s cnt=1,dest="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMILN s SAMILN="Second line test"
 s utsuccess=0
 d OUT^SAMINOTI(SAMILN)
 s utsuccess=($g(SAMIUPOO(2))="Second line test")
 d CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;XVAL(var,vals)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMINOTI(1,"SAMIUARC")="Testing xval")
 d CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTNI
