ZTMTZ ;ven/toad-toolkit: test utilities (general) ;2018-04-09T02:31Z
 ;;9.0;TASK MANAGER;;May 22, 2017;
 ;;9.0T02;Task Manager;;2017-05-22;
 ;(c) 2016/2017, Vista Expertise Network, all rights reserved
 ;(l) licensed under VEN Partner License (file license-venpl-1p0.pdf)
 ;($) ven & ehs
 ;
 ; in sync with VA Vista routine XUTMTZ XU*8*0 1995-04-05
 ;;8.0;KERNEL;;Jul 10, 1995
 ; 
 ; This is the main taskman troubleshooting routine, an interactive
 ; direct-mode tool that queues up test tasks for taskman to process.
 ;
 ; primary development
 ;
 ; primary developer: Frederick D. S. Marshall (toad)
 ; primary development organization: Vista Expertise Network (ven)
 ; cofunding organization: Electronic Health Solutions (ehs)
 ;
 ; additional author: R. Wally Fort (rwf)
 ; additional author: Linda M. R. Yaw (lmry)
 ; original development organization: U.S. Department of Veterans
 ;   Affairs, prev. Veterans Administration, National Development
 ;   Office in San Francisco (vaisf)
 ;
 ; 2016-12-08 ven/toad ZTM*9.0D01 ZTMTZ: create from XUTMTZ; in LOAD
 ; add whitespace, fix bug blocking queuing to resources, cut ZTUCI,
 ; bump version to ZTM*9.0D01.
 ;
 ; 2017-01-10 ven/lmry ZTM*9.0T01 ZTMTZ: at DELAY+1 cut eol garbage.
 ;
 ; 2017-03-08 ven/lmry ZTM*9.0T01*1 ZTMTZ: remove locks from LOAD to
 ; fix bug that doesn't allow multiple sets of jobs to be queued if the
 ; previous set is still running.
 ;
 ; 2017-03-27 ven/lmry ZTM*9.0T02 ZTMTZ: in LOAD+6 fix typo from
 ; 2017-03-08 with L instead of K; also remove H 1 on same line at
 ; toad's request.
 ;
 ; 2017-04-26 ven/lmry ZTM*9.0T02 ZTMTZ: stdize hdr lines, bump
 ; version to 9.0T02.
 ;
 ; 2017-05-22 ven/toad ZTM*9.0T02 ZTMTZ: update dates & chg history.
 ;
 ; 2018-03-26 ven/lmry ZTM*9.0T02 ZTMTZ: Make BASIC2 test. Same as BASIC but 
 ; no lock.
 ;
 ; 2018-04-02 ven/lmry ZTM*9.0T02 ZTMTZ: Make BASIC3 test. Same as BASIC but 
 ; different lock.
 ;
 ; 2018-04-08 ven/lmry ZTM*9.0T02 ZTMTZ: Futz with BASIC tests and comments
 ;
 ;
 ;
LOAD ;Load up Queue jobs
 ;
 W !,"This call will allow you to start a large number of tasks for",!,"TaskMan to run."
 ;
 R !,"Enter the number of jobs to start: ",JOBS:DTIME Q:+JOBS'>0
 ;
 K ZTIO W !,"use '^' for no device."
 ;
 S %ZIS="RST" D ^%ZIS S TASKIO=POP
 ;
 S %DT="AETSX",%DT("B")="NOW" D ^%DT Q:Y<1  S XUDTH=Y
 ;
LD2 R !,"Entry point to use: ",RTN:DTIME
 ;
 I RTN["?" D  G LD2
 . F I=3:1 S X=$T(+I) Q:X=""  W:$E($P(X," ",2),1,2)=";;" !,X
 ;
 I $T(@RTN)'[";;" W !,"Not valid" G LD2
 ;
 W !,"=============================================================="
 ;
 W !,"New Batch:  ",$H,"...",$J,!,"Tasks: "
 ;
 F QUASI=1:1:JOBS S ZTRTN=RTN_"^ZTMTZ",ZTDTH=XUDTH,ZTDESC=$T(@RTN)_", Job #"_QUASI S:TASKIO ZTIO="" D ^%ZTLOAD W ZTSK,", "
 ;
 W !,"..............................................................."
 ;
 D HOME^%ZIS
 ;
 quit  ; end of ZTMTZ-LOAD
 ;
 ;
 ;
ERROR ;;Test Taskman's Error Handling
 S ^TMP("ZTMTZ",$H,$J)=ZTSK_", TEST ERROR HANDLING"
 H 1 X "ERROR "
 ;
BASIC ;;Basic Test With Hang
 L +^TMP("ZTMTZ") S ^TMP("ZTMTZ",$H,$J)=ZTSK_", BASIC TEST"_U_ZTDESC
 I IO]"" W "." S IONOFF=1
 H 1 L -^TMP("ZTMTZ") Q
 ;
