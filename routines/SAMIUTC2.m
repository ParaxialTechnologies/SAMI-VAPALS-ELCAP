SAMIUTC2 ;ven/lgc&arc - UNIT TEST for SAMISRC2 ; 20181031T1854Z
 ;;18.0;SAMI;;
 ;
 ;
 START
  if $T(^%ut)="" do
  . write !,"*** UNIT TEST NOT INSTALLED ***"
  . quit
  ;
  do EN^%ut($text(+0),3)
  quit
  ;
  ;
 STARTUP
  new utsuccess
  quit
  ;
  ;
 SETUP
  new args,body,return,expect,result
  quit
  ;
  ;
 TEARDOWN ; ZEXCEPT: args,body,return,expect,result
  kill args,body,return,expect,result
  quit
  ;
  ;
 SHUTDOWN ; ZEXCEPT: utsuccess
  kill utsuccess
  quit
  ;
  ;
UTWSLKU ; @TEST wsLookup^SAMISRC2
 ; Comments
 ;
 set args("dfn")=1
 set args("name")="Fourteen,Patient N"
 set args("pt-lookup-input")="Fourteen,Patient N"
 set args("samiroute")="casereview"
 set args("studyid")="XXX00001"
 set body(1)="samiroute=lookup&dfn=1&name=Fourteen%2CPatient+N&studyid=XXX00001&pt-lookup-input=Fourteen%2CPatient+N"
 
 ; N ARG,BODY,RESULT,route,poo,cnt,poou,filter,dfn,studyid
 ; ; testing route=lookup"". RESULT should have HTML
 ; ; look up ELCAP patient (patient in vapals-patients
 ; S ARG("studyid")="XXX00001",ARG("route")="lookup"
 ; S dfn=1,studyid="XXX00001"
 ; ; If I set BODY(1) SAMISRC2 looks for case review page
 ; ;   and finding none, returns
 ; ;   filter("samilookuperror")="Patient not found"
 ; ;S BODY(1)="field=sid&dfn="_dfn_"&fvalue="_studyid
 ; D wsLookup^SAMISRC2(.ARG,.BODY,.RESULT)
 ; ;
 ; s utsuccess=1
 ; ; Get array saved in "vapals unit tests" for this unit test
 ; D PullUTdata^SAMIUTST(.poou,"getHome-SAMIHOM3")
 ; s cnt=0
 ; ; *** FAILS at line 165 where there is a date
 ; ; *** Really fails as there is no case review page
 ; f  s cnt=$o(RESULT(cnt)) q:'cnt  d
 ; . I '($g(RESULT(cnt))=$g(poou(cnt))) d  q:'utsuccess
 ; .. s utsuccess=0
 ; i '($O(RESULT("A"),-1)=$O(poou("A"),-1)) s utsuccess=0
 ; D CHKEQ^%ut(utsuccess,1,"Testing wsVAPALS route=lookup  FAILED!")
 q
 ;
 ;
EOR ;End of routine SAMIUTC2
