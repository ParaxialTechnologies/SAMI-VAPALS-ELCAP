SAMIUTVB ;;ven/lgc - UNIT TEST for SAMIVST3 ; 3/18/19 9:39am
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; VA-PALS will be using Sam Habiel's [KBANSCAU] broker
 ;   to pull information from the VA server into the
 ;   VA-PALS client and, to push TIU notes generated by
 ;   VA-PALS forms onto the VA server.
 ; Using this broker between VistA instances requires
 ;   not only the IP and Port for the server be known,
 ;   but also, that the Access and Verify of the user
 ;   on the server be sent across as well.  This is
 ;   required as the user on the server must have the
 ;   necessary Context menu(s) allowing use of the
 ;   Remote Procedure(s).
 ; Six parameters have been added to the client
 ;   VistA to prevent the necessity of hard coding
 ;   certain values and to allow for default values for others.
 ;   SAMi PORT
 ;   SAMi IP ADDRESS
 ;   SAMi ACCVER
 ;   SAMi DEFAULT PROVIDER
 ;   SAMi DEFAULT STATION NUMBER
 ;   SAMi TIU NOTE PRINT NAME
 ;   SAMi DEFAULT CLINIC IEN
 ;   SAMi SYSTEM TEST PATIENT DFN
 ; Note that the user selected must have active
 ;   credentials on both the Client and Server systems
 ;   and the following Broker context menu.
 ;      OR CPRS GUi CHART
 ;
 ; NOTE: Unit tests will pull data using the local
 ;       client VistA files rather than risk degrading
 ;       large datasets in use.  NEVERTHELESS, it is
 ;       recommended that UNIT TESTS be run when
 ;       VA-PALS is not in use as some Graphstore globals
 ;       are temporarily moved while testing is running.
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
STARTUP ; Set up dfn and tiuien to use throughout testing
 ;s utdfn="dfn"_$J
 s utdfn=$$GET^XPAR("SYS","SAMi SYSTEM TEST PATIENT DFN",,"Q")
 s (utsuccess,tiuien)=0
 ; Set up graphstore graph on test patient
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n SAMIUPOO d PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 m @root@("graph","XXX00001")=SAMIUPOO
 q
SHUTDOWN ; ZEXCEPT: dfn,tiuien
 k utdfn,tiuien,utsuccess
 q
SETUP q
TEARDOWN q
 ;
 ;
UTVIT ; @TEST - Pull Vitals on a patient
 ; d VIT(dfn,sdate,edate)
 ; Find entry in patient-lookup without a 'vitals node'
 ;  however the patient has vitals in 120.5
 n root s root=$$setroot^%wd("patient-lookup")
 n gien s gien=0
 n gnode,utdfn,utNeedsVitUpdate s utNeedsVitUpdate=0
 f  s gien=$o(@root@(gien)) q:'gien  d  q:utNeedsVitUpdate
 . S utdfn=$g(@root@(gien,"dfn")) q:'utdfn
 . i $o(^GMR(120.5,"C",utdfn,0)) d
 .. s gnode=$na(@root@(gien,"vitals")),gnode=$q(@gnode)
 .. i '(gnode["vitals") s utNeedsVitUpdate=1
 i 'gien d  q
 . d FAIL^%ut("Unable to find suitable patient for Vitals - FAILED!")
 ;Found a good patient
 s utsuccess=$$VIT^SAMIVSTA(utdfn)
 s gnode=$na(@root@(gien,"vitals")),gnode=$q(@gnode)
 s utsuccess=(gnode["vitals")
 d CHKEQ^%ut(utsuccess,1,"Testing updating Vitals FAILED!")
 q
 ;
UTVPR ; @TEST - Pull Virtual Patient Record (VPR) on a patient
 ; d VPR(dfn)
 ; Find entry in patient-lookup without an 'inpatient' node'
 n root s root=$$setroot^%wd("patient-lookup")
 n gien s gien=0
 n gnode,utdfn,utNeedsVPRUpdate s utNeedsVPRUpdate=0
 f  s gien=$o(@root@(gien)) q:'gien  d  q:utNeedsVPRUpdate
 . s utdfn=$g(@root@(gien,"dfn")) q:'utdfn
 . i '$d(@root@(gien,"inpatient")) s utNeedsVPRUpdate=1
 i 'gien d  Q
 . d FAIL^%ut("Unable to find suitable patient for VPR - FAILED!")
 ;Found a good patient
 s utsuccess=$$VPR^SAMIVSTA(utdfn)
 h 1
 s utsuccess=$d(@root@(gien,"inpatient"))
 d CHKEQ^%ut(utsuccess,1,"Testing updating with VPR  FAILED!")
 q
 ;
 ;
EOR ;End of routine SAMIUTVB
