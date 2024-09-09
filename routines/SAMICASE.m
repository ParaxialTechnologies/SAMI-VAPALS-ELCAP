SAMICASE ;ven/gpl - case review library; 2024-09-07t18:49z
 ;;18.0;SAMI;**1,12,18**;2020-01-17;Build 8
 ;mdc-e1;SAMICASE-20240909-E1aDWct;SAMI-18-18-b1
 ;mdc-v7;B3026427;SAMI*18.0*18 SEQ #18
 ;
 ; SAMICASE is the service library for ScreeningPlus's Case Review
 ; module. These services support processing of the Case Review page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;
 ;@license see routine SAMIUL
 ;@documentation see SAMICUL
 ;@contents
 ; (all private services)
 ; 
 ;
 ;
 ;
 ;@section 1 web-route services
 ;
 ;
 ;
 ;
 ;@wrs WSCASE^SAMICASE, post vapals casereview: create case review page
WSCASE(rtn,filter) goto WSCASE^SAMICAS2
 ;
 ;
 ;
 ;@wrs WSNUFORM^SAMICASE, post vapals nuform: new form for patient
WSNUFORM(rtn,filter) goto WSNUFORM^SAMICAS2
 ;
 ;
 ;
 ;@wrs WSNUUPLD^SAMICASE, post vapals file upload new for patient
WSNUUPLD(rtn,filter) goto WSNUUPLD^SAMICAS2
 ;
 ;
 ;
 ;@wrs DELFORM^SAMICASE, post vapals deleteform: delete incomplete form
DELFORM(RESULT,ARGS) goto DELFORM^SAMICAS2
 ;
 ;
 ;
 ;@wrs WSNFPOST^SAMICASE, post vapals addform: new form
WSNFPOST(ARGS,BODY,RESULT) goto WSNFPOST^SAMICAS3
 ;
 ;
 ;
 ;
 ;@section 2 private program services
 ;
 ;
 ;
 ;
 ;@pps GETTMPL^SAMICASE, get html template
GETTMPL(return,form) goto GETTMPL^SAMICAS2
 ;
 ;
 ;
 ;@pps GETITEMS^SAMICASE, get items available for studyid
GETITEMS(ary,sid) goto GETITEMS^SAMICAS2
 ;
 ;
 ;
 ;@pps $$NOTEHREF^SAMICASE, html list of notes for form
NOTEHREF(sid,form) goto NOTEHREF^SAMICAS2
 ;
 ;
 ;
 ;@pps $$VAPALSDT^SAMICASE, date in vapals format
VAPALSDT(fmdate) goto VAPALSDT^SAMICAS2
 ;
 ;
 ;
 ;@pps $$KEY2FM^SAMICASE, convert key to fileman date
KEY2FM(key) goto KEY2FM^SAMICAS2
 ;
 ;
 ;
 ;@pps SSAMISTA^SAMICASE, set samistatus to val in form
SSAMISTA(sid,form,val) goto SSAMISTA^SAMICAS2
 ;
 ;
 ;
EOR ; end of routine SAMICASE
