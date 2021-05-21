SAMIHL7 ;ven/lgc&arc - HL7 utilities ;2021-05-21T16:11Z
 ;;18.0;SAMI;**11**;2020-01;Build 8
 ;;1.18.0.11-i11
 ;
 ; SAMIHL7 contains subroutines for manipulating VAPALS-ELCAP HL7
 ; messages.
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
 ; lgc@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, lgc, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-05-21T16:11Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11-i11
 ;@release-date 2020-01
 ;@patch-list **11**
 ;
 ;@additional-dev Alexis R. Carlson (arc)
 ; arc@vistaexpertise.net
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@module-credits
 ;@project VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding 2017/2021, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org Paraxial Technologies (par)
 ; http://paraxialtech.com/
 ;@partner-org Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2019-10-03/28 ven/lgc 1.18.0 d01fd10,ff6cea0,3670fb3,613e8ff
 ; ,82979cc
 ;  SAMIHL7: HL7 routines to populate & update patient-lookup graph,
 ; reorganize HL7 routines & work on unit tests, change how gender is
 ; handled, update unit test routines for dfn 1, further updates to
 ; SAMI unit tests.
 ;
 ; 2020-01-16 ven/lgc&arc 1.18.0 0a2af96
 ;  SAMIHL7: bulk commit due to switch to cache.
 ;
 ; 2020-07-28 ven/lgc 1.18.0.11+i11 c08b051
 ;  SAMIHL7: update for ORU messaging.
 ;
 ; 2021-04-14/20 ven/gpl 1.18.0.11+i11 3a5756a,d7182d7
 ;  SAMIHL7: fix for duplicate patients fr/HL7, fix for updating 
 ; patient-lookup graph on receipt of 2nd order.
 ;
 ; 2021-05-20 ven/mcglk&toad 1.18.0.11-i11
 ;  SAMIHL7: build hdr comments & dev log, lt refactor, bump version.
 ;
 ;@contents
 ; UPDTPTL-UPDTPTL1-MATCHLOG update patient-lookup w/patient-fields array
 ; CAPTORM save all ORM fields in patient-lookup
 ; KILLREF kill old field in patient-lookup root
 ; ACK force a com ACK
 ;
 ;
 ;
 ;@section 1 example incoming fields array
 ;
 ;
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
 ;
 ;@section 2 ppis & subroutines
 ;
 ;
 ;
 ;@ppi UPDTPTL^SAMIHL7
UPDTPTL(fields) ; update patient-lookup w/patient-fields array
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;ppi;procedure;???;silent;sac
 ;@falls-thru-to
 ; UPDTPTL1-MATCHLOG
 ;@called-by
 ; MSH^SAMIADT [<= EN^SAMIADT <= old HL7 app, no longer used]
 ; PID^SAMIADT [<= EN^SAMIADT <= old HL7 app, no longer used]
 ; EN^SAMIORM [<= hl7 app INST-MCAR <= HL7, main vapals hl7 entry]
 ; IMPRTPTS^SAMIPI [patient-lookup graph import & export utils]
 ; ACK^SAMITIU [<= old HL7 app, no longer used]
 ; RECTIU^SAMITIU
 ; RECTIU^SAMIVHL [HL7 TIU processing for VAPALS, no longer used?]
 ;@calls none
 ;@input
 ; fields = array of patient data
 ;@output
 ; existing entry in patient-lookup graph updated
 ; or new patient entered
 ;
 ;
 ;@stanza 2 setup
 ;
 kill ^KBAP("SAMIHL7")
 set ^KBAP("SAMIHL7","UPDTPTL")=""
 ;
 ; bail if we didn't get a fields array
 quit:'$data(fields)
 ;
 ;
