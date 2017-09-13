yottaq	;gpl - agile web server ; 2/27/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
setroot(graph) ; root of working storage
 n %y s %y=$o(^%wd(17.040801,"B",graph,""))
 i %y="" s %y=$$addgraph(graph) ; if graph is not present, add it
 q $na(^%wd(17.040801,%y)) ; root for graph
 ;
addgraph(graph) ; makes a place in the graph file for a new graph
 n fda s fda(17.040801,"?+1,",.01)=graph
 n %yerr
 d UPDATE^DIE("","fda","","%yerr")
 n %y s %y=$o(^%wd(17.040801,"B",graph,""))
 q %y
 ;
delgraph(graph) ; delete a graph
 n %y s %y=$o(^%wd(17.040801,"B",graph,""))
 i %y="" q 0
 n fda s fda(17.040801,%y_",",.01)="@"
 n %yerr
 d UPDATE^DIE("","fda","","%yerr")
 i '$d(%yerr) q 1
 zwr %yerr
 q 0 
 ;
queryTag(rtn,tag) ; returns a json/mumps array of tagged items
 n graph s graph="seeGraph"
 k @rtn
 n root s root=$$setroot(graph)
 n groot s groot=$na(@root@("graph"))
 i '$d(@groot@("pos","tag",tag)) q
 n x1,y1 s (x1,y1)=""
 n cnt s cnt=0
 f  s x1=$o(@groot@("pos","tag",tag,x1)) q:x1=""  d  ;
 . f  s y1=$o(@groot@("pos","tag",tag,x1,y1)) q:y1=""  d  ;
 . . s cnt=cnt+1
 . . m @rtn@(cnt)=@groot@(x1,y1)
 q
 ;
queryPred(rtn,pred) ; returns a json/mumps array of tagged items
 n graph s graph="seeGraph"
 k @rtn
 n root s root=$$setroot(graph)
 n groot s groot=$na(@root@("graph"))
 i '$d(@groot@("pos",pred)) q
 n obj,x1,y1 s (obj,x1,y1)=""
 n cnt s cnt=0
 f  s obj=$o(@groot@("pos",pred,obj)) q:obj=""  d  ;
 . f  s x1=$o(@groot@("pos",pred,obj,x1)) q:x1=""  d  ;
 . . f  s y1=$o(@groot@("pos",pred,obj,x1,y1)) q:y1=""  d  ;
 . . . s cnt=cnt+1
 . . . s @rtn@(cnt,obj,x1,y1)=""
 q
 ;
importsami ; import sami sample json
 n root s root=$$setroot("elcapSampleJson")
 n ii,%i s %i=""
 s ii("ceform3","ceform-20142105.json")=""
 s ii("fuform","fuform-20142105.json")=""
 s ii("sbform","sbform-20130101.json")=""
 s ii("bxform","bxform-20132802.json")=""
 s ii("ceform","ceform-20130101.json")=""
 s ii("rbform","rbform-20130104.json")=""
 s ii("ceform2","ceform-20131510.json")=""
 s ii("ptform","ptform-20130802.json")=""
 s ii("siform","siform-20122408.json")=""
 f  s %i=$o(ii(%i)) q:%i=""  d  ;
 . n %ii s %ii=$o(ii(%i,""))
 . d impsami1(root,%i,%ii)
 q
 ;
impsami1(root,id,fn) ;
 n vtmp
 d getThis("vtmp",fn)
 n dest s dest=$na(@root@(id))
 n tmpdest
 d DECODE^VPRJSON("vtmp","tmpdest")
 m @dest=tmpdest
 s @root@("B",id)=""
 q
 ;
fromCache(rary,name,graph) ; return a file from the cache
 i '$d(graph) s graph="html-cache"
 n zgn s zgn=$$setroot(graph)
 q:'$d(@zgn@("graph","B",name))
 n zien s zien=$o(@zgn@("graph","B",name,""))
 q:zien=""
 m @rary=@zgn@("graph",zien)
 q
 ;
