SAMIORR ;ven/lgc&arc - hl7: ORR enrollment respons ;2021-06-04T13:56Z
 ;;18.0;SAMI;**11**;2020-01;Build 1
 ;;1.18.0.11+i11
 ;
 ; SAMIORR builds and sends an outgoing Order Acknowledgment (ORR)
 ; response message to the Vista production system.
 ; SAMIHL7 contains the development log for the SAMIOR* routines.
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
 ;@primary-dev Larry G. Carlson (lgc)
 ; larry@fiscientific.com
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2020/2021, lgc, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-06-04T13:56Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@submodule HL7 interface - SAMIHL* & SAMIOR*
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11+i11
 ;@release-date 2020-01
 ;@patch-list **11**
 ;
 ;@additional-dev Alexis R. Carlson (arc)
 ; arc@vistaexpertise.net
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; see routine SAMIHL7
 ;
 ;@contents
 ; $$EN-DFN-MSGTYPE-BUILD build & send ORR enrollment response
 ;
 ; MSGTYP table of readable message types
 ; HLENV set HL7 variables
 ; $$SENDHL7 send HL7 message
 ;
 ; PID build PID segment for ORR msg
 ; ORC build ORC segment for ORR msg
 ; OBR build OBR segment for ORR msg
 ; OBXPRC build OBX procedure segment for ORR msg
 ; OBXMOD build OBX modifier segment for ORR msg
 ; NTE build NTE segments for ORR msg
 ; ADD2MSG add segment to OUTHL array
 ;
 ; TSTHL test generating NTE
 ; TESTPID test generating PID
 ; TEST test hli $$EN^SAMIORR
 ; TEST1 build test message
 ;
 ;
 ;
 ;@section 1 hl7 protocol & applications that hli $$EN^SAMIORR calls
 ;
 ;
 ;
 ; SAMI HL7 ORR protocols
 ;
 ; NAME: LSS ENROLL ORR                 TYPE: event driver
 ;   CREATOR: CARLSON,LARRY G              SENDING APPLICATION: VAPALS-ELCAP APP
 ;   TRANSACTION MESSAGE TYPE: ORR         EVENT TYPE: O02
 ;   ACCEPT ACK CODE: AL                   APPLICATION ACK TYPE: NE
 ;   VERSION ID: 2.4
 ; SUBSCRIBERS: LSS ENROLL ORR SUB
 ; 
 ; 
 ; NAME: LSS ENROLL ORR SUB                TYPE: subscriber
 ;   CREATOR: CARLSON,LARRY G              RECEIVING APPLICATION: VISTA-SVR
 ;   EVENT TYPE: O01                       LOGICAL LINK: VA-EL-SRV1
 ;   RESPONSE MESSAGE TYPE: ACK            SENDING FACILITY REQUIRED?: YES
 ;   RECEIVING FACILITY REQUIRED?: YES     SECURITY REQUIRED?: NO
 ;
 ;
 ;
 ; SAMI HL7 ORR applications
 ;
 ; NAME: VAPALS-ELCAP APP               ACTIVE/INACTIVE: ACTIVE
 ;   FACILITY NAME: VISTA HEALTH CARE      MAIL GROUP: SAMI ORM ORR
 ;   COUNTRY CODE: USA                     HL7 ENCODING CHARACTERS: ~&|\
 ;   HL7 FIELD SEPARATOR: ^
 ; 
 ; 
 ; NAME: VISTA-SVR                         ACTIVE/INACTIVE: ACTIVE
 ;   FACILITY NAME: PHOENIX                MAIL GROUP: SAMI ORM ORR
 ;   COUNTRY CODE: USA                     HL7 ENCODING CHARACTERS: ~&|\
 ;   HL7 FIELD SEPARATOR: ^
 ;
 ;
 ;
 ; SAMI HL logical link [hmm, cf PHX ORU]
 ;
 ; NODE: VA-EL-SRV1                        LLP TYPE: TCP
 ;   DEVICE TYPE: Single-threaded Server   STATE: Halting
 ;   AUTOSTART: Enabled                    TIME STOPPED: MAY 11, 2020@14:16:29
 ;   SHUTDOWN LLP ?: YES                   QUEUE SIZE: 10
 ;  DESCRIPTION:   Listener for ORM messages
 ;   RE-TRANSMISSION ATTEMPTS: 3           READ TIMEOUT: 120
 ;   ACK TIMEOUT: 120                      EXCEED RE-TRANSMIT ACTION: ignore
 ;   TCP/IP PORT: 5500                     TCP/IP SERVICE TYPE: SINGLE LISTENER
 ;   PERSISTENT: NO                        IN QUEUE BACK POINTER: 18
 ;   IN QUEUE FRONT POINTER: 18            OUT QUEUE BACK POINTER: 20
 ;   OUT QUEUE FRONT POINTER: 18
 ;
 ;
 ;
 ;@section 2 main hli $$EN^SAMIORR
 ;
 ;
 ;
 ;@hli $$EN^SAMIORR
