SAMIORU ;ven/lgc&arc - hl7: ORU enrollment reponse ;2021-06-04T13:12Z
 ;;18.0;SAMI;**8,11**;2020-01;Build 2
 ;;1.18.0.11+i11
 ;
 ; SAMIORU builds and sends an outgoing Observation Reporting (ORU)
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
 ;@last-updated 2021-06-04T13:12Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@submodule HL7 interface - SAMIHL* & SAMIOR*
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11+i11
 ;@release-date 2020-01
 ;@patch-list **8,11**
 ;
 ;@additional-dev Alexis R. Carlson (arc)
 ; arc@vistaexpertise.net
 ;@additional-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; see routine SAMIHL7
 ;
 ;@contents
 ; $$EN-DFN-FINDORM-HL7VARS build & send ORU enrollment response
 ;
 ; ORMVARS get vars fr/patient's most recent ORM
 ; HLENV set HL7 variables
 ; $$SENDHL7 send HL7 message
 ;
 ; PID build PID segment for ORU msg
 ; OBR build OBR segment for ORU msg
 ; OBX build OBX segment for ORU msg
 ; ADD2MSG add segment to OUTHL array
 ;
 ; TESTPID test generating PID
 ; TESTOBR test generating OBR
 ; TESTOBXV test generating OBX in vapalsyotta
 ; TESTOBXC test generating OBX in Cache
 ; TESTALL test hli $$EN^SAMIORU
 ;
 ;
 ;
 ;@section 1 hl7 protocol & applications that hli $$EN^SAMIORU calls
 ;
 ;
 ;
 ; SAMI HL7 ORU protocols
 ;
 ; NAME: PHX ENROLL ORU EVN                TYPE: event driver
 ;   CREATOR: CARLSON,LARRY G              SENDING APPLICATION: PHX ORU SEND
 ;   TRANSACTION MESSAGE TYPE: ORU         EVENT TYPE: R01
 ;   ACCEPT ACK CODE: AL                   APPLICATION ACK TYPE: NE
 ;   VERSION ID: 2.3
 ; SUBSCRIBERS: PHX ENROLL ORU RECV
 ;
 ;
 ; NAME: PHX ENROLL ORU RECV               TYPE: subscriber
 ;   CREATOR: CARLSON,LARRY G              RECEIVING APPLICATION: PHX ORU RECV
 ;   EVENT TYPE: R01                       LOGICAL LINK: PHX ORU
 ;   RESPONSE MESSAGE TYPE: ACK            SENDING FACILITY REQUIRED?: YES
 ;   RECEIVING FACILITY REQUIRED?: YES
 ;
 ;
 ;
 ; SAMI HL7 ORU applications
 ;
 ; NAME: PHX ORU SEND                      ACTIVE/INACTIVE: ACTIVE
 ;   FACILITY NAME: VAPALS                 COUNTRY CODE: USA
 ;   HL7 ENCODING CHARACTERS: ^~\&         HL7 FIELD SEPARATOR: |
 ;
 ;
 ; NAME: PHX ORU RECV                      ACTIVE/INACTIVE: ACTIVE
 ;   FACILITY NAME: VISTA                  COUNTRY CODE: USA
 ;   HL7 ENCODING CHARACTERS: ^~\&         HL7 FIELD SEPARATOR: |
 ;
 ;
 ;
 ; SAMI HL logical link
 ;
 ; NODE: PHX ORU                           INSTITUTION: PHOENIX
 ;   LLP TYPE: TCP                         DEVICE TYPE: Non-Persistent Client
 ;   STATE: Inactive                       AUTOSTART: Enabled
 ;   TIME STARTED: AUG 17,2020@00:15:48    SHUTDOWN LLP ?: NO
 ;   QUEUE SIZE: 10                        RE-TRANSMISSION ATTEMPTS: 3
 ;   READ TIMEOUT: 120                     ACK TIMEOUT: 120
 ;   EXCEED RE-TRANSMIT ACTION: ignore     TCP/IP ADDRESS: ---.---.---.---
 ;   TCP/IP PORT: 5000                     TCP/IP SERVICE TYPE: CLIENT (SENDER)
 ;   PERSISTENT: NO                        IN QUEUE BACK POINTER: 16
 ;   IN QUEUE FRONT POINTER: 16            OUT QUEUE BACK POINTER: 16
 ;   OUT QUEUE FRONT POINTER: 16
 ;
 ;
 ;
 ;@section 2 main hli $$EN^SAMIORU
 ;
 ;
 ;
 ;@hli $$EN^SAMIORU