UPDTPTL1 ;
 ;
 ;@falls-thru-from
 ; UPDTPTL
 ;@falls-thru-to
 ; MATCHLOG
 ;@called-by none
 ;@calls none
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1")=""
 ;
 new rootpl s rootpl=$$setroot^%wd("patient-lookup")
 new ptienssn set ptienssn=0 ; patient ssn
 new ptiennm set ptiennm=0 ; patient name
 new ptiendob set ptiendob=0 ; patient dob
 new ptienssntmp set ptienssntmp=0 ; patient 1st ssn xref match
 new ptien set ptien=0 ; patient ien
 new newpat set newpat=1 ; new patient: default to true
 ;
 ; look for existing patients w/matching ssn. If one has matching name
 ; we don't make new patient; we update existing w/changelog.
 ;
 do
 . quit:'$length($get(fields("ssn")))  ; existing ssn
 . quit:'$data(@rootpl@("ssn",$get(fields("ssn"))))  ; matches lkup?
 . set ptienssntmp=$order(@rootpl@("ssn",$get(fields("ssn")),0)) ;save
 . for  do  quit:'ptienssn  quit:ptiennm
 . . set ptienssn=$order(@rootpl@("ssn",$get(fields("ssn")),ptienssn))
 . . quit:'ptienssn
 . . ;
 . . quit:'$length($get(fields("saminame")))
 . . new name set name=fields("saminame") ; existing name
 . . new chkname set chkname=@rootpl@(ptienssn,"saminame") ; new name
 . . quit:$$UP^XLFSTR(chkname)'=$$UP^XLFSTR(name)  ; uppercase equal?
 . . set ptiennm=ptienssn ; we have a match!
 . . quit
 . quit
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","A")=""
 ;
 if ptienssn,ptiennm do
 . new fixdob set fixdob=@rootpl@(ptienssn,"sbdob")
 . new year set year=$piece(fixdob,"-")
 . new month
 . set month=$translate($justify($piece(fixdob,"-",2),2)," ","0")
 . new day
 . set day=$translate($justify($piece(fixdob,"-",3),2)," ","0")
 . set fixdob=year_"-"_month_"-"_day
 . if $length($get(fields("sbdob"))),fixdob=fields("sbdob") do
 . . set ptiendob=ptienssn
 . . quit
 . set newpat=0 ; not a new patient
 . set ptien=ptienssn ; existing patient!
 ;
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","B")=""
 ;
 ; if no name match, restore ptienssn to 1st ssn xref match
 set:'ptienssn ptienssn=ptienssntmp
 ;
 ; if existing patient, save existing data
 new oldarr
 merge:ptien oldarr=@rootpl@(ptien)
 ;
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","C")=""
 ;
 ; if new patient, get next ptien to use & set dfn
 if '$get(ptien) do
 . set ptien=$order(@rootpl@(999999999),-1)+1
 . set fields("dfn")=ptien
 . set newpat=1
 . quit
 ;
 ;
 set ^KBAP("SAMIHL7","UPDTPTL1","D")=""
 ;
 set ^KBAP("SAMIHL7","ptien","newpat")=$get(ptien)_"^"_$get(newpat)
 set ^KBAP("SAMIHL7","fields(dfn)")=$get(fields("dfn"))
 ;
 ; bail if for some reason we didn't get next patient ien
 quit:'ptien
 ;
 merge ^KBAP("SAMIHL7","fields")=fields
 set ^KBAP("SAMIHL7","ptien")=$get(ptien)
 ;
 ;
