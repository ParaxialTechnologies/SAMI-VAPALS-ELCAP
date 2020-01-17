SAMIHL7 ;SAMI/lgc/arc - HL7 UTILITIES ;Jan 15, 2020@13:14
 ;;18.0;SAMI;;;Build 1
 ;
 quit  ; no entry from top
 ;
 ; example fields array
 ;fields("active duty")="N"
 ;fields("address1")="86099 Edgar Track"
 ;fields("address2")=""
 ;fields("address3")=""
 ;fields("age")=49
 ;fields("city")="Milton"
 ;fields("county")=""
 ;fields("dfn")=129
 ;fields("gender")="M^MALE"
 ;fields("icn")=50000104 (or 50000104V910386)
 ;fields("last5")="H5813"
 ;fields("marital status")=""
 ;fields("phone")="648-421-4239"
 ;fields("name")="Huel366,Jack277"
 ;fields("sbdob")="1970-09-02"
 ;fields("sensitive patient")=0
 ;fields("sex")="M"
 ;fields("sinamef")="Jack277"
 ;fields("sinamel")="Huel366"
 ;fields("ssn")=999235813
 ;fields("state")="MA"
 ;fields("zip")="02186"
 ;
 ;
 ;@ppi
UPDTPTL(fields) ; Update patient-lookup with a patient fields array
 ;@input
 ;   fields  = array of patient data
 ;@output
 ;   existing entry in patient-lookup graph updated
 ;     or new patient entered
 ;
 ; bail if we didn't get a fields array
 quit:'$data(fields)
 ;
UPDTPTL1 new kcnt set (^KBAP("SAMIHL7",0),kcnt)=$get(^KBAP("SAMIHL7",0))+1
 merge ^KBAP("SAMIHL7",kcnt,"fields")=fields
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
 .. if $length($get(fields("saminame"))),(@rootpl@(ptienssn,"saminame")=fields("saminame")) do 
 ... set ptiennm=ptienssn
 ;
 if ptienssn,ptiennm do
 . new fixdob s fixdob=@rootpl@(ptienssn,"sbdob")
 . set fixdob=$piece(fixdob,"-")_"-"_$tr($j($piece(fixdob,"-",2),2)," ","0")_"-"_$tr($j($piece(fixdob,"-",3),2)," ","0")
 . if $length($get(fields("sbdob"))),(fixdob=fields("sbdob")) set ptiendob=ptienssn
 . s newpat=0,ptien=ptienssn
 ;
 ; if there was no name match, restore ptienssn to the first ssn cross ref match 
 set:'ptienssn ptienssn=ptienssntmp
 ;
 ;  if existing patient save existing data
 new oldarr
 if ptien merge oldarr=@rootpl@(ptien)
 ;
 ; If a new patient get the next ptien to use
 set:'$get(ptien) ptien=$order(@rootpl@(999999999),-1)+1,newpat=1
 ;
 ; bail if for some reason we didn't get a next patient ien
 quit:'ptien
 ;
 ; Build MATCHLOG
 ;  If we are adding a new patient check whether we had a 
 ;   match for ssn or name on an existing patient (with
 ;   precedence to the ssn).  If so set MATCHLOG equal
 ;   to the new patient ien and add the index to the
 ;   previously existing patient.
MATCHLOG new newptien,var set newptien=""
 if newpat do
 . set newptien=ptien ; ien of the new patient being added
 .; if there were 1 or more existing entries with this ssn, set MATCHLOG
 . if ptienssn do  quit
 .. new ssnien s ssnien=0
 .. for  s ssnien=$order(@rootpl@("ssn",$get(fields("ssn")),ssnien)) q:'ssnien  d
 ... set @rootpl@(ssnien,"MATCHLOG")=newptien
 ... set @rootpl@("MATCHLOG",ssnien,newptien)=""
 ... U $P write !,"MATCHLOG ssn","--- ssnien=",ssnien,"--- newptien=",newptien
 .; if there were 1 or more existing entries with this patient name, set MATCHLOG
 . if ptiennm do
 .. new pnien s pnien=0
 .. for  s pnien=$order(@rootpl@("name",$get(fields("saminame")),pnien)) q:'pnien  d
 ... set @rootpl@(pnien,"MATCHLOG")=newptien
 ... set @rootpl@("MATCHLOG",pnien,newptien)=""
 ... U $P write !,"MATCHLOG name","---",pnien
 ;
 ;
 new field s field=""
 ; run through every fields subscript and set the
 ;   appropriate subscript patient entry in patient-lookup
 for  set field=$order(fields(field)) q:field=""  do
 .;
 .;new patient ====================================
 .; if new patient just set all patient-lookup field with
 .; the data in field array
 . if newpat do
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
 . if '$get(newpat),'(fields(field)="") do
 .. if field="dfn" quit
 ..;
 .. if '($get(@rootpl@(ptien,field))=fields(field)) do
 ... set @rootpl@(ptien,"changelog",$$FMTE^XLFDT($$NOW^XLFDT,5),field)=fields(field)
 .. set @rootpl@(ptien,field)=fields(field)
 .;
 .;indicies =========================================
 .;set all indicies for old and new patients for this field
 .; NOTE: we must kill any existing earlier idicies on previously
 .;       existing patients to prevent duplicate pointers
 .;
 . if fields(field)="" quit
 .;
 .; field=dfn =====================================
 . if field="dfn" do
 .. if newpat do
 ... set @rootpl@("dfn",fields(field),ptien)=""
 ..;
 ..; As we have the patient's DFN from the VA server
 ..;  we can set the "remotedfn" field as well
 .. set @rootpl@(ptien,"remotedfn")=fields(field)
 .. set @rootpl@("remotedfn",fields(field),ptien)=""
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
 quit
 ;
 ;
KILLREF(field,oldrslt,ptien) ;
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
ACK ;Send a com ACK
 I $D(HLA("HLA")) S HLP("NAMESPACE")="HL" D  quit
 . D GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"LM",1,.HLMTIENA,"",.HLP)
 ;
 ;
EOR ;End of routine SAMIHL7
