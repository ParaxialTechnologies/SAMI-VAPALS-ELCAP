SAMIADMN ; VEN/ARC - IELCAP: Admin tools ;2018-05-03T22:35Z
 ;;1.0;SAMI;;
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (ARC)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-05-03 VEN/ARC:
 ; Create entry point to clear M Web Server files cache
 ;
 ;
 quit ; No entry from top
 ;
 ;
ClrWeb ; Clear the M Web Server files cache
 ;VEN/ARC;test;procedure;dirty;silent;non-sac
 ;
 d purgegraph^%wd("html-cache")
 d purgegraph^%wd("seeGraph")
 d build^%yottagr
 ;
 quit  ; end of CLRWEB
 ;
 ;
SETELCAP() ; set VA-PALS to use the ELCAP version of the Ct Evaluation form
 N GLB,FN,IEN
 S FN=311.11
 S GLB=$NA(^SAMI(311.11))
 S IEN=$O(@GLB@("B","vapals:ceform",""))
 I IEN="" D  Q  ;
 . W !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 N FDA
 S FDA(FN,IEN_",",2)="ctevaluation-elcap.html"
 N ZERR
 D UPDATE^DIE("","FDA","","ZERR")
 I $D(ZERR) D  Q  ;
 . ZWR ZERR
 Q
 ;
SETLUNGRADS() ; set VA-PALS to use the LungRads version of the Ct Evaluation form
 N GLB,FN,IEN
 S FN=311.11
 S GLB=$NA(^SAMI(311.11))
 S IEN=$O(@GLB@("B","vapals:ceform",""))
 I IEN="" D  Q  ;
 . W !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 N FDA
 S FDA(FN,IEN_",",2)="ctevaluation.html"
 N ZERR
 D UPDATE^DIE("","FDA","","ZERR")
 I $D(ZERR) D  Q  ;
 . ZWR ZERR
 Q
 ;
wsSETELCAP(rtn,filter) ; set VA-PALS to use the ELCAP version of the Ct Evaluation form
 N GLB,FN,IEN
 S FN=311.11
 S GLB=$NA(^SAMI(311.11))
 S IEN=$O(@GLB@("B","vapals:ceform",""))
 I IEN="" D  Q  ;
 . ;W !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 . D ^ZTER
 N FDA
 S FDA(FN,IEN_",",2)="ctevaluation-elcap.html"
 N ZERR
 D UPDATE^DIE("","FDA","","ZERR")
 I $D(ZERR) D  Q  ;
 . ;ZWR ZERR
 . D ^ZTER
 S rtn="{ok}"
 Q
 ;
wsSETLRADS(rtn,filter) ; set VA-PALS to use the LungRads version of the Ct Evaluation form
 N GLB,FN,IEN
 S FN=311.11
 S GLB=$NA(^SAMI(311.11))
 S IEN=$O(@GLB@("B","vapals:ceform",""))
 I IEN="" D  Q  ;
 . ;W !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 . D ^ZTER
 N FDA
 S FDA(FN,IEN_",",2)="ctevaluation.html"
 N ZERR
 D UPDATE^DIE("","FDA","","ZERR")
 I $D(ZERR) D  Q  ;
 . ;ZWR ZERR
 . D ^ZTER
 S rtn="{ok}"
 Q
 ;
EOR ; End of routine SAMIADMN
