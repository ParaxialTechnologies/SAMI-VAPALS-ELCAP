SAMIORM ;ven/lgc&arc - HL7: ORM > patient-lookup ;2021-06-08t20:07z
 ;;18.0;SAMI;**11,12**;2020-01;Build 7
 ;;18.12
 ;
 ; SAMIORM parses an incoming Order (ORM) message into the fields
 ; array, then calls SAMIHL7 to use the array to update the patient-
 ; lookup graph.
 ;
 ; SAMIOUL contains the development log for the SAMIHL7 & SAMIOR*
 ; routines.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@dev-main Larry G. Carlson (lgc)
 ; larry@fiscientific.com
 ;@dev-org-main Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2020/2021, lgc, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-06-08t20:07z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@submodule HL7 interface - SAMIHL* & SAMIOR*
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.12
 ;@release-date 2020-01
 ;@patch-list **11,12**
 ;
 ;@dev-add Alexis R. Carlson (arc)
 ; arc@vistaexpertise.net
 ;@dev-add George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; see routine SAMIOUL
 ;@contents
 ; EN-BLDARR-PMSG-UPDTPTL parse ORM msg > patient-lookup graph
 ;
 ; PARSEMSG get patient data f/ORM msg
 ; PID-ORMADDR get patient data from PID segment
 ; PV1 get patient data from PV1 segment
 ; ORC get patient data from ORC segment
 ; OBR get patient data from OBR segment
 ;
 ; TEST test hli EN^SAMIORM
 ;
 ;
 ;
 ;@section 1 hl7 applications & protocols that call hli EN^SAMIORM
 ;
 ;
 ;
 ; SAMI HL logical links
 ;
 ; NODE: LISTENER                          INSTITUTION: VISTA HEALTH CARE
 ;   LLP TYPE: TCP                         DEVICE TYPE: Multi-threaded Server
 ;   STATE: 7757 server                    AUTOSTART: Enabled
 ;   MAILMAN DOMAIN: VAPALS.ELCAP.ORG      SHUTDOWN LLP ?: NO
 ;   QUEUE SIZE: 10                        DO NOT PING: NO
 ;   RE-TRANSMISSION ATTEMPTS: 5           READ TIMEOUT: 600
 ;   ACK TIMEOUT: 600                      EXCEED RE-TRANSMIT ACTION: ignore
 ;   TCP/IP PORT: 5000                     TCP/IP SERVICE TYPE: MULTI LISTENER
 ;   PERSISTENT: YES                       STARTUP NODE: USER:VAPALS
 ;   IN QUEUE BACK POINTER: 117            IN QUEUE FRONT POINTER: 105
 ;   OUT QUEUE BACK POINTER: 76            OUT QUEUE FRONT POINTER: 76
 ;
 ;
 ;
 ; SAMI HL7 applications
 ;
 ; NAME: MCAR-INST                         ACTIVE/INACTIVE: ACTIVE
 ;   FACILITY NAME: VISTA                  COUNTRY CODE: USA
 ;   HL7 ENCODING CHARACTERS: ^~\&         HL7 FIELD SEPARATOR: |
 ;
 ;
 ; NAME: INST-MCAR                         ACTIVE/INACTIVE: ACTIVE
 ;   FACILITY NAME: VAPALS                 COUNTRY CODE: USA
 ;   HL7 ENCODING CHARACTERS: ^~\&         HL7 FIELD SEPARATOR: |
 ;
 ;
 ;
 ; SAMI HL7 ORM protocols
 ;
 ; NAME: MCAR ORM SERVER
 ;   ITEM TEXT: Clinical Procedures ORM Protocol Server
 ;   TYPE: event driver                    CREATOR: LABTECH,FORTYEIGHT
 ;   TIMESTAMP: 59921,33274                SENDING APPLICATION: MCAR-INST
 ;   TRANSACTION MESSAGE TYPE: ORM         EVENT TYPE: O01
 ;   VERSION ID: 2.3
 ; SUBSCRIBERS: PHX ENROLL ORM
 ;
 ;
 ; NAME: PHX ENROLL ORM EVN                TYPE: event driver
 ;   CREATOR: CARLSON,LARRY G              SENDING APPLICATION: MCAR-INST
 ;   TRANSACTION MESSAGE TYPE: ORM         EVENT TYPE: O01
 ;   ACCEPT ACK CODE: AL                   APPLICATION ACK TYPE: NE
 ;   VERSION ID: 2.3
 ; SUBSCRIBERS: PHX ENROLL ORM
 ;
 ;
 ; NAME: PHX ENROLL ORM                    TYPE: subscriber
 ;   CREATOR: CARLSON,LARRY G              RECEIVING APPLICATION: INST-MCAR
 ;   EVENT TYPE: O01                       RESPONSE MESSAGE TYPE: ACK
 ;   PROCESSING ROUTINE: D EN^SAMIORM      SENDING FACILITY REQUIRED?: YES
 ; 
 ; RECEIVING FACILITY REQUIRED?: YES
 ;
 ;
 ;
 ;@section 2 main hli EN^SAMIORM
 ;
 ;
 ;
 ;@hli EN^SAMIORM
