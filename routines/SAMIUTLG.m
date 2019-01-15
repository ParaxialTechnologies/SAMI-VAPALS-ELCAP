SAMIUTLG ;ven/lgc - Unit test for SAMILOG ; 1/14/19 1:22pm
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
UTTOGL ; @TEST - Toggle VAPALS password identification
 ;TOGOFF^SAMILOG and TOGON^SAMILOG
 n pooget,poopost,ienget,ienpost
 s ienget=$o(^%W(17.6001,"B","GET","vapals","WSHOME^SAMIHOM3",0))
 s ienpost=$o(^%W(17.6001,"B","POST","vapals","WSVAPALS^SAMIHOM3",0))
 s pooget=$g(^%W(17.6001,ienget,"AUTH"))
 s poopost=$g(^%W(17.6001,ienpost,"AUTH"))
 ;if the two (get and post) are not set the same, then
 ;  there is an error in the WEB SERVICE URL HANDLER file
 i '(pooget=poopost) d  q
 . d FAIL^%ut("Error, WEB SERVICE URL HANDLER setup error!")
 i pooget=1 d
 . d TOGOFF^SAMILOG
 . s utsuccess='$g(^%W(17.6001,ienget,"AUTH"))
 . d CHKEQ^%ut(utsuccess,1,"Toggle password OFF FAILED!")
 . d TOGON^SAMILOG
 . s utsuccess=$g(^%W(17.6001,ienget,"AUTH"))
 . d CHKEQ^%ut(utsuccess,1,"Toggle password ON FAILED!")
 e  d
 . d TOGON^SAMILOG
 . s utsuccess=$g(^%W(17.6001,ienget,"AUTH"))
 . d CHKEQ^%ut(utsuccess,1,"Toggle password ON FAILED!")
 . d TOGOFF^SAMILOG
 . s utsuccess='$g(^%W(17.6001,ienget,"AUTH"))
 . d CHKEQ^%ut(utsuccess,1,"Toggle password OFF FAILED!")
 ;
 ; Now test the interactive entry point
 d STONOFF^SAMILOG
 s utsuccess='(pooget=$g(^%W(17.6001,ienget,"AUTH")))
 d CHKEQ^%ut(utsuccess,1,"Toggle password 1st interactive FAILED!")
 d STONOFF^SAMILOG
 s utsuccess=(pooget=$g(^%W(17.6001,ienget,"AUTH")))
 d CHKEQ^%ut(utsuccess,1,"Toggle password 2nd interactive FAILED!")
 ;
 ; Be sure we leave setting as it was
 n node s node=$NA(^%W(17.6001,ienget,"AUTH"))
 s @node=pooget
 s node=$NA(^%W(17.6001,ienpost,"AUTH"))
 s @node=poopost
 q
 ;
EOR ;End of routine SAMIUTLG
