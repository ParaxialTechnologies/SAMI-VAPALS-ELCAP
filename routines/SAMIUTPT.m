SAMIUTPT ;ven/lgc - UNIT TEST for SAMIPTLK ; 10/24/18 10:51pm
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
UTWSPTLK ; @TEST - patient lookup
 ;wsPtLookup(rtn,filter)
 q
 ;
UTWSPTL1 ; @TEST - patient lookup from patient-lookup cache
 ;wsPtLkup(rtn,filter)
 q
 ;
UTBLDRTN ; @TEST - build the return json
 ;buildrtn(rtn,ary)
 q
 ;
 ;
EOR ;End of routine SAMIUTPT
