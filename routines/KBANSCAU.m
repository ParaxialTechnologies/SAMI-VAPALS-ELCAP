KBANSCAU ; SIC/SMH - RPC Broker in M;2018-08-29  3:16 PM ; 10/15/18 12:21pm
 ;;0.1;SAM'S INDUSTRIAL CONGLOMERATES;
 ; (c) VistA Expertise Network 2018
 ;
 ; Supplied under the Apache 2.0 License
 ;
 ; # SECTION BROKER #
 ;
CONST ; Constants (wish mumps had a way to say constant)
 S XWBVER=1 ; XWB Version Number 1.1
 S XWBTYPE=1 ; ditto
 S XWBLENV=3 ; L pack envolope size
 S XWBRT=0 ; New Return format; Not used
 QUIT
 ;
BUFF ; Buffers
 S KBANSBUF=""
 QUIT
 ;
CLEAN ; Clean variables
 K XWBVER,XWBTYPE,XWBLENV,XWBRT
 K KBANSBUF
 QUIT
 ;
HEADER() ; $$ ; Make the [XWB]1130 part
 D CONST ; Loop back and put the variables in the ST.
 D BUFF  ; Initilize Buffers
 Q "[XWB]"_XWBVER_XWBTYPE_XWBLENV_XWBRT
 ;
TCPCON(IP,PORT) ; $$ ; Make the TCPConnect header
 I '$L($G(IP)) S IP="127.0.0.1"
 I '$G(PORT) S PORT=0
 N Y D GETENV^%ZOSV
 N CLNAME S CLNAME=$P(Y,U,3) ; Host name
 N PAYLOAD S PAYLOAD(1)=IP,PAYLOAD(2)=PORT,PAYLOAD(3)=CLNAME
 N CONCMD S CONCMD=4_$$SPACK("TCPConnect") ; Command - Message
 N HEADER S HEADER=$$HEADER
 N PAYCMD S PAYCMD=$$DATA(.PAYLOAD)
 Q HEADER_CONCMD_PAYCMD_$$EOT()
 ;
BYE() ; $$ ; #BYE#
 Q $$HEADER()_4_$$SPACK("#BYE#")_$$EOT()
 ;
RPC(RPCNAME,DATA,BYREF) ; $$ ; Construct RPC message
 Q $$HEADER()_2_$$SPACK(0)_$$SPACK(RPCNAME)_$$DATA(.DATA,$G(BYREF))_$$EOT()
 ;
SPACK(STR) ; $$ ; S-Pack a string (ABC becomes $C(3)_ABC)
 I $L(STR)>255 S $ECODE=",U-STRING-TOO-LONG,"
 Q $C($L(STR))_STR
 ;
LPACK(STR) ; $$ ; L-Pack a string (ABC becomes 003ABC)
 I $L(STR)>(10**XWBLENV-1) S $ECODE=",U-STRING-TOO-LONG,"
 Q $TR($J($L(STR),XWBLENV)," ",0)_STR
 ;
DATA(REF,BYREF) ; $$ ; Data; pass REF by ref.
 N RTN S RTN="5"
 ;
 I '$D(REF) Q RTN_"4f" ; Empty data
 ;
 I $D(REF)#2 D  Q RTN ; Literal?
 . I $E(REF)=U S RTN=RTN_$$GDATA(REF) ; Serealize Global
 . E  I $L(REF),'$G(BYREF) S RTN=RTN_0_$$LPACK(REF)_"f" ; Searlize Literal
 . E  I $L(REF),$G(BYREF)  S RTN=RTN_1_$$LPACK(REF)_"f" ; Searlize Literal by Reference (rarely used)
 . E  S RTN=RTN_"4f" ; Empty
 ;
 I +$O(REF("")) D  Q RTN ; Bunches of literals subscipted by 1,2,3 etc
 . N I S I="" F  S I=$O(REF(I)) Q:'I  D
 . . I $E(REF(I))=U S RTN=RTN_$$GDATA(REF(I))
 . . E  I $E(REF(I))="@" S RTN=RTN_$$RDATA($P(REF(I),"@",2))
 . . E  S RTN=RTN_0_$$LPACK(REF(I))_"f"
 ;
 I $L($O(REF(""))) D  Q RTN ; Array
 . S RTN=RTN_$$RDATA("REF")
 ;
 ; Shouldn't hit this.
 S $ECODE=",U-INVALID-REFERENCE,"
 QUIT
 ;
