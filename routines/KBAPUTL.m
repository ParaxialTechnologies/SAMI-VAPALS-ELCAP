KBAPUTL ;ven/lgc - M2M data from another system ; 4/27/18 5:32pm
 ;;1.0;;**LOCAL**; APR 22, 2018
 ;
 ;
 ; Get all patients from a server
 ; e.g. M2M to Avicenna using known credentials
 ;  D ALLPTS^KBAPUTL(9430,"35.164.151.93","SEPI9393;Pvul+9339")
 ;  *** ORWPT ID INFO
ALLPTS(PORT,IP,ACCVER) ;
 K ^KBAP("ALLPTS")
 Q:$G(IP)=""  Q:$G(PORT)=""
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("HMP UI CONTEXT")
 F I=65:1:90 D
 . S FINI=$C(I)
 . K ^TMP("POO",$J)
 . S ^TMP("POO",$J,"TYPE")="STRING"
 . S ^TMP("POO",$J,"VALUE")="NAME"
 . S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 . S ^TMP("POO",$J,"TYPE")="STRING"
 . S ^TMP("POO",$J,"VALUE")=FINI
 . S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
 . K REQ
 . S CALL=$$CALLRPC^XWBM2MC("HMP PATIENT SELECT","REQ",1)
 . S NODE=$NA(^KBAP("ALLPTS",FINI))
 . M @NODE=REQ
 S CLOSE=$$CLOSE^XWBM2MC
 W !,$ZUT
 Q
 ;
 ;
 ; Make Graph Store patient-lookup global from 
 ;  ^KBAP("ALLPTS")
 ; e.g.
 ;   D MKGPH^KBAPUTL
MKGPH Q:'$D(^KBAP("ALLPTS"))
 d purgegraph^%wd("patient-lookup")
 N gien,NODE,PTDATA,root
 s root=$$setroot^%wd("patient-lookup")
 s gien=0
 N NODE S NODE=$NA(^KBAP("ALLPTS"))
 F  S NODE=$Q(@NODE) Q:NODE=""  D
 . S PTDATA=@NODE
 . S gien=gien+1
 . S @root@(gien,"saminame")=$P(PTDATA,"^",4)
 . S @root@(gien,"sinamef")=$P($P($P(PTDATA,"^",4),",",2)," ")
 . S @root@(gien,"sinamel")=$P($P(PTDATA,"^",4),",")
 . S @root@(gien,"sbdob")=$P(PTDATA,"^",10)
 . S @root@(gien,"last5")=$P(PTDATA,"^",9)
 . S @root@(gien,"dfn")=$P(PTDATA,"^",12)
 . S @root@("dfn",$P(PTDATA,"^",12),gien)=""
 . S @root@("last5",$P(PTDATA,"^",9),gien)=""
 . S @root@("name",$P(PTDATA,"^",4),gien)=""
 . S @root@("name",$P(PTDATA,"^",1),gien)=""
 . S @root@("sinamef",$P($P($P(PTDATA,"^",4),",",2)," "))=""
 . S @root@("sinamef",$P($P($P(PTDATA,"^"),",",2)," "))=""
 . S @root@("sinamel",$P($P(PTDATA,"^",4),","))=""
 . S @root@("sinamel",$P($P(PTDATA,"^"),","))=""
 Q
 ;
 ; Obtain full SSN on a patient
 ; e.g. M2M to Avicenna using known credentials
 ; D PTSSN^KBAPUTL(.XDATA,812,9430,"35.164.151.93","SEPI9393;Pvul+9339")
PTSSN(XDATA,DFN,PORT,IP,ACCVER) ;
 K XDATA
 Q:'$G(DFN)
 Q:'$G(PORT)  Q:$G(IP)=""
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("OR CPRS GUI CHART")
 K ^TMP("POO")
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=DFN
 N NODE S NODE=$NA(ALLPTS)
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 S CALL=$$CALLRPC^XWBM2MC("ORWPT ID INFO","POOSSN",1)
 I $G(POOSSN(1)) S XDATA=POOSSN(1)
 S CLOSE=$$CLOSE^XWBM2MC
 ; Update patient-lookup entry for this patient