EN(filter) ; build & send ORU enrollment response
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;hli;function/procedure;clean;silent;sac;0% tests
 ;@called-by
 ; wsi WSVAPALS^SAMIHOM3
 ;@calls
 ; $$setroot^%wd
 ; ORMVARS^SAMIORU
 ; HLENV
 ; PID
 ; OBR
 ; OBX
 ; $$SENDHL7
 ;@input
 ; .filter = array by reference
 ;  filter("sendprotocol") = defaults to Phoenix
 ;  filter("sid") = sid, e.g. PHO00015
 ;  filter("key") = sid, e.g. siform-2020-07-30
 ;  filter("notenmbr") = note # in vapals-patients graph, e.g. 2
 ;  filter("climit") = max #chars/line for text to display in CPRS
 ;   defaults to 66
 ; [patient data from patient-lookup graph]
 ;@output = msgid - message generated or 0 - error, if function call
 ; filter("rslt") = output if procedure call
 ; HL7 ORU msg is built & sent
 ;
 ; NOTE: We will only be sending ORU messages out for patients for
 ; whom at least one ORM has been received. Thus, we can trust the
 ; info stored in the patient-lookup graph through an incoming ORM to
 ; fill in fields of any ORU generated messages.
 ;
 ;
 ;@stanza 2 setup
 ;
 ; debug
 ; kill ^KBAP("SAMIORU")
 ; merge ^KBAP("SAMIORU","filter")=filter
 ;
 set filter("rslt")=0
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 set filter("rootpl")=rootpl
 ;
 new rootvp set rootvp=$$setroot^%wd("vapals-patients")
 set filter("rootvp")=rootvp
 ;
 new sid set sid=$get(filter("sid"))
 if sid="" do  quit:$quit filter("rslt")  quit
 . set filter("rlst")="0^no sid provided"
 . quit
 ;
 new key set key=$get(filter("key"))
 if key="" do  quit:$quit filter("rslt")  quit
 . set filter("rslt")="0^no key provided"
 . quit
 ;
 new SNDPROT set SNDPROT=$get(filter("sendprotocol"))
 if SNDPROT="" do
 . set (SNDPROT,filter("sendprotocol"))="PHX ENROLL ORU EVN"
 . quit
 ;
 new notenmbr set notenmbr=+$get(filter("notenmbr"))
 if notenmbr=0 do  quit:$quit filter("rslt")  quit
 . set filter("rslt")="0^no note number provided"
 . quit
 ;
 ; merge ^KBAP("SAMIORU","filter2")=filter
 ;
 ;
DFN ;@stanza 3 find vpien & plien from sid
 ;
 new dfn set dfn=@rootvp@("graph",sid,key,"dfn")
 set filter("dfn")=dfn
 ;
 new vpien set vpien=dfn
 set filter("vpien")=vpien
 ;
 new plien set plien=$order(@rootpl@("dfn",vpien,0))
 set filter("plien")=plien
 ;
 ; get data from entry in patient-lookup graph
 merge filter=@rootpl@(plien)
 ;
 ;
FINDORM ;@stanza 4 return error if no ORM found
 ;
 if '$data(filter("ORM")) do  quit:$quit filter("rslt")  quit
 . set filter("rslt")="0^Patient does not have previous ORM"
 . quit
 ;
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter)
 ;
 ; merge ^KBAP("SAMIORU","filter","ORM")=filter
 ;
 ;
