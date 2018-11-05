SAMIUTD2 ;ven/lgc - UNIT TEST for SAMIUTD2 ; 10/29/18 12:03pm
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
UTIN2G ; @TEST - initialize CTEVAL dictionary into graph cteval-dict
 ;init2graph()
 n g,root,poo,arc
 s root=$$setroot^%wd("cteval-dict")
 m poo=@root
 d SaveUTarray^SAMIUTST(.poo,"init2graph-SAMICTD2")
 ; although init2graph kills the root, I need to do
 ;  so before the call so I know it is a new build
 k @root
 s utsuccess=1
 d init2graph^SAMICTD2
 m arc=@root
 k poo d PullUTarray^SAMIUTST(.poo,"init2graph-SAMICTD2")
 n nodea,nodep s nodea=$na(arc),nodep=$na(poo)
 f  s nodea=$Q(@nodea),nodep=$Q(@nodep) q:nodea=""  d  q:'utsuccess
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing initialization of CTEVAL dictionary FAILED!")
 q
 ;
EOR ;End of routine SAMIUTD2