EN(SNDPROT,filter,notenbr,msgid) ; build & send ORR enrollment response
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;hli;function;clean;silent;sac;0% tests
 ;@called-by
 ; none: not currently active, latent SAMi feature
 ;@calls
 ; $$setroot^%wd
 ; HLENV
 ; PID
 ; ORC
 ; OBR
 ; OBXPRC
 ; OBXMOD
 ; NTE
 ; $$SENDHL7
 ;@input
 ; SNDPROT = name of sending protocol, e.g. LSS ENROLL ORR
 ; notenmbr = note # in vapals-patients graph
 ;@thruput
 ; .filter = array by reference
 ;  filter("sid") = sid, e.g. XXX00034
 ;  filter("key") = sid, e.g. siform-2019-03-05"
 ;  filter("notenmbr") = note # (Cache instance)
 ;@output = HL7 msg id, or -1 = error
 ; HL7 ORR message built & sent
 ; .msgid = HL7 message ID [no longer works]
 ;@other
 ; *** not in use right now
 ; msgtype = 1 = LSS enrollment response
 ;           2 = LSS pre-enrollment discussion
 ;           3 = LSS intake
 ;           4 = LSS CT results follow-up
 ;           5 = LSS communication with veteran
 ;
 ;
 ;@stanza 2 setup
 ;
 if $get(SNDPROT)="" set SNDPROT="LSS ENROLL ORR"
 if '$data(^ORD(101,"B",SNDPROT)) quit -1
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 set filter("rootpl")=rootpl
 ;
 new rootvp set rootvp=$$setroot^%wd("vapals-patients")
 set filter("rootvp")=rootvp
 ;
 if $get(filter("sid"))="" quit -1
 set sid=$get(filter("sid"))
 if '$data(@rootvp@("graph",sid)) quit -1
 ;
 if $get(filter("key"))="" quit -1
 set key=$get(filter("key"))
 if '$data(@rootvp@("graph",sid,key)) quit -1
 ;
 ;
DFN ;@stanza 3 find vpien & plien from sid
 ;
 new vpien,plien
 ; in Cache have to rmove XXX9 for manual entries
 ;
 ; set vpien=+$extract(sid,5,$length(sid))
 ; set filter("vpien")=vpien
 ;
 set vpien=+$extract(sid,4,$length(sid))
 set filter("vpien")=vpien
 if 'vpien quit -1
 ;
 set plien=$order(@rootpl@("dfn",vpien,0))
 set filter("plien")=plien
 if 'plien quit -1
 ;
 ;
MSGTYPE ;@stanza 4 translate message type to readable string
 ;
 set msgtype=+$piece($get(msgtype),".")
 if msgtype<1!(msgtype>5) set msgtype=1
 set msgtype=$piece($text(MSGTYP+msgtype),";;",2)
 ;
 ;
