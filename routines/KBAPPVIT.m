KBAPPVIT ;VEN/LGC - Pull Vitals from another system ; 6/17/18 7:08pm
 ;;1.0;GMRV;**LOCAL**; APR 22, 2018
EN(XDATA,DFN,SDATE,EDATE) ;
 K XDATA
 ; if no start date specified, set to 19010101
 S:+$G(SDATE)=0 SDATE="19000101"
 ; if no end date specified, set to now
 S:+$G(EDATE)=0 EDATE=$P($$FMTHL7^XLFDT($$HTFM^XLFDT($H)),"-")
 N CALL,CLOSE,CONNECT,CONTEXT,DIVFLAG,DIVISION,REQ,X
 N IP,PORT,ACCVER
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 Q:$G(IP)=""  Q:$G(PORT)=""
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 ;
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
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
 Q
 ;
 ;^%wd(17.040801,2,0) = elcap-patients
 ;^%wd(17.040801,2,1,"samicreatedate") = 2018-03-08
 ;^%wd(17.040801,2,1,"saminame") = Primo,Guy
 ;^%wd(17.040801,2,1,"saminum") = 1
 ;^%wd(17.040801,2,1,"samistudyid") = XXX0001
 ;^%wd(17.040801,2,1,"sinamef") = Guy
 ;^%wd(17.040801,2,1,"sinamel") = Primo
 ;^%wd(17.040801,2,1,"sisid") = XXX0001
 ;
 ; Enter new patient
 ;   build list of patients
 ;
 ;
 ; Enter height and weight on existing patient
 ;
 ; Get all patients from a site
 ;  *** ORWPT ID INFO
ALLPTS N CCONNECT,CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 N IP,PORT,ACCVER
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 Q:$G(IP)=""  Q:$G(PORT)=""
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 ;
 S CONNECT=$$CONNECT^XWBM2MC(9430,"35.164.151.93","SEPI9393;Pvul+9339")
 K ALLPTS
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
 . M ALLPTS(FINI)=REQ
 ;
 ; Clear CONTEXT in preparation for a new one
ALLPTS1 S CCONTEXT=$$GETCONTX^XWBM2MC(.CONTEXT)
 ;
 ; Now get SSN for every patient in ALLPTS array
ALLPTS2 S CONTEXT=$$SETCONTX^XWBM2MC("OR CPRS GUI CHART")
 K ^TMP("POO")
 N NODE S NODE=$NA(ALLPTS)
 F  S NODE=$Q(@NODE) Q:'NODE["ALLPTS("  D
 . W !,NODE
 . K POOSSN
 . S DFN=$P(@NODE,"^",12)
 . S ^TMP("POO",$J,"TYPE")="STRING"
 . S ^TMP("POO",$J,"VALUE")=DFN
 . S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 . S CALL=$$CALLRPC^XWBM2MC("ORWPT ID INFO","POOSSN",1)
 . I $G(POOSSN(1)) S $P(@NODE,"^",25)=$P(POOSSN(1),"^")
 ;
 S CLOSE=$$CLOSE^XWBM2MC
 Q
 ;
MKGPH N gien,NODE,PTDATA,root
 s root=$$setroot^%wd("patient-lookup")
 s gien=0
 N NODE S NODE=$NA(ALLPTS)
 F  S NODE=$Q(@NODE) Q:NODE'["ALLPTS("  D
 . S PTDATA=@NODE
 . S gien=gien+1
 . S @root@(gien,"saminame")=$P(PTDATA,"^",4)
 . S @root@(gien,"sinamef")=$P($P($P(PTDATA,"^",4),",",2)," ")
 . S @root@(gien,"sinamel")=$P($P(PTDATA,"^",4),",")
 . S @root@(gien,"sbdob")=$P(PTDATA,"^",10)
 . S @root@(gien,"last5")=$P(PTDATA,"^",9)
 . S @root@("last5",$P(PTDATA,"^",9),gien)=""
 . S @root@("name",$P(PTDATA,"^",4),gien)=""
 . S @root@("name",$P(PTDATA,"^",1),gien)=""
 . S @root@("sinamef",$P($P($P(PTDATA,"^",4),",",2)," "))=""
 . S @root@("sinamef",$P($P($P(PTDATA,"^"),",",2)," "))=""
 . S @root@("sinamel",$P($P(PTDATA,"^",4),","))=""
 . S @root@("sinamel",$P($P(PTDATA,"^"),","))=""
 ;
 Q
 ;
