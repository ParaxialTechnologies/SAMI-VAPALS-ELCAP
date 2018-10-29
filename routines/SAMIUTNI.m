SAMIUTNI ;ven/lgc - UNIT TEST for SAMINOTI ; 10/24/18 7:51pm
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
UTWSNOTE ; @TEST - web service which returns a text note
 ;wsNote(return,filter)
 q
 ;
UTNOTFLT ; @TEST - extrnisic which creates a note
 ;note(filter)
 q
 ;
UTOUT ; @TEST - Testing out(ln)
 ;out(ln)
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 q
 ;
EOR ;End of routine SAMIUTNI