BASIC2 ;;Basic Test with hang no lock
 S ^TMP("ZTMTZ",$H,$J)=ZTSK_", BASIC TEST2"_U_ZTDESC
 I IO]"" W "." S IONOFF=1
 H 1 Q
 ;
BASIC3 ;;Basic Test with hang using different lock than BASIC
 L +^TMP("ZTMTZ3") S ^TMP("ZTMTZ3",$H,$J)=ZTSK_", BASIC TEST3"_U_ZTDESC
 I IO]"" W "." S IONOFF=1
 H 1 L -^TMP("ZTMTZ3") Q
 ;
QUICK ;;Quick Test To Exercise Submanager
 S FRANK="HONEST" Q
 ;
STOP ;;Test Stop Code
 S ^TMP("ZTMTZ",$H,$J)=ZTSK_", STOP CODE TEST: "
 H 60
 I $$S^%ZTLOAD S ZTSTOP=1,^TMP("ZTMTZ",$H,$J)="Stop Request Acknowledged." Q
 S ^TMP("ZTMTZ",$H,$J)="No Stop Request Detected." Q
 ;
SIZE ;TOOL--SIZE OF ROUTINES
 X ^%ZOSF("RSEL") S ZT1="" F ZT=0:0 S ZT1=$O(^TMP($J,ZT1)) Q:ZT1=""  X "ZL @ZT1 X ^%ZOSF(""SIZE"") W !,ZT1,?10,Y,?15,"" "",$P($P($T(+1),"";"",2),""-"",2,999)"
 K ^TMP($J) Q
 ;
MULTPL ;test task--Test running multiple managers on different nodes of VAXcluster
 L +^TMP("ZTMTZ") H 1
 W !,"..............................................................."
 W !,ZTSK,":  ",$H,"...",$J
 L -^TMP("ZTMTZ") Q
 ;
STOP2 ;;Test ZTSTOP code
 F ZT=1:1:792 S X=$$S^%ZTLOAD Q:X  W 9
 I X S ZTSTOP=1
 Q
 ;
WATCH ;DON'T QUEUE--watch tasks as they are scheduled and unscheduled
 S ZTSK=0
 F ZT=0:0 D LOOKUP W !,"Update: ",ZTU,?15,"Queued: ",ZTS,?30,"Late: ",ZTO,?40,"New: ",ZTN,?50,"Subs: ",ZTSU,?60,"Free Subs: ",ZTF R X:1 Q:X="^"
 Q
 ;
LOOKUP ;WATCH--get data to show
 S ZTH=$H,ZTR=$S($D(^%ZTSCH("RUN"))#2:^("RUN"),1:""),ZTU="off"
 I ZTR S ZTU=ZTH-ZTR*86400+$P(ZTH,",",2)-$P(ZTR,",",2) I ZTU>99 S ZTU="late"
 S ZT1=0,ZTO=0,ZTS=0 F ZT=0:0 S ZT1=$O(^%ZTSCH(ZT1)),ZT2="" Q:'ZT1  F ZT=0:0 S ZT2=$O(^%ZTSCH(ZT1,ZT2)) Q:'ZT2  S ZTS=ZTS+1,ZTH=$H I ZTH-ZT1*86400+$P(ZTH,",",2)-$P(ZT1,",",2)>0 S ZTO=ZTO+1
 S ZTN=^%ZTSK(-1)-ZTSK,ZTSK=^(-1)
 S ZTSU=0,ZT1="" F ZT=0:0 S ZT1=$O(^%ZTSCH("TASK",ZT1)) Q:ZT1=""  S ZTSU=ZTSU+1
 S ZTF=0 I $D(^%ZTSCH("SUB"))#2 S ZTF=^("SUB"),ZTSU=ZTSU+ZTF
 Q
 ;
HANG ;;Wait five minutes then quit
 H 300 Q
 ;
OWN ;;Hold a device until told to release it
 F A=0:0 H 1 I $D(^%ZTSK(ZTSK,.4))#2 Q
 Q
 ;
QOWN ;entry--queue an own task
 S ZTRTN="OWN^ZTMTZ",ZTDTH=$H,ZTIO="",ZTDESC="Toad test 1",ZTSAVE("ZTREQ")="@" D ^%ZTLOAD Q
 ;
Q ;entry--queue a test task
 S ZTRTN="QUICK^ZTMTZ",ZTDTH=$H,ZTIO="",ZTDESC="Toad test",ZTSAVE("ZTREQ")="@" D ^%ZTLOAD Q
 ;
DELAY ;;Record delay in start
 S ZTN=$H,ZTO=$P(^%ZTSK(ZTSK,0),"^",6),Y=$$DIFF^%ZTM(ZTN,ZTO,0)
 S ^TMP("ZTMTZ",ZTN,ZTSK)="DELAY^"_IO_"^"_ZTN_"^"_ZTO_"^"_Y
 I $$S^%ZTLOAD("DELAY TIME IS "_Y)
 Q
 ;
 ;
EOR ; end of routine ZTMTZ
