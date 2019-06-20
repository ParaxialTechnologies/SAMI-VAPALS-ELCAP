SAMIUTN1 ;ven/lgc - UNIT TEST for SAMINOT1 ; 4/30/19 1:13pm
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
 d EN^%ut($T(+0),2)
 q
 ;
 ;
STARTUP n utsuccess
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n SAMIUPOO d PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 m @root@("graph","XXX00001")=SAMIUPOO
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMINOT1
 d SUCCEED^%ut
 q
 ;
UTEXSTCE ; @TEST -  if a Chart Eligibility Note exists
 n SAMISID,SAMIFORM
 s SAMISID="XXX00001",SAMIFORM="siform-2018-11-13"
 s utsuccess=($$EXISTCE^SAMINOT1(SAMISID,SAMIFORM)="false")
 d CHKEQ^%ut(utsuccess,1,"Testing Chart Eligibility Note FAILED!")
 q
 ;
UTEXSTPR ; @TEST - if a Pre-enrollment Note exists
 n SAMISID,SAMIFORM
 s SAMISID="XXX00001",SAMIFORM="siform-2018-11-13"
 s utsuccess=($$EXISTPRE^SAMINOT1(SAMISID,SAMIFORM)="false")
 d CHKEQ^%ut(utsuccess,1,"Testing Pre-enrollment FAILED!")
 q
 ;
UTEXSTIN ; @TEST - if an Intake Note exists
 n SAMISID,SAMIFORM
 s SAMISID="XXX00001",SAMIFORM="siform-2018-11-13"
 s utsuccess=($$EXISTINT^SAMINOT1(SAMISID,SAMIFORM)="false")
 d CHKEQ^%ut(utsuccess,1,"Testing if intake note exists FAILED!")
 q
 ;