MATCHLOG ; build MATCHLOG
 ;
 ;@falls-thru-from
 ; UPDTPTL-UPDTPTL1
 ;@called-by none
 ;@calls
 ; $$FMTE^XLFDT
 ; $$NOW^XLFDT
 ; $$UP^XLFSTR
 ; $$HTE^XLFDT
 ; KILLREF
 ; CAPTORM
 ;
 ; If adding new patient, check whether we had a match for ssn or name
 ; on an existing patient (with precedence to the ssn). If so set
 ; MATCHLOG = new patient ien & add index to existing patient.
 ;
 new var
 new newptien set newptien=""
 if newpat do
 . set newptien=ptien ; ien of the new patient being added
 . ;
 . ; if 1 or more existing entries w/this ssn, set MATCHLOG
 . ;
 . if ptienssn do  quit
 . . new ssnien set ssnien=0
 . . for  do  quit:'ssnien
 . . . set ssnien=$order(@rootpl@("ssn",$get(fields("ssn")),ssnien))
 . . . quit:'ssnien
 . . . set @rootpl@(ssnien,"HL7MATCHLOG")=newptien
 . . . set @rootpl@("HL7MATCHLOG",ssnien,newptien)=""
 . . . use $principal
 . . . write !,"HL7MATCHLOG ssn","--- ssnien=",ssnien
 . . . write "--- newptien=",newptien
 . . . quit
 . . quit
 . ;
 . ; if 1 or more existing entries w/this patient name, set MATCHLOG
 . ;
 . if ptiennm do
 . . new pnien set pnien=0
 . . for  do  quit:'pnien
 . . . set pnien=$order(@rootpl@("name",$g(fields("saminame")),pnien))
 . . . quit:'pnien
 . . . set @rootpl@(pnien,"HL7MATCHLOG")=newptien
 . . . set @rootpl@("HL7MATCHLOG",pnien,newptien)=""
 . . . use $principal
 . . . write !,"HL7MATCHLOG name","---",pnien
 . . . quit
 . . quit
 . quit
 ;
 ;
 new field set field=""
 ; run through every fields subscript and set the
 ;   appropriate subscript patient entry in patient-lookup
 for  do  quit:field=""
 . set field=$order(fields(field))
 . quit:field=""
 . ;
 . ; new patient ====================================
 . ; if new patient just set all patient-lookup field w/data in field
 . ; array.
 . ;
 . ; Load ORM message data later
 . ;
 . if newpat do
 . . quit:field="ORM"
 . . set @rootpl@(ptien,field)=fields(field)
 . . quit
 . ;
 . ; old patient ====================================
 . ; if not new patient, only store field results that are NOT null.
 . ; Never overwrite existing patient's dfn; store dfn just received
 . ; in remotedfn field
 . ;
 . ; With existing patients, if new data for field doesn't match
 . ; pre-existing, save pre-existing data in changelog entry
 . ;
 . if '$get(newpat),fields(field)'="" do
 . . quit:field="ORM"
 . . quit:field="dfn"
 . . ;
 . . if $get(@rootpl@(ptien,field))'=fields(field) do
 . . . new now set now=$$FMTE^XLFDT($$NOW^XLFDT,5)
 . . . set @rootpl@(ptien,"hl7changelog",now,field)=fields(field)
 . . . quit
 . . set @rootpl@(ptien,field)=fields(field)
 . . quit
 . ;
 . ; indices =========================================
 . ; set all indices for old & new patients for this field
 . ; note: we must kill any existing earlier indices on existing
 . ; patients to prevent duplicate pointers
 . ;
 . quit:$get(fields(field))=""
 . ;
 . ; field=dfn =====================================
 . if field="dfn" do
 . . if newpat do
 . . . set @rootpl@("dfn",fields(field),ptien)=""
 . . . quit
 . . quit
 . ;
 . ; didn't get DFN from VA server (only ssn) so can't set remotedfn
 . ; field
 . set @rootpl@(ptien,"remotedfn")=""
 . ;
 . ; field=icn =====================================
 . if field="icn" do
 . . set @rootpl@("icn",fields(field),ptien)=""
 . . quit
 . ;
 . ; field=last5 ===================================
 . if field="last5" do
 . . if '$get(newpat) do
 . . . do KILLREF(field,$get(oldarr(field)),ptien)
 . . . quit
 . . set @rootpl@("last5",fields(field),ptien)=""
 . . quit
 . ;
 . ; field=saminame ================================
 . if field="saminame" do
 . . if '$get(newpat) do
 . . . do KILLREF(field,$get(oldarr(field)),ptien)
 . . . do KILLREF("name",$get(oldarr("name")),ptien)
 . . . do KILLREF("name",$$UP^XLFSTR($get(oldarr("name"))),ptien)
 . . . quit
 . . set @rootpl@("name",fields(field),ptien)=""
 . . set @rootpl@("saminame",fields(field),ptien)=""
 . . set @rootpl@("name",$$UP^XLFSTR(fields(field)),ptien)=""
 . . quit
 . ;
 . ; field=sinamef ==================================
 . if field="sinamef" do
 . . if '$get(newpat) do
 . . . do KILLREF(field,$get(oldarr(field)),ptien)
 . . . quit
 . . set @rootpl@(field,fields(field),ptien)=""
 . . quit
 . ;
 . ; field=sinamel ==================================
 . if field="sinamel" do
 . . if '$get(newpat) do
 . . . do KILLREF(field,$get(oldarr(field)),ptien)
 . . . quit
 . . set @rootpl@(field,fields(field),ptien)=""
 . . quit
 . ;
 . ; field=ssn ======================================
 . if field="ssn" do
 . . if '$get(newpat) do
 . . . do KILLREF(field,$get(oldarr(field)),ptien)
 . . . quit
 . . set @rootpl@(field,fields(field),ptien)=""
 . . quit
 . quit
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
 quit  ; end of UPDTPTL-UPDTPTL1-MATCHLOG
 ;
 ;
 ;
