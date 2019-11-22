SAMIUTH4 ;ven/lgc - UNIT TEST for SAMIHOM3,SAMIHOM4 continued; 5/1/19 10:25am ;Oct 22, 2019@15:39
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ;
 ; ===================== UNIT TESTS =====================
 ;
STARTUP new utsuccess
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 quit
 ;
 ;
UTWSVP1 ; @TEST - Test WSVAPALS API route=""
 new route,SAMIUPOO,cnt,SAMIUARC,SAMIUFLTR,nodea,nodep
 ; testing route="". RESULT should have HTML
 set route="" do WSVAPALS^SAMIHOM3(.SAMIUARG,.SAMIUBODY,.SAMIURSLT)
 merge SAMIUPOO=SAMIURSLT
 K ^SAMIUT("SAMIUTH3","UTWSVP1","SAMIUPOO")
 M ^SAMIUT("SAMIUTH3","UTWSVP1","SAMIUPOO")=SAMIUPOO
 ;
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP1^SAMIUTH4")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if (@nodep["meta content") quit
 . if '($qsubscript(nodea,1)=$qsubscript(nodep,1)) set utsuccess=0
 . if '(@nodea=@nodep) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=0  FAILED!")
 quit
 ;
UTWSVP2 ; @TEST - Test WSVAPALS API route="lookup"
 new SAMIUARG,SAMIUBODY,SAMIURSLT,route,SAMIUPOO,SAMIUARC,cnt,SAMIUFLTR
 ; testing route=lookup"". RESULT should have HTML
 ; look up ELCAP patient (patient in vapals-patients
 set SAMIUARG("field")="sid",SAMIUARG("fvalue")="XXX00001"
 Set SAMIUARG("samiroute")="lookup"
 do WSVAPALS^SAMIHOM3(.SAMIUARG,.SAMIUBODY,.SAMIURSLT)
 merge SAMIUPOO=SAMIURSLT
 K ^SAMIUT("SAMIUTH3","UTWSVP2","SAMIUPOO")
 M ^SAMIUT("SAMIUTH3","UTWSVP2","SAMIUPOO")=SAMIUPOO
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP2^SAMIUTH4")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if (@nodep["meta content") quit
 . if '($qsubscript(nodea,1)=$qsubscript(nodep,1)) set utsuccess=0
 . if '(@nodea=@nodep) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=lookup  FAILED!")
 quit
 ;
UTWSVP3 ; @TEST - Test WSVAPALS API route="casereview"
 new SAMIUARG,SAMIUBODY,SAMIURSLT,route,SAMIUPOO,SAMIUARC,SAMIUFLTR
 set SAMIUARG("field")="sid",SAMIUARG("fvalue")="XXX00001"
 set SAMIUARG("samiroute")="casereview"
 do WSVAPALS^SAMIHOM3(.SAMIUARG,.SAMIUBODY,.SAMIURSLT)
 merge SAMIUPOO=SAMIURSLT
 K ^SAMIUT("SAMIUTH3","UTWSVP3","SAMIUPOO")
 M ^SAMIUT("SAMIUTH3","UTWSVP3","SAMIUPOO")=SAMIUPOO
 ;
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP3^SAMIUTH4")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if (@nodep["meta content") quit
 . if (@nodep["XXX") quit
 . if '($qsubscript(nodea,1)=$qsubscript(nodep,1)) set utsuccess=0
 . if '(@nodea=@nodep) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=casereview  FAILED!")
 quit
 ;
UTWSVP4 ; @TEST - Test WSVAPALS API route="addform"
 new SAMIUARG,SAMIUBODY,SAMIURSLT,route,SAMIUPOO,SAMIUARC,SAMIUFLTR
 set SAMIUARG("field")="sid",SAMIUARG("fvalue")="XXX00001"
 set SAMIUARG("samiroute")="addform"
 do WSVAPALS^SAMIHOM3(.SAMIUARG,.SAMIUBODY,.SAMIURSLT)
 merge SAMIUPOO=SAMIURSLT
 K ^SAMIUT("SAMIUTH3","UTWSVP4","SAMIUPOO")
 M ^SAMIUT("SAMIUTH3","UTWSVP4","SAMIUPOO")=SAMIUPOO
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP4^SAMIUTH4")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if (@nodep["meta content") quit
 . if '($qsubscript(nodea,1)=$qsubscript(nodep,1)) set utsuccess=0
 . if '(@nodea=@nodep) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=addform  FAILED!")
 quit
 ;
UTWSVP5 ; @TEST - Test WSVAPALS API route="form"
 new SAMIUARG,SAMIUBODY,SAMIURSLT,route,SAMIUPOO,SAMIUARC,SAMIUFLTR
 set SAMIUARG("field")="sid",SAMIUARG("fvalue")="XXX00001"
 set SAMIUARG("samiroute")="form"
 do WSVAPALS^SAMIHOM3(.SAMIUARG,.SAMIUBODY,.SAMIURSLT)
 merge SAMIUPOO=SAMIURSLT
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP5^SAMIUTH4")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if (@nodep["meta content") quit
 . if '($qsubscript(nodea,1)=$qsubscript(nodep,1)) set utsuccess=0
 . if '(@nodea=@nodep) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=form  FAILED!")
 quit
 ;
 ;
 ;
EOR ;End of routine SAMIUTH4
