KBAPUTL1 ;ven/lgc - M2M Add single patient ; 7/4/18 9:28am
 ;;1.0;;**LOCAL**; APR 22, 2018
 ;
 Q  ; No entry from top
 ;
EN ; Temporary routine to allow testers to add
 ;  a new patient to their local graph store
 ; As the assumption is that the user had added a
 ;  new patient to their local system, it is
 ;  necessary to delete the entry in the parameter
 ;  SAMI IP ADDRESS so we don't reach out to
 ;  another VistA instance looking for the new patient
 ; May be run directly or through option
 ;  KBAP ADD PT TO GRAPH STORE
 W !,"Adding a patient to graph store through M2M"
 W !,"  requires several seconds.  Be prepared for"
 W !,"  a pause."
 K DIR,X,Y S DIR(0)="F^5:5^"
 S DIR("A")="Enter a patient's LAST5: "
 D ^DIR
 Q:X["^"
 I 'X?1A4N D  Q
 . W !,"LAST5 must consist of a letter and 4 numbers"
 . W !," e.g. Z1234"
 N LAST5 S LAST5=X
 W !,"Starting update of graph store for LAST5=",LAST5
 D ONEPT(LAST5)
 I $L($G(REQ(1)))>10 D
 . W !
 . W $P(REQ(1),"^")_" DFN: "_$P(REQ(1),"^",12)_" added to graph store."
 . W !
 E  D
 . W !," ***** UPDATE FAILED *****"
 . W !,"REQ(1) = ",$G(REQ(1))
 K REQ
 Q
 ;
ONEPT(LAST5) ;
 N PORT,IP,ACCVER,FINI
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 Q:$G(IP)=""  Q:$G(PORT)=""
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("HMP UI CONTEXT")
 ;
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="LAST5"
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=LAST5
 S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
 K REQ
 S CALL=$$CALLRPC^XWBM2MC("HMP PATIENT SELECT","REQ",1)
 S NODE=$NA(^KBAP("ALLPTS",$E(REQ(1))))
 M @NODE=REQ
 S CLOSE=$$CLOSE^XWBM2MC
 ;
 ; Make Graph Store patient-lookup global from
 ;  ^KBAP("ALLPTS")
 Q:'$D(^KBAP("ALLPTS"))
 N gien,NODE,PTDATA,root
 s root=$$setroot^%wd("patient-lookup")
 s gien=0
 N NODE S NODE=$NA(^KBAP("ALLPTS"))
 N SNODE S SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . S PTDATA=@NODE
 . S gien=gien+1
 . S @root@(gien,"saminame")=$P(PTDATA,"^",4)
 . S @root@(gien,"sinamef")=$P($P($P(PTDATA,"^",4),",",2)," ")
 . S @root@(gien,"sinamel")=$P($P(PTDATA,"^",4),",")
 . S @root@(gien,"sbdob")=$E($P(PTDATA,"^",10),1,4)_"-"_$E($P(PTDATA,"^",10),5,6)_"-"_$E($P(PTDATA,"^",10),7,8)
 . S @root@(gien,"last5")=$P(PTDATA,"^",9)
 . S @root@(gien,"dfn")=$P(PTDATA,"^",12)
 . S @root@(gien,"gender")=$P($P($P(PTDATA,"pat-gender",2),"^",1,2),":",2)
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
EOR ;KBAPUTL1