BUILD ;@stanza 5 build & send hl7 msg
 ;
 ; get HL7 vars & escape sequences to build msg
 new HL,HLA,HLECH,HLQ,OUTHL,HLFS,HLCC ; set by HLENV
 do HLENV(SNDPROT)
 ;
 ; build segments in OUTHL
 do PID(.filter,.OUTHL)
 do ORC(.filter,.OUTHL)
 do OBR(.filter,.OUTHL)
 do OBXPRC(.filter,.OUTHL)
 do OBXMOD(.filter,.OUTHL)
 do NTE(.filter,.OUTHL)
 ;
 ; send msg
 new msgid set msgid=$$SENDHL7(.OUTHL)
 ;
 ;
 ;@stanza 6 termination
 ;
 quit msgid ; end of hli $$EN^SAMIORR
 ;
 ;
 ;
 ;@section 3 init & hl7 subroutines
 ;
 ;
 ;
MSGTYP ;; table of readable message types [see MSGTYPE above]
 ;;LSS enrollment response
 ;;LSS pre-enrollment discussion
 ;;LSS intake
 ;;LSS CT results follow-up
 ;;LSS communication with veteran
 ;;
 ;; ***END***
 ;
 ;
 ;
HLENV(SNDPROT) ; set HL7 variables
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; INIT^HLFNC2
 ;@input
 ; SNDPROT = name of sending protocol (file #101)
 ;  e.g. SNDPROT="PHX ENROLL ORM EVN"
 ;@output
 ; ]HL
 ; ]HLA
 ; ]HLECH
 ; ]HLQ
 ; ]HLFS
 ; ]HLCC
 ;
 ; sets all necessary HL variables for building a message; caller is
 ; responsible for newing all output variables
 ;
 ;
 ;@stanza 2 init hl7 variables
 ;
 new PIEN set PIEN=$order(^ORD(101,"B",SNDPROT,0))
 set HL="HLS(""HLS"")"
 new INT set INT=1
 ;
 do INIT^HLFNC2(PIEN,.HL,INT) ; init vars in HL array to build msg
 ;
 set HLFS=$get(HL("FS"))
 set HLECH=$get(HL("ECH"))
 set HLCC=$extract(HLECH)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of HLENV
 ;
 ;
 ;
SENDHL7(OUTHL) ; send HL7 message
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;function;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; GENERATE^HLMA
 ; ^ZTER
 ;@input
 ; .OUTHL = array containing message to send
 ; ^ORD(101,"B",SNDPROT,*) = protocol ien
 ;@output = message ID
 ;
 ;
 ;@stanza 2 call hl7 & send msg
 ;
 kill HLA("HLS")
 merge HLA("HLS")=OUTHL
 ;
 new HLRESLT
 if $data(HLA("HLS")) do
 . set HL("MTN")="ORR"
 . new HLEID set HLEID=$order(^ORD(101,"B","LSS ENROLL ORR",0))
 . new HLARYTYPE set HLARYTYP="LM"
 . new HLFORMAT set HLFORMAT=1
 . new HLMTIEN set HLMTIEN=""
 . new HLP set HLP("PRIORITY")=1
 . ;
 . do GENERATE^HLMA(HLEID,HLARYTYP,HLFORMAT,.HLRESLT) ; send hl7 msg
 . quit
 ;
 do ^ZTER ; log in vista error log
 set msgid=HLRESLT
 ;
 ;
 ;@stanza 3 termination
 ;
 quit msgid ; end of $$SENDHL7
 ;
 ;
 ;
 ;@section 4 hl7 segment subroutines
 ;
 ;
 ;
