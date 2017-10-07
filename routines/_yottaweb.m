%yottaweb ; gpl - utilities for c0ts; 7/4/15 6:03pm
 ;;1.0;no package;;mar 21, 2016;build 1
 ;
 q
 ;
 ; to do: implement the camel parameter:
 ; example - fileman_field if camel=1 becomes filemanfield
 ;    if camel=2 becomes filemanfield
 ;
fmrec(file,ien) ; extrinsic which returns the json version of the fmx return
 n %g,%gj
 d fmx("%g",file,ien)
 d ENCODE^VPRJSON("%g","%gj")
 q %gj
 ;
fmx(rtn,file,ien,camel) ; return an array of a fileman record for external 
 ; use in rtn, which is passed by name. 
 ;
 k @rtn
 n trec,filenm
 d GETS^DIQ(file,ien_",","**","ENR","trec")
 s filenm=$o(^DD(file,0,"NM",""))
 s filenm=$tr(filenm," ","_")
 ;zwr trec
 i $g(debug)=1 b
 n % s %=$q(trec(""))
 f  d  q:%=""  ;
 . n fnum,fname,iens,field,val
 . s fnum=$qs(%,1)
 . i $d(^DD(fnum,0,"NM")) d  ;
 . . s fname=$o(^DD(fnum,0,"NM",""))
 . . s fname=$tr(fname," ","_")
 . e  s fname=fnum
 . s iens=$qs(%,2)
 . s field=$qs(%,3)
 . s field=$tr(field," ","_")
 . s val=@%
 . i fnum=file d  ; not a subfile
 . . s @rtn@(fname,ien,field)=val
 . . s @rtn@(fname,"ien")=$p(iens,",",1)
 . e  d  ;
 . . n i2 s i2=$o(@rtn@(fname,""),-1)+1
 . . s @rtn@(fname,$p(iens,","),field)=val
 . . ;s @rtn@(fname,i2,field)=val
 . . ;s @rtn@(fname,i2,"iens")=iens
 . w:$g(debug)=1 !,%,"=",@%
 . s %=$q(@%)
 q
 ;example
 ;g("bsts_concept","codeset")=36
 ;g("bsts_concept","concept_id")=370206005
 ;g("bsts_concept","counter")=75
 ;g("bsts_concept","dts_id")=370206
 ;g("bsts_concept","fully_specified_name")="asthma limits walking on the flat (finding)"
 ;g("bsts_concept","last_modified")="may 11, 2015"
 ;g("bsts_concept","out_of_date")="no"
 ;g("bsts_concept","partial_entry")="non-patial (full entry)"
 ;g("bsts_concept","revision_in")="mar 01, 2012"
 ;g("bsts_concept","revision_out")="jan 01, 2050"
 ;g("bsts_concept","version")=20140901
 ;g("bsts_concept","ien")="75"
 ;g("is_a_relationship",1,"is_a_relationship")=2
 ;g("subsets",1,"subsets")="ehr ipl asthma dxs"
 ;g("subsets",2,"subsets")="srch cardiology"
 ;g("subsets",3,"subsets")="ihs problem list"
 ;
gpltest(rtn,filter) ;
 i '$d(rtn) s rtn=$na(^tmp("gpltest",$j))
 k @rtn
 n gtop,gbot
 d htmltb(.gtop,.gbot,"gpltest page")
 m @rtn=gtop
 n dfn s dfn=$g(filter("dfn"))
 i dfn="" s dfn=2
 n gary,ary,hary
 d fmx^kbaiweb("gary",2,dfn)
 s ary("header",1)="name"
 s ary("header",2)="date of birth"
 s ary("header",3)="age"
 s ary("title")="test html"
 s ary(1,1)=gary("patient","name")
 s ary(1,2)=gary("patient","date_of_birth")
 s ary(1,3)=gary("patient","age")          
 d genhtml2^kbaiutil(rtn,"ary")
 s @rtn@($o(@rtn@(""),-1)+1)=gbot
 k @rtn@(0)
 s HTTPRSP("mime")="text/html"
 q
 ;
