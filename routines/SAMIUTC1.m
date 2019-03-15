SAMIUTC1 ;ven/lgc - Unit test for SAMICTC1 and SAMICTC2 ; 3/15/19 11:03am
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
 ; @last-updated: 10/26/18 7:56pm
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
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 d ^SAMICTC1
 d SUCCEED^%ut
 d ^SAMICTC2
 d SUCCEED^%ut
 q
 ;
UTCTCPY ; @TEST - copies a Ct Eval form selectively
 ;CTCOPY(FROM,TO)
 n SAMIUARC,SAMIUPOO,SAMIUFROM,SAMIUTO
 s utsuccess=1
 d PLUTARR^SAMIUTST(.SAMIUPOO,"CTCOPY-SAMICTC1")
 S SAMIUFROM=$NA(SAMIUPOO),SAMIUTO=$NA(SAMIUARC)
 d CTCOPY^SAMICTC1(SAMIUFROM,SAMIUTO)
 n nodea,nodep s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodea=$q(nodea),nodep=$q(nodep) q:nodea=""  d
 . i '(nodea=nodep) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing CTCOPY FAILED!")
 q
UTGNCTC ; @TEST - generates the copy routine from a graph
 q
 ;
EOR ;End of routine SAMIUTC1
