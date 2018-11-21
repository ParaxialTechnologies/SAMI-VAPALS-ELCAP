KBAPUTLR ; VEN/ARC - IELCAP: M2M to Graph tools ; 7/20/18 3:44pm
 ;;1.0;SAMI;;
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (ARC)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-06-06 VEN/ARC:
 ; Create graph store globals for
 ;   Radiology Procedures       --- RAPROCS
 ;   Radiology Active Exas      --- RAACTXM
 ;   Radiology STAFF            --- RASTAFF
 ;   Radiology RESIDENTS        --- RARSDTS
 ;   Radiology TECHS            --- RATECHS
 ;   Radiology Modifiers        --- RAMODFS
 ;   Radiology diagnostic codes --- RADXCDS
 ;
 ;VEN/ARC;test;procedure;dirty;silent;non-sac
 ;
 Q  ; No entry from top
 ;
 ;
 ; Rebuild Radiology Graph Store globals
RAALL W !,"Radiology Procedures:",$$RAPROCS(6100)
 W !,"Radiology Active Exams:",$$RAACTXM
 W !,"Radiology STAFF:",$$RASTAFF
 W !,"Radiology RESIDENTS:",$$RARSDTS
 W !,"Radiology TECHS:",$$RATECHS
 W !,"Radiology diagnostic codes:",$$RADXCDS
 W !
 Q
 ;
 ; Radiology Procedures
RAPROCS(STNNMBR) ;
 I '$L($G(STNNMBR)) Q:$Q 0 Q
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 I $G(IP)="" Q:$Q 0 Q
 I $G(PORT)="" Q:$Q 0 Q
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(ACCVER)="" Q:$Q 0 Q
 I '($L($G(ACCVER),";")=2) Q:$Q 0 Q
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 I '($G(CONNECT)=1) Q:$Q 0 Q
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("MAG DICOM VISA")
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")=STNNMBR
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="1"
 S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
 N REQ,RESULT
