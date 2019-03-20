SAMIVST5 ; ven/lgc/arc - M2Broker calls for VA-PALS - RAD; 3/7/19 9:35am ; 3/19/19 9:15am
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
 ;@dmi,@oi (Option: SAMI PULL RADIOLOGY PROCEDURES)
RADPROCD ;Pull RadiologyProcedures off the VA server into graphstore
 ;
 ;May be called as $$RadProcedures(StationNumber) - or -
 ;           do RadProcedures(StationNumber)
 ;Input
 ;   [StationNumber]  
 ;     if not entered, uses SAMI DEFAULT STATION NUMBER
 ;        parameter entry
 ;Exit
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology procedures" Graphstore failed
 ;      n = number of radiology procedures filed
 ;
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
 new si set si=$$CLRGRPS^SAMIVSTA("radiology procedures")
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
 ;@dmi,@oi (option :SAMI PULL RAd ACTIVE EXAMS)
ACTEXAMS ; Pull RadiologyProcedures off the VA server into graphstore
 ;
 ;Input
 ;   nothing required
 ;Exit
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology active exams" Graphstore failed
 ;      n = number of active exams filed
 ;
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAGJ RADACTIVEEXAMS"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="ALL^ALL"
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPS^SAMIVSTA("radiology active exams")
 new gien,root set gien=0
 set root=$$setroot^%wd("radiology active exams")
 ; *** need to run on active system to see how
 ;     to build file
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 quit:$Q $get(gien)  quit
 ;
 ;
 ;@dmi,@oi (Option : SAMI PULL RADIOLOGY STAFF)
RADSTAFF ; Pull Radiology Staff off the VA server into graphstore
 ;
 ;Input
 ;   nothing required
 ;Exit
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology staff" Graphstore failed
 ;      n = number of radiology staff filed
 ;
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM GET RAD PERSON"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="S"
 set SAMIXARR(2)="" ; All names
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 new si set si=$$CLRGRPS^SAMIVSTA("radiology staff")
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
 ;@dmi,@oi (SAMI PULL RADIOLOGY RESIDENTS)
RADRESDT ; Pull Radiology Residents off the VA server into graphstore
 ;
 ;Input
 ;   nothing required
 ;Exit
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology residents" Graphstore failed
 ;      n = number of radiology residents filed
 ;
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
 new si set si=$$CLRGRPS^SAMIVSTA("radiology residents")
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
 ;@dmi,@oi (Option: SAMI PULL RADIOLOGY TECHS)
 ;
RADTECHS ; Pull Radiology Technologists off the VA server into graphstore
 ;
 ;Input
 ;   nothing required
 ;Exit
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology technologists" Graphstore failed
 ;      n = number of radiology technologists filed
 ;
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
 new si set si=$$CLRGRPS^SAMIVSTA("radiology technologists")
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
 ;@dmi,@oi (Option : SAMI PULL RADIOLOGY MODIFIER)
RADMODS ; Pull Radiology Modifiers off the VA server and build graphstore
 ;
 ;Enter
 ;   nothing required
 ;Exit
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology modifiers" Graphstore failed
 ;      n = number of radiology modifiers filed
 ;
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM RADIOLOGY MODIFIERS"
 set (CONSOLE,CNTNOPEN)=0
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPS^SAMIVSTA("radiology modifiers")
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
 ;@dmi,@oi (Option: SAMI PULL RADIOLOGY DX CODES)
RADDXCDS ; Pull Radiology Dx Codes off the server and build graphstore
 ;
 ;Input
 ;   nothing required
 ;Exit
 ;   If called as extrinsic
 ;      0 = rebuild of "radiology dx codes" Graphstore failed
 ;      n = number of radiology dx codes filed
 ;
 new CNTXT,RMPRC,CONSOLE,CNTNOPEN,SAMIXARR,SAMIXD,radxcd
 set CNTXT="MAG DICOM VISA"
 set RMPRC="MAG DICOM GET RAD DX CODE"
 set (CONSOLE,CNTNOPEN)=0
 kill SAMIXARR
 set SAMIXARR(1)="" ; All names
 do M2M^SAMIM2M(.SAMIXD,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.SAMIXARR)
 if '($length(SAMIXD,$char(13,10))) quit:$Q 0  quit
 ;
 new si set si=$$CLRGRPS^SAMIVSTA("radiology diagnostic codes")
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
EOR ; End of routine SAMIVST5
