%wd ;ven/gpl-write dialog: ppi & api library ;2018-02-06T19:33Z
 ;;1.8;Mash;
 ;
 ; %wd is the Write Dialog Library's ppi & api routine. It currently
 ; supports the suite of tools for graphstore-format datasets, which will
 ; eventually be moved over to %sf & %sfg. Graphstores are Mash's primary
 ; dataset format.
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
 ;@last-updated: 2018-02-06T19:33Z
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
 ; 2017-09-24 ven/gpl %*1.8t01 %wd: create routine as ppi & api library.
 ;
 ; 2018-02-06 ven/toad %1.8t04 %wd: passim add white space & hdr comments,
 ; tag w/Apache license & attribution & to-do to shift to %sf later.
 ;
 ;@to-do
 ; convert entry points to ppi/api style
 ; %wdgraph: r/all local calls w/calls through ^%wd
 ; renamespace under %sf & %sfg
 ;
 ;@contents
 ; all private programming interfaces for now
 ; some public web services & apis later
 ;
 ;
 ;
 ;@section 1 graph-handling ppis
 ;
 ;
 ;
setroot(graph) ; root of working storage
 ;
 quit $$setroot^%wdgraph(graph) ; end of $$setroot^%wd
 ;
 ;
 ;
rootOf(graph) ; return the root of graph named graph
 ;
 quit $$rootOf^%wdgraph(graph) ; end of $$rootOf^%wd
 ;
 ;
 ;
addgraph(graph) ; makes a place in the graph file for a new graph
 ;
 do addgraph^%wdgraph(graph)
 ;
 quit  ; end of addgraph^%wd
 ;
 ;
 ;
purgegraph(graph) ; delete a graph
 ;
 do purgegraph^%wdgraph(graph)
 ;
 quit  ; end of purgegraph^%wd
 ;
 ;
 ;
insert2graph(ary,graph,replace) ; insert a new entry to a graph
 ;
 do insert2graph^%wdgraph(.ary,graph,replace)
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
 quit $$nameThis^%wdgraph(altname) ; end of $$nameThis^%wd
 ;
 ;
 ;
getThis(rary,fn,nocache) ; find a file and read it into rary array
 ;
 do getThis^%wdgraph(rary,fn,$get(nocache))
 ;
 quit  ; end of getThis^%wd
 ;
 ;
 ;
queryContext(context,locator,property) ; look up project specific
 ;
 ; names and values from the context graph
 ; tbd
 ;
 quit $$queryContext^%wdgraph(context,locator,property) ; end of $$queryContext^%wd
 ;
 ;
 ;
queryTag(rtn,tag) ; returns a json/mumps array of tagged items
 ;
 do queryTag^%wdgraph(rtn,tag)
 ;
 quit  ; end of queryTag^%wd
 ;
 ;
 ;
fromCache(rary,name,graph) ; return a file from the cache
 ;
 do fromCache^%wdgraph(rary,name,graph)
 ;
 quit  ; end of fromCache^%wd
 ;
 ;
 ;
toCache(arry,name,graph) ; put a file in the cache
 ;
 do toCache^%wdgraph(arry,name,graph)
 ;
 quit  ; end of toCache^%wd
 ;
 ;
 ;
beautify(inary,outary) ; pretty print a line of json
 ;
 do beautify^%wdgraph(inary,outary)
 ;
 quit  ; end of beautify^%wd
 ;
 ;
 ;
ary2file(ary,dir,file) ;
 ;
 do ary2file^%wdgraph(.ary,dir,file)
 ;
 quit  ; end of ary2file^%wd
 ;
 ;
 ;
file2ary(ary,dir,file)
 ;
 do file2ary^%wdgraph(.ary,dir,file)
 ;
 quit  ; end of file2ary^%wd
 ;
 ;
 ;
 ;@section 2 csv-handling ppis
 ;
 ;
 ;
csv2graph(source,graph) ; import a csv file to a graph
 ;
 ; graph is optional, will default to csvGraph
 ; source is either a filename which will be found in seeGraph
 ; or a global passed by name usually loaded with FTG^%ZISH
 ;
 do csv2graph^%wdcsv(source,$get(graph))
 ;
 quit  ; end of csv2graph^%wd
 ;
 ;
 ;
prune(txt) ; extrinsic removes extra quotes
 ;
 quit $$prune^%wdcsv(txt) ; end of $$prune^%wd
 ;
 ;
 ;
delim(ary) ; figures out the cvs delimiter
 ;
 ; return -1 if there not found
 ; ary is passed by reference
 ; returns the delimiter
 ;
 quit $$delim^%wdcsv(.ary) ; end of $$delim^%wd
 ;
 ;
 ;
wellformed(ary,delim) ; extrinsic returns 1 if ary is well formed
 ;
 ; checks to see that the count of the delimiter is the same
 ; on every line
 ; ary is passed by reference
 ;
 quit $$wellformed^%wdcsv(.ary,delim) ; end of $$wellformed^%wd
 ;
 ;
 ;
eor ; end of routine %wd
