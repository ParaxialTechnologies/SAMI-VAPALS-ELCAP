%wfhform ;ven/gpl-write form: html form get & post ;2018-02-11T15:12Z
 ;;1.8;Mash;
 ;
 ; %wfhform implements the Write Form Library's html form get & post web
 ; services. It will be broken up into many routines & further annotated.
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
 ;@last-updated: 2018-02-11T15:12Z
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
 ; break up into smaller routines & change branches from %wf
 ;
 ;@contents
 ; [too big, break up]
 ;
 ;
 ;
 ;@section 1 wsGetForm^%wf web service & ppis
 ;
 ;
 ;
wsGetForm ; code for wsGetForm^%wf, get html form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@signature
 ; do wsGetForm^%wf(.rtn,.filter,post)
 ;@branches-from
 ; wsGetForm^%wf
 ;@ws-called-by
 ; web service GET:form/*
 ;@called-by: none
 ;@calls
 ; getVals^%wf
 ; retrieve^%wffiler
 ; $$getTemplate^%wf
 ; getThis^%wd
 ; SAMISUBS^SAMIFRM
 ; redactErr^%wf
 ; redactErr2^%wf
 ; $$formLabel^%wf
 ; $$replaceSrc^%wf [commented out]
 ; $$replaceHref^%wf [commented out]
 ; uncheck^%wf
 ; check^%wf
 ; debugFld^%wf
 ; unvalue^%wf
 ; $$URLENC^VPRJRUT
 ; replace^%wf
 ; dateFormat^%wf
 ; value^%wf
 ; $$getFieldSpec^%wffmap
 ; $$validate^%wf
 ; putErrMsg2^%wf
 ; insError^%wf
 ;@input
 ;.filter = 
 ; filter("form")=form id
 ; filter("studyId")=study id
 ; post = 1 if ...
 ;@output
 ;.rtn = name of root containing returned html (the prepared form)
 ;@throughput: none
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; return the html for the form id, passed in filter
 ;
 ;@stanza 2 load saved field values from graph
 ;
 new form set form=$get(filter("form")) ; id form
 if form="" set form="sbform"
 ;
 new sid set sid=$get(filter("studyid")) ; id patient by study id
 if sid="" set sid=$get(filter("fvalue"))
 if sid="" set sid="XXXX01"
 ;
 new vals
 do getVals^%wf("vals",form,sid) ; load saved field values
 ;
 ;@stanza 3 load html template
 ;
 ; get field values saved in fileman file, preserve graph values
 new fn
 if form["sbform" do  
 . ;set fn="background-form.html"
 . new tmpvals
 . if $g(post)=1 quit  ;
 . do retrieve^%wffiler("tmpvals","sbform",311.102,sid)
 . ;if $data(tmpvals) kill vals merge vals=tmpvals
 . ; maintain graph vars not saved in fileman:
 . if $data(tmpvals) merge vals=tmpvals
 . quit
 ;
 ; clear return html array
 set rtn=$name(^TMP("yottaForm",$job))
 kill @rtn
 ;
 ; lookup template name
 if $get(fn)="" set fn=$$getTemplate^%wf(form)
 if fn="" quit  ;
 ;
 ; load template html
 new zhtml,errctrl ; holders of html template & error control array
 do getThis^%wd("zhtml",fn)
 if '$data(zhtml) quit  ;
 ;
 ;@stanza 4 traverse html lines in template, for each ...
 ;
 new name,value,selectnm
 set selectnm="" ; name of select variable, which spans options
 new %j set %j=""
 for  set %j=$order(zhtml(%j)) quit:%j=""  do  ;
 . new tln set tln=zhtml(%j)
 . new customscan s customscan=""
 . ;
 . ;@stanza 5 special handling of SAMI forms
 . ;
 . ; do  ; i can't get this to work... need help with x indirection
 . ; . new fglb set fglb=$name(^SAMI(311.11))
 . ; . new fn set fn=311.11
 . ; . new fien set fien=$order(@fglb@("B",form,""))
 . ; . quit:fien="" ""
 . ; . set customscan=$$GET1^DIQ(fn,fien_",",3) ; custom scan routine
 . ; . if $length(customscan)>0 do
 . ; . . set customscan=$translate(customscan,"@","^") ; fix for ^
 . ; . . quit
 . ; . quit:$length(customscan)>0
 . ; . if $extract(form,3,6)["form" do
 . ; . . set customscan="do SAMISUBS^SAMIFRM(.tln,form,sid,.filter)"
 . ; . . quit
 . ; if customscan'="" xecute @customscan
 . ;
 . if form="sbform3" do SAMISUB2^SAMIFRM(.tln,form,sid,.filter,.%j,.zhtml)
 . else  do SAMISUBS^SAMIFRM(.tln,form,sid,.filter)
 . ;
 . set zhtml(%j)=tln
 . if tln["submit" quit  ;
 . if tln["hidden" quit  ;
 . ;
 . ; hack for elcap forms - temporary - gpl
 . ; if tln["jquery-1.html" set zhtml(%j)="" quit  ; 
 . ; if tln["mgtsys.html" set zhtml(%j)="" quit  ; 
 . ; if tln["mgtsys2.html" set zhtml(%j)="" quit  ; 
 . ; if tln["index.html" set zhtml(%j)="" quit  ; 
 . ; if tln["identity.html" set zhtml(%j)="" quit  ; 
 . ; if tln["jquery-1.html" set zhtml(%j)="" quit  ; 
 . ; end hack
 . ;
 . ;@stanza 6 process errors
 . ;
 . if tln["class=""errormsg"">" do  quit  ; error block at top of form
 . . do redactErr^%wf("zhtml","errctrl",.%j) ; remove error section
 . . quit
 . ;
 . if tln["fielderr" do  ; error messages w/fields
 . . do redactErr2^%wf("zhtml",.%j)
 . . quit
 . ;
 . ;@stanza 7 process field name or value
 . ;
 . set (name,value)=""
 . ;
 . if zhtml(%j)["name=" do  ;
 . . set name=$piece($piece(zhtml(%j),"name=""",2),"""",1)
 . . ;write !,"found name ",name
 . . quit
 . ;
 . if zhtml(%j)["value=" do  ;
 . . set value=$piece($piece(zhtml(%j),"value=""",2),"""",1)
 . . quit
 . ;
 . ;@stanza 8 process study id [why the asterisks?]
 . ;
 . if zhtml(%j)["*sbsid*" do  ;
 . . set zhtml(%j)=$piece(tln,"*sbsid*",1)_sid_$piece(tln,"*sbsid*",2)
 . . quit
 . ;
 . ;@stanza 9 process action
 . ;
 . if zhtml(%j)["action=" do  ;
 . . ; set zhtml(%j)="<form action=""http://vendev.vistaplex.org:9080/postform?form="_form_"&studyId="_sid_""" method=""POST"" id=""backgroundForm"">"
 . . new sublbl set sublbl=$$formLabel^%wf(form)
 . . new dbg set dbg=$get(filter("debug"))
 . . if dbg'="" set dbg="&debug="_dbg
 . . ;
 . . ; if form'="sbform" do  quit  ;
 . . ; . if zhtml(%j)["datae" do
 . . ; . . set zhtml(%j)="<form action=""form?form="_form_"&studyId="_sid_dbg_""" method=""POST"" name="""_sublbl_""">"
 . . ; . . quit
 . . ;
 . . if zhtml(%j)["http://foia201606.vistaplex.org:9080/sami/intake" do  quit  ; 
 . . . set zhtml(%j)="<form action=""form?form="_form_"&studyId="_sid_dbg_""" method=""POST"" name="""_sublbl_""">"
 . . . quit
 . . quit
 . ;
 . ;@stanza 10 fix css & js href values [disabled]
 . ;
 . ;if form'="sbform" do  ;
 . ;. if $$replaceSrc^%wf(.tln) set zhtml(%j)=tln
 . ;. if $$replaceHref^%wf(.tln) set zhtml(%j)=tlnvalues
 . ;. quit
 . ;
 . ;@stanza 11 skip table declarations
 . ;
 . if tln["table" quit  ;
 . ;
 . ;@stanza 12 process input tags
 . ;
 . if zhtml(%j)["input" do  ;
 . . ;
 . . ; handle long lines
 . . if $length(zhtml(%j),"<input")>2 do  ; got to split the lines
 . . . new zgt,zgn set zgt=zhtml(%j)
 . . . set zgn=$find(zgt,"<input",$find(zgt,"<input"))
 . . . set zhtml(%j+.001)=$extract(zgt,zgn-6,$length(zgt))
 . . . set zhtml(%j)=$extract(zgt,1,zgn-7)
 . . . set tln=zhtml(%j)
 . . . quit
 . . ;
 . . ; save field value
 . . quit:$get(name)=""
 . . new val set val=""
 . . if $data(vals(name)) set val=vals(name)
 . . ;
 . . ; handle radio buttons & checkboxes
 . . new type set type=""
 . . ;if tln["type=" set type=$piece($piece(tln,"type=""",2),"""",1)
 . . if tln["type=" set type=$piece($piece(tln,"type=",2)," ",1)
 . . if ((type="radio")!(type="checkbox")) do  quit  ;
 . . . ;quit  ; skip these for now
 . . . do uncheck^%wf(.tln)
 . . . if $get(val)=$get(value) do check^%wf(.tln,type)
 . . . if $get(filter("debug"))=2 do debugFld^%wf(.tln,form,name)
 . . . set zhtml(%j)=tln
 . . . quit
 . . ; break
 . . ;
 . . ; clear value, normalize quotes & dates, restore value
 . . do unvalue^%wf(.tln) ; clear input-field value
 . . ; set val=$$URLENC^VPRJRUT(val)
 . . for  do replace^%wf(.val,"""","&quot;") quit:val'[""""  ; quotes
 . . do dateFormat^%wf(.val,form,name) ; ensure elcap date format
 . . do value^%wf(.tln,val) ; restore normalized value
 . . ;
 . . ; input-field validation
 . . new spec,errmsg set spec=$$getFieldSpec^%wffmap(form,name)
 . . set errmsg="Input invalid"
 . . if val'="" do  ;
 . . . if $$validate^%wf(val,spec,,.errmsg)<1 do  ;
 . . . . set errflag=1
 . . . . new errmethod set errmethod=2
 . . . . ; set errmethod=$get(filter("errormessagestyle"))
 . . . . ; if errmethod="" set errmethod=$get(errctrl("errorMessageStyle"))
 . . . . ; if errmethod="" set errmethod=1
 . . . . set errmethod=2
 . . . . if errmethod=2 do  ;
 . . . . . new tprevln,uln
 . . . . . set uln=(%j-1)
 . . . . . set tprevln=zhtml(uln)
 . . . . . if tprevln'["fielderror" set tprevln=zhtml(%j-2) set uln=%j-2
 . . . . . do putErrMsg2^%wf("zhtml",.tprevln,.errmsg,"errctrl")
 . . . . . set zhtml(uln)=tprevln
 . . . . . quit
 . . . . if errmethod=1 do insError^%wf(.tln,.errmsg)
 . . . . quit
 . . . quit
 . . ;
 . . ; [optionally debug & r/html template line w/processed line
 . . ; write !,tln,!,zhtml(%j),! break
 . . if $get(filter("debug"))>0 do debugFld^%wf(.tln,form,name)
 . . set zhtml(%j)=tln
 . . quit
 . ;
 . ;@stanza 13 process text areas
 . ;
 . if zhtml(%j)["<textarea" do  ;
 . . new val set val=""
 . . quit:$get(name)=""
 . . set val=$get(vals(name))
 . . ; set val=$get(vals(name))
 . . ; set val=$$URLENC^VPRJRUT(val)
 . . if val'="" do replace^%wf(.tln,"</textarea>",val_"</textarea>")
 . . set zhtml(%j)=tln
 . . quit
 . ;
 . ;@stanza 14 process option selections
 . ;
 . if zhtml(%j)["<select" do  ;
 . . set selectnm=$get(name)
 . . quit
 . if zhtml(%j)["</select" do  ;
 . . set selectnm=""
 . . quit
 . if zhtml(%j)["<option" do  ;
 . . quit:selectnm=""
 . . set val=$get(vals(selectnm))
 . . do replace^%wf(.tln," selected","") ; unselect
 . . if $g(val)=$get(value) do replace^%wf(.tln,"<option ","<option selected ")
 . . if $get(filter("debug"))=2 do debugFld^%wf(.tln,form,name)
 . . set zhtml(%j)=tln
 . . quit
 . quit
 ;
 ;@stanza 15 return form prepared fr/template
 ;
 ; do ADDCRLF^VPRJRUT(.zhtml)
 ;
 merge @rtn=zhtml ; copy processed template to return array
 ;
 set HTTPRSP("mime")="text/html" ; set mime type
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wsGetForm^%wf
 ;
 ;
 ;
 ;@section 2 wsGetForm^%wf support subroutines
 ;
 ;
 ;
formLabel ; code for ppi $$formLabel^%wf, form's post url label
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$formLabel^%wf(form)
 ;@branches-from
 ; $$formLabel^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; $$GET1^DIQ
 ;@input
 ; form = form name
 ; ^SAMI(311.11) = 
 ;@output=
 ; label to use
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ;
 ;@stanza 2 do replacements
 ;
 new fglb set fglb=$name(^SAMI(311.11))
 new fn set fn=311.11
 new fien set fien=$order(@fglb@("B",form,""))
 quit:fien="" ""
 new lbl set lbl=$$GET1^DIQ(fn,fien_",",2.1) ; label to use
 ;
 ;@stanza 3 termination
 ;
 quit lbl ; end of $$formLabel^%wf
 ;
 ;
 ;
getTemplate ; code for API $$getTemplate^%wf, form's template name
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$getTemplate^%wf(form)
 ;@branches-from
 ; $$getTemplate^%wf
 ;@api-called-by
 ; wsGetForm^%wf
 ; getTemplate^SAMICASE
 ;@called-by: none
 ;@calls
 ; $$GET1^DIQ
 ;@input
 ; form = form name
 ; ^SAMI(311.11) = 
 ;@output=
 ; template name
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ;
 ;@stanza 2 get template name
 ;
 new fglb set fglb=$name(^SAMI(311.11))
 new fn set fn=311.11
 if form["-" do  ;
 . set form=$piece(form,"-",1)
 . ;if form="sbform" set form="sbform2"
 . quit
 new fien set fien=$order(@fglb@("B",form,""))
 quit:fien="" ""
 new tnm set tnm=$$GET1^DIQ(fn,fien_",",2) ; name of template
 ;
 ;@stanza 3 termination
 ;
 quit tnm ; end of $$getTemplate^%wf
 ;
 ;
 ;
 ;@section 3 wsGetForm^%wf error handling
 ;
 ;
 ;
redactErr ; code for ppi redactErr^%wf, clear errors from form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do redactErr^%wf(html,err,indx)
 ;@branches-from
 ; redactErr^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls: none
 ;@input
 ; html = name of html form array
 ; err = name of error array
 ;.indx = current line in html
 ;@throughput
 ; @html = error messages cleared
 ; @err = error messages cleared
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; redact error message section in html & clear error array
 ;
 ;@stanza 2 clear error messages
 ;
 new done set done=0
 set @err@("errorSectionBeginLine")=indx
 set @err@("errorMessageStyle")=2 ; errors to the top of page
 for i=indx:1,indx+20 quit:done  do  ;
 . if @html@(i)["</div>" set done=1
 . set @html@(i)=""
 . set @err@("errorSectionEndLine")=i
 . if @html@(i)["<tr>" set @err@("currentErrorLine")=i
 . set indx=i
 . quit
 set @err@("errorCount")=0
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of redactErr^%wf
 ;
 ;
 ;
redactErr2 ; code for ppi redactErr2^%wf, redact field's error symbol
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do redactErr2^%wf(html,.indx)
 ;@branches-from
 ; redactErr2^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; $$delText^%wf
 ;@input
 ; html = 
 ;.indx = 
 ;@throughput
 ; @html(indx) = 
 ;@examples [tbd]
 ;@tests [tbd]
 ; testRedactErr2^%wf
 ;
 ; [description tbd]
 ;
 ;@stanza 2 remove error symbol from field
 ;
 if @html@(indx)'["fielderror" quit  ; nothing to replace
 if @html@(indx)["fielderror""></span>" quit  ; nothing to replace
 new ln
 set ln=@html@(indx)
 if $$delText^%wf(.ln,"fielderror"">","</span>") set @html@(indx)=ln
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of redactErr2^%wf
 ;
 ;
 ;
testRedactErr2 ; code for test redactErr2^%wf [move to %wfut]
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do testRedactErr2^%wf
 ;@ppi-called-by: none
 ;@called-by: none
 ;@calls
 ; redactErr2^%wf
 ;@input: none
 ;@output
 ; report to screen results of removing error from field
 ;
 ; [description tbd]
 ;
 ;@stanza 2 do replacements
 ;
 new g set g="<th class=""serv"">Served in the military?<span id=""sbmly-fielderror""><a name=""err-2"" href=""#err-2e""><img src=""see/error.png""/>2</a></span></th>"
 new gg set gg(1)=g
 do redactErr2^%wf("gg",1)
 write !,gg(1)
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of testRedactErr2^%wf
 ;
 ;
 ;
putErrMsg2 ; code for ppi putErrMsg2^%wf, insert error msgs
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do putErrMsg2^%wf(html,.lin,.msg,err)
 ;@branches-from
 ; putErrMsg2^%wf
 ;@ppi-called-by
 ; wsGetForm
 ;@called-by: none
 ;@calls
 ; replace^%wf
 ;@input
 ; html = name of array containing html form
 ;.msg = error message to insert
 ;@throughput
 ; err = name of error array
 ;.lin = line to change, containing error, needs error message inserted
 ; @html = form to insert error messages into
 ; @err = error array to update with error message
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; style 2 of error messages - top of screen
 ;
 ;@stanza 2 insert error messages
 ;
 if $g(err)="" set err="errctrl"
 ;merge ^gpl("err")=@err
 new errno set errno=$get(@err@("errorCount"))+1
 set @err@("errorCount")=errno
 new uline set uline=$get(@err@("currentErrorLine"))
 if errno=1 do  ;
 . new bline,eline
 . set bline=$get(@err@("errorSectionBeginLine"))
 . if bline="" quit  ; don't know where to put the section
 . set @html@(bline)="<div class=""errormsg"">"
 . set @html@(bline+1)="<h1>Errors:<h1>"
 . set @html@(bline+2)="<table>"
 . set eline=$get(@err@("errorSectionEndLine"))
 . if eline="" quit  ;
 . set @html@(eline-1)="</table>"
 . set @html@(eline)="</div>"
 . if uline="" set uline=bline+3
 . quit
 new inserttxt
 set inserttxt="<a name=""err-"_errno_""" href=""#err-"_errno_"e""><img src=""see/error.png""/>"_errno_"</a>"
 do replace^%wf(.lin,"fielderror"">","fielderror"">"_inserttxt)
 if $get(uline)="" quit  ; set uline=32 - no uline is found, so nowhere to put the errors
 set @html@(uline)=@html@(uline)_"<tr><td class=""icon""><a name=""err-"_errno_"e"" href=""#err-"_errno_"""><img src=""see/error.png""/>"_errno_"</a></td><td>"_msg_"</td></tr>"
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of putErrMsg2^%wf
 ;
 ;
 ;
insError ; code for ppi insError^%wf, insert error msg into html line
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do insError^%wf(.ln,.msg)
 ;@branches-from
 ; insError^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ; debugFld^%wf
 ;@called-by: none
 ;@calls
 ; replace^%wf
 ;@input
 ;.msg = error message to insert
 ;@throughput
 ;.ln = line to change by inserting error message
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; inserts an error message into ln, passed by reference
 ;
 ;@stanza 2 insert error message
 ;
 new errins set errins="<span class=""alert"" style=""font-size: 0.9em;"">"_msg_"</span>"
 if ln["</input>" do replace^%wf(.ln,"</input>","</input>"_errins)  quit  ;
 if ln["/>" do replace^%wf(.ln,"/>","/>"_errins)  quit  ;
 if ln[">" set ln=ln_"</input>"_errins
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of insError^%wf
 ;
 ;
 ;
debugFld ; code for ppi debugFld^%wf, insert field debugging info
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do debugFld^%wf(ln,form,name)
 ;@branches-from
 ; debugFld^%wf
 ;@ppi-called-by
 ; wsGetFld^%wf
 ;@called-by: none
 ;@calls
 ; getFieldMap^%wffmap
 ; insError^%wf
 ;@input
 ; form = 
 ; name = 
 ;@throughput
 ;.ln = 
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ;
 ;@stanza 2 insert debugging info re field
 ;
 new dtxt
 set dtxt="field="_name
 new fary
 do getFieldMap^%wffmap("fary",form,name)
 set dtxt=dtxt_" fmFld="_$get(fary("FILEMAN_FIELD"))
 set dtxt=dtxt_" "_$get(fary("DATA_TYPE"))
 set dtxt=dtxt_" fmTitle: "_$get(fary("TITLE"))
 do insError^%wf(.ln,dtxt)
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of debugFld^%wf
 ;
 ;
 ;
 ;@section 4 wsGetForm^%wf text manipulation
 ;
 ;
 ;
delText ; code for ppi $$delText^%wf, delete text from html line
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$delText^%wf(.ln,begin,end,ins)
 ;@branches-from
 ; $$delText^%wf
 ;@ppi-called-by
 ; redactErr2^%wf
 ;@called-by: none
 ;@calls: none
 ;@input
 ; begin = substring preceding text to delete
 ; end = substring following text to delete
 ; ins = [optional] text to insert
 ;@throughput
 ;.ln = line of html to change
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; delete text between begin & end, optionally inserts text
 ;
 ;@stanza 2 delete/insert text
 ;
 new loc1 set loc1=$find(ln,begin)
 new loc2 set loc2=$find(ln,end)
 new haveins set haveins=0
 if $get(ins)'="" set haveins=1
 else  set ins=""
 set ln=$extract(ln,1,loc1-1)_ins_$extract(ln,loc2-$length(end),$length(ln))
 ;
 ;@stanza 3 termination
 ;
 quit 1 ; end of $$delText^%wf
 ;
 ;
 ;
replace ; code for ppi replace^%wf, replace test in html line
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do replace^%wf(.ln,cur,repl)
 ;@branches-from
 ; replace^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ; putErrMsg2^%wf
 ; insError^%wf
 ; value^%wf
 ; uncheck^%wf
 ; check^%wf
 ; $$replaceHref^%wf [deprecated subroutine]
 ;@called-by: none
 ;@calls: none
 ;@input
 ; cur = 
 ; repl = 
 ;@throughput
 ;.ln = 
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; replace current with replacment in line ln
 ;
 ;@stanza 2 do replacements
 ;
 quit:'$data(ln)
 new where set where=$find(ln,cur)
 quit:where=0 ; this might not work for cur at the end of ln, please test
 set ln=$extract(ln,1,where-$length(cur)-1)_repl_$extract(ln,where,$length(ln))
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of replace^%wf
 ;
 ;
 ;
replaceAll ; code for API replaceAll^%wf, replace text in html line
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; dp replaceAll^%wf(.ln,cur,repl)
 ;@branches-from
 ; replaceAll^%wf
 ;@ppi-called-by
 ; $$replaceSrc^%wf [deprecated]
 ; wsCASE^SAMICASE
 ; SAMISUBS^SAMIFRM
 ; fixSrc^SAMIFRM
 ; fixHref^SAMIFRM
 ;@called-by: none
 ;@calls: none
 ;@input
 ; cur = 
 ; repl = 
 ;@throughput
 ;.ln = 
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; replace all occurances of cur with repl in ln, passed by reference
 ;
 ;@stanza 2 do replacements
 ;
 new i,t1,t2 set t1=""
 for i=1:1:$length(ln,cur) do  ;
 . set t2(i)=$piece(ln,cur,i)
 . if i>1 set t2(i)=repl_$extract(t2(i),1,$length(t2(i)))
 . quit
 ;zwr t2
 for i=1:1:$order(t2(""),-1) set t1=t1_t2(i)
 set ln=t1
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of replaceAll^%wf
 ;
 ;
 ;
 ;@section 5 wsGetForm^%wf field value manipulation
 ;
 ;
 ;
unvalue ; code for ppi unvalue^%wf, clear input value in html line
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do unvalue^%wf(.ln)
 ;@branches-from
 ; unvalue^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls: none
 ;@throughput
 ;.ln
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; sets value=""
 ;
 ;@stanza 2 clear value
 ;
 new l1,l2,l3,t1,t2
 set l1=$find(ln,"value=""")
 q:l1=0
 set t1=$extract(ln,1,l1-1)
 set t2=$extract(ln,l1,$l(ln))
 set l3=$find(t2,"""")
 set t2=""""_$extract(t2,l3,$l(t2))
 set ln=t1_t2
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of unvalue^%wf
 ;
 ;
 ;
value ; code for ppi value^%wf, set input value in html line
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do value^%wf(.ln,val)
 ;@branches-from
 ; value^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; replace^%wf
 ;@input
 ; val = 
 ;@throughput
 ;.ln = 
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; sets value="@val"
 ;
 ;@stanza 2 set value
 ;
 new loc,end
 set loc=$find(ln,"value=""""")
 if loc=0 do  quit  ;
 . ;if $extract(ln,$length(ln))=">" set ln=$extract(ln,1,$length(ln)-1)_" value="""_val_""""_">"
 . do replace^%wf(.ln,"<input ","<input value="""_val_""" ")
 . quit
 set end=$extract(ln,loc,$length(ln))
 set ln=$piece(ln,"value=""",1)_"value="""_val_""""_end
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of value^%wf
 ;
 ;
 ;
getVals ; code for ppi getVals^%wf, get field values from graph
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; d getVals^%wf(vary,zid,zsid)
 ;@branches-from
 ; getVals^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ; testFiler^%wffiler
 ;@called-by: none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; vrtn = 
 ; zid = 
 ; zsid = 
 ; @root@("graph",zsid,zid)
 ;@output
 ; @vrtn = 
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; get the values for the form from the graph
 ;
 ;@stanza 2 get values from graph
 ;
 new root set root=$$setroot^%wd("elcap-patients")
 if '$data(@root@("graph",zsid,zid)) do  quit  ;
 . set @vrtn@(0)="values for patient: "_zsid_" in graph: "_zsid
 . quit
 merge @vrtn=@root@("graph",zsid,zid)
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of getVals^%wf
 ;
 ;
 ;
setVals ; code for ppi setVals^%wf, set field values into graph
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do setVals^%wf(vary,zid,zsid)
 ;@branches-from
 ; setVals^%wf
 ;@called-by: none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; vary = 
 ; zid = 
 ; zsid = 
 ;@output
 ; @root@("graph")
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; set the values returned from form id for patient zsid
 ;
 ;@stanza 2 set values
 ;
 new root set root=$$setroot^%wd("elcap-patients")
 if zsid="XXXX01" do  quit  ; the sample set
 . new src set src=$$setroot^%wd("elcapSampleJson")
 . if '$data(@src@(zid)) quit  ; no such form
 . merge @root@("graph",zsid,zid)=@src@(zid)
 . quit
 kill @root@("graph",zsid,zid)
 merge @root@("graph",zsid,zid)=@vary
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of setVals^%wf
 ;
 ;
 ;
 ;@section 7 wsGetForm^%wf field validation
 ;
 ;
 ;
validate ; code for ppi $$validate^%wf, validate value
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$validate^%wf(value,spec,map,.msg)
 ;@branches-from
 ; $$validate^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; $$dateValid^%wf
 ; $$textValid^%wf
 ; $$numValid^%wf
 ;@input
 ; value = string being validated
 ; spec = fileman spec which defines validation (e.g., FJ30  D  N5.2)
 ; map = [optional] passed by name, field mapping entry for variable
 ;@output
 ;.msg = custom error message
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; extrinsic returns 1 if valid 0 if not valid
 ;
 ;@stanza 2 validate value
 ;
 ;if $get(spec)="" quit 0  ; everything is invalid with no spec
 ;if $get(spec)="" quit 1  ; everything is valid with no spec
 if $get(spec)="" set spec="FJ30" ; make it free text to weed out bad characters
 ;
 ;new valrtn set valrtn
 ;if $get(@map@("VALIDATOR"))'="" do  quit valrtn  ; call a custom validator
 ;. add code to call the custom validator here
 ;
 if spec["S" quit 1  ; all set of codes are valid - let fileman check them
 ;
 if spec["D" quit $$dateValid^%wf(value,spec,$get(map),.msg) ; validate a date
 ;
 if spec["F" quit $$textValid^%wf(value,spec,$get(map)) ; validate free text field
 ;
 if spec["N" quit $$numValid^%wf(value,spec,$get(map)) ; validate a numeric value
 ;
 ;@stanza 3 termination
 ;
 quit 0  ; what else is there? assume it is invalid ; end of $$validate^%wf
 ;
 ;
 ;
dateValid ; code for ppi $$dateValid^%wf, validate date
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$dateValid^%wf(value,spec,map,msg)
 ;@branches-from
 ; $$dateValid^%wf
 ;@ppi-called-by
 ; $$validate^%wf
 ;@called-by: none
 ;@calls
 ; ^%DT: Vista Fileman date-time input/validation
 ;@input
 ; value = date being validated
 ; spec = 
 ; map = 
 ;@output=
 ; 1 if valid
 ; 0 if invalid
 ;.msg =
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; extrinsic which validates a date
 ;
 ;@stanza 2 validate date
 ;
 new X,Y
 set X=value
 do ^%DT
 if Y=-1 quit 0
 ;
 ;@stanza 3 termination
 ;
 quit 1 ; end of $$dateValid^%wf
 ;
 ;
 ;
textValid ; code for ppi $$textValid^%wf, validate free-text field
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$textValid^%wf(value,spec,map)
 ;@branches-from
 ; $$textValid^%wf
 ;@ppi-called-by
 ; $$validate^%wf
 ;@called-by: none
 ;@calls: none
 ;@input
 ; value = text being validated
 ; spec = fileman spec which defines validation (e.g., FJ30)
 ; map =
 ;@output=
 ; 1 if valid
 ; 0 if invalid
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; validate a free text field
 ; uses mumps pattern matching
 ;
 ;@stanza 2 validate text
 ;
 if spec'["F" quit 0  ; not a text field
 ;
 new min,max,x,specn
 set specn=+$translate(spec,"FJX ","") ; gets rid of the alphabetics 
 if specn["." do  ; there is a minimum and maximum
 . set min=$piece(specn,".",1)
 . set max=$piece(specn,".",2)
 . set x="value?"_min_"."_max_"LUNP"
 . quit
 else  do  ; no minimum
 . set x="value?."_specn_"LUNP"
 . quit
 ;w !,x
 if @x quit 1
 ;
 ;@stanza 3 termination
 ;
 quit 0 ; end of $$textValid^%wf
 ;
 ;
 ;
numValid ; code for ppi $$numValid^%wf, validate numeric field
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$numValid^%wf(value,spec,map)
 ;@branches-from
 ; $$numValid^%wf
 ;@ppi-called-by
 ; $$validate^%wf
 ;@called-by: none
 ;@calls: none
 ;@input
 ; value = number being validated
 ; spec = fileman spec which defines validation (e.g., N5.2)
 ; map =
 ;@output=
 ; 1 if valid
 ; 0 if invalid
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; validate a numeric field
 ; uses mumps pattern matching, handles decimal points
 ;
 ;@stanza 2 validate number
 ;
 if spec'["N" quit 0  ; not a numeric field
 new left,right,x,specn
 set specn=$translate(spec,"NJX ","") ; gets rid of the alphabetics 
 new result set result=1 ; assume valid
 if specn["," do  quit result  ; there is a left and right
 . set left=$piece(specn,",",1) ; digits left of the decimal
 . new valleft set valleft=$piece(value,".",1)
 . set x="valleft?."_left_"N"
 . if @x s result=1
 . else  set result=0 quit  ;
 . ; now test the number of digits right of the decimal 
 . set right=$piece(specn,",",2)
 . new valright set valright=$piece(value,".",2) ; digits right of the decimal
 . set x="valright?."_right_"N"
 . if @x set result=1
 . else  set result=0
 . quit
 else  d  ; no right of decimal point
 . set x="value?."_specn_"N"
 . quit
 w !,x
 if @x quit 1
 ;
 ;@stanza 3 termination
 ;
 quit 0 ; end of $$numValid^%wf
 ;
 ;
 ;
dateFormat ; code for ppi $$dateFormat^%wf, date in elcap format
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do dateFormat^%wf(.val,form,name)
 ;@branches-from
 ; dateFormat^%wf
 ;@ppi-called-by
 ; wsGetForm
 ;@called-by: none
 ;@calls
 ; $$getFieldSpec^%wffmap
 ; ^%DT
 ; $$FMTE^XLFDT
 ;@input
 ; form = 
 ; name = 
 ;@throughput
 ;.val = date
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; reformat date in elcap format
 ;
 ;@stanza 2 reformat date
 ;
 new spec set spec=$$getFieldSpec^%wffmap(form,name)
 if spec'["D" quit  ; not a date field
 new X,Y
 set X=val
 do ^%DT
 if Y=-1 quit  ; invalid date, can't reformat
 new dtmp set dtmp=$$FMTE^XLFDT(Y,"D") ; default exteral date format
 if $length(dtmp)=12 set val=$extract(dtmp,5,6)_"/"_$extract(dtmp,1,3)_"/"_$extract(dtmp,9,12) ; jan 01,1987
 else  set val=dtmp
 if $length(val)=8 set val=$extract(val,5,8)
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of dateFormat^%wf
 ;
 ;
 ;
 ;@section 8 wsPostForm^%wf web service & parseBody ppi
 ;
 ;
 ;
wsPostForm ; code for ws wsPostForm^%wf, submit HTML form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@signature
 ; do wsPostForm^%wf(.ARGS,BODY,RESULT)
 ;@branches-from
 ; wsPostForm^%wf
 ;@ppi-called-by
 ; web service POST:form/*
 ;@called-by: none
 ;@calls
 ; parseBody^%wf
 ; $$setroot^%wd
 ; wsGetForm^%wf
 ; fileForm^%wffiler
 ; fmx^%sfv2g
 ; ENCODE^VPRJSON
 ; beautify^%wd
 ; ADDCRLF^VPRJRUT
 ;@input
 ;.ARGS =
 ;.BODY =
 ;@output
 ;.RESULT =
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; receive from form
 ;
 ;@stanza 2 receive from form
 ;
 new %json,form,sid,body,tbdy
 set form=$get(ARGS("form"))
 set sid=$get(ARGS("studyid"))
 set body=$get(BODY(1))
 if form="" set form="sbform"
 if sid="" set sid="XXXX17"
 quit:form=""
 quit:sid=""
 set %json(sid,form,"form")=form
 do parseBody^%wf("tbdy",.body)
 merge %json(sid,form)=tbdy
 new gr set gr=$$setroot^%wd("elcap-patients")
 merge @gr@("graph")=%json
 ;
 ; validation process
 ;
 new errflag set errflag=0
 new revise
 do wsGetForm^%wf(.revise,.ARGS,1)
 if form="sbform2" if errflag'=0 do  quit  ;
 . merge RESULT=revise
 ;
 ; end validation process
 ;
 ; no errors, file it into fileman
 new status s status=""
 if form["sbform" do  ;
 . do fileForm^%wffiler("tbdy","sbform",sid,"status")
 . ;
 . ; now return the fileman record that was created
 . new fman,fien
 . set fien=$order(^SAMI(311.102,"B",sid,""))
 . quit:fien=""
 . do fmx^%sfv2g("fman",311.102,fien)
 . quit
 merge fman=status
 merge fman(form)=tbdy
 new tjson
 do ENCODE^VPRJSON("fman","tjson")
 do beautify^%wd("tjson","RESULT")
 DO ADDCRLF^VPRJRUT(.RESULT)
 set HTTPRSP("mime")="application/json"
 kill ^gpl("sami")
 merge ^gpl("sami","args")=ARGS
 merge ^gpl("sami","body")=BODY
 merge ^gpl("sami","json")=%json
 merge ^gpl("sami","fman")=fman
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wsPostForm^%wf
 ;
 ;
 ;
parseBody ; code for ppi parseBody^%wf, get field values from form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do parseBody^%wf(rtn,body)
 ;@branches-from
 ; parseBody^%wf
 ;@ppi-called-by
 ; wsPostForm^%wf
 ;@called-by: none
 ;@calls
 ; $$URLDEC^VPRJRUT
 ;@input
 ; rtn = [pass by name]
 ; body = 
 ;@output
 ; @rtn =
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; parse the variables sent by a form
 ; rtn is passed by name
 ;
 ;@stanza 2 parse variables from form
 ;
 new ii set ii=""
 if '$data(body) set body=$get(^gpl("sami","body",1))
 quit:'$data(body)
 new tmp set tmp=body
 kill @rtn
 for ii=1:1:$length(tmp,"&") do  ;
 . new ij
 . set ij=$piece(tmp,"&",ii)
 . quit:ij=""
 . set @rtn@($piece(ij,"=",1))=$$URLDEC^VPRJRUT($piece(ij,"=",2))
 . quit
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of parseBody^%wf
 ;
 ;
 ;
 ;@section 9 commented-out procedures
 ;
 ;
 ;
replaceSrc ; code for ppi replaceSrc^%wf, chg resources in src & href
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$replaceSrc^%wf(.ln)
 ;@branches-from
 ; $$replaceSrc^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf [commented out]
 ;@called-by: none
 ;@calls
 ; replaceAll^%wf
 ;@input
 ;.ln = 
 ;@output=
 ; 1 if replacement was done
 ; 0 if not
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; do replacements on lines for src= to use see service to locate resource
 ; deprecated, needed changes are in template now.
 ;
 ;@stanza 2 insert see service in src & href lines
 ;
 new done set done=0
 if ln["src='/" do  ;
 . do replaceAll^%wf(.ln,"src='/","src='see/")
 . set done=1
 . quit
 if ln["src=""/" do  ;
 . quit:done
 . do replaceAll^%wf(.ln,"src=""/","src=""see/")
 . set done=1
 . quit
 if ln["src=" do  ; 
 . quit:done
 . do replaceAll^%wf(.ln,"src=""","src=""see/")
 . set done=1
 . quit
 if ln["href='/" do  ;
 . do replaceAll^%wf(.ln,"href='/","href='see/")
 . set done=1 
 . quit
 if ln["href='" do  ;
 . quit:done
 . if ln["href=""#" quit  ;
 . if ln["href=""javascript" quit  ;
 . do replaceAll^%wf(.ln,"href='","href='see/")
 . set done=1 
 . quit
 if ln["href=" do  ; 
 . quit:done
 . if ln["href=""#" quit  ;
 . if ln["href=""javascript" quit  ;
 . do replaceAll^%wf(.ln,"href=""","href=""see/")
 . set done=1
 . quit
 ;
 ;@stanza 3 termination
 ;
 quit done ; end of $$replaceSrc^%wf
 ;
 ;
 ;
replaceHref ; code for ppi replaceHref^%wf, chg resources in href
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@signature
 ; $$replaceHref^%wf(.ln)
 ;@branches-from
 ; $$replaceHref^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf [commented out]
 ;@called-by: none
 ;@calls
 ; replace^%wf
 ;@input
 ;.ln = 
 ;@output=
 ; 1 if replacement was done
 ; 0 if not
 ;@throughput
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; do replacements on html lines for href values ; extrinsic returns true if
 ; replacement was done
 ; deprecated, use replaceSrc instead, if needed
 ;
 ;@stanza 2 process href lines
 ;
 new conds,done
 set done=0
 set conds("""sami.css""")="""resources/sami/sami.css"""
 set conds("""sami.js""")="""resources/sami/sami.js"""
 set conds("""sami2.js""")="""resources/sami/sami2.js"""
 set conds("""jquery-3.2.1.min.js""")="""resources/sami/jquery-3.2.1.min.js"""
 set conds("""jquery-ui.min.js""")="""resources/sami/jquery-ui.min.js"""
 ;
 new %ig set %ig=""
 for  set %ig=$order(conds(%ig)) quit:%ig=""  do  ;
 . if ln[%ig do  ;
 . . do replace^%wf(.ln,%ig,$get(conds(%ig)))
 . . set done=1
 . . quit
 . quit
 ;
 ;@stanza 3 termination
 ;
 quit done ; end of $$replaceHref^%wf
 ;
 ;
 ;
eor ; end of routine %wfhform
