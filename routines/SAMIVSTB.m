SAMIVSTB ;;ven/lgc - M2M Broker to for VA-PALS ; 2019-02-21T21:35
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; API's called by SAMIVSTA only
 ;
 ;@routine-credits
 ;@primary development organization: Vista Expertise Network
 ;@primary-dev: Larry G. Carlson (lgc)
 ;@primary-dev: Alexis R. Carlson (arc)
 ;@additional-dev: Linda M. R. Yaw (lmry)
 ;@copyright:
 ;@license: see routine SAMIUL
 ;
 ;@last-updated: 2019-02-21
 ;@application: VA-PALS
 ;@version: 1.0
 ;
 ;@sac-exemption
 ; sac 2.2.8 Vendor specific subroutines may not be called directly
 ;  except by Kernel, Mailman, & VA Fileman.
 ; sac 2.3.3.2 No VistA package may use the following intrinsic
 ;  (system) variables unless they are accessed using Kernel or VA
 ;  FileMan supported references: $D[EVICE], $I[O], $K[EY],
 ;  $P[RINCIPAL], $ROLES, $ST[ACK], $SY[STEM], $Z*.
 ;  (Exemptions: Kernel & VA Fileman)
 ; sac 2.9.1: Application software must use documented Kernel
 ;  supported references to perform all platform specific functions.
 ;  (Exemptions: Kernel & VA Fileman)
 ;
 quit  ; not from top
 ;
 ;
 ;@API-code: $$VIT^SAMIVSTA
 ;@API-Context menu : ORRCMC DASHBOARD
 ;@API-Remote Procedure : ORRC VITALS BY PATIENT
 ;
 ; Pull patient Vitals from the server and
 ;   push into the 'patient-lookup' Graphstore
 ; Enter
 ;   dfm   = IEN of patient into file 2
 ;   sdate = Date to start search [optional]
 ;   edate = Date to end search [optional]
 ; Returns
 ;   Sets additional nodes in patient's Graphstore
 ;   If called as extrinsic
 ;      0   = unable to identify patient
 ;      1   = lookup of patient successful
 ;      2   = and update of Graphstore successful
