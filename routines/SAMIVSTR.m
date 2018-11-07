SAMIVSTR ; ven/lgc,arc - IELCAP: M2M to Graph tools ; 10/5/18 8:47am
 ;;1.0;SAMI;;
 ;
 ;@routine-credits
 ;@primary development organization: Vista Expertise Network
 ;@primary-dev: Larry G. Carlson (lgc)
 ;@primary-dev: Alexis R. Carlson (arc)
 ;@copyright:
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-09-26
 ;@application: VA-PALS
 ;@version: 1.0
 ;
 ;@sac-exemption
 ; sac 2.2.8 Vendor specific subroutines may not be called directly
 ;  except by Kernel, Mailman, & VA Fileman.
 ; sac 2.3.3.2 No VistA package may use the following intrinsic
 ;  (system) variables unless they are accessed using Kernel or VA
 ;  FileMan supported references: $D[EVICE], $I[O], $K[EY],
 ;  $P[RINCIPAL], $ROLES, $ST[ACK], $SY[STEM], $Z*.
 ;  (Exemptions: Kernel & VA Fileman)
 ; sac 2.9.1: Application software must use documented Kernel
 ;  supported references to perform all platform specific functions.
 ;  (Exemptions: Kernel & VA Fileman)
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 ;
 ;@API-code: $$RadProcedures(StationNumber) - or -
 ;           D RadProcedures(StationNumber)
 ;@API-called-by: Option : SAMI PULL RADIOLOGY PROCEDURES
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAGV GET RADIOLOGY PROCEDURES
 ;
 ; Pull RadiologyProcedures off the server and build the
 ;    'radiology procedures' Graphstore
 ;Enter
 ;   [StationNumber]  
 ;     if not entered, uses SAMI DEFAULT STATION NUMBER
 ;        parameter entry
 ;Return
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology procedures" Graphstore failed
 ;      n = number of radiology procedures filed
RadProcedures(StationNumber) ;
 I '$L($G(StationNumber)) D
 . S StationNumber=$$GET^XPAR("SYS","SAMI DEFAULT STATION NUMBER",,"Q")
 I '$L($G(StationNumber)) Q:$Q 0  Q
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAGV GET RADIOLOGY PROCEDURES"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)=StationNumber
 S XARRAY(2)=1
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$ClearGraphstore("radiology procedures")
 N I,gien,root s gien=0
 s root=$$setroot^%wd("radiology procedures")
 F I=1:1:$L(XDATA,$C(13,10)) D
 . S RDPRC=$P(XDATA,$C(13,10),I)
 . Q:($L(RDPRC,"^")<3)
 . S gien=gien+1
 . S @root@(gien,"name")=$P(RDPRC,"^")
 . S @root@(gien,"ien71")=$P(RDPRC,"^",2)
 . S @root@(gien,"CPT")=$P(RDPRC,"^",4)
 . S:$L($P(RDPRC,"^")) @root@("name",$P(RDPRC,"^"),gien)=""
 . S:$L($P(RDPRC,"^",4)) @root@("CPT",$P(RDPRC,"^",4),$P(RDPRC,"^"),gien)=""
 ;
 S @root@("Date Last Updated")=$$HTE^XLFDT($H)
 Q:$Q $G(gien)  Q
 ;
 ;
 ;@API-code: $$ActiveRadExams - or - D ActiveRadExams
 ;@API-called-by: Option : SAMI PULL RAD ACTIVE EXAMS
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAGJ RADACTIVEEXAMS
 ;
 ; Pull RadiologyProcedures off the server and build the
 ;    'radiology active exams' Graphstore
 ;Enter
 ;   nothing required
 ;Return
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology active exams" Graphstore failed
 ;      n = number of active exams filed
ActiveRadExams() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAGJ RADACTIVEEXAMS"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="ALL^ALL"
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$ClearGraphstore("radiology active exams")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology active exams")
 ; *** need to run on active system to see how
 ;     to build file
 S @root@("Date Last Updated")=$$HTE^XLFDT($H)
 Q:$Q $G(gien)  Q
 ;
 ;
 ;@API-code: W $$RadStaff - or - D RadStaff
 ;@API-called-by: Option : SAMI PULL RADIOLOGY STAFF
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAD PERSON
 ;
 ; Pull Radiology Staff off the server and build the
 ;    'radiology staff' Graphstore
 ;Enter
 ;   nothing required
 ;Return
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology staff" Graphstore failed
 ;      n = number of radiology staff filed
