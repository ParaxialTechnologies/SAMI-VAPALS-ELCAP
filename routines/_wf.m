%wf	;ven/gpl-write form: development log ;2018-01-22T20:01Z
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
12345678901234567890123456789012345678901234567890123456789012345678901234567890
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@primary-dev: George P. Lilly (gpl)
 ;   gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ;@copyright: 2017/2018, ven, all rights reserved
 ;@license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-01-22T20:01Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Write Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@contents
 ; all private programming interfaces for now, some apis later
 ;
 ;
 ;
 ;@section 2 %wffmap form mapping ppi
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
 ;@section 3 %wffmap form mapping ppi
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
replace(ln,cur,repl) ; replace current with replacment in line ln
 do replace^%wfhform(.ln,cur,repl)
 quit
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
 ;@section ? wsPostForm & parseBody
 ;
 ;
 ;
wsPostForm(ARGS,BODY,RESULT) ; recieve from form
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
 ;@section ? commented-out procedures
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
eor ; end of routine %wf
