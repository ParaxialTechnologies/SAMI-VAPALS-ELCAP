SAMIORU ;ven/lgc/arc - SEND ORU ENROLLMENT RESPONSE ;Jul 28, 2020@18:52
 ;;18.0;SAMI;;;Build 1
 ;
 ;NOTE: We will only be sending ORU messages out for patients
 ;      for whom at least one ORM has been received.  Thus,
 ;      we can trust the information stored in the patient-lookup
 ;      graph through an incoming ORM to fill in fields of
 ;      any ORU generated messages.
 ;
 quit  ;  no entry from top
 ;
 ;
EN(filter) ; Build and send ORU enrollment response
 ;@input
 ;   filter   =  array by reference
 ;               [filter("sendprotocol")] defaults to Phoenix
 ;               filter("sid")=sid (e.g.XXX00034)
 ;               filter("key")=sid (e.g. "siform-2019-03-05")
 ;               [filter("notenmbr")=note number]
 ;                     number of note in vapals-patients graph
 ;               [filter("climit")] defaults to 66
 ;                     limit to number of characters per line
 ;                     for text to display in CPRS
 ;
 ;@output
 ;   filter("rslt")  =  contains either
 ;                      msgid - message generated
 ;                      0 - error
 ;   HL7 ORU message built and sent
 ;   NOTE: if called as function contents of filter("rslt") is
 ;         returned directly
 ;
 set filter("rslt")=0
 ;
 new rootpl,rootvp,sid,key,SNDPROT,climit,notenmbr
 set (rootpl,filter("rootpl"))=$$setroot^%wd("patient-lookup")
 set (rootvp,filter("rootvp"))=$$setroot^%wd("vapals-patients")
 ;
 set sid=$get(filter("sid")) if sid="" do  quit:$Q filter("rslt")  quit 
 . set filter("rlst")="no sid provided"
 set key=$get(filter("key")) if key="" do  quit:$Q filter("rslt")  quit
 . set filter("rslt")="no key provided"
 set SNDPROT=$get(filter("sendprotocol")) if SNDPROT="" do
 . set filter("sendprotocol")="PHX ENROLL ORM EVN"
 set climit=$get(filter("climit")) if +$get(climit)=0 do
 . set climit=66
 set filter("Cache")=($zversion["Cache")
 set notenmbr=+$get(filter("notenmbr"))
 if $get(filter("Cache")),notenmbr=0 do  quit:$Q filter("rslt")  quit
 . set filter("rslt")="Cache requires note number"
 ;
DFN ; find vpien and plien
 new dfn,vpien,plien
 set (dfn,filter("vpien"),filter("dfn"))=@rootvp@("graph",sid,key,"dfn")
 set (plien,filter("plien"))=$order(@rootpl@("dfn",vpien,0))
 ;
 ;Pull HL7 vars and escape sequences for building a message
HL7VARS new HL,HLA,HLECH,HLQ,OUTHL,HLFS,HLCC,HLECH
 D HLENV(SNDPROT)
 ;
 ;   BUILD ; build segements in OUTHL
 D PID(HLFS,HLCC,.filter,.OUTHL)
 D OBR(HLFS,HLCC,.filter,.OUTHL)
 D OBX(HLFS,HLCC,.filter,.OUTHL)
 ;
 new msgid
 set (filter("rslt"),msgid)=$$SENDHL7(.OUTHL)
 ;
 quit:$Q $get(filter("rslt"))=msgid  quit
 ;
 ;
 ;
PID(HLFS,HLCC,filter,OUTHL) ;
 new vpien,plien,rootvp,rootpl,pid,name,address1,address2,address3
 new ssn,sex,city,state,zip,str,fulladdress,dob
 set rootpl=$get(filter("rootpl"))
 set plien=$get(filter("plien"))
 set outcnt=$order(OUTHL("A"),-1)
PID2 set $piece(pid,HLFS,2)=1
 ;
PID3 set ssn=$get(@rootpl@(plien,"ssn"))
 set $piece(pid,HLFS,3)=$get(ssn)
 ;
PID5 set name=$get(@rootpl@(plien,"saminame"))
 set name=$translate($$UP^XLFSTR(name),",",HLCC)
 set $piece(name,HLCC,7)="L"
 set $piece(pid,HLFS,5)=$get(name)
 ;
PID7 set dob=$get(@rootpl@(plien,"dob"))
 set $piece(pid,HLFS,7)=$get(dob)
 ;
PID8 set sex=$get(@rootpl@(plien,"sex"))
 set $piece(pid,HLFS,8)=$get(sex)
 ;
PID11 set fulladdress=$get(filter("fulladdress"))
 set $piece(pid,HLFS,8)=$get(fulladdress)
 ;
PID18 set $piece(pid,HLFS,13)=""
 ;
PID19 set $piece(pid,HLFS,19)=$get(@rootpl@(plien,"ssn"))
 ;
 set pid="PID"_HLFS_pid
 ;
 do ADD2MSG(pid)
 quit
 ;
 ;
 ;
 ; OBR is built from variables gleaned from the initiating ORM
 ;   message
OBR(HLFS,HLCC,filter,OUTHL) ; Build ORU OBR
 new obr,ordpvd
 ;
OBR1 set $piece(obr,HLFS,1)=1
 ;
OBR3 set $piece(obr,HLFS,3)=$get(filter("ordernumber")) ;universal identifier
 ;
OBR4 set $piece(obr,HLFS,4)=$get(filter("order"))_HLCC_$get(filter("order2"))
 ;
OBR7 set $piece(obr,HLFS,7)=$$FMTHL7^XLFDT($$HTFM^XLFDT($H)) ; our obsv date
 ;
OBR16 set ordpvd=$get(filter("providerien"))_HLCC_$get(filter("providernm"))
 set ordpvd=$translate(ordpvd,",",HLCC)
 set $piece(obr,HLFS,16)=ordpvd
 ;
OBR25 set $piece(obr,HLFS,25)="F" ; final
 set obr="OBR"_HLFS_obr
 ;
 do ADD2MSG(obr)
 ;
 quit
 ;
 ;
OBX(HLFS,HLCC,filter,OUTHL) ; Build text of note from vapals-patients nodes
 new outcnt,rootvp,rootpl,segment,sid,key,notenumber,str
 new ssn,dfn,plien,name,sex,line1,line2
 set sid=$get(filter("sid"))
 set key=$get(filter("key"))
 set rootvp=$get(filter("rootvp"))
 set rootpl=$get(filter("rootpl"))
 set plien=$get(filter("plien"))
 set notenmbr=$get(filter("notenmbr"))
 ; build string used in each ORU OBX node
 set str="TX"_HLFS_HLFS_"I1"_HLCC_"Intake Note"
 ;
 set name=$get(@rootpl@(plien,"saminame"))
 set sex=$get(@rootpl@(plien,"sex"))
 set ssn=$get(@rootpl@(plien,"ssn"))
 set line1="Patient name : "_name_" "_HLFS_" "_sex
 set line2="Record Number : "_ssn
 set segment="OBX"_HLFS_1_HLFS_str_HLFS_line1_HLFS
 do ADD2MSG(segment)
 set segment="OBX"_HLFS_2_HLFS_str_HLFS_line2_HLFS
 do ADD2MSG(segment)
 ;
 new node,snode,vpcnt,cnt
 ;
 ; *** in vapalsyotta
 if '($get(filter("Cache"))) do 
 . set node=$na(@rootvp@("graph",sid,key,"note"))
 ; *** in Cache
 if $get(filter("Cache")) do
 . set node=$na(@rootvp@("graph",sid,key,"notes",notenmbr,"text"))
 ;
 set snode=$piece(node,")")
 ;
 set cnt=2
 set node=$na(@rootvp@("graph",sid,key,"note")),snode=$piece(node,")")
 for  set node=$Q(@node) quit:node'[snode  do
 .; if the text in this node is less than our character limit
 .;   then build an OBX segment
 . if $length(@node)<climit do  quit
 .. set vpcnt=$QS(node,7) quit:'vpcnt
 .. set cnt=$get(cnt)+1
 .. set segment="OBX"_HLFS_cnt_HLFS_str_HLFS_@node_HLFS
 .. do ADD2MSG(segment)
 .; 
 .; string @node is too long to display properly in CPRS
 .;   The length is set in climit above
 .; Now we will pull this string and all subsequent 
 .;   strings into a single string UNTIL we hit an empty node
 .;
BLDTXT . new poo,txtstr,exit
 . set txtstr=@node
 . set exit=0
 . for  set node=$Q(@node) quit:$Q(@node)'[snode  do  quit:exit
 .. set txtstr=$get(txtstr)_@node_" "
 .. if ($translate(@($Q(@node))," ")="") set exit=1 quit
 .. if $length(@($Q(@node)))<climit set exit=1 quit
 . set poo(1)=txtstr
 . do wrap^%tt("poo",climit)
 .; now process text in poo(1) which has been limited
 .;  by wrap call to the number of characters in climit
 . new poocnt set poocnt=0
 . for  set poocnt=$order(poo(poocnt)) quit:'poocnt  do
 .. set cnt=$get(cnt)+1
 .. set segment="OBX"_HLFS_cnt_HLFS_str_HLFS_poo(poocnt)_HLFS
 .. do ADD2MSG(segment)
 .; now back to main loop looking through note in graphstore
 quit
 ;
 ;
 ;
SENDHL7(SNDPROT,OUTHL) ;Send out an HL7 message
 ;@input
 ;  OUTHL  = array containing message to send
 ;@output
 ;  msgid  = message ID
 new HLRESLT
 kill HLA("HLS")
 merge HLA("HLS")=OUTHL
 if $data(HLA("HLS")) do
 . new HLEID,HLARYTYP,HLFORMAT,HLMTIEN,HLP
 . set HL("MTN")="ORU"
 . set HLEID=$O(^ORD(101,"B",SNDPROT,0))
 . set HLARYTYP="LM"
 . set HLFORMAT=1
 . set HLMTIEN=""
 . set HLP("PRIORITY")=1
 . do GENERATE^HLMA(HLEID,HLARYTYP,HLFORMAT,.HLRESLT)
 set msgid=HLRESLT
 quit msgid
 ;
 ;
 ;
 ;
 ; e.g. SNDPROT="PHX ENROLL ORM EVN"
HLENV(SNDPROT) ; Set HL7 variables
 ;@input
 ;   SNDPROT = name of sending protocol (file #101)
 ;@output
 ;   sets all necessary HL variables for building a message
 new PIEN,INT
 set PIEN=$O(^ORD(101,"B",SNDPROT,0))
 set HL="HLS(""HLS"")"
 set INT=1
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
 ;
 ; builds extra filter vars from the most recent ORM array found in
 ;   the patient's patient-lookup graph
 ; filter("assignedlocation")="PHX-PULM RN LSS PHONE"
 ; filter("fulladdress")="7726 W ORCHID ST^^PHOENIX^AZ^85017"
 ; filter("msgid")="99000031ORM"
 ; filter("order")="PHO_LUNG"
 ; filter("order2")="LUNG"
 ; filter("ordercontrol")="NW"
 ; filter("ordereffectivedt")=20200616135751
 ; filter("ordernumber")=3200616135751
 ; filter("orderstatus")="NW"
 ; filter("patientclass")="O"
 ; filter("providerien")=244088
 ; filter("providernm")="GARCIA,DANIEL,P"
 ; filter("siteid")="PHO"
 ; filter("transactiondt")=20200616135751
ORMVARS(plien,filter) ; get variables from most recent ORM on this patient
 ;
 new node,snode,rootpl,var,invdt
 set rootpl=$$setroot^%wd("patient-lookup")
 set node=$na(@rootpl@(plien,"ORM")),snode=$p(node,")")
 set invdt=$QS($Q(@node),5)
 for  set node=$Q(@node) quit:node'[snode  quit:node'[invdt  do
 . set var=$QS(node,6)
 . set filter(var)=@node
 quit
 ;
 ;
 ;
TESTPID ; Test generating PID
 new plien set plien=1028
 new rootpl
 set (filter("rootpl"),rootpl)=$$setroot^%wd("patient-lookup")
 set filter("plien")=$get(plien)
 set SNDPROT="PHX ENROLL ORM EVN"
 do HLENV^SAMIORU(SNDPROT)
 merge filter=@rootpl@(plien)
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter)
 do PID^SAMIORU(HLFS,HLCC,.filter,.OUTHL)
 quit
 ;
 ;      ;
TESTOBR ; Test generating OBR
 new plien set plien=1028
 new rootpl
 set (filter("rootpl"),rootpl)=$$setroot^%wd("patient-lookup")
 set filter("plien")=$get(plien)
 set SNDPROT="PHX ENROLL ORM EVN"
 do HLENV^SAMIORU(SNDPROT)
 merge filter=@rootpl@(plien)
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter)
 do OBR^SAMIORU(HLFS,HLCC,.filter,.OUTHL)
 quit
 ;
 ;
TESTOBX ; Test generating OBX in vapalsyotta
 new rootpl,rootvp,filter
 set (filter("rootpl"),rootpl)=$$setroot^%wd("patient-lookup")
 set (filter("rootvp"),rootvp)=$$setroot^%wd("vapals-patients")
 new SNDPROT,notenbr,msgid
 set SNDPROT="PHX ENROLL ORM EVN"
 do HLENV^SAMIORU(SNDPROT)
 new sid,key
 set (sid,filter("sid"))="XXX00054"
 set (key,filter("key"))="siform-2019-03-22"
 set (filter("plien"),plien)=@rootvp@("graph",sid,key,"dfn")
 merge filter=@rootpl@(plien)
 kill filter("ORM")
 do ORMVARS^SAMIORU(plien,.filter)
 new climit set climit=66
 new notenbr set notenbr=1
 do OBX^SAMIORU(HLFS,HLCC,.filter,.OUTHL)
 quit
 ;
 ;
EOR ;End of routine SAMIORU
 ;
 ;