RadStaff() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM GET RAD PERSON"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="S"
 S XARRAY(2)="" ; All names
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 n si s si=$$ClearGraphstore("radiology staff")
 N I,gien,root,RASTAFF s gien=0
 s root=$$setroot^%wd("radiology staff")
 F I=1:1:$L(XDATA,$C(13,10)) D
 . S RASTAFF=$P(XDATA,$C(13,10),I)
 . Q:($L(RASTAFF,"^")<2)
 . Q:($P(RASTAFF,"^")["-1")
 . S gien=gien+1
 . S @root@(gien,"duz")=$P(RASTAFF,"^")
 . S @root@(gien,"name")=$P(RASTAFF,"^",2)
 . S:$L($P(RASTAFF,"^",2)) @root@("name",$P(RASTAFF,"^",2),gien)=""
 S @root@("Date Last Updated")=$$HTE^XLFDT($H)
 Q:$Q $G(gien)  Q
 ;
 ;
 ;
 ;@API-code: $$RadResidents - or - D RadResidents
 ;@API-called-by: Option : SAMI PULL RADIOLOGY RESIDENTS
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAD PERSON
 ;
 ; Pull Radiology Residents off the server and build the
 ;    'radiology residents' Graphstore
 ;Enter
 ;   nothing required
 ;Return
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology residents" Graphstore failed
 ;      n = number of radiology residents filed
RadResidents() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM GET RAD PERSON"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="R"
 S XARRAY(2)="" ; All names
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$ClearGraphstore("radiology residents")
 N I,gien,root,RARES s gien=0
 s root=$$setroot^%wd("radiology residents")
 F I=1:1:$L(XDATA,$C(13,10)) D
 . S RADRES=$P(XDATA,$C(13,10),I)
 . Q:($L(RADRES,"^")<2)
 . Q:($P(RADRES,"^")["-1")
 . S gien=gien+1,@root@(gien,"duz")=$P(RADRES,"^"),@root@(gien,"name")=$P(RADRES,"^",2)
 . S:$L($P(RADRES,"^",2)) @root@("name",$P(RADRES,"^",2),gien)=""
 S @root@("Date Last Updated")=$$HTE^XLFDT($H)
 Q:$Q $G(gien)  Q
 ;
 ;
 ;
 ;@API-code: $$RadTechs - or - D RadTechs
 ;@API-called-by: Option : SAMI PULL RADIOLOGY TECHS
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAD PERSON
 ;
 ; Pull Radiology Technologists off the server and build the
 ;    'radiology technologists' Graphstore
 ;Enter
 ;   nothing required
 ;Return
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology technologists" Graphstore failed
 ;      n = number of radiology technologists filed
RadTechs() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM GET RAD PERSON"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="T"
 S XARRAY(2)="" ; All names
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$ClearGraphstore("radiology technologists")
 N I,gien,root,RATECH s gien=0
 s root=$$setroot^%wd("radiology technologists")
 F I=1:1:$L(XDATA,$C(13,10)) D
 . S RATECH=$P(XDATA,$C(13,10),I)
 . Q:($L(RATECH,"^")<2)
 . Q:($P(RATECH,"^")["-1")
 . S gien=gien+1
 . S @root@(gien,"duz")=$P(RATECH,"^")
 . S @root@(gien,"name")=$P(RATECH,"^",2)
 . S:$L($P(RATECH,"^",2)) @root@("name",$P(RATECH,"^",2),gien)=""
 S @root@("Date Last Updated")=$$HTE^XLFDT($H)
 Q:$Q $G(gien)  Q
 ;
 ;
 ;@API-code: $$RadModifiers - or - D RadModifiers
 ;@API-called-by: Option : SAMI PULL RADIOLOGY MODIFIERS
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM RADIOLOGY MODIFIERS
 ;
 ; Pull Radiology Modifiers off the server and build the
 ;    'radiology modifiers' Graphstore
 ;Enter
 ;   nothing required
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology modifiers" Graphstore failed
 ;      n = number of radiology modifiers filed
RadModifiers() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM RADIOLOGY MODIFIERS"
 S (CONSOLE,CNTNOPEN)=0
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$ClearGraphstore("radiology modifiers")
 N I,gien,root,RAMOD,TypeOfImage s gien=0
 s root=$$setroot^%wd("radiology modifiers")
 F I=1:1:$L(XDATA,$C(13,10)) D
 . S RAMOD=$P(XDATA,$C(13,10),I)
 . Q:($L(RAMOD,"^")<3)
 . Q:($P(RAMOD,"^")["-1")
 . S gien=gien+1
 . S @root@(gien,"name")=$P(RAMOD,"^")
 . S @root@(gien,"ien71.2")=$P(RAMOD,"^",2)
 . S @root@(gien,"ien79.2")=$P(RAMOD,"^",3)
 . I +$P(RAMOD,"^",3) D
 .. S TypeOfImage=$P($G(^RA(79.2,+$P(RAMOD,"^",3),0)),"^")
 .. S @root@(gien,"type of imaging")=TypeOfImage
 .. S @root@("type of imaging",TypeOfImage,gien)=""
 . S:$L(RAMOD,"^") @root@("name",$P(RAMOD,"^"),gien)=""
 S @root@("Date Last Updated")=$$HTE^XLFDT($H)
 ;
 Q:$Q $G(gien)  Q
 ;
 ;
 ;@API-code: $$RadDxCodes - or - D RadDxCodes
 ;@API-called-by: Option : SAMI PULL RADIOLOGY DX CODES
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAD DX CODE
 ;
 ; Pull Radiology Dx Codes off the server and build the
 ;    'radiology dx codes' Graphstore
 ;Enter
 ;   nothing required
 ;Return
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology dx codes" Graphstore failed
 ;      n = number of radiology dx codes filed
RadDxCodes() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM GET RAD DX CODE"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="" ; All names
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$ClearGraphstore("radiology diagnostic codes")
 N I,gien,root,RATECH s gien=0
 s root=$$setroot^%wd("radiology diagnostic codes")
 F I=1:1:$L(XDATA,$C(13,10)) D
 . S RADXCD=$P(XDATA,$C(13,10),I)
 . Q:($L(RADXCD,"^")<2)
 . Q:($P(RADXCD,"^")["-1")
 . S gien=gien+1
 . S @root@(gien,"ien78.3")=$P(RADXCD,"^")
 . S @root@(gien,"name")=$P(RADXCD,"^",2)
 . S:$L($P(RADXCD,"^",2)) @root@("name",$P(RADXCD,"^",2),gien)=""
 S @root@("Date Last Updated")=$$HTE^XLFDT($H)
 ;
 Q:$Q $G(gien)  Q
 ;
 ;
 ;@API-code: $$ClearGraphstore(name) - or - D ClearGraphstore(name)
 ;
 ;Clear and existing graphstore of data or, if the named
 ;   Graphstore doesn't exist, set a root for the new file
 ;
 ;Enter
 ;   Name of graphstore
 ;Return
 ;   If called as extrinsic
 ;      0   = no Graphstore name entered
 ;      >0  = ien of Graphstore
 ; Clear a Graphstore global of data
ClearGraphstore(name) ;
 i '($l($g(name))) Q:$Q 0  Q
 n si s si=$O(^%wd(17.040801,"B",name,0))
 i $g(si) K ^%wd(17.040801,si) s ^%wd(17.040801,si,0)=name
 e  d purgegraph^%wd(name) s si=$O(^%wd(17.040801,"B",name,0))
 Q:$Q $g(si)  Q
 ;
 ;
 ; ============== UNIT TESTS ======================
 ; NOTE: Unit tests will pull data using the local
 ;       client VistA files rather than risk degrading
 ;       large datasets in use.  NEVERTHELESS, it is
 ;       recommended that UNIT TESTS be run when
 ;       VA-PALS is not in use as some Graphstore globals
 ;       are temporarily moved while testing is running.
 ;
UTRAPCD ; @TEST - Pulling Radiology Procedures through the broker
 ;  RadProcedures(StationNumber)
 K ^KBAP("UNIT TEST RA PROCEDURES")
 n root s root=$$setroot^%wd("radiology procedures")
 m ^KBAP("UNIT TEST RA PROCEDURES")=@root
 N KBAPPRCD,KBAPFAIL S KBAPFAIL=0
 S KBAPPRCD=$$RadProcedures(6100)
 I '$G(KBAPPRCD) D  Q
 . M @root=^KBAP("UNIT TEST RA PROCEDURES")
 . K ^KBAP("UNIT TEST RA PROCEDURES")
 . D FAIL^%ut("No radiology procedures pulled through broker")
 n ien,ien71G,cptG,nameG,entryV
 f ien=1:1:$G(KBAPPVDS) D  Q:$G(KBAPFAIL)
 . s ien71G=@root@(ien,"ien71")
 . I '$D(^RAMIS(71,ien71G,0)) S KBAPFAIL=1 Q
 . s nameG=@root@(ien,"name")
 . s cptG=@root@(ien,"CPT")
 . s entryV=$G(^RAMIS(71,ien71G,0))
 . I '($P(entryV,"^")=name) S KBAPFAIL=1 Q
 . I '($P(entryV,"^",9)=cptG) S KBAPFAIL=1 Q
 D ClearGraphstore("radiology procedures")
 m @root=^KBAP("UNIT TEST RA PROCEDURES")
 K ^KBAP("UNIT TEST RA PROCEDURES")
 D CHKEQ^%ut(KBAPFAIL,0,"Testing pulling rad procedures through broker FAILED!")
 Q
 ;
UTRAEXMS ; @TEST - Pulling Radiology Acive Exams through the broker
 ;  ActiveRadExams
 Q
UTRASTAFF ; @TEST - Pulling all active radiology staff
 ;  RadStaff
 K ^KBAP("UNIT TEST RAD STAFF")
 n root s root=$$setroot^%wd("radiology staff")
 m ^KBAP("UNIT TEST RAD STAFF")=@root
 N KBAPSTAF,KBAPFAIL S KBAPFAIL=0
 S KBAPSTAF=$$RadStaff
 I '$G(KBAPSTAF) D  Q
 . M @root=^KBAP("UNIT TEST RAD STAFF")
 . K ^KBAP("UNIT TEST RAD STAFF")
 . D FAIL^%ut("No radiology staff found.")
 n ien,duzG,nameG
 f ien=1:1:$G(KBAPSTAF) D  Q:$G(KBAPFAIL)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,KBAPFAIL=1
 . F  S cnt=$O(^VA(200,duzG,"RAC",cnt)) Q:'cnt  D
 ..  I ^VA(200,duzG,"RAC",cnt,0)="S" S KBAPFAIL=0
 . Q:KBAPFAIL
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^VA(200,duzG,0)),"^"))) D  Q
 .. S KBAPFAIL=1
 D ClearGraphstore("radiology staff")
 m @root=^KBAP("UNIT TEST RAD STAFF")
 K ^KBAP("UNIT TEST RAD STAFF")
 D CHKEQ^%ut(KBAPFAIL,0,"Testing pulling Radiology Staff through broker FAILED!")
 Q
 ;
UTRARES ; @TEST - Pulling all active radiology residents
 ;  RadResidents
 K ^KBAP("UNIT TEST RAD RESIDENTS")
 n root s root=$$setroot^%wd("radiology residents")
 m ^KBAP("UNIT TEST RAD RESIDENTS")=@root
 N KBAPRES,KBAPFAIL S KBAPFAIL=0
 S KBAPRES=$$RadResidents
 I '$G(KBAPRES) D  Q
 . M @root=^KBAP("UNIT TEST RAD RESIDENTS")
 . K ^KBAP("UNIT TEST RAD RESIDENTS")
 . D FAIL^%ut("No radiology residents found.")
 n ien,duzG,nameG
 f ien=1:1:$G(KBAPRES) D  Q:$G(KBAPFAIL)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,KBAPFAIL=1
 . F  S cnt=$O(^VA(200,duzG,"RAC",cnt)) Q:'cnt  D
 ..  I ^VA(200,duzG,"RAC",cnt,0)="R" S KBAPFAIL=0
 . Q:KBAPFAIL
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^VA(200,duzG,0)),"^"))) D  Q
 .. S KBAPFAIL=1
 D ClearGraphstore("radiology residents")
 m @root=^KBAP("UNIT TEST RAD RESIDENTS")
 K ^KBAP("UNIT TEST RAD RESIDENTS")
 D CHKEQ^%ut(KBAPFAIL,0,"Testing pulling Radiology residents through broker FAILED!")
 Q
 ;
