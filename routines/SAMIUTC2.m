SAMIUTC2 ;ven/arc - Unit test for SAMISRC2 ; 12/3/18 2:27pm
 ;;18.0;SAMI;;
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2018-11-02T1840Z
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START 
 if $text(^%ut)="" do
 . write !,"*** UNIT TEST NOT INSTALLED ***"
 . quit
 ;
 do EN^%ut($text(+0),3)
 quit
 ;
 ;
STARTUP ; Ensure all of test patient's forms are setup in vapals-patients
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n poo D PullUTarray^SAMIUTST(.poo,"all XXX00001 forms")
 m @root@("graph","XXX00001")=poo
 q
 ;
SETUP 
 new args,body,return,filter,from,to,expect,result,expectn,resultn,utsuccess
 quit
 ;
 ;
TEARDOWN ; ZEXCEPT: args,body,return,filter,from,to,expect,result,expectn,resultn,utsuccess
 kill args,body,return,filter,from,to,expect,result,expectn,resultn,utsuccess
 quit
 ;
 ;
UTWSLKU ; @TEST wsLookup^SAMISRC2
 ; Comments
 ;
 ; Test with no patient study ID
 set body(1)=""
 do wsLookup^SAMISRC2(.args,.body,.return)
 set expect="Patient not found"
 set result=filter("samilookuperror")
 do CHKEQ^%ut(result,expect)
 ; Check the HTML array
 kill expect,result
 set utsuccess=1
 do PullUTarray^SAMIUTST(.expect,"UTWSLKU^SAMIUTC2: Null SID")
 set resultn=0,expectn=0
 for  set resultn=$order(return(resultn)),expectn=$order(expect(expectn)) quit:('resultn)!('expectn)  do
 . quit:($E($TR(return(resultn),""""" "),1,10)?4N1"."2N1"."2N) ; Node with a date
 . quit:(return(resultn)["meta content")
 . if '(resultn=expectn) set utsuccess=0
 . if '(return(resultn)=expect(expectn)) set utsuccess=0
 if '(resultn="")&(expectn="") set utsuccess=0
 do CHKEQ^%ut(utsuccess,1)
 ;
 ; Test with a patient study ID
 kill args,body,return,result,expect
 set body(1)="field=sid&fvalue=XXX00001"
 do wsLookup^SAMISRC2(.args,.body,.return)
 set expect="XXX00001"
 set result=filter("studyid")
 do CHKEQ^%ut(result,expect)
 ; Check the HTML array
 kill expect,result,resultn,expectn
 set utsuccess=1
 do PullUTarray^SAMIUTST(.expect,"UTWSLKU^SAMIUTC2: SID=XXX00001")
 set resultn=0,expectn=0
 for  set resultn=$order(return(resultn)),expectn=$order(expect(expectn)) quit:('resultn)!('expectn)  do
 . quit:return(resultn)["meta content"
 . quit:'($E($TR(return(resultn),""""" "),1,10)?4N1"."2N1"."2N) ; Node with a date
 . if '(resultn=expectn) set utsuccess=0
 . if '(return(resultn)=expect(expectn)) set utsuccess=0
 if '(resultn="")&(expectn="") set utsuccess=0
 do CHKEQ^%ut(utsuccess,1)
 ;
 q
 ;
 ;
EOR ;End of routine SAMIUTC2