HL7VARS ;@stanza 5 build & send hl7 msg
 ;
 ; get HL7 vars & escape sequences to build msg
 new HL,HLA,HLECH,HLQ,OUTHL,HLFS,HLCC ; set by HLENV
 do HLENV(SNDPROT)
 ;
 ; build segments in OUTHL
 do PID(HLFS,HLCC,.filter,.OUTHL)
 do OBR(HLFS,HLCC,.filter,.OUTHL)
 do OBX(HLFS,HLCC,.filter,.OUTHL)
 ;
 ; send msg
 new msgid set msgid=$$SENDHL7(SNDPROT,.OUTHL)
 set filter("rslt")=msgid
 ;
 ; if a message id is returned, preface it with 1^
 set:+$get(filter("rslt")) filter("rslt")=1_"^"_filter("rslt")
 ;
 ;
 ;@stanza 6 termination
 ;
 quit:$quit $get(filter("rslt")) ; if called as function
 quit  ; end of hli $$EN^SAMIORU
 ;
 ;
 ;
 ;@section 3 init & hl7 subroutines
 ;
 ;
 ;
ORMVARS(plien,filter) ; get vars fr/patient's most recent ORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORU
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; plien
 ; [patient data from patient-lookup graph]
 ;@output
 ; .filter
 ;  filter("assignedlocation")="PHX-PULM RN LSS PHONE"
 ;  filter("fulladdress")="7726 W ORCHID ST^^PHOENIX^AZ^85017"
 ;  filter("msgid")="99000031ORM"
 ;  filter("order")="PHO_LUNG"
 ;  filter("order2")="LUNG"
 ;  filter("ordercontrol")="NW"
 ;  filter("ordereffectivedt")=20200616135751
 ;  filter("ordernumber")=3200616135751
 ;  filter("orderstatus")="NW"
 ;  filter("patientclass")="O"
 ;  filter("providerien")=244088
 ;  filter("providernm")="GARCIA,DANIEL,P"
 ;  filter("siteid")="PHO"
 ;  filter("transactiondt")=20200616135751
 ;
 ; get variables from most recent ORM on this patient; builds extra
 ; filter vars from the most recent ORM array found in the patient's
 ; patient-lookup graph:
 ;
 ;@stanza 2 get variables from patient-lookup graph
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 ;
 new exit set exit=0
 new node set node=$name(@rootpl@(plien,"ORM"))
 new snode set snode=$piece(node,")")
 new invdt set invdt=$qsubscript($query(@node),5)
 for  do  quit:exit
 . set node=$query(@node)
 . set exit=node'[snode!(node'[invdt)
 . quit:exit
 . ;
 . new var set var=$qsubscript(node,6)
 . set filter(var)=@node
 . quit
 ;
 ; don't confuse ORM message id with ORU message id
 if $data(filter("msgid")) do
 . set filter("ormmsgid")=filter("msgid")
 . kill filter("msgid")
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of ORMVARS
 ;
 ;
 ;
