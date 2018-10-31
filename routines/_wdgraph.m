%wdgraph ;ven/gpl-write dialog: graphstore ;2018-03-07T18:47Z
 ;;1.8;Mash;
 ;
 ; %wdgraph implements the Write Document Library's ppis & apis. At
 ; present, these are all graphstore-format dataset methods, which
 ; will eventually be moved to the %sfg namespace. Mash's primary
 ; dataset format is the graphstore.
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
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
 ;@last-updated: 2018-03-07T18:47Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Write Dialog - %wd
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@module-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017, gpl
 ;@funding: 2017, ven
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log
 ; 2017-09-24 ven/gpl %*1.8t01 %wdgraph: create routine to hold
 ; all graphstore methods.
 ;
 ; 2018-02-06 ven/toad %*1.8t04 %wdgraph: passim add white space &
 ; hdr comments, tag w/Apache license & attribution & to-do to shift
 ; to %sf later.
 ;
 ; 2018-03-07 ven/toad %*1.8t04 %wdgraph: in setroot add header.
 ;
 ;@to-do
 ; %wd: convert entry points to ppi/api style
 ; r/all local calls w/calls through ^%wd
 ; break up into smaller routines & change branches from %wd
 ; renamespace under %sfg
 ;
 ;@contents
 ; [too big, break up]
 ;
 ;
 ;
 ;@section 1 code to implement ppis & apis
 ;
 ;
 ;
setroot(graph) ; root of working storage
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; $$setroot^%wd
 ; $$field2Var^%wffiler
 ; initFmap^%wffmap
 ; $$getFmapGlb^%wffmap
 ; getVals^%wfhform
 ; setVals^%wfhform
 ; wsPostForm^%wfhform
 ; queryPred^%yottaq
 ; importsami^%yottaq
 ; wsCASE^SAMICASE
 ; getItems^SAMICASE
 ; wsNuForm^SAMICASE
 ; makeCeform^SAMICASE
 ; INITFRMS^SAMIFRM
 ; loadData^SAMIFRM
 ; patlist^SAMIHOME
 ; wsNewCase^SAMIHOME
 ; nextNum^SAMIHOME
 ; prefill^SAMIHOME
 ; makeSbform^SAMIHOME
 ; makeSiform^SAMIHOME
 ; wsLookup^SAMISRCH
 ;@calls
 ; $$addgraph
 ;@input
 ; graph = name of graph
 ;@output = root for graph's working storage
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 calculate graph's root
 ;
 new %y set %y=$order(^%wd(17.040801,"B",graph,""))
 if %y="" set %y=$$addgraph(graph) ; if graph is not present, add it
 new root set root=$name(^%wd(17.040801,%y)) ; root for graph
 ;
 ;@stanza 3 return & termination
 ;
 quit root ; return root; end of $$setroot^%wd
 ;
 ;
 ;
rootOf(graph) ; return the root of graph named graph
 ;
 new %x1 set %x1=$order(^%wd(17.040801,"B",graph,""))
 if %x1="" quit -1
 ;
 quit $name(^%wd(17.040801,%x1,"graph")) ; end of rootOf^%wd
 ;
 ;
 ;
addgraph(graph) ; makes a place in the graph file for a new graph
 ;
 new fda set fda(17.040801,"?+1,",.01)=graph
 new %yerr
 do UPDATE^DIE("","fda","","%yerr")
 new %y set %y=$order(^%wd(17.040801,"B",graph,""))
 ;
 quit %y ; end of $$addgraph^%wd
 ;
 ;
 ;
purgegraph(graph) ; delete a graph
 ;
 new %y set %y=$order(^%wd(17.040801,"B",graph,""))
 if %y="" quit 0
 new fda set fda(17.040801,%y_",",.01)="@"
 new %yerr
 do UPDATE^DIE("","fda","","%yerr")
 if '$data(%yerr) quit 1
 zwrite %yerr
 ;
 quit 0 ; end of $$purgegraph^%wd
 ;
 ;
 ;
insert2graph(ary,graph,replace) ; insert a new entry to a graph
 ;
 ; ary is passed by name, graph is the name of the graph
 ; if replace=1 the graph will be killed first before merge
 ;
 new root set root=$$setroot(graph)
 new groot set groot=$name(@root@("graph"))
 new id set id=$order(@ary@(""))
 if replace=1 kill @groot@(id) 
 merge @groot=@ary
 ;
 quit  ; end of insert2graph^%wd
 ;
 ;
 ;
nameThis(altname) ; returns the id to be used for altname
 ;
 ; this will eventually use the context graph and the 
 ; local variable context to query the altname and obtain an id
 ;
 new result
 if $data(context) set result=$$queryContext(context,"id",altname) quit result
 if altname="background-dd-map" set result="sbform" quit result
 ;
 quit altname ; end of $$nameThis^%wd
 ;
 ;
 ;
getThis(rary,fn,nocache) ; find a file and read it into rary array
 ;
 new ary
 if '$get(nocache) do fromCache("ary",fn)
 if $data(ary) do  quit  ;
 . merge @rary=ary
 . quit
 do queryTag("ary",fn)
 if '$data(ary) do  quit  ;
 . write !,"error retrieving array ",fn
 . quit
 new file set file=$order(ary(1,"file",""))
 new dir set dir=$order(ary(1,"localdir",""))_"/"
 new tmp set tmp=$name(^TMP("yottawrk",$J))
 kill @tmp
 new tmp1 set tmp1=$name(@tmp@(1))
 new ok set ok=$$FTG^%ZISH(dir,file,tmp1,3)
 if 'ok do  quit  ;
 . write !,"error loading file ",dir_file
 . quit
 if '$get(nocache) do toCache(tmp,fn,"html-cache")
 merge @rary=@tmp
 kill @tmp
 ;
 quit  ; end of getThis^%wd
 ;
 ;
 ;
