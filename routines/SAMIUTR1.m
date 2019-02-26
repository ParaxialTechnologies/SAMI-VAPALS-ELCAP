SAMIUTR1 ;ven/lgc - UNIT TEST for SAMICTR1 ; 2/25/19 8:00pm
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
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" q
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
 k utsuccess
 q
 ;
 ;
UTNODUL ; @TEST - nodules
 ;nodules(rtn,SAMIVALS,dict)
 n SAMIUPOO,root,SAMISI,SAMIVALS,SAMIDICT,SAMIUARC
 n noder,nodea,cnt,return
 s root=$$setroot^%wd("vapals-patients")
 s SAMISI="XXX00001"
 n SAMIKEY s SAMIKEY="ceform-2018-10-21"
 s SAMIVALS=$na(@root@("graph",SAMISI,SAMIKEY))
 n SAMIDICT s SAMIDICT=$$setroot^%wd("cteval-dict")
 s SAMIDICT=$na(@SAMIDICT@("cteval-dict"))
 s cnt=0
 d NODULES^SAMICTR1("return",SAMIVALS,SAMIDICT)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTNODUL^SAMIUTR1 report")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report FAILED!")
 ;
 n SAMIUPOO,SAMISI,SAMIVALS,SAMIDICT,SAMIUARC
 n root,cnt,return,noder,nodea
 s root=$$setroot^%wd("vapals-patients")
 s SAMISI="XXX00001",SAMIKEY="ceform-2018-12-03"
 s SAMIVALS=$na(@root@("graph",SAMISI,SAMIKEY))
 n SAMIDICT s SAMIDICT=$$setroot^%wd("cteval-dict")
 s SAMIDICT=$na(@SAMIDICT@("cteval-dict"))
 s cnt=0
 d NODULES^SAMICTR1("return",SAMIVALS,SAMIDICT)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTNODUL^SAMIUTR1 report XXX12-3")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX12-3  FAILED!")
 ;
 n SAMIUPOO,SAMISI,SAMIVALS,SAMIDICT,SAMIUARC
 n root,cnt,return,noder,nodea
 s root=$$setroot^%wd("vapals-patients")
 s SAMISI="XXX00001",SAMIKEY="ceform-2019-01-23"
 s SAMIVALS=$na(@root@("graph",SAMISI,SAMIKEY))
 n SAMIDICT s SAMIDICT=$$setroot^%wd("cteval-dict")
 s SAMIDICT=$na(@SAMIDICT@("cteval-dict"))
 s cnt=0
 d NODULES^SAMICTR1("return",SAMIVALS,SAMIDICT)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTNODUL^SAMIUTR1 report XXX01-23")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX01-23  FAILED!")
 ;
 n SAMIUPOO,SAMISI,SAMIVALS,SAMIDICT,SAMIUARC
 n root,cnt,return,noder,nodea
 s root=$$setroot^%wd("vapals-patients")
 s SAMISI="XXX00001",SAMIKEY="ceform-2019-02-25"
 s SAMIVALS=$na(@root@("graph",SAMISI,SAMIKEY))
 n SAMIDICT s SAMIDICT=$$setroot^%wd("cteval-dict")
 s SAMIDICT=$na(@SAMIDICT@("cteval-dict"))
 s cnt=0
 d NODULES^SAMICTR1("return",SAMIVALS,SAMIDICT)
 ;now pull saved report
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTNODUL^SAMIUTR1 report XXX01-23")
 ; now compare return with SAMIUARC
 n noder,nodea s noder=$na(return),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s noder=$Q(@noder),nodea=$Q(@nodea) q:noder=""  d  q:'utsuccess
 . i '(@noder=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating nodule report XXX01-23  FAILED!")
 q
 ;
UTOUT ; @TEST - out line
 ;OUT(ln)
 n cnt,rtn,SAMIUPOO,debug
 s debug=1
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 d OUT^SAMICTR1(SAMIULN)
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
 d HOUT^SAMICTR1(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 d CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;XVAL(var,SAMIVALS)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTR1(1,"SAMIUARC")="Testing xval")
 d CHKEQ^%ut(utsuccess,1,"Testing xval(var,SAMIVALS) FAILED!")
 q
 ;
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XSUB(var,SAMIVALS,SAMIDICT,valdx)
 n SAMIVALS,SAMIVAR,SAMIUPOO,SAMIVALDX,result
 s utsuccess=0
 s SAMIVALS="SAMIUPOO"
 s SAMIVAR="cteval-dict"
 s SAMIUPOO(1)="biopsy"
 s SAMIVALDX=1
 s SAMIDICT=$$setroot^%wd("cteval-dict")
 s result=$$XSUB^SAMICTR1(SAMIVAR,SAMIVALS,SAMIDICT,SAMIVALDX)
 s utsuccess=(result="CT-guided biopsy")
 d CHKEQ^%ut(utsuccess,1,"Testing xsub(var,SAMIVALS,SAMIDICT,valdx) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTR1
