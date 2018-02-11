%wf ;ven/gpl-write form: development log ;2018-02-11T13:48Z
 ;;1.8;Mash;
 ;
 ; %wful is the Write Form Library's ppi & api routine. It supports getting
 ; & posting html forms, specifically the interface between an html form &
 ; a mumps graphstore.
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-11T13:48Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Write Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@to-do
 ; reroute %wfhform calls to other routines as it is broken up
 ;
 ;@contents
 ; API = application program interface, supported reference for SAMI
 ; ppi = private program interface for Mash
 ; ws = web service for Mash
 ;
 ;
 ;
 ;@section 1 wsGetForm^%wf web service & ppis
 ;
 ;
 ;
 ;@ws GET form/*, get html form
wsGetForm(rtn,filter,post) goto wsGetForm^%wfhform
 ;
 ;
 ;
 ;@section 2 wsGetForm^%wf support subroutines
 ;
 ;
 ;
 ;@ppi $$formLabel^%wf, label to use for form's post url
formLabel(form) goto formLabel^%wfhform
 ;
 ;
 ;@API $$getTemplate^%wf, get name of form's template
getTemplate(form) goto getTemplate^%wfhform
 ;
 ;
 ;
 ;@section 3 wsGetForm^%wf error handling
 ;
 ;
 ;
 ;@ppi redactErr^%wf, clear errors from form
redactErr(html,err,indx) goto redactErr^%wfhform
 ;
 ;
 ;@ppi redactErr2^%wf, redact field's error symbol
redactErr2(html,indx) goto redactErr2^%wfhform
 ;
 ;
 ;>test redactErr2^%wf [move to %wfut]
testRedactErr2 goto testRedactErr2^%wfhform
 ;
 ;
 ;@ppi putErrMsg2^%wf, insert error msgs
putErrMsg2(html,lin,msg,err) goto putErrMsg2^%wfhform
 ;
 ;
 ;@ppi insError^%wf, insert error msg into html line
insError(ln,msg) goto insError^%wfhform
 ;
 ;
 ;@ppi debugFld^%wf, insert field debugging info
debugFld(ln,form,name) goto debugFld^%wfhform
 ;
 ;
 ;
 ;@section 4 wsGetForm^%wf text manipulation
 ;
 ;
 ;
 ;@ppi $$delText^%wf, delete text from html line
delText(ln,begin,end,ins) goto delText^%wfhform
 ;
 ;
 ;@ppi replace^%wf, replace test in html line
replace(ln,cur,repl) goto replace^%wfhform
 ;
 ;
 ;@API replaceAll^%wf, replace text in html line
replaceAll(ln,cur,repl) goto replaceAll^%wfhform
 ;
 ;
 ;
 ;@section 5 wsGetForm^%wf input value manipulation
 ;
 ;
 ;
 ;@ppi unvalue^%wf, clear input value in html line
unvalue(ln) goto unvalue^%wfhform
 ;
 ;
 ;@ppi value^%wf, set input value in html line
value(ln,val) goto value^%wfhform
 ;
 ;
 ;@ppi getVals^%wf, get field values from graph
getVals(vrtn,zid,zsid) goto getVals^%wfhform
 ;
 ;
 ;@ppi setVals^%wf, set field values into graph
setVals(vary,zid,zsid) goto setVals^%wfhform
 ;
 ;
 ;
 ;@section 6 wsGetForm^%wf radio/checkbox manipulation
 ;
 ;
 ;
 ;@ppi uncheck^%wf, uncheck radio button or checkbox
uncheck(ln) goto uncheck^%wfhradio
 ;
 ;
 ;@ppi check^%wf, check radio button or checkbox
check(line,type) goto check^%wfhradio
 ;
 ;
 ;
 ;@section 7 wsGetForm^%wf field validation
 ;
 ;
 ;
 ;@ppi $$validate^%wf, validate value
validate(value,spec,map,msg) goto validate^%wfhform
 ;
 ;
 ;@ppi $$dateValid^%wf, validate date
dateValid(value,spec,map,msg) goto dateValid^%wfhform
 ;
 ;
 ;@ppi $$textValid^%wf, validate free-text field
textValid(value,spec,map) goto textValid^%wfhform
 ;
 ;
 ;@ppi $$numValid^%wf, validate numeric field
numValid(value,spec,map) goto numValid^%wfhform
 ;
 ;
 ;@ppi $$dateFormat^%wf, date in elcap format
dateFormat(val,form,name) goto dateFormat^%wfhform
 ;
 ;
 ;
 ;@section 8 wsPostForm^%wf web service & parseBody ppi
 ;
 ;
 ;
 ;@ws POST form/*, submit HTML form
wsPostForm(ARGS,BODY,RESULT) goto wsPostForm^%wfhform
 ;
 ;
 ;@ppi parseBody^%wf, get field values from form
parseBody(rtn,body) goto parseBody^%wfhform
 ;
 ;
 ;
 ;@section 9 commented-out procedures
 ;
 ;
 ;
 ;@ppi replaceSrc^%wf, chg resources in src & href
replaceSrc(ln) goto replaceSrc^%wfhform
 ;
 ;
 ;@ppi replaceHref^%wf, chg resources in href
replaceHref(ln) goto replaceHref^%wfhform
 ;
 ;
 ;
 ;@section 10 %wffmap form mapping ppi
 ;
 ;
 ;
 ;@ppi importfmap^%wf, import map from csv
importfmap(csvname,form) goto importfmap^%wffmap
 ;
 ;
 ;
eor ; end of routine %wf