PID(filter,OUTHL) ; build PID segment for ORR msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; $$UP^XLFSTR
 ; ADD2MSG
 ;@input
 ; .filter = fields array
 ; ]HLFS = field separator
 ; ]HLCC = subfield separator
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Patient Identifier segment (PID) is built from fields pulled
 ; from initiating ORM message, recorded in vapals-patients graph.
 ;
 ;
 ;@stanza 2 get graph root & subscript
 new rootvp set rootvp=$get(filter("rootvp"))
 new rootpl set rootpl=$get(filter("rootpl"))
 new vpien set vpien=$get(filter("vpien"))
 new plien set plien=$get(filter("plien"))
 ;
 ;@stanza 3 PID-2 patient id - external id
 new pid set $piece(pid,HLFS,2)=$get(@rootpl@(plien,"icn"))
 ;
 ;@stanza 4 PID-3 patient id - internal id
 set $piece(pid,HLFS,3)=$get(@rootpl@(plien,"dfn"))_HLCC_"8"_HLCC_"M10"
 ;
 ;@stanza 5 PID-5 patient name, last^first^middle^suffix^prefix
 new name set name=$get(@rootpl@(plien,"saminame"))
 set name=$$UP^XLFSTR(name)
 set $piece(pid,HLFS,5)=$translate(name,",",HLCC)
 ;
 ;@stanza 6 PID-7 date & time of birth
 set $piece(pid,HLFS,7)=$get(@rootpl@(plien,"sbdob"))
 ;
 ;@stanza 7 PID-8 sex
 set $piece(pid,HLFS,8)=$get(@rootpl@(plien,"sex"))
 ;
 ;@stanza 8 PID-11 patient address, line1^line2^city^state^zip^country
 new address1,address2,address3
 new city,state,zip,str
 set address1=$get(@rootpl@(plien,"address1"))
 set address2=$get(@rootpl@(plien,"address2"))
 set address3=$get(@rootpl@(plien,"address3"))
 set city=$get(@rootpl@(plien,"city"))
 set state=$get(@rootpl@(plien,"state"))
 set zip=$get(@rootpl@(plien,"zip"))
 set str=address1_HLCC_address2_address3_HLCC_city_HLCC_state_HLCC_zip
 set $piece(pid,HLFS,11)=str
 ;
 ;@stanza 9 PID-13 phone number - home
 set $piece(pid,HLFS,13)=$get(@rootpl@(plien,"phone"))
 ;
 ;@stanza 10 PID-19 social security #
 set $piece(pid,HLFS,19)=$get(@rootpl@(plien,"ssn"))
 ;
 ;@stanza 11 add PID segment to draft ORR msg
 set pid="PID"_HLFS_pid
 do ADD2MSG(pid)
 ;
 ;
 ;@stanza 12 termination
 ;
 quit  ; end of PID
 ;
 ;
 ;
ORC(filter,OUTHL) ; build ORC segment for ORR msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; $$HTFM^XLFDT
 ; $$FMTHL7^XLFDT
 ; ADD2MSG
 ;@input
 ; .filter = fields array
 ; ]HLFS = field separator
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Common Order segment (ORC) is built from fields pulled from
 ; initiating ORM message, recorded in vapals-patients graph.
 ;
 ;
 ;@stanza 2 get graph root & subscript
 new sid set sid=$get(filter("sid"))
 new key set key=$get(filter("key"))
 new rootvp set rootvp=$get(filter("rootvp"))
 new rootpl set rootpl=$get(filter("rootpl"))
 new vpien set vpien=$get(filter("vpien"))
 new plien set plien=$get(filter("plien"))
 ;
 ;@stanza 3 ORC-1 order control
 new orc set $piece(orc,HLFS,1)="NW"
 ;
 ;@stanza 4 ORC-9 date/time of transaction
 set $piece(orc,HLFS,9)=$$FMTHL7^XLFDT($$HTFM^XLFDT($H))
 ;
 ;@stanza 5 ORC-14 call back phone #
 set $piece(orc,HLFS,14)="206-123-1234"
 ;
 ;@stanza 6 add ORC segment to draft ORR msg
 set orc="ORC"_HLFS_orc
 do ADD2MSG(orc)
 ;
 ;
 ;@stanza 7 termination
 ;
 quit  ; end of ORC
 ;
 ;
 ;
