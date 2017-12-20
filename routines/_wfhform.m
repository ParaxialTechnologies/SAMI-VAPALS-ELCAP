%wfhform	;ven/gpl - mash forms utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
 ; All the public entry points for forms are in %wf
 ;
wsGetForm(rtn,filter,post) ; return the html for the form id, passed in filter
 ; filter("form")=form
 ; filter("studyId")=studyId
 s rtn=$na(^TMP("yottaForm",$J))
 k @rtn
 n form s form=$g(filter("form"))
 i form="" s form="sbform"
 n sid s sid=$g(filter("studyid"))
 i sid="" s sid="XXXX01"
 n vals
 d getVals("vals",form,sid)
 n fn
 i form="sbform" do  
 . s fn="background-form.html"
 . new tmpvals
 . if $g(post)=1 quit  ;
 . do retrieve^%wffiler("tmpvals",form,311.102,sid)
 . ;if $data(tmpvals) kill vals merge vals=tmpvals
 . if $data(tmpvals) merge vals=tmpvals ; maintain graph vars not saved in fileman
 i form="sbform2" do  
 . s fn="Background Form.html"
 . new tmpvals
 . if $g(post)=1 quit  ;
 . do retrieve^%wffiler("tmpvals",form,311.102,sid)
 . ;if $data(tmpvals) kill vals merge vals=tmpvals
 . if $data(tmpvals) merge vals=tmpvals ; maintain graph vars not saved in fileman
 ;i fn="" s fn="background-form.html"
 i $get(fn)="" s fn=$$getTemplate(form)
 i fn="" quit  ;
 n zhtml,errctrl ; holders of the html template and the error control array
 d getThis^%wd("zhtml",fn)
 i '$d(zhtml) q  ;
 n name,value,selectnm
 s selectnm="" ; name of select variable, which spans options
 n %j s %j=""
 f  s %j=$o(zhtml(%j)) q:%j=""  d  ;
 . n tln s tln=zhtml(%j)
 . i tln["submit" q  ;
 . i tln["hidden" q  ;
 . ; hack for elcap forms - temporary - gpl
 . i tln["jquery-1.html" s zhtml(%j)="" quit  ; 
 . i tln["mgtsys.html" s zhtml(%j)="" quit  ; 
 . i tln["mgtsys2.html" s zhtml(%j)="" quit  ; 
 . i tln["index.html" s zhtml(%j)="" quit  ; 
 . i tln["identity.html" s zhtml(%j)="" quit  ; 
 . i tln["jquery-1.html" s zhtml(%j)="" quit  ; 
 . ; end hack
 . i tln["class=""errormsg"">" d redactErr("zhtml","errctrl",.%j)  quit  ; remove error section
 . i tln["fielderr" d redactErr2("zhtml",.%j)
 . s (name,value)=""
 . i zhtml(%j)["name=" d  ;
 . . s name=$p($p(zhtml(%j),"name=""",2),"""",1)
 . . ;w !,"found name ",name
 . i zhtml(%j)["value=" d  ;
 . . s value=$p($p(zhtml(%j),"value=""",2),"""",1)
 . i zhtml(%j)["*sbsid*" d  ;
 . . s zhtml(%j)=$p(tln,"*sbsid*",1)_sid_$p(tln,"*sbsid*",2)
 . i zhtml(%j)["action=" d  ;
 . . ;s zhtml(%j)="<form action=""http://vendev.vistaplex.org:9080/postform?form="_form_"&studyId="_sid_""" method=""POST"" id=""backgroundForm"">"
 . . n sublbl s sublbl=$$formLabel(form)
 . . n dbg s dbg=$g(filter("debug"))
 . . i dbg'="" s dbg="&debug="_dbg
 . . i form'="sbform" d  quit  ;
 . . . i zhtml(%j)["datae" s zhtml(%j)="<form action=""form?form="_form_"&studyId="_sid_dbg_""" method=""POST"" name="""_sublbl_""">"
 . . s zhtml(%j)="<form action=""form?form="_form_"&studyId="_sid_dbg_""" method=""POST"" name="""_sublbl_""">"
 . if form'="sbform" do  ;
 . . if $$replaceSrc(.tln) s zhtml(%j)=tln ; fix the css and js href values
 . . if $$replaceHref(.tln) s zhtml(%j)=tln ; fix the css and js href values
 . i tln["table" quit  ;
 . i zhtml(%j)["input" d  ;
 . . i $l(zhtml(%j),"<input")>2 d  ; got to split the lines
 . . . n zgt,zgn s zgt=zhtml(%j)
 . . . s zgn=$f(zgt,"<input",$f(zgt,"<input"))
 . . . s zhtml(%j+.001)=$e(zgt,zgn-6,$l(zgt))
 . . . s zhtml(%j)=$e(zgt,1,zgn-7)
 . . . s tln=zhtml(%j)
 . . i $g(name)="" q  ;
 . . n val 
 . . s val=$g(vals(name))
 . . n type s type=""
 . . i tln["type=" s type=$p($p(tln,"type=""",2),"""",1)
 . . i ((type="radio")!(type="checkbox")) d  q  ;
 . . . ;q  ; skip these for now
 . . . d uncheck(.tln)
 . . . i $g(val)=$g(value) d check(.tln,type)
 . . . if $get(filter("debug"))=2 do debugFld(.tln,form,name)
 . . . s zhtml(%j)=tln
 . . ;b
 . . d unvalue(.tln)
 . . ;s val=$$URLENC^VPRJRUT(val)
 . . f  d replace^%yottaq(.val,"""","&quot;") q:val'[""""
 . . d dateFormat(.val,form,name) ; reformat if date
 . . d value(.tln,val)
 . . ;
 . . ; validation starts here
 . . ;
 . . new spec,errmsg set spec=$$getFieldSpec^%wffmap(form,name)
 . . set errmsg="Input invalid"
 . . if val'="" do  ;
 . . . if $$validate(val,spec,,.errmsg)<1 do  ;
 . . . . set errflag=1
 . . . . new errmethod set errmethod=2
 . . . . ;s errmethod=$g(filter("errormessagestyle"))
 . . . . ;i errmethod="" s errmethod=$g(errctrl("errorMessageStyle"))
 . . . . ;i errmethod="" set errmethod=1
 . . . . s errmethod=2
 . . . . if errmethod=2 do  ;
 . . . . . n tprevln,uln
 . . . . . s uln=(%j-1)
 . . . . . s tprevln=zhtml(uln)
 . . . . . if tprevln'["fielderror" s tprevln=zhtml(%j-2) s uln=%j-2
 . . . . . do putErrMsg2("zhtml",.tprevln,.errmsg,"errctrl")
 . . . . . set zhtml(uln)=tprevln
 . . . . if errmethod=1 do insError(.tln,.errmsg)
 . . ;
 . . ; end validation
 . . ;
 . . ;w !,tln,!,zhtml(%j),! b
 . . if $get(filter("debug"))>0 do debugFld(.tln,form,name)
 . . s zhtml(%j)=tln
 . i zhtml(%j)["<textarea" d  ;
 . . n val
 . . s val=$g(vals(name))
 . . ;s val=$$URLENC^VPRJRUT(val)
 . . i val'="" d replace(.tln,"</textarea>",val_"</textarea>")
 . . s zhtml(%j)=tln
 . i zhtml(%j)["<select" d  ;
 . . s selectnm=$g(name)
 . i zhtml(%j)["</select" d  ;
 . . s selectnm=""
 . i zhtml(%j)["<option" d  ;
 . . q:selectnm=""
 . . s val=$g(vals(selectnm))
 . . d replace(.tln," selected","") ; unselect
 . . i $g(val)=$g(value) d replace(.tln,"<option ","<option selected ")
 . . if $get(filter("debug"))=2 do debugFld(.tln,form,name)
 . . s zhtml(%j)=tln
 ;D ADDCRLF^VPRJRUT(.zhtml)
 m @rtn=zhtml
 s HTTPRSP("mime")="text/html"
 q
 ;
formLabel(form) ; extrinsic return the label to use for the post url for the form
 new fglb set fglb=$name(^SAMI(311.11))
 new fn set fn=311.11
 new fien set fien=$order(@fglb@("B",form,""))
 q:fien="" ""
 new lbl set lbl=$$GET1^DIQ(fn,fien_",",2.1) ; label to use
 q lbl
 ;
getTemplate(form) ; extrinsic returns the name of the template file
 ;
 new fglb set fglb=$name(^SAMI(311.11))
 new fn set fn=311.11
 if form["-" d  ;
 . s form=$p(form,"-",1)
 . if form="sbform" s form="sbform2"
 new fien set fien=$order(@fglb@("B",form,""))
 q:fien="" ""
 new tnm set tnm=$$GET1^DIQ(fn,fien_",",2) ; name of template
 q tnm
 ;
redactErr(html,err,indx) ; redact an error message section found
 ; in the html. err is the error control array. indx is the current
 ; line in the html
 ; also sets up the error control array
 ;
 new done set done=0
 s @err@("errorSectionBeginLine")=indx
 s @err@("errorMessageStyle")=2 ; errors to the top of page
 f i=indx:1,indx+20 q:done  d  ;
 . i @html@(i)["</div>" s done=1
 . s @html@(i)=""
 . s @err@("errorSectionEndLine")=i
 . i @html@(i)["<tr>" s @err@("currentErrorLine")=i
 . s indx=i
 s @err@("errorCount")=0
 q
 ;
testRedactErr2 ;
 n g s g="<th class=""serv"">Served in the military?<span id=""sbmly-fielderror""><a name=""err-2"" href=""#err-2e""><img src=""see/error.png""/>2</a></span></th>"
 n gg s gg(1)=g
 d redactErr2("gg",1)
 w !,gg(1)
 q
 ;
redactErr2(html,indx) ; redact the error symbol on a field
 i @html@(indx)'["fielderror" quit  ; nothing to replace
 i @html@(indx)["fielderror""></span>" quit  ; nothing to replace
 new ln
 set ln=@html@(indx)
 if $$delText(.ln,"fielderror"">","</span>") s @html@(indx)=ln
 q
 ; 
putErrMsg2(html,lin,msg,err) ; style 2 of error messages - top of screen
 ;
 i $g(err)="" s err="errctrl"
 ;m ^gpl("err")=@err
 n errno s errno=$get(@err@("errorCount"))+1
 s @err@("errorCount")=errno
 n uline s uline=$get(@err@("currentErrorLine"))
 i errno=1 d  ;
 . n bline,eline
 . s bline=$get(@err@("errorSectionBeginLine"))
 . i bline="" quit  ; don't know where to put the section
 . s @html@(bline)="<div class=""errormsg"">"
 . s @html@(bline+1)="<h1>Errors:<h1>"
 . s @html@(bline+2)="<table>"
 . s eline=$get(@err@("errorSectionEndLine"))
 . i eline="" quit  ;
 . s @html@(eline-1)="</table>"
 . s @html@(eline)="</div>"
 . i uline="" s uline=bline+3
 n inserttxt
 s inserttxt="<a name=""err-"_errno_""" href=""#err-"_errno_"e""><img src=""see/error.png""/>"_errno_"</a>"
 d replace(.lin,"fielderror"">","fielderror"">"_inserttxt)
 i $g(uline)="" quit  ; s uline=32 - no uline is found, so nowhere to put the errors
 s @html@(uline)=@html@(uline)_"<tr><td class=""icon""><a name=""err-"_errno_"e"" href=""#err-"_errno_"""><img src=""see/error.png""/>"_errno_"</a></td><td>"_msg_"</td></tr>"
 q
 ;
delText(ln,begin,end,ins) ; delete text between begin and end
 ; and optionally insert ins
 ; ln is passed by reference
 ; begin and end passed by value and are not deleted
 new loc1 s loc1=$find(ln,begin)
 new loc2 s loc2=$find(ln,end)
 new haveins s haveins=0
 if $g(ins)'="" s haveins=1
 else  s ins=""
 s ln=$extract(ln,1,loc1-1)_ins_$extract(ln,loc2-$length(end),$length(ln))
 q 1
 ;
dateFormat(val,form,name)
 new spec s spec=$$getFieldSpec^%wffmap(form,name)
 i spec'["D" q  ; not a date field
 n X,Y
 s X=val
 d ^%DT
 i Y=-1 q  ; invalid date, can't reformat
 n dtmp S dtmp=$$FMTE^XLFDT(Y,"D") ; default exteral date format
 if $l(dtmp)=12 s val=$e(dtmp,5,6)_"/"_$e(dtmp,1,3)_"/"_$e(dtmp,9,12) ; jan 01,1987
 e  s val=dtmp
 i $l(val)=8 s val=$e(val,5,8)
 q
 ;
debugFld(ln,form,name) ;
 n dtxt
 s dtxt="field="_name
 n fary
 d getFieldMap^%wffmap("fary",form,name)
 s dtxt=dtxt_" fmFld="_$g(fary("FILEMAN_FIELD"))
 s dtxt=dtxt_" "_$g(fary("DATA_TYPE"))
 s dtxt=dtxt_" fmTitle: "_$g(fary("TITLE"))
 d insError(.ln,dtxt)
 q
 ;
replaceAll(ln,cur,repl) ; replace all occurances of cur with repl in ln, passed by reference
 new i,t1,t2 s t1=""
 f i=1:1:$l(ln,cur) d  ;
 . s t2(i)=$p(ln,cur,i)
 . if i>1 set t2(i)=repl_$e(t2(i),1,$l(t2(i)))
 ;zwr t2
 f i=1:1:$o(t2(""),-1) set t1=t1_t2(i)
 set ln=t1
 quit
 ;
replace(ln,cur,repl) ; replace current with replacment in line ln
 new where set where=$find(ln,cur)
 quit:where=0 ; this might not work for cur at the end of ln, please test
 set ln=$extract(ln,1,where-$length(cur)-1)_repl_$extract(ln,where,$length(ln))
 quit
 ;
insError(ln,msg) ; inserts an error message into ln, passed by reference
 ;
 new errins set errins="<span class=""alert"" style=""font-size: 0.9em;"">"_msg_"</span>"
 if ln["</input>" do replace(.ln,"</input>","</input>"_errins)  quit  ;
 if ln["/>" do replace(.ln,"/>","/>"_errins)  quit  ;
 if ln[">" s ln=ln_"</input>"_errins
 q
 ;
unvalue(ln) ; sets value=""
 new l1,l2,l3,t1,t2
 set l1=$find(ln,"value=""")
 q:l1=0
 set t1=$extract(ln,1,l1-1)
 set t2=$extract(ln,l1,$l(ln))
 set l3=$find(t2,"""")
 set t2=""""_$extract(t2,l3,$l(t2))
 set ln=t1_t2
 quit
 ;
value(ln,val) ; sets value="@val"
 new loc,end
 set loc=$find(ln,"value=""""")
 if loc=0 do  quit  ;
 . ;if $e(ln,$l(ln))=">" s ln=$e(ln,1,$l(ln)-1)_" value="""_val_""""_">"
 . do replace(.ln,"<input ","<input value="""_val_""" ")
 set end=$extract(ln,loc,$l(ln))
 set ln=$piece(ln,"value=""",1)_"value="""_val_""""_end
 quit
 ;
uncheck(ln) ; removes 'check="checked"' from ln, passed by reference
 if ln["checked=" do  ;
 . do replace(.ln,"checked=""checked""","")
 quit
 ;
check(line,type) ; for radio buttons and checkbox
 new ln set ln=line
 do replace(.line,"type="""_type_"""","type="""_type_"""  checked=""checked""")
 quit
 ;
wsPostForm(ARGS,BODY,RESULT) ; recieve from form
 new %json,form,sid,body,tbdy
 set form=$get(ARGS("form"))
 set sid=$get(ARGS("studyid"))
 set body=$get(BODY(1))
 if form="" set form="sbform"
 if sid="" set sid="XXXX17"
 quit:form=""
 quit:sid=""
 set %json(sid,form,"form")=form
 do parseBody("tbdy",.body)
 merge %json(sid,form)=tbdy
 new gr set gr=$$setroot^%wd("elcap-patients")
 merge @gr@("graph")=%json
 ;
 ; validation process
 ;
 new errflag set errflag=0
 new revise
 do wsGetForm(.revise,.ARGS,1)
 if form'="sbform2" if errflag'=0 do  quit  ;
 . merge RESULT=revise
 ;
 ; end validation process
 ;
 ; no errors, file it into fileman

 new status
 do fileForm^%wffiler("tbdy",form,sid,"status")
 ;
 ; now return the fileman record that was created
 new fman,fien
 s fien=$order(^SAMI(311.102,"B",sid,""))
 q:fien=""
 d fmx^%sfv2g("fman",311.102,fien)
 m fman=status
 m fman(form)=tbdy
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
 quit
 ;
parseBody(rtn,body) ; parse the variables sent by a form
 ; rtn is passed by name
 new ii set ii=""
 if '$data(body) set body=$get(^gpl("sami","body",1))
 quit:'$data(body)
 new tmp set tmp=body
 kill @rtn
 for ii=1:1:$length(tmp,"&") d  ;
 . new ij
 . set ij=$piece(tmp,"&",ii)
 . quit:ij=""
 . set @rtn@($piece(ij,"=",1))=$$URLDEC^VPRJRUT($piece(ij,"=",2))
 quit
 ;
getVals(vrtn,zid,zsid) ; get the values for the form from the graph
 new root set root=$$setroot^%wd("elcap-patients")
 if '$data(@root@("graph",zsid,zid)) quit  ;
 merge @vrtn=@root@("graph",zsid,zid)
 quit
 ;
setVals(vary,zid,zsid) ; set the values returned from form id for patient zsid
 new root set root=$$setroot^%wd("elcap-patients")
 if zsid="XXXX01" do  quit  ; the sample set
 . new src set src=$$setroot^%wd("elcapSampleJson")
 . if '$data(@src@(zid)) quit  ; no such form
 . merge @root@("graph",zsid,zid)=@src@(zid)
 kill @root@("graph",zsid,zid)
 merge @root@("graph",zsid,zid)=@vary
 quit
 ;
validate(value,spec,map,msg) ; extrinsic returns 1 if valid 0 if not valid
 ; value is passed by value and is the string being validated
 ; spec is passed by value and is the fileman spec which defines the validation
 ;   examples include: FJ30  D  N5.2
 ; map is passed by name and is the field mapping entry for the variable
 ; map is optional
 ; msg is passed by reference and can contain on return a custom error message
 ;
 ;if $g(spec)="" quit 0  ; everything is invalid with no spec
 ;if $g(spec)="" quit 1  ; everything is valid with no spec
 if $g(spec)="" s spec="FJ30" ; make it free text to weed out bad characters
 ;
 ;new valrtn s valrtn
 ;if $g(@map@("VALIDATOR"))'="" d  q valrtn  ; call a custom validator
 ;. add code to call the custom validator here
 ;
 if spec["S" quit 1  ; all set of codes are valid - let fileman check them
 ;
 if spec["D" quit $$dateValid(value,spec,$get(map),.msg) ; validate a date
 ;
 if spec["F" quit $$textValid(value,spec,$get(map)) ; validate free text field
 ;
 if spec["N" quit $$numValid(value,spec,$get(map)) ; validate a numeric value
 ;
 quit 0  ; what else is there? assume it is invalid
 ;
dateValid(value,spec,map,msg) ; extrinsic which validates a date
 ; returns 1 if valid 0 if invalid
 ; uses fileman date validation routines
 ;
 n X,Y
 set X=value
 do ^%DT
 if Y=-1 quit 0
 quit 1
 ;
textValid(value,spec,map) ; validate a free text field
 ; returns 1 if valid 0 if invalid
 ; uses mumps pattern matching
 ;
 if spec'["F" quit 0  ; not a text field
 ;
 new min,max,x,specn
 set specn=+$translate(spec,"FJX ","") ; gets rid of the alphabetics 
 if specn["." d  ; there is a minimum and maximum
 . set min=$piece(specn,".",1)
 . set max=$piece(specn,".",2)
 . set x="value?"_min_"."_max_"LUNP"
 else  d  ; no minimum
 . set x="value?."_specn_"LUNP"
 ;w !,x
 if @x quit 1
 quit 0
 ;
numValid(value,spec,map) ; validate a numeric field
 ; returns 1 if valid 0 if invalid
 ; uses mumps pattern matching, handles decimal points
 ;
 if spec'["N" quit 0  ; not a numeric field
 new left,right,x,specn
 set specn=$translate(spec,"NJX ","") ; gets rid of the alphabetics 
 n result s result=1 ; assume valid
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
 else  d  ; no right of decimal point
 . set x="value?."_specn_"N"
 w !,x
 if @x quit 1
 quit 0
 ;
replaceSrc(ln) ; do replacements on lines for src= to use the see service to locate
 ; the resource. extrinsic returns true if replacement was done
 ; not currently used - the changes are included in the template
 new done set done=0
 if ln["src=" do  ; 
 . do replaceAll(.ln,"src=""","src=""see/")
 . set done=1
 if ln["href=" do  ; 
 . if ln["href=""#" quit  ;
 . if ln["href=""javascript" quit  ;
 . do replaceAll(.ln,"href=""","href=""see/")
 . set done=1
 quit done
 ;
replaceHref(ln) ; do replacements on html lines for href values; extrinsic returns true if 
 ; replacement was done - depricated, use replaceSrc instead, if needed
 n conds,done
 s done=0
 s conds("""sami.css""")="""resources/sami/sami.css"""
 s conds("""sami.js""")="""resources/sami/sami.js"""
 s conds("""sami2.js""")="""resources/sami/sami2.js"""
 s conds("""jquery-3.2.1.min.js""")="""resources/sami/jquery-3.2.1.min.js"""
 s conds("""jquery-ui.min.js""")="""resources/sami/jquery-ui.min.js"""
 n %ig s %ig=""
 f  s %ig=$o(conds(%ig)) q:%ig=""  d  ;
 . i ln[%ig d  ;
 . . d replace(.ln,%ig,$g(conds(%ig)))
 . . s done=1
 q done
 ;
