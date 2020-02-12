SAMIORR ;ven/lgc/arc - SEND ORR ENROLLMENT RESPONSE ;Feb 11, 2020@12:12
 ;;18.0;SAMI;;;Build 1
 ;
 ;
 quit  ;  no entry from top
 ;
 ; e.g. SNDPROT="LSS ENROLL ORR"
EN(SNDPROT,filter,notenbr,msgid) ; Build and send ORR enrollment response
 ;@input
 ;   SNDPROT  = name of sending protocol
 ;   filter   =  array by reference
 ;         filter("sid")=sid (e.g.XXX00034)
 ;         filter("key")=sid (e.g. "siform-2019-03-05")
 ;         filter("notenmbr")=note number (Cache instance)
 ;   notenmbr =  number of note in vapals-patients graph
 ;   msgid    =  variable by reference (-1 = error)
 ;               HL7 message ID
 ;
 ;   *** not in use right now
 ;   msgtype  = 1 = LSS enrollment response 
 ;              2 = LSS pre-enrollment discussion
 ;              3 = LSS intake
 ;              4 = LSS CT results follow-up
 ;              5 = LSS communication with veteran
 ;@output
 ;   HL7 ORR message built and sent 
 ;   msgid = HL7 message ID
 ;   
 if $get(SNDPROT)="" set SNDPROT="LSS ENROLL ORR"
 if '$data(^ORD(101,"B",SNDPROT)) quit -1
 ;
 new rootpl,rootvp
 set (filter("rootpl"),rootpl)=$$setroot^%wd("patient-lookup")
 set (filter("rootvp"),rootvp)=$$setroot^%wd("vapals-patients")
 ;
 if $get(filter("sid"))="" quit -1
 set sid=$get(filter("sid"))
 if '$data(@rootvp@("graph",sid)) quit -1
 ;
 if $get(filter("key"))="" quit -1
 set key=$get(filter("key"))
 if '$data(@rootvp@("graph",sid,key)) quit -1
 ;
DFN ; find vpien and plien from sid
 new vpien,plien
 ; In Cache have to rmove XXX9 for manual entries
 ;set (vpien,filter("vpien"))=+$extract(sid,5,$length(sid))
 set (vpien,filter("vpien"))=+$extract(sid,4,$length(sid))
 if '$get(vpien) quit -1
 set (plien,filter("plien"))=$order(@rootpl@("dfn",vpien,0))
 if '$get(plien) quit -1
 ;
MSGTYPE ; translate message type to readable string
 set msgtype=+$piece($get(msgtype),".")
 if (msgtype<1)!(msgtype>5) set msgtype=1
 set msgtype=$piece($T(MSGTYP+msgtype),";;",2)
 ;
 ;
 new HL,HLA,HLECH,HLFS,HLQ,OUTHL
 D HLENV(SNDPROT)
 ;
BUILD ; build segements in OUTHL
 D PID(.filter,.OUTHL)
 D ORC(.filter,.OUTHL)
 D OBR(.filter,.OUTHL)
 D OBXPRC(.filter,.OUTHL)
 D OBXMOD(.filter,.OUTHL)
 D NTE(.filter,.OUTHL)
 ;
 new msgid
 set msgid=$$SENDHL7(.OUTHL)
 quit msgid
 ;
 ;
SENDHL7(OUTHL) ;Send out an HL7 message
 ;@input
 ;  OUTHL  = array containing message to send
 ;@output
 ;  msgid  = message ID
 new HLRESLT
 kill HLA("HLS")
 merge HLA("HLS")=OUTHL
 if $data(HLA("HLS")) do
 . new HLEID,HLARYTYPE,HLFORMAT,HLMTIEN,HLP
 . set HL("MTN")="ORR"
 . set HLEID=$O(^ORD(101,"B","LSS ENROLL ORR",0))
 . set HLARYTYP="LM"
 . set HLFORMAT=1
 . set HLMTIEN=""
 . set HLP("PRIORITY")=1
 . do GENERATE^HLMA(HLEID,HLARYTYP,HLFORMAT,.HLRESLT)
 D ^ZTER
 set msgid=HLRESLT
 quit msgid
 ;