VIT(dfn,sdate,edate) ;
 if '$get(dfn) quit:$Q 0  quit
 new cntxt,rmprc,console,cntnopen,SAMIUARR,SAMIUXD
 set cntxt="ORRCMC DASHBOARD"
 set rmprc="ORRC VITALS BY PATIENT"
 set (console,cntnopen)=0
 ; if no start date specified, set to 19010101
 set:+$get(sdate)=0 sdate="19000101"
 ; if no end date specified, set to now
 set:+$get(edate)=0 edate=$piece($$FMTHL7^XLFDT($$HTFM^XLFDT($horolog)),"-")
 set SAMIUARR(1)=dfn
 set SAMIUARR(2)=sdate
 set SAMIUARR(3)=edate
 set SAMIUARR(4)="1"
 kill SAMIUXD
 do M2M^SAMIM2M(.SAMIUXD,cntxt,rmprc,console,cntnopen,.SAMIUARR)
 if '$data(SAMIUXD) quit:$Q 0  quit
 ;
 new ptdfn,node,gien,ptwt,ptht,ptbp,str,J,vitdt,pttemp
 set (ptdfn,ptwt,ptht,ptbp,vitdt)=0
 for J=1:1:$length(SAMIUXD,$char(13,10)) do
 . set str=$piece(SAMIUXD,$char(13,10),J)
 . if str["Item=VIT:" do
 .. set ptdfn=+$piece(str,":",2),vitdt=+$piece(str,"^",3)
 . if str["Data=B/P",'$get(ptbp) do
 .. set ptbp=$piece(str,"^",2)_"^"_vitdt
 . if str["Data=Ht.",'$get(ptht) do
 .. set ptht=$piece(str,"Data=Ht.",2)
 .. set ptht=$piece(ptht,"^",2,5)_"^"_vitdt
 . if str["Data=Wt.",'$get(ptwt) do
 .. set ptwt=$piece(str,"Data=Wt.",2)
 .. set ptwt=$piece(str,"^",2,5)_"^"_vitdt
 . if str["Data=Temp" do
 .. set pttemp=$piece(str,"Data=Temp.",2)
 .. set pttemp=$piece(str,"^",2,5)_"^"_vitdt
 if '$get(ptdfn),'(ptdfn=dfn) quit:$Q 0  quit
 new root set root=$$setroot^%wd("patient-lookup")
 set node=$name(@root@("dfn",ptdfn)),node=$query(@node)
 if '($piece(node,",",4)[ptdfn) quit:$Q 1  quit
 set gien=+$piece(node,",",5)
 if 'gien quit:$Q 1  quit
 set:$get(ptbp) @root@(gien,"vitals bp")=ptbp
 set:$get(ptht) @root@(gien,"vitals ht")=ptht
 set:$get(ptwt) @root@(gien,"vitals wt")=ptwt
 set:$get(pttemp) @root@(gien,"vitals temp")=pttemp
 set node=$name(@root@("dfn",ptdfn))
 quit:$Q 2  quit
 ;
 ;
 ;
 ;
 ;@API-code: $$VPR^SAMIVSTA
 ;@API-Context menu : VPR APPLICATION PROXY
 ;@API-Remote Procedure : VPR GET PATIENT DATA
 ;
 ; Pull Virtual Patient Record (VPR) from the server and
 ;   push information into the 'patient-lookup' Graphstore
 ; Enter
 ;   dfn   = IEN of patient into file 2
 ; Returns
 ;   Sets additional nodes in patient's Graphstore
 ;   If called as extrinsic
 ;      0      = unable to identify patient
 ;      1      = lookup of patient successful
 ;      gien   = and update of Graphstore successful
VPR(dfn) ;
 if '$get(dfn) quit:$Q 0  quit
 new cntxt,rmprc,console,cntnopen,SAMIUARR,SAMIUXD,root
 set cntxt="VPR APPLICATION PROXY"
 set rmprc="VPR GET PATIENT DATA"
 set (console,cntnopen)=0
 kill SAMIUXD
 set SAMIUARR(1)=dfn
 set SAMIUARR(2)="demographics;reactions;problems;vitals;labs;meds;immunizations;observations;visits;appointments;documents;procedures;consults;flags;factors;skinTests;exams,education,insurance"
 do M2M^SAMIM2M(.SAMIUXD,cntxt,rmprc,console,cntnopen,.SAMIUARR)
 ;for J=1:1:$length(SAMIUXD,$char(13,10)) write !,$piece(SAMIUXD,$char(13,10),J)
 ;
 new admtdt,attnd,strng,J,node
 new inpt,pticn,ptloc,ptsrvc,ptssn,ptwt,ptht,spclty
 ;
 for J=1:1:$length(SAMIUXD,$char(13,10)) do
 . set strng=$piece(SAMIUXD,$char(13,10),J)
 .; Is this attending information?
 . if strng["attending code" do  quit
 .. set attnd=$piece(strng,"'",2)
 .. set attnd=attnd_"^"_$piece(strng,"'",5)
 .;
 .; Is this the patient's SSN?
 . if strng["ssn value" do  quit
 .. set ptssn=$piece(strng,"'",2)
 .;
 .; Is this patient's admission data?
 . if strng["admitted id" do  quit
 .. set admtdt="^DGPM("_+$piece(strng,"'",3)_",^"_+$piece(strng,"'",5)
 .;
 .; Is this patient's specialty data
 . if strng["specialty code=" do  quit
 .. set spclty="CODE="_+$piece(strng,"'",3)_"^"_$piece(strng,"'",5)
 .;
 .; Is this patient location data?
 . if strng["location code=" do  quit
 .. set ptloc=$piece(strng,"'",2)_"^"_$piece(strng,"'",4)
 .;
 .; Is this patient's assigned service
 . if strng["locSvc code" do  quit
 .. set ptsrvc=$piece(strng,"'",2)
 .;
 .; Is this the patient's ICN?
 . if strng["icn value=" do  quit
 .. set pticn=$piece(strng,"'",2)
 .;
 .; Is this an inpatient
 . if strng["inpatient value" do  quit
 .. set inpt=$piece(strng,"'",2)
 ;
 ; Now save data in "patient-lookup" Graph Store
 ;
VPR1 set root=$$setroot^%wd("patient-lookup")
 set node=$name(@root@("dfn",dfn)),node=$q(@node)
 if '($piece(node,",",4)[dfn) quit:$Q 1  quit
 set gien=+$piece(node,",",5)
 if 'gien quit:$Q 1  quit
 set @root@(gien,"attending")=$get(attnd)
 set @root@(gien,"admission")=$get(admtdt)
 set @root@(gien,"specialty")=$get(spclty)
 set @root@(gien,"location")=$get(ptloc)
 set @root@(gien,"service")=$get(ptsrvc)
 set @root@(gien,"icn")=$get(pticn)
 set @root@(gien,"inpatient")=$get(inpt)
 quit:$Q $get(gien)  quit
 ;
EOR ; End of routine SAMIVSTB
