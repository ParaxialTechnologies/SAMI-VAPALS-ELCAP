SAMIUTC2 ;ven/arc - Unit test for SAMISRC2 ;Jan 09, 2020@13:47
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2019-03-21T17:37Z
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START ;
 if $text(^%ut)="" do
 . write !,"*** UNIT TEST NOT INSTALLED ***"
 . quit
 ;
 do EN^%ut($text(+0),3)
 quit
 ;
 ;
STARTUP ; Ensure all of test patient's forms are setup in vapals-patients
 D SVAPT1^SAMIUTST  ; Save VA's dfn 1 patient if it exists
 D LOADTPT^SAMIUTST  ; Load our test patient
 quit
 ;
SETUP ;
 new args,body,return,filter,from,to,expect,result,expectn,resultn,utsuccess
 quit
 ;
 ;
TEARDOWN ; ZEXCEPT: SAMIUARGS,SAMIUBODY,SAMIURETURN,filter,from,to,expect,result,expectn,resultn,utsuccess
 kill SAMIUARGS,SAMIUBODY,SAMIURETURN,filter,from,to,expect,result,expectn,resultn,utsuccess
 quit
 ;
SHUTDOWN ; Return VA's dfn 1 patient data to graphs
 D LVAPT1^SAMIUTST
 quit
 ;
UTQUIT ; @TEST - Quit at top of routine
 do ^SAMISRC2
 do SUCCEED^%ut
 quit
 ;
UTWSLKU ; @TEST WSLOOKUP^SAMISRC2
 ; Comments
 ;
 ; Test with no patient study ID
UTWSLKU1 set SAMIUBODY(1)=""
 do WSLOOKUP^SAMISRC2(.SAMIUARGS,.SAMIUBODY,.SAMIURETURN)
 set expect="Patient not found"
 set result=filter("samilookuperror")
 ;do CHKEQ^%ut(result,expect)
 ; Check the HTML array
 kill expect,result
 set utsuccess=1
 do PLUTARR^SAMIUTST(.expect,"UTWSLKU^SAMIUTC2: Null SID")
 set resultn=0,expectn=0
 for  set resultn=$order(SAMIURETURN(resultn)),expectn=$order(expect(expectn)) quit:('resultn)!('expectn)  do
 . quit:($extract($translate(SAMIURETURN(resultn),""""" "),1,10)?4N1"."2N1"."2N)  ; Node with a date
 . quit:(SAMIURETURN(resultn)["meta content")
 . if '(resultn=expectn) set utsuccess=0
 . if '(SAMIURETURN(resultn)=expect(expectn)) set utsuccess=0
 if '(resultn="")&(expectn="") set utsuccess=0
 do CHKEQ^%ut(utsuccess,1)
 ;
 ; Test with a patient study ID
UTWSLKU2 kill SAMIUARGS,SAMIUBODY,SAMIURETURN,result,expect
 set SAMIUBODY(1)="field=sid&fvalue=XXX00001"
 do WSLOOKUP^SAMISRC2(.SAMIUARGS,.SAMIUBODY,.SAMIURETURN)
 set expect="XXX00001"
 set result=filter("studyid")
 ;do CHKEQ^%ut(result,expect)
 ; Check the HTML array
 kill expect,result,resultn,expectn
 set utsuccess=1
 do PLUTARR^SAMIUTST(.expect,"UTWSLKU^SAMIUTC2: SID=XXX00001")
 set resultn=0,expectn=0
 for  set resultn=$order(SAMIURETURN(resultn)),expectn=$order(expect(expectn)) quit:('resultn)!('expectn)  do
 . quit:SAMIURETURN(resultn)["meta content"
 . quit:($extract($translate(SAMIURETURN(resultn),""""" "),1,10)?4N1"."2N1"."2N)  ; Node with a date
 . quit:SAMIURETURN(resultn)["<script>"
 . if '(resultn=expectn) set utsuccess=0
 . if '(SAMIURETURN(resultn)=expect(expectn)) set utsuccess=0
 if '(resultn="")&(expectn="") set utsuccess=0
 do CHKEQ^%ut(utsuccess,1)
 ;
 quit
 ;
 ;
EOR ;End of routine SAMIUTC2
