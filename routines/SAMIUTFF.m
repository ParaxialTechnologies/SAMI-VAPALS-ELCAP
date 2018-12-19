SAMIUTFF ;ven/lgc - Unit test for SAMIIFF ; 12/14/18 12:06pm
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
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTBLDGP ; @TEST - Build a graph of the intake form fields
 ;BLDGRPH
 n SAMIUARC,SAMIUPOO,nodea,nodep
 s utsuccess=1
 ; Delete graph if it existed
 DO purgegraph^%wd("siform-fields")
 ; Now build the graph
 D BLDGRPH^SAMIIFF
 n root s root=$$setroot^%wd("siform-fields")
 m SAMIUARC=@root
 D PLUTARR^SAMIUTST(.SAMIUPOO,"UTBLDGPH^SAMIUTFF")
 n nodea,nodep s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodea=$Q(nodea),nodep=$Q(nodep) q:nodea=""  d
 . i '(nodea=nodep) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing building siform graph FAILED!")
 q
 ;
EOR ;End of routine SAMIUFF
