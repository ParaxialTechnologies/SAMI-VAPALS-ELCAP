%wdgrtrans        ;ven/gpl - mash graph utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ; 2019-05-28 ven/lgc call to ^%WC changed to ^%webcurl
 ;
 q
 ;
 ; All the public entry points for these routines are found in %wd
 ;
wsPutGraph(ARG,BODY,RESULT) ; POST web service which takes in and stores a graph
 n zgraph s zgraph=$g(ARG("graph"))
 i zgraph="" s zgraph="misc-graph"
 ;
 ; determine which graph
 ;
 n root s root=$$setroot^%wd(zgraph)
 ; 
 ; parse the json
 ;
 n tbdy
 d DECODE^VPRJSON("BODY","tbdy")
 ;
 ; find the ids of the graph
 ;
 n id1,id2
 s id1=$g(ARG("id"))
 s id2=$g(ARG("id2"))
 ;
 ; find where in the graph to put incoming
 ;
 n ien,rien s (ien,rien)=""
 ;
 i id1="" s ien=$o(@root@(" "),-1)+1
 i id1'="" d  ;
 . s ien=$o(@root@("B",id1,""))
 . i ien="" d  q  ;
 . . s ien=$o(@root@(" "),-1)+1
 . i id2'="" d  ;
 . . s rien=$o(@root@(ien,""),-1)+1
 ;
 ; merge to the graph
 ;
 set HTTPRSP("mime")="application/json"
 n rslt,prefix
 s prefix=$o(tbdy(""))
 i id1="" d  q  ; no index provided, merge to root
 . ;m @root=tbdy(prefix)
 . m @root=tbdy
 . s rslt("result","status")="ok"
 . s rslt("result","graph")=zgraph
 . s rslt("result","ien")=""
 . d ENCODE^VPRJSON("rslt","RESULT")
 ;
 i id2="" d  q  ; index found but no secondary index
 . ;m @root@(ien)=tbdy(prefix)
 . m @root@(ien)=tbdy
 . s @root@("B",id1,ien)=""
 . s rslt("result","status")="ok"
 . s rslt("result","graph")=zgraph
 . s rslt("result","ien")=ien
 . d ENCODE^VPRJSON("rslt","RESULT")
 ;
 d  q  ; index and secondary index found
 . ;m @root@(ien,rien)=tbdy(prefix)
 . m @root@(ien,rien)=tbdy
 . s @root@("B",id1,ien)=""
 . s @root@(ien,"B",id2,rien)=""
 . s rslt("result","status")="ok"
 . s rslt("result","graph")=zgraph
 . s rslt("result","ien")=ien
  . s rslt("result","rien")=rien
 . d ENCODE^VPRJSON("rslt","RESULT")
 ;
 q
 ;
wsGetGraph(rtn,filter) ; web service to retieve a graph
 n zgraph s zgraph=$g(ARG("graph"))
 i zgraph="" s zgraph="misc-graph"
 ;
 ; determine which graph
 ;
 n root s root=$$setroot^%wd(zgraph)
 n grshape
 d grokGraph(.grshape,root)
 ;
 ; find the ids of the graph
 ;
 n id1,id2
 s id1=$g(ARG("id"))
 s id2=$g(ARG("id2"))
 ;
 ; locate the graph
 ;
 n ien,rien s (ien,rien)=""
 ;
 i id1'="" d  ;
 . s ien=$o(@root@("B",id1,""))
 . q:ien=""
 . ;s rien=$o(
 q
 ;
grokGraph(shape,groot,recalc) ; detect the shape of the graph
 ; if recalc is 1, the shape will be recalculated and stored in the graph
 i $d(@groot@("shape")) d  q  ; graph has a shape section
 . m shape=@groot@("shape")
 ;
 q
 ;
remoteGraph(url,graph) ; download a graph from url and create graph
 ;
 n %,json
 s %=$$%^%webcurl(.json,"GET",url)
 ;
 i '$d(graph) s graph="remoteGraph"
 n root s root=$$setroot^%wd(graph)
 ;
 d DECODE^VPRJSON("json",root)
 q
 ;
getOS5 ; get the latest OS5 graph
 n url
 s url="http://syn.vistaplex.org/os5?format=json"
 d remoteGraph(url,"OS5codes")
 q
 ;
