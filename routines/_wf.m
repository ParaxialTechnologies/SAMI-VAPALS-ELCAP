%wf	;ven/gpl - mash forms utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
 ; All the public entry points for forms are here in %wf
 ;
importfmap(csvname,form) ; import form mapping definitions from csv
 ; csvname is the name of the csv file
 ; form is the name of the form
 ;
 do importfmap^%wffmap(csvname,form)
 quit
 ;
wsGetForm(rtn,filter) ; return the html for the form id, passed in filter
 ; filter("form")=id
 ; filter("studyId")=studyId
 do wsGetForm^%wfhform(.rtn,.filter)
 quit
 ;
replaceHref(ln) ; do replacements on html lines for href values; extrinsic returns true if 
 ; replacement was done
 do replaceHref^%wfhform(.ln)
 quit
 ;
replace(ln,cur,repl) ; replace current with replacment in line ln
 do replace^%wfhform(.ln,cur,repl)
 quit
 ;
unvalue(ln) ; sets value=""
 do unvalue^%wfhform(.ln)
 quit
 ;
value(ln,val) ; sets value="@val"
 do value^%wfhform(.ln,val)
 quit
 ;
uncheck(ln) ; removes 'check="checked"' from ln, passed by reference
 do uncheck^%wfhform(.ln)
 quit
 ;
check(line,type) ; for radio buttons and checkbox
 do check^%wfhform(.line,type)
 quit
 ;
wsPostForm(ARGS,BODY,RESULT) ; recieve from form
 do wsPostForm^%wfhform(.ARGS,.BODY,.RESULT)
 quit
 ;
parseBody(rtn,body) ; parse the variables sent by a form
 ; rtn is passed by name
 do parseBody^%wfhform(.rtn,.body)
 quit
 ;
getVals(vrtn,zid,zsid) ; get the values for the form from the graph
 do getVals^%wfhform(.vrtn,zid,zsid)
 quit
 ;
setVals(vary,zid,zsid) ; set the values returned from form id for patient zsid
 do setVals^%wfhform(.vary,zid,zsid)
 quit
 ;

