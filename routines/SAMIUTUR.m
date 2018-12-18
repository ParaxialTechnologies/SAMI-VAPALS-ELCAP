SAMIUTUR ;ven/lgc - UNIT TEST for SAMIUR1 ; 12/18/18 1:56pm
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
UTWSRPT ; @TEST - generate a report based on parameters in the SAMIUFLTR
 ;wsReport(rtn,SAMIUFLTR)
 n SAMIUFLTR,pats,SAMIUPOO,cnt,root
 s root=$$setroot^%wd("vapals-patients")
 s SAMIUFLTR("samireporttype")="followup"
 s utsuccess=0
 d WSREPORT^SAMIUR1(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)["Followup next 30 days - before"  s utsuccess=1
 D CHKEQ^%ut(utsuccess,1,"Testing wsReport for followup FAILED!")
 ;
 k SAMIUFLTR,SAMIUPOO
 s SAMIUFLTR("samireporttype")="activity"
 s utsuccess=0
 d WSREPORT^SAMIUR1(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)["Activity last 30 days - after" s utsuccess=1
 D CHKEQ^%ut(utsuccess,1,"Testing wsReport for activity FAILED!")
 ;
 k SAMIUFLTR
 s SAMIUFLTR("samireporttype")="enrollment"
 s utsuccess=1
 d WSREPORT^SAMIUR1(.SAMIUPOO,.SAMIUFLTR)
 s cnt=0 f  s cnt=$o(SAMIUPOO(cnt)) q:'cnt  i SAMIUPOO(cnt)["Enrollment as of" s utsuccess=1
 D CHKEQ^%ut(utsuccess,1,"Testing wsReport for enrollment FAILED!")
 q
 ;
UTSELCT ; @TEST - selects patient for the report
 ;select(pats,type)
 n SAMIUPATS,type,SAMIUDPHR,unplus30,unminus30,unowdate,udtphrase,SAMIUPOO
 s root=$$setroot^%wd("vapals-patients")
 ;
 s unplus30=$P($$FMTE^XLFDT($$FMADD^XLFDT($$HTFM^XLFDT($H),31),5),"@")
 s unminus30=$P($$FMTE^XLFDT($$FMADD^XLFDT($$HTFM^XLFDT($H),-31),5),"@")
 s unowdate=$P($$FMTE^XLFDT($$HTFM^XLFDT($H),5),"@")
 ;
 s type="",SAMIUDPHR=""
 s udtphrase=" as of "_unowdate
 D SELECT^SAMIUR1(.SAMIUPATS,type,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(SAMIUPATS) d
 . n node,cnt s node=$na(SAMIUPATS),cnt=0
 . f  s node=$q(@node) q:node=""  d
 .. s:cnt<3 cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 w !,cnt,@node q
 .. i cnt=2,'($qs(node,3)="cefud") s utsuccess=0 w !,cnt,@node q
 .. i cnt=3 s cnt=0 i '($qs(node,3)="edate") s utsuccess=0 w !,cnt,@node
 D CHKEQ^%ut(utsuccess,1,"Testing type=null patient report FAILED!")
 ;
 k SAMIUPATS
 s type="followup",SAMIUDPHR=""
 s udtphrase=" before "_unplus30
 D SELECT^SAMIUR1(.SAMIUPATS,type,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(pats) d
 . n node,cnt s node=$na(pats),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:'utsuccess
 .. s:cnt<3 cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=3 s cnt=0 i '($qs(node,3)="edate") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing followup patient report FAILED!")
 ;
 k SAMIUPATS
 s type="activity",SAMIUDPHR=""
 s udtphrase=" after "_unminus30
 D SELECT^SAMIUR1(.SAMIUPATS,type,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(pats) d
 . n node,cnt s node=$na(pats),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:'utsuccess
 .. s:cnt<3 cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=3 s cnt=0 i '($qs(node,3)="edate") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing activity patient report FAILED!")
 ;
 k SAMIUPATS
 s type="enrollment",SAMIUDPHR=""
 s udtphrase=" as of "_unowdate
 D SELECT^SAMIUR1(.SAMIUPATS,type,.SAMIUDPHR)
 s utsuccess=(SAMIUDPHR=udtphrase)
 i utsuccess,$d(pats) d
 . n node,cnt s node=$na(pats),cnt=0
 . f  s node=$q(@node) q:node=""  d  q:'utsuccess
 .. s:cnt<3 cnt=cnt+1
 .. i cnt=1,'(@node="") s utsuccess=0 q
 .. i cnt=2,'($qs(node,3)="cefud") s utsuccess=0 q
 .. i cnt=3 s cnt=0 i '($qs(node,3)="edate") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing enrollment patient report FAILED!")
 ;
 k SAMIUPATS
 s type="missingct",SAMIUDPHR=""
 D SELECT^SAMIUR1(.SAMIUPATS,type,.SAMIUDPHR)
 s utsuccess=($g(SAMIUDPHR)="")
 D CHKEQ^%ut(utsuccess,1,"Testing missingct patient report FAILED!")
 ;
 k SAMIUPATS
 s type="incomplete",SAMIUDPHR=""
 D SELECT^SAMIUR1(.SAMIUPATS,type,.SAMIUDPHR)
 s utsuccess=($g(SAMIUDPHR)="")
 D CHKEQ^%ut(utsuccess,1,"Testing incomplete patient report FAILED!")
 ;
 k SAMIUPATS
 s type="outreach",SAMIUDPHR=""
 D SELECT^SAMIUR1(.SAMIUPATS,type,.SAMIUDPHR)
 s utsuccess=($g(SAMIUDPHR)="")
 D CHKEQ^%ut(utsuccess,1,"Testing outreach patient report FAILED!")
 q
 ;
UTPNAME ; @TEST - extrinsic returns the PAGE NAME for the report
 ;PNAME(type)
 n str
 s str=$$PNAME^SAMIUR1("followup","-test text")
 s utsuccess=(str="Followup next 30 days --test text")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns followup PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR1("activity","-test text")
 s utsuccess=(str="Activity last 30 days --test text")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns activity PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR1("missingct","-test text")
 s utsuccess=(str="Intake but no CT Evaluation-test text")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns missingct PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR1("incomplete","-test text")
 s utsuccess=(str="Incomplete Forms-test text")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns incomplete PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR1("outreach","-test text")
 s utsuccess=(str="Outreach-test text")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns outreach PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR1("enrollment","-test text")
 s utsuccess=(str="Enrollment-test text")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns enrollment PAGE NAME FAILED!")
 ;
 s str=$$PNAME^SAMIUR1("XXX","-test text")
 s utsuccess=(str="")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns XXX PAGE NAME FAILED!")
 q
 ;
 ;
EOR ;End of routine SAMIUTUR
