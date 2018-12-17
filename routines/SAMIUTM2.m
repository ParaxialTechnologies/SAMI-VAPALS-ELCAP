SAMIUTM2 ;ven/lgc/smh - UNIT TEST for SAMIM2M ; 12/17/18 9:39am
 ;;18.0;SAM;;
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
STARTUP N utsuccess,port,host,av
 s port=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 s host=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 s:($g(host)="") host="127.0.0.1"
 s av=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 i ('$g(port))!('($l($G(av),";")=2)) d  g SHUTDOWN
 . D FAIL^%ut("SAMI PARAMETERS MUST BE SET UP FOR UNIT TESTING")
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess,port,host,av - defined in STARTUP
 k utsuccess,port,host,av
 q
 ;
TESTM2M ; @TEST - Test full M2M call
 n cntxt,rmprc,console,cntnopen,SAMIDATA,SAMIARR
 s cntxt="XWB BROKER EXAMPLE"
 s rmprc="XWB EXAMPLE ECHO STRING"
 s (console,cntnopen)=0
 s SAMIARR(1)="ABC12345DEF"
 d M2M^SAMIM2M(.SAMIDATA,cntxt,rmprc,console,cntnopen,.SAMIARR)
 D CHKEQ^%ut(SAMIDATA,SAMIARR(1),"Testing Complete SAMIM2M call  FAILED!")
 Q
 ;
 ;
EOR ;End of routine SAMIUTM2
