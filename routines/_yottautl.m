%yottautl ; gpl - utilities for c0ts; 7/4/15 6:03pm
 ;;1.0;no package;;mar 21, 2016;build 1
 ;
 q
 ;
starttm(ary) ; timestamp the start time
 s @ary@("starttimefm")=$$timei
 s @ary@("starttime")=$$timee(@ary@("starttimefm"))
 q
 ;
endtm(ary) ; timestamp the start time
 s @ary@("endtimefm")=$$timei
 s @ary@("endtime")=$$timee(@ary@("endtimefm"))
 s @ary@("elapsedtime")=$$elapsed(@ary@("endtimefm"),@ary@("starttimefm")) ;
 ; in seconds
 q
 ;
elapsed(end,start) ; elapsed time in seconds. end and start are fm format
 q $$fmdiff^xlfdt(end,start,2)
timei() ; internal time
 q $$now^xlfdt
 ;
timee(fmtime) ; external time
 q $$fmte^xlfdt(fmtime)
 ;
addat(outary,inary,tag) ; both passed by name..
 ;  inary("attr")="xx" is converted to outary("tag@attr")="xx"
 ;   to make better xml - only works with simple arrays
 i '$d(tag) s tag="item"
 n zi s zi=""
 f  s zi=$o(@inary@(zi)) q:zi=""  d  ;
 . s @outary@(tag_"@"_zi)=@inary@(zi)
 q
 ;
testadd ; test of addat routine
 n gn s gn=$na(^xtmp("ehexpat",1))
 n gpl
 d addat("gpl",gn,"patient")
 zwr gpl
 q
 ;
genhtml2(hout,hary) ; generate an html table from array hary
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
 n c0i,c0j
 d addto(hout,"<div align=""center"">")
 ;i $d(@hary@("title")) d  ;
 ;. n x
 ;. s x="<title>"_@hary@("title")_"</title>"
 ;. d addto(hout,x)
 d addto(hout,"<text>")
 d addto(hout,"<table border=""1"" style=""width:80%"">")
 i $d(@hary@("title")) d  ;
 . n x
 . s x="<caption><b>"_@hary@("title")_"</b></caption>"
 . d addto(hout,x)
 i $d(@hary@("header")) d  ;
 . d addto(hout,"<thead>")
 . d addto(hout,"<tr>")
 . s c0i=0
 . f  s c0i=$o(@hary@("header",c0i)) q:+c0i=0  d  ;
 . . d addto(hout,"<th>"_@hary@("header",c0i)_"</th>")
 . d addto(hout,"</tr>")
 . d addto(hout,"</thead>")
 d addto(hout,"<tbody>")
 i $d(@hary@(1)) d  ;
 . s c0i=0 s c0j=0
 . f  s c0i=$o(@hary@(c0i)) q:+c0i=0  d  ;
 . . d addto(hout,"<tr>")
 . . f  s c0j=$o(@hary@(c0i,c0j)) q:+c0j=0  d  ;
 . . . n uid s uid=$g(@hary@(c0i,c0j,"id"))
 . . . i uid'="" d addto(hout,"<td style=""padding:5px;"" id="""_uid_""">"_@hary@(c0i,c0j)_"</td>")
 . . . e  d addto(hout,"<td style=""padding:5px;"">"_@hary@(c0i,c0j)_"</td>")
 . . d addto(hout,"</tr>")
 d addto(hout,"</tbody>")
 d addto(hout,"</table>")
 d addto(hout,"</text>")
 d addto(hout,"</div>")
 q
 ;