OBR(filter,OUTHL) ; build OBR segment for ORR msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; $$HTFM^XLFDT
 ; $$FMTHL7^XLFDT
 ; ADD2MSG
 ;@input
 ; .filter = fields array
 ; ]HLFS = field separator
 ; ]HLCC = subfield separator
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Observation Request segment (OBR) is built from fields pulled
 ; from initiating ORM message, recorded in vapals-patients graph.
 ;
 ;
 ;@stanza 2 set up
 ;
 new sid set sid=$get(filter("sid"))
 new key set key=$get(filter("key"))
 new rootvp set rootvp=$get(filter("rootvp"))
 new rootpl set rootpl=$get(filter("rootpl"))
 new vpien set vpien=$get(filter("vpien"))
 new plien set plien=$get(filter("plien"))
 ;
 ;@stanza 3 OBR-4 universal service id
 new unvid set unvid="7089898.8453-1"_HLCC_"040391-6"_HLCC_"L"
 new obr set $piece(obr,HLFS,4)=unvid
 ;
 ;@stanza 4 OBR-7 observation date/time
 set $piece(obr,HLFS,7)=$$FMTHL7^XLFDT($$HTFM^XLFDT($horolog))
 ;
 ;@stanza 5 OBR-8 observation end date/time
 set $piece(obr,HLFS,8)=""
 ;
 ;@stanza 6 OBR-9 collection volume
 set $piece(obr,HLFS,9)=""
 ;
 ;@stanza 7 OBR-14 specimen received date/time
 set $piece(obr,HLFS,14)=""
 ;
 ;@stanza 8 OBR-16 ordering provider
 set $piece(obr,HLFS,16)="3232~HL7Doctor~One"
 ;
 ;@stanza 9 OBR-18 placers field #1 (ward/clinic)
 set $piece(obr,HLFS,18)="MEDICINE"
 ;
 ;@stanza 10 OBR-20 fillers field #1 (ward/clinic)
 set $piece(obr,HLFS,20)=""
 ;
 ;@stanza 11 OBR-22 results rpt/status chng-date/time
 set $piece(obr,HLFS,22)=$$FMTHL7^XLFDT($$HTFM^XLFDT($horolog))
 ;
 ;@stanza 12 add OBR segment to draft ORR msg
 set obr="OBR"_HLFS_obr
 do ADD2MSG(obr)
 ;
 ;
 ;@stanza 13 termination
 ;
 quit  ; end of OBR
 ;
 ;
 ;
OBXPRC(filter,OUTHL) ; build OBX procedure segment for ORR msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; ADD2MSG
 ;@input
 ; .filter = fields array
 ; ]HLFS = field separator
 ; ]HLCC = subfield separator
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Observation Result procedure segment (OBX) is built from fields
 ; pulled from initiating ORM message, recorded in vapals-patients
 ; graph.
 ;
 ;
 ;@stanza 2 set up
 ;
 new sid set sid=$get(filter("sid"))
 new key set key=$get(filter("key"))
 new rootvp set rootvp=$get(filter("rootvp"))
 new rootpl set rootpl=$get(filter("rootpl"))
 new vpien set vpien=$get(filter("vpien"))
 new plien set plien=$get(filter("plien"))
 ;
 ;@stanza 3 OBX-2 value type
 new obx set $piece(obx,HLFS,2)="CE"
 ;
 ;@stanza 4 OBX-3 observation identifier
 set $piece(obx,HLFS,3)="P"_HLCC_"PROCEDURE"_HLCC_"L"
 ;
 ;@stanza 5 OBX-5 observation results
 set $piece(obx,HLFS,5)="100"_HLCC_"CHEST PA & LAT"_HLCC_"L"
 ;
 ;@stanza 6 add OBX procedure segment to draft ORR msg
 set obx="OBX"_HLFS_obx
 do ADD2MSG(obx)
 ;
 ;
 ;@stanza 7 termination
 ;
 quit  ; end of OBXPRC
 ;
 ;
 ;