EN ; parse ORM message into patient-lookup graph
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;hli;procedure;clean;silent;sac
 ;@falls-thru-to
 ; BLDARR-PMSG-UPDTPTL
 ;@called-by [see section 1]
 ;@calls
 ; $$HTFM^XLFDT
 ; ACK^SAMIHL7
 ;@input [tbd]
 ; ]HLNEXT = executable code that sets HLNODE to next line of hl7 msg
 ; ]HL("ECH")
 ; ]HL("FS")
 ; ]HLREC("MID")
 ;@output [tbd]
 ; patient-lookup graph updated for patient
 ; ^KBAP = debug array
 ; hl7 ACK msg sent
 ;
 ;
 ;@stanza 2 setup
 ;
 kill ^KBAP("SAMIORM")
 set ^KBAP("SAMIORM","EN")=$$HTFM^XLFDT($horolog)_" TEST"
 ;
 ; immediately return COMM ACK  ***** TMP TURNED OFF
 do ACK^SAMIHL7
 ;
 ;
BLDARR ;@stanza 3 pull out message into samihl7 array
 ;
 ;@falls-thru-from
 ; EN
 ;@falls-thru-to
 ; PMSG-UPDTPTL
 ;@called-by none
 ;@calls
 ; $$HTFM^XLFDT
 ;
 new invdt set invdt=9999999.9999-$$HTFM^XLFDT($horolog)
 ;
 new HLARR ; hl7 msg array fetched by xecuting HLNEXT
 new samihl7 ; ditto
 new cnt set cnt=0 ; line count
 for  do  quit:$get(HLNODE)=""
 . xecute HLNEXT ; get next line of hl7 msg
 . quit:$get(HLNODE)=""  ; done when out of lines
 . set cnt=cnt+1 ; count line
 . set HLARR(cnt)=HLNODE ; save line
 . set samihl7(cnt)=HLNODE ; ditto
 . quit
 ;
 kill ^KBAP("SAMIORM","BLDARR")
 merge ^KBAP("SAMIORM","BLDARR","HLARR")=HLARR
 ;
 new INFS set INFS=$get(HL("FS"))
 new INCC set INCC=$extract($get(HL("ECH")))
 ;
 ;
PMSG ;@stanza 4 pull patient data in ORM message > fields array
 ;
 ;@falls-thru-from
 ; EN-BLDARR
 ;@falls-thru-to
 ; UPDTPTL
 ;@called-by none
 ;@calls
 ; PARSEMSG
 ;
 new fields set fields("ORM",invdt,"msgid")=$get(HLREC("MID"))
 do PARSEMSG(.HLARR,.fields) ; get patient data f/ORM msg
 ;
 merge ^KBAP("SAMIORM","samihl7")=samihl7
 merge ^KBAP("SAMIORM","fields")=fields
 ;
 ;
UPDTPTL ;@stanza 5 update patient-lookup graph using fields array
 ;
 ;@falls-thru-from
 ; EN-BLDARR-PMSG
 ;@called-by none
 ;@calls
 ; UPDTPTL^SAMIHL7
 ; $$setroot^%wd
 ;
 do UPDTPTL^SAMIHL7(.fields) ; update patient-lookup w/pat-flds array
 ;
 merge ^KBAP("SAMIORM","fields")=fields
 ;
 ;
 ;@stanza 6 file hl7 msg in patient-lookup graph
 ;
 ; At this point the fields have been filed in the patient with ptien
 ; into the patient lookup graph. I have the ptien in fields("ptien")
 ; and I have the HL7 message segments in samihl7. Time to file the
 ; actual hl7 message into patient lookup. 
 ; NOTE: @rootpl@(ptien,"hl7 counter") was updated in UPDTPTL^SAMIHL7.
 ;
 new ptien set ptien=$get(fields("ptien"))
 quit:'ptien
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 new hl7cnt set hl7cnt=$get(@rootpl@(ptien,"hl7 counter"))
 set fields("ORM",hl7cnt,"msgid")=$get(HLREC("MID"))
 ;
 new cnt set cnt=0
 for  set cnt=$order(samihl7(cnt)) quit:'cnt  do
 . new seg set seg=$extract(samihl7(cnt),1,3)
 . set @rootpl@(ptien,"hl7",hl7cnt,seg)=samihl7(cnt)
 . quit
 ;
 ;
 ;@stanza 7 termination
 ;
 quit  ; end of hli EN^SAMIORM
 ;
 ;
 ;
 ;@section 3 PARSEMSG subroutines
 ;
 ;
 ;
