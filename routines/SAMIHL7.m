SAMIHL7 ;SAMI/lgc/arc - HL7 UTILITIES ;Oct 23, 2019@20:19
 ;;18.0;SAMI;
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
 ;fields("gender")="M"
 ;fields("icn")=50000104 (or 50000104V910386)
 ;fields("last5")="H5813"
 ;fields("marital status")=""
 ;fields("phone")="648-421-4239"
 ;fields("saminame")="Huel366,Jack277"
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
 ;? I could use setroot, but that would build if it
 ;   didn't exist.  Perhaps this is what we want.
 new dien s dien=$order(^%wd(17.040801,"B","patient-lookup",0))
 ; bail if the patient-lookup graph doesn't exist
 quit:'dien
 ;
 new root s root=$$setroot^%wd("patient-lookup")
 new ptien,newpat set newpat=0
 ;
 ; Using ICN as the patient identifier
 set ptien=$order(@root@("icn",$get(fields("icn")),0))
 ;
 ; If this patient already in patient-lookup save
 ;  existing patient data to correct indicies later
 ; Also prepare to save in ^TMP
 new tmpcnt set tmpcnt=$get(^TMP("SAMIHL7",0))+1
 if $get(ptien) do
 . kill oldarr m oldarr=@root@(ptien)
 . merge ^TMP("SAMIHL7",tmpcnt,"A")=@root@(ptien)
 ;
 ; If a new patient get the next ptien to use
 set:'$get(ptien) ptien=$order(@root@(999999999),-1)+1,newpat=1 
 ;
 ; bail if for some reason we didn't get a next patient ien
 quit:'ptien
 ;
 new field s field=""
 ; run through every fields subscript and set the
 ;   appropriate subscript patient entry in patient-lookup
 for  set field=$order(fields(field)) q:field=""  do
 .;
 .;new patient ====================================
 .; if new patient set null fields as well to setup subscript
 . if newpat do
 .. set @root@(ptien,field)=fields(field)
 .;
 .;old patient ====================================
 .; if not a new patient only store field results
 .;   that are NOT null.  However, do not overwrite
 .;   dfn as it may be a manually entered patient and
 .;   in this case we only want to store the VA dfn
 .;   in the remotedfn field
 . if '$get(newpat),'(fields(field)="") do
 .. if field="dfn" quit
 .. set @root@(ptien,field)=fields(field)
 .;
 .; now set all the indicies for this patient
 .; NOTE: we must kill any existing earlier idicies on previously
 .;       existing patients to prevent duplicate pointers
 .;
 . if fields(field)="" quit
 .;
 .; field=dfn =====================================
 . if field="dfn" do
 .. if newpat do
 ... set @root@("dfn",fields(field),ptien)=""
 ..;
 ..; As we have the patient's DFN from the VA server
 ..;  we can set the "remotedfn" field as well
 .. set @root@(ptien,"remotedfn")=fields(field)
 .. set @root@("remotedfn",fields(field),ptien)=""
 .;
 .; field=icn =====================================
 . if field="icn" do
 .. if '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @root@("icn",fields(field),ptien)=""
 .;
 .; field=last5 ===================================
 . if field="last5" do
 .. if '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @root@("last5",fields(field),ptien)="" quit
 .;
 .; field=saminame ================================
 . if field="saminame" do
 .. if '$get(newpat) do
 ... do KILLREF(field,$get(oldarr(field)),ptien)
 ... do KILLREF("name",$get(oldarr("name")),ptien)
 ... do KILLREF("name",$$UP^XLFSTR($get(oldarr("name"))),ptien)
 .. set @root@("saminame",fields(field),ptien)=""
 .. set @root@("name",fields(field),ptien)=""
 .. set @root@("name",$$UP^XLFSTR(fields(field)),ptien)=""
 .;
 .; field=sinamef ==================================
 . if field="sinamef" do
 .. i '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @root@(field,fields(field),ptien)=""
 .;
 .; field=sinamel ==================================
 . if field="sinamel" do
 .. if '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @root@(field,fields(field),ptien)=""
 .;
 .; field=ssn ======================================
 . if field="ssn" do
 .. if '$get(newpat) do KILLREF(field,$get(oldarr(field)),ptien)
 .. set @root@(field,fields(field),ptien)=""
 ;
 ; Now save new data in ^TMP
 merge ^TMP("SAMIHL7",tmpcnt,"B")=@root@(ptien)
 ;
 quit
 ;
 ;
KILLREF(field,oldrslt,ptien) ;
 quit:($get(oldrslt)="")
 kill @root@(field,oldrslt,ptien) 
 quit
 ;
 ;
DELPTL ; Delete patient-lookup graph without changing root
 new root set root=$$setroot^%wd("patient-lookup")
 kill @root set @root@(0)="patient-lookup" quit
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
