SAMIGRPH ; VEN/ARC - IELCAP: M2M to Graph tools ;2018-06-06T21:33Z
 ;;1.0;SAMI;;
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (ARC)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-06-06 VEN/ARC:
 ; Create graph store of health factors
 ;
 ;
 quit ; No entry from top
 ;
 ;
HealthFactors ; Clear the M Web Server files cache
 ;VEN/ARC;test;procedure;dirty;silent;non-sac
 ;
 N PORT,IP,ACCVER,FINI
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
 K:($G(CONTEXT)) ^KBAP("HEALTH FACTORS")
 K REQ
 S CALL=$$CALLRPC^XWBM2MC("ORWPCE GET HEALTH FACTORS TY","REQ",1)
 S CLOSE=$$CLOSE^XWBM2MC
 ;
 Q:'$D(REQ)
  d purgegraph^%wd("health-factors")
  N gien,NODE,PTDATA,root
  s root=$$setroot^%wd("health-factors")
  s gien=0
  N NODE S NODE=$NA(^KBAP("HEALTH FACTORS"))
  N REQIEN S REQIEN=0
  N IEN,NAME1,NAME2
  ;
  F  S REQIEN=$O(REQ(REQIEN)) Q:'REQIEN  D
  . S IEN=$P(REQ(REQIEN),U)
  . S NAME1=$P(REQ(REQIEN),U,2)
  . S NAME2=$P(REQ(REQIEN),U,3)
  . ;
  . S gien=gien+1
  . S @root@(gien,"hfien")=IEN
  . S @root@(gien,"hfname1")=NAME1
  . S @root@(gien,"hfname2")=NAME2
  Q
 quit
 ;
 ;
EOR ; End of routine SAMIGRPH
