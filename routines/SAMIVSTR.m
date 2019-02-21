SAMIVSTR ; ven/lgc/arc - IELCAP: M2M to Graph tools ; 2019-02-21T21:50pm
 ;;1.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ;@routine-credits
 ;@primary development organization: Vista Expertise Network
 ;@primary-dev: Larry G. Carlson (lgc)
 ;@primary-dev: Alexis R. Carlson (arc)
 ;@additional-dev: Linda M. R. Yaw (lmry)
 ;@copyright:
 ;@license: see routine SAMIUL
 ;
 ;@last-updated: 2019-02-21
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
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ;
 ;@API-code: $$RadProcedures(StationNumber) - or -
 ;           do RadProcedures(StationNumber)
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
 if '$length($get(StationNumber)) do
 . set StationNumber=$$GET^XPAR("SYS","SAMI DEFAULT STATIOn NUMBER",,"Q")
 if '$length($get(StationNumber)) quit:$Q 0  quit
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD,rdprc
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAGV GET RADIOLOGY PROCEDURES"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)=StationNumber
 set SAMIXARR(2)=1
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPHS("radiology procedures")
 new I,gien,root set gien=0
 set root=$$setroot^%wd("radiology procedures")
 for I=1:1:$length(SAMIXD,$char(13,10)) do
 . set rdprc=$piece(SAMIXD,$char(13,10),I)
 . quit:($length(rdprc,"^")<3)
 . set gien=gien+1
 . set @root@(gien,"name")=$piece(rdprc,"^")
 . set @root@(gien,"ien71")=$piece(rdprc,"^",2)
 . set @root@(gien,"CPT")=$piece(rdprc,"^",4)
 . set:$length($piece(rdprc,"^")) @root@("name",$piece(rdprc,"^"),gien)=""
 . set:$length($piece(rdprc,"^",4)) @root@("CPT",$piece(rdprc,"^",4),$piece(rdprc,"^"),gien)=""
 ;
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 quit:$Q $get(gien)  quit
 ;
 ;
 ;@API-code: $$ActiveRadExams - or - do ActiveRadExams
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
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAGJ RADACTIVEEXAMS"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="ALL^ALL"
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPHS("radiology active exams")
 new gien,root set gien=0
 set root=$$setroot^%wd("radiology active exams")
 ; *** need to run on active system to see how
 ;     to build file
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 quit:$Q $get(gien)  quit
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
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM GET RAD PERSON"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="S"
 set SAMIXARR(2)="" ; All names
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 new si set si=$$CLRGRPHS("radiology staff")
 new I,gien,root,rastaff set gien=0
 set root=$$setroot^%wd("radiology staff")
 for I=1:1:$length(SAMIXD,$char(13,10)) do
 . set rastaff=$piece(SAMIXD,$char(13,10),I)
 . quit:($length(rastaff,"^")<2)
 . quit:($piece(rastaff,"^")["-1")
 . set gien=gien+1
 . set @root@(gien,"duz")=$piece(rastaff,"^")
 . set @root@(gien,"name")=$piece(rastaff,"^",2)
 . set:$length($piece(rastaff,"^",2)) @root@("name",$piece(rastaff,"^",2),gien)=""
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 quit:$Q $get(gien)  quit
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
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD,radres
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM GET RAD PERSON"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="R"
 set SAMIXARR(2)="" ; All names
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPHS("radiology residents")
 new I,gien,root,RAREs set gien=0
 set root=$$setroot^%wd("radiology residents")
 for I=1:1:$length(SAMIXD,$char(13,10)) do
 . set radres=$piece(SAMIXD,$char(13,10),I)
 . quit:($length(radres,"^")<2)
 . quit:($piece(radres,"^")["-1")
 . set gien=gien+1,@root@(gien,"duz")=$piece(radres,"^"),@root@(gien,"name")=$piece(radres,"^",2)
 . set:$length($piece(radres,"^",2)) @root@("name",$piece(radres,"^",2),gien)=""
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 quit:$Q $get(gien)  quit
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
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM GET RAD PERSON"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="T"
 set SAMIXARR(2)="" ; All names
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPHS("radiology technologists")
 new I,gien,root,ratech set gien=0
 set root=$$setroot^%wd("radiology technologists")
 for I=1:1:$length(SAMIXD,$char(13,10)) do
 . set ratech=$piece(SAMIXD,$char(13,10),I)
 . quit:($length(ratech,"^")<2)
 . quit:($piece(ratech,"^")["-1")
 . set gien=gien+1
 . set @root@(gien,"duz")=$piece(ratech,"^")
 . set @root@(gien,"name")=$piece(ratech,"^",2)
 . set:$length($piece(ratech,"^",2)) @root@("name",$piece(ratech,"^",2),gien)=""
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 quit:$Q $get(gien)  quit
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
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM RADIOLOGY MODIFIERS"
 set (CONSOLE,CNTNOPEN)=0
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPHS("radiology modifiers")
 new I,gien,root,ramod,TypeOfImage set gien=0
 set root=$$setroot^%wd("radiology modifiers")
 for I=1:1:$length(SAMIXD,$char(13,10)) do
 . set ramod=$piece(SAMIXD,$char(13,10),I)
 . quit:($length(ramod,"^")<3)
 . quit:($piece(ramod,"^")["-1")
 . set gien=gien+1
 . set @root@(gien,"name")=$piece(ramod,"^")
 . set @root@(gien,"ien71.2")=$piece(ramod,"^",2)
 . set @root@(gien,"ien79.2")=$piece(ramod,"^",3)
 . if +$piece(ramod,"^",3) do
 .. set TypeOfImage=$piece($get(^RA(79.2,+$piece(ramod,"^",3),0)),"^")
 .. set @root@(gien,"type of imaging")=TypeOfImage
 .. set @root@("type of imaging",TypeOfImage,gien)=""
 . set:$length(ramod,"^") @root@("name",$piece(ramod,"^"),gien)=""
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 ;
 quit:$Q $get(gien)  quit
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
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD,radxcd
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM GET RAD DX CODE"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="" ; All names
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPHS("radiology diagnostic codes")
 new I,gien,root,RATECH set gien=0
 set root=$$setroot^%wd("radiology diagnostic codes")
 for I=1:1:$length(SAMIXD,$char(13,10)) do
 . set radxcd=$piece(SAMIXD,$char(13,10),I)
 . quit:($length(radxcd,"^")<2)
 . quit:($piece(radxcd,"^")["-1")
 . set gien=gien+1
 . set @root@(gien,"ien78.3")=$piece(radxcd,"^")
 . set @root@(gien,"name")=$piece(radxcd,"^",2)
 . set:$length($piece(radxcd,"^",2)) @root@("name",$piece(radxcd,"^",2),gien)=""
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 ;
 quit:$Q $get(gien)  quit
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
 if '($length($get(name))) quit:$Q 0  quit
 new si set si=$order(^%wd(17.040801,"B",name,0))
 if $get(si) kill ^%wd(17.040801,si) set ^%wd(17.040801,si,0)=name
 else  do purgegraph^%wd(name) set si=$order(^%wd(17.040801,"B",name,0))
 quit:$Q $get(si)  quit
 ;
EOR ; End of routine SAMIVSTR
