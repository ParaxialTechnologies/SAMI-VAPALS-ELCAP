SAMIUTUR ;ven/lgc - UNIT TEST for SAMIUR ; 10/24/18 10:56pm
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
UTWSRPT ; @TEST - generate a report based on parameters in the filter
 ;wsReport(rtn,filter)
 q
 ;
UTSELCT ; @TEST - selects patient for the report
 ;select(pats,type)
 q
 ;
UTPNAME ; @TEST - extrinsic returns the PAGE NAME for the report
 ;PNAME(type)
 q
 ;
 ;
EOR ;End of routine SAMIUTUR
