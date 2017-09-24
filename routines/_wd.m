%wd	;ven/gpl - mash graph utilities ; 9/24/17 4:33pm
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
csv2graph(source,graph) ; import a csv file to a graph
 ; graph is optional, will default to csvGraph
 ; source is either a filename which will be found in seeGraph
 ; or a global passed by name usually loaded with FTG^%ZISH
 ;
 new %wary,%wi,%wgraph
 if $extract(source,1)="^" m %wary=@$name(source)
 else  do getThis("%wary",source)
 new delim s delim=$$delim(.%wary)
 if delim=-1 d  q  ;
 . write !,"error, delimiter not found"
 if '$$wellformed(.ary,delim) do  quit  ;
 . write !,"error, csv file not well formed delimiter="_delim
 new %wgraph,%wcol,%wid ; place to store the graph and the id of the graph
 ; %wcol contains the column names in order
 set %wid=$$nameThis(source) ; get the id from the context
 ; first get the column names from row 1
 for %wi=1:1:$length(%wary(1),delim) set %wcol(%wi)=$piece(%wary(1),delim,%wi)
 set %wi=1
 for  set %wi=$order(%wary(%wi)) q:+%wi=0  do  ;
 . new %wj
 . w !,%wary(%wi)
 . for %wj=1:1:$length(%wary(%wi),delim) do  ;
 . . new %wval set %wval=$piece(%wary(%wi),delim,%wj)
 . . if %wval'="" set %wgraph(%wid,%wi,%wcol(%wj),%wval)=""
 break
 quit
 ;
delim(ary) ; figures out the cvs delimiter
 ; return -1 if there not found
 ; ary is passed by reference
 ; returns the delimiter
 new %wdlim,%wfound,%return s %wfound=0
 for %wdlim=$c(9),",","|" q:%wfound  do  ; for each common delimiter
 . new %count s %count=$length(ary(1),%wdlim) ; how many in line 1
 . if %count<2 q  ;
 . if $length(ary(2),%wdlim)=%count s %wfound=1 s %return=%wdlim
 . if $data(ary(3)) if $length(ary(3),%wdlim)='%count s %wfound=0 kill %return
 . if $data(ary(4)) if $length(ary(4),%wdlim)='%count s %wfound=0 kill %return
 if %wfound=0 q -1
 q %return
 ;
wellformed(ary,delim) ; extrinsic returns 1 if ary is well formed
 ; checks to see that the count of the delimiter is the same
 ; on every line
 ; ary is passed by reference
 ;
 new %wi,%count,%result set %wi=0 set %result=1
 for  set %wi=$order(ary(%wi)) quit:+%wi=0  do  ;
 . if '$data(%count) set %count=$length(ary(%wi),delmin) quit  ;
 . if $length(ary(%wi))'=%count set %result=0
 quit %result
 ;
nameThis(altname) ; returns the id to be used for altname
 ; this will eventually use the context graph and the 
 ; local variable context to query the altname and obtain an id
 new result
 if $data(context) set result=$$queryContext(context,"id",altname) q result
 if altname="background-dd-map" set result="sbform" quit result
 quit altname
 ;
getThis(rary,fn,nocache) ; find a file and read it into rary array  
 n ary
 if '$g(nocache) d fromCache("ary",fn)
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
 if '$g(nocache) d toCache(tmp,fn,"html-cache")
 m @rary=@tmp
 k @tmp
 q
 ;
queryContext(context,pred,obj) ; look up project specific 
 ; names and values from the context graph
 ; tbd
 q obj
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