PARSEMSG(HLARR,fields) ; get patient data f/ORM msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; hli EN^SAMIORM
 ;@calls
 ; PID
 ; PV1
 ; ORC
 ; OBR
 ;@input [tbd]
 ; .HLARR = hl7 msg array
 ; ]INFS = field separator
 ; ]INCC = subfield separator
 ; ]HL("FS") = field separator
 ;@output [tbd]
 ; .fields = fields array
 ; ^KBAP = debug array
 ;
 ;
 ;@stanza 2 get patient data
 ;
 set ^KBAP("SAMIORM","PARSEMSG","INFS")=$get(INFS)
 set ^KBAP("SAMIORM","PARSEMSG","INCC")=$get(INCC)
 ;
 ; get patient data from ORM message
 new cnt set cnt=0
 for  do  quit:'cnt
 . set cnt=$order(HLARR(cnt))
 . quit:'cnt
 . ;
 . new segment set segment=HLARR(cnt)
 . new SEG set SEG=$piece(HLARR(cnt),HL("FS"))
 . if SEG="PID" do PID(segment,.fields)
 . if SEG="PV1" do PV1(segment,.fields)
 . if SEG="ORC" do ORC(segment,.fields)
 . if SEG="OBR" do OBR(segment,.fields)
 . quit
 ;
 merge ^KBAP("SAMIORM","fields")=fields
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of PARSEMSG
 ;
 ;
 ;
PID(segment,fields) ; get patient data from PID segment
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@falls-thru-to
 ; ORMADDR
 ;@called-by
 ; PARSEMSG
 ;@calls
 ; $$UP^XLFSTR
 ;@input
 ; .segment = PID segment of hl7 message
 ; ]INFS = field separator
 ; ]INCC = subfield separator
 ;@output
 ; .fields = fields array
 ; ^KBAP = debug array
 ;
 ;
 ;@stanza 2 get patient id #s
 ;
 set ^KBAP("SAMIORM","fields","PID","segment")=segment
 ;
 set fields("icn")="" ; not currently using integration control #
 set fields("ssn")=$piece($piece(segment,INFS,4),INCC)
 ;
 ;
 ;@stanza 3 get patient name
 ;
 new name set name=$$UP^XLFSTR($piece(segment,INFS,6)) ; full upper
 new lname set lname=$piece(name,INCC) ; last
 new fname set fname=$piece(name,INCC,2) ; first
 ;
 new mname set mname="" ; middle
 if $length(name,INCC)>2 set mname=$piece(name,INCC,3)
 ;
 new suffix set suffix="" ; suffix, e.g., JR, 3RD, etc.
 if $length(name,INCC)>3 set suffix=$piece(name,INCC,4)
 ;
 if $length(mname) set fname=fname_" "_mname
 if $length(suffix) set lname=lname_" "_suffix
 set name=lname_","_fname ; replace full
 ;
 set fields("saminame")=name
 set fields("sinamef")=fname
 set fields("sinamel")=lname
 ;
 ;
 ;@stanza 4 get other patient demographics
 ;
 if $length(fields("ssn")),$length(fields("saminame")) do
 . set fields("last5")=$extract(fields("saminame"))_$extract(fields("ssn"),6,9)
 . set ^KBAP("SAMIORM","MadeLast5")=$get(fields("last5"))
 . quit
 ;
 set fields("sbdob")=$piece(segment,INFS,8)
 set fields("sex")=$piece(segment,INFS,9)
 ;
 ;
ORMADDR ;@stanza 5 get address
 ;
 ;@falls-thru-from
 ; PID
 ;@called-by none
 ;@calls none
 ;
 set fields("ORM",invdt,"fulladdress")=$piece(segment,INFS,12)
 ;
 set fields("address1")=$piece($piece(segment,INFS,12),INCC)
 set fields("city")=$piece($piece(segment,INFS,12),INCC,3)
 set fields("state")=$piece($piece(segment,INFS,12),INCC,4)
 set fields("zip")=$piece($piece(segment,INFS,12),INCC,5)
 set fields("phone")=$piece(segment,INFS,14)
 ; set fields("ssn")=$piece(segment,INFS,20)
 ;
 ;
 ;@stanza 6 termination
 ;
 quit  ; end of PID-ORMADDR
 ;
 ;
 ;
