yottagr ;ven/gpl-yottadb extension: graphstore ;2018-03-11T22:31Z
 ;;1.8;Mash;
 ;
 ; %yottagr implements the Yottadb Extension Library's graphstore
 ; ppis & apis. These may eventually migrate to another Mash
 ; namespace, tbd. In the meantime, they will get a %yotta ppi &
 ; api library built.
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
 ;@last-updated: 2018-03-11T22:31Z
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
 ; 2017-02-17 ven/gpl %*1.8t01 %yottagr: create routine to hold
 ; all yottadb graph methods.
 ;
 ; 2017-09-16 ven/gpl %*1.8t01 %yottagr: update
 ;
 ; 2017-09-18 ven/gpl %*1.8t01 %yottagr: update
 ;
 ; 2017-10-07 ven/gpl %*1.8t01 %yottagr: update
 ;
 ; 2018-02-07/11 ven/toad %*1.8t04 %yottagr: passim add white space &
 ; hdr comments & do-dot quits, tag w/Apache license & attribution
 ; & to-do to shift namespace later, break up a few long line. debug.
 ;
 ; 2018-03-10/11 ven/toad %*1.8t04 %yottagr: fix $namew typo.
 ;
 ;@to-do
 ; %yotta: create entry points in ppi/api style
 ; r/all local calls w/calls through ^%yotta
 ; break up into smaller routines & change branches from %yotta
 ; renamespace elsewhere, research best choice
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
 if '$data(graph) set graph="seeGraph"
 new %y set %y=$order(^%wd(17.040801,"B",graph,""))
 if %y="" set %y=$$addgraph(graph) ; if graph is not present, add it
 ;
 quit $na(^%wd(17.040801,%y)) ; root for graph ; end of $$setroot
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
 quit %y ; end of $$addgraph
 ;
 ;
 ;
homedir() ; extrinsic which return the document home
 ;
 new kbaihd set kbaihd=$get(^%WHOME)
 if kbaihd="" do  break  ;
 . write !,"error, home directory not set"
 . quit
 if $extract(kbaihd,$length(kbaihd))="/" do
 . set kbaihd=$extract(kbaihd,1,$length(kbaihd)-1)
 . quit
 ;
 quit kbaihd ; end of $$homedir
 ;
 ;
 ;
build ; retrieve directory structure and build into xtmp
 ;
 new kbairoot
 set kbairoot=$$setroot()
 ;
 ; kill @kbairoot
 ; if '$data(@kbairoot@(0)) do  quit  ; work area doesn't exist
 ; . write !,"error, work area not found ",kbairoot
 ; . quit
 ; . new X,Y
 ; . set X="T+999" ; a long time from now
 ; . do ^%DT ; covert to fm date format
 ; . set @kbairoot@(0)=Y_"^"_$$NOW^XLFDT_"^kbaiwsai graph"
 ; . quit
 ;
 zsystem "ls -DRL --file-type ~/www > ~/www/dirconfig.txt"
 new zdir set zdir=^%WHOME
 new kbails,kbails1,ok
 set kbails=$na(@kbairoot@("ls"))
 set kbails1=$name(@kbails@(1))
 set ok=$$FTG^%ZISH(zdir,"dirconfig.txt",kbails1,4)
 do bldgraph
 ;
 quit  ; end of build
 ;
 ;
 ;
