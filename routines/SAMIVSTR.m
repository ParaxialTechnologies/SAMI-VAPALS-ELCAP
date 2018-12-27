SAMIVSTR ; ven/lgc,arc - IELCAP: M2M to Graph tools ; 12/27/18 11:13am
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
RADPROCD(StationNumber) ;
 I '$L($G(StationNumber)) D
 . S StationNumber=$$GET^XPAR("SYS","SAMI DEFAULT STATION NUMBER",,"Q")
 I '$L($G(StationNumber)) Q:$Q 0  Q
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA,RDPRC
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAGV GET RADIOLOGY PROCEDURES"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)=StationNumber
 S XARRAY(2)=1
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$CLRGRPHS("radiology procedures")
 N I,gien,root s gien=0
 ;s root=$$setroot^%wd("radiology procedures")
 s root=$$SETROOT("radiology procedures")
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
ACTEXAMS() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAGJ RADACTIVEEXAMS"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="ALL^ALL"
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$CLRGRPHS("radiology active exams")
 N gien,root s gien=0
 ;s root=$$setroot^%wd("radiology active exams")
 s root=$$SETROOT("radiology active exams")
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
RADSTAFF() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM GET RAD PERSON"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="S"
 S XARRAY(2)="" ; All names
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 n si s si=$$CLRGRPHS("radiology staff")
 N I,gien,root,RASTAFF s gien=0
 ;s root=$$setroot^%wd("radiology staff")
 s root=$$SETROOT("radiology staff")
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
RADRESDT() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA,RADRES
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM GET RAD PERSON"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="R"
 S XARRAY(2)="" ; All names
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$CLRGRPHS("radiology residents")
 N I,gien,root,RARES s gien=0
 ;s root=$$setroot^%wd("radiology residents")
 s root=$$SETROOT("radiology residents")
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
RADTECHS() ;
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
 n si s si=$$CLRGRPHS("radiology technologists")
 N I,gien,root,RATECH s gien=0
 ;s root=$$setroot^%wd("radiology technologists")
 s root=$$SETROOT("radiology technologists")
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
RADMODS() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM RADIOLOGY MODIFIERS"
 S (CONSOLE,CNTNOPEN)=0
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$CLRGRPHS("radiology modifiers")
 N I,gien,root,RAMOD,TypeOfImage s gien=0
 ;s root=$$setroot^%wd("radiology modifiers")
 s root=$$SETROOT("radiology modifiers")
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
RADDXCDS() ;
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA,RADXCD
 S CNTXT="MAG DICOM VISA"
 S RMPRC="MAG DICOM GET RAD DX CODE"
 S (CONSOLE,CNTNOPEN)=0
 K XARRAY
 S XARRAY(1)="" ; All names
 D M2M^SAMIM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 I '($L(XDATA,$C(13,10))) Q:$Q 0  Q
 ;
 n si s si=$$CLRGRPHS("radiology diagnostic codes")
 N I,gien,root,RATECH s gien=0
 ;s root=$$setroot^%wd("radiology diagnostic codes")
 s root=$$SETROOT("radiology diagnostic codes")
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
 ;@API-code: $$CLRGRPHS(name) - or - D CLRGRPHS(name)
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
CLRGRPHS(name) ;
 i '($l($g(name))) Q:$Q 0  Q
 n siglb s siglb="^%wd(17.040801,""B"","""_name_""",0)"
 n si s si=$o(@siglb)
 i $g(si) d
 . s siglb="^%wd(17.040801,"_si_")"
 . k @siglb
 . s siglb="^%wd(17.040801,"_si_",0)"
 . s @siglb=name
 e  d
 . s siglb="setroot^%wd("""_name_""")"
 . d @siglb
 . s siglb="^%wd(17.040801,""B"","""_name_""",0)"
 . s si=$o(@siglb)
 Q:$Q $g(si)  Q
 ;
SETROOT(name) ;
 n siglb s siglb="setroot^%wd("""_name_""")"
 d @siglb
 s siglb="^%wd(17.040801,""B"","""_name_""",0)"
 n si s si=$o(@siglb)
 n root s root="^%wd(17.040801,"_si_")"
 q root
 ;
EOR ; End of routine SAMIVSTR