htmltb(gtop,gbot,title) ; sets beginning and ending fixed html
 ;
 ;s gtop="<!doctype html><html><head></head><body>"
 s gtop(1)="<!doctype html>"
 s gtop(2)="<html>"
 s gtop(3)="<head>"
 s gtop(4)="<meta charset=""utf-8"">"
 s gtop(5)="<meta http-equiv=""content-type"" content=""text/html; charset=utf-8"" />"
 s gtop(6)="<title>"_$g(title)_"</title>"
 s gtop(7)="<link rel=""stylesheet"" type=""text/css"" href=""/resources/css/c0tstyle.css"" />"
 s gtop(8)="</head>"
 s gtop(9)="<body>"
 ;
 s gbot="</body></html>"
 q
 ;
htmltb2(gtop,gbot,title) ; sets beginning and ending fixed html
 ; this one is for standalone html files - no remote css
 ;s gtop="<!doctype html><html><head></head><body>"
 s gtop(1)="<!doctype html>"
 s gtop(2)="<html>"
 s gtop(3)="<head>"
 s gtop(4)="<meta charset=""utf-8"">"
 s gtop(5)="<meta http-equiv=""content-type"" content=""text/html; charset=utf-8"" />"
 s gtop(6)="<title>"_$g(title)_"</title>"
 ;s gtop(7)="<link rel=""stylesheet"" type=""text/css"" href=""/resources/css/c0tstyle.css"" />"
 ;s gtop(6.5)="<style>"
 s gtop(7)="<style>body {"
 s gtop(8)="    font-family: verdana, sans-serif;"
 s gtop(9)="    font-size: 10pt;"
 s gtop(10)="}"
 s gtop(11)="div.formats {"
 s gtop(12)="    border: 1px solid black;"
 ;s gtop(13)="    margin: 2em;"
 s gtop(13)="    margin: .02em;"
 s gtop(14)="    width: 20em;"
 s gtop(15)="    padding: 0.4em;"
 s gtop(16)="}"
 s gtop(17)="div.formats p {"
 s gtop(18)="    display: inline;"
 s gtop(19)="}"
 s gtop(20)="div.formats ul, div.formats li {"
 s gtop(21)="    display: inline;"
 s gtop(22)="    color: #333399;"
 s gtop(23)="    margin: 0px;"
 s gtop(24)="    padding: 0px;"
 s gtop(25)="    font-weight: bold;"
 s gtop(26)="}"
 s gtop(27)="div.formats li {"
 s gtop(28)="    padding: 0px 0.1em;"
 s gtop(29)="}"
 s gtop(30)="div.tables {"
 s gtop(31)="    margin: 1em auto; align: left;"
 s gtop(32)="}"
 s gtop(33)="table {"
 s gtop(34)="    border-collapse: collapse;"
 ;s gtop(35)="    margin: 3em auto;"
 ;s gtop(35)="    margin: 3em auto;"
 s gtop(35)=" "
 s gtop(36)="}"
 s gtop(37)="table caption {"
 s gtop(38)="    font-size: 110%;"
 s gtop(39)="    padding: 0.4em;"
 s gtop(40)="    background-color: black;"
 s gtop(41)="    color: white;"
 s gtop(42)="    font-weight: bold;"
 s gtop(43)="}"
 s gtop(44)="table td, table th {"
 s gtop(45)="    border: 1px solid #e0e0e0;"
 s gtop(46)="    margin: 0px;"
 s gtop(47)="    padding: 0.4em;"
 s gtop(48)="    white-space: normal; word-wrap: break-word;"
 s gtop(49)="}"
 s gtop(50)="table th {"
 s gtop(51)="    background-color: #808080;"
 s gtop(52)="    color: white;"
 s gtop(53)="    font-weight: bold;"
 s gtop(54)="    text-align: center;"
 s gtop(55)="}"
 s gtop(56)="table td {"
 s gtop(57)="    font-size: 90%;"
 s gtop(58)="    padding: 0.4em; white-space:normal; word-wrap: break-word;"
 s gtop(59)="}"
 s gtop(60)="</style>"
 s gtop(61)="</head>"
 s gtop(62)="<body>"
 ;
 s gbot="</body></html>"
 q
 ;
