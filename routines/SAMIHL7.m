SAMIHL7 ;SAMI/lgc/arc - HL7 UTILITIES ;Oct 02, 2019@21:10
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
 ;fields("gender")="M^MALE"
 ;fields("icn")=50000104
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
 ;@ppi
UPDTPTL(fields) ; Update patient-lookup with a patient fields array
 ; bail if we didn't get a fields array
 quit:'$data(fields)
 ;? I could use setroot, but that would build if it
 ;   didn't exist.  Perhaps this is what we want.
 new dien s dien=$order(^%wd(17.040801,"B","patient-lookup",0))
 ; bail if the patient-lookup graph doesn't exist
 quit:'dien
 ;
 new root s root=$$setroot^%wd("patient-lookup")
 new ptien,newpat set newpat=0
 ; Is this patient already in patient-lookup save
 ;  existing patient data to correct indicies later
 set ptien=$order(@root@("dfn",$get(fields("dfn")),0))
 if $get(ptien) do
 . kill oldarr m oldarr=@root@(ptien)
 ; If a new patient get the next ptien to use
 if '$g(ptien) do 
 . s ptien=$order(@root@(999999999),-1)+1
 . s newpat=1
 ;
 ; bail if for some reason we didn't get a next patient ien
 quit:'ptien
 ;
 new field s field=""
 ; run through every fields subscript and set the
 ;   appropriate subscript patient entry in patient-lookup
 for  set field=$order(fields(field)) q:field=""  do
 .; if new patient set null fields as well to setup
 .;  subscript.
 . if newpat do
 .. set @root@(ptien,field)=fields(field)
 . if '$get(newpat),'(fields(field)="") do
 .. set @root@(ptien,field)=fields(field)
 .;
 .; now set all the indicies for this patient
 . if fields(field)="" quit
 . if field="dfn" set @root@("dfn",fields(field),ptien)=""
 .;
 . if field="icn" do
 .. if '$get(newpat) kill @root@("icn",oldarr(field),ptien)
 .. set @root@("icn",fields(field),ptien)=""
 .;
 . if field="last5" do
 .. if '$get(newpat) kill @root@("last5",oldarr(field),ptien)
 .. set @root@("last5",fields(field),ptien)="" quit
 .;
 . if field="saminame" do
 .. if '$get(newpat) do
 ... kill @root@("saminame",oldarr(field),ptien)
 ... kill @root@("name",oldarr(field),ptien)
 ... kill @root@("name",$$UP^XLFSTR(oldarr(field)),ptien)
 .. set @root@("saminame",fields(field),ptien)=""
 .. set @root@("name",fields(field),ptien)=""
 .. set @root@("name",$$UP^XLFSTR(fields(field)),ptien)=""
 .;
 . if field="sinamef" do
 .. i '$get(newpat) kill @root@("sinnamef",oldarr(field),ptien)
 .. set @root@("sinnamef",fields(field),ptien)=""
 .;
 . if field="sinamel" do
 .. if '$get(newpat) kill @root@("sinnamef",oldarr(field),ptien)
 .. set @root@("sinnamel",fields(field),ptien)=""
 .;
 . if field="ssn" do
 .. if '$get(newpat) kill @root@("ssn",oldarr(field),ptien)
 .. set @root@("ssn",fields(field),ptien)=""
 quit
 ;
 ;
DELPTL ; Delete patient-lookup graph without changing root
 new root set root=$$setroot^%wd("patient-lookup")
 kill @root
 set @root@(0)="patient-lookup"
 quit
 ;
EOR ;End of routine SAMIHL7
