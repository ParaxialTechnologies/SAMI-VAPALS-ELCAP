SAMICASE ;ven/gpl - case review library ;2021-07-06T15:44Z
 ;;18.0;SAMI;**1,12**;2020-01;
 ;;1.18.0.12-t2+i12
 ;
 ; SAMICASE contains ppis and other services to support processing
 ; of the VAPALS-IELCAP case review page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@license see routine SAMIUL
 ;@documentation see SAMICUL
 ;@contents
 ; (all public interfaces)
 ; 
 ;
 ;
 ;@section 1 web-route interfaces
 ;
 ;
 ;
 ;@wri WSCASE^SAMICASE, post vapals casereview: generate case review page
WSCASE(rtn,filter) goto WSCASE^SAMICAS2
 ;
 ;
 ;
 ;@wri WSNUFORM^SAMICASE, post vapals nuform: new form for patient
WSNUFORM(rtn,filter) goto WSNUFORM^SAMICAS2
 ;
 ;
 ;
 ;@wri DELFORM^SAMICASE, post vapals deleteform: delete incomplete form
DELFORM(RESULT,ARGS) goto DELFORM^SAMICAS2
 ;
 ;
 ;
 ;@wri WSNFPOST^SAMICASE, post vapals addform: new form
WSNFPOST(ARGS,BODY,RESULT) goto WSNFPOST^SAMICAS3
 ;
 ;
 ;
 ;@section 2 private program interfaces
 ;
 ;
 ;
 ;@ppi GETTMPL^SAMICASE, get html template
GETTMPL(return,form) goto GETTMPL^SAMICAS2
 ;
 ;
 ;
 ;@ppi GETITEMS^SAMICASE, get items available for studyid
GETITEMS(ary,sid) goto GETITEMS^SAMICAS2
 ;
 ;
 ;
 ;@ppi $$NOTEHREF^SAMICASE, html list of notes for form
NOTEHREF(sid,form) goto NOTEHREF^SAMICAS2
 ;
 ;
 ;
 ;@ppi $$VAPALSDT^SAMICASE, date in vapals format
VAPALSDT(fmdate) goto VAPALSDT^SAMICAS2
 ;
 ;
 ;
 ;@ppi $$KEY2FM^SAMICASE, convert key to fileman date
KEY2FM(key) goto KEY2FM^SAMICAS2
 ;
 ;
 ;
 ;@ppi SSAMISTA^SAMICASE, set samistatus to val in form
SSAMISTA(sid,form,val) goto SSAMISTA^SAMICAS2
 ;
 ;
 ;
EOR ; end of routine SAMICASE
