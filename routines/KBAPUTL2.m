KBAPUTL2 ; VEN/ARC - IELCAP: M2M to Graph tools ; 7/4/18 10:43am
 ;;1.0;SAMI;;
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (ARC)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-06-06 VEN/ARC:
 ; Create graph store of reminders
 ;
 ;
 Q  ; No entry from top
 ;
 ;
RMDRS() ; Clear the M Web Server files cache
 ;VEN/ARC;test;procedure;dirty;silent;non-sac
 ;
 N PORT,IP,ACCVER,FINI,RCNT,RESULT,XDATA
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 Q:$G(IP)=""  Q:$G(PORT)=""
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 Q:$G(ACCVER)=""  Q:'($L($G(ACCVER),";")=2)
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I,CLOSE
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 Q:'($G(CONNECT)=1)
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("OR CPRS GUI CHART")
 K:($G(CONTEXT)) ^KBAP("REMINDERS")
 N REQ
 S CALL=$$CALLRPC^XWBM2MC("PXRM REMINDERS AND CATEGORIES","REQ",1)
 S CLOSE=$$CLOSE^XWBM2MC
 ;
 M ^KBAP("REMINDERS")=REQ
 Q:'$D(REQ)
 d purgegraph^%wd("reminders")
 N gien,NODE,PTDATA,root
 s root=$$setroot^%wd("reminders")
 s gien=0
 Q:'$D(REQ)
 N IEN,NAME,PRNTNAME,TYPE
 N NODE S NODE=$NA(^KBAP("REMINDERS"))
 N SNODE S SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . S RCNT=$G(RCNT)+1
 . S XDATA=@NODE
 . S TYPE=$P(XDATA,U)
 . S IEN=$P(XDATA,U,2)
 . S NAME=$P(XDATA,U,3)
 . S PRNTNAME=$P(XDATA,U,4)
 . ;
 . S gien=gien+1
 . S @root@(gien,"type")=TYPE
 . S @root@(gien,"ien")=IEN
 . S @root@(gien,"name")=NAME
 . S @root@(gien,"printname")=PRNTNAME
 ;
 Q:$Q RCNT  Q
 ;
 ;
EOR ; End of routine KBAPUTL2