RAPROC1 S CALL=$$CALLRPC^XWBM2MC("MAGV GET RADIOLOGY PROCEDURES","REQ",1)
 S CLOSE=$$CLOSE^XWBM2MC
 ;
 n si s si=$$CLRGRGBL("radiology procedures")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology procedures")
 N CNT S CNT=0
 F  S CNT=$O(REQ(CNT)) Q:'CNT  D
 .  Q:("<>{}[]"[$E(REQ(CNT)))
 . S gien=gien+1
 . S @root@(gien,"name")=$P(REQ(CNT),"^")
 . S @root@(gien,"ien71")=$P(REQ(CNT),"^",2)
 . S @root@(gien,"CPT")=$P(REQ(CNT),"^",4)
 . S:$L($P(REQ(CNT),"^")) @root@("name",$P(REQ(CNT),"^"))=gien
 . S:$L($P(REQ(CNT),"^",4)) @root@("CPT",$P(REQ(CNT),"^",4),$P(REQ(CNT),"^"))=gien
 ;
 Q:$Q $G(gien)  Q
 ;
 ;
 ; Gather all active radiology exams
RAACTXM() ;
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 I $G(IP)="" Q:$Q 0 Q
 I $G(PORT)="" Q:$Q 0 Q
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(ACCVER)="" Q:$Q 0 Q
 I '($L($G(ACCVER),";")=2) Q:$Q 0 Q
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 I '($G(CONNECT)=1) Q:$Q 0 Q
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("MAG DICOM VISA")
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="ALL^ALL"
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 N REQ,RESULT
RAACT1 S CALL=$$CALLRPC^XWBM2MC("MAGJ RADACTIVEEXAMS","REQ",1)
 S CLOSE=$$CLOSE^XWBM2MC
 ;
RAACT2 n si s si=$$CLRGRGBL("radiology active exams")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology active exams")
 ; *** need to run on active system to see how
 ;     to build file
 Q:$Q $G(gien)  Q
 ;
 ;
 ; Radiology STAFF
RASTAFF() ;
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 I $G(IP)="" Q:$Q 0 Q
 I $G(PORT)="" Q:$Q 0 Q
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(ACCVER)="" Q:$Q 0 Q
 I '($L($G(ACCVER),";")=2) Q:$Q 0 Q
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 I '($G(CONNECT)=1) Q:$Q 0 Q
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("MAG DICOM VISA")
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="S" ; Staff
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="" ; All names
 S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
 N REQ,RESULT
RASTAF1 S CALL=$$CALLRPC^XWBM2MC("MAG DICOM GET RAD PERSON","REQ",1)
 N POO M POO=^TMP("XWBM2MVLC",$J,"XML")
RASTAF2 S CLOSE=$$CLOSE^XWBM2MC
 ;
 d purgegraph^%wd("radiology staff")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology staff")
 N CNT S CNT=0
 F  S CNT=$O(POO(CNT)) Q:'CNT  D
 .  Q:'POO(CNT)
 . S gien=gien+1
 . S @root@(gien,"duz")=$P(POO(CNT),"^")
 . S @root@(gien,"name")=$P(POO(CNT),"^",2)
 . S:$L($P(POO(CNT),"^",2)) @root@("name",$P(POO(CNT),"^",2))=gien
 ;
 Q:$Q $G(gien)  Q
 ;
 ;
 ; Radiology RESIDENTS
RARSDTS() ;
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 I $G(IP)="" Q:$Q 0 Q
 I $G(PORT)="" Q:$Q 0 Q
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(ACCVER)="" Q:$Q 0 Q
 I '($L($G(ACCVER),";")=2) Q:$Q 0 Q
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 I '($G(CONNECT)=1) Q:$Q 0 Q
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("MAG DICOM VISA")
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="R" ; Staff
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="" ; All names
 S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
 N REQ,RESULT
RARSDT1 S CALL=$$CALLRPC^XWBM2MC("MAG DICOM GET RAD PERSON","REQ",1)
 N POO M POO=^TMP("XWBM2MVLC",$J,"XML")
RARSDT2 S CLOSE=$$CLOSE^XWBM2MC
 ;
 n si s si=$$CLRGRGBL("radiology residents")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology residents")
 N CNT S CNT=0
 F  S CNT=$O(POO(CNT)) Q:'CNT  D
 .  Q:'POO(CNT)
 . S gien=gien+1
 . S @root@(gien,"duz")=$P(POO(CNT),"^")
 . S @root@(gien,"name")=$P(POO(CNT),"^",2)
 . S:$L($P(POO(CNT),"^",2)) @root@("name",$P(POO(CNT),"^",2))=gien
 ;
 Q:$Q $G(gien)  Q
 ;
 ;
 ; Radiology Techs
RATECHS() ;
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 I $G(IP)="" Q:$Q 0 Q
 I $G(PORT)="" Q:$Q 0 Q
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(ACCVER)="" Q:$Q 0 Q
 I '($L($G(ACCVER),";")=2) Q:$Q 0 Q
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 I '($G(CONNECT)=1) Q:$Q 0 Q
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("MAG DICOM VISA")
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="T" ; Staff
 S X=$$PARAM^XWBM2MC(1,$NA(^TMP("POO",$J)))
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="" ; All names
 S X=$$PARAM^XWBM2MC(2,$NA(^TMP("POO",$J)))
 N REQ,RESULT
RATEC1 S CALL=$$CALLRPC^XWBM2MC("MAG DICOM GET RAD PERSON","REQ",1)
 N POO M POO=^TMP("XWBM2MVLC",$J,"XML")
RATEC2 S CLOSE=$$CLOSE^XWBM2MC
 ;
 n si s si=$$CLRGRGBL("radiology technologists")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology technologists")
 N CNT S CNT=0
 F  S CNT=$O(POO(CNT)) Q:'CNT  D
 .  Q:'POO(CNT)
 . S gien=gien+1
 . S @root@(gien,"duz")=$P(POO(CNT),"^")
 . S @root@(gien,"name")=$P(POO(CNT),"^",2)
 . S:$L($P(POO(CNT),"^",2)) @root@("name",$P(POO(CNT),"^",2))=gien
 ;
 Q:$Q $G(gien)  Q
 ;
 ;
 ; Radiology Modifiers
RAMODFS() ;
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 I $G(IP)="" Q:$Q 0 Q
 I $G(PORT)="" Q:$Q 0 Q
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(ACCVER)="" Q:$Q 0 Q
 I '($L($G(ACCVER),";")=2) Q:$Q 0 Q
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 I '($G(CONNECT)=1) Q:$Q 0 Q
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("MAG DICOM VISA")
 K ^TMP("POO",$J)
 N REQ,RESULT
RAMOD1 S CALL=$$CALLRPC^XWBM2MC("MAG DICOM RADIOLOGY MODIFIERS","REQ",1)
 N POO M POO=^TMP("XWBM2MVLC",$J,"XML")
RAMOD2 S CLOSE=$$CLOSE^XWBM2MC
 ;
 n si s si=$$CLRGRGBL("radiology modifiers")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology modifiers")
 N CNT S CNT=0
 F  S CNT=$O(POO(CNT)) Q:'CNT  D
 . Q:(POO(CNT)["<")
 . S gien=gien+1
 . S @root@(gien,"name")=$P(POO(CNT),"^")
 . S @root@(gien,"ien")=$P(POO(CNT),"^",2)
 . S @root@(gien,"type of imaging")=$P(POO(CNT),"^",2)
 ;
 Q:$Q $G(gien)  Q
 ;
 ;
 ; Radiology Diagnostic Codes
RADXCDS() ;
 N PORT,IP,ACCVER,FINI,CCNT
 S PORT=$$GET^XPAR("SYS","SAMI PORT",,"Q")
 S IP=$$GET^XPAR("SYS","SAMI IP ADDRESS",,"Q")
 S:($G(IP)="") IP="127.0.0.1"
 I $G(IP)="" Q:$Q 0 Q
 I $G(PORT)="" Q:$Q 0 Q
 S ACCVER=$$GET^XPAR("SYS","SAMI ACCVER",,"Q")
 I $G(ACCVER)="" Q:$Q 0 Q
 I '($L($G(ACCVER),";")=2) Q:$Q 0 Q
 N CONNECT,DIVFLAG,XWBDIVS,DIVISION,CONTEXT,X,I
 S CONNECT=$$CONNECT^XWBM2MC(PORT,IP,ACCVER)
 I '($G(CONNECT)=1) Q:$Q 0 Q
 S DIVFLAG=$$GETDIV^XWBM2MC("DIVISIONS")
 S XWBDIVS=0,DIVISION=$$SETDIV^XWBM2MC(XWBDIVS)
 S CONTEXT=$$SETCONTX^XWBM2MC("MAG DICOM VISA")
 K ^TMP("POO",$J)
 S ^TMP("POO",$J,"TYPE")="STRING"
 S ^TMP("POO",$J,"VALUE")="" ; All names
 N REQ,RESULT
RADXC1 S CALL=$$CALLRPC^XWBM2MC("MAG DICOM GET RAD DX CODE","REQ",1)
 N POO M POO=^TMP("XWBM2MVLC",$J,"XML")
RADXC2 S CLOSE=$$CLOSE^XWBM2MC
 ;
 n si s si=$$CLRGRGBL("radiology diagnostic codes")
 N gien,root s gien=0
 s root=$$setroot^%wd("radiology diagnostic codes")
 N CNT S CNT=0
 F  S CNT=$O(POO(CNT)) Q:'CNT  D
 . Q:'($L(POO(CNT),"^")=2)
 . S gien=gien+1
 . S @root@(gien,"ien")=$P(POO(CNT),"^")
 . S @root@(gien,"name")=$P(POO(CNT),"^",2)
 ;
 Q:$Q $G(gien)  Q
 ;
 ; Clear a Graphstore global of data
CLRGRGBL(name) ;
 q:'$l($g(name))
 n si s si=$O(^%wd(17.040801,"B",name,0))
 i $g(si) K ^%wd(17.040801,si) s ^%wd(17.040801,si,0)=name
 e  d purgegraph^%wd(name)
 Q $g(si)
 ;
EOR ; End of routine KBAPUTLR
