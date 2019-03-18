SAMIUTVA ;;ven/lgc - UNIT TEST for SAMIVSTA,SAMIVST1,SAMIVST2 ; 3/18/19 9:38am
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
 ;   SAMI PORT
 ;   SAMI IP ADDRESS
 ;   SAMI ACCVER
 ;   SAMI DEFAULT PROVIDER
 ;   SAMI DEFAULT STATION NUMBER
 ;   SAMI TIU NOTE PRINT NAME
 ;   SAMI DEFAULT CLINIC IEN
 ;   SAMI SYSTEM TEST PATIENT DFN
 ; Note that the user selected must have active
 ;   credentials on both the Client and Server systems
 ;   and the following Broker context menu.
 ;      OR CPRS GUI CHART
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
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: see routine SAMIUL
 ;
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
STARTUP ; Set up dfn and tiuien to use throughout testing
 ;set utdfn="dfn"_$J
 set utdfn=$$GET^XPAR("SYS","SAMI SYSTEM TEST PATIENT DFN",,"Q")
 set (utsuccess,tiuien)=0
 ; Set up graphstore graph on test patient
 new root set root=$$setroot^%wd("vapals-patients")
 kill @root@("graph","XXX00001")
 new SAMIUPOO do PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 merge @root@("graph","XXX00001")=SAMIUPOO
 quit
SHUTDOWN ; ZEXCEPT: dfn,tiuien
 kill utdfn,tiuien,utsuccess
 quit
SETUP quit
TEARDOWN quit
 ;
