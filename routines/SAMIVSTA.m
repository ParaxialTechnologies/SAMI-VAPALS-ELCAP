SAMIVSTA ;;ven/lgc - M2Broker calls for VA-PALS ; 6/21/19 9:02am
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;@module documentation see routine SAMIVUL
 ;
SV2VISTA(filter) ; Build a new patient TIU
 goto SV2VISTA^SAMIVST1
 ;
TASKIT ; Task off building a new patient TIU
 goto TASKIT^SAMIVST1
 ;
NEWTIU ; Build new patient TIU
 goto NEWTIU^SAMIVST1
 ;
NEWTXT ; Add text to a TIU document
 goto NEWTXT^SAMIVST1
 ;
ENCNTR ; Add encounter to a TIU
 goto ENCNTR^SAMIVST1
 ;
BLDTIU(tiuien,dfn,title,user,clinien) ; Build the TIU
 goto BLDTIU^SAMIVST1
 ;
SETTEXT(tiuien,dest) ; Set text into a TIU document
 goto SETTEXT^SAMIVST1
 ;
BLDENCTR(tiuien,SAMIUHFA) ; Build the encounter
 goto BLDENCTR^SAMIVST1
 ;
ADDSGNRS(filter) ; Add additional signers to a TIU
 goto ADDSGNRS^SAMIVST1
 ;
ADDSIGN ; Add signers
 goto ADDSIGN^SAMIVST1
 ;
TIUADND(tiuien,userduz) ; Add and addendum to a TIU
 goto TIUADND^SAMIVST2
 ;
VISTSTR(tiuien) ; Build the VSTR string for an existing TIU
 goto VISTSTR^SAMIVST2
 ;
PTINFO(dfn,debug) ; Get additional information on a patient
 goto PTINFO^SAMIVST2
 ;
PTSSN(dfn) ; Get SSN on a patient
 goto PTSSN^SAMIVST2
 ;
SIGNTIU(tiuda) ; Sign a TIU note
 goto SIGNTIU^SAMIVST2
 ;
DELTIU(tiuien) ; Delete a TIU note
 goto DELTIU^SAMIVST2
 ;
URBRUR(zipcode) ; Return Rural or Urban for a zip code
 goto URBRUR^SAMIVST2
 ;
RACE(icn) ; Return the race information for a patient
 goto RACE^SAMIVST2
 ;
KASAVE(provider,tiuien) ;  Kills cross refs on a TIU
 goto KASAVE^SAMIVST1
 ;
VIT(dfn,sdate,edate) ; Gets vitals information for a patient
 goto VIT^SAMIVST3
 ;
VPR(dfn) ; Pulls the Virtual Patient Record on a patient
 goto VPR^SAMIVST3
 ;
ALLPTS ; Gets all patients off the VA server
 goto ALLPTS^SAMIVST4
 ;
ALLPTS1(SAMISS) ; Saves all patients data on the client
 goto ALLPTS1^SAMIVST4
 ;
MKGPH ; Builds the patient-lookup graphstore
 goto MKGPH^SAMIVST4
 ;
RMDRS() ; Gets reminders for a patient
 goto RMDRS^SAMIVST4
 ;
PRVDRS() ; Pulls a list of active providers from the VA server
 goto PRVDRS^SAMIVST4
 ;
CLINICS() ; Pulls a list of clinics from the VA server
 goto CLINICS^SAMIVST4
 ;
HLTHFCT() ; Pulls health factors from the VA server
 goto HLTHFCT^SAMIVST4
 ;
CLRGRPS(name) ; Clear an existing graphstore global
 goto CLRGRPS^SAMIVST4
 ;
RADPROCD(StationNumber) ; Pull radiology procedures
 goto RADPROCD^SAMIVST5
 ;
ACTEXAMS() ; Pull active radiology exams from the VA server
 goto ACTEXAMS^SAMIVST5
 ;
RADSTAFF() ; Pull list of radiology staff from the VA server
 goto RADSTAFF^SAMIVST5
 ;
RADRESDT() ; Pull list of radiology residents from the VA server
 goto RADRESDT^SAMIVST5
 ;
RADTECHS() ; Pull list of radiology techs from the VA server
 goto RADTECHS^SAMIVST5
 ;
RADMODS() ; Pull radiology mods list from VA server
 goto RADMODS^SAMIVST5
 ;
RADDXCDS() ; Pull radiology diagnostic codes from VA server
 goto RADDXCDS^SAMIVST5
 ;
 ;
EOR ; End of routine SAMIVSTA
