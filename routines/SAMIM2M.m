SAMIM2M ;ven/lgc/smh - M2M WITH SAM HABIEL'S KBANSCAU BROKER ; 1/22/19 1:29pm
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
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
 Q  ; Cannot call from top
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
 N X
 K XDATA S XDATA=-1
 S CONSOLE=+$G(CONSOLE)
 S CNTNOPEN=+$G(CNTNOPEN)
 N HOST,PORT,AV
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S HOST=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(HOST)="") HOST="127.0.0.1"
 ; *** NOTE: for UNIT TESTS use local host
 n forxindex s forxindex="%ut"
 S:$D(@forxindex) HOST="127.0.0.1"
 I $G(HOST)="" Q
 I $G(PORT)="" Q
 S AV=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(AV)="" Q
 I '($L($G(AV),";")=2) Q
 ;
 ; Below pulled from XWBTEST^KBANSCAU
 ; 1. Open Socket to remote system, check POP, use IO
 N POP D CALL^%ZISTCP(HOST,PORT,5)
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
 N NIO S NIO=IO,IO=$S($G(IO(0))]"":IO(0),1:$P)
 I NIO]"" C NIO K IO(1,NIO) S IO("CLOSE")=NIO
 D:CONSOLE CONSOLE^KBANSCAU($$NOW^XLFDT)
 ;
 ; 12. Clean temporary variables
 D CLEAN^KBANSCAU
 ;
 Q
 ;
 ;
EOR ;End of routine SAMIM2M