OBXMOD(filter,OUTHL) ; build OBX modifier segment for ORR msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; ADD2MSG
 ;@input
 ; .filter = fields array
 ; ]HLFS = field separator
 ; ]HLCC = subfield separator
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Observation Result procedure segment (OBX) is built from fields
 ; pulled from initiating ORM message, recorded in vapals-patients
 ; graph.
 ;
 ;
 ;@stanza 2 set up
 ;
 new sid set sid=$get(filter("sid"))
 new key set key=$get(filter("key"))
 new rootvp set rootvp=$get(filter("rootvp"))
 new rootpl set rootpl=$get(filter("rootpl"))
 new vpien set vpien=$get(filter("vpien"))
 new plien set plien=$get(filter("plien"))
 ;
 ;@stanza 3 OBX-2 value type
 new obx set $piece(obx,HLFS,2)="TX"
 ;
 ;@stanza 4 OBX-3 observation identifier
 set $piece(obx,HLFS,3)="M"_HLCC_"MODIFIERS"_HLCC_"L"
 ;
 ;@stanza 5 OBX-5 observation results
 set $piece(obx,HLFS,5)="RIGHT, PORTABLE"
 ;
 ;@stanza 6 add OBX procedure segment to draft ORR msg
 set obx="OBX"_HLFS_obx
 do ADD2MSG(obx)
 ;
 ;
 ;@stanza 7 termination
 ;
 quit  ; end of OBXMOD
 ;
 ;
 ;
NTE(filter,OUTHL) ; build NTE segments for ORR msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORR
 ;@calls
 ; ADD2MSG
 ;@input
 ; .filter = fields array
 ; ]HLFS = field separator
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Note segment (NTE) is built from fields recorded in
 ; vapals-patients graph.
 ;
 ;
 ;@stanza 2 set up
 ;
 new sid set sid=$get(filter("sid"))
 new key set key=$get(filter("key"))
 new rootvp set rootvp=$get(filter("rootvp"))
 new node set node=$name(@rootvp@("graph",sid,key,"note"))
 new snode set snode=$piece(node,")")
 ;
 ; *** in Cache use
 ; new node set node=$name(@rootvp@("graph",sid,key,"notes",notenmbr))
 ; new snode set snode=$piece(node,")")
 ;
 ; note: *** in vapals
 ; ^%wd(17.040801,23,"graph","XXX00955","siform-2019-04-12","note"
 ;
 ; note: *** in Cache
 ;^%wd(17.040801,66,"graph","XXX9000076","siform-2020-01-21","notes",1,"date")
 ;^%wd(17.040801,66,"graph","XXX9000076","siform-2020-01-21","notes",1,"name")
 ;^%wd(17.040801,66,"graph","XXX9000076","siform-2020-01-21","notes",1,"text",1)
 ;
 ;
 ;@stanza 3 get note nodes
 ;
 new exit set exit=0
 for  do  quit:exit
 . set node=$query(@node)
 . set exit=node'[snode
 . quit:exit
 . ;
 . new cnt set cnt=$qsubscript(node,7)
 . quit:'cnt
 . ;
 . new segment set segment="NTE"_HLFS_cnt_HLFS_"L"_HLFS_@node
 . do ADD2MSG(segment)
 . quit
 ;
 ;
 ;@stanza 4 termination
 ;
 quit  ; end of NTE
 ;
 ;
 ;
ADD2MSG(segment) ; add segment to OUTHL array
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; PID
 ; ORC
 ; OBR
 ; OBXPRC
 ; OBXMOD
 ; NTE
 ;@calls none
 ;@input
 ; segment = segment to add
 ;@thruput
 ; ]OUTHL = segment added to OUTHL array
 ; ]OUTHL("A") = most recently added segment
 ;
 ;
 ;@stanza 2 add segment
 ;
 new outcnt set outcnt=$order(OUTHL("A"),-1)
 set outcnt=$get(outcnt)+1
 set OUTHL(outcnt)=segment
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of ADD2MSG
 ;
 ;
 ;
 ;@section 5 test subroutines
 ;
 ;
 ;
TSTHL ; test generating NTE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; HLENV^SAMIORR
 ; NTE^SAMIORR
 ;@input
 ; patient-lookup graph
 ; vapals-patients graph
 ; patient XXX00955 in graph
 ; form siform-2019-04-12 in graph
 ; protocol LSS ENROLL ORR
 ;@output
 ; ]HL
 ; ]HLA
 ; ]HLECH
 ; ]HLQ
 ; ]HLFS
 ; ]HLCC
 ; ]OUTHL = message output array
 ;
 ;
 ;@stanza 2 test PID
 ;
 kill OUTHL,SNDPROT
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 set filter("rootpl")=rootpl
 ;
 new rootvp set rootvp=$$setroot^%wd("vapals-patients")
 set filter("rootvp")=rootvp
 ;
 set filter("sid")="XXX00955"
 set filter("key")="siform-2019-04-12"
 ;
 set SNDPROT="LSS ENROLL ORR"
 do HLENV^SAMIORR(SNDPROT) ; set up HL variables
 ;
 do NTE^SAMIORR(.filter,.OUTHL) ; build NTE segments
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TSTHL
 ;
 ;
 ;
