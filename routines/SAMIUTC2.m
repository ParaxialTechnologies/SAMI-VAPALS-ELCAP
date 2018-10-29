SAMIUTC2 ;ven/lgc - UNIT TEST for SAMISRC2 ; 10/24/18 11:00am
 ;;18.0;SAMI;;
 ;
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 ;
STARTUP n utsuccess
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTWSLKU ; @TEST - Test wsLookup API
 N ARG,BODY,RESULT,route,poo,cnt,poou,filter,dfn,studyid
 ; testing route=lookup"". RESULT should have HTML
 ; look up ELCAP patient (patient in vapals-patients
 S ARG("studyid")="XXX00001",ARG("route")="lookup"
 S dfn=1,studyid="XXX00001"
 ; If I set BODY(1) SAMISRC2 looks for case review page
 ;   and finding none, returns 
 ;   filter("samilookuperror")="Patient not found"
 ;S BODY(1)="field=sid&dfn="_dfn_"&fvalue="_studyid
 D wsLookup^SAMISRC2(.ARG,.BODY,.RESULT)
 ;
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTdata^SAMIUTST(.poou,"getHome-SAMIHOM3")
 s cnt=0
 ; *** FAILS at line 165 where there is a date
 ; *** Really fails as there is no case review page
 f  s cnt=$o(RESULT(cnt)) q:'cnt  d
 . I '($g(RESULT(cnt))=$g(poou(cnt))) d  q:'utsuccess
 .. s utsuccess=0
 i '($O(RESULT("A"),-1)=$O(poou("A"),-1)) s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing wsVAPALS route=lookup  FAILED!")
 q
 ;
EOR ;End of routine SAMIUTC2
