SAMIHL7 ;SAMI/lgc/arc - HL7 UTILITIES ;Apr 19, 2021@15:57
 ;;18.0;SAMI;;;Build 2
 ;
 quit  ; not from top
 ;
 ; example incoming fields array
 ;
 ;fields("PID","segment")="PID|1||000002341||ZZTEST^MACHO^^^^^L||19271106000000|M|||7726 W ORCHID ST^^PHOENIX^AZ^85017||||||||000002341|"
 ;fields("PIV","segment")="PV1||O|PHX-PULM RN LSS PHONE|||||244088^GARCIA^DANIEL^P"
 ;fields("OBR","segment")="OBR||||PHO_LUNG^LUNG|"
 ;fields("ORC","segment")="ORC|NW|3200616135751|||NW||||20200616135751||||||20200616135751"
 ;
 ;fields("ORM",6799278.886493,"assignedlocation")="PHX-PULM RN LSS PHONE"
 ;fields("ORM",6799278.886493,"fulladdress")="7726 W ORCHID ST^^PHOENIX^AZ^85017"
 ;fields("ORM",6799278.886493,"msgid")="99000023ORM"
 ;fields("ORM",6799278.886493,"order")="PHO_LUNG"
 ;fields("ORM",6799278.886493,"order2")="LUNG"
 ;fields("ORM",6799278.886493,"ordercontrol")="NW"
 ;fields("ORM",6799278.886493,"ordereffectivedt")=20200616135751
 ;fields("ORM",6799278.886493,"ordernumber")=3200616135751
 ;fields("ORM",6799278.886493,"orderstatus")="NW"
 ;fields("ORM",6799278.886493,"patientclass")="O"
 ;fields("ORM",6799278.886493,"providerien")=244088
 ;fields("ORM",6799278.886493,"providernm")="GARCIA,DANIEL,P"
 ;fields("ORM",6799278.886493,"siteid")="PHO"
 ;fields("ORM",6799278.886493,"transactiondt")=20200616135751
 ;
 ; fields("address1")="7726 W ORCHID ST"
 ; fields("city")="PHOENIX"
 ; fields("icn")=""
 ; fields("last5")="Z2341"
 ; fields("phone")=""
 ; fields("saminame")="Zztest,Macho"
 ; fields("sbdob")=19271106000000
 ; fields("sex")="M"
 ; fields("sinamef")="Macho"
 ; fields("sinamel")="Zztest"
 ; fields("siteid")="PHO"
 ; fields("ssn")="000002341"
 ; fields("state")="AZ"
 ; fields("zip")=85017
 ;
 ;
 ;@ppi
UPDTPTL(fields) ;
 ; Update patient-lookup with a patient fields array
 ;@input
 ;   fields  = array of patient data
 ;@output
 ;   existing entry in patient-lookup graph updated
 ;     or new patient entered
 ;
 kill ^KBAP("SAMIHL7")
 set ^KBAP("SAMIHL7","UPDTPTL")=""
 ;
 ; bail if we didn't get a fields array
 quit:'$data(fields)
 ;
