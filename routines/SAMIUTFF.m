SAMIUTFF ;ven/lgc - Unit test for SAMIIFF ; 1/14/19 2:10pm
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
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" q
 d EN^%ut($T(+0),2)
 q
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
UTBLDGP ; @TEST - Build a graph of the intake form fields
 ;BLDGRPH
 n SAMIUARC,SAMIUPOO,nodea,nodep
 s utsuccess=1
 ; Delete graph if it existed
 ;DO purgegraph^%wd("siform-fields")
 n siglb s siglb="purgegraph^%wd(""siform-fields"")"
 d @siglb
 ; Now build the graph
 d BLDGRPH^SAMIIFF
 ;n root s root=$$setroot^%wd("siform-fields")
 n root s root=$$SETROOT^SAMIIFF("siform-fields")
 m SAMIUARC=@root
 d PLUTARR^SAMIUTST(.SAMIUPOO,"UTBLDGPH^SAMIUTFF")
 n nodea,nodep s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodea=$Q(nodea),nodep=$Q(nodep) q:nodea=""  d
 . i '(nodea=nodep) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing building siform graph FAILED!")
 q
 ;
EOR ;End of routine SAMIUFF
