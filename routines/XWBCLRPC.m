XWBCLRPC ; SIC/SMH - RPC Broker in M;2018-08-29  3:16 PM ; 2/2/19 2:38pm
 ;;0.1;SAM'S INDUSTRIAL CONGLOMERATES;
 ; (c) VistA Expertise Network 2018
 ;
 ;Previously KBANSCAU
 ;
 ;@license: see routine SAMIUL
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
EOF ;End of routine XWBCLRPC