UTBLDTIU ; @TEST - Build a new TIU and Visit stub for a patient
 ; BLDTIU(.tiuien,DFN,TITLE,USER,CLINIEN)
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new provduz,clinien,tiutitlepn,tiutitleien,ptdfn
 set provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 set clinien=$$GET^XPAR("SYS","SAMI DEFAULT CLINIC IEN",,"Q")
 set tiutitlepn=$$GET^XPAR("SYS","SAMI NOTE TITLE PRINT NAME",,"Q")
 set tiutitleien=$order(^TIU(8925.1,"D",tiutitlepn,0))
 if '$get(utdfn) do  quit
 . do FAIL^%ut("Patient DFN missing")
 if ('$get(provduz))!('$get(clinien))!('$get(tiutitleien)) do  quit
 . do FAIL^%ut("Provider,clinic, or tiu title missing")
 do BLDTIU^SAMIVSTA(.tiuien,utdfn,tiutitleien,provduz,clinien)
 hang 3 ; Delay for time to build everything
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Procedure failed to build new TIU note")
 new tiunode0 set tiunode0=$get(^TIU(8925,tiuien,0))
 if '($piece(tiunode0,"^",1,2)=(tiutitleien_"^"_utdfn)) do  quit
 . do FAIL^%ut("Procedure failed to build CORRECT TIU note")
 if '$piece(tiunode0,"^",3) do  quit
 . do FAIL^%ut("Procedure failed to build TIU visit")
 new aupnvist0 set aupnvist0=$get(^AUPNVSIT(+$piece(tiunode0,"^",3),0))
 do CHKEQ^%ut(+aupnvist0,+$piece(tiunode0,"^",7),"Testing building TIU note FAILED!")
 quit
 ;
UTSTEXT ; @TEST - Push text into an existing TIU note
 ; SETTEXT(.tiuien,.dest)
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new SAMIUPOO
 set SAMIUPOO(1)="First line of UNIT TEST text."
 set SAMIUPOO(2)="Second line of UNIT TEST text."
 set SAMIUPOO(3)="Setting text time:"_$$HTE^XLFDT($HOROLOG)
 set SAMIUPOO(4)="Forth and last line of UNIT TEST text"
 new dest set dest="SAMIUPOO"
 do SETTEXT^SAMIVSTA(.tiuien,dest)
 hang 1 ; Delay for time to build everything
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Procedure failed to set text in TIU note")
 set SAMIUPOO=0
 new if for I=1:1:4 do  quit:SAMIUPOO
 . if '($get(^TIU(8925,tiuien,"TEXT",I,0))=SAMIUPOO(I)) set SAMIUPOO=1
 do CHKEQ^%ut(SAMIUPOO,0,"Testing setting text in TIU note FAILED!")
 quit
 ;
UTENCTR ; @TEST - Update TIU with encounter and HF information
 ; BLDENCTR(.tiuien,.HFARRAY)
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new vstr,provduz
 if '$get(utdfn) do  quit
 . do FAIL^%ut("Update tiu with encounter missing utdfn FAILED!")
 set vstr=$$VISTSTR^SAMIVSTA(tiuien)
 if '($length(vstr,";")=3) do  quit
 . do FAIL^%ut("Update tiu with encounter VSTR FAILED!")
 set provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 if '$get(provduz) do  quit
 . do FAIL^%ut("Update tiu with encounter no provduz FAILED!")
 ; Time to build the HF array for the next call
 new SAMIUHFA
 set SAMIUHFA(1)="HDR^0^^"_vstr
 set SAMIUHFA(2)="VST^DT^"_$piece(vstr,";",2)
 set SAMIUHFA(3)="VST^PT^"_utdfn
 set SAMIUHFA(4)="VST^HL^"_$piece(vstr,";")
 set SAMIUHFA(5)="VST^VC^"_$piece(vstr,";",3)
 set SAMIUHFA(6)="PRV^"_provduz_"^^^"_$piece($get(^VA(200,provduz,0)),"^")_"^1"
 set SAMIUHFA(7)="POV+^F17.210^COUNSELING AND SCREENING^Nicotine dependence, cigarettes, uncomplicated^1^^0^^^1"
 set SAMIUHFA(8)="COM^1^@"
 set SAMIUHFA(9)="HF+^999001^LUNG SCREENING HF^LCS-ENROLLED^@^^^^^2^"
 set SAMIUHFA(10)="COM^2^@"
 set SAMIUHFA(11)="CPT+^99203^NEW PATIENT^Intermediate Exam  26-35 Min^1^71^^^0^3^"
 set SAMIUHFA(12)="COM^3^@"
 ;
 set utsuccess=$$BLDENCTR^SAMIVSTA(.tiuien,.SAMIUHFA)
 do CHKEQ^%ut(utsuccess,tiuien,"Testing adding encounter to TIU note FAILED!")
 quit
 ;
UTPTINF ; @TEST - Pull additional patient information
 ; do PTINFO^SAMIVSTA(dfn)
 ; Find patient without SSN filed in Graphstore
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new root set root=$$setroot^%wd("patient-lookup")
 new gien set gien=0
 for  set gien=$order(@root@(gien)) quit:'gien  quit:'($data(@root@(gien,"ssn")))
 if 'gien do  quit
 . do FAIL^%ut("Unable to find Graphstore entry without SSN - FAILED!")
 new utdfn set utdfn=@root@(gien,"dfn")
 if 'utdfn do  quit
 . do FAIL^%ut("Unable to find patient dfn in Graphstore - FAILED!")
 set utsuccess=$$PTINFO^SAMIVSTA(utdfn)
 do CHKEQ^%ut(utsuccess,("2^"_utdfn),"Testing PTINFO FAILED!")
 quit
 ;
UTADDNS ; @TEST - Add additional signers to a TIU note
 ; do ADDSGNRS,ADDSIGN
 ; NOTE: Signers will not show up on tiu in CPRS until it is
 ;       edited or signed
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 set utsuccess=0
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Add additional signers failed - no tiuien")
 new root,vals
 ; Set the tiuien variable in an existing test patient
 ;  form to the newly generated tiu
 set root=$$setroot^%wd("vapals-patients")
 set vals=$name(@root@("graph","XXX00001","siform-2018-11-13"))
 set @vals@("tiuien")=tiuien
 new filter
 set filter("studyid")="XXX00001"
 set filter("form")="siform-2018-11-13"
 set filter("add signers",1)="64^Smith,Mary"
 do ADDSGNRS^SAMIVSTA(.filter) ; sets utsuccess if unit testing
 hang 1
 do CHKEQ^%ut(utsuccess,1,"Testing Adding additional signers  FAILED!")
 quit
 ;
 ;
UTSSN ; @TEST - Pull SSN on a patient
 ; do PTSSN(dfn)
 ; Find patient without SSN filed in Graphstore
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new root set root=$$setroot^%wd("patient-lookup")
 new gien set gien=0
 for  set gien=$order(@root@(gien)) quit:'gien  quit:'($data(@root@(gien,"ssn")))
 if 'gien do  quit
 . do FAIL^%ut("Unable to find Graphstore entry without SSN - FAILED!")
 new utdfn set utdfn=@root@(gien,"dfn")
 if 'utdfn do  quit
 . do FAIL^%ut("Unable to find patient dfn in Graphstore - FAILED!")
 set utsuccess=$$PTSSN^SAMIVSTA(utdfn) ; 2^999989135
 if '($piece(utsuccess,"^",2)=$piece(^DPT(utdfn,0),"^",9)) do  quit
 . do FAIL^%ut("Unable to pull correct patient ssn - FAILED!")
 new GSssn set GSssn=$get(@root@(gien,"ssn"))
 do CHKEQ^%ut($piece(utsuccess,"^",2),GSssn,"Testing PTSSN FAILED!")
 quit
 ;
 ;
UTVSTR ; @TEST - Get Visit string (VSTR) for a TIU note
 ; do VisitString(tiuien)
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new tiuien,node0,node12,VSTR,tiuVSTR
 set tiuien=$order(^TIU(8925,"A"),-1)
 set VSTR=$$VISTSTR^SAMIVSTA(tiuien)
 set node0=$get(^TIU(8925,tiuien,0))
 set node12=$get(^TIU(8925,tiuien,12))
 set tiuVSTR=$piece(node12,"^",5)_";"_$piece(node0,"^",7)_";"_$piece(node0,"^",13)
 do CHKEQ^%ut(VSTR,tiuVSTR,"Testing getting Visit String FAILED!")
 quit
 ;
UTKASAVE ; @TEST - Kill ASAVE node for a TIU note
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new provduz
 set provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 if '$get(provduz) do  quit
 . do FAIL^%ut("Unable to obtain Provider DUZ for ASAVE  - FAILED!")
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Unable to obtain tiuien for ASAVE  - FAILED!")
 set utsuccess=$$KASAVE^SAMIVSTA(provduz,tiuien)
 do CHKEQ^%ut(utsuccess,1,"Testing updating with VPR  FAILED!")
 quit
 ;
UTSIGN ; @TEST - Sign TIU note
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Unable to obtain tiuien for SIGN TIU  - FAILED!")
 new status set status=$piece(^TIU(8925,tiuien,0),"^",5)
 if '(status=5) do  quit
 . do FAIL^%ut("TIU status not 'unsigned' for SIGN TIU  - FAILED!")
 set utsuccess=$$SIGNTIU^SAMIVSTA(tiuien)
 do CHKEQ^%ut(utsuccess,1,"Testing Signing of TIU FAILED!")
 quit
 ;
UTADDND ; @TEST - Add an addendum to a signed note
 ; $$TIUADND(tiuien,userduz)
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Unable to obtain tiuien for Adding Addendum  - FAILED!")
 new provduz
 set provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 if '$get(provduz) do  quit
 . do FAIL^%ut("Unable to obtain Provider DUZ to Add Addendum  - FAILED!")
 new tiuaien set tiuaien=$$TIUADND^SAMIVSTA(tiuien,provduz)
 set:($get(tiuaien)>0) tiuien=tiuien_"^"_tiuaien
 set utsuccess=($get(tiuaien)>0)
 ; Sign the addendum
 new OK set OK=$$SIGNTIU^SAMIVSTA(tiuaien)
 do CHKEQ^%ut(utsuccess,1,"Testing Adding Addendum FAILED!")
 quit
 ;
UTDELTIU ; @TEST - Deleting an unsigned TIU note
 hang 2
 new D,D0,DG,DI,DIC,DICR,DIG,DIH
 new tiuaien set tiuaien=$select($piece(tiuien,"^",2):$piece(tiuien,"^",2),1:0)
 set tiuien=+$get(tiuien)
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Unable to obtain tiuien for Deleting TIU  - FAILED!")
 ; Set note status back to UNSIGNED so we can delete it
 set:$data(^TIU(8925,+tiuien,0)) $piece(^TIU(8925,+tiuien,0),"^",5)=5
 set:$data(^TIU(8925,+tiuaien,0)) $piece(^TIU(8925,+tiuaien,0),"^",5)=5
 ;
 set:$get(tiuaien) utsuccess=$$DELTIU^SAMIVSTA(tiuaien)
 set utsuccess=$$DELTIU^SAMIVSTA(tiuien)
 ;
 do CHKEQ^%ut(utsuccess,1,"Testing Deleting TIU FAILED!")
 quit
 ;
UTURBR ; @TEST - extrinsic to return urban or rural depending on zip code
 new uturbr
 set uturbr=$$URBRUR^SAMIVSTA(40714)
 set uturbr=uturbr_$$URBRUR^SAMIVSTA(40272)
 set uturbr=uturbr_$$URBRUR^SAMIVSTA(99185)
 set utsuccess=(uturbr="urn")
 do CHKEQ^%ut(utsuccess,1,"Testing Urban/Rural extrinsic FAILED!")
 quit
 ;
UTTASK ; @TEST - test TASKIT creation of new note,text, and encounter
 ;get existing siform from graph store.
 new root set root=$$setroot^%wd("vapals-patients")
 new glbrt set glbrt=$name(@root@("graph","XXX00001","siform"))
 set filter("form")=$order(@glbrt)
 ;
 set filter("studyid")="XXX00001"
 new tiuien set tiuien=0
 kill ^TMP("UNIT TEST","UTTASK^SAMIUTVA")
 do TASKIT^SAMIVSTA
 set tiuien=$get(^TMP("UNIT TEST","UTTASK^SAMIUTVA"))
 set utsuccess=$select(tiuien>0:1,1:0)
 do CHKEQ^%ut(utsuccess,1,"Testing creating a new TIU note FAILED!")
 ; If a new note was generated add encounter info
 if tiuien do
 . new ptdfn set ptdfn=$piece(^TIU(8925,tiuien,0),"^",2)
 . new provduz
 . set provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 . do ENCNTR^SAMIVSTA
 . set utsuccess=(tiuien>0)
 . do CHKEQ^%ut(utsuccess,1,"Testing adding encounter informatin FAILED!")
 ; If new note was generated, delete it
 if tiuien do
 . new D,D0,DG,DI,DIC,DICR,DIG,DIH
 . set utsuccess=$$DELTIU^SAMIVSTA(tiuien)
 . do CHKEQ^%ut(utsuccess,1,"Testing deleting TASKIT note  FAILED!")
 quit
 ;
EOR ;End of routine SAMIUTVA
