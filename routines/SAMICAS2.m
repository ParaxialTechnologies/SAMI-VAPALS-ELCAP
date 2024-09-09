SAMICAS2 ;ven/gpl - case review cont; 2024-09-09t12:42z
 ;;18.0;SAMI;**1,5,9,12,14,18**;2020-01-17;
 ;mdc-e1;SAMICAS2-20240909-E1vtFzO;SAMI-18-18-b1
 ;mdc-v7;B382829905;SAMI*18.0*18 SEQ #18
 ;
 ; SAMICAS2 contains ppses and other subroutines to support processing
 ; of the VAPALS case review page.
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
 ;@license see routine SAMIUL
 ;@documentation see SAMICUL
 ;@contents
 ;
 ;  1. wsCASE & related ppses:
 ; WSCASE wrs-code WSCASE^SAMICASE, post vapals casereview:
 ;  generate case review page
 ; $$NOTEHREF pps-code $$NOTEHREF^SAMICASE, 
 ;  html list of notes for form
 ; GETTMPL pps-code GETTMPL^SAMICASE, get html template
 ; $$CNTITEMS = how many forms does patient have?
 ; GETITEMS pps-code GETITEMS^SAMICASE
 ;  get items available for studyid
 ; $$GETDTKEY date part of form key
 ; $$KEY2DSPD date in elcap format from key date
 ; $$VAPALSDT pps-code $$VAPALSDT^SAMICASE, vapals format for dates
 ;
 ;  2. WSNUFORM & related ppses:
 ; WSNUFORM wrs-code WSNUFORM^SAMICASE, post vapals nuform:
 ;  new form for patient
 ; OLDNUFORM
 ;
 ;  3. WSNUUPLD & related ppses:
 ; WSNUUPLD wrs-code WSNUUPLD^SAMICASE, post vapals nuform:
 ;  new form for patient
 ; OLDPROCESS
 ; $$DOCTYPE document type
 ; MINIPARS parse on name=
 ; FILEUP process file upload
 ; $$DEDUP append dash # to key to make it unique
 ; FILEVIEW view an uploaded document
 ;
 ; $$KEY2FM pps-code $$KEY2FM^SAMICASE, convert key to fileman date
 ;
 ;  4. casetbl:
 ; $$GSAMISTA value of 'samistatus' from form
 ; SSAMISTA pps-code SSAMISTA^SAMICASE, set samistatus to val in form
 ; DELFORM wrs-code DELFORM^SAMICASE, post vapals deleteform:
 ;  delete incomplete form
 ; INITSTAT set all forms to 'incomplete'
 ;
 ;
 ;
 ;
 ;@section 1 wsCASE & related ppses
 ;
 ;
 ;
 ;
 ;@wrs-code WSCASE^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wrs;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; do WSCASE^SAMICASE(rtn,filter)
 ;@branches-from
 ; WSCASE^SAMICASE
 ;@wri-called-by
 ; wsPostForm^%wfhform
 ; DELFORM^SAMICASE
 ; WSNFPOST^SAMICASE
 ; WSVAPALS^SAMIHOM3 [wsi for ws post vapals]
 ; WSLOOKUP^SAMISRC2
 ; wsPostForm^SAMIZ2
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; GETTMPL^SAMICASE
 ; GETITEMS^SAMICASE
 ; $$SID2NUM^SAMIHOM3
 ; findReplace^%ts
 ; $$SITENM2^SAMISITE
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; $$GETDTKEY
 ; $$KEY2DSPD
 ; $$NOTEHREF^SAMICASE
 ; $$GETLAST5^SAMIFORM
 ; $$GETSSN^SAMIFORM
 ; $$GETNAME^SAMIFORM
 ; $$GETIDSID^SAMIFORM
 ; $$GSAMISTA
 ; $$VIEWURL^SAMIDCM2
 ; D ADDCRLF^VPRJRUT
 ;@input
 ; .filter =
 ; .filter("studyid")=studyid of the patient
 ;@output
 ; .rtn
 ;@tests
 ; UTWSCAS^SAMIUTS2
 ;
 ;
