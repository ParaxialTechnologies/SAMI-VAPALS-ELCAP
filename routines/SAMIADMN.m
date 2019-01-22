SAMIADMN ; ven/arc - IELCAP: Admin tools ; 1/22/19 2:03pm
 ;;1.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (arc)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-05-03 ven/arc:
 ; Create entry point to clear M Web Server files cache
 ;
 ;
 quit  ; No entry from top
 ;
 ;
CLRWEB ; Clear the M Web Server files cache
 ;ven/arc;test;procedure;dirty;silent;non-sac
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
 .; ZWR ZERR
 . D ^ZTER
 Q
 ;
SETLGRDS() ; set VA-PALS to use the LungRads version of the Ct Evaluation form
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
 .; ZWR ZERR
 . D ^ZTER
 Q
 ;
WSSTELCP(rtn,filter) ; set VA-PALS to use the ELCAP version of the Ct Evaluation form
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
 S rtn="{""status"": ""ok""}"
 Q
 ;
WSSTLRAD(rtn,filter) ; set VA-PALS to use the LungRads version of the Ct Evaluation form
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
 S rtn="{""status"": ""ok""}"
 Q
 ;
WSCTVERS(rtn,filter) ; web service to return the current ctform version
 ;
 n fn,ver,ien
 s ien=$o(^SAMI(311.11,"B","vapals:ceform",""))
 q:ien=""
 s fn=$$GET1^DIQ(311.11,ien_",",2)
 i fn["elcap" s ver="elcap"
 e  s ver="lungrads"
 s rtn="{""ctversion"": """_ver_"""}"
 q
 ;
EOR ; End of routine SAMIADMN
