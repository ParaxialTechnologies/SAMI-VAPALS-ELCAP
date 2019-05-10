SAMIUTAD ;ven/lgc - Unit test for SAMIADMN ; 5/10/19 9:45am
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: see routine SAMIUL
 ;
 ; @last-updated: 2019-03-12T21:04Z
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ;
STARTUP new utsuccess
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 quit
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 do ^SAMIADMN
 do SUCCEED^%ut
 quit
 ;
UTCLRW ; @TEST - Test Clear the M WebServer
 ; will delete seeGraph and html-cache Graphstores
 ;  then rebuild the seeGraph
 new root,poo,arc set root=$$setroot^%wd("seeGraph")
 do purgegraph^%wd("seeGraph")
 do CLRWEB^SAMIADMN
 ; save the seeGraph file just built
 new poo merge poo=@root
 ; run the Clear the M Webserver again
 do CLRWEB^SAMIADMN
 ; Compare rebuilt seeGraph to be sure it generates
 ;   the same data each time
 kill arc merge arc=@root
 set utsuccess=1
 new nodea,nodep set nodea=$name(arc),nodep=$name(poo)
 for  set nodea=$Q(@nodea),nodep=$Q(@nodep) quit:nodea=""  do  quit:'utsuccess
 . if '(@nodea=@nodep) set utsuccess=0
 if '(nodep="") set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing Clear M WebServer FAILED!")
 quit
 ;
UTSLCP ; @TEST - Test set VA-PALS to use the ELCAP version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 new GLB,gien set GLB=$name(^SAMI(311.11))
 set gien=$order(@GLB@("B","vapals:ceform",""))
 if gien="" do  quit
 . do FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 new ien set ien=$order(^SAMI(311.11,"B","vapals:ceform",""))
 new setting set setting=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 ; set to LungRads
 set $piece(^SAMI(311.11,ien,2),"^",2)="ctevaluation.html"
 do SETELCAP^SAMIADMN()
 new poo set poo=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 set utsuccess=(poo="ctevaluation-elcap.html")
 ; Return to original state
 set $piece(^SAMI(311.11,ien,2),"^",2)=setting
 do CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use ELCAP FAILED!")
 quit
UTSLRADS ; @TEST - Test set VA-PALS to use the LungRads version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 new GLB,gien set GLB=$NA(^SAMI(311.11))
 set gien=$order(@GLB@("B","vapals:ceform",""))
 if gien="" do  quit
 . do FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 new ien set ien=$order(^SAMI(311.11,"B","vapals:ceform",""))
 new setting set setting=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 ; set to ELCAP
 set $piece(^SAMI(311.11,ien,2),"^",2)="ctevaluation-elcap.html"
 do SETLGRDS^SAMIADMN()
 new poo set poo=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 set utsuccess=(poo="ctevaluation.html")
 ; Return to original state
 set $piece(^SAMI(311.11,ien,2),"^",2)=setting
 do CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use LungRads FAILED!")
 quit
UTWSLCP ; @TEST - set VA-PALS to use the ELCAP version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 new GLB,gien set GLB=$name(^SAMI(311.11))
 set gien=$order(@GLB@("B","vapals:ceform",""))
 if gien="" do  quit
 . do FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 new ien set ien=$order(^SAMI(311.11,"B","vapals:ceform",""))
 new setting set setting=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 ; set to LungRads
 set $piece(^SAMI(311.11,ien,2),"^",2)="ctevaluation.html"
 new arc do WSSTELCP^SAMIADMN(.arc,"")
 new poo set poo=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 set utsuccess=(poo="ctevaluation-elcap.html")
 ; Return to original state
 set $piece(^SAMI(311.11,ien,2),"^",2)=setting
 do CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use ELCAP FAILED!")
 quit
UTWSLRAD ; @TEST -  set VA-PALS to use the LungRads version of the Ct Evaluation form
 ; if set to LungRads poosfm will be "ctevaluation.html"
 ; if set to ELCAP poosfm will be "ctevaluation-elcap.html"
 new GLB,gien set GLB=$name(^SAMI(311.11))
 set gien=$order(@GLB@("B","vapals:ceform",""))
 if gien="" do  quit
 . do FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 new ien set ien=$order(^SAMI(311.11,"B","vapals:ceform",""))
 new setting set setting=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 ; set to ELCAP
 set $piece(^SAMI(311.11,ien,2),"^",2)="ctevaluation-elcap.html"
 new arc do WSSTLRAD^SAMIADMN(.arc,"")
 new poo set poo=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 set utsuccess=(poo="ctevaluation.html")
 ; Return to original state
 set $piece(^SAMI(311.11,ien,2),"^",2)=setting
 do CHKEQ^%ut(utsuccess,1,"Testing setting VAPALS to use LungRads FAILED!")
 quit
UTWSCTV ; @TEST - web service to return the current ctform version
 ; Look up entry in 311.11 manually and compare to results of call
 new GLB,gien set GLB=$name(^SAMI(311.11))
 set gien=$order(@GLB@("B","vapals:ceform",""))
 if gien="" do  quit
 . do FAIL^%ut("Error, record vapals:ceform is not found in SAMI FORM MAPPING file!")
 new ien set ien=$order(^SAMI(311.11,"B","vapals:ceform",""))
 new poosfm set poosfm=$piece($get(^SAMI(311.11,ien,2)),"^",2)
 set utsuccess=0
 new arcsfm do WSCTVERS^SAMIADMN(.arcsfm,"")
 if poosfm="ctevaluation.html",arcsfm["lungrads" set utsuccess=1
 if poosfm="ctevaluation-elcap.html",arcsfm["elcap" set utsuccess=1
 do CHKEQ^%ut(utsuccess,1,"Testing web service return current ctform version FAILED!")
 quit
 ;
UTWSUHF ; @TEST - updating the WEB SERVICE URL HANDLER file
 new root s root=$na(^%web(17.6001))
 new SAMIMETH,SAMIPAT,SAMIRTN
 set SAMIMETH="GET",SAMIPAT="unit test"
 set SAMIRTN="TESTING^SAMIUTST"
 ;check existence of unit test entry
 new webien s webien=$order(@root@("B",SAMIMETH,SAMIPAT,SAMIRTN,0))
 if $g(webien) do WDEL^SAMIADMN(SAMIMETH,SAMIPAT)
 set webien=$order(@root@("B",SAMIMETH,SAMIPAT,SAMIRTN,0))
 if $g(webien) do
 . do FAIL^%ut("Error. Unit test entry not deleted!")
 do WINIT^SAMIADMN(SAMIMETH,SAMIPAT,SAMIRTN)
 set webien=$order(@root@("B",SAMIMETH,SAMIPAT,SAMIRTN,0))
 set utsuccess=($get(webien)>0)
 do CHKEQ^%ut(utsuccess,1,"Testing adding web service FAILED!")
 ;
 if $g(webien) do
 . do WDEL^SAMIADMN(SAMIMETH,SAMIPAT)
 . set webien=$order(@root@("B",SAMIMETH,SAMIPAT,SAMIRTN,0))
 . set utsuccess=(+$get(webien)=0)
 do CHKEQ^%ut(utsuccess,1,"Testing deleting web service FAILED!")
 quit
 ;
UTWINITA ; @TEST - building all production web services
 do WINITA^SAMIADMN
 set utsuccess=($get(^TMP("SAMIADMN","WINITA"))=0)
 do CHKEQ^%ut(utsuccess,1,"Testing building all services FAILED!")
 quit
 ;
EOR ;End of routine SAMIUTAD