queryContext(context,pred,obj) ; look up project specific
 ;
 ; names and values from the context graph
 ; tbd
 ;
 quit obj ; end of $$queryContext^%wd
 ;
 ;
 ;
queryTag(rtn,tag) ; returns a json/mumps array of tagged items
 ;
 new graph set graph="seeGraph"
 kill @rtn
 new root set root=$$setroot(graph)
 new groot set groot=$na(@root@("graph"))
 if '$d(@groot@("pos","tag",tag)) quit
 new x1,y1 set (x1,y1)=""
 new cnt set cnt=0
 for  set x1=$order(@groot@("pos","tag",tag,x1)) quit:x1=""  do  ;
 . for  set y1=$order(@groot@("pos","tag",tag,x1,y1)) quit:y1=""  do  ;
 . . set cnt=cnt+1
 . . merge @rtn@(cnt)=@groot@(x1,y1)
 . . quit
 . quit
 ;
 quit  ; end of queryTag^%wd
 ;
 ;
 ;
fromCache(rary,name,graph) ; return a file from the cache
 ;
 if '$d(graph) set graph="html-cache"
 new zgn set zgn=$$setroot(graph)
 quit:'$data(@zgn@("graph","B",name))
 new zien set zien=$order(@zgn@("graph","B",name,""))
 quit:zien=""
 merge @rary=@zgn@("graph",zien)
 ;
 quit  ; end of fromCache^%wd
 ;
 ;
 ;
toCache(arry,name,graph) ; put a file in the cache
 ;
 if '$d(graph) set graph="html-cache"
 new zgn set zgn=$$setroot(graph)
 new zien
 if $data(@zgn@("graph","B",name)) do  ;
 . set zien=$order(@zgn@("graph","B",name,""))
 . kill @zgn@("graph",zien)
 . kill @zgn@("graph","B",name,zien)
 . quit
 if $get(zien)="" do  ;
 . set zien=$order(@zgn@("graph"," "),-1)+1
 . quit
 merge @zgn@("graph",zien)=@arry
 set @zgn@("graph","B",name,zien)=""
 ;
 quit  ; end of toCache^%wd
 ;
 ;
 ;
beautify(inary,outary) ; pretty print a line of json
 ;
 new zg,zi set (zg,zi)=""
 for  set zi=$order(@inary@(zi)) quit:zi=""  set zg=zg_@inary@(zi)
 do ary2file("zg",^%WHOME,"json.json")
 zsystem "python -m json.tool "_^%WHOME_"json.json > "_^%WHOME_"pretty-json.json"
 do file2ary(outary,^%WHOME,"pretty-json.json")
 ;
 quit  ; end of beautify^%wd
 ;
 ;
 ;
ary2file(ary,dir,file) ;
 ;
 new tmp set tmp=$name(^TMP("yottawrk",$J))
 kill @tmp
 if '$data(@ary@(1)) do  ; not really an array
 . if $get(@ary)="" quit ; not a string either
 . merge @tmp@(1)=@ary ; input was a string
 . quit
 else   merge @tmp=@ary
 new tmp1 set tmp1=$name(@tmp@(1))
 new ok set ok=$$GTF^%ZISH(tmp1,3,dir,file)
 if 'ok do  quit  ;
 . write !,"error saving file ",dir_file
 . quit
 ;
 quit  ; end of ary2file^%wd
 ;
 ;
 ;
file2ary(ary,dir,file) ;
 ;
 new tmp set tmp=$name(^TMP("yottawrk",$J))
 kill @tmp
 new tmp1 set tmp1=$name(@tmp@(1))
 new ok set ok=$$FTG^%ZISH(dir,file,tmp1,3)
 if 'ok do  quit  ;
 . write !,"error loading file ",dir_file
 . quit
 merge @ary=@tmp
 kill @tmp
 ;
 quit  ; end of file2ary^%wd
 ;
getGraph(url,gname) ; get a graph from a web service
 ;
 q:'$d(gname)
 i $$rootOf^%wd(gname)'=-1 d  q  ;
 . w !,"error, graph exists: "_gname
 n root s root=$$setroot^%wd(gname)
 n %,json,grf
 s %=$$%^%WC(.json,"GET",url)
 w !,"result= ",%
 i '$d(json) d  q  ;
 . w !,"error, nothing returned"
 d DECODE^VPRJSON("json","grf")
 m @root=grf
 n indx,rindx
 s indx=$o(@root@(0))
 s rindx=$na(@root@(indx))
 s @root@("index","root")=rindx
 d index(rindx)
 q
 ;
wsGetGraph(RTN,FILTER) ; web service returns the requested graph FILTER("graph")="graph"
 ; this is the server side of getGraph above
 n graph s graph=$g(FILTER("graph"))
 i graph="" d  q  ;
 . s RTN="-1^please specify a graph"
 ;n root s root=$$rootOf^%wd(graph)
 n root s root=$$setroot^%wd(graph)
 i +root=-1 d  q  ;
 . s RTN="-1^graph not found"
 ;
 ;n json
 ;s json=$$setroot^%wd(graph_"-json")
 ;i +json'=-1 s RTN=json q  ;
 ;s json=$$setroot^%wd(graph_"-json")
 S RTN=$na(^TMP("SYNOUT",$J))
 K @RTN
 d ENCODE^VPRJSON(root,RTN)
 q
 ;
 ;
 ;
eor ; end of routine %wdgraph