RDATA(MYLOC) ; $$ [Private] ; Reference Data; Pass MYLOC by NAME
 N RTN S RTN=2
 N Q S Q="""" ; Quote to quote reference values
 N I S I="" F  S MYLOC=$Q(@MYLOC) Q:MYLOC=""  D
 . N SUBAF S SUBAF=$P(MYLOC,"(",2,99)
 . N SUB S SUB=$E(SUBAF,1,$L(SUBAF)-1)
 . S RTN=RTN_$$LPACK(SUB)_$$LPACK(@MYLOC)_"t"
 S $E(RTN,$L(RTN))="f"
 QUIT RTN
 ;
GDATA(MYGLO) ; $$ [Private] ; Global Data; pass MYGLO by name
 ; Invokers: DATA (v.s.)
 N RTN S RTN=3
 N Q S Q="""" ; Quote
 N I S I="" F  S I=$O(@MYGLO@(I)) Q:I=""  S RTN=RTN_$$LPACK(Q_I_Q)_$$LPACK(@MYGLO@(I))_"t"
 S $E(RTN,$L(RTN))="f"
 Q RTN
 ;
EOT() Q $C(4) ; End of Transmission
 ;
 ;
 ;
 ;
WRITE(STR) ;Buffer a data string
 N MAX S MAX=32766 ; Max string on Cache
 F  Q:'$L(STR)  D
 . I $L(KBANSBUF)+$L(STR)>MAX D WBF
 . S KBANSBUF=KBANSBUF_$E(STR,1,MAX),STR=$E(STR,MAX+1,99999)
 Q
WBF ;Write to TCP connection
 Q:'$L(KBANSBUF)
 W KBANSBUF,! ; (NB: ! has no effect on GT.M as GT.M sends the stuff to the Linux kernel immediately)
 S KBANSBUF=""
 Q
 ;
READ() ; Read data from TCP connection until EOT ($C(4))
 N X,Y,C ; X is return buffer; Y is single read buffer; C is counter
 S X="",C=0
 F  D  Q:($E(X,$L(X))=$C(4))  ; I C>1000 S $EC=",U-INCOMPLETE-READ,"
 . R Y
 . S X=X_Y
 . ; I  U $P WRITE "TRUE",! U IO S X=X_Y
 . ; E  U $P WRITE "FALSE",! U IO S C=C+1
 S X=$P(X,$C(4)) ; Remove EOT
 N SEC S SEC=$$SEC(X) ; Extract error packet
 I $L(SEC) Q SEC
 E  Q $P(X,$C(0,0),2,999)
 ;
SEC(X) ; $$ ; S-Read Security and Application errors sections
 N SEC,APP S (SEC,APP)=""
 N SLEN S SLEN=$A(X)
 I SLEN S SEC=$E(X,2,SLEN+1)
 N ALEN S ALEN=$A(X,SLEN+2)
 I ALEN S APP=$E(X,SLEN+3,ALEN+SLEN+3)
 I $L(SEC)!$L(APP) Q SEC_U_APP
 E  Q ""
 ;
 ;
CONSOLE(OUT) ; Write reply X to Console
 U 0
 N X S X=0 X ^%ZOSF("RM")
 W OUT,!
 U IO
 QUIT
 ;
 ;
TEST N IO S IO=$P D DT^DICRW D EN^XTMUNIT($T(+0),1) QUIT
STARTUP S XWBLENV=3 QUIT
SHUTDOWN K XWBLENV QUIT
TSPACK ; @TEST - Test S-Pack
 D CHKEQ^XTMUNIT($$SPACK("ABC"),$C(3)_"ABC")
 QUIT
TLPACK ; @TEST - Test L-Pack
 D CHKEQ^XTMUNIT($$LPACK("ABC"),"003ABC")
 QUIT
TDATA1 ; @TEST - Test Data - Literal
 D CHKEQ^XTMUNIT($$DATA("ABC"),"50003ABCf")
 QUIT
TDATA2 ; @TEST - Test Data - Bunches of literals
 N SAM S SAM(1)="ABC",SAM(2)="DEF"
 D CHKEQ^XTMUNIT($$DATA(.SAM),"50003ABCf0003DEFf")
 QUIT
TDATA3 ; @TEST - Test Data - Global
 K ^TMP($J) S ^TMP($J,1)="ABC",^TMP($J,2)="DEF"
 D CHKEQ^XTMUNIT($$DATA($NA(^TMP($J))),"53003""1""003ABCt003""2""003DEFf")
 K ^TMP($J)
 QUIT
TDATA4 ; @TEST - Test Data - List
 N SAM S SAM("PARAM1")="ABC",SAM("PARAM2")="DEF"
 D CHKEQ^XTMUNIT($$DATA(.SAM),"52008""PARAM1""003ABCt008""PARAM2""003DEFf")
 QUIT
TDATA5 ; @TEST - Test Data - Empty
 D CHKEQ^XTMUNIT($$DATA(),"54f")
 D CHKEQ^XTMUNIT($$DATA(""),"54f")
 QUIT