PID(filter,OUTHL) ;
 new vpien,plien,rootvp,rootpl,pid,name,address1,address2,address3
 new city,state,zip,str
 set rootvp=$get(filter("rootvp"))
 set rootpl=$get(filter("rootpl"))
 set vpien=$get(filter("vpien"))
 set plien=$get(filter("plien"))
 set outcnt=$order(OUTHL("A"),-1)
 set $piece(pid,HLFS,2)=$get(@rootpl@(plien,"icn")) ; icn
 set $piece(pid,HLFS,3)=$get(@rootpl@(plien,"dfn"))_HLCC_"8"_HLCC_"M10" ; dfn
 set name=$get(@rootpl@(plien,"saminame"))
 set name=$$UP^XLFSTR(name)
 set $piece(pid,HLFS,5)=$translate(name,",",HLCC) ; name
 set $piece(pid,HLFS,7)=$get(@rootpl@(plien,"sbdob")) ;date of birth
 set $piece(pid,HLFS,8)=$get(@rootpl@(plien,"sex")) ; sex
 set address1=$get(@rootpl@(plien,"address1"))
 set address2=$get(@rootpl@(plien,"address2"))
 set address3=$get(@rootpl@(plien,"address3"))
 set city=$get(@rootpl@(plien,"city"))
 set state=$get(@rootpl@(plien,"state"))
 set zip=$get(@rootpl@(plien,"zip"))
 set str=address1_HLCC_address2_address3_HLCC_city_HLCC_state_HLCC_zip
 set $piece(pid,HLFS,11)=str ; address city state zip
 set $piece(pid,HLFS,13)=$get(@rootpl@(plien,"phone")) ; phone number
 set $piece(pid,HLFS,19)=$get(@rootpl@(plien,"ssn")) ; ssn
 set pid="PID"_HLFS_pid
 ;
 do ADD2MSG(pid)
 quit
 ;
 ;
 ;ORC 1 Order Control 
 ;9 Date/Time of Transaction 
 ;14 Call Back Phone Number 
 ;
ORC(filter,OUTHL) ;
 new sid,key,rootvp,roopl,orc
 set sid=$get(filter("sid"))
 set key=$get(filter("key"))
 set rootvp=$get(filter("rootvp"))
 set rootpl=$get(filter("rootpl"))
 set vpien=$get(filter("vpien"))
 set plien=$get(filter("plien"))
 set $piece(orc,HLFS,1)="NW"
 set $piece(orc,HLFS,9)=$$FMTHL7^XLFDT($$HTFM^XLFDT($H)) ;date/time transaction
 set $piece(orc,HLFS,14)="206-123-1234" ; call back phone number
 set orc="ORC"_HLFS_orc
 ;
 do ADD2MSG(orc)
 ;
 quit
 ;
 ;
 ;OBR 4 Universal Service Ident. 
 ;7 Observation Date/Time 
 ;8 Observation End Date/Time 
 ;9 Collection Volume 
 ;14 Specimen Received Date/Time 
 ;16 Ordering Provider 
 ;18 Placers Field #1 (Ward/Clinic) 
 ;20 Fillers Field #1 (Ward/Clinic) 
 ;22 Results Rpt/Status Chng-Date/Time 
 ;
