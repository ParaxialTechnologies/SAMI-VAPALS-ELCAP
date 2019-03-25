SAMIUTD2 ;ven/lgc - UNIT TEST for SAMICTD2 ; 2019-03-25T19:20Z
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
 ; @license: see routine SAMIUL
 ;
 ; @last-updated: 2019-03-25T19:20Z
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
 do ^SAMICTD2
 do SUCCEED^%ut
 quit
 ;
UTIN2G ; @TEST - initialize CTEVAL dictionary into graph cteval-dict
 ;INIT2GPH()
 new root,SAMIUPOO,SAMIUARC
 set root=$$setroot^%wd("cteval-dict")
 merge SAMIUPOO=@root
 do SVUTARR^SAMIUTST(.SAMIUPOO,"init2graph-SAMICTD2")
 ; although init2graph kills the root, I need to do
 ;  so before the call so I know it is a new build
 kill @root
 set utsuccess=1
 do INIT2GPH^SAMICTD2
 merge SAMIUARC=@root
 kill SAMIUPOO do PLUTARR^SAMIUTST(.SAMIUPOO,"init2graph-SAMICTD2")
 new nodea,nodep set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodea=$query(@nodea),nodep=$query(@nodep) quit:nodea=""  do  quit:'utsuccess
 . if '(@nodea=@nodep) set utsuccess=0
 if '(nodep="") set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing initialization of CTEVAL dictionary FAILED!")
 quit
 ;
EOR ;End of routine SAMIUTD2
