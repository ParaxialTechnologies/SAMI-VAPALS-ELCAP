SAMIUTRA ;ven/lgc - UNIT TEST for SAMICTRA ;Oct 22, 2019@16:02
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
 D SVAPT1^SAMIUTST  ; Save VA's DFN 1 patient data
 D LOADTPT^SAMIUTST  ; Load unit test patient data
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMICTRA
 d SUCCEED^%ut
 q
 ;
UTRCMD ; @TEST - Recommendation
 ;recommend(rtn,SAMIVALS,dict)
 n SAMIVALS,SAMIDICT,si,samikey,root,SAMIUPOO,SAMIUARC,nodea,nodep
 s root=$$setroot^%wd("vapals-patients")
 s si="XXX00001"
 s samikey="ceform-2018-10-21"
 s SAMIVALS=$na(@root@("graph",si,samikey))
 s SAMIDICT=$$setroot^%wd("cteval-dict")
 s SAMIDICT=$na(@SAMIDICT@("cteval-dict"))
 s cnt=1
 ; SAMICTRA needs para = value to insert in one line
 n para s para="POO"
 s utsuccess=1
 d RCMND^SAMICTRA("SAMIUPOO",SAMIVALS,SAMIDICT)
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTRCMD^SAMIUTRA")
 n nodea,nodep s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing recommend FAILED!")
 q
 ;
UTOUT ; @TEST - out line
 ;OUT(ln)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 d OUT^SAMICTRA(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="Second line test")
 d CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
 ;
UTHOUT ; @TEST - hout line
 ;HOUT(ln)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 d HOUT^SAMICTRA(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 d CHKEQ^%ut(utsuccess,1,"Testing hout(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTRA(1,"SAMIUARC")="Testing xval")
 d CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
 ;
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;xsub(var,SAMIVALS,SAMIDICT,SAMIVALDX)
 n SAMIVALS,SAMIVAR,SAMIUPOO,SAMIVALDX,result
 s utsuccess=0
 s SAMIVALS="SAMIUPOO"
 s SAMIVAR="cteval-dict"
 s SAMIUPOO(1)="biopsy"
 s SAMIVALDX=1
 s SAMIDICT=$$setroot^%wd("cteval-dict")
 s result=$$XSUB^SAMICTRA(SAMIVAR,SAMIVALS,SAMIDICT,SAMIVALDX)
 s utsuccess=(result="CT-guided biopsy")
 d CHKEQ^%ut(utsuccess,1,"Testing xsub(var,SAMIVALS,dict,SAMIVALDX) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTRA
