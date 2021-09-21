SAMIADMN ; ven/arc - IELCAP: Admin tools ;Jan 17, 2020@13:46
 ;;18.0;SAMI;;
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
 ; @change-log
 ;   2018-05-03 ven/arc: Create entry point to clear M Web Server files cache
 ;   2018-07-01 ven/arc: added SETELCAP and SETLUNGRADS to switch between Ct Evaluation
 ;     forms
 ;   2018-08-14 ven/arc: web services for setlrads and setelcap, fix to setelcap and 
 ;     setlungrads web services
 ;   2018-08-16 ven/arc: adding quotes to json, return valid json and added /ctversion
 ;   2018-08-20 ven/gpl: fixed but in /ctversion
 ;   2018-12-06 ven/lmry: minor edits for SAC compliance
 ;   2018-12-11 ven/lgc: update routines for SAC compliance
 ;   2018-12-27 ven/lgc: update routines for SAC compliance
 ;   2019-01-22 ven/lgc: add license info and edit for lower case initials
 ;   2019-03-12 ven/lmry: Spell out commands, add table of contents, few format changes, 
 ;     also noted routines used for debugging, added history, added gpl, lgc, me to devs
 ;   2019-10-11 ven/arc : Add entry point DODD
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
 ; DODD ; Import TSV files to build form field DDs
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
 .; do ^ZTER
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
 .; do ^ZTER
 quit
 ;
WSSTELCP(rtn,filter) ; set VA-PALS to use the ELCAP version of the Ct Evaluation form
 new GLB,FN,IEN
 set FN=311.11
 set GLB=$name(^SAMI(311.11))
 set IEN=$order(@GLB@("B","vapals:ceform",""))
 if IEN="" do  quit  ;
 . ;write !,"Error, record vapals:ceform is not found in SAMI FORM MAPPING file!"
 . ;do ^ZTER
 new FDA
 set FDA(FN,IEN_",",2)="ctevaluation-elcap.html"
 new ZERR
 do UPDATE^DIE("","FDA","","ZERR")
 if $data(ZERR) do  quit  ;
 . ;ZWR ZERR
 . ;do ^ZTER
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
 . ;do ^ZTER
 new FDA
 set FDA(FN,IEN_",",2)="ctevaluation.html"
 new ZERR
 do UPDATE^DIE("","FDA","","ZERR")
 if $data(ZERR) do  quit  ;
 . ;ZWR ZERR
 . ;do ^ZTER
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
WINIT(method,urlpattern,routine) ; Add Web service
 ;Input
 ;  method        = HTTP VERB
 ;  urlpattern    = URI
 ;  routine       = EXECUTION ENDPOINT
 ;Exit
 ;  ien of new service in 17.6001
 quit:($get(method)="") 0
 quit:($get(urlpattern)="") 0
 quit:($get(routine)="") 0
 quit $$addService^%webutils(method,urlpattern,routine)
 ;
WDEL(method,urlpattern) ; Delete a Web service
 ;Input
 ;  method        = HTTP VERB
 ;  urlpattern    = URI
 ;Exit
 ;  none
 quit:($get(method)="")
 quit:($get(urlpattern)="")
 do deleteService^%webutils(method,urlpattern)
 quit
 ;