UTRATECH ; @TEST - Pulling all active radiology technologists
 ;  RadTechs
 K ^KBAP("UNIT TEST RAD TECHS")
 n root s root=$$setroot^%wd("radiology technologists")
 m ^KBAP("UNIT TEST RAD TECHS")=@root
 N KBAPTECH,KBAPFAIL S KBAPFAIL=0
 S KBAPTECH=$$RadTechs
 I '$G(KBAPTECH) D  Q
 . M @root=^KBAP("UNIT TEST RAD TECHS")
 . K ^KBAP("UNIT TEST RAD TECHS")
 . D FAIL^%ut("No radiology technologists found.")
 n ien,duzG,nameG
 f ien=1:1:$G(KBAPTECH) D  Q:$G(KBAPFAIL)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,KBAPFAIL=1
 . F  S cnt=$O(^VA(200,duzG,"RAC",cnt)) Q:'cnt  D
 ..  I ^VA(200,duzG,"RAC",cnt,0)="T" S KBAPFAIL=0
 . Q:KBAPFAIL
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^VA(200,duzG,0)),"^"))) D  Q
 .. S KBAPFAIL=1
 D ClearGraphstore("radiology technologists")
 m @root=^KBAP("UNIT TEST RAD TECHS")
 K ^KBAP("UNIT TEST RAD TECHS")
 D CHKEQ^%ut(KBAPFAIL,0,"Testing pulling Radiology technologists through broker FAILED!")
 Q
 ;
