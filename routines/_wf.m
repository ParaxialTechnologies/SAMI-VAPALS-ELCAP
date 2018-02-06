%wf ;ven/gpl-write form: development log ;2018-02-06T02:00Z
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
 ;@last-updated: 2018-02-06T02:00Z
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
 ; convert entry points to ppi/api style
 ; %wfhform: r/all local calls w/calls through ^%wf
 ;
 ;@contents
 ; all private web services & programming interfaces for now
 ; some public web services & apis later
 ;
 ;
 ;
 ;@section 1 wsGetForm^%wf web service & ppis
 ;
 ;
 ;
wsGetForm(rtn,filter,post) ; web service wsGetForm^%wf, get html form
 do wsGetForm^%wfhform(.rtn,.filter,$get(post))
 quit
 ;
 ;
 ;
 ;@section 2 wsGetForm^%wf support subroutines
 ;
 ;
 ;
formLabel(form) ; ppi $$formLabel^%wf, label to use for form's post url
 quit $$formLabel^%wfhform(form)
 ;
 ;
getTemplate(form) ; ppi $$getTemplate^%wf, get name of form's template
 quit $$getTemplate^%wfhform(form)
 ;
 ;
 ;
 ;@section 3 wsGetForm^%wf error handling
 ;
 ;
 ;
redactErr(html,err,indx) ; ppi redactErr^%wf, clear errors from form
 do redactErr^%wfhform(html,err,.indx)
 quit
 ;
 ;
redactErr2(html,indx) ; ppi redactErr2^%wf, redact field's error symbol
 do redactErr2^%wfhform(html,.indx)
 quit
 ;
 ;
testRedactErr2 ; test redactErr2^%wf [move to %wfut]
 do testRedactErr2^%wfhform
 quit
 ;
 ;
putErrMsg2(html,lin,msg,err) ; ppi putErrMsg2^%wf, insert error msgs
 do putErrMsg2^%wfhform(html,.lin,msg,$get(err))
 quit
 ;
 ;
insError(ln,msg) ; ppi insError^%wf, insert error msg into html line
 do insError^%wfhform(.ln,.msg)
 quit
 ;
 ;
debugFld(ln,form,name) ; ppi debugFld^%wf, insert field debugging info
 do debugFld^%wfhform(.ln,form,name)
 quit
 ;
 ;
 ;
 ;@section 4 wsGetForm^%wf text manipulation
 ;
 ;
 ;
delText(ln,begin,end,ins) ; ppi $$delText^%wf, delete text from html line
 quit $$delText^%wfhform(.ln,begin,end,$get(ins))
 ;
 ;
replace(ln,cur,repl) ; ppi replace^%wf, replace test in html line
 do replace^%wfhform(.ln,cur,repl)
 quit
 ;
 ;
replaceAll(ln,cur,repl) ; ppi replaceAll^%wf, replace text in html line
 do replaceAll^%wfhform(.ln,cur,repl)
 quit
 ;
 ;
 ;
 ;@section 5 wsGetForm^%wf input value manipulation
 ;
 ;
 ;
unvalue(ln) ; ppi unvalue^%wf, clear input value in html line
 do unvalue^%wfhform(.ln)
 quit
 ;
 ;
value(ln,val) ; ppi value^%wf, set input value in html line
 do value^%wfhform(.ln,val)
 quit
 ;
 ;
getVals(vrtn,zid,zsid) ; ppi getVals^%wf, get form's values from graph
 do getVals^%wfhform(.vrtn,zid,zsid)
 quit
 ;
 ;
setVals(vary,zid,zsid) ; ppi setVals^%wf, set graph's values from form
 do setVals^%wfhform(.vary,zid,zsid)
 quit
 ;
 ;
 ;
 ;@section 6 wsGetForm^%wf radio/checkbox manipulation
 ;
 ;
 ;
uncheck(ln) ; ppi uncheck^%wf, uncheck radio button or checkbox
 do uncheck^%wfhform(.ln)
 quit
 ;
 ;
check(line,type) ; ppi check^%wf, check radio button or checkbox
 do check^%wfhform(.line,type)
 quit
 ;
 ;
 ;
 ;@section 7 wsGetForm^%wf field validation
 ;
 ;
 ;
validate(value,spec,map,msg) ; ppi $$validate^%wf, validate value
 quit $$validate^%wfhform(value,spec,$get(map),.msg)
 ;
 ;
dateValid(value,spec,map,msg) ; ppi $$dateValid^%wf, validate date
 quit $$dateValid^%wfhform(value,spec,$get(map),.msg)
 ;
 ;
textValid(value,spec,map) ; ppi $$textValid^%wf, validate free-text field
 quit $$textValid^%wfhform(value,spec,$get(map))
 ;
 ;
numValid(value,spec,map) ; ppi $$numValid^%wf, validate numeric field
 quit $$numValid^%wfhform(value,spec,$get(map)) ; validate a numeric field
 ;
 ;
dateFormat(val,form,name) ; ppi $$dateFormat^%wf, reformat date in elcap format
 quit $$dateFormat^%wfhform(.val,form,name)
 ;
 ;
 ;
 ;@section 8 wsPostForm^%wf web service & parseBody ppi
 ;
 ;
 ;
wsPostForm(ARGS,BODY,RESULT) ; web service wsPostForm^%wf, submit HTML form
 do wsPostForm^%wfhform(.ARGS,.BODY,.RESULT)
 quit
 ;
 ;
parseBody(rtn,body) ; ppi parseBody^%wf, get form's values from submitted form
 do parseBody^%wfhform(.rtn,.body)
 quit
 ;
 ;
 ;
 ;@section 9 commented-out procedures
 ;
 ;
 ;
replaceSrc(ln) ; ppi replaceSrc^%wf, chg src & href lines to find resources
 do replaceSrc^%wfhform(.ln)
 quit
 ;
 ;
replaceHref(ln) ; ppi replaceHref^%wf, chg href lines to find resources
 do replaceHref^%wfhform(.ln)
 quit
 ;
 ;
 ;
 ;@section 10 %wffmap form mapping ppi
 ;
 ;
 ;
importfmap(csvname,form) ; ppi importfmap^%wf, import map from csv
 do importfmap^%wffmap(csvname,form)
 quit
 ;
 ;
 ;
eor ; end of routine %wf
