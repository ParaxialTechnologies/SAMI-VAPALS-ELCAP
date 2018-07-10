KBAPUTL3 ; VEN/ARC - IELCAP: M2M to Graph tools ; 7/4/18 10:45am
 ;;1.0;SAMI;;
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (ARC)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-06-06 VEN/ARC:
 ; Create graph store of providers
 ;
 ;
 Q  ; No entry from top
 ;
 ;
PVDRS() ; Clear the M Web Server files cache
 ;VEN/ARC;test;procedure;dirty;silent;non-sac
 ;
 N PORT,IP,ACCVER,FINI,PCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 Q:$G(IP)=""  Q:$G(PORT)=""
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 ;
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 ;S DIVFLAG=1,DIVISIONS=1
 ;
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 ;S DIVISION=1,XWBDIVG(1)=0
 ;
 S CONTEXT=$$SETCONTX^XWBM2MC("OR CPRS GUI CHART")
 ;S ^TMP("XWBM2M",$J,"CONTEXT")="OR CPRS GUI CHART"
 ;S CONTEXT=1
 ;
 K:($G(CONTEXT)) ^KBAP("PROVIDERS")
 K REQ
PVDRS1 S CALL=$$CALLRPC^XWBM2MC("ORQPT PROVIDERS","",1)
 M ^KBAP("PROVIDERS")=@XWBRL("STORE")
 S CLOSE=$$CLOSE^XWBM2MC
 ;
 N NODE,SNODE,KBAPP,CNT S CNT=0
 S NODE=$NA(^KBAP("PROVIDERS")),SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . I @NODE["CDATA" D  Q
 .. S CNT=CNT+1,KBAPP(CNT)=$P(@NODE,"[CDATA[",2)
 . I @NODE S CNT=CNT+1,KBAPP(CNT)=@NODE
 ;
 d purgegraph^%wd("providers")
 N gien,root
 s root=$$setroot^%wd("providers")
 s gien=0
 N XDUZ,NAME,XDATA
 N NODE S NODE=$NA(KBAPP)
 N SNODE S SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . S PCNT=$G(PCNT)+1
 . S XDATA=@NODE
 . S XDUZ=$P(XDATA,"^")
 . S NAME=$P(XDATA,"^",2)
 . S gien=gien+1
 . S @root@(gien,"duz")=XDUZ
 . S @root@(gien,"name")=NAME
 ;
 Q:$Q PCNT  Q
 ;
EOR ; End of routine KBAPUTL3