UTRAMOD ; @TEST - Pulling all radiology diagnosis modifiers
 ;  RadModifiers
 K ^KBAP("UNIT TEST RAD MODS")
 n root s root=$$setroot^%wd("radiology modifiers")
 m ^KBAP("UNIT TEST RAD MODS")=@root
 N KBAPMODS,KBAPFAIL S KBAPFAIL=0
 S KBAPMODS=$$RadModifiers
 I '$G(KBAPMODS) D  Q
 . M @root=^KBAP("UNIT TEST RAD MODS")
 . K ^KBAP("UNIT TEST RAD MODS")
 . D FAIL^%ut("No radiology diagnosis modifiers found.")
 n ien,ien712G,ien792G,nameG,TypeOfImagingG,ienV,TypeOfImagingV
 f ien=1:1:$G(KBAPMODS) D  Q:$G(KBAPFAIL)
 . s ien712G=@root@(ien,"ien71.2")
 . s nameG=@root@(ien,"name")
 . s ien792G=@root@(ien,"ien79.2")
 . s TypeOfImagingG=@root@(ien,"type of imaging")
 .;  check this entry in 71.2 has an ien79.2 image type
 . n cnt s cnt=0,KBAPFAIL=1
 . F  S cnt=$O(^RAMIS(71.2,ien712G,1,cnt)) Q:'cnt  D
 ..  I $G(^RAMIS(71.2,ien712G,1,cnt,0))=ien792G S KBAPFAIL=0
 . Q:KBAPFAIL
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^RAMIS(71.2,ien712G,0)),"^"))) D  Q
 .. S KBAPFAIL=1
 D ClearGraphstore("radiology modifiers")
 m @root=^KBAP("UNIT TEST RAD MODS")
 K ^KBAP("UNIT TEST RAD MODS")
 D CHKEQ^%ut(KBAPFAIL,0,"Testing pulling Radiology Dx Modifiers through broker FAILED!")
 Q
 ;