WINITA ; Build all production web services
 new method,urlpattern,routine,xstr,xcnt,xrslt
 if $data(%ut) set ^TMP("SAMIADMN","WINITA")=0
 f  s xcnt=$g(xcnt)+1,xstr=$text(PRODSERV+xcnt) q:(xstr["***END***")  do
 . set method=$p($piece(xstr,";;",2),",")
 . set urlpattern=$p($piece(xstr,";;",2),",",2)
 . set routine=$p($piece(xstr,";;",2),",",3)
 . set xrslt=$$WINIT^SAMIADMN(method,urlpattern,routine)
 . if '($get(xrslt)) do
 .. set ^TMP("SAMIADMN","WINITA")=1
 .. write !,!,xcnt," ",method," ",urlpattern," ",routine," FAILED",!
 quit
 ;
PRODSERV ;;
 ;;GET,ctversion,WSCTVERS^SAMIADMN,
 ;;GET,ptlookup/{search},WSPTLKUP^SAMIPTLK,
 ;;GET,ruralurbancount,WSGETRU^SAMIRU,
 ;;GET,setelcap,WSSTELCP^SAMIADMN,
 ;;GET,setlungrads,WSSTLRAD^SAMIADMN,
 ;;GET,vapals,WSHOME^SAMIHOM3,
 ;;GET,zipru/{zip},WSZIPRU^SAMIRU,
 ;;POST,vapals,WSVAPALS^SAMIHOM3,
 ;;GET,filesystem/*,FILESYS^%webapi,
 ;;GET,form/*,wsGetForm^%wf,
 ;;GET,global/{root},wsGLOBAL^KBAIVPR,
 ;;GET,graph/{graph},wsGetGraph^%wdgraph,
 ;;GET,gtree/{root},wsGtree^SYNVPR,
 ;;GET,r/{routine?.1"%25".32AN},R^%webapi,
 ;;GET,resources/*,FILESYS^%webapi,
 ;;GET,see/*,wssee^%yottagr,
 ;;GET,testptinfo,wsPTNFO^KBAIPTIN,
 ;;GET,vpr/{dfn},wsVPR^KBAIVPR,
 ;;GET,xml,XML^VPRJRSP,
 ;;POST,form/*,wsPostForm^%wf,
 ;;POST,postform/*,wsPostForm^%wf,
 ;;POST,sami/intake,wsPostForm^%yottaq,
 ;;GET,background,WSSBFORM^SAMIFORM,
 ;;GET,intake,WSSIFORM^SAMIFORM,
 ;;GET,ctevaluation,WSCEFORM^SAMIFORM,
 ;;***END***
 ;
 ;
DODD ; Import TSV files to build form field DDs
 new path set path=$$GET^XPAR("SYS","SAMI FORM FIELDS DEF PATH",,"Q")
 quit:path=""
 ;
 do PRSTSV^SAMIFF(path,"background.tsv","form fields - background")
 do PRSTSV^SAMIFF(path,"biopsy.tsv","form fields - biopsy")
 do PRSTSV^SAMIFF(path,"ct-evaluation.tsv","form fields - ct evaluation")
 do PRSTSV^SAMIFF(path,"follow-up.tsv","form fields - follow up")
 do PRSTSV^SAMIFF(path,"intake.tsv","form fields - intake")
 do PRSTSV^SAMIFF(path,"intervention.tsv","form fields - intervention")
 do PRSTSV^SAMIFF(path,"pet-evaluation.tsv","form fields - pet evaluation")
 do PRSTSV^SAMIFF(path,"register.tsv","form fields - register")
 ;
 quit  ; End of entry point DODD
 ;
 ;
DEVMSG(routine,type,message) ; Create a dev/test message in ^TMP
 ; @input
 ;   routine = routine, with or without entry point (optional)
 ;   type = type of message (optional)
 ;   message
 ;
 quit:$get(message)=""
 set routine=$get(routine)
 set type=$get(type)
 ;
 set msgSubscript="DEV MSG"
 new timestamp set timestamp=$horolog
 new timeSubscript set timeSubscript=$piece(timestamp,",",2)
 ;
 set ^TMP(msgSubscript,$job,0,"TIME")=$piece($$HTE^XLFDT(timestamp,7),"@",2)
 set ^TMP(msgSubscript,$job,0,"ROUTINE")=routine
 set ^TMP(msgSubscript,$job,0,"TYPE")=type
 set ^TMP(msgSubscript,$job,0,"MESSAGE")=message
 ;
 set ^TMP(msgSubscript,$job,timeSubscript,"TIME")=$piece($$HTE^XLFDT(timestamp,7),"@",2)
 set ^TMP(msgSubscript,$job,timeSubscript,"ROUTINE")=routine
 set ^TMP(msgSubscript,$job,timeSubscript,"TYPE")=type
 set ^TMP(msgSubscript,$job,timeSubscript,"MESSAGE")=message
 ;
 quit  ; End of entry point DEVMSG
 ;
 ;
EOR ; End of routine SAMIADMN

