KBAPM2M ;ven/lgc/smh - M2M WITH SAM HABIEL'S KBANSCAU BROKER ; 9/28/18 2:27pm
 ;;1.0;;**LOCAL**; SEPT 11, 2018
 ;
 ;SAM'S INDUSTRIAL CONGLOMERATES
 ;
 ; Provide standardized entrance into KBANSCAU
 ;  M2M broker for VA-PALS
 ;
 ;
 ;@routine-credits
 ;@primary development organization: Vista Expertise Network
 ;@primary-dev: Larry G. Carlson (lgc)
 ;@primary development organization: SAM'S INDUSTRIAL CONGLOMERATES
 ;@primary-dev: Sam Habiel (smh)
 ;@copyright:
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-09-26
 ;@application: VA-PALS
 ;@version: 1.0
 ;
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 ; Enter
 ;   XDATA     = variable by reference for results
 ;   CNTXT     = Broker Context Menu
 ;   RMPRC     = Remote Procedure
 ;   CONSOLE   = Display steps to console toggle
 ;               0 [default] = no, 1 = yes
 ;   CNTNOPEN  = Leave connection open toggle
 ;               0 [default] = no, 1 = yes
 ;   XARRAY    = Array by reference of data for RPC call
 ; Exit
 ;   XDATA     = results of broker call (-1 call failed)
 ;               with error message e.g. -1^error message
M2M(XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY) ;
 ;
 K XDATA S XDATA=-1
 S CONSOLE=+$G(CONSOLE)
 S CNTNOPEN=+$G(CNTNOPEN)
 N HOST,PORT,AV
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S HOST=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(HOST)="") HOST="127.0.0.1"
 ; *** NOTE: for UNIT TESTS use local host
 S:$D(%ut) HOST="127.0.0.1"
 I $G(HOST)="" Q
 I $G(PORT)="" Q
 S AV=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(AV)="" Q
 I '($L($G(AV),";")=2) Q
 ;
 ; Below pulled from XWBTEST^KBANSCAU
 ; 1. Open Socket to remote system, check POP, use IO
 D CALL^%ZISTCP(HOST,PORT,5)
 I $G(POP) QUIT
 U IO
 ;
 D:CONSOLE CONSOLE^KBANSCAU("")
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 2. Write TCP Connect
 D WRITE^KBANSCAU($$TCPCON^KBANSCAU()),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 D:CONSOLE CONSOLE^KBANSCAU(X)
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 3. Get Intro Message
 ;    Note: Don't need intro message /Sam Habiel
 ; D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS INTRO MSG")),WBF^KBANSCAU
 ; S X=$$READ^KBANSCAU()
 ; D:CONSOLE CONSOLE^KBANSCAU(X)
 ; D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 4. Setup for Sign-on (can do CAPRI/auto signon here)
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS SIGNON SETUP")),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 D:CONSOLE CONSOLE^KBANSCAU(X)
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 5. Log-in
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS AV CODE",$$ENCRYP^XUSRB1(AV))),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 D:CONSOLE CONSOLE^KBANSCAU(X)
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 6. Get/Set division (set not shown)
 ;    Note: Don't really need to set division /Sam Habiel
 ; D WRITE^KBANSCAU($$RPC^KBANSCAU("XUS DIVISION GET")),WBF^KBANSCAU
 ; S X=$$READ^KBANSCAU()
 ; D:CONSOLE CONSOLE^KBANSCAU(X)
 ; D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 7. Create the context
 D WRITE^KBANSCAU($$RPC^KBANSCAU("XWB CREATE CONTEXT",$$ENCRYP^XUSRB1(CNTXT))),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 D:CONSOLE CONSOLE^KBANSCAU(X)
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 8. Run RPC using data in XARRAY
 D WRITE^KBANSCAU($$RPC^KBANSCAU(RMPRC,.XARRAY)),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 D:CONSOLE CONSOLE^KBANSCAU(X)
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 M XDATA=X
 ;
 I CNTNOPEN Q
 ;
 ; Close connection and clean temporary variables
CLSCLN ; 10. Logout
 D WRITE^KBANSCAU($$BYE^KBANSCAU()),WBF^KBANSCAU
 S X=$$READ^KBANSCAU()
 D:CONSOLE CONSOLE^KBANSCAU(X)
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 11. Close connection
 ;
 ; We do not call CLOSE^%ZISTCP b/c it calls HOME^%ZIS which issues
 ; a new line to slave devices. GTM makes 0 the principal device for
 ; background jobs by default./Sam Habiel
 S NIO=IO,IO=$S($G(IO(0))]"":IO(0),1:$P)
 I NIO]"" C NIO K IO(1,NIO) S IO("CLOSE")=NIO
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 12. Clean temporary variables
 D CLEAN^KBANSCAU
 ;
 Q
 ;
 ; ============== UNIT TESTS ======================
 ; NOTE: Unit tests will pull data using the local
 ;       client VistA files rather than risk degrading
 ;       large datasets in use.  NEVERTHELESS, it is
 ;       recommended that UNIT TESTS be run when
 ;       VA-PALS is not in use as some Graphstore globals
 ;       are temporarily moved while testing is running.
 ;
STARTUP N PORT,HOST,AV,KBAPFAIL
 S KBAPFAIL=0
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S HOST=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(HOST)="") HOST="127.0.0.1"
 S AV=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I ('$G(PORT))!('($L($G(AV),";")=2)) D  G SHUTDOWN
 . D FAIL^%ut("SAMI PARAMETERS MUST BE SET UP FOR UNIT TESTING")
 Q
 ;
SHUTDOWN ; ZEXCEPT: PORT,HOST,AV,KBAPFAIL - defined in STARTUP
 K PORT,HOST,AV,KBAPFAIL
 Q
 ;
TESTM2M ; @TEST - Test full M2M call
 N CNTXT,RMPRC,CONSOLE,CNTNOPEN,XARRAY,XDATA
 S CNTXT="XWB BROKER EXAMPLE"
 S RMPRC="XWB EXAMPLE ECHO STRING"
 S (CONSOLE,CNTNOPEN)=0
 S XARRAY(1)="ABC12345DEF"
 D M2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 D CHKEQ^%ut(XDATA,XARRAY(1),"Testing Complete KBAPM2M call  FAILED!")
 Q
 ;
 ;
EOR ;End of routine KBAPM2M
