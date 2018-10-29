SAMIUTM2 ;ven/lgc/smh - UNIT TEST for KBAPM2M ; 10/22/18 12:31pm
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
 D M2M^KBAPM2M(.XDATA,CNTXT,RMPRC,CONSOLE,CNTNOPEN,.XARRAY)
 D CHKEQ^%ut(XDATA,XARRAY(1),"Testing Complete KBAPM2M call  FAILED!")
 Q
 ;
 ;
EOR ;End of routine SAMIUTM2
