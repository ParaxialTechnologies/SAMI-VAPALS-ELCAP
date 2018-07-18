KBAPUTL4 ; VEN/ARC - IELCAP: M2M to Graph tools ; 7/6/18 9:32am
 ;;1.0;SAMI;;
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (ARC)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-06-06 VEN/ARC:
 ; Create graph store of clinics
 ;
 ;
 Q  ; No entry from top
 ;
 ;
CLINICS() ; Clear the M Web Server files cache
 ;VEN/ARC;test;procedure;dirty;silent;non-sac
 ;
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 Q:$G(IP)=""  Q:$G(PORT)=""
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("OR CPRS GUI CHART")
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=" "
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="1"
 S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
CL1 S CALL=$$CALLRPC^XWBM2MC("ORWU1 NEWLOC","REQ",1)
 K POO M POO=@XWBRL("STORE")
 S CLOSE=$$CLOSE^XWBM2MC
 ;
 d purgegraph^%wd("clinics")
 N gien,root
 s root=$$setroot^%wd("clinics")
 s gien=0
 N NODE S NODE=$NA(POO)
 N SNODE S SNODE=$P(NODE,")")
CL2 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . I @NODE["[CDATA[",$P(@NODE,"[CDATA[",2) D
 .. S @NODE=$P(@NODE,"[CDATA[",2)
 . Q:'@NODE
 . S CCNT=$G(CCNT)+1
 . S gien=gien+1
 . S @root@(gien,"clinic ien")=+$P(@NODE,"^")
 . S @root@(gien,"clinic name")=$P(@NODE,"^",2)
 ;
 Q:$Q $G(CCNT)  Q
 ;
 ;
EOR ; End of routine KBAPUTL4