genhtml(hout,hary) ; generate an html table from array hary
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
 n divclass,tblclass
 s divclass=$g(@hary@("divclass"))
 s tblclass=$g(@hary@("tableclass"))
 i divclass="" s divclass="tables"
 i tblclass="" s tblclass="patient"
 n c0i,c0j
 d addto(hout,"<div class=""tables"">")
 ;i $d(@hary@("title")) d  ;
 ;. n x
 ;. s x="<title>"_@hary@("title")_"</title>"
 ;. d addto(hout,x)
 ;d addto(hout,"<text>")
 n zwidth s zwidth=$g(@hary@("width"))
 i zwidth="" s zwidth="80%"
 d addto(hout,"<table class=""summary"" style=""width:"_zwidth_""">")
 i $d(@hary@("title")) d  ;
 . n x
 . s x="<caption>"_@hary@("title")_"</caption>"
 . d addto(hout,x)
 i $d(@hary@("header")) d  ;
 . d addto(hout,"<thead>")
 . d addto(hout,"<tr>")
 . n numcol s numcol=$o(@hary@("header",""),-1)
 . s c0i=0
 . f  s c0i=$o(@hary@("header",c0i)) q:+c0i=0  d  ;
 . . ;n th s th="<th colspan="""_numcol_""">"_@hary@("header",c0i)_"</th>"
 . . n th s th="<th>"_@hary@("header",c0i)_"</th>"
 . . d addto(hout,th)
 . d addto(hout,"</tr>")
 . d addto(hout,"</thead>")
 d addto(hout,"<tbody>")
 i $d(@hary@(1)) d  ;
 . s c0i=0 s c0j=0
 . f  s c0i=$o(@hary@(c0i)) q:+c0i=0  d  ;
 . . d addto(hout,"<tr>")
 . . f  s c0j=$o(@hary@(c0i,c0j)) q:+c0j=0  d  ;
 . . . n uid s uid=$g(@hary@(c0i,c0j,"id"))
 . . . i uid'="" d addto(hout,"<td id="""_uid_""">"_@hary@(c0i,c0j)_"</td>")
 . . . e  d addto(hout,"<td>"_@hary@(c0i,c0j)_"</td>")
 . . d addto(hout,"</tr>")
 d addto(hout,"</tbody>")
 d addto(hout,"</table>")
 ;d addto(hout,"</text>")
 d addto(hout,"</div>")
 q
 ;
genvhtml(hout,hary) ; generate a vertical html table from array hary
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
 n divclass,tblclass
 s divclass=$g(@hary@("divclass"))
 s tblclass=$g(@hary@("tableclass"))
 i divclass="" s divclass="tables"
 i tblclass="" s tblclass="patient"
 n c0i,c0j
 d addto(hout,"<div class=""tables"">")
 ;d addto(hout,"<div align=""center"">")
 n zwidth s zwidth=$g(@hary@("width"))
 i zwidth="" s zwidth="80%"
 d addto(hout,"<table class=""summary"" style=""width:"_zwidth_""">")
 ;d addto(hout,"<text>")
 ;d addto(hout,"<table border=""1"" style=""width:40%"">")
 i $d(@hary@("title")) d  ;
 . n x
 . s x="<caption><b>"_@hary@("title")_"</b></caption>"
 . d addto(hout,x)
 i $d(@hary@("header")) d  ;
 . d addto(hout,"<thead>")
 . d addto(hout,"<tr>")
 . n numcol s numcol=$o(@hary@("header",""),-1)
 . s c0i=0
 . f  s c0i=$o(@hary@("header",c0i)) q:+c0i=0  d  ;
 . . d addto(hout,"<th style=""padding:5px;"">"_@hary@("header",c0i)_"</th>")
 . . d addto(hout,"<td style=""padding:5px;"">"_@hary@(c0i,1)_"</td>")
 . d addto(hout,"</tr>")
 d addto(hout,"</table>")
 d addto(hout,"</text>")
 d addto(hout,"</div>")
 q
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
 q
 ;
testhtml ;
 n html
 s html("title")="problem list"
 s html("header",1)="column 1 header"
 s html("header",2)="col 2 header"
 s html(1,1)="row 1 col1 value"
 s html(1,2)="row 1 col2 value"
 n ghtml
 d genhtml("ghtml","html")
 zwr ghtml
 q
 ;
test2 ;
 n html
 s html("title")="problem list"
 s html("header",1)="column 1 header"
 s html("header",2)="col 2 header"
 s html(1,1)="row 1 col1 value"
 s html(1,2)="row 1 col2 value"
 n ghtml
 d genhtml2("ghtml","html")
 zwr ghtml
 q
 ;
addto(dest,what) ; adds string what to list dest 
 ; dest is passed by name
 n gn
 s gn=$o(@dest@("aaaaaa"),-1)+1
 s @dest@(gn)=what
 s @dest@(0)=gn ; count
 q
 ;
addary(dest,what) ; adds array what to list dest 
 ; dest and what are passed by name
 n gn
 s gn=$o(@dest@("aaaaaa"),-1)+1
 n zzi s zzi=0
 f  s zzi=$o(@what@(zzi)) q:'zzi  d  ;
 . s @dest@(gn)=$g(@what@(zzi))
 . s @dest@(0)=gn ; count
 . s gn=gn+1
 q
 ;
orgoid() ; extrinsic which returns the organization oid
 q "2.16.840.1.113883.5.83" ; worldvista hl7 oid - 
 ; replace with oid lookup from institution file
 ;
tree(where,prefix,docid,zout) ; show a tree starting at a node in mxml. 
 ; node is passed by name
 ; 
 i $g(prefix)="" s prefix="|--" ; starting prefix
 i '$d(kbaijob) s kbaijob=$j
 n node s node=$na(^TMP("MXMLDOM",kbaijob,docid,where))
 n txt s txt=$$clean($$alltxt(node))
 w:'$g(diquiet) !,prefix_@node_" "_txt
 d oneout(zout,prefix_@node_" "_txt)
 n zi s zi=""
 f  s zi=$o(@node@("a",zi)) q:zi=""  d  ;
 . w:'$g(diquiet) !,prefix_"  : "_zi_"^"_$g(@node@("a",zi))
 . d oneout(zout,prefix_"  : "_zi_"^"_$g(@node@("a",zi)))
 f  s zi=$o(@node@("c",zi)) q:zi=""  d  ;
 . d tree(zi,"|  "_prefix,docid,zout)
 q
 ;
oneout(zbuf,ztxt) ; adds a line to zbuf
 n zi s zi=$o(@zbuf@(""),-1)+1
 s @zbuf@(zi)=ztxt
 q
 ;
alltxt(where) ; extrinsic which returns all text lines from the node .. concatinated 
 ; together
 n zti s zti=""
 n ztr s ztr=""
 f  s zti=$o(@where@("t",zti)) q:zti=""  d  ;
 . s ztr=ztr_$g(@where@("t",zti))
 q ztr
 ;
clean(str) ; extrinsic function; returns string - gpl borrowed from the ccr package
 ;; removes all non printable characters from a string.
 ;; str by value
 n tr,i
 f i=0:1:31 s tr=$g(tr)_$c(i)
 s tr=tr_$c(127)
 n zr s zr=$tr(str,tr)
 s zr=$$ldblnks(zr) ; get rid of leading blanks
 quit zr
 ;
ldblnks(st) ; extrinsic which removes leading blanks from a string
 n pos f pos=1:1:$l(st)  q:$e(st,pos)'=" "
 q $e(st,pos,$l(st))
 ;
show(what,docid,zout) ;
 i '$d(c0xjob) s c0xjob=$j
 d tree(what,,docid,zout)
 q
 ; 
listm(out,in) ; out is passed by name in is passed by reference
 n i s i=$q(@in@(""))
 f  s i=$q(@i) q:i=""  d oneout(out,i_"="_@i)
 q
 ;
peel(out,in) ; compress a complex global into something simpler
 n i s i=$q(@in@(""))
 f  s i=$q(@i) q:i=""  d  ;
 . n j,k,l,m,n,m1
 . s (l,m)=""
 . s n=$$shrink($qs(i,$ql(i)))
 . s k=$qs(i,0)_"("""
 . f j=1:1:$ql(i)-1  d  ;
 . . i +$qs(i,j)>0 d  ;
 . . . i m'="" q
 . . . s m=$qs(i,j)
 . . . s m1=j
 . . . i j>1 s l=$qs(i,j-1)
 . . . e  s l=$qs(i,j)
 . . . i l["substanceadministration" s l=$p(l,"substanceadministration",2)
 . . s k=k_$qs(i,j)_""","""
 . . w:$g(debug) !,j," ",k
 . s k=k_$qs(i,$ql(i))_""")"
 . w:$g(debug) !,k,"=",@k
 . i l'="" d  q  ;
 . . d:$g(@out@(l,m,n))'=""
 . . . ;n jj,n2
 . . . ;f jj=2:1  w !,jj s n2=$qs(i,$ql(i)-1)_"["_jj_"]"_n q:$g(@out@(l,m,n2))=""  w !,n2
 . . . ;s n=n2
 . . . ;s n=$$shrink($qs(i,$ql(i)-1))_"_"_n
 . . . s n=$$mkxpath(i,m1)
 . . . b:$g(@out@(l,m,n))'=""
 . . s @out@(l,m,n)=@k
 . i @k'="" d  ;
 . . i $ql(i)>1 d  q  ;
 . . . s l=$$shrink($qs(i,$ql(i)-1))
 . . . d:$g(@out@(l,n))'=""
 . . . . ;n jj,n2
 . . . . ;f jj=2:1  s n2=$qs(i,$ql(i)-1)_"["_jj_"]"_"_"_n q:$g(@out@(l,n2))=""
 . . . . ;s n=n2
 . . . . ;b:$g(@out@(l,n))'=""
 . . . . s n=$$shrink($qs(i,$ql(i)-1))_"_"_n
 . . . s @out@(l,n)=@k
 . . s @out@(n)=@k
 q
 ;
shrink(x) ; reduce strings 
 n y,z
 s y=x
 s z="substanceadministration"
 i x[z s y=$p(x,z,2)
 q y
 ;
mkxpath(zq,zm) ; extrinsic which returns the xpath derived from the $query value 
 ;passed by value. zm is the index to begin with
 ;
 n zr s zr=""
 n zi s zi=""
 f zi=1:1:$ql(zq) s zr=zr_"/"_$qs(zq,zi)
 q zr
 ;
 ; todo: make this work for regular xml files - only works now with 
 ;   attributes to a single tag per entry
 ;
ary2xml(outxml,inary,stk,child) ; convert an array to xml
 i '$d(@outxml@(1)) s @outxml@(1)="<?xml version=""1.0"" encoding=""utf-8"" ?>"
 n ii s ii=""
 n dattr s dattr="" ; deffered attributes
 f  s ii=$o(@inary@(ii),-1) q:ii=""  d  ;
 . n attr,tag
 . s attr="" s tag=""
 . i ii["@" d  ;
 . . i tag="" s tag=$p(ii,"@",1) s attr=$p(ii,"@",2)_"="""_@inary@(ii)_""""
 . . w:$g(debug) !,"tag="_tag_" attr="_attr
 . . ;i $o(@inary@(ii))["@" d  ;
 . . ;f  s ii=$o(@inary@(ii),-1) q:ii=""  q:$o(@inary@(ii),-1)'[(tag_"@")  d  ;
 . . f  s ii=$o(@inary@(ii),-1) q:ii=""  q:ii'[(tag_"@")  d  ;
 . . . s attr=attr_" "_$p(ii,"@",2)_"="""_@inary@(ii)_""""
 . . . w:$g(debug) !,"attr= ",attr
 . . . w:$g(debug) !,"ii= ",ii
 . . s ii=$o(@inary@(ii)) ; reset to previous
 . . n ending s ending="/"
 . . i ii["@" d  ;
 . . . i $o(@inary@(ii),-1)=tag s dattr=" "_attr q  ; deffered attributes
 . . . i $d(@inary@(tag)) s ending=""
 . . . d oneout(outxml,"<"_tag_" "_attr_ending_">")
 . . . i ending="" d push("stk","</"_tag_">")
 . i ii'["@" d  ;
 . . i +ii=0 d  ;
 . . . d oneout(outxml,"<"_ii_dattr_">")
 . . . s dattr="" ; reinitialize after use
 . . . d push("stk","</"_ii_">")
 . i $d(@inary@(ii)) d ary2xml(outxml,$na(@inary@(ii)))
 i $d(stk) f  d oneout(outxml,$$pop("stk")) q:'$d(stk)
 q
 ;
push(buf,str) ;
 d oneout(buf,str)
 q
 ;
pop(buf) ; extrinsic returns the last element and then deletes it
 n nm,tx
 s nm=$o(@buf@(""),-1)
 q:nm="" nm
 s tx=@buf@(nm)
 k @buf@(nm)
 q tx
 ;