HLENV(SNDPROT) ; set HL7 variables
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORU
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
SENDHL7(SNDPROT,OUTHL) ; send HL7 message
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;function;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORU
 ;@calls
 ; GENERATE^HLMA
 ;@input
 ; SNDPROT = name of the sending protocol
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
 ; zwrite HLA("HLS")
 ;
 new HLRESLT
 if $data(HLA("HLS")) do
 . ; write !,"GOT TO HERE"
 . set HL("MTN")="ORU"
 . new HLEID set HLEID=$order(^ORD(101,"B",SNDPROT,0))
 . new HLARYTYP set HLARYTYP="LM"
 . new HLFORMAT set HLFORMAT=1
 . new HLMTIEN set HLMTIEN=""
 . new HLP set HLP("PRIORITY")=1
 . ;
 . do GENERATE^HLMA(HLEID,HLARYTYP,HLFORMAT,.HLRESLT) ; send hl7 msg
 . ;
 . ; write !,"HLRESLT=",$get(HLRESLT),!
 . quit
 ;
 set msgid=$get(HLRESLT)
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
PID(HLFS,HLCC,filter,OUTHL) ; build PID segment for ORU msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORU
 ;@calls
 ; $$UP^XLFSTR
 ; ADD2MSG
 ;@input
 ; HLFS = field separator
 ; HLCC = subfield separator
 ; .filter = fields array
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Patient Identifier segment (PID) is built from fields pulled
 ; from initiating ORM message, recorded in vapals-patients graph.
 ;
 ;
 ;@stanza 2 get graph root & subscript
 new rootpl set rootpl=$get(filter("rootpl"))
 new plien set plien=$get(filter("plien"))
 ;
 ;@stanza 3 PID-1 set id - patient id
 new pid set $piece(pid,HLFS,1)=1
 ;
 ;@stanza 4 PID-3 patient id - internal id
 new ssn set ssn=$get(@rootpl@(plien,"ssn"))
 set $piece(pid,HLFS,3)=$get(ssn)
 ;
 ;@stanza 5 PID-5 patient name, last^first^middle^suffix^prefix
 new name set name=$get(@rootpl@(plien,"saminame"))
 set name=$translate($$UP^XLFSTR(name),",",HLCC)
 set $piece(name,HLCC,7)="L"
 set $piece(pid,HLFS,5)=$get(name)
 ;
 ;@stanza 6 PID-7 date & time of birth
 new dob set dob=$get(filter("sbdob"))
 set $piece(pid,HLFS,7)=$get(dob)
 ;
 ;@stanza 7 PID-8 sex
 new sex set sex=$get(filter("sex"))
 set $piece(pid,HLFS,8)=$get(sex)
 ;
 ;@stanza 8 PID-11 patient address, line1^line2^city^state^zip^country
 new fulladdress set fulladdress=$get(filter("fulladdress"))
 set $piece(pid,HLFS,11)=$get(fulladdress)
 ;
 ;@stanza 9 PID-18 patient account #
 set $piece(pid,HLFS,13)=""
 ;
 ;@stanza 10 social security #
 set $piece(pid,HLFS,19)=$get(@rootpl@(plien,"ssn"))
 ;
 ;@stanza 11 add PID segment to draft ORU msg
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
OBR(HLFS,HLCC,filter,OUTHL) ; build OBR segment for ORU msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORU
 ;@calls
 ; $$HTFM^XLFDT
 ; $$FMTHL7^XLFDT
 ; ADD2MSG
 ;@input
 ; HLFS = field separator
 ; HLCC = subfield separator
 ; .filter = fields array
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Observation Request segment (OBR) is built from fields pulled
 ; from initiating ORM message, recorded in vapals-patients graph.
 ;
 ;
 ;@stanza 2 OBR-1 set id
 new obr set $piece(obr,HLFS,1)=1
 ;
 ;@stanza 3 OBR-3 filler order #
 set $piece(obr,HLFS,3)=$get(filter("ordernumber")) ; universal id
 ;
 ;@stanza 4 OBR-4 universal service id
 set $piece(obr,HLFS,4)=$get(filter("order"))_HLCC_$get(filter("order2"))
 ;
 ;@stanza 5 OBR-7 observation date & time
 set $piece(obr,HLFS,7)=$$FMTHL7^XLFDT($$HTFM^XLFDT($horolog))
 ;
 ;@stanza 6 OBR-16 ordering provider
 new ordpvd set ordpvd=$get(filter("providerien"))_HLCC_$get(filter("providernm"))
 set ordpvd=$translate(ordpvd,",",HLCC)
 set $piece(obr,HLFS,16)=ordpvd
 ;
 ;@stanza 7 OBR-25 result status
 set $piece(obr,HLFS,25)="F" ; final
 ;
 ;@stanza 8 add OBR segment to draft ORU msg
 set obr="OBR"_HLFS_obr
 do ADD2MSG(obr)
 ;
 ;
 ;@stanza 9 termination
 ;
 quit  ; end of OBR
 ;
 ;
 ;
