SAMIUTRX ;ven/lgc - UNIT TEST for SAMICTRX ; 12/17/18 3:55pm
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
UTOUT ; @TEST - out line
 ;OUT(ln)
 n cnt,rtn,poo
 s cnt=1,rtn="poo",poo(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D OUT^SAMICTRX(SAMIULN)
 s utsuccess=($g(poo(2))="Second line test")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 ;
 n cnt,rtn,poo
 s cnt=1,rtn="poo",poo(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 n debug s debug=1
 D OUT^SAMICTRX(SAMIULN)
 s utsuccess=($g(poo(2))[":Second line test")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line debug FAILED!")
 q
 ;
UTHOUT ; @TEST - hout line
 ;HOUT(ln)
 n cnt,rtn,poo
 s cnt=1,rtn="poo",poo(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D HOUT^SAMICTRX(SAMIULN)
 s utsuccess=($g(poo(2))="<p><span class='sectionhead'>Second line test</span>")
 D CHKEQ^%ut(utsuccess,1,"Testing hout(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;XVAL(var,vals)
 s utsuccess=0
 n arc s arc(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTRX(1,"arc")="Testing xval")
 D CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XSUB(var,vals,dict,valdx)
 n vals,var,poo,valdx,result,dict
 s utsuccess=0
 s vals="poo"
 s var="cteval-dict"
 s poo(1)="biopsy"
 s valdx=1
 s dict=$$setroot^%wd("cteval-dict")
 s result=$$XSUB^SAMICTRX(var,vals,dict,valdx)
 s utsuccess=(result="CT-guided biopsy")
 D CHKEQ^%ut(utsuccess,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTRX
