SAMIUTNI ;ven/lgc - UNIT TEST for SAMINOTI ;Oct 22, 2019@15:47
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: see routine SAMIUL
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ;
STARTUP new utsuccess
 D SVAPT1^SAMIUTST  ; Save VA's DFN 1 patient data
 D LOADTPT^SAMIUTST  ; Load unit test patient data
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 quit
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 do ^SAMINOTI
 do SUCCEED^%ut
 quit
 ;
UTWSNOTE ; @TEST - web service which returns a text note
 ;WSNOTE(return,filter)
 new SAMIFLTR,SAMIUPOO,SAMIUARC
 set SAMIFLTR("studyid")="XXX00001"
 set SAMIFLTR("form")="ceform-2018-10-21"
 ; pull text note
 do WSNOTE^SAMINOTI(.SAMIUPOO,.SAMIFLTR)
 ; get array of what text note should look like
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSNOTE^SAMIUTNI")
 ; compare the two
 new nodep,nodea set nodep=$name(SAMIUPOO),nodea=$name(SAMIUARC)
 set utsuccess=1
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do  quit:'utsuccess
 . if (@nodep["meta content") quit
 . if $extract($translate(@nodep,""""" "),1,10)?4N1"."2N1"."2N quit
 . if ($qs(nodea,1)=142) quit
 . if '(@nodep=@nodea) set utsuccess=0
 if utsuccess set utsuccess=(nodea="")
 do CHKEQ^%ut(utsuccess,1,"Testing web service return a note FAILED!")
 quit
 ;
UTNOTFLT ; @TEST - extrnisic which creates a note
 ;NOTE(filter)
 new SAMIFLTR,root,SAMIVALS,SAMIUPOO
 set SAMIFLTR("studyid")="XXX00001"
 set SAMIFLTR("form")="ceform-2018-10-21"
 set root=$$setroot^%wd("vapals-patients")
 set SAMIVALS=$name(@root@("graph",SAMIFLTR("studyid"),SAMIFLTR("form"),"note"))
 ; kill any existing note
 kill @SAMIVALS
 ; build new note
 do NOTE^SAMINOTI(.SAMIFLTR)
 ; pull array with what the note should look like in global
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTNOTFLT^SAMIUTNI")
 ; now compare the two
 set utsuccess=1
 new nodep set nodep=$name(SAMIUPOO)
 for  set nodep=$query(@nodep),SAMIVALS=$query(@SAMIVALS) quit:(nodep="")  do  quit:'utsuccess
 . if '(@nodep=@SAMIVALS) set utsuccess=0
 if utsuccess set utsuccess=($qsubscript(SAMIVALS,6)'["note")
 do CHKEQ^%ut(utsuccess,1,"Testing extrinsic which creates note FAILED!")
 quit
 ;
UTOUT ; @TEST - Testing out(ln)
 ;OUT(ln)
 new cnt,dest,SAMIUPOO
 set cnt=1,dest="SAMIUPOO",SAMIUPOO(1)="First line of test"
 new SAMILN set SAMILN="Second line test"
 set utsuccess=0
 do OUT^SAMINOTI(SAMILN)
 set utsuccess=($get(SAMIUPOO(2))="Second line test")
 do CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 quit
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;XVAL(var,vals)
 set utsuccess=0
 set SAMIUARC(1)="Testing xval"
 set utsuccess=($$XVAL^SAMINOTI(1,"SAMIUARC")="Testing xval")
 do CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 quit
 ;
EOR ;End of routine SAMIUTNI