OBR(filter,OUTHL) ;
 new sid,key,rootvp,roopl,unvid,obr
 set sid=$get(filter("sid"))
 set key=$get(filter("key"))
 set rootvp=$get(filter("rootvp"))
 set rootpl=$get(filter("rootpl"))
 set vpien=$get(filter("vpien"))
 set plien=$get(filter("plien"))
 set unvid="7089898.8453-1"_HLCC_"040391-6"_HLCC_"L"
 set $piece(obr,HLFS,4)=unvid ;universal identifier
 set $piece(obr,HLFS,7)=$$FMTHL7^XLFDT($$HTFM^XLFDT($H)) ; observation date/time
 set $piece(obr,HLFS,8)="" ; observation end date/time
 set $piece(obr,HLFS,9)="" ; collection volume
 set $piece(obr,HLFS,14)="" ; specimen received date/time
 set $piece(obr,HLFS,16)="3232~HL7Doctor~One" ; ordering provider
 set $piece(obr,HLFS,18)="MEDICINE" ; ward/clinic
 set $piece(obr,HLFS,20)="" ; filler
 set $piece(obr,HLFS,22)=$$FMTHL7^XLFDT($$HTFM^XLFDT($H)) ; rpt chg stat d/t
 set obr="OBR"_HLFS_obr
 ;
 do ADD2MSG(obr)
 ;
 quit
 ;
 ;
 ;OBX 2 Value Type 
 ;3 Observation Identifier 
 ;5 Observation Results 
 ;
OBXPRC(filter,OUTHL) ;
 new sid,key,rootvp,roopl,obx
 set sid=$get(filter("sid"))
 set key=$get(filter("key"))
 set rootvp=$get(filter("rootvp"))
 set rootpl=$get(filter("rootpl"))
 set vpien=$get(filter("vpien"))
 set plien=$get(filter("plien"))
 set $piece(obx,HLFS,2)="CE" ; 
 set $piece(obx,HLFS,3)="P"_HLCC_"PROCEDURE"_HLCC_"L" ; observation identifier
 set $piece(obx,HLFS,5)="100"_HLCC_"CHEST PA & LAT"_HLCC_"L" ; observation results
 set obx="OBX"_HLFS_obx
 ;
 do ADD2MSG(obx)
 ;
 quit
 ;
