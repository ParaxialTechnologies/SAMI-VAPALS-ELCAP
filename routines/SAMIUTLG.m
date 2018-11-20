SAMIUTLG ;ven/lgc - Unit test for SAMILOG ; 11/19/18 11:12am
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
UTTOGL ; @TEST - Toggle VAPALS password identification
 ;ToggleOff^SAMILOG and ToggleON^SAMILOG
 n pooget,poopost,ienget,ienpost
 s ienget=$o(^%W(17.6001,"B","GET","vapals","wsHOME^SAMIHOM3",0))
 s ienpost=$o(^%W(17.6001,"B","POST","vapals","wsVAPALS^SAMIHOM3",0))
 s pooget=$g(^%W(17.6001,ienget,"AUTH"))
 s poopost=$g(^%W(17.6001,ienpost,"AUTH"))
 ;if the two (get and post) are not set the same, then
 ;  there is an error in the WEB SERVICE URL HANDLER file
 i '(pooget=poopost) d  q
 . D FAIL^%ut("Error, WEB SERVICE URL HANDLER setup error!")
 i pooget=1 d
 . d ToggleOff^SAMILOG
 . s utsuccess='$g(^%W(17.6001,ienget,"AUTH"))
 . D CHKEQ^%ut(utsuccess,1,"Toggle password OFF FAILED!")
 . d ToggleOn^SAMILOG
 . s utsuccess=$g(^%W(17.6001,ienget,"AUTH"))
 . D CHKEQ^%ut(utsuccess,1,"Toggle password ON FAILED!")
 e  d
 . d ToggleOn^SAMILOG
 . s utsuccess=$g(^%W(17.6001,ienget,"AUTH"))
 . D CHKEQ^%ut(utsuccess,1,"Toggle password ON FAILED!")
 . d ToggleOff^SAMILOG
 . s utsuccess='$g(^%W(17.6001,ienget,"AUTH"))
 . D CHKEQ^%ut(utsuccess,1,"Toggle password OFF FAILED!")
 ; Be sure we leave setting as it was
 i (pooget=$g(^%W(17.6001,ienget,"AUTH"))) q
 i pooget=1 d
 . s ^%W(17.6001,ienget,"AUTH")=1
 . s ^%W(17.6001,ienpost,"AUTH")=1
 e  d
 . s ^%W(17.6001,ienget,"AUTH")=0
 . s ^%W(17.6001,ienpost,"AUTH")=0
 D PullUTarray^SAMIUTST(.poou,"CTCOPY-SAMICTC1")
 s FROM=$NA(poou),TO=$NA(arc)
 D CTCOPY^SAMICTC1(FROM,TO)
 n nodea,nodep s nodea=$na(arc),nodep=$na(poou)
 f  s nodea=$Q(nodea),nodep=$Q(nodep) q:nodea=""  d
 . i '(nodea=nodep) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing CTCOPY FAILED!")
 q
 ;
EOR ;End of routine SAMIUTLG