UTWSNOTE ; @TEST - web service which returns a text note
 ;WSNOTE(return,filter)
 n root s root=$$setroot^%wd("vapals-patients")
 s @root@("graph","XXX00001","ceform-2018-10-21","notes",1,"text")="unit test"
 n SAMIFLTR,SAMIUPOO,SAMIUARC
 s SAMIFLTR("studyid")="XXX00001"
 s SAMIFLTR("form")="ceform-2018-10-21"
 s SAMIFLTR("nien")=1
 ; pull text note
 d WSNOTE^SAMINOT1(.SAMIUPOO,.SAMIFLTR)
 ; get array of what text note should look like
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTWSNOTE^SAMIUTNI")
 ; compare the two
 n nodep,nodea s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 s utsuccess=1
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i (@nodep["meta content") q
 . i $E($tr(@nodep,""""" "),1,10)?4N1"."2N1"."2N q
 . i (@nodep["const frozen") q
 . i $tr($tr($tr(@nodea," "),$C(10)),$C(13))="" q
 .;
 . i '(@nodep=@nodea) s utsuccess=0
 i utsuccess s utsuccess=(nodea="")
 d CHKEQ^%ut(utsuccess,1,"Testing web service return a note FAILED!")
 q
 ;
UTNOTE ; @TEST - extrnisic which creates a note
 ;NOTE(filter)
 n SAMIFLTR,SAMIUPOO,SAMIVALS,root
 s SAMIFLTR("studyid")="XXX00001"
 s SAMIFLTR("form")="siform-2018-11-13"
 s root=$$setroot^%wd("vapals-patients")
 S SAMIVALS=$na(@root@("graph","XXX00001","siform-2018-11-13"))
 ;
 ; build new chart-eligibility note
 s @SAMIVALS@("samistatus")="chart-eligibility"
 s utsuccess=$$NOTE^SAMINOT1(.SAMIFLTR)
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic chart-eligibility FAILED!")
 ;
 ; build new "pre-enrollment-discussion" note
 s @SAMIVALS@("samistatus")="pre-enrollment-discussion"
 s @SAMIVALS@("chart-eligibility-complete")="false"
 s utsuccess=$$NOTE^SAMINOT1(.SAMIFLTR)
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic pre-enrollment FAILED!")
 ;
 ; build new "eligibility-complete" note
 s @SAMIVALS@("samistatus")="complete"
 s @SAMIVALS@("chart-eligibility-complete")="false"
 s utsuccess=$$NOTE^SAMINOT1(.SAMIFLTR)
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic pre-enrollment FAILED!")
 q
 ;
UTMKEL ; @TEST - Testing eligibility note
 n root,SAMISID,SAMIFORM,SAMIVALS,SAMIFLTR
 s root=$$setroot^%wd("vapals-patients")
 S SAMISID="XXX00001"
 s SAMIFORM="siform-2018-11-13"
 s SAMIVALS=$na(@root@("graph",SAMISID,SAMIFORM,"note"))
 s SAMIFLTR("nien")=1
 D MKEL^SAMINOT1(SAMISID,SAMIFORM,SAMIVALS,.SAMIFLTR)
 N SAMIUARC,SAMIUPOO
 M SAMIUARC=@root@("graph",SAMISID,SAMIFORM,"note")
 D PLUTARR^SAMIUTST(.SAMIUPOO,"UTMKEL^SAMIUTN1")
 ; now compare the two
 s utsuccess=1
 n nodep s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:(nodep="")  d  q:'utsuccess
 . i $qs(nodep,3)="date" quit
 . i $qs(nodep,3)="name" quit
 . i '(@nodep=@nodea) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing create elegibility note FAILED!")
 q
 ;
UTMKPRE ; @TEST - Testing pre note
 n root,SAMISID,SAMIFORM,SAMIVALS,SAMIFLTR
 s root=$$setroot^%wd("vapals-patients")
 S SAMISID="XXX00001"
 s SAMIFORM="siform-2018-11-13"
 s SAMIVALS=$na(@root@("graph",SAMISID,SAMIFORM,"note"))
 s SAMIFLTR("nien")=2
 S @SAMIVALS@("chart-eligibility-complete")=""
 D MKPRE^SAMINOT1(SAMISID,SAMIFORM,SAMIVALS,.SAMIFLTR)
 N SAMIUARC,SAMIUPOO
 M SAMIUARC=@root@("graph",SAMISID,SAMIFORM,"note")
 D PLUTARR^SAMIUTST(.SAMIUPOO,"UTMKPRE^SAMIUTN1")
 ; now compare the two
 s utsuccess=1
 n nodep s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:(nodep="")  d  q:'utsuccess
 . i $qs(nodep,3)="date" quit
 . i $qs(nodep,3)="name" quit
 . i '(@nodep=@nodea) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing create pre-note FAILED!")
 q
 ;
UTMKIN ; @TEST - Testing intake note
 n root,SAMISID,SAMIFORM,SAMIVALS,SAMIFLTR
 s root=$$setroot^%wd("vapals-patients")
 S SAMISID="XXX00001"
 s SAMIFORM="siform-2018-11-13"
 s SAMIVALS=$na(@root@("graph",SAMISID,SAMIFORM,"note"))
 s SAMIFLTR("nien")=3
 S @SAMIVALS@("chart-eligibility-complete")=""
 D MKIN^SAMINOT1(SAMISID,SAMIFORM,SAMIVALS)
 N SAMIUARC,SAMIUPOO
 M SAMIUARC=@root@("graph",SAMISID,SAMIFORM,"note")
 K ^SAMIUT("SAMIUTN1","UTMKIN","SAMIUARC")
 M ^SAMIUT("SAMIUTN1","UTMKIN","SAMIUARC")=SAMIUARC
 D PLUTARR^SAMIUTST(.SAMIUPOO,"UTMKIN^SAMIUTN1")
 ; now compare the two
 s utsuccess=1
 n nodep s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:(nodep="")  d  q:'utsuccess
 . i $qs(nodep,3)="date" quit
 . i $qs(nodep,3)="name" quit
 . i '(@nodep=@nodea) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing create intake note FAILED!")
 q
 ;
UTELNOTE ; @TEST - Testing elegibility note text
 n SAMIVALS,SAMIDEST,SAMICNT,root,SAMIUPOO,SAMIUARC
 s root=$$setroot^%wd("vapals-patients")
 S SAMISID="XXX00001"
 s SAMIFORM="siform-2018-11-13"
 s SAMIVALS=$na(@root@("graph",SAMISID,SAMIFORM))
 S SAMIDEST="SAMIUPOO"
 S SAMICNT=0
 s @SAMIVALS@("siceiden")="referral"
 s @SAMIVALS@("sicerfdt")=3180401
 s @SAMIVALS@("sicechrt")=3180403
 d ELNOTE^SAMINOT1(.SAMIVALS,.SAMIDEST,.SAMICNT)
 D PLUTARR^SAMIUTST(.SAMIUARC,"UTELNOTE^SAMIUTN1")
 s utsuccess=1
 n nodep s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:(nodep="")  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing create elegibility text FAILED!")
 q
 ;
UTPRENT ; @TEST - Testing pre-enrolment note text
 n SAMIVALS,SAMIDEST,SAMICNT,root,SAMIUPOO,SAMIUARC
 s root=$$setroot^%wd("vapals-patients")
 S SAMISID="XXX00001"
 s SAMIFORM="siform-2018-11-13"
 s SAMIVALS=$na(@root@("graph",SAMISID,SAMIFORM))
 S SAMIDEST="SAMIUPOO"
 S SAMICNT=0
 S @SAMIVALS@("sipedisc")="y"
 s @SAMIVALS@("sipedc")=3180401
 s @SAMIVALS@("sipecnvd")=1
 s @SAMIVALS@("siperslt")=1
 s @SAMIVALS@("sipecmnt")="Comment string"
 d PRENOTE^SAMINOT1(.SAMIVALS,.SAMIDEST,.SAMICNT)
 D SVUTARR^SAMIUTST(.SAMIUPOO,"UTPRENT^SAMIUTN1")
 D PLUTARR^SAMIUTST(.SAMIUARC,"UTPRENT^SAMIUTN1")
 s utsuccess=1
 n nodep s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:(nodep="")  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing create pre-enrollment text FAILED!")
 q
 ;
UTSUBR ; @TEST - Tesing translation of discussion result
 N SAMIXVAL,SAMISUCC
 S SAMIXVAL="y"
 S SAMISUCC(1)=($$SUBRSLT^SAMINOT1(SAMIXVAL)="Participant is interested in discussing lung screening. The program will proceed with enrollment process.")
 ;
 S SAMIXVAL="u"
 S SAMISUCC(2)=($$SUBRSLT^SAMINOT1(SAMIXVAL)="Participant is unsure of lung screening. Ok to contact in the future.")
 ;
 S SAMIXVAL="nn"
 S SAMISUCC(3)=($$SUBRSLT^SAMINOT1(SAMIXVAL)="Participant is not interested in discussing lung screening at this time. Ok to contact in the future.")
 ;
 S SAMIXVAL="nf"
 S SAMISUCC(4)=($$SUBRSLT^SAMINOT1(SAMIXVAL)="Participant is not interested in discussing lung screening in the future.")
 ;
 S SAMIXVAL="na"
 S SAMISUCC(5)=($$SUBRSLT^SAMINOT1(SAMIXVAL)="Unable to reach participant at this time")
 N I F I=1:1:5 S SAMISUCC=$G(SAMISUCC)+SAMISUCC(I)
 d CHKEQ^%ut(SAMISUCC,5,"Testing translation of discussion  FAILED!")
 q
 ;
UTINNOTE ; @TEST - Testing intake note text
 n SAMIVALS,SAMIDEST,SAMICNT,root,SAMIUPOO,SAMIUARC
 s root=$$setroot^%wd("vapals-patients")
 S SAMISID="XXX00001"
 s SAMIFORM="siform-2018-11-13"
 s SAMIVALS=$na(@root@("graph",SAMISID,SAMIFORM))
 S SAMIDEST="SAMIUPOO"
 S SAMICNT=0
 S @SAMIVALS@("sidc")=3180401
 S @SAMIVALS@("silnpc")="y"
 S @SAMIVALS@("sipav")="n"
 S @SAMIVALS@("sirs")="u"
 S @SAMIVALS@("sipsa")=1
 S @SAMIVALS@("sipz")=1
 S @SAMIVALS@("sippn")=1
 S @SAMIVALS@("sies")=1
 S @SAMIVALS@("siesq")=1
 S @SAMIVALS@("sicpd")=35
 S @SAMIVALS@("sippd")=35
 S @SAMIVALS@("sisny")=1
 S @SAMIVALS@("sicadx")="y"
 S @SAMIVALS@("sicadxl")=3180401
 S @SAMIVALS@("sildct")="y"
 d INNOTE^SAMINOT1(.SAMIVALS,.SAMIDEST,.SAMICNT)
 D PLUTARR^SAMIUTST(.SAMIUARC,"UTINNOTE^SAMIUTN1")
 s utsuccess=1
 s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . if '(@nodea=@nodep) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing intake note text FAILED!")
 q
 ;
 ;
UTOUT ; @TEST - Testing out(ln)
 ;OUT(ln)
 n cnt,dest,SAMIUPOO
 s cnt=1,dest="SAMIUPOO",SAMIUPOO(1)="First line of test"
 n SAMILN s SAMILN="Second line test"
 s utsuccess=0
 d OUT^SAMINOT1(SAMILN)
 s utsuccess=($g(SAMIUPOO(2))="Second line test")
 d CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;XVAL(var,vals)
 s utsuccess=0
 s SAMIUARC(1)="Testing xval"
 s utsuccess=($$XVAL^SAMINOT1(1,"SAMIUARC")="Testing xval")
 d CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTN1
