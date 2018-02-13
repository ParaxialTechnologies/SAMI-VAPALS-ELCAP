%yottautl ;ven/gpl-yottadb extension: utilities ;2018-02-08T19:18Z
 ;;1.8;Mash;
 ;
 ; %yottaq implements the Yottadb Extension Library's utilities
 ; ppis & apis. This will eventually be reorganized into topics &
 ; migrated to other Mash namespaces. In the meantime, they will be
 ; added to the new %yotta ppi library.
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
 ;@last-updated: 2018-02-08T19:18Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Yottadb Extension - %yotta
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
 ; 2017-07-04 ven/gpl %*1.8t01 %yottautl: create routine to hold
 ; yottadb utility methods.
 ;
 ; 2017-09-12 ven/gpl %*1.8t01 %yottautl: update
 ;
 ; 2017-09-18 ven/gpl %*1.8t01 %yottautl: update
 ;
 ; 2018-02-07/08 ven/toad %*1.8t04 %yottautl: passim add white space
 ; & hdr comments & do-dot quits, tag w/Apache license & attribution
 ; & to-do to shift namespace later.
 ;
 ;@to-do
 ; %yotta: create entry points in ppi/api style
 ; r/all local calls w/calls through ^%yotta
 ; organize by topic & renamespace variously
 ;
 ;@contents
 ; [too big, organize & break up]
 ;
 ;
 ;
 ;@section 1 code to implement ppis & apis
 ;
 ;
 ;
starttm(ary) ; timestamp the start time
 ;
 set @ary@("starttimefm")=$$timei
 set @ary@("starttime")=$$timee(@ary@("starttimefm"))
 ;
 quit  ; end of starttm
 ;
 ;
 ;
endtm(ary) ; timestamp the start time
 ;
 set @ary@("endtimefm")=$$timei
 set @ary@("endtime")=$$timee(@ary@("endtimefm"))
 set @ary@("elapsedtime")=$$elapsed(@ary@("endtimefm"),@ary@("starttimefm")) ;
 ; in seconds
 ;
 quit  ; end of endtm
 ;
 ;
 ;
elapsed(end,start) ; elapsed time in seconds. end and start are fm format
 ;
 quit $$fmdiff^xlfdt(end,start,2) ; end of $$elapsed
 ;
 ;
 ;
timei() ; internal time
 ;
 quit $$now^xlfdt ; end of $$timei
 ;
 ;
 ;
timee(fmtime) ; external time
 ;
 quit $$FMTE^XLFDT(fmtime) ; end of $$timee
 ;
 ;
 ;
addat(outary,inary,tag) ; both passed by name..
 ;
 ;  inary("attr")="xx" is converted to outary("tag@attr")="xx"
 ;   to make better xml - only works with simple arrays
 ;
 if '$data(tag) set tag="item"
 new zi set zi=""
 for  set zi=$order(@inary@(zi)) quit:zi=""  do  ;
 . set @outary@(tag_"@"_zi)=@inary@(zi)
 . quit
 ;
 quit  ; end of addat
 ;
 ;
 ;
testadd ; test of addat routine
 ;
 new gn set gn=$name(^xtmp("ehexpat",1))
 new gpl
 do addat("gpl",gn,"patient")
 zwrite gpl
 ;
 quit  ; end of testadd
 ;
 ;
 ;
