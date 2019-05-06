DINIT21 ;ven/toad - init mumps os file ; 2019-05-06T19:48Z
 ;;22.2;VA FileMan;;Jan 05, 2016
 ;
 ;@license: see routine SAMIUL
 ;
 ; Routine DINIT21 initializes Fileman file Mumps Operating System
 ; (.7).
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2019, toad, all rights reserved
 ;
 ;@original-dev: George F. Timson (gft)
 ;@additional-dev: Samuel M. Habiel (smh)
 ;
 ;@last-updated: 2019-05-06T19:48Z
 ;@application: File Manager
 ;@module: FM Initialization - DINIT
 ;@version: 22.2
 ;@release-date: 2016-01-05
 ;@patch-list: **2001**
 ;
 ;@module-log:
 ;
 ; 2013-03-08 gft/gft DI*22.2*0 DINIT21: unknown change to routine.
 ;
 ; 2012-11-28 ven/smh DI*22.2*0 DINIT21: variable DINITOSX used in
 ; routine DINIT6; todo: see if we can move that logic here.
 ;
 ; 2016-01-05 va/??? DI*22.2*0 DINIT21: update ZS and DEL values for
 ; entry 19, GT.M(UNIX), to use new ROUDEL^DINVGUX & ROUSAV^DINVGUX;
 ; refactor for clarity; annotate; add DATA label to aid in
 ; refactoring.
 ;
 ;@contents
 ; DINITOSX: confirm update to mumps os file
 ; DD: install data in mumps os file
 ; DATA: $text-table of data to install in mumps os file
 ;
 ;
 ;
 ;@section 1 initialize file Mumps Operating System (.7)
 ;
 ;
 ;
