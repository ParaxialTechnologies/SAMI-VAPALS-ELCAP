SAMIUTD2 ;ven/lgc - UNIT TEST for SAMIUTD2 ; 10/29/18 12:03pm
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
UTIN2G ; @TEST - initialize CTEVAL dictionary into graph cteval-dict
 ;init2graph()
 n g,root,poo,arc
 s root=$$setroot^%wd("cteval-dict")
 m poo=@root
 d SaveUTarray^SAMIUTST(.poo,"init2graph-SAMICTD2")
 ; although init2graph kills the root, I need to do
 ;  so before the call so I know it is a new build
 k @root
 s utsuccess=1
 d init2graph^SAMICTD2
 m arc=@root
 k poo d PullUTarr^SAMIUTST(.poo,"init2graph-SAMICTD2")
 n nodea,nodep s nodea=$na(arc),nodep=$na(poo)
 f  s nodea=$Q(@nodea),nodep=$Q(@nodep) q:nodea=""  d  q:'utsuccess
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing initialization of CTEVAL dictionary FAILED!")
 q
 ;
EOR ;End of routine SAMIUTD2
