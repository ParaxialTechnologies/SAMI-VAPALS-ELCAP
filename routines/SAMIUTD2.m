SAMIUTD2 ;ven/lgc - UNIT TEST for SAMIUTD2 ; 1/15/19 8:58am
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
 ; @last-updated: 10/29/18 12:03pm
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
UTIN2G ; @TEST - initialize CTEVAL dictionary into graph cteval-dict
 ;INIT2GPH()
 n root,SAMIUPOO,SAMIUARC
 ;s root=$$setroot^%wd("cteval-dict")
 s root=$$SETROOT^SAMIUTST("cteval-dict")
 m SAMIUPOO=@root
 d SVUTARR^SAMIUTST(.SAMIUPOO,"init2graph-SAMICTD2")
 ; although init2graph kills the root, I need to do
 ;  so before the call so I know it is a new build
 k @root
 s utsuccess=1
 d INIT2GPH^SAMICTD2
 m SAMIUARC=@root
 k SAMIUPOO d PLUTARR^SAMIUTST(.SAMIUPOO,"init2graph-SAMICTD2")
 n nodea,nodep s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodea=$Q(@nodea),nodep=$Q(@nodep) q:nodea=""  d  q:'utsuccess
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing initialization of CTEVAL dictionary FAILED!")
 q
 ;
EOR ;End of routine SAMIUTD2