genhtml2(hout,hary) ; generate an html table from array hary
 ;
 ; hout and hary are passed by name
 ;
 ;  hary("title")="problem list"
 ;  hary("header",1)="column 1 header"
 ;  hary("header",2)="col 2 header"
 ;  hary(1,1)="row 1 col1 value"
 ;  hary(1,2)="row 1 col2 value"
 ;  hary(1,2,"id")="the id of the element" 
 ;  etc...
 ;
 new c0i,c0j
 do addto(hout,"<div align=""center"">")
 ;
 ; if $data(@hary@("title")) do  ;
 ; . new x
 ; . set x="<title>"_@hary@("title")_"</title>"
 ; . do addto(hout,x)
 ; . quit
 ;
 do addto(hout,"<text>")
 do addto(hout,"<table border=""1"" style=""width:80%"">")
 if $data(@hary@("title")) do  ;
 . new x
 . set x="<caption><b>"_@hary@("title")_"</b></caption>"
 . do addto(hout,x)
 . quit
 if $data(@hary@("header")) do  ;
 . do addto(hout,"<thead>")
 . do addto(hout,"<tr>")
 . set c0i=0
 . for  set c0i=$order(@hary@("header",c0i)) quit:+c0i=0  do  ;
 . . do addto(hout,"<th>"_@hary@("header",c0i)_"</th>")
 . . quit
 . do addto(hout,"</tr>")
 . do addto(hout,"</thead>")
 . quit
 do addto(hout,"<tbody>")
 if $data(@hary@(1)) do  ;
 . set c0i=0 set c0j=0
 . for  set c0i=$order(@hary@(c0i)) quit:+c0i=0  do  ;
 . . do addto(hout,"<tr>")
 . . for  set c0j=$order(@hary@(c0i,c0j)) quit:+c0j=0  do  ;
 . . . new uid set uid=$get(@hary@(c0i,c0j,"id"))
 . . . if uid'="" do addto(hout,"<td style=""padding:5px;"" id="""_uid_""">"_@hary@(c0i,c0j)_"</td>")
 . . . else  do addto(hout,"<td style=""padding:5px;"">"_@hary@(c0i,c0j)_"</td>")
 . . do addto(hout,"</tr>")
 . . quit
 . quit
 do addto(hout,"</tbody>")
 do addto(hout,"</table>")
 do addto(hout,"</text>")
 do addto(hout,"</div>")
 ;
 quit  ; end of genhtml2
 ;
 ;
 ;
