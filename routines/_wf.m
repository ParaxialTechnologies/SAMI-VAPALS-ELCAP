%wf	;ven/gpl-write form: development log ;2018-02-03T17:16Z
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
 ;   gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-03T17:16Z
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
wsGetForm(rtn,filter) ; return the html for the form id, passed in filter
 ; filter("form")=id
 ; filter("studyId")=studyId
 do wsGetForm^%wfhform(.rtn,.filter)
 quit
 ;
 ;
 ;
 ;@section 2 wsGetForm^%wf support subroutines
 ;
 ;
 ;
 ; $$formLabel^%wf, label to use for form's post url
 ;
 ;
 ; $$getTemplate^%wf, extrinsic returns the name of the template file
 ;
 ;
 ;
 ;@section 3 wsGetForm^%wf error handling
 ;
 ;
 ;
 ; redactErr^%wf, redact error message section in html & clear error array
 ;
 ;
 ; redactErr2^%wf, redact the error symbol on a field
 ;
 ;
 ; testRedactErr2^%wf, test redactErr2^%wf
 ;
 ;
 ; putErrMsg2^%wf, style 2 of error messages - top of screen
 ;
 ;
 ; insError^%wf, inserts an error message into ln, passed by reference
 ;
 ;
 ; debugFld^%wf, insert debugging info re field
 ;
 ;
 ;
 ;@section 4 wsGetForm^%wf text manipulation
 ;
 ;
 ;
 ; $$delText^%wf, delete text between begin & end
 ;
 ;
replace(ln,cur,repl) ; replace current with replacment in line ln
 do replace^%wfhform(.ln,cur,repl)
 quit
 ;
 ;
 ;
 ;@section 5 wsGetForm^%wf field value manipulation
 ;
 ;
 ;
unvalue(ln) ; sets value=""
 do unvalue^%wfhform(.ln)
 quit
 ;
 ;
value(ln,val) ; sets value="@val"
 do value^%wfhform(.ln,val)
 quit
 ;
 ;
getVals(vrtn,zid,zsid) ; get the values for the form from the graph
 do getVals^%wfhform(.vrtn,zid,zsid)
 quit
 ;
 ;
setVals(vary,zid,zsid) ; set the values returned from form id for patient zsid
 do setVals^%wfhform(.vary,zid,zsid)
 quit
 ;
 ;
 ;
 ;@section 6 wsGetForm^%wf radio/checkbox manipulation
 ;
 ;
 ;
uncheck(ln) ; removes 'check="checked"' from ln, passed by reference
 do uncheck^%wfhform(.ln)
 quit
 ;
 ;
check(line,type) ; for radio buttons and checkbox
 do check^%wfhform(.line,type)
 quit
 ;
 ;
 ;
 ;@section 7 wsGetForm^%wf field validation
 ;
 ;
 ;
 ; $$validate^%wf, extrinsic returns 1 if valid 0 if not valid
 ;
 ;
 ; $$dateValid^%wf, extrinsic which validates a date
 ;
 ;
 ; $$textValid^%wf, validate a free text field
 ;
 ;
 ; $$numValid^%wf, validate a numeric field
 ;
 ;
 ; dateFormat^%wf, reformat date in elcap format
 ;
 ;
 ;
 ;@section 8 wsPostForm^%wf web service & parseBody ppi
 ;
 ;
 ;
wsPostForm(ARGS,BODY,RESULT) ; receive from form
 do wsPostForm^%wfhform(.ARGS,.BODY,.RESULT)
 quit
 ;
 ;
parseBody(rtn,body) ; parse the variables sent by a form
 ; rtn is passed by name
 do parseBody^%wfhform(.rtn,.body)
 quit
 ;
 ;
 ;
 ;@section 9 commented-out procedures
 ;
 ;
 ;
replaceSrc(ln) ; do replacements on lines for src= to use see service to locate resource
 do replaceSrc^%wfhform(.ln)
 quit
 ;
 ;
replaceAll(ln,cur,repl) ; replace all occurances of cur with repl in ln, passed by reference
 dp replaceAll^%wfhform(.ln,cur,repl)
 quit
 ;
 ;
replaceHref(ln) ; do replacements on html lines for href values; extrinsic returns true if 
 ; replacement was done
 do replaceHref^%wfhform(.ln)
 quit
 ;
 ;
 ;
 ;@section 10 %wffmap form mapping ppi
 ;
 ;
 ;
importfmap(csvname,form) ; import form mapping definitions from csv
 ; csvname is the name of the csv file
 ; form is the name of the form
 ;
 do importfmap^%wffmap(csvname,form)
 quit
 ;
 ;
 ;
eor ; end of routine %wf