OBX(HLFS,HLCC,filter,OUTHL) ; build OBX segment for ORU msg
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;0% tests
 ;@called-by
 ; hli $$EN^SAMIORU
 ;@calls
 ; ADD2MSG
 ;@input
 ; HLFS = field separator
 ; HLCC = subfield separator
 ; .filter = fields array
 ; [patient data from patient-lookup graph]
 ;@thruput
 ; .OUTHL = output hl7 msg array
 ;
 ; The Observation Result segment (OBX) is built from fields pulled
 ; from initiating ORM message, recorded in vapals-patients graph.
 ;
 ;
 ;@stanza 2 set up
 ;
 new rootpl set rootpl=$get(filter("rootpl"))
 new plien set plien=$get(filter("plien"))
 ; build string used in each ORU OBX node
 new str set str="TX"_HLFS_HLFS_"I1"_HLCC_"Intake Note"
 ;
 ;
 ;@stanza 3 build & add OBX segment 1
 ;
 new name set name=$get(@rootpl@(plien,"saminame"))
 new sex set sex=$get(@rootpl@(plien,"sex"))
 new line1 set line1="Patient name : "_name_" "_HLFS_" "_sex
 new segment set segment="OBX"_HLFS_1_HLFS_str_HLFS_line1_HLFS
 do ADD2MSG(segment)
 ;
 ;
 ;@stanza 4 build & add OBX segment 2
 ;
 new ssn set ssn=$get(@rootpl@(plien,"ssn"))
 new line2 set line2="Record Number : "_ssn
 set segment="OBX"_HLFS_2_HLFS_str_HLFS_line2_HLFS
 do ADD2MSG(segment)
 ;
 ;
 ;@stanza 5 build & add rest of OBX segments
 ;
 new sid set sid=$get(filter("sid"))
 new key set key=$get(filter("key"))
 new rootvp set rootvp=$get(filter("rootvp"))
 new notenumber set notenmbr=$get(filter("notenmbr"))
 new node set node=$name(@rootvp@("graph",sid,key,"notes",notenmbr,"text"))
 ;
 new exit set exit=0
 new snode set snode=$piece(node,")")
 new cnt set cnt=2
 for  do  quit:exit
 . set node=$query(@node)
 . set exit=node'[snode
 . quit:exit
 . ;
 . new vpcnt set vpcnt=$qsubscript(node,7)
 . quit:'vpcnt
 . ;
 . set cnt=$get(cnt)+1
 . set segment="OBX"_HLFS_cnt_HLFS_str_HLFS_@node_HLFS
 . do ADD2MSG(segment)
 . quit
 ;
 ;
 ;@stanza 6 termination
 ;
 quit  ; end of OBX
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
 ; OBR
 ; OBX
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
TESTPID(plien) ; test generating PID
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; HLENV^SAMIORU
 ; ORMVARS^SAMIORU
 ; PID^SAMIORU
 ;@input
 ; plien = patient-lookup graph subscript
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
 new filter set filter("plien")=$get(plien)
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 set filter("rootpl")=rootpl
 ;
 new SNDPROT set SNDPROT="PHX ENROLL ORU EVN"
 do HLENV^SAMIORU(SNDPROT) ; set up HL variables
 ;
 merge filter=@rootpl@(plien)
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter) ; get patient variables from graph
 ;
 do PID^SAMIORU(HLFS,HLCC,.filter,.OUTHL) ; build PID segment
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TESTPID
 ;
 ;
 ;
TESTOBR(plien) ; test generating OBR
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; HLENV^SAMIORU
 ; ORMVARS^SAMIORU
 ; OBR^SAMIORU
 ;@input
 ; plien = patient-lookup graph subscript
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
 ;@stanza 2 test OBR
 ;
 new filter set filter("plien")=$get(plien)
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 set filter("rootpl")=rootpl
 ;
 new SNDPROT set SNDPROT="PHX ENROLL ORU EVN"
 do HLENV^SAMIORU(SNDPROT) ; set up HL variables
 ;
 merge filter=@rootpl@(plien)
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter) ; get patient variables from graph
 ;
 do OBR^SAMIORU(HLFS,HLCC,.filter,.OUTHL) ; build OBR segment
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TESTOBR
 ;
 ;
 ;
