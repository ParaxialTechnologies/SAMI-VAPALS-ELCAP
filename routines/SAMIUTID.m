SAMIUTID ;ven/lgc - UNIT TEST for SAMIID ; 1/22/19 1:34pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
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
UTSSNIN ; @TEST - ddi SSNIN^SAMID, input xform for .09 in 311.101
 ;SSNIN(X,SAMIUPDATE) goto SSNIN^SAMIDSSN
 q
UTALL ; @TEST - @ppi ALL^SAMID, export all sami dds
 ;ALL(SAMILOG) goto ALL^SAMIDOUT
 q
UTONE ; @TEST - @ppi ONE^SAMID, export sami dd
 ;ONE(SAMIDD,SAMIPKG,SAMILOG) goto ONE^SAMIDOUT
 q
 ;
EOR ;End of routine SAMIUTID
