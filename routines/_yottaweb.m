%yottaweb ;ven/gpl-yottadb extension: utilities ;2018-02-08T20:06Z
 ;;1.8;Mash;
 ;
 ; %yottaweb implements Yottadb Extension Library web-interface
 ; ppis & apis. This will eventually be migrated to other Mash
 ; namespaces, perhaps %ww. In the meantime, they will be added
 ; to the new %yotta ppi library.
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
 ;@last-updated: 2018-02-08T20:06Z
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
 ; 2017-07-04 ven/gpl %*1.8t01 %yottaweb: create routine to hold
 ; yottadb web-interface methods.
 ;
 ; 2017-09-12 ven/gpl %*1.8t01 %yottaweb: update
 ;
 ; 2017-09-27 ven/gpl %*1.8t01 %yottaweb: update
 ;
 ; 2017-10-07 ven/gpl %*1.8t01 %yottaweb: update
 ;
 ; 2018-02-08 ven/toad %*1.8t04 %yottaweb: passim add white space &
 ; hdr comments & do-dot quits, tag w/Apache license & attribution
 ; & to-do to shift namespace later.
 ;
 ;@to-do
 ; implement the camel parameter:
 ; example - fileman_field if camel=1 becomes filemanfield
 ;  if camel=2 becomes filemanfield
 ; %yotta: create entry points in ppi/api style
 ; r/all local calls w/calls through ^%yotta
 ; eventually renamespace, perhaps under %ww
 ;
 ;@contents
 ;
 ;
 ;
 ;@section 1 code to implement ppis & apis
 ;
 ;
 ;
fmrec(file,ien) ; extrinsic which returns the json version of the fmx return
 ;
 new %g,%gj
 do fmx("%g",file,ien)
 do ENCODE^VPRJSON("%g","%gj")
 ;
 quit %gj ; end of $$fmrec
 ;
 ;
 ;
fmx(rtn,file,ien,camel) ; return an array of a fileman record for external 
 ;
 ; use in rtn, which is passed by name. 
 ;
 kill @rtn
 new trec,filenm
 do GETS^DIQ(file,ien_",","**","ENR","trec")
 set filenm=$order(^DD(file,0,"NM",""))
 set filenm=$translate(filenm," ","_")
 ; zwrite trec
 if $get(debug)=1 break
 new % set %=$query(trec(""))
 for  do  quit:%=""  ;
 . new fnum,fname,iens,field,val
 . set fnum=$qsubscript(%,1)
 . if $data(^DD(fnum,0,"NM")) do  ;
 . . set fname=$order(^DD(fnum,0,"NM",""))
 . . set fname=$translate(fname," ","_")
 . . quit
 . else  set fname=fnum
 . set iens=$qsubscript(%,2)
 . set field=$qsubscript(%,3)
 . set field=$translate(field," ","_")
 . set val=@%
 . if fnum=file do  ; not a subfile
 . . set @rtn@(fname,ien,field)=val
 . . set @rtn@(fname,"ien")=$piece(iens,",",1)
 . . quit
 . else  do  ;
 . . new i2 set i2=$order(@rtn@(fname,""),-1)+1
 . . set @rtn@(fname,$piece(iens,","),field)=val
 . . ; set @rtn@(fname,i2,field)=val
 . . ; set @rtn@(fname,i2,"iens")=iens
 . . quit
 . write:$get(debug)=1 !,%,"=",@%
 . set %=$query(@%)
 . quit
 ;
 quit  ; end of fmx
 ;
 ;
 ;
 ; example
 ; g("bsts_concept","codeset")=36
 ; g("bsts_concept","concept_id")=370206005
 ; g("bsts_concept","counter")=75
 ; g("bsts_concept","dts_id")=370206
 ; g("bsts_concept","fully_specified_name")="asthma limits walking on the flat (finding)"
 ; g("bsts_concept","last_modified")="may 11, 2015"
 ; g("bsts_concept","out_of_date")="no"
 ; g("bsts_concept","partial_entry")="non-patial (full entry)"
 ; g("bsts_concept","revision_in")="mar 01, 2012"
 ; g("bsts_concept","revision_out")="jan 01, 2050"
 ; g("bsts_concept","version")=20140901
 ; g("bsts_concept","ien")="75"
 ; g("is_a_relationship",1,"is_a_relationship")=2
 ; g("subsets",1,"subsets")="ehr ipl asthma dxs"
 ; g("subsets",2,"subsets")="srch cardiology"
 ; g("subsets",3,"subsets")="ihs problem list"
 ;
 ;
 ;