TESTOBXV ; test generating OBX in vapalsyotta
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; HLENV^SAMIORU
 ; ORMVARS^SAMIORU
 ; OBX^SAMIORU
 ;@input
 ; patient-lookup graph
 ; vapals-patients graph
 ; protocol PHX ENROLL ORU EVN
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
 ;@stanza 2 test OBX
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 new filter set filter("rootpl")=rootpl
 ;
 new rootvp set rootvp=$$setroot^%wd("vapals-patients")
 set filter("rootvp")=rootvp
 ;
 new SNDPROT set SNDPROT="PHX ENROLL ORU EVN"
 do HLENV^SAMIORU(SNDPROT) ; set up HL variables
 ;
 new sid set sid="PHO00015"
 set filter("sid")=sid
 ;
 new key set key="siform-2020-07-30"
 set filter("key")=key
 ;
 set plien=@rootvp@("graph",sid,key,"dfn")
 set filter("plien")=plien
 ;
 merge filter=@rootpl@(plien)
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter) ; get patient variables from graph
 ;
 set filter("climit")=66
 set filter("notenmbr")=1
 do OBX^SAMIORU(HLFS,HLCC,.filter,.OUTHL) ; build OBX segment
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TESTOBXV
 ;
 ;
 ;
TESTOBXC ; test generating OBX in Cache
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;**SAC**
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; HLENV^SAMIORU
 ; ORMVARS^SAMIORU
 ; OBX^SAMIORU
 ;@input
 ; patient-lookup graph
 ; vapals-patients graph
 ; protocol PHX ENROLL ORU EVN
 ;@output
 ; ]HL
 ; ]HLA
 ; ]HLECH
 ; ]HLQ
 ; ]HLFS
 ; ]HLCC
 ; ]OUTHL = message output array
 ;@sac-violation
 ; 1. $zversion
 ;
 ;
 ;@stanza 2 test OBX
 ;
 new rootpl set rootpl=$$setroot^%wd("patient-lookup")
 new filter set filter("rootpl")=rootpl
 ;
 new rootvp set rootvp=$$setroot^%wd("vapals-patients")
 set filter("rootvp")=rootvp
 ;
 new SNDPROT set SNDPROT="PHX ENROLL ORU EVN"
 do HLENV^SAMIORU(SNDPROT) ; set up HL variables
 ;
 new sid set sid="PHO00015"
 set filter("sid")=sid
 ;
 new key set key="siform-2020-07-30"
 set filter("key")=key
 ;
 set plien=@rootvp@("graph",sid,key,"dfn")
 set filter("plien")=plien
 ;
 merge filter=@rootpl@(plien)
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter) ; get patient variables from graph
 ;
 set filter("climit")=66
 set filter("notenmbr")=2
 set filter("Cache")=$zversion["Cache"
 do OBX^SAMIORU(HLFS,HLCC,.filter,.OUTHL)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; test of TESTOBXC
 ;
 ;
 ;
TESTALL ; test hli $$EN^SAMIORU
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;dmi-test;procedure;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$EN^SAMIORU
 ;@input
 ; patient PHO00008 in graphstore
 ; form siform-2021-03-12 in graphstore
 ;@output
 ; build & send hl7 message
 ; ]filter (killed & returned)
 ; ]OUTHL (killed but not returned)
 ;
 ;
 ;@stanza 2 test hli $$EN^SAMIORU
 ;
 kill filter
 kill OUTHL
 ; set filter("sendprotocol")="PHX ENROLL ORU EVN"
 set filter("sid")="PHO00008"
 set filter("key")="siform-2021-03-12"
 set filter("notenmbr")=1
 ;
 new poopoo set poopoo=$$EN^SAMIORU(.filter) ; build & send ORU msg
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of TESTALL
 ;
 ;
 ;
EOR ; end of routine SAMIORU