bldgraph ; build the graph in xtmp
 ;
 new kbairoot set kbairoot=$$setroot()
 new hmdir set hmdir=$$homedir()
 new groot set groot=$name(@kbairoot@("graph"))
 ; kill @groot
 new gsrc set gsrc=$name(@kbairoot@("ls"))
 new zi,zj,zln,zien,zien2,uriary,distdir,localdir
 set distdir="root"  ;
 set zien=0
 set zien2=0 ; subfile ien
 set zi=0
 new %cnt set %cnt=0
 for  set zi=$order(@gsrc@(zi)) quit:+zi=0  do  ;
 . new zln,zdir,zpar,ztag
 . set zln=@gsrc@(zi)
 . quit:zln=""
 . if zln[":" do  quit  ;
 . . set %cnt=%cnt+1
 . . ; if %cnt>100000 do counts(groot) set %cnt=1 ; this is for watching progress on big builds
 . . set zien=zien+1
 . . if $extract(zln,$length(zln))=":" set zln=$extract(zln,1,$length(zln)-1) ; strip off the :
 . . if $get(distdir)="" set distdir="root"  ;
 . . set @groot@(zien,"parent",distdir)=""
 . . set @groot@("pos","parent",distdir,zien)=""
 . . set @groot@("ops",distdir,"parent",zien)=""
 . . set localdir=zln
 . . set @groot@(zien,"localdir",localdir)=""
 . . set @groot@("pos","localdir",localdir,zien)=""
 . . set @groot@("ops",localdir,"localdir",zien)=""
 . . ; set graph type
 . . set @groot@(zien,"type","directory")=""
 . . set @groot@("pos","type","directory",zien)=""
 . . set @groot@("ops","directory","type",zien)=""
 . . set distdir=$piece(localdir,$$homedir,2)
 . . if distdir'="" do  ;
 . . . set @groot@(zien,"distdir",distdir)=""
 . . . set @groot@("pos","distdir",distdir,zien)=""
 . . . set @groot@("ops",distdir,"distdir",zien)=""
 . . . set @groot@(zien,"id",distdir)=""
 . . . set @groot@("pos","id",distdir,zien)=""
 . . . set @groot@("ops",distdir,"id",zien)=""
 . . . kill uriary do deuri(distdir,"uriary")
 . . . quit
 . . set zien2=0
 . . quit
 . ; process file names as a subfile to the directory
 . set zien2=zien2+1
 . ; set parent pointer
 . if $get(distdir)="" set distdir="root"  ;
 . set @groot@(zien,zien2,"parent",distdir)=""
 . set @groot@("pos","parent",distdir,zien,zien2)=""
 . set @groot@("ops",distdir,"parent",zien,zien2)=""
 . ; set file name attribute
 . set @groot@(zien,zien2,"file",zln)=""
 . set @groot@("pos","file",zln,zien,zien2)=""
 . set @groot@("ops",zln,"file",zien,zien2)=""
 . ; tag the file name
 . set @groot@(zien,zien2,"tag",zln)=""
 . set @groot@("pos","tag",zln,zien,zien2)=""
 . set @groot@("ops",zln,"tag",zien,zien2)=""
 . ; added to tag qrda cqm names
 . if $extract(zln,1,3)="CMS" do  ;
 . . new cqm
 . . set cqm=$piece(zln,"_",1)
 . . do addtag(cqm,zien,zien2)
 . . quit
 . ;
 . ; set the file id
 . new zid set zid=distdir_"/"_zln
 . if distdir="root" set zid=zln
 . set @groot@(zien,zien2,"id",zid)=""
 . set @groot@("pos","id",zid,zien,zien2)=""
 . set @groot@("ops",zid,"id",zien,zien2)=""
 . new ztyp ; graph type
 . if $extract(zln,$length(zln))="/" set ztyp="directory"
 . else  set ztyp="file"
 . set @groot@(zien,zien2,"type",ztyp)=""
 . set @groot@("pos","type",ztyp,zien,zien2)=""
 . set @groot@("ops",ztyp,"type",zien,zien2)=""
 . new zftyp
 . set zftyp=$reverse($piece($reverse(zln),".",1))
 . if zftyp'="" do  ;
 . . set @groot@(zien,zien2,"filetype",zftyp)=""
 . . set @groot@("pos","filetype",zftyp,zien,zien2)=""
 . . set @groot@("ops",zftyp,"filetype",zien,zien2)=""
 . . set @groot@(zien,zien2,"tag",zftyp)=""
 . . set @groot@("pos","tag",zftyp,zien,zien2)=""
 . . set @groot@("ops",zftyp,"tag",zien,zien2)=""
 . . ; tag the name without the filetype
 . . new zfn2
 . . set zfn2=$reverse($piece($reverse(zln),$reverse(zftyp)_".",2))
 . . if zfn2'="" do  ;
 . . . set @groot@(zien,zien2,"tag",zfn2)=""
 . . . set @groot@("pos","tag",zfn2,zien,zien2)=""
 . . . set @groot@("ops",zfn2,"tag",zien,zien2)=""
 . . . new contents
 . . . if zftyp["xml" do  ;
 . . . . do scan(.contents,zid,zien,zien2) ; not scanning right now
 . . . . quit
 . . . quit
 . . quit
 . set @groot@(zien,zien2,"localdir",localdir)=""
 . set @groot@("pos","localdir",localdir,zien,zien2)=""
 . set @groot@("ops",localdir,"localdir",zien,zien2)=""
 . if $get(distdir)'="" do  ;
 . . set @groot@(zien,zien2,"distdir",distdir)=""
 . . set @groot@("pos","distdir",distdir,zien,zien2)=""
 . . set @groot@("ops",distdir,"distdir",zien,zien2)=""
 . . quit
 . ; add the tags from the directory
 . new zj set zj=""
 . for  set zj=$order(uriary(zj)) quit:zj=""  do  ;
 . . set @groot@(zien,zien2,"tag",uriary(zj))=""
 . . set @groot@("pos","tag",uriary(zj),zien,zien2)=""
 . . set @groot@("ops",uriary(zj),"tag",zien,zien2)=""
 . . quit
 . ; if zien=3344 break
 . quit
 ; compute the counts
 do counts(groot) ;
 ;
 quit  ; end of bldgraph
 ;
 ;
 ;
counts(groot) ;
 ;
 new ztag,zary,zcnt
 kill @groot@("countbytag")
 kill @groot@("tagbycount")
 set ztag=""
 for  set ztag=$order(@groot@("pos","tag",ztag)) quit:ztag=""  do  ;
 . if ztag="" quit  ;
 . kill zary
 . do match("#tag:"_ztag,"zary")
 . ; write !,ztag," ",$data(zary)
 . set zcnt=$$count("zary")
 . if zcnt<1 quit  ;
 . set @groot@("countbytag",ztag,zcnt)=""
 . set @groot@("tagbycount",zcnt,ztag)=""
 . quit
 ;
 quit  ; end of counts
 ;
 ;
 ;
testscan ;
 ;
 set zien=4
 set zien2=1
 ; set zid=$order(^xtmp("kbaiweb","graph",4,1,"id",""))
 set zid=$order(@$$setroot@("graph",4,1,"id",""))
 do scan(.g,zid,zien,zien2)
 ;
 quit  ; end of testscan
 ;
 ;
 ;
scan(rtn,zid,zien,zien2) ; scan the file contents for new tags
 ;
 ; and add them to the graph
 ;
 new zcmd,tmpfile,tmpdir,cmdfile
 set tmpfile="scan.txt"
 set cmdfile="scan.sh"
 set tmpdir=^%WHOME
 set zcmd=$name(^tmp("kbaicmd",$job))
 set zcmd1=$name(@zcmd@(1))
 set @zcmd@(1)="rm "_tmpdir_"/"_tmpfile
 new g2 set g2=""
 for i=1:1:$length(zid) set g2=g2_$select($extract(zid,i)=" ":"\ ",1:$extract(zid,i))
 ; set @zcmd@(2)="grep code "_tmpdir_"/"_zid_" > "_tmpdir_"/"_tmpfile
 set @zcmd@(2)="grep code "_tmpdir_g2_" > "_tmpdir_tmpfile
 ; set @zcmd@(3)="grep originaltext "_tmpdir_"/"_zid_" >> "_tmpdir_"/"_tmpfile
 set @zcmd@(3)="grep originaltext "_tmpdir_g2_" >> "_tmpdir_tmpfile
 new ok
 set ok=$$GTF^%ZISH(zcmd1,3,tmpdir,cmdfile)
 zsystem "bash ../www/scan.sh"
 new where set where=$name(^tmp("kbaiscan",$job))
 kill @where
 new where1 set where1=$name(@where@(1))
 set ok=$$FTG^%ZISH(tmpdir,tmpfile,where1,3)
 if ok do  ;
 . new zi set zi=0
 . for  set zi=$order(@where@(zi)) quit:+zi=0  do  ;
 . . new zl set zl=@where@(zi)
 . . if zl["code" do  ;
 . . . new code
 . . . set code=$piece($piece(zl,"code=""",2),""" ")
 . . . if code[">" quit  ;
 . . . if code["""" quit  ;
 . . . ; break
 . . . new name
 . . . set name=$piece($piece(zl,"displayName=""",2),"""")
 . . . if name["[&quot;" set name=$piece($piece(name,"[&quot;",2),"&quot;]")
 . . . if name="" do  ;
 . . . . if zl["<originalText" do  ;
 . . . . . set name=$piece($piece(zl,"<originalText>",2),"</originalText>")
 . . . . . quit
 . . . . quit
 . . . quit:code=""
 . . . do addtag(code_" "_name,zien,zien2)
 . . . ; do addtag(code,zien,zien2)
 . . . quit
 . . quit
 . quit
 ;
 ; zwrite ^tmp("kbaiscan",$job,*)
 ;
 quit  ; end of scan
 ;
 ;
 ;
addtag(tag,zien,zien2) ; add a tag to a graph
 ;
 ; write !,"adding ",tag," at ",zien," ",zien2 
 ;
 new gn set gn=$na(@$$setroot@("graph"))
 set @gn@(zien,zien2,"tag",tag)=""
 set @gn@("pos","tag",tag,zien,zien2)=""
 set @gn@("ops",tag,"tag",zien,zien2)=""
 ; zwrite @$$setroot@("graph",:,:,tag,zien,zien2)
 ;
 quit  ; end of addtag
 ;
 ;
 ;
wssee(rtn,filter) ; web service for browsing files using the graph
 ;
 merge ^SAMIGPL("filter")=filter
 new arg set arg=$get(filter("*"))
 if arg="" do toppage^%yottahtm(.rtn,.filter) quit  ;
 ;
 ; if arg="@rewrite" do rewrite(.rtn) quit  ;
 ;
 if arg]"%" set arg=$$URLDEC^VPRJRUT(arg)
 new ptrary ; pointer array for result
 new groot set groot=$name(@$$setroot@("graph"))
 ;
 ; if $$lookup(arg,"id",.ptrary)= do  quit  ; id arg is found
 ; . if $$count(.ptrary)=1 do  ; just one match
 ; . . ;
 ; . . quit
 ; . quit
 ; if $order(@$$setroot@("graph","pos","id","/"_arg,""))'="" do  quit  ;
 ; if $order(@groot@("pos","id","/"_arg,""))'="",arg'="ehmp" do  quit  ;
 ;
 if $order(@groot@("pos","id","/"_arg,""))'="" do  quit  ;
 . ; new zdest set zdest="/"_arg
 . ; if $$stat(arg)'["regular file" set zdest=$$locate(arg)
 . ; if zdest'=arg set filter("*")=zdest
 . if $extract(arg,$length(arg))="/" do dir(.rtn,arg) quit  ; it's a directory
 . ; if $reverse($piece($reverse(arg),"."))="xml" do style(.rtn,arg) quit  ;
 . if $reverse($piece($reverse(arg),"."))="xml" do  quit  ;
 . . do style(.rtn,arg)
 . . do ADDCRLF^VPRJRUT(.rtn)
 . . quit
 . set filter("*")=arg
 . do FILESYS^%W0(.rtn,.filter)
 . quit
 ;
 ; request is not an id in the graph, so try and find the file if any
 new zf,zuri
 set zuri=$$useuri($$isfile(arg),arg)
 if zuri=-1 set zuri=$$useuri($$altfile($$isfile(arg)),arg)
 if zuri'=-1 do  quit  ;
 . if $reverse($piece($reverse(zuri),"."))="xml" do  quit  ;
 . . do style(.rtn,zuri)
 . . do ADDCRLF^VPRJRUT(.rtn)
 . . quit
 . set filter("*")=zuri
 . do FILESYS^%W0(.rtn,.filter)
 . quit
 ;
 ; set zf=$$isfile(arg)
 ; if zf'=-1 set zuri=$$useuri(zf) ;
 ; else  do  ;
 ; . set zf=$$altfile(zf)
 ; . if zf'=-1 set zuri=$$useuri(zf)
 ; . quit
 ; if zuri'=1 do  quit  ;
 ; . set filter("*")=zuri
 ; . do FILESYS^%W0(.rtn,.filter)
 ; . quit
 ;
 new matches
 ;
 ; if arg["%20" s arg=$translate(arg,"%20"," ")
 ;
 do match("#"_arg,"matches")
 ;
 ; merge ^SAMIGPL("matches")=matches
 ; if $data(matches) set rtn=$query(matches)
 ;
 if $$count("matches")>0 do  quit  ; more than one match
 . do multout(.rtn,"matches")
 . quit
 ;
 quit  ; end of wssee
 ;
 ;
 ;
style(rtn,zuri) ;
 ;
 new gn set gn=$name(^tmp("kbaiout",$job))
 new gn1 set gn1=$name(@gn@(1))
 kill @gn
 new ok
 set ok=$$FTG^%ZISH($$dirpart(zuri),$$isfile(zuri),gn1,3)
 if 'ok do  quit  ;
 . ; break
 . set filter("*")=zuri
 . do FILESYS^%W0(.rtn,.filter)
 . quit
 set HTTPRSP("mime")="text/xml"
 ;
 ; new gt1
 ; set gt1="<?xml-stylesheet type=""text/xsl"" href=""/resources/css/cda.xslt""?>"
 ; if $get(@gn@(1))["?>" do  ;
 ; . new gt set gt=$piece(@gn@(1),"?>",1)_"?>"_gt1_$piece(@gn@(1),"?>",2)
 ; . set @gn@(1)=gt
 ; . quit
 ; set @gn@(1)=@gn@(1)_"<?xml-stylesheet type=""text/xml"" href=""/resources/css/cda.xsl""?>"
 ;
 set @gn@(1.5)="<?xml-stylesheet type=""text/xml"" href=""/resources/css/cda.xsl""?>"
 set rtn=gn
 ;
 quit  ; end of style
 ;
 ;
 ;
parent(zarg) ; extrinsic which returns the parent of the zarg
 ;
 new groot set groot=$name(@$$setroot@("graph"))
 new zien
 set zien=$order(@groot@("pos","id","/"_zarg,""))
 if zien="" quit ""
 ;
 quit $order(@groot@(zien,"parent",""))
 ;
 ;
 ;
isfile(zarg) ; extrinsic to return the file name from a uri
 ;
 ; -1 if it's not a file
 ;
 new rslt
 set rslt=$reverse($piece($reverse(zarg),"/"))
 if rslt="" set rslt=-1
 ;
 quit rslt ; end of $$isFile
 ;
 ;
 ;
dirpart(zuri) ; extrinsic which returns the directory part of the file uri
 ;
 new rslt
 set rslt=$piece(zuri,$$isfile(zuri),1)
 if rslt="" set rslt=-1
 ;
 quit ^%WHOME_rslt ; end of $$dirpart
 ;
 ;
 ;
altfile(zfile) ; extrinsic which tries to take the version number out of
 ;
 ; the filename ie jasmine-1.3.1.js becomes jasmine.js
 ;
 new z1,z2,z3,z4,z5
 set z1=$reverse(zfile) ; sj.1.3.1-enimsaj
 set z2=$piece(z1,".",4) ; 1-enimsaj
 ; write:$get(debug) !,"z2=",z2
 ; set z3=$piece(z2,"-",2) ; enimsaj
 set z3=$extract(z2,3,$length(z2))
 ; write:$get(debug) !,"z3=",z3,!
 set z4="."_$reverse($piece(z1,".",1)) ; .js
 ; write:$get(debug) !,"z4=",z4,!
 set z5=$reverse(z3)_z4
 ;
 quit z5 ; end of $$altfile
 ;
 ;
 ;
useuri(zfile,zarg) ; extrinsic which returns the uri to use for a filename
 ;
 ; -1 if none found
 ;
 new z1,z2,groot,zr
 set groot=$name(@$$setroot@("graph"))
 set z1=$order(@groot@("pos","file",zfile,""))
 if z1="" quit -1
 set z2=$order(@groot@("pos","file",zfile,z1,""))
 set zr=$order(@groot@(z1,z2,"id",""))
 if zr="" set zr=-1
 ; if zr'=-1 do logrewr(zarg,zr)
 ;
 quit zr ; end of $$useuri
 ;
 ;
 ;
multout(rtn,zary,title) ; return and html page with multiple selections
 ;
 ; zary is passed by name and is usually a "match" array
 ;
 do  ;
 . set rtn=$name(^tmp("kbaiwsai",$j))
 . kill @rtn
 . new gtop,gbot
 . do htmltb2^%yottaweb(.gtop,.gbot,"search results for #"_arg)
 . merge @rtn=gtop
 . if $data(title) do addto^%yottautl(rtn,"<p>"_title_"</p>")
 . do addto^%yottautl(rtn,"<ul>")
 . new zcnt,zstop set (zcnt,zstop)=0
 . new zi set zi=zary
 . for  set zi=$query(@zi) quit:((zi="")!(zstop))  do  ;
 . . set zcnt=zcnt+1
 . . if zcnt>1000 set zstop=1
 . . new zptr set zptr=$$fmtptr(zi)
 . . new zd,zf,zref
 . . set zd=$order(@zptr@("localdir",""))
 . . set zd=$piece(zd,$$homedir,2)
 . . ; if $extract(zd,$length(zd))="/" do  quit  ; it's a directory
 . . set zf=$order(@zptr@("file",""))
 . . set zref="<a href=""/see"_zd_"/"_zf_""">"_zd_"/"_zf_"</a>"
 . . do addto^%yottautl(rtn,"<li>"_zref_"</li>")
 . . quit
 . do addto^%yottautl(rtn,"</ul>")
 . kill @rtn@(0)
 . set HTTPRSP("mime")="text/html"
 . set @rtn@($order(@rtn@(""),-1)+1)=gbot
 . quit
 ;
 ; if $extract(arg,$length(arg))="/" do  quit  ; it's a directory
 ; . set rtn="it's a directory"
 ; . quit
 ; do FILESYS^%W0(.rtn,.filter)
 ;
 quit  ; end of multout
 ;
 ;
 ;
dir(rtn,zpar)
 ;
 new zi,dirary
 new groot set groot=$name(@$$setroot@("graph"))
 new adj set adj="/"_$extract(zpar,1,$length(zpar)-1)
 merge dirary=@groot@("pos","parent",adj)
 ; set dirary("up")=$get(@groot@("
 ; break
 if '$data(dirary) quit  ;
 do multout(.rtn,"dirary")
 ;
 quit  ; end of dir
 ;
 ;
 ;
deuri(in,out) ; deconstruct a uri. in passed by value out passed by name
 ;
 new zzi
 for zzi=2:1:$length(in,"/") set @out@(zzi-1)=$piece(in,"/",zzi)
 ;
 quit  ; end of deuri
 ;
 ;
 ;
reuri(in) ; extrinsic which reconstructs a uri from an array
 ;
 quit  ; end of reuri
 ;
 ;
 ;
repar(in) ; extrinsic which reconstructs a parent uri from an array
 ;
 quit  ; end of repar
 ;
 ;
 ;
show(zien,zien2) ;
 ;
 if $get(zien)="" set zien=1
 if $get(zien2)="" zwrite @$$setroot@("graph",zien,*) quit  ;
 zwrite @$$setroot@("graph",zien,zien2,*)
 ;
 quit  ; end of show
 ;
 ;
 ;
fmtptr(inref) ; extrinsic forms a closed global reference to the graph
 ;
 ; inref is passed by value and looks like g(2897,3)
 ; returns ^xtmp("kbaiweb","graph",3297,3) based on setroot
 ;
 new %1,%2 set %1=$name(@$$setroot@("graph"))
 set %1=$piece(%1,")",1)
 set %2=$piece(inref,"(",2)
 ;
 quit %1_","_%2 ; end of fmtptr
 ;
 ;
 ;
gshow(inary) ; show the location and file names pointed to by inary
 ;
 ; inary is passed by name
 ;
 new %
 new z1 set z1=inary
 for  set z1=$query(@z1) quit:z1=""  do  ;
 . new z2,z3
 . set %=$$fmtptr(z1)
 . set z2=$name(@%@("file"))
 . write !,z2,"   ",$order(@z2@(""))
 . set z3=$name(@%@("distdir"))
 . write !,"   ",$order(@z3@(""))
 . quit
 ;
 quit  ; end of gshow
 ;
 ;
 ;
match(input,outary) ; extrinsic which returns the count of matches, 0 if none
 ;
 ; input is a string eg.. #ehmp#applets.
 ; outary is passed by name and returns
 ; the iens of the graph elements that match
 ; ie.. outary(1,2)="" and outary(3)
 ;
 new po ; predicate object array
 do hashpars(input,"po")
 if '$data(po) quit 0 ;
 new groot set groot=$$setroot()
 new posroot set posroot=$name(@groot@("graph","pos"))
 if $order(po(""),-1)=1 do  quit  ; $$count(outary)
 . ; only one hash tag to search for
 . new pred,obj
 . set pred=$order(po(1,""))
 . set obj=$order(po(1,pred,""))
 . if '$data(@posroot@(pred,obj)),$data(@posroot@(pred,obj_" ")) do
 . . set obj=obj_" "
 . . quit
 . if $order(@posroot@(pred,obj,""))="" quit  ;
 . kill @outary
 . merge @outary=@posroot@(pred,obj)
 . quit
 ;
 quit  ; end of match
 ;
 ;
 ;
count(ary) ; count the number of entries in the array ary pased by name
 ;
 new zcnt set zcnt=0
 if '$data(@ary) quit zcnt
 new % set %=ary
 for  set %=$query(@%) quit:%=""  set zcnt=zcnt+1
 ;
 quit zcnt ; end of $$count
 ;
 ;
 ;
recount ; recount the tags
 ;
 new groot set groot=$$setroot
 set groot=$name(@groot@("graph"))
 do counts(groot)
 ;
 quit  ; end of recount
 ;
 ;
 ;
hashpars(input,pairs)
 ;
 new kbaii
 if input'["#" quit  ;
 for kbaii=2:1:$length(input,"#") do  ;
 . new zp,zo,pred
 . set zp=$piece(input,"#",kbaii)
 . set pred="tag"
 . set zo=zp
 . if zp[":" do  ;
 . . set pred=$piece(zp,":",1)
 . . set zo=$extract(zp,$find(zp,":"),$length(zp))
 . . if zo["%" set zo=$$URLDEC^VPRJRUT(.zo)
 . . ; write !,zo
 . . ; set zo=$piece(zp,":",2)
 . . quit
 . if $get(pred)="" quit  ;
 . if $get(zo)="" quit  ;
 . set @pairs@(kbaii-1,pred,zo)=""
 . quit
 ;
 quit  ; end of hashpars
 ;
 ;
 ;
stat(zf) ;
 ;
 new zstat,zcmd,zwhere
 set zcmd="""stat --format %f "_zf_" >./stat.txt"""
 zsystem @zcmd
 set zwhere=$name(^tmp("kbaiweb","stat",1))
 new zok set zok=$$FTG^%ZISH("./","stat.txt",zwhere,3)
 ;
 quit @zwhere ; end of $$stat
 ;
 ;
 ;
locate(zarg) ;
 ;
 quit zarg ; end of $$locate
 ;
 ;
 ;
logrewr(from,to) ; log uri rewrite
 ;
 new dt,id,ln
 set dt=httplog("dt"),id=httplog("id")
 set ln=$g(^vprhttp("log",dt,$job,id,"rewrite","from"),0)+1
 set ^vprhttp("log",dt,$job,id,"rewrite","from",0)=ln
 set ^vprhttp("log",dt,$job,id,"rewrite",ln,"from")=$get(from)
 set ^vprhttp("log",dt,$job,id,"rewrite",ln,"to")=$get(to)
 ;
 quit  ; end of logrewr
 ;
 ;
 ;
rewrite(rtn) ; show all the rewrites in the log
 ;
 new zr,zrary
 new gtop,gbot
 do htmltb^%yottaweb(.gtop,.gbot,"search results for #"_arg)
 merge @rtn=gtop
 do addto^%yottautl(rtn,"<h1>items not found</h1>") 
 set zr=$name(^vprhttp("log"))
 for  set zr=$query(@zr) quit:zr=""  do  ;
 . if zr'["rewrite" quit  ;
 . if zr'["from" quit  ;
 . ; write !,zr
 . if $length(@zr)=1 quit  ; the count
 . new title set title="not found - "_@zr
 . do match(@zr,"zrary")
 . do addto^%yottautl(rtn,"<p>"_@zr_"</p>")
 . ; do multout(.rtn,"zrary",title)
 . quit
 kill @rtn@(0)
 set HTTPRSP("mime")="text/html"
 set @rtn@($order(@rtn@(""),-1)+1)=gbot
 ;
 quit  ; end of rewrite
 ;
 ;
 ;
eor ; end of routine %yottagr