PTSSN1 N root s root=$$setroot^%wd("patient-lookup")
 N NAME,NODE,gien
 S NAME=$P(XDATA,"^",8)
 N NODE S NODE=$NA(@root@("name",NAME))
 S NODE=$Q(@NODE)
 I ($P(NODE,",",4)_","_$P(NODE,",",5))[NAME S gien=+$P(NODE,",",6)
 Q:'$G(gien)
 N DOB S DOB=$$FMTHL7^XLFDT($P(XDATA,"^",2))
 Q:'(DOB=@root@(gien,"sbdob"))
 N LAST5 S LAST5=$E(NAME)_$E(XDATA,6,9)
 Q:'(LAST5=@root@(gien,"last5"))
 S @root@(gien,"ssn")=$P(XDATA,"^")
 S @root@("ssn",$P(XDATA,"^"))=gien
 Q
 ;
 ;
 ; Pull Vitals on a patient
 ; e.g. M2M to Avicenna using known credentials
 ; D VIT^KBAPUTL(.XDATA,812,,,9430,"35.164.151.93","SEPI9393;Pvul+9339")
VIT(XDATA,DFN,SDATE,EDATE,PORT,IP,ACCVER) ;
 K XDATA
 Q:$G(IP)=""  Q:$G(PORT)=""
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 ; if no start date specified, set to 19010101
 S:+$G(SDATE)=0 SDATE="19000101"
 ; if no end date specified, set to now
 S:+$G(EDATE)=0 EDATE=$P($$FMTHL7^XLFDT($$HTFM^XLFDT($H)),"-")
 N CALL,CLOSE,CONNECT,CONTEXT,DIVFLAG,DIVISION,REQ,X
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("ORRCMC DASHBOARD")
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=DFN
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=SDATE
 S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=EDATE
 S X=$$PARAM^XWBM2MC(3,$NA(^TMP("POO",$J)))
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="1"
 S X=$$PARAM^XWBM2MC(4,$NA(^TMP("POO",$J)))
 S CALL=$$CALLRPC^XWBM2MC("ORRC VITALS BY PATIENT","REQ",1)
 M XDATA=REQ
 S CLOSE=$$CLOSE^XWBM2MC
 ; Vitals will be in XDATA array
 ; XDATA(1)="Item=VIT:801;3170309.183916^^3170309.183916"
 ; XDATA(2)="Data=B/P^113/85^^^^^^^Data=Ht.^71^in^180.34^cm^^^^"
 ; XDATA(3)="Data=Wt.^254.7^lb^115.77^kg^36*^^^Item=VIT:801;3161130.081805^^3161130.081805"
VIT1 N root s root=$$setroot^%wd("patient-lookup")
 N PTDFN,NODE,gien,PTWT,PTHT,PTBP
 S (PTDFN,PTWT,PTHT,PTBP)=0
 S NODE=$NA(XDATA)
 F  S NODE=$Q(@NODE) Q:'(NODE["XDATA(")  D
 . I (@NODE["Item=VIT:"),'$G(PTDFN) S PTDFN=+$P(@NODE,":",2)
 . I (@NODE["Data=B/P"),'$G(PTBP) S PTBP=$P(@NODE,"^",2)
 . I (@NODE["Data=Ht."),'$G(PTHT) D
 .. S PTHT=$P(@NODE,"Data=Ht.",2)
 .. S PTHT=$P(PTHT,"^",2,5)
 . I (@NODE["Data=Wt."),'$G(PTWT) D
 .. S PTWT=$P(@NODE,"Data=Wt.",2)
 .. S PTWT=$P(PTWT,"^",2,5)
VIT2 Q:'$G(PTDFN)
 S NODE=$NA(@root@("dfn",PTDFN)),NODE=$Q(@NODE)
 S gien=+$P(NODE,",",5)
 S:$G(PTBP) @root@(gien,"bp")=PTBP
 S:$G(PTHT) @root@(gien,"ht")=PTHT
 S:$G(PTWT) @root@(gien,"wt")=PTWT
 S NODE=$NA(@root@("dfn",PTDFN))
 S NODE=$Q(@NODE)
 I ($P(NODE,",",4)[PTDFN) S gien=+$P(NODE,",",5)
 Q:'$G(gien)
 ;
 ;
EOR ;KBAPUTL