toCache(arry,name,graph) ; put a file in the cache
 i '$d(graph) s graph="html-cache"
 n zgn s zgn=$$setroot(graph)
 n zien
 i $d(@zgn@("graph","B",name)) d  ;
 . s zien=$o(@zgn@("graph","B",name,""))
 . k @zgn@("graph",zien)
 . k @zgn@("graph","B",name,zien)
 i $g(zien)="" d  ;
 . s zien=$o(@zgn@("graph"," "),-1)+1
 m @zgn@("graph",zien)=@arry
 s @zgn@("graph","B",name,zien)=""
 q
 ;
getThis(rary,fn) ; find a file and read it into rary array  
 n ary
 d fromCache("ary",fn)
 i $d(ary) d  q  ;
 . m @rary=ary
 d queryTag("ary",fn)
 i '$d(ary) d  q  ;
 . w !,"error retrieving array ",fn
 n file s file=$o(ary(1,"file",""))
 n dir s dir=$o(ary(1,"localdir",""))_"/"
 n tmp s tmp=$na(^TMP("yottawrk",$J))
 k @tmp
 n tmp1 s tmp1=$na(@tmp@(1))
 n ok s ok=$$FTG^%ZISH(dir,file,tmp1,3)
 i 'ok d  q  ;
 . w !,"error loading file ",dir_file
 d toCache(tmp,fn,"html-cache")
 m @rary=@tmp
 k @tmp
 q
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
tagyn(tag,ien1,ien2) ; extrinsic returns 1 if the item is tagged with tag
 n gn s gn=$na(^%wd(17.020801,1,"graph",ien1,ien2,"tag"))
 i $d(@gn@(tag)) q 1
 q 0
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
 d getThis("zhtml",fn)
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
 . . d value(.tln,val)
 . . ;w !,tln,!,zhtml(%j),! b
 . . s zhtml(%j)=tln
 . i zhtml(%j)["<textarea" d  ;
 . . n val
 . . s val=$g(vals(name))
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
 n where s where=$f(ln,cur)
 q:where=0 ; this might not work for cur at the end of ln, please test
 s ln=$e(ln,1,where-$l(cur)-1)_repl_$e(ln,where,$l(ln))
 q
 ;
unvalue(ln) ; sets value=""
 n l1,l2,l3,t1,t2
 s l1=$f(ln,"value=""")
 s t1=$e(ln,1,l1-1)
 s t2=$e(ln,l1,$l(ln))
 s l3=$f(t2,"""")
 s t2=""""_$e(t2,l3,$l(t2))
 s ln=t1_t2
 ;n rmv s rmv=$p($p(ln,"value=""",2),"""",1)
 ;s ln=$p(ln,"value=""",1)_"value="""_$p(ln,rmv,2)
 q
 ;
value(ln,val) ; sets value="@val"
 n loc,end
 s loc=$f(ln,"value=""""")
 s end=$e(ln,loc,$l(ln))
 s ln=$p(ln,"value=""",1)_"value="""_val_""""_end
 q
 ;
uncheck(ln) ; removes 'check="checked"' from ln, passed by reference
 i ln["checked=" d  ;
 . d replace(.ln,"checked=""checked""","")
 . ;n loc s loc=$f(ln,"checked=""checked""")
 . ;s ln=$p(ln,"checked=",1)_">"_$e(ln,loc,$l(ln))
 q
 ;
check(line,type) ; for radio buttons and checkbox
 n ln s ln=line
 d replace(.line,"type="""_type_"""","type="""_type_"""  checked=""checked""")
 ;n end
 ;s end=">"_$e(ln,$f(ln,">"),$l(ln))
 ;i ln'["checked" s line=$p(ln,">",1)_" checked=""checked"""_end
 q
 ;
wsPostForm(ARGS,BODY,RESULT) ; recieve from form
 n %json,form,sid,body,tbdy
 s form=$g(ARGS("form"))
 s sid=$g(ARGS("studyid"))
 s body=$g(BODY(1))
 i form="" s form="sbform"
 i sid="" s sid="XXXX17"
 q:form=""
 q:sid=""
 ;i body="" s body=$g(^gpl("sami","body",1))
 ;q:body=""
 s %json(sid,form,"form")=form
 d parseBody("tbdy",.body)
 m %json(sid,form)=tbdy
 n gr s gr=$$setroot("elcap-patients")
 m @gr@("graph")=%json
 n tjson
 d ENCODE^VPRJSON("%json","tjson")
 d beautify("tjson","RESULT")
 D ADDCRLF^VPRJRUT(.RESULT)
 s HTTPRSP("mime")="application/json"
 k ^gpl("sami")
 m ^gpl("sami","args")=ARGS
 m ^gpl("sami","body")=BODY
 m ^gpl("sami","json")=%json
 q
 ;
parseBody(rtn,body) ; parse the variables sent by a form
 ; rtn is passed by name
 n ii s ii=""
 i '$d(body) s body=$g(^gpl("sami","body",1))
 q:'$d(body)
 n tmp s tmp=body
 s tmp=$$URLDEC^VPRJRUT(tmp)
 k @rtn
 f ii=1:1:$l(tmp,"&") d  ;
 . n ij
 . s ij=$p(tmp,"&",ii)
 . s @rtn@($p(ij,"=",1))=$p(ij,"=",2)
 q
 ;
getVals(vrtn,zid,zsid) ; get the values for the form from the graph
 n root s root=$$setroot("elcap-patients")
 i '$d(@root@("graph",zsid,zid)) q  ;
 m @vrtn=@root@("graph",zsid,zid)
 q
 ;
setVals(vary,zid,zsid) ; set the values returned from form id for patient zsid
 n root s root=$$setroot("elcap-patients")
 i zsid="XXXX01" d  q  ; the sample set
 . n src s src=$$setroot("elcapSampleJson")
 . i '$d(@src@(zid)) q  ; no such form
 . m @root@("graph",zsid,zid)=@src@(zid)
 m @root@("graph",zsid,zid)=@vary
 q
 ;
scanall ; 
 n gn s gn=$na(^%wd(17.020801,1,"graph","pos","id"))
 n zid,zi,zj
 s (zid,zi,zj)=""
 f  s zid=$o(@gn@(zid)) q:zid=""  d  ;
 . i $re($p($re(zid),"."))'="xml" q  ; 
 . s zi=$o(@gn@(zid,""))
 . s zj=$o(@gn@(zid,zi,""))
 . q:zj=""
 . q:$$tagyn("scanned",zi,zj)
 . n contents
 . w !,"scanning ",zid
 . d scan^%yottagr(.contents,zid,zi,zj)
 . d addtag^%yottagr("scanned",zi,zj)
 q
 ;
beautify(inary,outary) ; pretty print a line of json
 ;d ary2file(inary,^%WHOME,"json.json")
 n zg,zi s (zg,zi)=""
 f  s zi=$o(@inary@(zi)) q:zi=""  s zg=zg_@inary@(zi)
 d ary2file("zg",^%WHOME,"json.json")
 zsy "python -m json.tool "_^%WHOME_"json.json > "_^%WHOME_"pretty-json.json"
 d file2ary(outary,^%WHOME,"pretty-json.json")
 q
 ;
ary2file(ary,dir,file) ;
 n tmp s tmp=$na(^TMP("yottawrk",$J))
 k @tmp
 i '$d(@ary@(1)) d  ; not really an array
 . i $g(@ary)="" q ; not a string either
 . m @tmp@(1)=@ary ; input was a string
 e   m @tmp=@ary
 n tmp1 s tmp1=$na(@tmp@(1))
 n ok s ok=$$GTF^%ZISH(tmp1,3,dir,file)
 i 'ok d  q  ;
 . w !,"error saving file ",dir_file
 q
 ;
file2ary(ary,dir,file)
 n tmp s tmp=$na(^TMP("yottawrk",$J))
 k @tmp
 n tmp1 s tmp1=$na(@tmp@(1))
 n ok s ok=$$FTG^%ZISH(dir,file,tmp1,3)
 i 'ok d  q  ;
 . w !,"error loading file ",dir_file
 m @ary=@tmp
 k @tmp
 q
 ;
