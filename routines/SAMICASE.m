SAMICASE ;ven/gpl - ielcap: case review page module; 2/14/19 10:11am ; 3/29/19 10:18am
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ;@documentation: see routine SAMICUL
 ;
 ; SAMICASE contains subroutines for producing the ELCAP Case Review Page.
 ;
 ;
 quit  ; no entry from top
 ;
 ;@ppi - generate case review page
WSCASE(rtn,filter) ; generate case review page
 ;@called by :
 ; WSVAPALS^SAMIHOM4
 ; WSLOOKUP^SAMISRC2
 ; WSCASE^SAMICAS2
 ; _wfhform
 ; %wfhform
 ;@web service
 ; SAMICASE-wsCASE
 ;@calls :
 ; $$setroot^%wd
 ; GETTMPL^SAMICAS2
 ; GETITEMS^SAMICAS2
 ; $$SID2NUM^SAMIHOM3
 ; findReplace^%ts
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; $$GETDTKEY^SAMICAS2
 ; $$KEY2DSPD^SAMICAS2
 ; $$GETLAST5^SAMIFORM
 ; $$GETSSN^SAMIFORM
 ; $$GETNAME^SAMIFORM
 ; $$GSAMISTA^SAMICAS2
 ; D ADDCRLF^VPRJRUT
 ;@input :
 ; .filter =
 ; .filter("studyid")=studyid of the patient
 ;@output :
 ; .rtn
 ;@tests :
 ; SAMIUTS2
 goto WSCASE^SAMICAS2
 ;
 ;
 ;@ppi - get html template
GETTMPL(return,form) ; get html template
 ;@called by :
 ; GETHOME^SAMIHOM4
 ; WSNOTE^SAMINOTI
 ;@calls :
 ; $$getTemplate^%wf
 ; getThis^%wd
 ;@input
 ; return = name of array to return template in
 ; form = name of form
 ;@output
 ; @return = template
 ;@tests :
 ; SAMIUTS2
 goto GETTMPL^SAMICAS2
 ;
 ;
 ;@ppi - get items available for studyid
GETITEMS(ary,sid) ; get items available for studyid
 ;@called by
 ; GETITEMS^SAMICAS2
 ; MKCEFORM^SAMICAS3
 ; GETFILTR^SAMICTR0
 ; WSSBFORM^SAMIFORM
 ; WSSIFORM^SAMIFORM
 ; WSCEFORM^SAMIFORM
 ; SELECT^SAMIUR1
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; @ary = returned items available
 ; sid = patient's study ID (e.g. "XXX00001")
 ;@output
 ;@tests
 ; SAMIUTS2
 goto GETITEMS^SAMICAS2
 ;
 ;@ppi extrinsic returns html for the list of notes for the form
NOTEHREF(sid,form) ; extrinsic returns html for the list of notes for the form
 goto NOTEHREF^SAMICAS2
 ;
 ;@ppi - extrinsic which return the vapals format for dates
VAPALSDT(fmdate) ; extrinsic which return the vapals format for dates
 ;@called by
 ; PREFILL^SAMIHOM3
 ; MKSIFORM^SAMIHOM3
 ; SELECT^SAMIUR1
 ;@calls
 ; $$FMTE^XLFDT
 ;@input
 ; fmdate = date in fileman format
 ;@output
 ; vapals date format
 ;@tests
 ; SAMIUTS2
 goto VAPALSDT^SAMICAS2
 ;
 ;
WSNUFORM(rtn,filter) ; select new form for patient (get service)
 ;@called by
 ; WSVAPALS^SAMIHOM4
 ;@web service
 ;  SAMICASE-wsNuForm
 ;@calls
 ; $$SID2NUM^SAMIHOM3
 ; $$setroot^%wd
 ; GETTMPL^SAMICAS2
 ; findReplace^%ts
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; findReplace^%ts
 ;@input
 ; .filter =
 ; .filter("studyid")=studyid of the patient
 ;@output
 ; @rtn
 ;@tests
 ; SAMIUTS
 goto WSNUFORM^SAMICAS2
 ;
 ;
 ;@ppi - convert a key to a fileman date
KEY2FM(key) ; convert a key to a fileman date
 ;@called by
 ; WSNFPOST^SAMICAS3
 ; SAVFILTR^SAMISAV
 ; SELECT^SAMIUR1
 ;@calls
 ; ^%DT
 ;@input
 ; key = vapals key (e.g.
 ;@output
 ;@examples
 ;  $$KEY2FM("sbform-2018-02-26") = 3180226
 ;@tests
 ; SAMIUTS2
 goto KEY2FM^SAMICAS2
 ;
 ;@ppi - sets 'samistatus' to val in form
SSAMISTA(sid,form,val) ; sets 'samistatus' to val in form
 ;@called by
 ; INITSTAT^SAMICAS2
 ; MKBSFORM^SAMIHOM3
 ; MKSIFORM^SAMIHOM3
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid   = patient's studyid
 ; form  = specific study form (e.g. "sbform-2018-02-26")
 ; value = status (complete, incomplete)
 ;@output
 ; sets 'samistatus' to val in form
 ;@tests
 goto SSAMISTA^SAMICAS2
 ;
 ;@ppi - deletes a form if it is incomplete
DELFORM(RESULT,ARGS) ; deletes a form if it is incomplete
 ;@called by
 ; WSVAPALS^SAMIHOM4
 ;@calls
 ; $$setroot^%wd
 ; $$GSAMISTA^SAMICAS2
 ; WSCASE^SAMICAS2
 ;@input
 ; .ARGS=
 ; .ARGS("studyid")
 ; .ARGS("form")
 ;@output
 ; @RESULT
 ;@tests
 ; SAMIUTS2
 goto DELFORM^SAMICAS2
 ;
 ;
 ;@ppi - post new form selection (post service)
WSNFPOST(ARGS,BODY,RESULT) ; post new form selection (post service)
 ;@called by
 ; WSVAPALS^SAMIHOM4
 ;@web service
 ; SAMICASE-wsNuFormPost
 ;@calls
 ; parseBody^%wf
 ; GETHOME^SAMIHOM3
 ; $$KEYDATE^SAMIHOM3
 ; $$setroot^%wd
 ; $$KEY2FM^SAMICAS2
 ; MKSBFORM^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKBXFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ;@input
 ; .ARGS
 ; .ARGS("form")
 ; .ARGS("studyid")
 ; .ARGS("sid")
 ; .BODY
 ; .BODY(1) (e.g. "samiroute=casereview&dfn="_dfn_"&studyid="_studyid)
 ;@output
 ; @RESULT
 ;@tests
 ; SAMIUTS2
 goto WSNFPOST^SAMICAS3
 ;
EOR ; end of routine SAMICASE
