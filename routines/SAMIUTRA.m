SAMIUTRA ;ven/lgc - UNIT TEST for SAMICTRA ; 1/10/19 11:16am
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
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" Q
 d EN^%ut($T(+0),2)
 q
 ;
 ;
STARTUP n utsuccess
 ;n root s root=$$setroot^%wd("vapals-patients")
 n root s root=$$SETROOT^SAMIUTST("vapals-patients")
 k @root@("graph","XXX00001")
 n SAMIUPOO D PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 m @root@("graph","XXX00001")=SAMIUPOO
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTRCMD ; @TEST - Recommendation
 ;recommend(rtn,vals,dict)
 n vals,dict,si,samikey,root,SAMIUPOO,SAMIUARC,nodea,nodep
 ;s root=$$setroot^%wd("vapals-patients")
 n root s root=$$SETROOT^SAMIUTST("vapals-patients")
 s si="XXX00001"
 s samikey="ceform-2018-10-21"
 s vals=$na(@root@("graph",si,samikey))
 ;s dict=$$setroot^%wd("cteval-dict")
 s dict=$$SETROOT^SAMIUTST("cteval-dict")
 s dict=$na(@dict@("cteval-dict"))
 s cnt=1
 ; SAMICTRA needs para = value to insert in one line
 n para s para="POO"
 s utsuccess=1
 D RCMND^SAMICTRA("SAMIUPOO",vals,dict)
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTRCMD^SAMIUTRA")
 n nodea,nodep s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing recommend FAILED!")
 q
UTOUT ; @TEST - out line
 ;OUT(ln)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D OUT^SAMICTRA(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="Second line test")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
UTHOUT ; @TEST - hout line
 ;HOUT(ln)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D HOUT^SAMICTRA(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 D CHKEQ^%ut(utsuccess,1,"Testing hout(ln) adds line to array FAILED!")
 q
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTRA(1,"SAMIUARC")="Testing xval")
 D CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;xsub(var,vals,dict,valdx)
 n vals,var,SAMIUPOO,valdx,result
 s utsuccess=0
 s vals="SAMIUPOO"
 s var="cteval-dict"
 s SAMIUPOO(1)="biopsy"
 s valdx=1
 ;s dict=$$setroot^%wd("cteval-dict")
 s dict=$$SETROOT^SAMIUTST("cteval-dict")
 s result=$$XSUB^SAMICTRA(var,vals,dict,valdx)
 s utsuccess=(result="CT-guided biopsy")
 D CHKEQ^%ut(utsuccess,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTRA
