SAMIUTC1 ;ven/lgc - Unit test for SAMICTC1 and SAMICTC2 ; 2019-03-19T00:26Z
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
 ;  linda.yaw@vistaexpertise.org
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: see routine SAMIUL
 ;
 ; @last-updated: 2019-03-19T00:26Z
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
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 quit
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 do ^SAMICTC1
 do SUCCEED^%ut
 do ^SAMICTC2
 do SUCCEED^%ut
 quit
 ;
UTCTCPY ; @TEST - copies a Ct Eval form selectively
 ;CTCOPY(FROM,TO)
 new SAMIUARC,SAMIUPOO,SAMIUFROM,SAMIUTO
 set utsuccess=1
 do PLUTARR^SAMIUTST(.SAMIUPOO,"CTCOPY-SAMICTC1")
 set SAMIUFROM=$name(SAMIUPOO),SAMIUTO=$name(SAMIUARC)
 do CTCOPY^SAMICTC1(SAMIUFROM,SAMIUTO)
 new nodea,nodep set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodea=$query(nodea),nodep=$query(nodep) quit:nodea=""  do
 . if '(nodea=nodep) set utsuccess=0
 . if '(@nodea=@nodep) set utsuccess=0
 if '(nodep="") set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing CTCOPY FAILED!")
 quit
UTGNCTC ; @TEST - generates the copy routine from a graph
 quit
 ;
EOR ;End of routine SAMIUTC1