CAPTORM(fields,rootpl,ptien) ; save all ORM fields in patient-lookup
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; UPDTPTL-UPDTPTL1-MATCHLOG
 ;@calls none
 ;@input
 ; .fields = fields array
 ; rootpl = patient-lookup root
 ; ptien = patient ien
 ;@output
 ; ORM fields are saved in patient-lookup
 ;
 ;
 ;@stanza 2 remove old field result from patient-lookup root
 ;
 new node set node=$name(fields("ORM"))
 new snode set snode=$piece(node,")")
 new invdt
 for  do   quit:node'[snode
 . set node=$query(@node)
 . quit:node'[snode
 . set invdt=$qsubscript(node,2)
 . set @rootpl@(ptien,"ORM",invdt,$qsubscript(node,3))=@node
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of CAPTORM
 ;
 ;
 ;
KILLREF(field,oldrslt,ptien) ; kill old field in patient-lookup root
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; UPDTPTL-UPDTPTL1-MATCHLOG
 ;@calls none
 ;@input
 ; ]rootpl = patient-lookup root
 ; field = name of field to kill
 ; oldrslt = old field value to kill
 ; ptien = patient ien
 ;@output
 ; field is killed
 ;
 ;
 ;@stanza 2 remove old field result from patient-lookup root
 ;
 quit:$get(oldrslt)=""
 kill @rootpl@(field,oldrslt,ptien)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of KILLREF
 ;
 ;
 ;
 ;@ppi ACK^SAMIHL7
ACK ; force a com ACK
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;ppi;procedure;shell;silent;sac
 ;@called-by
 ; MSH^SAMIADT [<= EN^SAMIADT <= old HL7 app, no longer used]
 ; EN^SAMIORM [<= hl7 app INST-MCAR <= HL7, main vapals hl7 entry]
 ; EN-ACK^SAMITIU [<= old HL7 app, no longer used]
 ;@calls
 ; GENACK^HLMA1
 ;@input
 ;  expects all HL7 variables captured on message reception to be in
 ;  environment, incl:
 ; ]HL("EID")
 ; ]HL("EIDS")
 ; ]HLA
 ; ]HLA("HLA")
 ; ]HLREC("FS")
 ; ]HLREC("MID")
 ;@output
 ;  sends com ACK through appropriate link
 ; ]HLA("HLA",1)
 ; ]HLMTIENA
 ; ]HLP
 ; ]HLP("NAMESPACE")
 ; ^KBAP("SAMIHL7","HLA")
 ;
 ;
 ;@stanza 2 send HL7 ack message
 ;
 kill HLA("HLA")
 set HLA("HLA",1)="MSA"_HLREC("FS")_"CA"_HLREC("FS")_HLREC("MID")
 ;
 if $data(HLA("HLA")) do  quit
 . set HLP("NAMESPACE")="HL"
 . merge ^KBAP("SAMIHL7","HLA")=HLA
 . do GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"LM",1,.HLMTIENA,"",.HLP)
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of ACK
 ;
 ;
 ;
EOR ; end of routine SAMIHL7