WSCASE ; post vapals casereview: generate case review page
 ;
 ;@stanza 2 initialize
 ;
 kill rtn
 ;
 new groot set groot=$$setroot^%wd("vapals-patients") ; root of patient graphs
 ;
 new temp ; html template
 do GETTMPL^SAMICASE("temp","vapals:casereview")
 quit:'$data(temp)
 ;
 new sid set sid=$get(filter("studyid"))
 if sid="" set sid=$get(filter("studyId"))
 if sid="" set sid=$get(filter("fvalue"))
 quit:sid=""
 ;
 new items
 do GETITEMS^SAMICASE("items",sid)
 quit:'$data(items)
 ;
 new gien set gien=$$SID2NUM^SAMIHOM3(sid) ; graph ien
 new name set name=$get(@groot@(gien,"saminame"))
 quit:name=""
 new fname set fname=$piece(name,",",2)
 new lname set lname=$piece(name,",")
 ;
 ;
 ;@stanza 3 change resource paths to /see/
 ;
 new cnt set cnt=0
 new zi set zi=0
 ;for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["VEP0001"  do  ;
 for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["tbody"  do  ;
 . new ln set ln=temp(zi)
 . new touched set touched=0
 . ;
 . if ln["@@SITE@@" do  ; insert site id
 . . n siteid s siteid=$g(filter("siteid"))
 . . i siteid="" s siteid=$g(filter("site"))
 . . q:siteid=""
 . . do findReplace^%ts(.ln,"@@SITE@@",siteid)
 . . s temp(zi)=ln
 . ;
 . if ln["@@SITETITLE@@" do  ; insert site title
 . . n sitetit s sitetit=$g(filter("sitetitle"))
 . . if sitetit="" d  ;
 . . . n tsite s tsite=$g(filter("site"))
 . . . q:tsite=""
 . . . s sitetit=$$SITENM2^SAMISITE(tsite)_" - "_tsite
 . . q:sitetit=""
 . . do findReplace^%ts(.ln,"@@SITETITLE@@",sitetit)
 . . s temp(zi)=ln
 . ;
 . if ln["id" if ln["studyIdMenu" do  ;
 . . set zi=zi+4
 . ;
 . if ln["home.html" do  ;
 . . do findReplace^%ts(.ln,"home.html","/vapals")
 . . set temp(zi)=ln
 . . set touched=1
 . ;
 . if ln["href" if 'touched do  ;
 . . do FIXHREF^SAMIFORM(.ln)
 . . set temp(zi)=ln
 . ;
 . if ln["src" do  ;
 . . do FIXSRC^SAMIFORM(.ln)
 . . set temp(zi)=ln
 . ;
 . if ln["@@ERROR_MESSAGE@@" do  ; insert error message
 . . n zerr s zerr=$g(filter("errorMessage"))
 . . i zerr="" q  ;
 . . do findReplace^%ts(.ln,"@@ERROR_MESSAGE@@",zerr)
 . . s temp(zi)=ln
 . ;
 . set cnt=cnt+1
 . set rtn(cnt)=temp(zi)
 . quit
 ;
 ; ready to insert rows for selection
 ;
 ;
 ;@stanza 4 intake form
 ;
 new sikey set sikey=$order(items("sifor"))
 if sikey="" set sikey="siform-2017-12-10"
 new sidate set sidate=$$GETDTKEY(sikey)
 set sikey="vapals:"_sikey
 new sidispdate set sidispdate=$$KEY2DSPD(sidate)
 ;new geturl set geturl="/form?form=vapals:siform&studyid="_sid_"&key="_sikey
 new nuhref set nuhref="<form method=POST action=""/vapals"">"
 set nuhref=nuhref_"<td><input type=hidden name=""samiroute"" value=""nuform"">"
 set nuhref=nuhref_"<input type=hidden name=""studyid"" value="_sid_">"
 set nuhref=nuhref_"<input value=""New Form"" class=""btn label label-warning"" role=""link"" type=""submit""></form></td>"
 ; new intake notes table
 n notehref,form
 set form=$p(sikey,":",2)
 set notehref=$$NOTEHREF^SAMICASE(sid,form) ; table of notes
 set cnt=cnt+1
 ;new facilitycode set facilitycode=$$GETPRFX^SAMIFORM()
 n siteid s siteid=$g(filter("siteid"))
 i siteid="" s siteid=$g(filter("site"))
 new facilitycode set facilitycode=siteid
 new last5 set last5=$$GETLAST5^SAMIFORM(sid)
 new pssn set pssn=$$GETSSN^SAMIFORM(sid)
 new pname set pname=$$GETNAME^SAMIFORM(sid)
 new useid set useid=$$GETIDSID^SAMIUID(sid)
 if useid="" set useid=last5
 set rtn(cnt)="<tr><td> "_useid_" </td><td> "_pname_" </td><td> "_facilitycode_" </td><td>"_sidispdate_"</td><td>"_$char(13)
 set cnt=cnt+1
 set rtn(cnt)="<form method=""post"" action=""/vapals"">"
 set cnt=cnt+1
 set rtn(cnt)="<input name=""samiroute"" value=""form"" type=""hidden"">"
 set rtn(cnt)=rtn(cnt)_" <input name=""studyid"" value="""_sid_""" type=""hidden"">"
 set rtn(cnt)=rtn(cnt)_" <input name=""form"" value="""_sikey_""" type=""hidden"">"
 set rtn(cnt)=rtn(cnt)_" <input value=""Intake"" class=""btn btn-link"" role=""link"" type=""submit"">"
 ;
 new samistatus set samistatus=""
 if $$GSAMISTA(sid,sikey)="incomplete" set samistatus="(incomplete)"
 set cnt=cnt+1
 set rtn(cnt)="</form>"_samistatus_notehref_"</td>"_$char(13)
 set cnt=cnt+1
 set rtn(cnt)=nuhref_"</tr>"
 ;
 ;
 ;@stanza 6 rest of the forms
 ;
 new zj set zj="" ; each of the rest of the forms
 if $data(items("sort")) do  ; we have more forms
 . for  set zj=$order(items("sort",zj)) quit:zj=""  do  ;
 . . new cdate set cdate=zj
 . . new zk set zk=""
 . . for  set zk=$order(items("sort",cdate,zk)) q:zk=""  do  ;
 . . . new zform set zform=zk
 . . . new zkey set zkey=""
 . . . f  s zkey=$order(items("sort",cdate,zform,zkey)) q:zkey=""  d  ;
 . . . . new zname set zname=$order(items("sort",cdate,zform,zkey,""))
 . . . . new imgid set imgid=$g(items("sort",cdate,zform,zkey,zname))
 . . . . new dispdate set dispdate=$$KEY2DSPD(cdate)
 . . . . if zform'["file" set zform="vapals:"_zkey ; all the new forms are vapals:key
 . . . . set cnt=cnt+1
 . . . . ;set rtn(cnt)="<tr><td> "_sid_" </td><td> - </td><td> - </td><td> - </td><td>"_dispdate_"</td><td>"
 . . . . set rtn(cnt)="<tr><td> "_useid_" </td><td> - </td><td> - </td><td>"_dispdate_"</td><td>"
 . . . . set cnt=cnt+1
 . . . . set rtn(cnt)="<form method=""post"" action=""/vapals"">"_$char(13)
 . . . . set cnt=cnt+1
 . . . . set rtn(cnt)="<input name=""samiroute"" value=""form"" type=""hidden"">"_$char(13)
 . . . . set cnt=cnt+1
 . . . . set rtn(cnt)=" <input name=""studyid"" value="""_sid_""" type=""hidden"">"_$char(13)
 . . . . set cnt=cnt+1
 . . . . set rtn(cnt)=" <input name=""form"" value="""_zform_""" type=""hidden"">"_$char(13)
 . . . . ;set rtn(cnt)=" <input name=""form"" value="""_zkey_""" type=""hidden"">"_$char(13)
 . . . . set cnt=cnt+1
 . . . . set rtn(cnt)=" <input value="""_zname_""" class=""btn btn-link"" role=""link"" type=""submit"">"_$char(13)
 . . . . ;
 . . . . new samistatus set samistatus=""
 . . . . if $$GSAMISTA(sid,zform)="incomplete" set samistatus="(incomplete)"
 . . . . set cnt=cnt+1
 . . . . set rtn(cnt)="</form>"_samistatus_$$NOTEHREF^SAMICASE(sid,zkey)_"</td>"
 . . . . set cnt=cnt+1
 . . . . if zform["ceform" do  ;
 . . . . . new rpthref set rpthref="<form method=POST action=""/vapals"">"
 . . . . . set rpthref=rpthref_"<td><input type=hidden name=""samiroute"" value=""ctreport"">"
 . . . . . set rpthref=rpthref_"<input type=hidden name=""form"" value="_$p(zform,":",2)_">"
 . . . . . ;set rpthref=rpthref_"<input type=hidden name=""form"" value="_zkey_">"
 . . . . . set rpthref=rpthref_"<input type=hidden name=""studyid"" value="_sid_">"
 . . . . . set rpthref=rpthref_"<input value=""Report"" class=""btn label label-warning"" role=""link"" type=""submit""></form></td>"
 . . . . . set rtn(cnt)=rpthref_"</tr>"
 . . . . . set cnt=cnt+1
 . . . . . ;set rtn(cnt)="</tr>" ; turn off report
 . . . . if zform["file" do  ;
 . . . . . new filehref set filehref="<form method=POST action=""/vapals"">"
 . . . . . set filehref=filehref_"<td><input type=hidden name=""samiroute"" value=""viewfile"">"
 . . . . . ;set filehref=filehref_"<input type=hidden name=""form"" value="_$p(zform,":",2)_">"
 . . . . . set filehref=filehref_"<input type=hidden name=""form"" value="_zkey_">"
 . . . . . set filehref=filehref_"<input type=hidden name=""studyid"" value="_sid_">"
 . . . . . set filehref=filehref_"<input value=""View"" class=""btn label label-warning"" role=""link"" type=""submit""></form></td>"
 . . . . . set rtn(cnt)=filehref_"</tr>"
 . . . . . set cnt=cnt+1
 . . . . if zform["image" d  ;
 . . . . . new imgurl set imgurl=$$VIEWURL^SAMIDCM2(siteid)
 . . . . . new imgview s imgview=""
 . . . . . s imgview=imgview_"<td><a href="_imgurl_"?StudyInstanceUIDs="_imgid
 . . . . . s imgview=imgview_">View</a></td></tr>"
 . . . . . set rtn(cnt)=imgview
 . . . . . set cnt=cnt+1
 . . . . else  set rtn(cnt)="<td></td></tr>"
 . . . quit
 . . quit
 . quit
 ;
 ;
 ;@stanza 7 skip ahead in template to tbody
 ;
 new loc set loc=zi+1
 for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["/tbody"  do  ;
 . set x=$get(x)
 . quit
 set zi=zi-1
 ;
 ;
 ;@stanza 8 rest of lines
 ;
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . new line
 . set line=temp(zi)
 . ;
 . if line["@@SITE@@" do  ; insert site id
 . . n siteid s siteid=$g(filter("siteid"))
 . . i siteid="" s siteid=$g(filter("site"))
 . . q:siteid=""
 . . d findReplace^%ts(.line,"@@SITE@@",siteid)
 . . q
 . ;
 . if line["@@SITETITLE@@" do  ; insert site title
 . . n sitetit s sitetit=$g(filter("sitetitle"))
 . . if sitetit="" d  ;
 . . . n tsite s tsite=$g(filter("site"))
 . . . q:tsite=""
 . . . s sitetit=$$SITENM2^SAMISITE(tsite)_" - "_tsite
 . . . q
 . . q:sitetit=""
 . . d findReplace^%ts(.line,"@@SITETITLE@@",sitetit)
 . . q
 . ;
 . if line["XX0002" do  ;
 . . do findReplace^%ts(.line,"XX0002",sid)
 . . quit
 . ;
 . if line["@@ERROR_MESSAGE@@" do  ;
 . . n zerr
 . . k ^gpl("error")
 . . m ^gpl("error")=filter
 . . s zerr=$g(filter("errorMessage"))
 . . ;i err="" q  ;
 . . s ^gpl("error","zerr")=zerr
 . . d findReplace^%ts(.line,"@@ERROR_MESSAGE@@",zerr)
 . . s ^gpl("error","newline")=line
 . . q
 . set cnt=cnt+1
 . set rtn(cnt)=line
 . quit
 ;
 do ADDCRLF^VPRJRUT(.rtn)
 set HTTPRSP("mime")="text/html" ; set mime type
 ;
 ;
 ;@stanza 9 termination
 ;
 quit  ; end of wrs WSCASE^SAMICAS2
 ;
 ;
 ;
 ;
 ;@pps-code $$NOTEHREF^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;silent;clean?;sac?;tests?;port?
 ;@signature
 ; $$NOTEHREF^SAMICASE(sid,form)
 ;@branches-from
 ; NOTEHREF^SAMICASE
 ;@ppi-called-by
 ; WSNFPOST^SAMICAS3
 ;@called-by none
 ;@calls
 ; NTLIST^SAMINOT1
 ;@input
 ; sid = study id
 ; form
 ;@output = html list of notes
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
NOTEHREF ; html list of notes for form
 ;
 ;@stanza 2 get list of notes
 ;
 new notehref set notehref=""
 new ntlist
 if form["sifor" do NTLIST^SAMINOT1("ntlist",sid,form)
 if form["fufor" do NTLIST^SAMINOT2("ntlist",sid,form)
 if $order(ntlist(""))="" quit notehref
 ;
 set notehref="<table>"
 ;
 new zi set zi=0
 for  do  quit:'zi
 . set zi=$order(ntlist(zi))
 . quit:'zi
 . ;
 . set notehref=notehref_"<td><form method=POST action=""/vapals"">"
 . set notehref=notehref_"<input type=hidden name=""nien"" value="""_$get(ntlist(zi,"nien"))_""">"
 . set notehref=notehref_"<input type=hidden name=""samiroute"" value=""note"">"
 . set notehref=notehref_"<input type=hidden name=""studyid"" value="_sid_">"
 . set notehref=notehref_"<input type=hidden name=""form"" value="_form_">"
 . set notehref=notehref_"<input value="""_$get(ntlist(zi,"name"))_""" class=""btn btn-link"" role=""link"" type=""submit""></form></td></tr>"
 . quit
 ;
 set notehref=notehref_"</table>"
 ;
 ;
 ;@stanza 3 termination
 ;
 quit notehref ; end of pps $$NOTEHREF^SAMICASE
 ;
 ;
 ;
 ;
 ;@pps-code GETTMPL^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; do GETTMPL^SAMICASE(return,form)
 ;@branches-from
 ; GETTMPL^SAMICASE
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ; GETHOME^SAMIHOM4
 ; WSNOTE^SAMINOT1
 ; WSNOTE^SAMINOT2
 ; WSNOTE^SAMINOT3
 ; WSNOTE^SAMINOTI
 ;@called-by none
 ;@calls
 ; $$getTemplate^%wf
 ; getThis^%wd
 ;@input
 ; return = name of array to return template
 ; form = name of form
 ;@output
 ; @return = template
 ;@examples [tbd]
 ;@tests
 ; UTGTMPL^SAMIUTS2
 ;
 ;
GETTMPL ; get html template
 ;
 ;@stanza 2 get html template
 ;
 quit:$get(form)=""
 ;
 new fn set fn=$$getTemplate^%wf(form)
 do getThis^%wd(return,fn)
 ;
 set HTTPRSP("mime")="text/html"
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of pps GETTMPL^SAMICASE
 ;
 ;
 ;
 ;
 ;@function $$CNTITEMS
 ;
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient's study ID (e.g. "XXX00001")
 ;@output = # forms patient has
 ;@tests
 ; SAMIUTS2
 ;
 ;
CNTITEMS(sid) ; how many forms does patient have?
 ;
 ; used before deleting a patient to count how many forms patient has
 ;
 new groot set groot=$$setroot^%wd("vapals-patients")
 quit:'$data(@groot@("graph",sid)) 0  ; nothing there
 ;
 new zi set zi=""
 new cnt set cnt=0
 for  set zi=$o(@groot@("graph",sid,zi)) quit:zi=""  set cnt=cnt+1
 ;
 quit cnt  ; end of CNTITEMS
 ;
 ;
 ;
 ;
 ;@pps-code GETITEMS^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; do GETITEMS^SAMICASE(ary,sid)
 ;@branches-from
 ; GETITEMS^SAMICASE
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ; $$BASELNDT^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; GETFILTR^SAMICTR0
 ; GETFILTR^SAMICTT0
 ; SELECT^SAMIUR
 ; SELECT^SAMIUR1
 ; CUMPY^SAMIUR2
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; $$DOCTYPE
 ; $$FMDT^SAMIUR2
 ; ADDITEMS^SAMIDCM2
 ;@input
 ; ary = name of return array
 ; sid = patient's study ID (e.g. "XXX00001")
 ;@output
 ; @ary = returned items available
 ;@examples [tbd]
 ;@tests
 ; UTCNTITM^SAMIUTS2
 ;
 ;
GETITEMS ; get items available for studyid
 ;
 ;@stanza 2 get items
 ;
 new groot set groot=$$setroot^%wd("vapals-patients")
 quit:'$data(@groot@("graph",sid))  ; nothing there
 ;
 kill @ary
 new zi set zi=""
 for  set zi=$order(@groot@("graph",sid,zi)) quit:zi=""  do  ;
 . set @ary@(zi)=""
 . quit
 ;
 ;
 ;@stanza 3 get rest of forms (many-to-one, get dates)
 ;
 new tary
 for  set zi=$order(@ary@(zi)) quit:zi=""  do  ;
 . new zkey1,zform set zkey1=$piece(zi,"-",1)
 . ; if zkey1="sbform" quit  ;
 . if zkey1="siform" quit  ;
 . new fname
 . if zkey1="ceform" set fname="CT Evaluation"
 . set zform=zkey1
 . if zkey1="sbform" set zform="vapals:sbform"
 . if zkey1="sbform" set fname="Background"
 . if zkey1="ceform" set zform="vapals:ceform"
 . if zkey1="fuform" set zform="vapals:fuform"
 . if zkey1="fuform" set fname="Follow-up"
 . if zkey1="bxform" set fname="Biopsy"
 . if zkey1="bxform" set zform="vapals:bxform"
 . if zkey1="ptform" set zform="vapals:ptform"
 . if zkey1="ptform" set fname="PET Evaluation"
 . if zkey1="itform" set zform="vapals:itform"
 . if zkey1="itform" set fname="Intervention"
 . if zkey1="file" d  ;
 . . s zform="file"
 . . n doccode s doccode=$g(@groot@("graph",sid,zi,"pdtype"))
 . . n doctype s doctype=$$DOCTYPE(doccode)
 . . if doctype'="" s fname="Doc: "_doctype
 . . else  s fname="file"
 . . quit
 . if $get(fname)="" set fname="unknown"
 . ;
 . ;new zdate set zdate=$extract(zi,$length(zkey1)+2,$length(zi))
 . new zdate set zdate=$p(zi,"-",2)_"-"_$p(zi,"-",3)_"-"_$p(zi,"-",4)
 . set zdate=$$FMDT^SAMIUR2(zdate)
 . quit:$get(zdate)=""
 . quit:$get(zform)=""
 . quit:$get(zi)=""
 . quit:$get(fname)=""
 . ;
 . set tary("sort",zdate,zform,zi,fname)=""
 . set tary("type",zform,zi,fname)=""
 . quit
 ;
 D ADDITEMS^SAMIDCM2("tary",sid)
 merge @ary=tary
 ;
 ;
 ;@stanza 4 termination
 ;
 quit  ; end of pps GETITEMS^SAMICASE
 ;
 ;
 ;
 ;
 ;@function $$GETDTKEY
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called by
 ; WSCASE^SAMICAS2
 ;@calls none
 ;@input
 ; formid = form key
 ;@output = date from form key
 ;@examples
 ; $$GETDTKEY("sbform-2018-02-26") = "2018-02-26"
 ;@tests :
 ; SAMIUTS2
 ;
 ;
GETDTKEY(formid) ; date portion of form key
 ;
 ;@stanza 2 calculate date from key
 ;
 new frm set frm=$piece(formid,"-")
 ;new date set date=$piece(formid,frm_"-",2)
 new date set date=$piece(formid,"-",2)_"-"_$piece(formid,"-",3)_"-"_$piece(formid,"-",4)
 ;
 ;@stanza 3 return & termination
 ;
 quit date ; return date; end of $$GETDTKEY
 ;
 ;
 ;
 ;
 ;@function $$KEY2DSPD
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;silent;clean;sac?;100% tests;port?
 ;@called by
 ;  WSCASE^SAMICAS2
 ;@calls
 ; ^%DT
 ; $$FMTE^XLFDT [commented out]
 ; $$VAPALSDT^SAMICASE
 ;@input
 ; zkey = date in any format %DT can process
 ;@output = date in elcap format
 ;@examples
 ; date 2018-02-26 => 26/Feb/2018
 ;@tests
 ; SAMIUTS2
 ;
 ;
KEY2DSPD(zkey) ; date in elcap format from key date
 ;
 ;@stanza 2 convert date to elcap display format
 ;
 new X set X=zkey
 new Y
 do ^%DT
 ;new Z set Z=$$FMTE^XLFDT(Y,"9D")
 ;set Z=$translate(Z," ","/")
 new zdate set zdate=$$VAPALSDT^SAMICASE(Y)
 ;
 ;@stanza 3 return & termination
 ;
 quit zdate  ; return date; end of $$KEY2DSPD
 ;
 ;
 ;
 ;
 ;@pps-code $$VAPALSDT^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;clean;silent;sac;100% tests
 ;@signature
 ; $$VAPALSDT^SAMICASE(fmdate)
 ;@branches-from
 ; VAPALSDT^SAMICASE
 ;@pps-called-by
 ; KEY2DSPD^SAMICAS2
 ; LASTCMP^SAMICAS3
 ; KEY2DT^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; LOGIT^SAMICLOG
 ; MKSIFORM^SAMIHOM3
 ; PREFILL^SAMIHOM3
 ; SELECT^SAMIUR
 ; SELECT^SAMIUR1
 ; IFORM^SAMIUR2
 ;@called-by none
 ;@calls
 ; $$FMTE^XLFDT
 ;@input
 ; fmdate = date in fileman format
 ;@output = vapals date format
 ;@tests
 ; UTVPLSD^SAMIUTS2
 ;
 ;
VAPALSDT ; vapals format for dates
 ;
 ;@stanza 2 convert date
 ;
 ; new vdate set vdate=$$FMTE^XLFDT(fmdate,"9D")
 ; set vdate=$translate(vdate," ","/")
 ;
 ;new vdate set vdate=$$FMTE^XLFDT(fmdate,"5D")
 new vdate set vdate=$$FMTE^XLFDT(fmdate,"5DZ")
 ;
 ;
 ;@stanza 3 termination
 ;
 quit vdate ; end of pps $$VAPALSDT^SAMICASE
 ;
 ;
 ;
 ;
 ;@section 2 WSNUFORM & related ppses
 ;
 ;
 ;
 ;
 ;@wrs-code WSNUFORM^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wrs;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; do WSNUFORM^SAMICASE(rtn,filter)
 ;@branches-from
 ; WSNUFORM^SAMICASE
 ;@wrs-called-by
 ; WSVAPALS^SAMIHOM3 [wr nuform of ws post vapals]
 ;@called-by none
 ;@calls
 ; $$SID2NUM^SAMIHOM3
 ; $$setroot^%wd
 ; $$NOW^XLFDT
 ; $$VAPALSDT^SAMICASE
 ; wsGetForm^%wf
 ;@input
 ; .filter =
 ; .filter("studyid")=studyid of the patient
 ;@output
 ; @rtn
 ;@tests
 ; UTWSNF^SAMIUTS2
 ;
 ;
WSNUFORM ; post vapals nuform: new form for patient
 ;
 ;@stanza 2 get select-new-form form
 ;
 new sid set sid=$get(filter("studyid"))
 quit:sid=""
 ;
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new groot set groot=$name(@root@(sien))
 new saminame set saminame=$get(@groot@("saminame"))
 quit:saminame=""
 ;
 ;
 ; gpl experiment to fool wsGetForm^%wf into processing this form
 ;
 n tmpdt s tmpdt=$$VAPALSDT^SAMICASE($$NOW^XLFDT())
 s tmpdt=$tr(tmpdt,"/","-")
 n tmpkey s tmpkey="temp-"_tmpdt ; key to fool wsGetForm
 s @root@("graph",sid,tmpkey,sid)=sid
 ;
 n filter
 s filter("form")="vapals:nuform"
 s filter("studyid")=sid
 s filter("key")=tmpkey
 d wsGetForm^%wf(.rtn,.filter)
 k @root@("graph",sid,tmpkey) ; clean up temp false form
 ;
 quit  ; end of wrs WSNUFORM^SAMICAS
 ;
 ;
 ;
 ;
 ;@proc OLDNUFORM
 ;
 ;@calls
 ; GETTMPL
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; findReplace^%ts
 ; $$SITENM2^SAMISITE
 ;
OLDNUFORM()
 ;
 new temp,tout
 set return="temp"
 new form set form="vapals:nuform"
 do GETTMPL
 quit:'$data(temp)
 ;
 new cnt set cnt=0
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . new ln set ln=temp(zi)
 . new touched set touched=0
 . ;
 . if ln["href" if 'touched do  ;
 . . do FIXHREF^SAMIFORM(.ln)
 . . set temp(zi)=ln
 . . quit
 . ;
 . if ln["src" d  ;
 . . do FIXSRC^SAMIFORM(.ln)
 . . set temp(zi)=ln
 . . quit
 . ;
 . if ln["@@SID@@" do  ;
 . . do findReplace^%ts(.ln,"@@SID@@",sid)
 . . set temp(zi)=ln
 . . quit
 . ;
 . if ln["@@SITE@@" do  ; insert site id
 . . n siteid s siteid=$g(filter("siteid"))
 . . i siteid="" s siteid=$g(filter("site"))
 . . q:siteid=""
 . . do findReplace^%ts(.ln,"@@SITE@@",siteid)
 . . s temp(zi)=ln
 . . q
 . ;
 . if ln["@@SITETITLE@@" do  ; insert site title
 . . n sitetit s sitetit=$g(filter("sitetitle"))
 . . if sitetit="" d  ;
 . . . n tsite s tsite=$g(filter("site"))
 . . . q:tsite=""
 . . . s sitetit=$$SITENM2^SAMISITE(tsite)_" - "_tsite
 . . . q
 . . q:sitetit=""
 . . do findReplace^%ts(.ln,"@@SITETITLE@@",sitetit)
 . . s temp(zi)=ln
 . . q
 . ;
 . set cnt=cnt+1
 . set rtn(cnt)=temp(zi)
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of OLDNUFORM
 ;
 ;
 ;
 ;
 ;@section 3 WSNUUPLD & related ppses
 ;
 ;
 ;
 ;
 ;@wrs-code WSNUUPLD^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wrs;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; do WSNUUPLD^SAMICASE(rtn,filter)
 ;@branches-from
 ; WSNUFORM^SAMICASE
 ;@wrs-called-by
 ; WSVAPALS^SAMIHOM3 [wr nuform of ws post vapals]
 ;@called-by none
 ;@calls
 ; $$SID2NUM^SAMIHOM3
 ; $$setroot^%wd
 ; $$NOW^XLFDT
 ; $$VAPALSDT^SAMICASE
 ; wsGetForm^%wf
 ;@input
 ; .filter =
 ; .filter("studyid")=studyid of the patient
 ;@output
 ; @rtn
 ;@tests
 ; UTWSNF^SAMIUTS2
 ;
 ;
WSNUUPLD ; post vapals nuform: new form for patient
 ;
 ;@stanza 2 get select-new-form form
 ;
 new sid set sid=$get(filter("studyid"))
 if sid="" set sid=$get(filter("sid"))
 quit:sid=""
 ;
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new groot set groot=$name(@root@(sien))
 new saminame set saminame=$get(@groot@("saminame"))
 quit:saminame=""
 ;
 ; gpl experiment to fool wsGetForm^%wf into processing this form
 ;
 n tmpdt s tmpdt=$$VAPALSDT^SAMICASE($$NOW^XLFDT())
 s tmpdt=$tr(tmpdt,"/","-")
 n tmpkey s tmpkey="temp-"_tmpdt ; key to fool wsGetForm
 s @root@("graph",sid,tmpkey,sid)=sid
 ;
 n filter
 s filter("form")="vapals:fileupload"
 s filter("studyid")=sid
 s filter("key")=tmpkey
 d wsGetForm^%wf(.rtn,.filter)
 k @root@("graph",sid,tmpkey) ; clean up temp false form
 ;
 quit  ; end of wrs WSNUUPLD^SAMICASE
 ;
 ;
 ;
 ;
 ;@proc OLDPROCESS
 ;
 ;@calls
 ; GETTMPL [commented out]
 ; GETTMPL^SAMICASE [commented out]
 ; getThis^%wd
 ; SAMIHTM^%wf [commented out]
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; findReplace^%ts
 ; $$SITENM2^SAMISITE
 ; ^ZTER
 ;
 ;
OLDPROCESS()
 ;
 new temp,tout,form
 set return="temp",form="vapals:fileupload"
 ;do GETTMPL
 ;do GETTMPL^SAMICASE("temp","vapals:fileupload")
 do getThis^%wd("temp","fileupload.html")
 ;d SAMIHTM^%wf("temp","fileupload","err")
 set HTTPRSP("mime")="text/html"
 quit:'$data(temp)
 ;
 new cnt set cnt=0
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . new ln set ln=temp(zi)_$C(13,10)
 . new touched set touched=0
 . ;
 . if ln["href" if 'touched do  ;
 . . do FIXHREF^SAMIFORM(.ln)
 . . set temp(zi)=ln
 . . quit
 . ;
 . if ln["src" d  ;
 . . do FIXSRC^SAMIFORM(.ln)
 . . set temp(zi)=ln
 . . quit
 . ;
 . if ln["@@SID@@" do  ;
 . . do findReplace^%ts(.ln,"@@SID@@",sid)
 . . set temp(zi)=ln
 . . quit
 . ;
 . if ln["@@SITE@@" do  ; insert site id
 . . n siteid s siteid=$g(filter("siteid"))
 . . i siteid="" s siteid=$g(filter("site"))
 . . q:siteid=""
 . . do findReplace^%ts(.ln,"@@SITE@@",siteid)
 . . s temp(zi)=ln
 . . q
 . ;
 . if ln["@@SITETITLE@@" do  ; insert site title
 . . n sitetit s sitetit=$g(filter("sitetitle"))
 . . if sitetit="" d  ;
 . . . n tsite s tsite=$g(filter("site"))
 . . . q:tsite=""
 . . . s sitetit=$$SITENM2^SAMISITE(tsite)_" - "_tsite
 . . . q
 . . q:sitetit=""
 . . do findReplace^%ts(.ln,"@@SITETITLE@@",sitetit)
 . . s temp(zi)=ln
 . . q
 . ;
 . set cnt=cnt+1
 . set rtn(cnt)=temp(zi)
 . quit
 ;
 ;D ^ZTER
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of OLDPROCESS
 ;
 ;
 ;
 ;
 ;@function $$DOCTYPE
 ;
 ;@called-by
 ; GETITEMS^SAMICASE
 ;@calls none
 ;@input
 ; code = document code
 ;@output = document type, expanded from code
 ;
 ;
DOCTYPE(code) ; document type
 ;
 n dtype ; document type table
 s dtype("c","CT Chest")=""
 s dtype("p","PET-CT")=""
 s dtype("b","Biopsy")=""
 s dtype("s","Surgical")=""
 s dtype("a","Operative Report")=""
 s dtype("d","Discharge Summary")=""
 s dtype("t","Treatment Summary")=""
 s dtype("f","PFT")=""
 s dtype("m","Molecular Pathology")=""
 s dtype("r","Bronchoscopy")=""
 s dtype("cs","Consent Form")=""
 s dtype("o","Other")=""
 n rtn s rtn=""
 i $d(dtype(code)) s rtn=$o(dtype(code,""))
 ;
 quit rtn ; end of $$DOCTYPE
 ;
 ;
 ;
 ;
 ;@proc MINIPARS
 ;
 ;@calls
 ; $$STRIP^XLFSTR
 ;@input
 ; ARY
 ;@output
 ; .RTN
 ;
 ;
MINIPARS(RTN,ARY) ; parse on name=
 ;
 m ^gpl("BODY")=@ARY
 n lastline s lastline=$o(@ARY@(" "),-1)
 n debug s debug=$g(DEBUG)
 n LN
 n doline
 f doline=1,lastline-1,lastline d  ;
 . s LN=@ARY@(doline)
 . n ncnt s ncnt=$l(LN,"name=")
 . n i
 . for i=2:1:ncnt-1 d  ;
 . . n zp s zp=$p(LN,"name=",i)
 . . w:debug !,"zp: ",zp
 . . n zpp s zpp=$tr(zp,$C(34),"#")
 . . w:debug !,"zpp: ",zpp
 . . n tag,value
 . . s tag=$p(zpp,"#",2)
 . . w:debug !,"tag: ",tag
 . . n zp2 s zp2=$e(zp,$l(tag)+3,$l(zp))
 . . w:debug !,"zp2: ",zp2
 . . n zp3 s zp3=$tr(zp2," ","")
 . . w:debug !,"zp3: ",zp3
 . . s value=$p(zp3,"-----",1)
 . . s value=$$STRIP^XLFSTR(value,$C(10)_$C(13))
 . . w:debug !,"value: ",value
 . . s RTN(tag)=value
 . . q
 . q
 ;
 ; now isolate the document (starting with pdf)
 s LN=@ARY@(1)
 n right s right=$e(LN,$f(LN,"Content-Type:"),$l(LN))
 ;n mime s mime=$p(right,$C(10,13),1)
 ;w:debug !,"mime: ",mime
 n mime s mime="application/pdf"
 s RTN("Content-Type")=mime
 ;b
 n pdftop s pdftop=$p(right,"application/pdf",2) ; start of pdf
 s @ARY@(1)=pdftop
 m RTN("file")=@ARY
 ;
 quit  ; end of MINIPARS
 ;
 ;
 ;
 ;
 ;@proc FILEUP
 ;
 ;@calls
 ; $$SID2NUM^SAMIHOM3
 ; $$setroot^%wd
 ; $$DEDUP
 ; WSCASE^SAMICASE
 ;
 ;
FILEUP(SAMIARG,SAMIBODY,SAMIRESULT) ; process file upload
 ;
 n vars m vars=SAMIARG
 ;D TOADPARSE(.vars,.SAMIARG,.SAMIBODY)
 ;D MINIPARS(.vars,"SAMIARG")
 q:'$d(vars)
 ;
 n pddos s pddos=$g(vars("pddos")) ; document data
 n spdt ; screening plus date
 ;s spdt=$tr(pddos,"/","-")
 s spdt=$p(pddos,"/",3)_"-"_$p(pddos,"/",1)_"-"_$p(pddos,"/",2)
 ;
 new sid set sid=$get(vars("studyid"))
 if sid="" set sid=$get(vars("sid"))
 ;set sid=$g(SAMIARG("studyid"))
 quit:sid=""
 ;
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new groot set groot=$name(@root@(sien))
 new froot set froot=$name(@root@("graph",sid))
 ; form root for this person
 ;
 new saminame set saminame=$get(@groot@("saminame"))
 quit:saminame=""
 s vars("saminame")=saminame
 ;
 n key s key="file-"_spdt
 s key=$$DEDUP(key,froot) ; append dash # to key to make it unique
 ;
 m @froot@(key)=vars
 m SAMIARG=vars
 s SAMIARG("site")="XXX"
 k SAMIRESULT
 d WSCASE^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 quit  ; end of FILEUP
 ;
 ;
 ;
 ;
 ;@function DEDUP
 ;
 ;@called-by
 ; FILEUP
 ;@calls none
 ;@input
 ; key
 ; froot
 ;
 ;
DEDUP(key,froot) ; append dash # to key to make it unique
 ;
 ; if needed
 ;
 n done s done=0
 n rtn s rtn=key
 i $d(@froot@(rtn)) d  ;
 . n zi
 . f zi=1:1:99 q:done  d  ;
 . . n rtn2 s rtn2=rtn_"-"_zi
 . . i '$d(@froot@(rtn2)) d  ;
 . . . s done=1
 . . . s rtn=rtn2
 . . . q
 . . q
 . q
 ;
 quit rtn ; end of $$DEDUP
 ;
 ;
 ;
 ;
 ;
 ;@proc FILEVIEW
 ;
 ;@calls
 ; $$setroot^%wd
 ;
 ;
FILEVIEW(SAMIARG,SAMIBODY,SAMIRESULT) ; view an uploaded document
 ;
 n sid s sid=$g(SAMIARG("studyid"))
 q:sid=""
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 n form s form=$g(SAMIARG("form"))
 q:'$d(@root@("graph",sid,form))
 ;
 n gn s gn=$na(^TMP("SAMIVIEW",$J))
 q:'$d(@root@("graph",sid,form,"file"))
 ;
 k @gn
 m @gn=@root@("graph",sid,form,"file")
 s SAMIRESULT=gn
 s HTTPRSP("mime")="application/pdf"
 ;
 quit  ; end of FILEVIEW
 ;
 ;
 ;
 ;
 ;@pps-code $$KEY2FM^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; $$KEY2FM^SAMICASE(key)
 ;@branches-from
 ; KEY2FM^SAMICASE
 ;@ppi-called-by
 ; WSNFPOST^SAMICAS3
 ; $$LASTCMP^SAMICAS3
 ; $$KEY2DT^SAMICAS3
 ; SAVFILTR^SAMISAV
 ; SELECT^SAMIUR
 ; SELECT^SAMIUR1
 ; IFORM^SAMIUM2
 ;@called-by none
 ;@calls
 ; ^%DT
 ;@input
 ; key = vapals key (e.g.
 ;@output
 ;@examples
 ;  $$KEY2FM("sbform-2018-02-26") = 3180226
 ;@tests
 ; UTK2FM^SAMIUTS2
 ;
 ;
KEY2FM ; convert key to fileman date
 ;
 ;@stanza 2 convert key to fm date
 ;
 new datepart set datepart=key
 ; allow key to be the whole key ie ceform-2018-10-3
 if $length(key,"-")>3 do
 . new frm set frm=$piece(key,"-")
 . set datepart=$piece(key,"-",2)_"-"_$piece(key,"-",3)_"-"_$piece(key,"-",4)
 . quit
 new X set X=datepart
 new Y
 do ^%DT ; call fileman to convert date
 ;
 ;
 ;@stanza 3 termination
 ;
 quit Y ; end of pps $$KEY2FM^SAMICASE
 ;
 ;
 ;
 ;
 ;@section 4 casetbl
 ;
 ;
 ;
 ;
 ;@pps $$GSAMISTA^SAMICAS2 = value of 'samistatus' from form
 ;
 ;@called by
 ; WSCASE^SAMICAS2
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid  = patient's studyid
 ; form = specific study form (e.g. "sbform-2018-02-26")
 ;@output
 ; status of the form
 ;@tests
 ; SAMIUTS2
 ;
 ;
GSAMISTA(sid,form) ; extrinsic returns value of 'samistatus' from form
 ;
 if form["file" q ""
 if form["image" q ""
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new useform set useform=form
 ;if form["vapals:" set useform=$p(form,"vapals:",2)
 if useform="" q ""
 ;
 new stat set stat=$get(@root@("graph",sid,useform,"samistatus"))
 if stat="" set stat="incomplete"
 if useform["file" set stat=""
 ;
 quit stat ; end of pps $$GSAMISTA^SAMICAS2
 ;
 ;
 ;
 ;
 ;@pps-code SSAMISTA^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; do SSAMISTA^SAMICASE(sid,form,val)
 ;@branches-from
 ; SSAMISTA^SAMICASE
 ;@ppi-called-by
 ; INITSTAT^SAMICAS2
 ; MKSBFORM^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ; MKBXFORM^SAMICAS3
 ; MKSBFORM^SAMIHOM3
 ; MKSIFORM^SAMIHOM3
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid   = patient's studyid
 ; form  = specific study form (e.g. "sbform-2018-02-26")
 ; value = status (complete, incomplete)
 ;@output
 ; sets 'samistatus' to val in form
 ;@examples [tbd]
 ;@tests
 ; UTSSAMIS^SAMIUTS2
 ;
 ;
SSAMISTA ; set samistatus to val in form
 ;
 ;@stanza 2 set status
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new useform set useform=form
 if form["vapals:" set useform=$piece(form,"vapals:",2)
 if '$data(@root@("graph",sid,useform)) quit  ; no form
 set @root@("graph",sid,useform,"samistatus")=val
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of pps SSAMISTA^SAMICASE
 ;
 ;
 ;
 ;
 ;@wrs-code DELFORM^SAMICASE
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wrs;procedure;silent;clean?;sac?;tests?;port?
 ;@signature
 ; do DELFORM^SAMICASE(RESULT,ARGS)
 ;@branches-from
 ; DELFORM^SAMICASE
 ;@wri-called-by
 ; WSVAPALS^SAMIHOM3 [wr deleteform of ws post vapals]
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; $$GSAMISTA
 ; WSCASE^SAMICASE
 ;@input
 ; .ARGS=
 ; .ARGS("studyid")
 ; .ARGS("form")
 ;@output
 ; @RESULT
 ;@tests
 ; UTDELFM^SAMIUTS2
 ;
 ; will not delete intake or background form
 ;
 ;
DELFORM ; post vapals deleteform: delete incomplete form
 ;
 ;@stanza 2 delete form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(ARGS("studyid"))
 quit:sid=""
 ;
 new form set form=$get(ARGS("form"))
 quit:form=""
 ;
 quit:form["siform"
 ;
 ; quit:'$data(@root@("graph",sid,form))  ; form does not exist
 if $$GSAMISTA(sid,form)="incomplete" do
 . kill @root@("graph",sid,form)
 . quit
 ;
 kill ARGS("samiroute")
 do WSCASE^SAMICASE(.RESULT,.ARGS) ; post vapals casereview:
 ; generate case review page
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wrs DELFORM^SAMICASE
 ;
 ;
 ;
 ;
 ;@proc INITSTAT
 ;
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; SSAMISTA^SAMICASE
 ;@input none
 ;@output
 ; set all forms to 'incomplete'
 ;@tests
 ;
 ;
INITSTAT ; set all forms to 'incomplete'
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new zi,zj set (zi,zj)=""
 for  set zi=$order(@root@("graph",zi)) quit:zi=""  do  ;
 . for  set zj=$order(@root@("graph",zi,zj)) quit:zj=""  do  ;
 . . if zj["siform" do SSAMISTA^SAMICASE(zi,zj,"complete") quit  ;
 . . do SSAMISTA^SAMICASE(zi,zj,"incomplete")
 . . q
 . q
 ;
 quit  ; end of INITSTAT
 ;
 ;
 ;
EOR ; end of routine SAMICAS2
