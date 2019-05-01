SAMIUTH4 ;ven/lgc - UNIT TEST for SAMIHOM3,SAMIHOM4 continued; 5/1/19 10:25am ; 5/1/19 10:44am
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
 new root set root=$$setroot^%wd("vapals-patients")
 kill @root@("graph","XXX00001")
 new SAMIUPOO do PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 merge @root@("graph","XXX00001")=SAMIUPOO
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 quit
 ;
 ;
UTWSVP1 ; @TEST - Test WSVAPALS API route=""
 new route,SAMIUPOO,cnt,SAMIUARC,SAMIUFLTR,nodea,nodep
 ; testing route="". RESULT should have HTML
 set route="" do WSVAPALS^SAMIHOM3(.SAMIUARG,.SAMIUBODY,.SAMIURSLT)
 merge SAMIUPOO=SAMIURSLT
 K ^KBAP("SAMIUTH3","UTWSVP1","SAMIUPOO")
 M ^KBAP("SAMIUTH3","UTWSVP1","SAMIUPOO")=SAMIUPOO
 ;
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP1^SAMIUTH3")
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
 K ^KBAP("SAMIUTH3","UTWSVP2","SAMIUPOO")
 M ^KBAP("SAMIUTH3","UTWSVP2","SAMIUPOO")=SAMIUPOO
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP2^SAMIUTH3")
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
 K ^KBAP("SAMIUTH3","UTWSVP3","SAMIUPOO")
 M ^KBAP("SAMIUTH3","UTWSVP3","SAMIUPOO")=SAMIUPOO
 ;
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP3^SAMIUTH3")
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
 K ^KBAP("SAMIUTH3","UTWSVP4","SAMIUPOO")
 M ^KBAP("SAMIUTH3","UTWSVP4","SAMIUPOO")=SAMIUPOO
 set utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP4^SAMIUTH3")
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
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSVP5^SAMIUTH3")
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