UPDTPTL1 ;
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1")=""
 ;
 new rootpl s rootpl=$$setroot^%wd("patient-lookup")
 new ptienssn,ptiennm,ptiendob,ptienssntmp
 set (ptienssn,ptiennm,ptiendob,ptienssntmp)=0
 new ptien,newpat set ptien=0,newpat=1
 ;
 ; Look for the existing patients with matching ssn.
 ;  if one has a matching name we don't make a new patient
 ;  but rather update the existing with changelog
 ;
 if $length($get(fields("ssn"))),$data(@rootpl@("ssn",$get(fields("ssn")))) do
 . set ptienssntmp=$order(@rootpl@("ssn",$get(fields("ssn")),0))
 . for  set ptienssn=$order(@rootpl@("ssn",$get(fields("ssn")),ptienssn)) quit:'ptienssn  do  quit:ptiennm
 .. if $length($get(fields("saminame"))),($$UP^XLFSTR(@rootpl@(ptienssn,"saminame"))=$$UP^XLFSTR(fields("saminame"))) do
 ... set ptiennm=ptienssn
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","A")=""
 ;
 if ptienssn,ptiennm do
 . new fixdob s fixdob=@rootpl@(ptienssn,"sbdob")
 . set fixdob=$piece(fixdob,"-")_"-"_$tr($j($piece(fixdob,"-",2),2)," ","0")_"-"_$tr($j($piece(fixdob,"-",3),2)," ","0")
 . if $length($get(fields("sbdob"))),(fixdob=fields("sbdob")) set ptiendob=ptienssn
 . s newpat=0,ptien=ptienssn
 ;
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","B")=""
 ;
 ; if there was no name match, restore ptienssn to the first ssn cross ref match
 set:'ptienssn ptienssn=ptienssntmp
 ;
 ;  if existing patient save existing data
 new oldarr
 if ptien merge oldarr=@rootpl@(ptien)
 ;
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","C")=""
 ;
 ; If a new patient get the next ptien to use and set dfn
 if '$get(ptien) do
 . set ptien=$order(@rootpl@(999999999),-1)+1
 . set fields("dfn")=ptien
 . set newpat=1
 ;
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","D")=""
 ;
 set ^KBAP("SAMIHL7","ptien","newpat")=$get(ptien)_"^"_$get(newpat)
 set ^KBAP("SAMIHL7","fields(dfn)")=$get(fields("dfn"))
 ;
 ; bail if for some reason we didn't get a next patient ien
 quit:'ptien
 ;
 merge ^KBAP("SAMIHL7","fields")=fields
 set ^KBAP("SAMIHL7","ptien")=$get(ptien)
 ;
 ;
 ; Build MATCHLOG
 ;  If we are adding a new patient check whether we had a
 ;   match for ssn or name on an existing patient (with
 ;   precedence to the ssn).  If so set MATCHLOG equal
 ;   to the new patient ien and add the index to the
 ;   previously existing patient.
