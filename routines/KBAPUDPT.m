KBAPUDPT ;ven/lgc - UPDATE PATIENT USING SAM'S BROKER ; 8/15/18 1:23pm
 ;;1.0;;**LOCAL**; AUG 15, 2018;Build 1
 ;
 ;
 ;Get additional patient demographics
 ;Remote Procedure : SCMC PATIENT INFO
 ;D PATIENT^SCMCPAT(.SCMCIFO,737)
 ; 1      2         3   4   5   6     7             8           9
 ;DFN^PATIENT NAME^SSN^DOB^AGE^SEX^MARITAL STATUS^ACTIVE DUTY^ADDRESS
 ; 10        11      12   13    14  15      16       17        18
 ;ADDRESS2^ADDRESS3^CITY^STATE^ZIP^COUNTY^TELEPHONE^SENSITIVE^ICN
PTINFO(DFN) ;
 N SSN
 S SSN=0
 I '$G(DFN) Q:$Q SSN  Q
 N HOST,PORT,AV,SCMCIFO
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S HOST=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(HOST)="") HOST="127.0.0.1"
 I $G(HOST)="" Q:$Q SSN  Q
 I $G(PORT)="" Q:$Q SSN  Q
 S AV=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(AV)="" Q:$Q SSN  Q
 I '($L($G(AV),";")=2) Q:$Q SSN  Q
 ;
 ; Start using Sam's new Broker in KBANSCAU
 ; 1. Open Socket to remote system, check POP, use IO
 D CALL^%ZISTCP(HOST,PORT,5)
 I $G(POP) QUIT
 U IO
 ;
 D CONSOLE^KBANSCAU("")
 ;
 ; 2. Write TCP Connect
 D WRITE^KBANSCAU($$TCPCON^KBANSCAU()),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 ;
 ; 3. Get Intro Message
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS INTRO MSG")),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 ;
 ; 4. Setup for Sign-on (can do CAPRI/auto signon here)
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS SIGNON SETUP")),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 ;
 ; 5. Log-in
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS AV CODE",$$ENCRYP^XUSRB1(AV))),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 ;
 ; 6. Get/Set division (set not shown)
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS DIVISION GET")),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 ;
 ; 7. Create the context
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XWB CREATE CONTEXT",$$ENCRYP^XUSRB1("SCMC PCMMR APP PROXY MENU"))),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 ;
 ; 8. Run RPC (RPC w/ 2 parameters shown)
 N D S D(1)=DFN
 D WRITE^KBANSCAU($$RPC^KBANSCAU("SCMC PATIENT INFO",.D)),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 S ^KBAP("KBANSCAU","X")=$G(X)
 S XDATA=$G(X)
 ;
 ; 9. Run another RPC w/ single parameter (but parameter at endpoint by reference -- rarely used
 ;
 ; 10. Logout
 D WRITE^KBANSCAU($$BYE^KBANSCAU()),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 ; D CONSOLE^KBANSCAU(X)
 ;
 ; 11. Close connection
 S ^KBAP("KBANSCAU",11)=""
 D CLOSE^%ZISTCP
 ;
 ; 12. Clean temporary variables
 D CLEAN^KBANSCAU
 ;
 ;
 ; Update patient-lookup entry for this patient
SCMCIFO N root s root=$$setroot^%wd("patient-lookup")
 N NAME,NODE,gien
 I '(DFN=$P(XDATA,"^",1)) Q:$Q SSN  Q
 N NODE S NODE=$NA(@root@("dfn",DFN))
 S NODE=$Q(@NODE)
 S gien=+$P(NODE,",",5)
 I '$G(gien) Q:$Q SSN  Q
 W !,!,"gien=",$G(gien),!
 S SSN=$P(XDATA,"^",3)
 N DOB S DOB=$$FMTHL7^XLFDT($P(XDATA,"^",4))
 S DOB=$E(DOB,1,4)_"-"_$E(DOB,5,6)_"-"_$E(DOB,7,8)
 I '(DOB=@root@(gien,"sbdob")) Q:$Q SSN  Q
 S @root@(gien,"ssn")=$P(XDATA,"^",3)
 S:+$P(XDATA,"^",3) @root@("ssn",$P(XDATA,"^",3))=gien
 S @root@(gien,"icn")=$P(XDATA,"^",18)
 S:+$P(XDATA,"^",18) @root@("icn",$P(XDATA,"^",18))=gien
 S @root@(gien,"age")=$P(XDATA,"^",5)
 S @root@(gien,"sex")=$P(XDATA,"^",6)
 S @root@(gien,"marital status")=$P(XDATA,"^",7)
 S @root@(gien,"active duty")=$P(XDATA,"^",8)
 S @root@(gien,"address1")=$P(XDATA,"^",9)
 S @root@(gien,"address2")=$P(XDATA,"^",10)
 S @root@(gien,"address3")=$P(XDATA,"^",11)
 S @root@(gien,"city")=$P(XDATA,"^",12)
 S @root@(gien,"state")=$P(XDATA,"^",13)
 S @root@(gien,"zip")=$P(XDATA,"^",14)
 S @root@(gien,"county")=$P(XDATA,"^",15)
 S @root@(gien,"phone")=$P(XDATA,"^",16)
 S @root@(gien,"sensitive patient")=$P(XDATA,"^",17)
 ;
 Q:$Q SSN  Q
 ;
 ;
 ;
EOR ;KBAPUDPT
