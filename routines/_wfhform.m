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
 . . s zhtml(%j)="<form action=""postform?form="_id_"&studyId="_sid_""" method=""POST"" id=""backgroundForm"">"
 . i $$replaceHref(.tln) s zhtml(%j)=tln ; fix the css and js href values
 . i zhtml(%j)["input" d  ;
 . . i $l(zhtml(%j),"<input")>2 d  ; got to split the lines
 . . . n zgt,zgn s zgt=zhtml(%j)
 . . . s zgn=$f(zgt,"<input",$f(zgt,"<input"))
 . . . s zhtml(%j+.5)=$e(zgt,zgn-6,$l(zgt))
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
 . . ;w !,tln,!,zhtml(%j),! b
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
 new root set root=$$setroot("elcap-patients")
 if zsid="XXXX01" do  quit  ; the sample set
 . new src set src=$$setroot("elcapSampleJson")
 . if '$data(@src@(zid)) quit  ; no such form
 . merge @root@("graph",zsid,zid)=@src@(zid)
 merge @root@("graph",zsid,zid)=@vary
 quit
 ;
initforms ; initialize sami forms
 n root s root=$$setroot("elcapSampleJson")
 n %i s %i=""
 f  s %i=$o(@root@(%i)) q:%i=""  d  ;
 . i %i="B" q
 . i %i=0 q
 . n vars
 . m vars=@root@(%i)
 . ;b
 . d initform1(%i,"vars") 
 q
 ;
initform1(id,ary) ; initialize one form named id from ary passed by name
 n fn s fn=17.040201 ; file number
 n sfn s sfn=17.402011 ; subfile number for variables
 n fmroot s fmroot=$na(^%wf(17.040201))
 n fda,%yerr
 s fda(fn,"?+1,",.01)=id
 w !,"creating form ",id
 d UPDATE^DIE("","fda","","%yerr")
 i $d(%yerr) d  q  ;
 . w !,"error creating form record ",id,!
 . zwr %yerr
 n %ien s %ien=$o(@fmroot@("B",id,""))
 i %ien="" d  q  ;
 . w !,"error locating form record ",id
 n %j s %j=""
 n vcnt s vcnt=0
 k fda
 f  s %j=$o(@ary@(%j)) q:%j=""  d  ;
 . s vcnt=vcnt+1
 . s fda(sfn,"?+"_vcnt_","_%ien_",",.01)=%j
 d CLEAN^DILF
 w !,"creating variables for form ",%ien
 d UPDATE^DIE("","fda","","%yerr")
 i $d(%yerr) d  q  ;
 . w !,"error creating variable record ",%j,!
 . zwr %yerr
 q
 ;