gpltest(rtn,filter) ;
 ;
 if '$data(rtn) set rtn=$name(^tmp("gpltest",$job))
 kill @rtn
 new gtop,gbot
 do htmltb(.gtop,.gbot,"gpltest page")
 merge @rtn=gtop
 new dfn set dfn=$get(filter("dfn"))
 if dfn="" set dfn=2
 new gary,ary,hary
 do fmx^kbaiweb("gary",2,dfn)
 set ary("header",1)="name"
 set ary("header",2)="date of birth"
 set ary("header",3)="age"
 set ary("title")="test html"
 set ary(1,1)=gary("patient","name")
 set ary(1,2)=gary("patient","date_of_birth")
 set ary(1,3)=gary("patient","age")          
 do genhtml2^kbaiutil(rtn,"ary")
 set @rtn@($order(@rtn@(""),-1)+1)=gbot
 kill @rtn@(0)
 set HTTPRSP("mime")="text/html"
 ;
 quit  ; end of gpltest
 ;
 ;
 ;
htmltb(gtop,gbot,title) ; sets beginning and ending fixed html
 ;
 ; set gtop="<!doctype html><html><head></head><body>"
 set gtop(1)="<!doctype html>"
 set gtop(2)="<html>"
 set gtop(3)="<head>"
 set gtop(4)="<meta charset=""utf-8"">"
 set gtop(5)="<meta http-equiv=""content-type"" content=""text/html; charset=utf-8"" />"
 set gtop(6)="<title>"_$g(title)_"</title>"
 set gtop(7)="<link rel=""stylesheet"" type=""text/css"" href=""/resources/css/c0tstyle.css"" />"
 set gtop(8)="</head>"
 set gtop(9)="<body>"
 ;
 set gbot="</body></html>"
 ;
 quit  ; end of htmltb
 ;
 ;
 ;
htmltb2(gtop,gbot,title) ; sets beginning and ending fixed html
 ;
 ; this one is for standalone html files - no remote css
 ;
 ; set gtop="<!doctype html><html><head></head><body>"
 set gtop(1)="<!doctype html>"
 set gtop(2)="<html>"
 set gtop(3)="<head>"
 set gtop(4)="<meta charset=""utf-8"">"
 set gtop(5)="<meta http-equiv=""content-type"" content=""text/html; charset=utf-8"" />"
 set gtop(6)="<title>"_$get(title)_"</title>"
 ; set gtop(7)="<link rel=""stylesheet"" type=""text/css"" href=""/resources/css/c0tstyle.css"" />"
 ; set gtop(6.5)="<style>"
 set gtop(7)="<style>body {"
 set gtop(8)="    font-family: verdana, sans-serif;"
 set gtop(9)="    font-size: 10pt;"
 set gtop(10)="}"
 set gtop(11)="div.formats {"
 set gtop(12)="    border: 1px solid black;"
 ; set gtop(13)="    margin: 2em;"
 set gtop(13)="    margin: .02em;"
 set gtop(14)="    width: 20em;"
 set gtop(15)="    padding: 0.4em;"
 set gtop(16)="}"
 set gtop(17)="div.formats p {"
 set gtop(18)="    display: inline;"
 set gtop(19)="}"
 set gtop(20)="div.formats ul, div.formats li {"
 set gtop(21)="    display: inline;"
 set gtop(22)="    color: #333399;"
 set gtop(23)="    margin: 0px;"
 set gtop(24)="    padding: 0px;"
 set gtop(25)="    font-weight: bold;"
 set gtop(26)="}"
 set gtop(27)="div.formats li {"
 set gtop(28)="    padding: 0px 0.1em;"
 set gtop(29)="}"
 set gtop(30)="div.tables {"
 set gtop(31)="    margin: 1em auto; align: left;"
 set gtop(32)="}"
 set gtop(33)="table {"
 set gtop(34)="    border-collapse: collapse;"
 ; set gtop(35)="    margin: 3em auto;"
 ; set gtop(35)="    margin: 3em auto;"
 set gtop(35)=" "
 set gtop(36)="}"
 set gtop(37)="table caption {"
 set gtop(38)="    font-size: 110%;"
 set gtop(39)="    padding: 0.4em;"
 set gtop(40)="    background-color: black;"
 set gtop(41)="    color: white;"
 set gtop(42)="    font-weight: bold;"
 set gtop(43)="}"
 set gtop(44)="table td, table th {"
 set gtop(45)="    border: 1px solid #e0e0e0;"
 set gtop(46)="    margin: 0px;"
 set gtop(47)="    padding: 0.4em;"
 set gtop(48)="    white-space: normal; word-wrap: break-word;"
 set gtop(49)="}"
 set gtop(50)="table th {"
 set gtop(51)="    background-color: #808080;"
 set gtop(52)="    color: white;"
 set gtop(53)="    font-weight: bold;"
 set gtop(54)="    text-align: center;"
 set gtop(55)="}"
 set gtop(56)="table td {"
 set gtop(57)="    font-size: 90%;"
 set gtop(58)="    padding: 0.4em; white-space:normal; word-wrap: break-word;"
 set gtop(59)="}"
 set gtop(60)="</style>"
 set gtop(61)="</head>"
 set gtop(62)="<body>"
 ;
 set gbot="</body></html>"
 ;
 quit  ; end of htmltb2
 ;
 ;
 ;
eor ; end of routine %yottaweb