genhtml(hout,hary) ; generate an html table from array hary
 ;
 ; hout and hary are passed by name
 ;
 ;  hary("title")="problem list"
 ;  hary("header",1)="column 1 header"
 ;  hary("header",2)="col 2 header"
 ;  hary(1,1)="row 1 col1 value"
 ;  hary(1,2)="row 1 col2 value"
 ;  hary(1,2,"id")="the id of the element" 
 ;  etc...
 ;
 new divclass,tblclass
 set divclass=$get(@hary@("divclass"))
 set tblclass=$get(@hary@("tableclass"))
 if divclass="" set divclass="tables"
 if tblclass="" set tblclass="patient"
 new c0i,c0j
 do addto(hout,"<div class=""tables"">")
 ;
 ; if $data(@hary@("title")) do  ;
 ; . new x
 ; . set x="<title>"_@hary@("title")_"</title>"
 ; . do addto(hout,x)
 ; . quit
 ; do addto(hout,"<text>")
 ;
 new zwidth set zwidth=$get(@hary@("width"))
 if zwidth="" set zwidth="80%"
 do addto(hout,"<table class=""summary"" style=""width:"_zwidth_""">")
 if $data(@hary@("title")) do  ;
 . new x
 . set x="<caption>"_@hary@("title")_"</caption>"
 . do addto(hout,x)
 . quit
 if $data(@hary@("header")) do  ;
 . do addto(hout,"<thead>")
 . do addto(hout,"<tr>")
 . new numcol set numcol=$order(@hary@("header",""),-1)
 . set c0i=0
 . for  set c0i=$order(@hary@("header",c0i)) quit:+c0i=0  do  ;
 . . ; new th set th="<th colspan="""_numcol_""">"_@hary@("header",c0i)_"</th>"
 . . new th set th="<th>"_@hary@("header",c0i)_"</th>"
 . . do addto(hout,th)
 . . quit
 . do addto(hout,"</tr>")
 . do addto(hout,"</thead>")
 . quit
 do addto(hout,"<tbody>")
 if $data(@hary@(1)) do  ;
 . set c0i=0 set c0j=0
 . for  set c0i=$order(@hary@(c0i)) quit:+c0i=0  do  ;
 . . do addto(hout,"<tr>")
 . . for  set c0j=$order(@hary@(c0i,c0j)) quit:+c0j=0  do  ;
 . . . new uid set uid=$get(@hary@(c0i,c0j,"id"))
 . . . if uid'="" do addto(hout,"<td id="""_uid_""">"_@hary@(c0i,c0j)_"</td>")
 . . . else  do addto(hout,"<td>"_@hary@(c0i,c0j)_"</td>")
 . . . quit
 . . do addto(hout,"</tr>")
 . . quit
 . quit
 do addto(hout,"</tbody>")
 do addto(hout,"</table>")
 ; do addto(hout,"</text>")
 do addto(hout,"</div>")
 ;
 quit  ; end of genhtml
 ;
 ;
 ;
genvhtml(hout,hary) ; generate a vertical html table from array hary
 ;
 ; headers are in the first row
 ; hout and hary are passed by name
 ;
 ; format of the table:
 ;  hary("title")="problem list"
 ;  hary("header",1)="row 1 column 1 header"
 ;  hary("header",2)="row 2 col 2 header"
 ;  hary(1,1)="row 1 col2 value"
 ;  hary(2,1)="row 2 col2 value"
 ;  etc...
 ;
 new divclass,tblclass
 set divclass=$get(@hary@("divclass"))
 set tblclass=$get(@hary@("tableclass"))
 if divclass="" set divclass="tables"
 if tblclass="" set tblclass="patient"
 new c0i,c0j
 do addto(hout,"<div class=""tables"">")
 ; do addto(hout,"<div align=""center"">")
 new zwidth set zwidth=$get(@hary@("width"))
 if zwidth="" set zwidth="80%"
 do addto(hout,"<table class=""summary"" style=""width:"_zwidth_""">")
 ; do addto(hout,"<text>")
 ; do addto(hout,"<table border=""1"" style=""width:40%"">")
 if $d(@hary@("title")) do  ;
 . new x
 . set x="<caption><b>"_@hary@("title")_"</b></caption>"
 . do addto(hout,x)
 . quit
 if $data(@hary@("header")) do  ;
 . do addto(hout,"<thead>")
 . do addto(hout,"<tr>")
 . new numcol set numcol=$order(@hary@("header",""),-1)
 . set c0i=0
 . for  set c0i=$order(@hary@("header",c0i)) quit:+c0i=0  do  ;
 . . do addto(hout,"<th style=""padding:5px;"">"_@hary@("header",c0i)_"</th>")
 . . do addto(hout,"<td style=""padding:5px;"">"_@hary@(c0i,1)_"</td>")
 . . quit
 . do addto(hout,"</tr>")
 . quit
 do addto(hout,"</table>")
 do addto(hout,"</text>")
 do addto(hout,"</div>")
 ;
 quit  ; end of genvhtml
 ;
 ;
 ;
tstyle1 ; table style template
 ;;<style>
 ;;table, th, td
 ;;{
 ;;border-collapse:collapse;
 ;;border:1px solid black;
 ;;}
 ;;th, td
 ;;{
 ;;padding:5px;
 ;;}
 ;;</style>
 quit  ; end of tstyle1
 ;
 ;
 ;
testhtml ;
 ;
 new html
 set html("title")="problem list"
 set html("header",1)="column 1 header"
 set html("header",2)="col 2 header"
 set html(1,1)="row 1 col1 value"
 set html(1,2)="row 1 col2 value"
 new ghtml
 do genhtml("ghtml","html")
 zwrite ghtml
 ;
 quit  ; end of testhtml
 ;
 ;
 ;
test2 ;
 ;
 new html
 set html("title")="problem list"
 set html("header",1)="column 1 header"
 set html("header",2)="col 2 header"
 set html(1,1)="row 1 col1 value"
 set html(1,2)="row 1 col2 value"
 new ghtml
 do genhtml2("ghtml","html")
 zwrite ghtml
 ;
 quit  ; end of test2
 ;
 ;
 ;
addto(dest,what) ; adds string what to list dest 
 ;
 ; dest is passed by name
 ;
 new gn
 set gn=$o(@dest@("aaaaaa"),-1)+1
 set @dest@(gn)=what
 set @dest@(0)=gn ; count
 ;
 quit  ; end of addto
 ;
 ;
 ;
addary(dest,what) ; adds array what to list dest 
 ;
 ; dest and what are passed by name
 ;
 new gn
 set gn=$order(@dest@("aaaaaa"),-1)+1
 new zzi set zzi=0
 for  set zzi=$order(@what@(zzi)) quit:'zzi  do  ;
 . set @dest@(gn)=$get(@what@(zzi))
 . set @dest@(0)=gn ; count
 . set gn=gn+1
 . quit
 ;
 quit  ; end of addary
 ;
 ;
 ;
orgoid() ; extrinsic which returns the organization oid
 ;
 quit "2.16.840.1.113883.5.83" ; worldvista hl7 oid - 
 ;
 ; replace with oid lookup from institution file
 ;
 ;
 ;
tree(where,prefix,docid,zout) ; show a tree starting at a node in mxml. 
 ;
 ; node is passed by name
 ; 
 if $get(prefix)="" set prefix="|--" ; starting prefix
 if '$data(kbaijob) set kbaijob=$job
 new node set node=$name(^TMP("MXMLDOM",kbaijob,docid,where))
 new txt set txt=$$clean($$alltxt(node))
 write:'$get(diquiet) !,prefix_@node_" "_txt
 do oneout(zout,prefix_@node_" "_txt)
 new zi set zi=""
 for  set zi=$order(@node@("a",zi)) quit:zi=""  do  ;
 . write:'$get(diquiet) !,prefix_"  : "_zi_"^"_$get(@node@("a",zi))
 . do oneout(zout,prefix_"  : "_zi_"^"_$get(@node@("a",zi)))
 . quit
 for  set zi=$order(@node@("c",zi)) quit:zi=""  do  ;
 . do tree(zi,"|  "_prefix,docid,zout)
 . quit
 ;
 quit  ; end of tree
 ;
 ;
 ;
oneout(zbuf,ztxt) ; adds a line to zbuf
 ;
 new zi set zi=$order(@zbuf@(""),-1)+1
 set @zbuf@(zi)=ztxt
 ;
 quit  ; end of oneout
 ;
 ;
 ;
alltxt(where) ; extrinsic which returns all text lines from the node .. concatinated 
 ;
 ; together
 ;
 new zti set zti=""
 new ztr set ztr=""
 for  s zti=$order(@where@("t",zti)) quit:zti=""  do  ;
 . set ztr=ztr_$get(@where@("t",zti))
 . quit
 ;
 quit ztr ; end of $$alltxt
 ;
 ;
 ;
clean(str) ; extrinsic function; returns string - gpl borrowed from the ccr package
 ;
 ;; removes all non printable characters from a string.
 ;; str by value
 ;
 new tr,i
 for i=0:1:31 s tr=$get(tr)_$char(i)
 set tr=tr_$char(127)
 new zr set zr=$translate(str,tr)
 set zr=$$ldblnks(zr) ; get rid of leading blanks
 ;
 quit zr ; end of $$clean
 ;
 ;
 ;
ldblnks(st) ; extrinsic which removes leading blanks from a string
 ;
 new pos for pos=1:1:$length(st)  quit:$extract(st,pos)'=" "
 ;
 quit $extract(st,pos,$length(st)) ; end of $$ldblnks
 ;
 ;
 ;
show(what,docid,zout) ;
 ;
 if '$data(c0xjob) set c0xjob=$job
 do tree(what,,docid,zout)
 ;
 quit  ; end of show
 ;
 ;
 ;
listm(out,in) ; out is passed by name in is passed by reference
 ;
 new i set i=$query(@in@(""))
 for  set i=$query(@i) quit:i=""  do oneout(out,i_"="_@i)
 ;
 quit  ; end of listm
 ;
 ;
 ;
peel(out,in) ; compress a complex global into something simpler
 ;
 new i set i=$query(@in@(""))
 for  s i=$query(@i) quit:i=""  do  ;
 . new j,k,l,m,n,m1
 . set (l,m)=""
 . set n=$$shrink($qsubscript(i,$qlength(i)))
 . set k=$qsubscript(i,0)_"("""
 . for j=1:1:$qlength(i)-1  do  ;
 . . if +$qsubscript(i,j)>0 do  ;
 . . . if m'="" quit
 . . . set m=$qsubscript(i,j)
 . . . set m1=j
 . . . if j>1 set l=$qsubscript(i,j-1)
 . . . else  set l=$qsubscript(i,j)
 . . . if l["substanceadministration" set l=$p(l,"substanceadministration",2)
 . . . quit
 . . set k=k_$qsubscript(i,j)_""","""
 . . write:$get(debug) !,j," ",k
 . . quit
 . set k=k_$qsubscript(i,$qlength(i))_""")"
 . write:$get(debug) !,k,"=",@k
 . if l'="" do  quit  ;
 . . do:$get(@out@(l,m,n))'=""
 . . . ; new jj,n2
 . . . ; for jj=2:1 write !,jj set n2=$qsubscript(i,$qlength(i)-1)_"["_jj_"]"_n quit:$get(@out@(l,m,n2))=""  write !,n2
 . . . ; set n=n2
 . . . ; set n=$$shrink($qsubscript(i,$qlength(i)-1))_"_"_n
 . . . set n=$$mkxpath(i,m1)
 . . . break:$get(@out@(l,m,n))'=""
 . . . quit
 . . set @out@(l,m,n)=@k
 . . quit
 . if @k'="" do  ;
 . . if $qlength(i)>1 do  quit  ;
 . . . set l=$$shrink($qsubscript(i,$qlength(i)-1))
 . . . do:$get(@out@(l,n))'=""
 . . . . ; new jj,n2
 . . . . ; for jj=2:1 set n2=$qsubscript(i,$qlength(i)-1)_"["_jj_"]"_"_"_n quit:$get(@out@(l,n2))=""
 . . . . ; set n=n2
 . . . . ; break:$get(@out@(l,n))'=""
 . . . . set n=$$shrink($qsubscript(i,$qlength(i)-1))_"_"_n
 . . . . quit
 . . . set @out@(l,n)=@k
 . . . quit
 . . set @out@(n)=@k
 . . quit
 . quit
 ;
 quit  ; end of peel
 ;
 ;
 ;
shrink(x) ; reduce strings 
 ;
 new y,z
 set y=x
 set z="substanceadministration"
 if x[z set y=$piece(x,z,2)
 ;
 quit y ; end of $$shrink
 ;
 ;
 ;
mkxpath(zq,zm) ; extrinsic which returns the xpath derived from the $query value 
 ;
 ;passed by value. zm is the index to begin with
 ;
 new zr set zr=""
 new zi set zi=""
 for zi=1:1:$qlength(zq) set zr=zr_"/"_$qsubscript(zq,zi)
 ;
 quit zr ; end of $$mkxpath
 ;
 ;
 ;
 ; todo: make this work for regular xml files - only works now with 
 ;   attributes to a single tag per entry
 ;
 ;
 ;
ary2xml(outxml,inary,stk,child) ; convert an array to xml
 ;
 if '$data(@outxml@(1)) set @outxml@(1)="<?xml version=""1.0"" encoding=""utf-8"" ?>"
 new ii set ii=""
 new dattr set dattr="" ; deffered attributes
 for  set ii=$order(@inary@(ii),-1) quit:ii=""  do  ;
 . new attr,tag
 . set attr="" set tag=""
 . if ii["@" do  ;
 . . if tag="" set tag=$piece(ii,"@",1) set attr=$piece(ii,"@",2)_"="""_@inary@(ii)_""""
 . . write:$get(debug) !,"tag="_tag_" attr="_attr
 . . ; if $order(@inary@(ii))["@" do  ;
 . . ; for  set ii=$order(@inary@(ii),-1) quit:ii=""  quit:$order(@inary@(ii),-1)'[(tag_"@")  do  ;
 . . for  set ii=$order(@inary@(ii),-1) quit:ii=""  quit:ii'[(tag_"@")  do  ;
 . . . set attr=attr_" "_$piece(ii,"@",2)_"="""_@inary@(ii)_""""
 . . . write:$get(debug) !,"attr= ",attr
 . . . write:$get(debug) !,"ii= ",ii
 . . . quit
 . . set ii=$order(@inary@(ii)) ; reset to previous
 . . new ending set ending="/"
 . . if ii["@" do  ;
 . . . if $order(@inary@(ii),-1)=tag set dattr=" "_attr quit  ; deffered attributes
 . . . if $data(@inary@(tag)) set ending=""
 . . . do oneout(outxml,"<"_tag_" "_attr_ending_">")
 . . . if ending="" do push("stk","</"_tag_">")
 . . . quit
 . . quit
 . if ii'["@" do  ;
 . . if +ii=0 do  ;
 . . . do oneout(outxml,"<"_ii_dattr_">")
 . . . set dattr="" ; reinitialize after use
 . . . do push("stk","</"_ii_">")
 . . . quit
 . . quit
 . if $data(@inary@(ii)) do ary2xml(outxml,$name(@inary@(ii)))
 . quit
 if $data(stk) for  do oneout(outxml,$$pop("stk")) quit:'$data(stk)
 ;
 quit  ; end of ary2xml
 ;
 ;
 ;
push(buf,str) ;
 ;
 do oneout(buf,str)
 ;
 quit  ; end of push
 ;
 ;
 ;
pop(buf) ; extrinsic returns the last element and then deletes it
 ;
 new nm,tx
 set nm=$order(@buf@(""),-1)
 quit:nm="" nm
 set tx=@buf@(nm)
 kill @buf@(nm)
 ;
 quit tx ; end of $$pop
 ;
 ;
 ;
eor ; end of routine %yottautl
