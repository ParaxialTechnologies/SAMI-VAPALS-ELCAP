SAMIUTCR ;ven/lgc - UNIT TEST for SAMICTR ;Dec 16, 2019@09:44
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
 ; @last-updated: 2019-03-25T19:12Z
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
 D SVAPT1^SAMIUTST  ; Save VA's DFN 1 patient
 D LOADTPT^SAMIUTST  ; Pull Unit Test DFN 1 patient data
 ; add extra test patient forms
 new SAMIUPOO,root
 s root=$$setroot^%wd("vapals-patients")
 do PLUTARR^SAMIUTST(.SAMIUPOO,"ceform-2019-01-24")
 merge @root@("graph","XXX00001","ceform-2019-01-24")=SAMIUPOO
 do PLUTARR^SAMIUTST(.SAMIUPOO,"ceform-2018-01-02")
 merge @root@("graph","XXX00001","ceform-2018-01-02")=SAMIUPOO
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 D LVAPT1^SAMIUTST  ; Reload VA's DFN 1 patient data
 quit
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 do ^SAMICTR
 do SUCCEED^%ut
 quit
 ;
UTWSRPT ; @TEST - web service which returns an html cteval report
 ;WSREPORT(return,SAMIFLTR)
 ;use ceform-2018-10-21
 new root set root=$$setroot^%wd("vapals-patients")
 kill SAMIFLTR
 set SAMIFLTR("studyid")="XXX00001"
 set SAMIFLTR("form")="ceform-2018-10-21"
 set utsuccess=1
 do WSREPORT^SAMICTR(.SAMIUPOO,.SAMIFLTR)
 ; compare SAMIUPOO with SAMIUPOO from a Pull
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSRPT^SAMIUTCR")
 ; now compare
 new pnode,anode set pnode=$name(SAMIUPOO),anode=$name(SAMIUARC)
 for  set pnode=$query(@pnode),anode=$query(@anode) quit:pnode=""  do
 . if '(@pnode=@anode) set utsuccess=0
 set:'(anode="") utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval 10-21 FAILED!")
 ;
 ;
 ;use ceform-2019-01-23
 kill SAMIFLTR
 set SAMIFLTR("studyid")="XXX00001"
 set SAMIFLTR("form")="ceform-2019-01-23"
 set @root@("graph","XXX00001","ceform-2019-01-23","cetex")="b"
 set utsuccess=1
 do WSREPORT^SAMICTR(.SAMIUPOO,.SAMIFLTR)
 ; compare SAMIUPOO with SAMIUPOO from a Pull
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSRPT^SAMIUTCR XXX01-23")
 ; now compare
 new pnode,anode set pnode=$name(SAMIUPOO),anode=$name(SAMIUARC)
 for  set pnode=$query(@pnode),anode=$query(@anode) quit:pnode=""  do
 . if '(@pnode=@anode) set utsuccess=0
 set:'(anode="") utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval 01-23 FAILED!")
 ;
 ;use ceform-2019-01-24
 kill SAMIFLTR
 set SAMIFLTR("studyid")="XXX00001"
 set SAMIFLTR("form")="ceform-2019-01-24"
 set utsuccess=1
 do WSREPORT^SAMICTR(.SAMIUPOO,.SAMIFLTR)
 ; compare SAMIUPOO with SAMIUPOO from a Pull
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSRPT^SAMIUTCR XXX01-24")
 ; now compare
 new pnode,anode set pnode=$name(SAMIUPOO),anode=$name(SAMIUARC)
 for  set pnode=$query(@pnode),anode=$query(@anode) quit:pnode=""  do
 . if '(@pnode=@anode) set utsuccess=0
 set:'(anode="") utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval 01-24 FAILED!")
 ;
 ;use ceform-2018-01-02
 kill SAMIFLTR
 set SAMIFLTR("studyid")="XXX00001"
 set SAMIFLTR("form")="ceform-2018-01-02"
 set utsuccess=1
 do WSREPORT^SAMICTR(.SAMIUPOO,.SAMIFLTR)
 ; compare SAMIUPOO with SAMIUPOO from a Pull
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSRPT^SAMIUTCR XXX01-02")
 ; now compare
 new pnode,anode set pnode=$name(SAMIUPOO),anode=$name(SAMIUARC)
 for  set pnode=$query(@pnode),anode=$query(@anode) quit:pnode=""  do
 . if '(@pnode=@anode) set utsuccess=0
 set:'(anode="") utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval 01-02 FAILED!")
 ;
 ; Now lets try a special case
 new SAMIUPOO,SAMIUARC,pnode,anode
 do PLUTARR^SAMIUTST(.SAMIUPOO,"ce-sb-si forms XXX0005")
 kill @root@("graph","XXX0005")
 merge @root@("graph","XXX0005")=SAMIUPOO
 kill SAMIFLTR
 set SAMIFLTR("studyid")="XXX0005"
 set SAMIFLTR("form")="ceform-2016-01-01"
 set utsuccess=1
 do WSREPORT^SAMICTR(.SAMIUARC,.SAMIFLTR)
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSRPT^SAMIUTCR XXX0005")
 ; now compare
 new pnode,anode set pnode=$name(SAMIUPOO),anode=$name(SAMIUARC)
 for  set pnode=$query(@pnode),anode=$query(@anode) quit:pnode=""  do
 . if '(@pnode=@anode) set utsuccess=0
 set:'(anode="") utsuccess=0
 kill @root@("graph","XXX0005")
 do CHKEQ^%ut(utsuccess,1,"Testing web service returns html cteval XXX0005 FAILED!")
 quit
 ;
UTOUT ; @TEST - out line
 ;OUT(ln)
 new cnt,rtn,SAMIUPOO
 set cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 new SAMIULN set SAMIULN="Second line test"
 set utsuccess=0
 do OUT^SAMICTR(SAMIULN)
 set utsuccess=($get(SAMIUPOO(2))="Second line test")
 do CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 quit
 ;
UTHOUT ; @TEST - hout line
 ;HOUT(ln)
 new cnt,rtn,SAMIUPOO
 set cnt=1,rtn="SAMIUPOO",SAMIUPOO(1)="First line of test"
 new SAMIULN set SAMIULN="Second line test"
 set utsuccess=0
 do HOUT^SAMICTR(SAMIULN)
 set utsuccess=($get(SAMIUPOO(2))="<p><span class='sectionhead'>Second line test</span>")
 do CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 quit
 ;
UTXVAL ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XVAL(var,vals,dict,valdx)
 set utsuccess=0
 set SAMIUARC(1)="Testing xval"
 set utsuccess=($$XVAL^SAMICTR(1,"SAMIUARC")="Testing xval")
 do CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 quit
 ;
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;XSUB(var,vals,dict,valdx)
 new SAMIUVALS,SAMIUVAR,SAMIUPOO,SAMIUVALDX,SAMIUDICT,result
 set utsuccess=0
 set SAMIUVALS="SAMIUPOO"
 set SAMIUVAR="cteval-dict"
 set SAMIUPOO(1)="biopsy"
 set SAMIUVALDX=1
 set SAMIUDICT=$$setroot^%wd("cteval-dict")
 set result=$$XSUB^SAMICTR(SAMIUVAR,SAMIUVALS,SAMIUDICT,SAMIUVALDX)
 set utsuccess=(result="CT-guided biopsy")
 do CHKEQ^%ut(utsuccess,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 quit
 ;
EOR ;End of routine SAMIUTCR