MATCHLOG ;
 new newptien,var set newptien=""
 if newpat do
 . set newptien=ptien ; ien of the new patient being added
 .;
 .; if there were 1 or more existing entries with this ssn, set MATCHLOG
 .;
 . if ptienssn do  quit
 .. new ssnien s ssnien=0
 .. for  s ssnien=$order(@rootpl@("ssn",$get(fields("ssn")),ssnien)) q:'ssnien  d
 ... set @rootpl@(ssnien,"HL7MATCHLOG")=newptien
 ... set @rootpl@("HL7MATCHLOG",ssnien,newptien)=""
 ... U $P write !,"HL7MATCHLOG ssn","--- ssnien=",ssnien,"--- newptien=",newptien
 .;
 .; if there were 1 or more existing entries with this patient name, set MATCHLOG
 .;
 . if ptiennm do
 .. new pnien s pnien=0
 .. for  s pnien=$order(@rootpl@("name",$get(fields("saminame")),pnien)) q:'pnien  d
 ... set @rootpl@(pnien,"HL7MATCHLOG")=newptien
 ... set @rootpl@("HL7MATCHLOG",pnien,newptien)=""
 ... U $P write !,"HL7MATCHLOG name","---",pnien
 ;
 new field s field=""
 ; run through every fields subscript and set the
 ;   appropriate subscript patient entry in patient-lookup
 for  set field=$order(fields(field)) q:field=""  do
 .;
 .;new patient ====================================
 .; if new patient just set all patient-lookup field with
 .; the data in field array
 .; Load ORM message data later
 .;
 . if newpat do
 .. if field="ORM" quit
 .. set @rootpl@(ptien,field)=fields(field)
 .;
 .;old patient ====================================
  .; if not a new patient only store field results that are NOT null.
 .;   Never overwrite an existing patient's "dfn", rather store
 .;     the dfn just received in the remotedfn field
 .;
 .;   With existing patients if the new data for a field doesn't match
 .;     the pre-existing, save the pre-existing data in a changelog entry
 .;
 . if '$get(newpat),'($get(fields(field))="") do
 .. if field="ORM" quit
 .. if field="dfn" quit
 ..;
 .. if '($get(@rootpl@(ptien,field))=fields(field)) do
 ... set @rootpl@(ptien,"hl7changelog",$$FMTE^XLFDT($$NOW^XLFDT,5),field)=fields(field)
 .. set @rootpl@(ptien,field)=fields(field)
 .;
 .;indicies =========================================
 .;set all indicies for old and new patients for this field
 .; NOTE: we must kill any existing earlier idicies on previously
 .;existing patients to prevent duplicate pointers
 .;
 . if $get(fields(field))="" quit
 .;
 .; field=dfn =====================================
 . if field="dfn" do
 .. if newpat do
 ... set @rootpl@("dfn",fields(field),ptien)=""
 ..;
 .; As DID NOT get DFN from the VA server (only ssn)
 .;  we cannot set the "remotedfn" field
 . set @rootpl@(ptien,"remotedfn")=""
 .;
 .; field=icn =====================================
 . if field="icn" do
 .. set @rootpl@("icn",fields(field),ptien)=""
 .;
 .; field=last5 ===================================
 . if field="last5" do
 .. if '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @rootpl@("last5",fields(field),ptien)="" quit
 .;
 .; field=saminame ================================
 . if field="saminame" do
 .. if '$get(newpat) do
 ... do KILLREF(field,$get(oldarr(field)),ptien)
 ... do KILLREF("name",$get(oldarr("name")),ptien)
 ... do KILLREF("name",$$UP^XLFSTR($get(oldarr("name"))),ptien)
 .. set @rootpl@("name",fields(field),ptien)=""
 .. set @rootpl@("saminame",fields(field),ptien)=""
 .. set @rootpl@("name",$$UP^XLFSTR(fields(field)),ptien)=""
 .;
 .; field=sinamef ==================================
 . if field="sinamef" do
 .. i '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @rootpl@(field,fields(field),ptien)=""
 .;
 .; field=sinamel ==================================
 . if field="sinamel" do
 .. if '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @rootpl@(field,fields(field),ptien)=""
 .;
 .; field=ssn ======================================
 . if field="ssn" do
 .. if '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @rootpl@(field,fields(field),ptien)=""
 ;
 ;
 set @rootpl@("Date Last Updated")=$$HTE^XLFDT($horolog)
 ;
 ; set so SAMIORM can use ptien to file HL7 messages
 set fields("ptien")=$get(ptien)
 ;
 ; now capture most recent ORM message
 do CAPTORM(.fields,rootpl,ptien)
 ;
 merge ^KBAP("SAMIHL7","fields")=fields
 ;
 quit
 ;
 ;
CAPTORM(fields,rootpl,ptien) ; Save all ORM fields in patient-lookup
 new node,snode,invdt
 set node=$na(fields("ORM")),snode=$p(node,")")
 for  set node=$Q(@node) q:node'[snode  do
 . set invdt=$QS(node,2)
 . set @rootpl@(ptien,"ORM",invdt,$QS(node,3))=@node
 quit
 ;
KILLREF(field,oldrslt,ptien) ;
 ;
 quit:($get(oldrslt)="")
 kill @rootpl@(field,oldrslt,ptien)
 quit
 ;
 ;
 ;
 ;@ppi
 ;@input
 ;  Expects all HL7 variables captured on message reception to
 ;   be in environment
 ;@output
 ;  Sends com ACK through appropriate link
ACK ;Force a com ACK
 ;
 kill HLA("HLA")
 set HLA("HLA",1)="MSA"_HLREC("FS")_"CA"_HLREC("FS")_HLREC("MID")
 ;
 I $D(HLA("HLA")) S HLP("NAMESPACE")="HL" D  quit
 . merge ^KBAP("SAMIHL7","HLA")=HLA
 . D GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"LM",1,.HLMTIENA,"",.HLP)
 ;
 ;
EOR ;End of routine SAMIHL7
