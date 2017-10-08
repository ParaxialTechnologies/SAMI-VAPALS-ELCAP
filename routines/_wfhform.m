%wfhform	;ven/gpl - mash forms utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
 ; All the public entry points for forms are in %wf
 ;
wsGetForm(rtn,filter) ; return the html for the form id, passed in filter
 ; filter("form")=id
 ; filter("studyId")=studyId
 s rtn=$na(^TMP("yottaForm",$J))
 k @rtn
 n id s id=$g(filter("form"))
 i id="" s id="sbform"
 n sid s sid=$g(filter("studyid"))
 i sid="" s sid="XXXX01"
 n vals
 d getVals("vals",id,sid)
 n fn
 i id="sbform" s fn="elcap-background-form.html"
 i fn="" s fn="elcap-background-form.html"
 n zhtml
 d getThis^%wd("zhtml",fn)
 i '$d(zhtml) q  ;
 n name,value,selectnm
 s selectnm="" ; name of select variable, which spans options
 n %j s %j=""
 f  s %j=$o(zhtml(%j)) q:%j=""  d  ;
 . n tln s tln=zhtml(%j)
 . i tln["submit" q  ;
 . i tln["hidden" q  ;
 . s (name,value)=""
 . i zhtml(%j)["name=" d  ;
 . . s name=$p($p(zhtml(%j),"name=""",2),"""",1)
 . . ;w !,"found name ",name
 . i zhtml(%j)["value=" d  ;
 . . s value=$p($p(zhtml(%j),"value=""",2),"""",1)
 . i zhtml(%j)["*sbsid*" d  ;
 . . s zhtml(%j)=$p(tln,"*sbsid*",1)_sid_$p(tln,"*sbsid*",2)
 . i zhtml(%j)["action=" d  ;
 . . ;s zhtml(%j)="<form action=""http://vendev.vistaplex.org:9080/postform?form="_id_"&studyId="_sid_""" method=""POST"" id=""backgroundForm"">"
 . . s zhtml(%j)="<form action=""form?form="_id_"&studyId="_sid_""" method=""POST"" id=""backgroundForm"">"
 . i $$replaceHref(.tln) s zhtml(%j)=tln ; fix the css and js href values
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
 . . . s zhtml(%j)=tln
 . . d unvalue(.tln)
 . . ;s val=$$URLENC^VPRJRUT(val)
 . . f  d replace^%yottaq(.val,"""","&quot;") q:val'[""""
 . . d value(.tln,val)
 . . ;
 . . ; validation starts here
 . . ;
 . . new spec,errmsg set spec=$$getFieldSpec^%wffmap(id,name)
 . . set errmsg="Input invalid"
 . . if val'="" do  ;
 . . . if $$validate(val,spec,,.errmsg)<1 do  ;
 . . . . set errflag=1
 . . . . do insError(.tln,.errmsg)
 . . ;
 . . ; end validation
 . . ;
 . . ;w !,tln,!,zhtml(%j),! b
 . . if $get(filter("debug"))=1 do insError(.tln,"field="_name)
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
 . . i $g(val)=$g(value) d replace(.tln,">"," selected>")
 . . s zhtml(%j)=tln
 D ADDCRLF^VPRJRUT(.zhtml)
 m @rtn=zhtml
 s HTTPRSP("mime")="text/html"
 q
 ;
replaceHref(ln) ; do replacements on html lines for href values; extrinsic returns true if 
 ; replacement was done
 n conds,done
 s done=0
 s conds("""sami.css""")="""resources/sami/sami.css"""
 s conds("""sami.js""")="""resources/sami/sami.js"""
 n %ig s %ig=""
 f  s %ig=$o(conds(%ig)) q:%ig=""  d  ;
 . i ln[%ig d  ;
 . . d replace(.ln,%ig,$g(conds(%ig)))
 . . s done=1
 q done
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
 do replace(.ln,"</input>","</input>"_errins)
 q
 ;
unvalue(ln) ; sets value=""
 new l1,l2,l3,t1,t2
 set l1=$find(ln,"value=""")
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
 do wsGetForm(.revise,.ARGS)
 if errflag'=0 do  quit  ;
 . merge RESULT=revise
 ;
 ; end validation process
 ;
 new tjson
 do ENCODE^VPRJSON("%json","tjson")
 do beautify^%wd("tjson","RESULT")
 DO ADDCRLF^VPRJRUT(.RESULT)
 set HTTPRSP("mime")="application/json"
 kill ^gpl("sami")
 merge ^gpl("sami","args")=ARGS
 merge ^gpl("sami","body")=BODY
 merge ^gpl("sami","json")=%json
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
 if $g(spec)="" quit 0  ; everything is invalid with no spec
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
