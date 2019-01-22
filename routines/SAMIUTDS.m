SAMIUTDS ;ven/lgc - UNIT TEST for SAMIDSSN ; 1/22/19 1:33pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
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
UTSSIN ; @TEST - code for ddi SSNIN^SAMID, input xform for .09 in 311.101
 ;D SSNIN
 q
UTPSEUDO ; @TEST - generate pseudo-ssn
 ;D PSEUDO
 q
UTHASH ; @TEST - ; hash letter to digit
 ;HASH(chr)
 q
UTFNDFR ; @TEST - find next free pseudo-ssn to avoid duplicates
 ;FINDFREE(PSSN)
 q
 ;
EOR ;End of routine SAMIUTDS
