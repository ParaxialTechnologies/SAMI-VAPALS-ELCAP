SAMIVSTB ;;ven/lgc - M2M Broker to for VA-PALS ; 1/16/19 9:39am
 ;;18.0;SAMI;;
 ;
 ; API's called by SAMIVSA only
 ;
 ;@routine-credits
 ;@primary development organization: Vista Expertise Network
 ;@primary-dev: Larry G. Carlson (lgc)
 ;@primary-dev: Alexis R. Carlson (arc)
 ;@copyright:
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-09-26
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
 Q  ; not from top
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
 i '$g(dfn) q:$Q 0  q
 n cntxt,rmprc,console,cntnopen,SAMIUARR,SAMIUXD
 s cntxt="ORRCMC DASHBOARD"
 s rmprc="ORRC VITALS BY PATIENT"
 s (console,cntnopen)=0
 ; if no start date specified, set to 19010101
 s:+$g(sdate)=0 sdate="19000101"
 ; if no end date specified, set to now
 s:+$g(edate)=0 edate=$p($$FMTHL7^XLFDT($$HTFM^XLFDT($H)),"-")
 s SAMIUARR(1)=dfn
 s SAMIUARR(2)=sdate
 s SAMIUARR(3)=edate
 s SAMIUARR(4)="1"
 k SAMIUXD
 d M2M^SAMIM2M(.SAMIUXD,cntxt,rmprc,console,cntnopen,.SAMIUARR)
 i '$d(SAMIUXD) q:$Q 0  q
 ;
 n ptdfn,node,gien,ptwt,ptht,ptbp,str,J,vitdt,pttemp
 s (ptdfn,ptwt,ptht,ptbp,vitdt)=0
 f J=1:1:$L(SAMIUXD,$c(13,10)) d
 . s str=$p(SAMIUXD,$c(13,10),J)
 . i str["Item=VIT:" d
 .. s ptdfn=+$p(str,":",2),vitdt=+$p(str,"^",3)
 . i str["Data=B/P",'$g(ptbp) d
 .. s ptbp=$p(str,"^",2)_"^"_vitdt
 . i str["Data=Ht.",'$g(ptht) d
 .. s ptht=$p(str,"Data=Ht.",2)
 .. s ptht=$p(ptht,"^",2,5)_"^"_vitdt
 . i str["Data=Wt.",'$g(ptwt) d
 .. s ptwt=$p(str,"Data=Wt.",2)
 .. s ptwt=$p(str,"^",2,5)_"^"_vitdt
 . i str["Data=Temp" d
 .. s pttemp=$p(str,"Data=Temp.",2)
 .. s pttemp=$p(str,"^",2,5)_"^"_vitdt
 i '$g(ptdfn),'(ptdfn=dfn) q:$Q 0  q
 n root s root=$$setroot^%wd("patient-lookup")
 s node=$na(@root@("dfn",ptdfn)),node=$q(@node)
 i '($p(node,",",4)[ptdfn) q:$Q 1  q
 s gien=+$p(node,",",5)
 i 'gien q:$Q 1  q
 s:$g(ptbp) @root@(gien,"vitals bp")=ptbp
 s:$g(ptht) @root@(gien,"vitals ht")=ptht
 s:$g(ptwt) @root@(gien,"vitals wt")=ptwt
 s:$g(pttemp) @root@(gien,"vitals temp")=pttemp
 s node=$na(@root@("dfn",ptdfn))
 q:$Q 2  q
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
 I '$g(dfn) q:$Q 0  q
 n cntxt,rmprc,console,cntnopen,SAMIUARR,SAMIUXD,root
 s cntxt="VPR APPLICATION PROXY"
 s rmprc="VPR GET PATIENT DATA"
 s (console,cntnopen)=0
 k SAMIUXD
 s SAMIUARR(1)=dfn
 s SAMIUARR(2)="demographics;reactions;problems;vitals;labs;meds;immunizations;observations;visits;appointments;documents;procedures;consults;flags;factors;skinTests;exams,education,insurance"
 d M2M^SAMIM2M(.SAMIUXD,cntxt,rmprc,console,cntnopen,.SAMIUARR)
 ;F J=1:1:$L(SAMIUXD,$C(13,10)) W !,$p(SAMIUXD,$C(13,10),J)
 ;
 n admtdt,attnd,strng,J,node
 n inpt,pticn,ptloc,ptsrvc,ptssn,ptwt,ptht,spclty
 ;
 f J=1:1:$L(SAMIUXD,$C(13,10)) d
 . s strng=$p(SAMIUXD,$C(13,10),J)
 .; Is this attending information?
 . i strng["attending code" d  q
 .. s attnd=$p(strng,"'",2)
 .. s attnd=attnd_"^"_$p(strng,"'",5)
 .;
 .; Is this the patient's SSN?
 . i strng["ssn value" d  q
 .. s ptssn=$p(strng,"'",2)
 .;
 .; Is this patient's admission data?
 . i strng["admitted id" d  q
 .. s admtdt="^DGPM("_+$p(strng,"'",3)_",^"_+$p(strng,"'",5)
 .;
 .; Is this patient's specialty data
 . i strng["specialty code=" d  q
 .. s spclty="CODE="_+$p(strng,"'",3)_"^"_$p(strng,"'",5)
 .;
 .; Is this patient location data?
 . i strng["location code=" d  q
 .. s ptloc=$p(strng,"'",2)_"^"_$p(strng,"'",4)
 .;
 .; Is this patient's assigned service
 . i strng["locSvc code" d  q
 .. s ptsrvc=$p(strng,"'",2)
 .;
 .; Is this the patient's ICN?
 . i strng["icn value=" d  q
 .. s pticn=$p(strng,"'",2)
 .;
 .; Is this an inpatient
 . i strng["inpatient value" d  q
 .. s inpt=$p(strng,"'",2)
 ;
 ; Now save data in "patient-lookup" Graph Store
 ;
VPR1 s root=$$setroot^%wd("patient-lookup")
 s node=$na(@root@("dfn",dfn)),node=$q(@node)
 i '($p(node,",",4)[dfn) q:$Q 1  q
 S gien=+$p(node,",",5)
 I 'gien q:$Q 1  q
 s @root@(gien,"attending")=$g(attnd)
 s @root@(gien,"admission")=$g(admtdt)
 s @root@(gien,"specialty")=$g(spclty)
 s @root@(gien,"location")=$g(ptloc)
 s @root@(gien,"service")=$g(ptsrvc)
 s @root@(gien,"icn")=$g(pticn)
 s @root@(gien,"inpatient")=$g(inpt)
 q:$Q $g(gien)  q
 ;
EOR ; End of routine SAMIVSTB
