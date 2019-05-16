SAMIUTLG ;ven/lgc - Unit test for SAMILOG ; 5/16/19 11:29am
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
 ; @last-updated: 2019-03-25T22:09Z
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
UTTOGL ; @TEST - Toggle VAPALS password identification
 ;TOGOFF^SAMILOG and TOGON^SAMILOG
 new pooget,poopost,ienget,ienpost,root
 set root=$name(^%web(17.6001))
 set ienget=$order(@root@("B","GET","vapals","WSHOME^SAMIHOM3",0))
 set ienpost=$order(@root@("B","POST","vapals","WSVAPALS^SAMIHOM3",0))
 set pooget=+$get(@root@(ienget,"AUTH"))
 set poopost=+$get(@root@(ienpost,"AUTH"))
 ;if the two (get and post) are not set the same, then
 ;  there is an error in the WEB SERVICE URL HANDLER file
 i '(pooget=poopost) d  q
 . d FAIL^%ut("Error, WEB SERVICE URL HANDLER setup error!")
 ;
 if pooget=1 do
 . do TOGOFF^SAMILOG
 . set utsuccess='$get(@root@(ienget,"AUTH"))
 . do CHKEQ^%ut(utsuccess,1,"Toggle password OFF FAILED!")
 . do TOGON^SAMILOG
 . set utsuccess=$get(@root@(ienget,"AUTH"))
 . do CHKEQ^%ut(utsuccess,1,"Toggle password ON FAILED!")
 else  do
 . do TOGON^SAMILOG
 . set utsuccess=$get(@root@(ienget,"AUTH"))
 . do CHKEQ^%ut(utsuccess,1,"Toggle password ON FAILED!")
 . do TOGOFF^SAMILOG
 . set utsuccess='$get(@root@(ienget,"AUTH"))
 . do CHKEQ^%ut(utsuccess,1,"Toggle password OFF FAILED!")
 ;
 ; Now test the interactive entry point
 do STONOFF^SAMILOG
 set utsuccess='(pooget=$get(@root@(ienget,"AUTH")))
 do CHKEQ^%ut(utsuccess,1,"Toggle password 1st interactive FAILED!")
 do STONOFF^SAMILOG
 set utsuccess=(pooget=$get(@root@(ienget,"AUTH")))
 do CHKEQ^%ut(utsuccess,1,"Toggle password 2nd interactive FAILED!")
 ;
 ; Be sure we leave setting as it was
 new node set node=$name(@root@(ienget,"AUTH"))
 set @node=pooget
 quit
 ;
EOR ;End of routine SAMIUTLG
