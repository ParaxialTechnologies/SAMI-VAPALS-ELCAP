SAMIVSTR ; ven/lgc/arc - IELCAP: M2M to Graph tools ; 1/22/19 2:24pm
 ;;1.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
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
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLEd ***" Q
 d EN^%ut($T(+0),2)
 Q
 ;
 ;
 ;@API-code: $$RadProcedures(StationNumber) - or -
 ;           d RadProcedures(StationNumber)
 ;@API-called-by: Option : SAMI PULL RADIOLOGY PROCEDURES
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAGV GET RADIOLOGY PROCEDURES
 ;
 ; Pull RadiologyProcedures off the server and build the
 ;    'radiology procedures' Graphstore
 ;Enter
 ;   [StationNumber]  
 ;     if not entered, uses SAMI DEFAULT STATIOn NUMBER
 ;        parameter entry
 ;Return
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology procedures" Graphstore failed
 ;      n = number of radiology procedures filed
RADPROCD(StationNumber) ;
 I '$l($G(StationNumber)) D
 . s StationNumber=$$GET^XPAR("SYS","SAMI DEFAULT STATIOn NUMBER",,"Q")
 I '$l($G(StationNumber)) q:$Q 0  q
 n CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD,rdprc
 s CNTXT="MAG DICOM VISA"
 s RMPRC="MAGV GET RADIOLOGY PROCEDURES"
 s (CONSOLE,CNTNOPEN)=0
 k SAMIXARR
 s SAMIXARR(1)=StationNumber
 s SAMIXARR(2)=1
 d M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 I '($l(SAMIXD,$c(13,10))) q:$Q 0  q
 ;
 n si s si=$$CLRGRPHS("radiology procedures")
 n I,gien,root s gien=0
 s root=$$setroot^%wd("radiology procedures")
 f I=1:1:$l(SAMIXD,$c(13,10)) D
 . s rdprc=$p(SAMIXD,$c(13,10),I)
 . q:($l(rdprc,"^")<3)
 . s gien=gien+1
 . s @root@(gien,"name")=$p(rdprc,"^")
 . s @root@(gien,"ien71")=$p(rdprc,"^",2)
 . s @root@(gien,"CPT")=$p(rdprc,"^",4)
 . S:$l($p(rdprc,"^")) @root@("name",$p(rdprc,"^"),gien)=""
 . S:$l($p(rdprc,"^",4)) @root@("CPT",$p(rdprc,"^",4),$p(rdprc,"^"),gien)=""
 ;
 s @root@("Date Last Updated")=$$HTE^XLFDT($H)
 q:$Q $G(gien)  q
 ;
 ;
 ;@API-code: $$ActiveRadExams - or - d ActiveRadExams
 ;@API-called-by: Option : SAMI PULL RAd ACTIVE EXAMS
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
 n CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 s CNTXT="MAG DICOM VISA"
 s RMPRC="MAGJ RADACTIVEEXAMS"
 s (CONSOLE,CNTNOPEN)=0
 k SAMIXARR
 s SAMIXARR(1)="ALL^ALL"
 d M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 I '($l(SAMIXD,$c(13,10))) q:$Q 0  q
 ;
 n si s si=$$CLRGRPHS("radiology active exams")
 n gien,root s gien=0
 s root=$$setroot^%wd("radiology active exams")
 ; *** need to run on active system to see how
 ;     to build file
 s @root@("Date Last Updated")=$$HTE^XLFDT($H)
 q:$Q $G(gien)  q
 ;
 ;
 ;@API-code: W $$RadStaff - or - d RadStaff
 ;@API-called-by: Option : SAMI PULL RADIOLOGY STAFF
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAd PERSON
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
 n CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 s CNTXT="MAG DICOM VISA"
 s RMPRC="MAG DICOM GET RAD PERSON"
 s (CONSOLE,CNTNOPEN)=0
 k SAMIXARR
 s SAMIXARR(1)="S"
 s SAMIXARR(2)="" ; All names
 d M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 I '($l(SAMIXD,$c(13,10))) q:$Q 0  q
 n si s si=$$CLRGRPHS("radiology staff")
 n I,gien,root,rastaff s gien=0
 s root=$$setroot^%wd("radiology staff")
 f I=1:1:$l(SAMIXD,$c(13,10)) D
 . s rastaff=$p(SAMIXD,$c(13,10),I)
 . q:($l(rastaff,"^")<2)
 . q:($p(rastaff,"^")["-1")
 . s gien=gien+1
 . s @root@(gien,"duz")=$p(rastaff,"^")
 . s @root@(gien,"name")=$p(rastaff,"^",2)
 . S:$l($p(rastaff,"^",2)) @root@("name",$p(rastaff,"^",2),gien)=""
 s @root@("Date Last Updated")=$$HTE^XLFDT($H)
 q:$Q $G(gien)  q
 ;
 ;
 ;
 ;@API-code: $$RadResidents - or - d RadResidents
 ;@API-called-by: Option : SAMI PULL RADIOLOGY RESIDENTS
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAd PERSON
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
 n CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD,radres
 s CNTXT="MAG DICOM VISA"
 s RMPRC="MAG DICOM GET RAD PERSON"
 s (CONSOLE,CNTNOPEN)=0
 k SAMIXARR
 s SAMIXARR(1)="R"
 s SAMIXARR(2)="" ; All names
 d M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 I '($l(SAMIXD,$c(13,10))) q:$Q 0  q
 ;
 n si s si=$$CLRGRPHS("radiology residents")
 n I,gien,root,RAREs s gien=0
 s root=$$setroot^%wd("radiology residents")
 f I=1:1:$l(SAMIXD,$c(13,10)) D
 . s radres=$p(SAMIXD,$c(13,10),I)
 . q:($l(radres,"^")<2)
 . q:($p(radres,"^")["-1")
 . s gien=gien+1,@root@(gien,"duz")=$p(radres,"^"),@root@(gien,"name")=$p(radres,"^",2)
 . S:$l($p(radres,"^",2)) @root@("name",$p(radres,"^",2),gien)=""
 s @root@("Date Last Updated")=$$HTE^XLFDT($H)
 q:$Q $G(gien)  q
 ;
 ;
 ;
 ;@API-code: $$RadTechs - or - d RadTechs
 ;@API-called-by: Option : SAMI PULL RADIOLOGY TECHS
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAd PERSON
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
 n CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 s CNTXT="MAG DICOM VISA"
 s RMPRC="MAG DICOM GET RAD PERSON"
 s (CONSOLE,CNTNOPEN)=0
 k SAMIXARR
 s SAMIXARR(1)="T"
 s SAMIXARR(2)="" ; All names
 d M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 I '($l(SAMIXD,$c(13,10))) q:$Q 0  q
 ;
 n si s si=$$CLRGRPHS("radiology technologists")
 n I,gien,root,ratech s gien=0
 s root=$$setroot^%wd("radiology technologists")
 f I=1:1:$l(SAMIXD,$c(13,10)) D
 . s ratech=$p(SAMIXD,$c(13,10),I)
 . q:($l(ratech,"^")<2)
 . q:($p(ratech,"^")["-1")
 . s gien=gien+1
 . s @root@(gien,"duz")=$p(ratech,"^")
 . s @root@(gien,"name")=$p(ratech,"^",2)
 . S:$l($p(ratech,"^",2)) @root@("name",$p(ratech,"^",2),gien)=""
 s @root@("Date Last Updated")=$$HTE^XLFDT($H)
 q:$Q $G(gien)  q
 ;
 ;
 ;@API-code: $$RadModifiers - or - d RadModifiers
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
 n CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 s CNTXT="MAG DICOM VISA"
 s RMPRC="MAG DICOM RADIOLOGY MODIFIERS"
 s (CONSOLE,CNTNOPEN)=0
 d M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 I '($l(SAMIXD,$c(13,10))) q:$Q 0  q
 ;
 n si s si=$$CLRGRPHS("radiology modifiers")
 n I,gien,root,ramod,TypeOfImage s gien=0
 s root=$$setroot^%wd("radiology modifiers")
 f I=1:1:$l(SAMIXD,$c(13,10)) D
 . s ramod=$p(SAMIXD,$c(13,10),I)
 . q:($l(ramod,"^")<3)
 . q:($p(ramod,"^")["-1")
 . s gien=gien+1
 . s @root@(gien,"name")=$p(ramod,"^")
 . s @root@(gien,"ien71.2")=$p(ramod,"^",2)
 . s @root@(gien,"ien79.2")=$p(ramod,"^",3)
 . I +$p(ramod,"^",3) D
 .. s TypeOfImage=$p($G(^RA(79.2,+$p(ramod,"^",3),0)),"^")
 .. s @root@(gien,"type of imaging")=TypeOfImage
 .. s @root@("type of imaging",TypeOfImage,gien)=""
 . S:$l(ramod,"^") @root@("name",$p(ramod,"^"),gien)=""
 s @root@("Date Last Updated")=$$HTE^XLFDT($H)
 ;
 q:$Q $G(gien)  q
 ;
 ;
 ;@API-code: $$RadDxCodes - or - d RadDxCodes
 ;@API-called-by: Option : SAMI PULL RADIOLOGY DX CODES
 ;@API-Context menu : MAG DICOM VISA
 ;@API-Remote Procedure : MAG DICOM GET RAd DX CODE
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
 n CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD,radxcd
 s CNTXT="MAG DICOM VISA"
 s RMPRC="MAG DICOM GET RAD DX CODE"
 s (CONSOLE,CNTNOPEN)=0
 k SAMIXARR
 s SAMIXARR(1)="" ; All names
 d M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 I '($l(SAMIXD,$c(13,10))) q:$Q 0  q
 ;
 n si s si=$$CLRGRPHS("radiology diagnostic codes")
 n I,gien,root,RATECH s gien=0
 s root=$$setroot^%wd("radiology diagnostic codes")
 f I=1:1:$l(SAMIXD,$c(13,10)) D
 . s radxcd=$p(SAMIXD,$c(13,10),I)
 . q:($l(radxcd,"^")<2)
 . q:($p(radxcd,"^")["-1")
 . s gien=gien+1
 . s @root@(gien,"ien78.3")=$p(radxcd,"^")
 . s @root@(gien,"name")=$p(radxcd,"^",2)
 . S:$l($p(radxcd,"^",2)) @root@("name",$p(radxcd,"^",2),gien)=""
 s @root@("Date Last Updated")=$$HTE^XLFDT($H)
 ;
 q:$Q $G(gien)  q
 ;
 ;
 ;@API-code: $$CLRGRPHS(name) - or - d CLRGRPHS(name)
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
 i '($l($g(name))) q:$Q 0  q
 n si s si=$O(^%wd(17.040801,"B",name,0))
 i $g(si) k ^%wd(17.040801,si) s ^%wd(17.040801,si,0)=name
 e  d purgegraph^%wd(name) s si=$O(^%wd(17.040801,"B",name,0))
 q:$Q $g(si)  q
 ;
EOR ; End of routine SAMIVSTR
