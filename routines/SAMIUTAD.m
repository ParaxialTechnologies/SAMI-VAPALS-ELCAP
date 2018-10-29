SAMIUTAD ;ven/lgc - UNIT TEST for SAMIADMN ; 10/29/18 11:29am
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
UTCLRW ; @TEST - Test Clear the M WebServer
 ; will delete seeGraph and html-cache Graphstores
 ;  then rebuild the seeGraph
 n root,poo,arc s root=$$setroot^%wd("seeGraph")
 n poo m poo=@root
 d SaveUTarray^SAMIUTST(.poo,"ClrWeb-SAMIADMN")
 d purgegraph^%wd("seeGraph")
 D ClrWeb^SAMIADMN
 ; Compare rebuilt seeGraph with data saved
 k arc m arc=@root
 k poo d PullUTarr^SAMIUTST(.poo,"ClrWeb-SAMIADMN")
 s utsuccess=1
 n nodea,nodep s nodea=$na(arc),nodep=$na(poo)
 f  s nodea=$Q(@nodea),nodep=$Q(@nodep) q:nodea=""  d  q:'utsuccess
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing Clear M WebServer FAILED!")
 q
 ;
UTSLCP ; @TEST - Test set VA-PALS to use the ELCAP version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 n glb,gien S GLB=$NA(^SAMI(311.11))
 S gien=$O(@GLB@("B","vapals:ceform",""))
 i gien="" d  q
 . D FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 n ien s ien=$o(^SAMI(311.11,"B","vapals:ceform",""))
 n setting s setting=$p($g(^SAMI(311.11,ien,2)),"^",2)
 ; set to LungRads
 s $p(^SAMI(311.11,ien,2),"^",2)="ctevaluation.html"
 d SETELCAP^SAMIADMN()
 n poo s poo=$p($g(^SAMI(311.11,ien,2)),"^",2)
 s utsuccess=(poo="ctevaluation-elcap.html")
 ; Return to original state
 s $p(^SAMI(311.11,ien,2),"^",2)=setting
 D CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use ELCAP FAILED!")
 q
UTSLRADS ; @TEST - Test set VA-PALS to use the LungRads version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 n glb,gien S GLB=$NA(^SAMI(311.11))
 S gien=$O(@GLB@("B","vapals:ceform",""))
 i gien="" d  q
 . D FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 n ien s ien=$o(^SAMI(311.11,"B","vapals:ceform",""))
 n setting s setting=$p($g(^SAMI(311.11,ien,2)),"^",2)
 ; set to ELCAP
 s $p(^SAMI(311.11,ien,2),"^",2)="ctevaluation-elcap.html"
 d SETLUNGRADS^SAMIADMN()
 n poo s poo=$p($g(^SAMI(311.11,ien,2)),"^",2)
 s utsuccess=(poo="ctevaluation.html")
 ; Return to original state
 s $p(^SAMI(311.11,ien,2),"^",2)=setting
 D CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use LungRads FAILED!")
 q
UTWSLCP ; @TEST - set VA-PALS to use the ELCAP version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 n glb,gien S GLB=$NA(^SAMI(311.11))
 S gien=$O(@GLB@("B","vapals:ceform",""))
 i gien="" d  q
 . D FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 n ien s ien=$o(^SAMI(311.11,"B","vapals:ceform",""))
 n setting s setting=$p($g(^SAMI(311.11,ien,2)),"^",2)
 ; set to LungRads
 s $p(^SAMI(311.11,ien,2),"^",2)="ctevaluation.html"
 n arc d wsSETELCAP^SAMIADMN(.arc,"")
 n poo s poo=$p($g(^SAMI(311.11,ien,2)),"^",2)
 s utsuccess=(poo="ctevaluation-elcap.html")
 ; Return to original state
 s $p(^SAMI(311.11,ien,2),"^",2)=setting
 D CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use ELCAP FAILED!")
 q
UTWSLRAD ; @TEST -  set VA-PALS to use the LungRads version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 n glb,gien S GLB=$NA(^SAMI(311.11))
 S gien=$O(@GLB@("B","vapals:ceform",""))
 i gien="" d  q
 . D FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 n ien s ien=$o(^SAMI(311.11,"B","vapals:ceform",""))
 n setting s setting=$p($g(^SAMI(311.11,ien,2)),"^",2)
 ; set to ELCAP
 s $p(^SAMI(311.11,ien,2),"^",2)="ctevaluation-elcap.html"
 n arc d wsSETLRADS^SAMIADMN(.arc,"")
 n poo s poo=$p($g(^SAMI(311.11,ien,2)),"^",2)
 s utsuccess=(poo="ctevaluation.html")
 ; Return to original state
 s $p(^SAMI(311.11,ien,2),"^",2)=setting
 D CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use LungRads FAILED!")
 q
UTWSCTV ; @TEST - web service to return the current ctform version
 ; Look up entry in 311.11 manually and compare to results of call
 n glb,gien S GLB=$NA(^SAMI(311.11))
 S gien=$O(@GLB@("B","vapals:ceform",""))
 i gien="" d  q
 . D FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 n ien s ien=$o(^SAMI(311.11,"B","vapals:ceform",""))
 n poosfm s poosfm=$p($g(^SAMI(311.11,ien,2)),"^",2)
 s utsuccess=0
 n arcsfm D wsctversion^SAMIADMN(.arcsfm,"")
 i poosfm="ctevaluation.html",arcsfm["lungrads" s utsuccess=1
 i poosfm="ctevaluation-elcap.html",arcsfm["elcap" s utsuccess=1
 D CHKEQ^%ut(utsuccess,1,"Testing web service return current ctform version FAILED!")
 q
 ;
EOR ;End of routine SAMIUTAD