PV1(segment,fields) ; get patient data from PV1 segment
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; PARSEMSG
 ;@calls none
 ;@input [tbd]
 ; .segment = PV1 segment of hl7 message
 ; ]INFS = field separator
 ; ]INCC = subfield separator
 ;@output [tbd]
 ; .fields = fields array
 ; ^KBAP = debug array
 ;
 ;
 ;@stanza 2 get patient data
 ;
 set ^KBAP("SAMIORM","fields","PIV","segment")=segment
 ;
 set fields("ORM",invdt,"patientclass")=$piece(segment,INFS,3)
 set fields("ORM",invdt,"assignedlocation")=$piece(segment,INFS,4)
 set fields("ORM",invdt,"providerien")=$piece($piece(segment,INFS,9),INCC)
 set fields("ORM",invdt,"providernm")=$translate($piece($piece(segment,INFS,9),INCC,2,4),"^",",")
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of PV1
 ;
 ;
 ;
ORC(segment,fields) ; get patient data from ORC segment
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; PARSEMSG
 ;@calls none
 ;@input [tbd]
 ; .segment = ORC segment of hl7 message
 ; ]INFS = field separator
 ;@output [tbd]
 ; .fields = fields array
 ; ^KBAP = debug array
 ;
 ;
 ;@stanza 2 get patient data
 ;
 set ^KBAP("SAMIORM","fields","ORC","segment")=segment
 ;
 set fields("ORM",invdt,"ordercontrol")=$piece(segment,INFS,2)
 set fields("ORM",invdt,"ordernumber")=$piece(segment,INFS,3)
 set fields("ORM",invdt,"orderstatus")=$piece(segment,INFS,6)
 set fields("ORM",invdt,"transactiondt")=$piece(segment,INFS,10)
 set fields("ORM",invdt,"ordereffectivedt")=$piece(segment,INFS,16)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of ORC
 ;
 ;
 ;
OBR(segment,fields) ; get patient data from OBR segment
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; PARSEMSG
 ;@calls none
 ;@input [tbd]
 ; .segment = OBR segment of hl7 message
 ; ]INFS = field separator
 ; ]INCC = subfield separator
 ;@output [tbd]
 ; .fields = fields array
 ; ^KBAP = debug array
 ;
 ;
 ;@stanza 2 get patient data
 ;
 set ^KBAP("SAMIORM","fields","OBR","segment")=segment
 ;
 set fields("ORM",invdt,"order")=$piece($piece(segment,INFS,5),INCC)
 ;
 set fields("ORM",invdt,"siteid")=$piece($piece($piece(segment,INFS,5),INCC),"_")
 set fields("siteid")=$piece($piece($piece(segment,INFS,5),INCC),"_")
 ;
 set fields("ORM",invdt,"order2")=$piece($piece(segment,INFS,5),INCC,2)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of OBR
 ;
 ;
 ;
CAMELCAS(str) ; convert string to camel case
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;function;clean;silent;sac
 ;@called-by
 ; PID
 ;@calls
 ; $$LOW^XLFSTR
 ; $$UP^XLFSTR
 ;@input [tbd]
 ; str = string to convert
 ;@output = string in camel case
 ;
 ;
 ;@stanza 2 convert string
 ;
 if $get(str)="" quit str
 set str=$$LOW^XLFSTR(str)
 set str=$$UP^XLFSTR($extract(str,1))_$extract(str,2,$length(str))
 ;
 ;
 ;@stanza 3 termination
 ;
 quit str ; end of $$CAMELCAS
 ;
 ;
 ;
 ;@section 4 test subroutine
 ;
 ;
 ;
TEST ; test hli EN^SAMIORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;sac
 ;@called-by
 ; PID
 ;@calls
 ; $$LOW^XLFSTR
 ; $$UP^XLFSTR
 ;@input [tbd]
 ; str = string to convert
 ;@output = string in camel case
 ;
 ;
 ;@stanza 2 convert string
 ;
 kill HLARR ; hl7 test orm msg
 set HLARR(1)="MSH|^~\&|MCAR-INST|VISTA|INST-MCAR|VAPALS|20200616135751-0700||ORM^O01|6442288610689|P|2.3|||||USA"
 set HLARR(2)="PID|1||000002341||ZZTEST^MACHO^^^^^L||19271106000000|M|||7726 W ORCHID ST^^PHOENIX^AZ^85017||||||||000002341|"
 set HLARR(3)="PV1||O|PHX-PULM RN LSS PHONE|||||244088^GARCIA^DANIEL^P"
 set HLARR(4)="ORC|NW|3200616135751|||NW||||20200616135751||||||20200616135751"
 set HLARR(5)="OBR||||PHO_LUNG^LUNG|"
 ;
 do HLENV^SAMIORU("MCAR ORM SERVER") ; set hl7 variables for testing
 ;
 set HLNEXT="D HLNEXT^HLCSUTL" ; get-next-line qwik
 set HLQUIT=0 ; curent ien of "IN" wp field in msg array in file 771
 ;
 do EN ; parse ORM msg > patient-lookup graph
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TEST
 ;
 ;
 ;
EOR ; end of routine SAMIORM
