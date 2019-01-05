SAMIUTCR ;ven/lgc - UNIT TEST for SAMICTR ; 1/4/19 11:18am
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
 ; @last-updated: 10/31/18 5:51pm
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
 n root s root=$$setroot^%wd("vapals-patients")
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
UTWSRPT ; @TEST - web service which returns an html cteval report
 ;WSREPORT(return,filter)
 ;use ceform-2018-10-21
 n root
 n root s root=$$setroot^%wd("vapals-patients")
 k filter
 s filter("studyid")="XXX00001"
 s filter("form")="ceform-2018-10-21"
 s utsuccess=1
 D WSREPORT^SAMICTR(.SAMIUPOO,.filter)
 ; compare SAMIUPOO with SAMIUPOO from a Pull
 D PLUTARR^SAMIUTST(.SAMIUARC,"UTWSRPT^SAMIUTCR")
 ; now compare
 n pnode,anode s pnode=$na(SAMIUPOO),anode=$na(SAMIUARC)
 f  s pnode=$q(@pnode),anode=$q(@anode) q:pnode=""  d
 . I '(@pnode=@anode) s utsuccess=0
 S:'(anode="") utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval FAILED!")
 ;
 ;use ceform-2018-12-03
 k filter
 s filter("studyid")="XXX00001"
 s filter("form")="ceform-2018-12-03"
 s utsuccess=1
 D WSREPORT^SAMICTR(.SAMIUPOO,.filter)
 ; compare SAMIUPOO with SAMIUPOO from a Pull
 D PLUTARR^SAMIUTST(.SAMIUARC,"UTWSRPT^SAMIUTCR XXX12-3")
 ; now compare
 n pnode,anode s pnode=$na(SAMIUPOO),anode=$na(SAMIUARC)
 f  s pnode=$q(@pnode),anode=$q(@anode) q:pnode=""  d
 . I '(@pnode=@anode) s utsuccess=0
 S:'(anode="") utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval FAILED!")
 ;
 ; Now lets try a special case
 n SAMIUPOO,SAMIUARC,pnode,anode
 D PLUTARR^SAMIUTST(.SAMIUPOO,"ce-sb-si forms XXX0005")
 k @root@("graph","XXX0005")
 m @root@("graph","XXX0005")=SAMIUPOO
 k filter
 s filter("studyid")="XXX0005"
 s filter("form")="ceform-2016-01-01"
 s utsuccess=1
 D WSREPORT^SAMICTR(.SAMIUARC,.filter)
 D PLUTARR^SAMIUTST(.SAMIUPOO,"UTLOADD^SAMIUTF2 XXX0005")
 ; now compare
 n pnode,anode s pnode=$na(SAMIUPOO),anode=$na(SAMIUARC)
 f  s pnode=$q(@pnode),anode=$q(@anode) q:pnode=""  d
 . I '(@pnode=@anode) s utsuccess=0
 S:'(anode="") utsuccess=0
 k @root@("graph","XXX0005")
 D CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval XXX0005 FAILED!")
 ;
 q
 ;
UTOUT ; @TEST - out line
 ;OUT(ln)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D OUT^SAMICTR(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="Second line test")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
UTHOUT ; @TEST - hout line
 ;HOUT(ln)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D HOUT^SAMICTR(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
UTXVAL ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XVAL(var,vals,dict,valdx)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTR(1,"SAMIUARC")="Testing xval")
 D CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XSUB(var,vals,dict,valdx)
 n SAMIUVALS,SAMIUVAR,SAMIUPOO,SAMIUVALDX,SAMIUDICT,result
 s utsuccess=0
 s SAMIUVALS="SAMIUPOO"
 s SAMIUVAR="cteval-dict"
 s SAMIUPOO(1)="biopsy"
 s SAMIUVALDX=1
 s SAMIUDICT=$$setroot^%wd("cteval-dict")
 s result=$$XSUB^SAMICTR(SAMIUVAR,SAMIUVALS,SAMIUDICT,SAMIUVALDX)
 s utsuccess=(result="CT-guided biopsy")
 D CHKEQ^%ut(utsuccess,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTCR
