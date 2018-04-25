ORWORR1 ; SLC/JLI - Utilities for Retrieve Orders for Broker ; 4/25/18 1:14pm
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**141,243**;Dec 17, 1997;Build 242
 ;Called from ORWORR
 ;
 ; CHANGE 20180424 VEN
 ;   Delete &&
GET1 ; 
 S TOT=^TMP("ORR",$J,ORLIST,"TOT") K ^TMP("ORR",$J,ORLIST,"TOT")
 S I=.1 F  S I=$O(^TMP("ORR",$J,ORLIST,I)) Q:'I  S IFN=^(I) D
 .; Old code
 .; I $G(ORRECIP)&&($G(FILTER)=12&&($$FLAGRULE(+IFN))) K ^TMP("ORR",$J,ORLIST,I) S TOT=TOT-1 Q
 .; New code
 . I $G(ORRECIP),$G(FILTER)=12,$$FLAGRULE(+IFN) K ^TMP("ORR",$J,ORLIST,I) S TOT=TOT-1 Q
 .;
 . I ORWTS,(+$P($G(^OR(100,+IFN,0)),U,13)'=ORWTS) K ^TMP("ORR",$J,ORLIST,I) S TOT=TOT-1 Q
 . S PTEVTID=$P($G(^OR(100,+IFN,0)),U,17)
 . S:PTEVTID>0 EVTNAME=$$NAME^OREVNTX(PTEVTID)
 . S ^TMP("ORR",$J,ORLIST,I)=IFN_U_$P($G(^OR(100,+IFN,0)),U,11)_U_$P($G(^(8,+$P(IFN,";",2),0)),U)_U_PTEVTID_U_EVTNAME
 S TXTVW=$S(MULT:0,FILTER=2:2,1:1) D:FILTER=2 ORYD^ORDD100
 S ^TMP("ORR",$J,ORLIST,.1)=TOT_U_TXTVW_U_$G(ORYD,0)
 S REF=$NA(^TMP("ORR",$J,ORLIST))
 Q
GET2 ; For AUTO DC/Event Release Orders
 N JDND,JDIX,JDCNT,DCSPLIT
 S JDCNT=1,DCSPLIT=0
 S TOT=^TMP("ORR",$J,ORLIST,"TOT") K ^TMP("ORR",$J,ORLIST,"TOT")
 F JDND="RL","DC" D
 . S I=.1 F  S I=$O(^TMP("ORR",$J,ORLIST,I)) Q:'I  D
 . . I '$D(^TMP("ORR",$J,ORLIST,I,JDND)) Q
 . . S JDIX=0 F  S JDIX=$O(^TMP("ORR",$J,ORLIST,I,JDND,JDIX)) Q:'JDIX  S IFN=^(JDIX)  D
 . . . I 'DCSPLIT,(JDND="DC") D
 . . . . S ^TMP("ORRJD",$J,JDCNT)="DC START"
 . . . . S DCSPLIT=1,JDCNT=JDCNT+1,TOT=TOT+1
 . . . I ORWTS,(+$P($G(^OR(100,+IFN,0)),U,13)'=ORWTS) S TOT=TOT-1 Q
 . . . S PTEVTID=$P($G(^OR(100,+IFN,0)),U,17)
 . . . S:PTEVTID>0 EVTNAME=$$NAME^OREVNTX(PTEVTID)
 . . . S ^TMP("ORRJD",$J,JDCNT)=IFN_U_$P($G(^OR(100,+IFN,0)),U,11)_U_$P($G(^(8,+$P(IFN,";",2),0)),U)_U_PTEVTID_U_EVTNAME
 . . . S JDCNT=JDCNT+1
 S TXTVW=$S(MULT:0,FILTER=2:2,1:1) D:FILTER=2 ORYD^ORDD100
 S ^TMP("ORRJD",$J,.1)=TOT_U_TXTVW_U_$G(ORYD,0)
 S REF=$NA(^TMP("ORRJD",$J))
 Q
FLAGRULE(ORNUM,USR) ;
 ;returns 0 if we should keep ORNUM in the list
 ;returns 1 if we should remove ORNUM from the list
 ;determines based on whether the user USR should see these flagged orders
 ; based on presence in file 100 NODE 8 FIELD 39 and
 ; based on whether the user should have gotten the flag due to provider recipients
 N ORI,ORRET,ORQUIT,I,LST,ORDFN
 I '$G(USR) S USR=DUZ
 S ORRET=1,ORQUIT=0
 S ORI=0 F  S ORI=$O(^OR(100,ORNUM,8,ORI)) Q:'ORI  D
 .I '$P($G(^OR(100,ORNUM,8,ORI,3)),U,6)&($P($G(^OR(100,ORNUM,8,ORI,3)),U,9)) S LST($P($G(^OR(100,ORNUM,8,ORI,3)),U,9))=""
 S ORDFN=+$P($G(^OR(100,ORNUM,0)),U,2)
 D START^ORBPRCHK(.LST,ORNUM,6,ORDFN)
 ;add ordering provider
 N ORDPROV
 S ORDPROV=$$ORDERER^ORQOR2(ORNUM)
 I $G(ORDPROV) S LST(ORDPROV)=""
 D ADDSURR(.LST)
 I $D(LST(USR)) S ORRET=0
 Q ORRET
ADDSURR(LST) ;TAKE LIST OF USERS AND ADD SURROGATES TO THE LIST
 N I
 S I=0 F  S I=$O(LST(I)) Q:'I  S LST($$CURRSURO^XQALSURO(I))=""
 Q
