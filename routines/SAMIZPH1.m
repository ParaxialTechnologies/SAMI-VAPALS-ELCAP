SAMIZPH1 ;ven/gpl - VAPALS PATIENT IMPORT FOR PHILIDELPHIA ; 8/15/20 4:48pm
 ;;18.0;SAMI;;;Build 2
 ;
 ;@license: see routine SAMIUL
 ;
 Q
 ;
SEP() ; extrinsic returns the separator character used
 Q $CHAR(9)
 ;
EN ;
 N DIR,FN,GN
 S DIR="/tmp/"
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.csv"
 S FN="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 S GN=$NA(^TMP("SAMICSV",$J,1))
 K @GN
 N OK
 S OK=$$FTG^%ZISH(DIR,FN,GN,3)
 K ^gpl("CSV")
 M ^gpl("CSV")=^TMP("SAMICSV",$J)
 D TOGRAPH
 D RECAP
 Q
 ;
TOGRAPH ;
 N GN S GN=$NA(^TMP("SAMICSV",$J))
 n root s root=$$setroot^%wd("PHI-INTAKE")
 n zi,zl
 ; first row
 f zi=1:1:$l(@GN@(1),$$SEP) d  ;
 . s zl=$p(@GN@(1),$$SEP,zi)
 . s @root@("key",zi,zl)=""
 . s @root@("key","B",zl,zi)=""
 q
 ;
REDCAP ;
 n root s root=$$setroot^%wd("PHI-INTAKE")
 n proot s proot=$na(@root@("REDCAP"))
 n GN s GN=$NA(^TMP("SAMICSV",$J))
 n key s key=$na(@root@("key"))
 n zi s zi=1
 f  s zi=$o(@GN@(zi)) q:+zi=0  d  ;
 . n zj
 . f zj=1:1:$l(@GN@(zi),$$SEP) d  ;
 . . n zl s zl=$o(@key@(zj,""))
 . . i zl="" s zl="piece"_zj
 . . s @proot@(zi,zl)=$p(@GN@(zi),$$SEP,zj)
 q
 ;