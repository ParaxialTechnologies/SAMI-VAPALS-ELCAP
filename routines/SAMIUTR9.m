SAMIUTR9 ;ven/lgc - UNIT TEST for SAMICTR9 ; 1/14/19 10:47am
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
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" q
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
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTIMPRS ; @TEST - impression
 ;IMPRSN(rtn,SAMIVALS,dict)
 n SAMIVALS,SAMIDICT,si,samikey,root,SAMIUPOO,SAMIUARC
 n nodea,nodep,para,cac,cacrec
 ;s root=$$setroot^%wd("vapals-patients")
 s root=$$SETROOT^SAMIUTST("vapals-patients")
 s si="XXX00001"
 s samikey="ceform-2018-10-21"
 s SAMIVALS=$na(@root@("graph",si,samikey))
 ;s SAMIDICT=$$setroot^%wd("cteval-dict")
 s SAMIDICT=$$SETROOT^SAMIUTST("cteval-dict")
 s SAMIDICT=$na(@SAMIDICT@("cteval-dict"))
 s cnt=1,para="POO"
 s cacrec=" CaCrEc ",cac=99
 s utsuccess=1
 d IMPRSN^SAMICTR9("SAMIUPOO",SAMIVALS,SAMIDICT)
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTIMPRS^SAMICTR9")
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
 d OUT^SAMICTR9(SAMIULN)
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
 d HOUT^SAMICTR9(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 d CHKEQ^%ut(utsuccess,1,"Testing hout(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;XVAL(var,SAMIVALS)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTR9(1,"SAMIUARC")="Testing xval")
 d CHKEQ^%ut(utsuccess,1,"Testing xval(var,SAMIVALS) FAILED!")
 q
 ;
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XSUB(var,SAMIVALS,dict,valdx)
 n SAMIVALS,SAMIVAR,SAMIUPOO,SAMIVALDX,result,SAMIDICT
 s utsuccess=0
 s SAMIVALS="SAMIUPOO"
 s SAMIVAR="cteval-dict"
 s SAMIUPOO(1)="biopsy"
 s SAMIVALDX=1
 ;s SAMIDICT=$$setroot^%wd("cteval-dict")
 s SAMIDICT=$$SETROOT^SAMIUTST("cteval-dict")
 s result=$$XSUB^SAMICTR9(SAMIVAR,SAMIVALS,SAMIDICT,SAMIVALDX)
 s utsuccess=(result="CT-guided biopsy")
 d CHKEQ^%ut(utsuccess,1,"Testing xsub(var,SAMIVALS,dict,valdx) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTR9
