SAMIUTR0 ;ven/lgc - UNIT TEST for SAMICTR0 ; 10/26/18 1:46pm
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
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTWSRPT ; @TEST - web service which returns an html cteval report
 ;wsReport(return,filter)
 k filter
 s filter("studyid")="XXX00001"
 s filter("form")="ceform-2018-10-21"
 s utsuccess=1
 D wsReport^SAMICTR0(.poo,.filter)
 ; compare poo with poou from a Pull
 D PullUTarray^SAMIUTST(.arc,"wsReport-SAMICTR0")
 ; now compare
 n pnode,anode s pnode=$na(poo),anode=$na(arc)
 f  s pnode=$q(@pnode),anode=$q(@anode) q:pnode=""  d
 . I '(@pnode=@anode) s utsuccess=0
 S:'(anode="") utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval FAILED!")
 q
UTOUT ; @TEST - out line
 ;out(ln)
 n cnt,rtn,poo
 s cnt=1,rtn="poo",poo(1)="First line of test"
 n ln s ln="Second line test"
 s utsuccess=0
 D out^SAMICTR0(ln)
 s utsuccess=($g(poo(2))="Second line test")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
UTHOUT ; @TEST - hout line
 ;hout(ln)
 ; just run hout(ln) and it will add another line
 n cnt,rtn,poo
 s cnt=1,rtn="poo",poo(1)="First line of test"
 n ln s ln="Second line test"
 s utsuccess=0
 D hout^SAMICTR0(ln)
 s utsuccess=($g(poo(2))="<p><span class='sectionhead'>Second line test</span>")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 ;w $$xval^SAMICTR0(51,"arc")
 s utsuccess=0
 s arc(1)="Testing xval"
 s utsuccess=($$xval^SAMICTR0(1,"arc")="Testing xval")
 D CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;xsub(var,vals,dict,valdx)
 n vals,var,poo,valdx,result
 s utsuccess=0
 s vals="poo"
 s var="cteval-dict"
 s poo(1)="biopsy"
 s valdx=1
 s dict=$$setroot^%wd("cteval-dict")
 s result=$$xsub^SAMICTR0(var,vals,dict,valdx)
 s utsuccess=(result="CT-guided biopsy")
 D CHKEQ^%ut(utsuccess,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 q
UTGTFLT ; @TEST - fill in the filter for Ct Eval for sid
 ;getFilter(filter,sid)
 d getFilter^SAMICTR0(.filter,"XXX00001")
 s utsuccess=1
 s:'(filter("form")="ceform-2018-10-21") utsuccess=0
 s:'(filter("studyid")="XXX00001") utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing getFilter FAILED!")
 q
UTT1 ; @TEST - Testing T1
 ;T1(grtn,debug) ;
 q
 ;
EOR ;End of routine SAMIUTR0