UTRADXCD ; @TEST - Pull all radiology diagnostic codes
 ;  RadDxCodes
 K ^KBAP("UNIT TEST RA DX CODES")
 n root s root=$$setroot^%wd("radiology diagnostic codes")
 m ^KBAP("UNIT TEST RA DX CODES")=@root
 N KBAPCODS,KBAPFAIL S KBAPFAIL=0
 S KBAPCODS=$$RadDxCodes
 I '$G(KBAPCODS) D  Q
 . M @root=^KBAP("UNIT TEST RA DX CODES") K ^KBAP("UNIT TEST RA DX CODES") 
 . D FAIL^%ut("No radiology dx codes pulled through broker")
 n ien,ien783G,nameG,nameV
 f ien=1:1:$G(KBAPCODS) D  Q:$G(KBAPFAIL)
 . s ien783G=@root@(ien,"ien78.3")
 . I '$D(^RA(78.3,ien783G,0)) S KBAPFAIL=1 Q
 . s nameG=@root@(ien,"name")
 . s nameV=$P($G(^RA(78.3,ien783G,0)),"^")
 . I '(nameG=nameV) S KBAPFAIL=1 Q
 D ClearGraphstore("radiology diagnostic codes")
 m @root=^KBAP("UNIT TEST RA DX CODES")
 K ^KBAP("UNIT TEST RA DX CODES")
 D CHKEQ^%ut(KBAPFAIL,0,"Testing pulling rad dx codes through broker FAILED!")
 Q
 ;
UTCLRG ; @TEST - Clear a Graphstore of entries
 n root s root=$$setroot^%wd("radiology diagnostic codes")
 K ^KBAP("UNIT TEST CLRGRPH") M ^KBAP("UNIT TEST CLRGRPH")=@root
 n cnt s cnt=$O(@root@("A"),-1)
 I 'cnt D  Q
 . D FAIL^%ut("No 'radiology diagnostic codes' entry")
 s cnt=$$ClearGraphstore("radiology diagnostic codes"),cnt=$O(@root@("A"),-1)
 M @root=^KBAP("UNIT TEST CLRGRPH") K ^KBAP("UNIT TEST CLRGRPH")
 D CHKEQ^%ut(cnt,0,"Clear Graphstore FAILED!")
 Q
 ;
EOR ; End of routine SAMIVSTR
