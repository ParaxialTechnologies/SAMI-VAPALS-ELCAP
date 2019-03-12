SAMIADMN ; ven/arc - IELCAP: Admin tools ; 2019-03-12T20:29Z
 ;;1.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; Primary development:
 ;
 ; @primary-dev: Alexis Carlson (arc)
 ; @additional-dev: Larry Carlson (lgc)
 ; @additional-dev: George Lilly (gpl)
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-05-03 ven/arc: Create entry point to clear M Web Server files cache
 ; 2018-07-01 ven/arc: added SETELCAP and SETLUNGRADS to switch between Ct Evaluation
 ;   forms
 ; 2018-08-14 ven/arc: web services for setlrads and setelcap, fix to setelcap and 
 ;   setlungrads web services
 ; 2018-08-16 ven/arc: adding quotes to json, return valid json and added /ctversion
 ; 2018-08-20 ven/gpl: fixed but in /ctversion
 ; 2018-12-06 ven/lmry: minor edits for SAC compliance
 ; 2018-12-11 ven/lgc: update routines for SAC compliance
 ; 2018-12-27 ven/lgc: update routines for SAC compliance
 ; 2019-01-22 ven/lgc: add license info and edit for lower case initials
 ; 2019-03-12 ven/lmry: Spell out commands, add table of contents, few format changes, 
 ;  also noted routines used for debugging, added history, added gpl, lgc, me to devs
 ;
 quit  ; No entry from top
 ;
 ;@contents
 ; CLRWEB ; Clear the M Web Server files cache
 ; SETELCAP() ; set VA-PALS to use the ELCAP version of the Ct Evaluation form--for 
 ;   debugging
 ; SETLGRDS() ; set VA-PALS to use the LungRads version of the Ct Evaluation form--
 ;   for debugging
 ; WSSTELCP(rtn,filter) ; set VA-PALS to use the ELCAP version of the Ct Evaluation form
 ; WSSTLRAD(rtn,filter) ; set VA-PALS to use the LungRads version of the Ct Evaluation form
 ; WSCTVERS(rtn,filter) ; web service to return the current ctform version
 ;
CLRWEB ; Clear the M Web Server files cache
 ;ven/arc;test;procedure;dirty;silent;non-sac
 ;
 do purgegraph^%wd("html-cache")
 do purgegraph^%wd("seeGraph")
 do build^%yottagr
 ;
 quit  ; end of CLRWEB
 ;
 ;
SETELCAP() ; set VA-PALS to use the ELCAP version of the Ct Evaluation form--debugging
 new GLB,FN,IEN
 set FN=311.11
 set GLB=$name(^SAMI(311.11))
 set IEN=$order(@GLB@("B","vapals:ceform",""))
 if IEN="" do  quit  ;
 . write !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 new FDA
 set FDA(FN,IEN_",",2)="ctevaluation-elcap.html"
 new ZERR
 do UPDATE^DIE("","FDA","","ZERR")
 if $data(ZERR) do  quit  ;
 .; ZWR ZERR
 . do ^ZTER
 quit
 ;
SETLGRDS() ; set VA-PALS to use the LungRads version of the Ct Evaluation form--debugging
 new GLB,FN,IEN
 set FN=311.11
 set GLB=$name(^SAMI(311.11))
 set IEN=$order(@GLB@("B","vapals:ceform",""))
 if IEN="" do  quit  ;
 . write !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 new FDA
 set FDA(FN,IEN_",",2)="ctevaluation.html"
 new ZERR
 do UPDATE^DIE("","FDA","","ZERR")
 if $data(ZERR) do  quit  ;
 .; ZWR ZERR
 . do ^ZTER
 quit
 ;
WSSTELCP(rtn,filter) ; set VA-PALS to use the ELCAP version of the Ct Evaluation form
 new GLB,FN,IEN
 set FN=311.11
 set GLB=$name(^SAMI(311.11))
 set IEN=$order(@GLB@("B","vapals:ceform",""))
 if IEN="" do  quit  ;
 . ;write !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 . do ^ZTER
 new FDA
 set FDA(FN,IEN_",",2)="ctevaluation-elcap.html"
 new ZERR
 do UPDATE^DIE("","FDA","","ZERR")
 if $data(ZERR) do  quit  ;
 . ;ZWR ZERR
 . do ^ZTER
 set rtn="{""status"": ""ok""}"
 quit
 ;
WSSTLRAD(rtn,filter) ; set VA-PALS to use the LungRads version of the Ct Evaluation form
 new GLB,FN,IEN
 set FN=311.11
 set GLB=$name(^SAMI(311.11))
 set IEN=$order(@GLB@("B","vapals:ceform",""))
 if IEN="" do  quit  ;
 . ;write !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 . do ^ZTER
 new FDA
 set FDA(FN,IEN_",",2)="ctevaluation.html"
 new ZERR
 do UPDATE^DIE("","FDA","","ZERR")
 if $data(ZERR) do  quit  ;
 . ;ZWR ZERR
 . do ^ZTER
 set rtn="{""status"": ""ok""}"
 quit
 ;
WSCTVERS(rtn,filter) ; web service to return the current ctform version
 ;
 new fn,ver,ien
 set ien=$order(^SAMI(311.11,"B","vapals:ceform",""))
 quit:ien=""
 set fn=$$GET1^DIQ(311.11,ien_",",2)
 if fn["elcap" set ver="elcap"
 else  set ver="lungrads"
 set rtn="{""ctversion"": """_ver_"""}"
 quit
 ;
EOR ; End of routine SAMIADMN