DINITOSX ; confirm update to mumps os file
 ;
 ;@DINIT21-called-by: OSETC^DINIT
 ;@falls-thru-from: DINIT21
 ;@branches-from: DINITOSX
 ;@called-by: none
 ;@falls-thru-to: DD
 ;@branches-to:
 ; DD
 ; DINITOSX
 ;@input/output: prompts current device
 ;
 goto DD:'$order(^DD("OS",0)) ; mandatory update if no file header
 goto DD:'$data(^DD("OS",19,"RM")) ; or if no fm 22.2 RM node
 ; RM node introduced in 22.2; must re-install file if not there
 ;
 write !!,"Do you want to change the MUMPS OPERATING SYSTEM File? "
 write "NO//" ; default to no change
 read Y:60
 else  quit  ; timeout
 quit:Y["^"  ; ^-escape
 quit:"Nn"[$extract(Y)  ; if do not want to fhange file, done here
 ;
 if "Yy"'[$extract(Y) do  goto DINITOSX ; advise & re-ask if bad input
 . write !,"Answer YES to overwrite MAXIMUM ROUTINE SIZE"
 . quit
 ;
DD ; install data in mumps os file
 ;
 ;@falls-thru-from: DINIT21-DINITOSX
 ;@branches-from: DINIT21-DINITOSX
 ;@called-by: NOASK^DINIT
 ;@input-$text: DATA
 ;@output: file Mumps Operating System
 ;
 ; variable DINITOSX used in routine DINIT6
 ; TODO: see if we can move that logic here. VEN/SMH 2012-11-28
 ;
 set DINITOSX=1
 for I=1:1 do  quit:X?.P
 . set X=$text(DATA+I)
 . set Y=$piece(X," ",3,99)
 . quit:X?.P
 . set D="^DD(""OS"","_$extract($piece(X," ",2),3,99)_")"
 . set @D=Y
 . quit
 ;
 quit  ; end of DINIT21-DINITOSX-DD
 ;
 ;
 ;
DATA ; $text-table of data to install in mumps os file
 ;;0 MUMPS OPERATING SYSTEM^.7
 ;;8,0 MSM^^127^5000^^1^63
 ;;8,1 B X
 ;;8,8 X ^DD("$O")
 ;;8,18 I $D(^ (X))
 ;;8,"DEL" X "ZR  ZS @X" K ^UTILITY("%RD",X)
 ;;8,"EOFF" U $I:(::::1)
 ;;8,"EON" U $I:(:::::1)
 ;;8,"LOAD" S %N=0 X "ZL @X F XCNP=XCNP+1:1 S %N=%N+1,%=$T(+%N) Q:$L(%)=0  S @(DIF_XCNP_"",0)"")=%"
 ;;8,"NO-TYPE-AHEAD" U $I:(::::100663296)
 ;;8,"RM" U:IOT["TRM" $I:X
 ;;8,"RSEL" K ^UTILITY($J) G ^%RSEL
 ;;8,"SDP" O @("DIO:"_DLP) F %=0:0 U DIO R % Q:$ZA=X&($ZB>Y)!($ZA>X)  U IO W:$A(%)'=12 ! W %
 ;;8,"SDPEND" S X=$ZA,Y=$ZB
 ;;8,"TRMOFF" U $I:(::::::::$C(13,27))
 ;;8,"TRMON" U $I:(::::::::$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))
 ;;8,"TRMRD" S Y=$ZB
 ;;8,"TYPE-AHEAD" U $I:(::::67108864:33554432)
 ;;8,"UCICHECK" S Y=$$UCICHECK^DINVMSM(X)
 ;;8,"XY" S $X=IOX,$Y=IOY
 ;;8,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
 ;;9,0 DTM-PC^^127^5000^^1^115
 ;;9,1 B X
 ;;9,8 D:$P($ZVER,"/",2)<4 ^%VARLOG X:$P($ZVER,"/",2)'<4 ^DD("$O")
 ;;9,18 I $ZRSTATUS(X)'=""
 ;;9,"SDP" O @("DIO:"_"(""R"":"_$P(DLP,":",2,9)) F %=0:0 U DIO R % Q:$ZIOS=3  U IO W:$A(%)'=12 ! W %
 ;;9,"SDPEND" Q
 ;;9,"XY" S $X=IOX,$Y=IOY
 ;;9,"ZS" S %X="" X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  S %X=%X_$C(10)_^(%Y)" ZS @X:$E(%X,2,999999)
 ;;16,0 DSM for OpenVMS^^108^5000^^1^63
 ;;16,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
 ;;16,8 D DOLRO^%ZOSV
 ;;16,18 I $T(^@X)]""
 ;;16,"SDP" O DIO U DIO:DISCONNECT F %=0:0 U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
 ;;16,"SDPEND" W !,"#$#",! C IO
 ;;16,"XY" S $X=IOX,$Y=IOY
 ;;16,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
 ;;17,0 GT.M(VAX)^^250^15000^^1^250
 ;;17,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
 ;;17,8 X ^DD("$O") ;D DOLRO^%ZOSV
 ;;17,18 I $L($T(^@X))
 ;;17,"DEL" D DEL^DINVGTM(X)
 ;;17,"EOFF" U $I:(NOECHO)
 ;;17,"EON" U $I:(ECHO)
 ;;17,"LOAD" N %,%N S %N=0 F XCNP=XCNP+1:1 S %N=%N+1,%=$T(+%N^@X) Q:$L(%)=0  S @(DIF_XCNP_",0)")=%
 ;;17,"NO-TYPE-AHEAD" U $I:(NOTYPEAHEAD)
 ;;17,"RM" U $I:(WIDTH=$S(X<256:X,1:0):FILTER="ESCAPE")
 ;;17,"RSEL" N %ZR,X K ^UTILITY($J) D ^%RSEL S X="" X "F  S X=$O(%ZR(X)) Q:X=""""  S ^UTILITY($J,X)="""""
 ;;17,"SDP" O DIO F  U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
 ;;17,"SDPEND" W !,"#$#",! C IO
 ;;17,"TRMOFF" U $I:(TERMINATOR="")
 ;;17,"TRMON" U $I:(TERMINATOR=$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))
 ;;17,"TRMRD" S Y=$A($ZB)
 ;;17,"TYPE-AHEAD" U $I:(TYPEAHEAD)
 ;;17,"UCICHECK" S Y=1
 ;;17,"XY" S $X=IOX,$Y=IOY
 ;;17,"ZS" N %,%I,%F,%S S %I=$I,%F=$P($ZRO,",")_X_".m" O %F:(NEWVERSION) U %F X "S %S=0 F  S %S=$O(^UTILITY($J,0,%S)) Q:%S=""""  Q:'$D(^(%S))  S %=^UTILITY($J,0,%S) I $E(%)'="";"" W %,!" C %F U %I
 ;;18,0 CACHE/OpenM^^250^20000^^1^250
 ;;18,1 B X
 ;;18,8 X ^DD("$O")
 ;;18,18 I $T(^@X)]""
 ;;18,"DEL" X "ZR  ZS @X"
 ;;18,"EOFF" U $I:("":"+S")
 ;;18,"EON" U $I:("":"-S")
 ;;18,"HIGHESTCHAR" N DIUTF8 S DIUTF8=$L($C(256))>0 S Y=$C($S(DIUTF8:65533,1:255))
 ;;18,"LOAD" N %,%N S %N=0 X "ZL @X F XCNP=XCNP+1:1 S %N=%N+1,%=$T(+%N) Q:$L(%)=0  S @(DIF_XCNP_"",0)"")=%"
 ;;18,"NO-TYPE-AHEAD" U $I:("":"+F":$C(13,27))
 ;;18,"RM" I $G(IOT)["TRM" U $I:X
 ;;18,"RSEL" K ^UTILITY($J) D KERNEL^%RSET K %ST
 ;;18,"SDP" C DIO O DIO F %=0:0 U DIO R % Q:%="#$#"  U IO W %
 ;;18,"SDPEND" W !,"#$#",! C IO
 ;;18,"TRMOFF" U $I:("":"-I-T":$C(13,27))
 ;;18,"TRMON" U $I:("":"+I+T")
 ;;18,"TRMRD" S Y=$A($ZB),Y=$S(Y<32:Y,Y=127:Y,1:0)
 ;;18,"TYPE-AHEAD" U $I:("":"-F":$C(13,27))
 ;;18,"UCICHECK" X "N % S %=$P(X,"","",1),Y=0 I ##CLASS(%SYS.Namespace).Exists(%) S Y=%"
 ;;18,"XY" S $Y=IOY,$X=IOX
 ;;18,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
 ;;19,0 GT.M(UNIX)^^250^15000^^1^250
 ;;19,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
 ;;19,8 X ^DD("$O") ;D DOLRO^%ZOSV
 ;;19,18 I $L($T(^@X))
 ;;19,"DEL" D ROUDEL^DINVGUX(X)
 ;;19,"EOFF" U $I:(NOECHO)
 ;;19,"EON" U $I:(ECHO)
 ;;19,"HIGHESTCHAR" N DIUTF8 S DIUTF8=$L($C(256))>0 S Y=$C($S(DIUTF8:983037,1:255))
 ;;19,"LOAD" N %,%N S %N=0 F XCNP=XCNP+1:1 S %N=%N+1,%=$T(+%N^@X) Q:$L(%)=0  S @(DIF_XCNP_",0)")=%
 ;;19,"NO-TYPE-AHEAD" U $I:(NOTYPEAHEAD)
 ;;19,"RM" U $I:(WIDTH=$S(X<256:X,1:0):FILTER="ESCAPE")
 ;;19,"RSEL" K ^UTILITY($J) D ^%RSEL S X="" X "F  S X=$O(%ZR(X)) Q:X=""""  S ^UTILITY($J,X)=""""" K %ZR
 ;;19,"SDP" O DIO F  U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
 ;;19,"SDPEND" W !,"#$#",! C IO
 ;;19,"TRMOFF" U $I:(TERMINATOR="")
 ;;19,"TRMON" U $I:(TERMINATOR=$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))
 ;;19,"TRMRD" S Y=$A($ZB)
 ;;19,"TYPE-AHEAD" U $I:(TYPEAHEAD)
 ;;19,"UCICHECK" S Y=1
 ;;19,"XY" S $X=IOX,$Y=IOY
 ;;19,"ZS" D ROUSAV^DINVGUX(X)
 ;;100,0 OTHER^^40^5000
 ;;100,1 Q
 ;
 ;
 ;
EOR ; end of routine DINIT21
