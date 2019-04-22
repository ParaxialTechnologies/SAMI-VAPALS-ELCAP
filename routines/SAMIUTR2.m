SAMIUTR2 ;ven/lgc - UNIT TEST for SAMICTR2 ; 4/22/19 9:04am
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
 ; @last-updated: 10/29/18 4:11pm
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
 ;
START i $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 d EN^%ut($T(+0),2)
 q
 ;
 ;
STARTUP n utsuccess
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n SAMIUPOO D PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 m @root@("graph","XXX00001")=SAMIUPOO
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMICTR2
 d SUCCEED^%ut
 q
 ;
UTOTLNG ; @TEST - other lung
 ;OTHERLUNG(rtn,vals,dict)
 n SAMIUPOO,SAMIUARC
 n root,si,vals,dict,cnt,return,noder,nodea,para
 s root=$$setroot^%wd("vapals-patients")
 s si="XXX00001"
 n samikey s samikey="ceform-2018-10-21"
 s vals=$na(@root@("graph",si,samikey))
 n dict s dict=$$setroot^%wd("cteval-dict")
 s dict=$na(@dict@("cteval-dict"))
 s cnt=0
 s para="SAMIUPOO"
 d OTHRLUNG^SAMICTR2("return",vals,dict)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTOTLNG^SAMIUTR2 report")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing other Lung report FAILED!")
 ;
 n SAMIUPOO,si,vals,cnt,return,SAMIUARC,noder,nodea
 s si="XXX00001",samikey="ceform-2018-12-03"
 s vals=$na(@root@("graph",si,samikey))
 s cnt=0
 s para="POO"
 d OTHRLUNG^SAMICTR2("return",vals,dict)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTOTLNG^SAMIUTR2 report XXX12-3")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX12-3  FAILED!")
 ;
 n SAMIUPOO,si,vals,cnt,return,SAMIUARC,noder,nodea
 s si="XXX00001",samikey="ceform-2019-01-23"
 s vals=$na(@root@("graph",si,samikey))
 s cnt=0
 s para="POO"
 d OTHRLUNG^SAMICTR2("return",vals,dict)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTOTLNG^SAMIUTR2 report XXX01-23")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX01-23  FAILED!")
 ;
 n SAMIUPOO,si,vals,cnt,return,SAMIUARC,noder,nodea
 s si="XXX00001",samikey="ceform-2019-02-25"
 s vals=$na(@root@("graph",si,samikey))
 s cnt=0
 s para="POO"
 d OTHRLUNG^SAMICTR2("return",vals,dict)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTOTLNG^SAMIUTR2 report XXX02-25")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX02-25  FAILED!")
 ;
 n SAMIUPOO,si,vals,cnt,return,SAMIUARC,noder,nodea
 s si="XXX00001",samikey="ceform-2019-02-26"
 s vals=$na(@root@("graph",si,samikey))
 s cnt=0
 s para="POO"
 d OTHRLUNG^SAMICTR2("return",vals,dict)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTOTLNG^SAMIUTR2 report XXX02-26")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX02-26  FAILED!")
 ;
 n SAMIUPOO,si,vals,cnt,return,SAMIUARC,noder,nodea
 s si="XXX00001",samikey="ceform-2019-03-12"
 s vals=$na(@root@("graph",si,samikey))
 s cnt=0
 s para="POO"
 d OTHRLUNG^SAMICTR2("return",vals,dict)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTOTLNG^SAMIUTR2 report XXX03-12")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX03-12  FAILED!")
 q
 ;
UTOUT ; @TEST - out line
 ;OUT(ln)
 n cnt,rtn,SAMIUPOO,debug
 s debug=1
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 d OUT^SAMICTR2(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))["Second line test")
 d CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
 ;
UTHOUT ; @TEST - hout line
 ;HOUT(ln)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 d HOUT^SAMICTR2(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 d CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;XVAL(var,vals)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTR2(1,"SAMIUARC")="Testing xval")
 d CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
 ;
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XSUB(var,vals,dict,valdx)
 n vals,var,SAMIUPOO,valdx,result
 s utsuccess=0
 s vals="SAMIUPOO"
 s var="cteval-dict"
 s SAMIUPOO(1)="biopsy"
 s valdx=1
 s dict=$$setroot^%wd("cteval-dict")
 s result=$$XSUB^SAMICTR2(var,vals,dict,valdx)
 s utsuccess=(result="CT-guided biopsy")
 d CHKEQ^%ut(utsuccess,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTR2
