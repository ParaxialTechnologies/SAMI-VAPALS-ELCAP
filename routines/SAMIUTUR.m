SAMIUTUR ;ven/lgc - UNIT TEST for SAMIUR,SAMIUR1,SAMIUR2 ;Oct 22, 2019@16:09
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
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" q
 d EN^%ut($t(+0),2)
 q
 ;
 ;
STARTUP n utsuccess
 D SVAPT1^SAMIUTST  ; Save VA's DFN 1 patient data
 D LOADTPT^SAMIUTST  ; Load unit test patient data
 ; Temporarily update sidc field in siform-2018-11-13 
 s @root@("graph","XXX00001","siform-2018-11-13","sidc")=$P($$HTE^XLFDT($H,5),"@")
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMIUR
 d SUCCEED^%ut
 D ^SAMIUR2
 d SUCCEED^%ut
 q
 ;
UTWSRPT ; @TEST - generate a report based on parameters in filter
 ;wsReport(rtn,SAMIUFLTR)
 n rpttstr
 ;
 n SAMIUFLTR,pats,SAMIUPOO,cnt,root
 s SAMIUFLTR("samireporttype")="followup"
 s rpttstr="<input name=""samireporttype"" type=""hidden"" value=""followup""/>"
 s utsuccess=0
 d WSREPORT^SAMIUR(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)[rpttstr s utsuccess=1
 d CHKEQ^%ut(utsuccess,1,"Testing wsReport for followup FAILED!")
 ;
 k SAMIUFLTR,SAMIUPOO
 s SAMIUFLTR("samireporttype")="activity"
 s rpttstr="<input name=""samireporttype"" type=""hidden"" value=""activity""/>"
 s utsuccess=0
 d WSREPORT^SAMIUR(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)[rpttstr s utsuccess=1
 d CHKEQ^%ut(utsuccess,1,"Testing wsReport for activity FAILED!")
 ;
 k SAMIUFLTR
 s SAMIUFLTR("samireporttype")="enrollment"
 s rpttstr="<input name=""samireporttype"" type=""hidden"" value=""enrollment""/>"
 s utsuccess=0
 d WSREPORT^SAMIUR(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)[rpttstr s utsuccess=1
 d CHKEQ^%ut(utsuccess,1,"Testing wsReport for enrollment FAILED!")
 ;
 k SAMIUFLTR
 s SAMIUFLTR("samireporttype")="missingct"
 s rpttstr="<input name=""samireporttype"" type=""hidden"" value=""missingct""/>"
 s utsuccess=0
 d WSREPORT^SAMIUR(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)[rpttstr s utsuccess=1
 d CHKEQ^%ut(utsuccess,1,"Testing wsReport for missingct FAILED!")
 ;
 k SAMIUFLTR
 s SAMIUFLTR("samireporttype")="incomplete"
 s rpttstr="<input name=""samireporttype"" type=""hidden"" value=""incomplete""/>"
 s utsuccess=0
 d WSREPORT^SAMIUR(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)[rpttstr s utsuccess=1
 d CHKEQ^%ut(utsuccess,1,"Testing wsReport for incomplete FAILED!")
 ;
 q
 ;
UTSELCT ; @TEST - selects patient for the report
 ;select(pats,type)
 n SAMIUPATS,SAMITYPE,SAMIUDPHR,unplus30,unminus30,unowdate,udtphrase,SAMIUPOO
 n root s root=$$setroot^%wd("vapals-patients")
 ;
 s unplus30=$P($$FMTE^XLFDT($$FMADD^XLFDT($$HTFM^XLFDT($H),31),5),"@")
 s unminus30=$P($$FMTE^XLFDT($$FMADD^XLFDT($$HTFM^XLFDT($H),-31),5),"@")
 s unowdate=$P($$FMTE^XLFDT($$HTFM^XLFDT($H),5),"@")
 ;
 s SAMITYPE="",SAMIUDPHR=""
 s udtphrase=" as of "_unowdate
 d SELECT^SAMIUR(.SAMIUPATS,SAMITYPE,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(SAMIUPATS) d
 . n node,cnt s node=$na(SAMIUPATS),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:(cnt=5)
 .. s cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="cedos") s utsuccess=0 q
 .. i cnt=3,'($qs(node,3)="ceform") s utsuccess=0 q
 .. i cnt=4,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=5,'($qs(node,3)="edate") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing type=null patient report FAILED!")
 ;
 k SAMIUPATS
 s SAMITYPE="followup",SAMIUDPHR=""
 s udtphrase=" before "_unplus30
 d SELECT^SAMIUR(.SAMIUPATS,SAMITYPE,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(SAMIUPATS) d
 . n node,cnt s node=$na(SAMIUPATS),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:(cnt=6)
 .. s cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="cedos") s utsuccess=0 q
 .. i cnt=3,'($qs(node,3)="ceform") s utsuccess=0 q
 .. i cnt=4,'($qs(node,3)="ceform-vals") s utsuccess=0 q
 .. i cnt=5,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=6,'($qs(node,3)="edate") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing followup patient report FAILED!")
 ;
 k SAMIUPATS
 s SAMITYPE="activity",SAMIUDPHR=""
 s udtphrase=" after "_unminus30
 d SELECT^SAMIUR(.SAMIUPATS,SAMITYPE,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(SAMIUPATS) d
 . n node,cnt s node=$na(SAMIUPATS),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:(cnt=5)
 .. s cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="cedos") s utsuccess=0 q
 .. i cnt=3,'($qs(node,3)="ceform") s utsuccess=0 q
 .. i cnt=4,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=5,'($qs(node,3)="edate") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing activity patient report FAILED!")
 ;
 k SAMIUPATS
 s SAMITYPE="enrollment",SAMIUDPHR=""
 s udtphrase=" as of "_unowdate
 d SELECT^SAMIUR(.SAMIUPATS,SAMITYPE,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(SAMIUPATS) d
 . n node,cnt s node=$na(SAMIUPATS),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:(cnt=5)
 .. s cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="cedos") s utsuccess=0 q
 .. i cnt=3,'($qs(node,3)="ceform") s utsuccess=0 q
 .. i cnt=4,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=5,'($qs(node,3)="edate") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing enrollment patient report FAILED!")
 ;
 k SAMIUPATS
 s SAMITYPE="missingct",SAMIUDPHR=""
 s udtphrase=" as of "_unowdate
 d SELECT^SAMIUR(.SAMIUPATS,SAMITYPE,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(SAMIUPATS) d
 . n node,cnt s node=$na(SAMIUPATS),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:(cnt=4)
 .. s cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="ceform") s utsuccess=0 q
 .. i cnt=3,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=4,'($qs(node,3)="edate") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing missingct patient report FAILED!")
 ;
 k SAMIUPATS
 s SAMITYPE="incomplete",SAMIUDPHR=""
 s udtphrase=" as of "_unowdate
 d SELECT^SAMIUR(.SAMIUPATS,SAMITYPE,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(SAMIUPATS) d
 . n node,cnt s node=$na(SAMIUPATS),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:(cnt=4)
 .. s cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="ceform") s utsuccess=0 q
 .. i cnt=3,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=4,'($qs(node,3)="edate") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing incomplete patient report FAILED!")
 ;
 q
 ;
UTPNAME ; @TEST - extrinsic returns the PAGE NAME for the report
 ;PNAME(type)
 n str
 s str=$$PNAME^SAMIUR("followup","-test text")
 s utsuccess=(str="Followup -test text")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns followup PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR("activity","-test text")
 s utsuccess=(str="Activity -test text")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns activity PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR("missingct","-test text")
 s utsuccess=(str="Intake but no CT Evaluation-test text")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns missingct PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR("incomplete","-test text")
 s utsuccess=(str="Incomplete Forms-test text")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns incomplete PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR("outreach","-test text")
 s utsuccess=(str="Outreach-test text")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns outreach PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR("enrollment","-test text")
 s utsuccess=(str="Enrollment-test text")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns enrollment PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR("XXX","-test text")
 s utsuccess=(str="")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns XXX PAGE NAME FAILED!")
 q
 ;
 ;
EOR ;End of routine SAMIUTUR
