%wdcsv	;ven/gpl - mash csv utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
 ; All the public entry points for these routines are in %wd
 ;
csv2graph(source,graph) ; import a csv file to a graph
 ; graph is optional, will default to csvGraph
 ; source is either a filename which will be found in seeGraph
 ; or a global passed by name usually loaded with FTG^%ZISH
 ;
 new %wary,%wi,%wgraph
 if $extract(source,1)="^" m %wary=@$name(source)
 else  do getThis^%wdgraph("%wary",source)
 new delim s delim=$$delim(.%wary)
 if delim=-1 d  q  ;
 . write !,"error, delimiter not found"
 if '$$wellformed(.ary,delim) do  quit  ;
 . write !,"error, csv file not well formed delimiter="_delim
 new %wgraph,%wcol,%wid ; place to store the graph and the id of the graph
 ; %wcol contains the column names in order
 set %wid=$$nameThis^%wdgraph(source) ; get the id from the context
 ; first get the column names from row 1
 for %wi=1:1:$length(%wary(1),delim) set %wcol(%wi)=$$rename($translate($$prune($piece(%wary(1),delim,%wi))," ","_"))
 set %wi=1
 for  set %wi=$order(%wary(%wi)) q:+%wi=0  do  ;
 . new %wj
 . ;w !,%wary(%wi)
 . for %wj=1:1:$length(%wary(%wi),delim) do  ;
 . . new %wval set %wval=$piece(%wary(%wi),delim,%wj)
 . . if %wval'="" set %wgraph(%wid,%wi,%wcol(%wj))=$$prune(%wval)
 if $get(graph)="" set graph="csvGraph"
 merge %wgraph(%wid,"order")=%wcol
 new rpl s rpl=1
 do insert2graph^%wdgraph("%wgraph",graph,rpl)
 quit
 ;
prune(txt) ; extrinsic removes extra quotes
 if txt'["""" quit  ; no extra quotes
 new %w1,%return set %return=""
 for %w1=1:1:$length(txt,"""") do  ;
 . set %return=%return_$piece(txt,"""",%w1)
 quit %return
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
rename(name) ; extrinsic returns new name or old name if not found
 ; this is a temporary routine until the csv files are updated
 n nam
 s nam("Sub._#")="sub#"
 s nam("Field_Name")="fieldName"
 s nam("Title")="fieldTitle"
 s nam("Data_Type")="dataType"
 s nam("Value")="value"
 s nam("Definition")="definition"
 s nam("m-class-#")="mClass#"
 s nam("m-prop-#")="mProp#"
 s nam("m-prop-name")="mPropName"
 s nam("m-prop-title")="mPropTitle"
 s nam("m-prop-loc")="mPropLoc"
 s nam("m-prop-type")="mPropType"
 s nam("m-prop-det")="mPropDet"
 s nam("m-delim-check")="mDlimCheck"
 n namtmp
 s namtmp=$g(nam(name))
 i namtmp="" s namtmp=name
 q namtmp
 ;
wellformed(ary,delim) ; extrinsic returns 1 if csv ary is well formed
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
