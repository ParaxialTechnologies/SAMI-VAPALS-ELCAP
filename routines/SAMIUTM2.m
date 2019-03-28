SAMIUTM2 ;ven/lgc/smh - UNIT TEST for SAMIM2M ; 2019-03-28T20:00Z
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
 ;@additional-dev: Linda M. R. Yaw (lmry)
 ;@primary development organization: SAM'S INDUSTRIAL CONGLOMERATES
 ;@primary-dev: Sam Habiel (smh)
 ;@copyright:
 ;@license: see routine SAMIUL
 ;
 ;@last-updated: 2019-03-28T20:00Z
 ;@application: VA-PALS
 ;@version: 1.0
 ;
 ;
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ; ============== UNIT TESTS ======================
 ; NOTE: Unit tests will pull data using the local
 ;       client VistA files rather than risk degrading
 ;       large datasets in use.  NEVERTHELESS, it is
 ;       recommended that UNIT TESTS be run when
 ;       VA-PALS is not in use as some Graphstore globals
 ;       are temporarily moved while testing is running.
 ;
STARTUP new utsuccess,port,host,av
 set port=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 set host=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 set:($get(host)="") host="127.0.0.1"
 set av=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 if ('$get(port))!('($length($get(av),";")=2)) do  goto SHUTDOWN
 . do FAIL^%ut("SAMI PARAMETERS MUST BE SET UP FOR UNIT TESTING")
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess,port,host,av - defined in STARTUP
 kill utsuccess,port,host,av
 quit
 ;
TESTM2M ; @TEST - Test full M2M call
 new SAMICNTXT,SAMIRMPR,SAMICSOL,SAMIOPEN,SAMIDATA,SAMIARR
 set SAMICNTXT="XWB BROKER EXAMPLE"
 set SAMIRMPR="XWB EXAMPLE ECHO STRING"
 set (SAMICSOL,SAMIOPEN)=0
 set SAMIARR(1)="ABC12345DEF"
 do M2M^SAMIM2M(.SAMIDATA,SAMICNTXT,SAMIRMPR,SAMICSOL,SAMIOPEN,.SAMIARR)
 do CHKEQ^%ut(SAMIDATA,SAMIARR(1),"Testing Complete SAMIM2M call  FAILED!")
 quit
 ;
 ;
EOR ;End of routine SAMIUTM2
