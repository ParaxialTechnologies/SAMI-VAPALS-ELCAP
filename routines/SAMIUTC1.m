SAMIUTC1 ;ven/lgc - UNIT TEST for SAMICTC1 ; 10/26/18 7:56pm
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
UTCTCPY ; @TEST - copies a Ct Eval form selectively
 ;CTCOPY(FROM,TO)
 ;n arc,poou
 s utsuccess=1
 D PullUTarr^SAMIUTST(.poou,"CTCOPY-SAMICTC1")
 s FROM=$NA(poou),TO=$NA(arc)
 D CTCOPY^SAMICTC1(FROM,TO)
 n nodea,nodep s nodea=$na(arc),nodep=$na(poou)
 f  s nodea=$Q(nodea),nodep=$Q(nodep) q:nodea=""  d
 . i '(nodea=nodep) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing CTCOPY FAILED!")
 q
UTGNCTC ; @TEST - generates the copy routine from a graph
 q
 ;
EOR ;End of routine SAMIUTC1
