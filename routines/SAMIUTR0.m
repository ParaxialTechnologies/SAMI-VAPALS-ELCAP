SAMIUTR0 ;ven/lgc - UNIT TEST for SAMICTR0 ;Oct 22, 2019@15:52
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: see routine SAMIUL
 ;
 ; @last-updated: 20190413T22:31Z
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ;
STARTUP new utsuccess
 D SVAPT1^SAMIUTST  ; Save VA's DFN 1 patient data
 D LOADTPT^SAMIUTST  ; Load unit test patient data
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 quit
 ;
UTQUIT ; @TEST - Quit at top of routine
 do ^SAMICTR0
 do SUCCEED^%ut
 quit
 ;
UTWSRPT ; @TEST - web service which returns an html cteval report
 ;wsReport(return,SAMIUFLTR)
 new SAMIUARC
 kill SAMIUFLTR
 set SAMIUFLTR("studyid")="XXX00001"
 set SAMIUFLTR("form")="ceform-2018-10-21"
 set utsuccess=1
 do WSREPORT^SAMICTR0(.SAMIUPOO,.SAMIUFLTR)
 ; compare SAMIUPOO with SAMIUPOOu from a Pull
 do PLUTARR^SAMIUTST(.SAMIUARC,"wsReport-SAMICTR0")
 ; now compare
 new pnode,anode set pnode=$name(SAMIUPOO),anode=$name(SAMIUARC)
 for  set pnode=$query(@pnode),anode=$query(@anode) quit:pnode=""  do
 . if '(@pnode=@anode) set utsuccess=0
 set:'(anode="") utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval FAILED!")
 quit
 ;
UTOUT ; @TEST - out line
 ;out(SAMIULN)
 new cnt,rtn,SAMIUPOO,debug
 set debug=1
 set cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 new SAMIULN set SAMIULN="Second line test"
 set utsuccess=0
 do OUT^SAMICTR0(SAMIULN)
 set utsuccess=($get(SAMIUPOO(2))["Second line test")
 do CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 quit
 ;
UTHOUT ; @TEST - hout line
 ;hout(ln)
 ; just run hout(ln) and it will add another line
 new cnt,rtn,SAMIUPOO
 set cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 new SAMIULN set SAMIULN="Second line test"
 set utsuccess=0
 do HOUT^SAMICTR0(SAMIULN)
 set utsuccess=($get(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 do CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 quit
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 ;write $$XVAL^SAMICTR0(51,"SAMIUARC")
 new SAMIUARC
 set utsuccess=0
 set SAMIUARC(1)="Testing xval"
 set utsuccess=($$XVAL^SAMICTR0(1,"SAMIUARC")="Testing xval")
 do CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 quit
 ;
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by SAMIVAR
 ;xsub(var,vals,dict,valdx)
 new SAMIVAR,SAMIVALS,SAMIUPOO,SAMIVALDX,result,SAMIDICT
 set utsuccess=0
 set SAMIVALS="SAMIUPOO"
 set SAMIVAR="cteval-dict"
 set SAMIUPOO(1)="biopsy"
 set SAMIVALDX=1
 set SAMIDICT=$$setroot^%wd("cteval-dict")
 set result=$$XSUB^SAMICTR0(SAMIVAR,SAMIVALS,SAMIDICT,SAMIVALDX)
 set utsuccess=(result="CT-guided biopsy")
 do CHKEQ^%ut(utsuccess,1,"Testing xsub(SAMIVAR,SAMIVALS,dict,SAMIVALDX) FAILED!")
 quit
 ;
UTGTFLT ; @TEST - fill in the SAMIUFLTR for Ct Eval for sid
 ;getFilter(SAMIUFLTR,sid)
 do GETFILTR^SAMICTR0(.SAMIUFLTR,"XXX00001")
 set utsuccess=1
 set:'(SAMIUFLTR("form")="ceform-2018-10-21") utsuccess=0
 set:'(SAMIUFLTR("studyid")="XXX00001") utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing getFilter FAILED!")
 quit
 ;
UTT1 ; @TEST - Testing T1
 ;T1(grtn,debug) ;
 quit
 ;
EOR ;End of routine SAMIUTR0
