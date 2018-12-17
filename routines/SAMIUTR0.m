SAMIUTR0 ;ven/lgc - UNIT TEST for SAMICTR0 ; 12/17/18 10:25am
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
 ; @last-updated: 10/26/18 1:46pm
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
 ;wsReport(return,SAMIUFLTR)
 n SAMIUARC
 k SAMIUFLTR
 s SAMIUFLTR("studyid")="XXX00001"
 s SAMIUFLTR("form")="ceform-2018-10-21"
 s utsuccess=1
 D WSREPORT^SAMICTR0(.SAMIUPOO,.SAMIUFLTR)
 ; compare SAMIUPOO with SAMIUPOOu from a Pull
 D PLUTARR^SAMIUTST(.SAMIUARC,"wsReport-SAMICTR0")
 ; now compare
 n pnode,anode s pnode=$na(SAMIUPOO),anode=$na(SAMIUARC)
 f  s pnode=$q(@pnode),anode=$q(@anode) q:pnode=""  d
 . I '(@pnode=@anode) s utsuccess=0
 S:'(anode="") utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval FAILED!")
 q
UTOUT ; @TEST - out line
 ;out(SAMIULN)
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D OUT^SAMICTR0(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="Second line test")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
UTHOUT ; @TEST - hout line
 ;hout(ln)
 ; just run hout(ln) and it will add another line
 n cnt,rtn,SAMIUPOO
 s cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMIULN s SAMIULN="Second line test"
 s utsuccess=0
 D HOUT^SAMICTR0(SAMIULN)
 s utsuccess=($g(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 ;w $$XVAL^SAMICTR0(51,"SAMIUARC")
 n SAMIUARC
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMICTR0(1,"SAMIUARC")="Testing xval")
 D CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;xsub(var,vals,dict,valdx)
 n var,vals,SAMIUPOO,valdx,result,dict
 s utsuccess=0
 s vals="SAMIUPOO"
 s var="cteval-dict"
 s SAMIUPOO(1)="biopsy"
 s valdx=1
 s dict=$$setroot^%wd("cteval-dict")
 s result=$$XSUB^SAMICTR0(var,vals,dict,valdx)
 s utsuccess=(result="CT-guided biopsy")
 D CHKEQ^%ut(utsuccess,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 q
UTGTFLT ; @TEST - fill in the SAMIUFLTR for Ct Eval for sid
 ;getFilter(SAMIUFLTR,sid)
 d GETFILTR^SAMICTR0(.SAMIUFLTR,"XXX00001")
 s utsuccess=1
 s:'(SAMIUFLTR("form")="ceform-2018-10-21") utsuccess=0
 s:'(SAMIUFLTR("studyid")="XXX00001") utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing getFilter FAILED!")
 q
UTT1 ; @TEST - Testing T1
 ;T1(grtn,debug) ;
 q
 ;
EOR ;End of routine SAMIUTR0