TTCPCON ; @TEST - Test TCPConnect
 D CHKTF^XTMUNIT($$TCPCON()[(4_$C(10)_"TCPConnect50009127.0.0.1"))
 QUIT
TBYE ; @TEST - Test #BYE#
 D CHKTF^XTMUNIT($$BYE()[4_$C(5)_"#BYE#")
 QUIT
TRPC ; @TEST - Test RPC constructor
 D CHKEQ^XTMUNIT($$RPC("XWB GET VARIABLE VALUE","$HOROLOG"),"[XWB]11302"_$C(1)_"0"_$C(22)_"XWB GET VARIABLE VALUE50008$HOROLOGf"_$C(4))
 QUIT
TSEC ; @TEST - Test Security and Application Error read
 D CHKEQ^XTMUNIT($$SEC($C(0,0)),"")
 D CHKEQ^XTMUNIT($$SEC($C(5)_"ABCDE"_$C(0)),"ABCDE^")
 D CHKEQ^XTMUNIT($$SEC($C(0,5)_"ABCDE"),"^ABCDE")
 D CHKEQ^XTMUNIT($$SEC($C(4)_"ABCD"_$C(5)_"ABCDE"),"ABCD^ABCDE")
 QUIT
 ;
TMUL ; @TEST Mix globals and locals together
 ;
 ; Literals
 N D
 S D(1)=1 ; DFN
 ;
 ; Global Parameter
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,1202)=DUZ
 S ^TMP("POO",$J,1301)=3180816.144239
 S ^TMP("POO",$J,1205)=1
 S ^TMP("POO",$J,1701)=""
 S D(2)=$NA(^TMP("POO",$J))
 ;
 ; Reference Parameter
 S SAM(1)="ABC"
 S SAM(2)="DEF"
 S SAM(3)=999
 S SAM(4,"TEXT",1)="LINE 1"
 S SAM(4,"TEXT",2)="LINE 2"
 S D(3)="@SAM"
 ;
 W $$DATA(.D)
 QUIT
 ;
XWBTEST ; @TEST XWB Broker Full Example
 ;
 ; CHANGE 20181015 VEN/lgc
 ;  Modified HOST,PORT, and AV for VA-PALS project
 N START S START=$ZUT
 N HOST,PORT,AV
 ;Original code
 ;S HOST="192.168.1.181"
 ;New code
 S HOST=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(HOST)="") HOST="127.0.0.1"
 ;Original code
 ;S PORT=9022
 ;New code
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S:'$G(PORT) PORT="9430"
 ;Original code
 ;S AV="SM1234;CATDOG.33"
 ;New code
 S AV=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 ;
 ; 1. Open Socket to remote system, check POP, use IO
 D CALL^%ZISTCP(HOST,PORT,5)
 I $G(POP) QUIT
 U IO
 ;
 D CONSOLE("")
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 2. Write TCP Connect
 D WRITE($$TCPCON^KBANSCAU()),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 3. Get Intro Message
 D WRITE($$RPC^KBANSCAU("XUS INTRO MSG")),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 4. Setup for Sign-on (can do CAPRI/auto signon here)
 D WRITE($$RPC^KBANSCAU("XUS SIGNON SETUP")),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 5. Log-in
 D WRITE($$RPC^KBANSCAU("XUS AV CODE",$$ENCRYP^XUSRB1(AV))),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 6. Get/Set division (set not shown)
 D WRITE($$RPC^KBANSCAU("XUS DIVISION GET")),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 7. Create the context
 D WRITE($$RPC^KBANSCAU("XWB CREATE CONTEXT",$$ENCRYP^XUSRB1("OR CPRS GUI CHART"))),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 8. Run RPC (RPC w/ 2 parameters shown)
 N D S D(1)="S",D(2)=-1 D WRITE($$RPC^KBANSCAU("ORWU NEWPERS",.D)),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 9. Run another RPC w/ single parameter (but parameter at endpoint by reference -- rarely used)
 D WRITE($$RPC^KBANSCAU("XWB GET VARIABLE VALUE","DUZ",1)),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 9.5. TIU RPC
 N D 
 S D(1)=1 ; DFN
 S D(2)=8 ; ADVANCE DIRECTIVE
 S D(3)=$$NOW^XLFDT
 S D(4)=""
 S D(5)=""
 N POO
 S POO(1202)=DUZ
 S POO(1301)=$$NOW^XLFDT
 S POO(1205)=1
 S POO(1701)=""
 S POO("TEXT",1,0)="LINE 1"
 S POO("TEXT",2,0)="LINE 2"
 S POO("TEXT",3,0)="LINE 3"
 S D(6)="@POO"
 D WRITE($$RPC^KBANSCAU("TIU CREATE RECORD",.D)),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 10. Logout
 D WRITE($$BYE^KBANSCAU()),WBF
 S X=$$READ() D CONSOLE(X)
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 11. Close connection
 D CLOSE^%ZISTCP
 D CONSOLE($$NOW^XLFDT)
 ;
 ; 12. Clean temporary variables
 D CLEAN^KBANSCAU
 ;
 ; 13. End
 N END S END=$ZUT
 ;
 W !!,END-START,!
 QUIT