TESTPID ; test generating PID
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; HLENV^SAMIORR
 ; PID^SAMIORR
 ;@input
 ; patient-lookup graph
 ; vapals-patients graph
 ; patient XXX00955 in graph
 ; form siform-2019-04-12 in graph
 ; protocol LSS ENROLL ORR
 ;@output
 ; ]HL
 ; ]HLA
 ; ]HLECH
 ; ]HLQ
 ; ]HLFS
 ; ]HLCC
 ; ]OUTHL = message output array
 ;
 ;
 ;@stanza 2 test PID
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 set filter("rootpl")=rootpl
 ;
 new rootvp set rootvp=$$setroot^%wd("vapals-patients")
 set filter("rootvp")=rootvp
 ;
 new sid set sid="XXX00955"
 set filter("sid")=sid
 ;
 new key set key="siform-2019-04-12"
 set filter("key")=key
 ;
 set SNDPROT="LSS ENROLL ORR"
 do HLENV^SAMIORR(SNDPROT) ; set up HL variables
 ;
 new vpien set vpien=+$extract(sid,4,$length(sid))
 set filter("vpien")=vpien
 ;
 new plien set plien=$order(@rootpl@("dfn",vpien,0))
 set filter("plien")=plien
 ;
 do PID^SAMIORR(.filter,.OUTHL) ; build PID segment
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TESTPID
 ;
 ;
 ;
TEST ; test hli $$EN^SAMIORR
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;report;sac;
 ;@called-by none
 ;@calls
 ; $$EN^SAMIORR
 ;@input
 ; patient XXX01017 in graphstore
 ; form siform-2019-03-05 in graphstore
 ;@output
 ; build & send hl7 message
 ;
 ;
 ;@stanza 2 test hli $$EN^SAMIORR
 ;
 new SNDPROT set SNDPROT="LSS ENROLL ORR"
 new filter set filter("sid")="XXX01017"
 set filter("key")="siform-2019-03-05"
 new notenbr set notenbr=1
 new msgid
 ;
 write $$EN^SAMIORR(SNDPROT,.filter,notenbr,.msgid) ; build & send ORR
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TEST
 ;
 ;
 ;
TEST1 ; build test message
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;
 ;@called-by none
 ;@calls none
 ;@input none
 ;@output
 ; ]OUTHL = hl7 msg array containing sample ORR msg
 ;
 ;
 ;@stanza 2 build sample ORR msg
 ;
 kill OUTHL
 set OUTHL(1)="PID^^50001000V910386^1~8~M10^^FOURTEEN~PATIENT~N^^19560708^M^^7^10834 DIXIN DR SOUTH~~SEATTLE~WA~98178^53033^(206)772-2059^^^^29^^444678924^^^^BostonMASSACHUSETTS"
 set OUTHL(2)="ORC^NW^^^^^^^^199104301000"
 set OUTHL(3)="OBR^^^^7089898.8453-1~040391-66~L^^^199104301200^^^^^^^^^3232~HL7Doctor~One^^MEDICINE^^^^199104301000"
 set OUTHL(4)="OBX^^CE^P~PROCEDURE~L^^100~CHEST PA & LAT~L"
 set OUTHL(5)="OBX^^TX^M~MODIFIERS~L^^RIGHT, PORTABLE"
 set OUTHL(6)="OBX^^TX^H~HISTORY~L^^None"
 set OUTHL(7)="OBX^^TX^A~ALLERGIES~L^^BEE STINGS"
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TEST1
 ;
 ;
 ;
EOR ; end of SAMIORR