OBXMOD(filter,OUTHL) ;
 new sid,key,rootvp,roopl,obx
 set sid=$get(filter("sid"))
 set key=$get(filter("key"))
 set rootvp=$get(filter("rootvp"))
 set rootpl=$get(filter("rootpl"))
 set vpien=$get(filter("vpien"))
 set plien=$get(filter("plien"))
 set $piece(obx,HLFS,2)="TX" ; 
 set $piece(obx,HLFS,3)="M"_HLCC_"MODIFIERS"_HLCC_"L" ; observation identifier
 set $piece(obx,HLFS,5)="RIGHT, PORTABLE" ; observation results
 set obx="OBX"_HLFS_obx
 ;
 do ADD2MSG(obx)
 ;
 quit
 ; note: *** in vapals
 ; ^%wd(17.040801,23,"graph","XXX00955","siform-2019-04-12","note"
 ; note: *** in Cache
 ;^%wd(17.040801,66,"graph","XXX9000076","siform-2020-01-21","notes",1,"date")
 ;^%wd(17.040801,66,"graph","XXX9000076","siform-2020-01-21","notes",1,"name")
 ;^%wd(17.040801,66,"graph","XXX9000076","siform-2020-01-21","notes",1,"text",1)
 ;
NTE(filter,OUTHL) ; Build NTE nodes
 new node,snode,outcnt,rootvp,segment,sid,key
 set sid=$get(filter("sid"))
 set key=$get(filter("key"))
 set rootvp=$get(filter("rootvp"))
 set node=$na(@rootvp@("graph",sid,key,"note")),snode=$piece(node,")")
 ; *** in Cache use
 ;set node=$na(@rootvp@("graph",sid,key,"notes",notenmbr)),snode=$piece(node,")")
 ;
 for  set node=$Q(@node) quit:node'[snode  d
 . new cnt set cnt=$QS(node,7) quit:'cnt
 . set segment="NTE"_HLFS_cnt_HLFS_"L"_HLFS_@node
 . do ADD2MSG(segment)
 quit
 ;
 ;
 ; e.g. SNDPROT="LSS ENROLL ORR"
HLENV(SNDPROT) ; Set HL7 variables
 ;@input
 ;   SNDPROT = name of sending protocol (file #101)
 ;@output
 ;   sets all necessary HL variables for building a message
 new PIEN
 set PIEN=$O(^ORD(101,"B",SNDPROT,0))
 set HL="HLS(""HLS"")",INT=1
 do INIT^HLFNC2(PIEN,.HL,INT)
 set HLFS=$get(HL("FS"))
 set HLECH=$get(HL("ECH"))
 set HLCC=$E(HLECH)
 quit
 ;
 ;
ADD2MSG(segment) ; Add segment to OUTHL array
 new outcnt set outcnt=$order(OUTHL("A"),-1),outcnt=$get(outcnt)+1
 set OUTHL(outcnt)=segment
 quit
 ;
 ;
TSTHL kill OUTHL,SNDPROT
 new rootpl,rootvp
 set (filter("rootpl"),rootpl)=$$setroot^%wd("patient-lookup")
 set (filter("rootvp"),rootvp)=$$setroot^%wd("vapals-patients")
 set filter("sid")="XXX00955",filter("key")="siform-2019-04-12"
 set SNDPROT="LSS ENROLL ORR"
 do HLENV^SAMIORR(SNDPROT)
 do NTE^SAMIORR(.filter,.OUTHL)
 quit
 ;
TESTPID ;
 new rootpl,rootvp,sid,key
 set (filter("rootpl"),rootpl)=$$setroot^%wd("patient-lookup")
 set (filter("rootvp"),rootvp)=$$setroot^%wd("vapals-patients")
 set (sid,filter("sid"))="XXX00955"
 set (key,filter("key"))="siform-2019-04-12"
 set SNDPROT="LSS ENROLL ORR"
 do HLENV^SAMIORR(SNDPROT)
 new vpien,plien
 set (vpien,filter("vpien"))=+$extract(sid,4,$length(sid))
 set (plien,filter("plien"))=$order(@rootpl@("dfn",vpien,0))
 do PID^SAMIORR(.filter,.OUTHL)
 quit
 ;
 ;
TEST ; test sending message in vapals avicenna
 new SNDPROT,filter,notenbr,msgid
 set SNDPROT="LSS ENROLL ORR"
 set filter("sid")="XXX01017"
 set filter("key")="siform-2019-03-05"
 set notenbr=1
 write $$EN^SAMIORR(SNDPROT,.filter,notenbr,.msgid)
 quit
 ;
 ;
TEST1 kill OUTHL
 set OUTHL(1)="PID^^50001000V910386^1~8~M10^^FOURTEEN~PATIENT~N^^19560708^M^^7^10834 DIXIN DR SOUTH~~SEATTLE~WA~98178^53033^(206)772-2059^^^^29^^444678924^^^^BostonMASSACHUSETTS"
 set OUTHL(2)="ORC^NW^^^^^^^^199104301000"
 set OUTHL(3)="OBR^^^^7089898.8453-1~040391-66~L^^^199104301200^^^^^^^^^3232~HL7Doctor~One^^MEDICINE^^^^199104301000"
 set OUTHL(4)="OBX^^CE^P~PROCEDURE~L^^100~CHEST PA & LAT~L"
 set OUTHL(5)="OBX^^TX^M~MODIFIERS~L^^RIGHT, PORTABLE"
 set OUTHL(6)="OBX^^TX^H~HISTORY~L^^None"
 set OUTHL(7)="OBX^^TX^A~ALLERGIES~L^^BEE STINGS"
 quit
 ;
 ;
MSGTYP ;;
 ;;LSS enrollment response
 ;;LSS pre-enrollment discussion
 ;;LSS intake
 ;;LSS CT results follow-up
 ;;LSS communication with veteran
 ;;
 ;; ***END***
 ;
EOR ;End of SAMIORR
