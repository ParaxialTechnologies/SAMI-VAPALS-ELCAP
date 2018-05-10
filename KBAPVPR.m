KBAPVPR ;ven/lgc - GATHER AND PARSE PT VPR ; 5/9/18 11:45am
 ;;1.0;;**LOCAL**; MAY 8, 2018
 ;
 ;
 ; Get Virtual Patient Record
EN(DFN) Q:'$G(DFN)
 D VPR(DFN,9430,"35.164.151.93","SEPI9393;Pvul+9339")
 Q
 ;
 ;e.g.
 ; D VPR^KBAPVPR(DFN,PORT,IP,ACCVER)
 ; D VPR^KBAPVPR(22,9430,"35.164.151.93","SEPI9393;Pvul+9339")
VPR(DFN,PORT,IP,ACCVER) ;
 Q:$G(IP)=""  Q:$G(PORT)=""
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 N CALL,CLOSE,CONNECT,CONTEXT,DIVFLAG,DIVISION,REQ,X,XSSN
 N REG,POO,NODE,gien,root
 ;
 N root s root=$$setroot^%wd("patient-lookup")
 S NODE=$NA(@root@("dfn",DFN))
 S NODE=$Q(@NODE)
 S gien=+$P(NODE,",",5)
 Q:'$G(gien)
 Q:'(@root@(gien,"dfn")=DFN)
 ;
 ; Set up connection
CNCT S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 ;
 ; Get SSN
PULLSSN S CONTEXT=$$SETCONTX^XWBM2MC("OR CPRS GUI CHART")
 K ^TMP("POO")
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=DFN
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 S CALL=$$CALLRPC^XWBM2MC("ORWPT ID INFO","XSSN",1)
 I $G(XSSN(1)) D
 . S @root@(gien,"ssn")=$P(XSSN(1),"^")
 . S @root@("ssn",$P(XSSN(1),"^"))=gien
 ;
 ; Clear CONTEXT
 N CCONTEXT S CCONTEXT=$$GETCONTX^XWBM2MC(.CONTEXT)
 ;
PULLVPR S CONTEXT=$$SETCONTX^XWBM2MC("VPR APPLICATION PROXY")
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=DFN
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 S CALL=$$CALLRPC^XWBM2MC("VPR GET PATIENT DATA","REQ",1)
 ;
 ; Now run down array and pull info
 ;
 G:'$D(REQ) PULLRAD
 ;
 N ADMTDT,ATTND,NODE,STRNG
 N INPT,PTICN,PTLOC,PTSRVC,PTSSN,PTWT,PTHT,SPCLTY
 S NODE=$NA(REQ)
 F  S NODE=$Q(@NODE) Q:NODE'["REQ("  D
 . S STRNG=@NODE
 .; Is this attending information?
 . I STRNG["&lt;attending code=&apos" D  Q
 .. S ATTND=+$P(STRNG,";",3)
 .. S ATTND=ATTND_"^"_$P($P(STRNG,";",5),"&apos")
 .;
 .; Is this the patient's SSN?
 . I STRNG["&lt;ssn value" D  Q
 .. S PTSSN=$P($P(STRNG,";",3),"&apos")
 .;
 .; Is this patient's admission data?
 . I STRNG["&lt;admitted id" D  Q
 .. S ADMTDT="^DGPM("_+$P(STRNG,";",3)_",^"_+$P(STRNG,";",5)
 .;
 .; Is this patient's specialty data
 . I STRNG["&lt;specialty code=" D  Q
 .. S SPCLTY="CODE="_+$P(STRNG,";",3)_"^"_$P($P(STRNG,";",5),"&apos")
 .;
 .; Is this patient location data?
 . I STRNG["&lt;location code=" D  Q
 .. N F405IEN S F405IEN=+$P(STRNG,";",3)
 .. N DNODE S DNODE=$NA(^DGPM(F405IEN)),DNODE=$Q(@NODE)
 .. N F42IEN S F42IEN=$P(@DNODE,"^",6)
 .. S PTLOC="^DGPM("_F405IEN_","_"^"
 .. S PTLOC=PTLOC_"^DIC(42,"_F42IEN_",^"
 .. S PTLOC=PTLOC_$P($P(STRNG,";",5),"&apos")
 .;
 .; Is this patient's assigned service
 . I STRNG["&lt;locSvc code" D  Q
 .. S PTSRVC=$P($P(STRNG,";",5),"&apos")
 .;
 .; Is this the patient's ICN?
 . I STRNG["&lt;icn value=" D  Q
 .. S PTICN=+$P(STRNG,";",3)
 .;
 .; Is this an inpatient
 . I STRNG["&lt;inpatient value" D  Q
IOPT .. S INPT=$P($P($P(STRNG,"inpatient value",2),";",2),"&apos")
 ;
 ; Now save data in "patient-lookup" Graph Store
 ;
 S @root@(gien,"attending")=$G(ATTND)
 S @root@(gien,"admission")=$G(ADMTDT)
 S @root@(gien,"specialty")=$G(SPCLTY)
 S @root@(gien,"location")=$G(PTLOC)
 S @root@(gien,"service")=$G(PTSRVC)
 S @root@(gien,"icn")=$G(PTICN)
 S @root@(gien,"inpatient")=$G(INPT)
 ;
 ; Clear Context
 N CCONTEXT S CCONTEXT=$$GETCONTX^XWBM2MC(.CONTEXT) 
 ;
 ; Now get radiology
PULLRAD S CONTEXT=$$SETCONTX^XWBM2MC("MAG WINDOWS")
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=DFN
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 S CALL=$$CALLRPC^XWBM2MC("MAGJ PTRADEXAMS","POO",1)
 I $G(POO(1))]"" D
 . S STRNG=$G(POO(1))
 . N RAD
 . S RAD=$P(STRNG,"^",3)_"^"_$P(STRNG,"^",5)_"^"
 . S RAD=RAD_$P(STRNG,"^",7)_"^"_$P(STRNG,"^",15)
 . S @root@(gien,"rad")=RAD
 ;
 ;
 S CLOSE=$$CLOSE^XWBM2MC
 ;
 W !,$ZUT,!
 ; 
 S NODE=$NA(@root@(gien))
 F  S NODE=$Q(@NODE) Q:NODE'[gien  W !,NODE,"=",@NODE
 ;
EOR ;KBAPVPR
