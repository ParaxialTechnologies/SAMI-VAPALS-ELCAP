SAMICAS2 ;ven/gpl - case review cont ;2021-08-09t17:03z
 ;;18.0;SAMI;**1,5,9,12**;2020-01;
 ;;18.12
 ;
 ; SAMICAS2 contains ppis and other subroutines to support processing
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
 ; WSCASE wri-code WSCASE^SAMICASE, post vapals casereview:
 ;  generate case review page
 ; $$NOTEHREF ppi-code $$NOTEHREF^SAMICASE, 
 ;  html list of notes for form
 ; GETTMPL ppi-code GETTMPL^SAMICASE, get html template
 ; $$CNTITEMS = # forms patient has used before deleting patient
 ; GETITEMS ppi-code GETITEMS^SAMICASE
 ;  get items available for studyid
 ; $$GETDTKEY date part of form key
 ; $$KEY2DSPD date in elcap format from key date
 ; $$VAPALSDT ppi-code $$VAPALSDT^SAMICASE, vapals format for dates
 ;
 ; WSNUFORM wri-code WSNUFORM^SAMICASE, post vapals nuform:
 ;  new form for patient
 ; $$KEY2FM ppi-code $$KEY2FM^SAMICASE, convert key to fileman date
 ;
 ; $$GSAMISTA value of 'samistatus' from form
 ; SSAMISTA ppi-code SSAMISTA^SAMICASE, set samistatus to val in form
 ; DELFORM wri-code DELFORM^SAMICASE, post vapals deleteform:
 ;  delete incomplete form
 ; INITSTAT set all forms to 'incomplete'
 ;
 ;
 ;
 ;@section 1 wsCASE & related ppis
 ;
 ;
 ;
 ;@wri-code WSCASE^SAMICASE
WSCASE ; post vapals casereview: generate case review page
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wri;procedure;silent;clean;sac;??% tests
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
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; $$GETDTKEY
 ; $$KEY2DSPD
 ; $$GETLAST5^SAMIFORM
 ; $$GETSSN^SAMIFORM
 ; $$GETNAME^SAMIFORM
 ; $$GSAMISTA
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
 new useid set useid=pssn
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
 . . . new zkey set zkey=$order(items("sort",cdate,zform,""))
 . . . new zname set zname=$order(items("sort",cdate,zform,zkey,""))
 . . . new dispdate set dispdate=$$KEY2DSPD(cdate)
 . . . set zform="vapals:"_zkey ; all the new forms are vapals:key
 . . . ;new geturl set geturl="/form?form="_zform_"&studyid="_sid_"&key="_zkey
 . . . set cnt=cnt+1
 . . . ;set rtn(cnt)="<tr><td> "_sid_" </td><td> - </td><td> - </td><td> - </td><td>"_dispdate_"</td><td>"
 . . . set rtn(cnt)="<tr><td> "_useid_" </td><td> - </td><td> - </td><td>"_dispdate_"</td><td>"
 . . . set cnt=cnt+1
 . . . set rtn(cnt)="<form method=""post"" action=""/vapals"">"_$char(13)
 . . . set cnt=cnt+1
 . . . set rtn(cnt)="<input name=""samiroute"" value=""form"" type=""hidden"">"_$char(13)
 . . . set cnt=cnt+1
 . . . set rtn(cnt)=" <input name=""studyid"" value="""_sid_""" type=""hidden"">"_$char(13)
 . . . set cnt=cnt+1
 . . . set rtn(cnt)=" <input name=""form"" value="""_zform_""" type=""hidden"">"_$char(13)
 . . . set cnt=cnt+1
 . . . set rtn(cnt)=" <input value="""_zname_""" class=""btn btn-link"" role=""link"" type=""submit"">"_$char(13)
 . . . ;
 . . . new samistatus set samistatus=""
 . . . if $$GSAMISTA(sid,zform)="incomplete" set samistatus="(incomplete)"
 . . . set cnt=cnt+1
 . . . set rtn(cnt)="</form>"_samistatus_$$NOTEHREF^SAMICASE(sid,zkey)_"</td>"
 . . . set cnt=cnt+1
 . . . if zform["ceform" do  ;
 . . . . new rpthref set rpthref="<form method=POST action=""/vapals"">"
 . . . . set rpthref=rpthref_"<td><input type=hidden name=""samiroute"" value=""ctreport"">"
 . . . . set rpthref=rpthref_"<input type=hidden name=""form"" value="_$p(zform,":",2)_">"
 . . . . set rpthref=rpthref_"<input type=hidden name=""studyid"" value="_sid_">"
 . . . . set rpthref=rpthref_"<input value=""Report"" class=""btn label label-warning"" role=""link"" type=""submit""></form></td>"
 . . . . set rtn(cnt)=rpthref_"</tr>"
 . . . . ;set rtn(cnt)="</tr>" ; turn off report
 . . . else  set rtn(cnt)="<td></td></tr>"
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
 . . do findReplace^%ts(.line,"@@SITE@@",siteid)
 . ;
 . if line["@@SITETITLE@@" do  ; insert site title
 . . n sitetit s sitetit=$g(filter("sitetitle"))
 . . if sitetit="" d  ;
 . . . n tsite s tsite=$g(filter("site"))
 . . . q:tsite=""
 . . . s sitetit=$$SITENM2^SAMISITE(tsite)_" - "_tsite
 . . q:sitetit=""
 . . do findReplace^%ts(.line,"@@SITETITLE@@",sitetit)
 . ;
 . if line["XX0002" do  ;
 . . do findReplace^%ts(.line,"XX0002",sid)
 . ;
 . if line["@@ERROR_MESSAGE@@" do  ;
 . . n zerr
 . . k ^gpl("error")
 . . m ^gpl("error")=filter
 . . s zerr=$g(filter("errorMessage"))
 . . ;i err="" q  ;
 . . s ^gpl("error","zerr")=zerr
 . . do findReplace^%ts(.line,"@@ERROR_MESSAGE@@",zerr)
 . . s ^gpl("error","newline")=line
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
 quit  ; end of ppi WSCASE^SAMICAS2
 ;
 ;
 ;
 ;@ppi-code $$NOTEHREF^SAMICASE
NOTEHREF ; html list of notes for form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ppi;function;clean;silent;sac;??? tests
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
 ;@stanza 2 get list of notes
 ;
 new notehref set notehref=""
 new ntlist
 if form["sifor" do NTLIST^SAMINOT1("ntlist",sid,form)
 if form["fufor" do NTLIST^SAMINOT2("ntlist",sid,form)
 if $order(ntlist(""))="" quit notehref
 ;
 set notehref="<table>"
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
 set notehref=notehref_"</table>"
 ;
 ;
 ;@stanza 3 termination
 ;
 quit notehref ; end of ppi $$NOTEHREF^SAMICASE
 ;
 ;
 ;
 ;@ppi-code GETTMPL^SAMICASE
GETTMPL ; get html template
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ppi;procedure;clean;silent;sac;??% tests
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
 quit  ; end of ppi GETTMPL^SAMICASE
 ;
 ;
 ;
CNTITEMS(sid) ; extrinsic returns how many forms the patient has
 ; used before deleting a patient
 ;
 ;@called by : none
 ;@calls :
 ; $$setroot^%wd
 ;@input ;
 ; sid = patient's study ID (e.g. "XXX00001")
 ;@output ;
 ;@tests :
 ; SAMIUTS2
 new groot set groot=$$setroot^%wd("vapals-patients")
 quit:'$data(@groot@("graph",sid)) 0  ; nothing there
 new cnt,zi
 set zi=""
 set cnt=0
 for  set zi=$o(@groot@("graph",sid,zi)) quit:zi=""  do  ;
 . set cnt=cnt+1
 ;
 quit cnt  ; end of CNTITEMS
 ;
 ;
 ;
 ;@ppi-code GETITEMS^SAMICASE
GETITEMS ; get items available for studyid
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ppi;procedure;clean;silent;sac;??% tests
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
 . if $get(fname)="" set fname="unknown"
 . ;
 . new zdate set zdate=$extract(zi,$length(zkey1)+2,$length(zi))
 . set zdate=$$FMDT^SAMIUR2(zdate)
 . quit:$get(zdate)=""
 . quit:$get(zform)=""
 . quit:$get(zi)=""
 . quit:$get(fname)=""
 . ;
 . set tary("sort",zdate,zform,zi,fname)=""
 . set tary("type",zform,zi,fname)=""
 . quit
 merge @ary=tary
 ;
 ;
 ;@stanza 4 termination
 ;
 quit  ; end of ppi GETITEMS^SAMICASE
 ;
 ;
 ;
GETDTKEY(formid) ; date portion of form key
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called by
 ;  WSCASE^SAMICAS2
 ;@calls :
 ;@input
 ; formid form key
 ;@output
 ; date from form key
 ;@examples
 ; $$GETDTKEY("sbform-2018-02-26") = "2018-02-26"
 ;@tests :
 ; SAMIUTS2
 ;
 ;@stanza 2 calculate date from key
 ;
 new frm set frm=$piece(formid,"-")
 new date set date=$piece(formid,frm_"-",2)
 ;
 ;@stanza 3 return & termination
 ;
 quit date ; return date; end of $$GETDTKEY
 ;
 ;
 ;
KEY2DSPD(zkey) ; date in elcap format from key date
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called by
 ;  WSCASE^SAMICAS2
 ;@calls
 ; ^%DT
 ; $$FMTE^XLFDT
 ; $$VAPALSDT^SAMICAS2
 ;@input
 ; zkey = date in any format %DT can process
 ;@output
 ; date in elcap format
 ;@examples
 ; date 2018-02-26 => 26/Feb/2018
 ;@tests
 ; SAMIUTS2
 ;
 ;@stanza 2 convert date to elcap display format
 ;
 new X set X=zkey
 new Y
 do ^%DT
 ;new Z set Z=$$FMTE^XLFDT(Y,"9D")
 ;set Z=$translate(Z," ","/")
 new zdate
 set zdate=$$VAPALSDT^SAMICASE(Y)
 ;
 ;@stanza 3 return & termination
 ;
 quit zdate  ; return date; end of $$KEY2DSPD
 ;
 ;
 ;
 ;@ppi-code $$VAPALSDT^SAMICASE
VAPALSDT ; vapals format for dates
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ppi;function;clean;silent;sac;100% tests
 ;@signature
 ; $$VAPALSDT^SAMICASE(fmdate)
 ;@branches-from
 ; VAPALSDT^SAMICASE
 ;@ppi-called-by
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
 quit vdate ; end of ppi $$VAPALSDT^SAMICASE
 ;
 ;
 ;
 ;@section 2 WSNUFORM & related ppis
 ;
 ;
 ;
 ;@wri-code WSNUFORM^SAMICASE
WSNUFORM ; post vapals nuform: new form for patient
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wri;procedure;clean;silent;sac;?? tests
 ;@signature
 ; do WSNUFORM^SAMICASE(rtn,filter)
 ;@branches-from
 ; WSNUFORM^SAMICASE
 ;@wri-called-by
 ; WSVAPALS^SAMIHOM3 [wr nuform of ws post vapals]
 ;@called-by none
 ;@calls
 ; $$SID2NUM^SAMIHOM3
 ; $$setroot^%wd
 ; GETTMPL^SAMICAS2
 ; findReplace^%ts
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; findReplace^%ts
 ;@input
 ; .filter =
 ; .filter("studyid")=studyid of the patient
 ;@output
 ; @rtn
 ;@tests
 ; UTWSNF^SAMIUTS2
 ;
 ;
 ;@stanza 2 get select-new-form form
 ;
 new sid set sid=$get(filter("studyid"))
 quit:sid=""
 new sien set sien=$$SID2NUM^SAMIHOM3(sid)
 quit:+sien=0
 new root set root=$$setroot^%wd("vapals-patients")
 new groot set groot=$name(@root@(sien))
 ;
 new saminame set saminame=$get(@groot@("saminame"))
 quit:saminame=""
 ;
 new temp,tout,form
 set return="temp",form="vapals:nuform"
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
 . ;
 . if ln["src" d  ;
 . . do FIXSRC^SAMIFORM(.ln)
 . . set temp(zi)=ln
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
 . set cnt=cnt+1
 . set rtn(cnt)=temp(zi)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wri WSNUFORM^SAMICASE
 ;
 ;
 ;
 ;@ppi-code $$KEY2FM^SAMICASE
KEY2FM ; convert key to fileman date
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wri;procedure;silent;clean;sac;??% tests
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
 ;@stanza 2 convert key to fm date
 ;
 new datepart set datepart=key
 ; allow key to be the whole key ie ceform-2018-10-3
 if $length(key,"-")=4 do
 . new frm set frm=$piece(key,"-")
 . set datepart=$piece(key,frm_"-",2)
 . quit
 new X set X=datepart
 new Y
 do ^%DT ; call fileman to convert date
 ;
 ;
 ;@stanza 3 termination
 ;
 quit Y ; end of ppi $$KEY2FM^SAMICASE
 ;
 ;
 ;
 ;@section 3 casetbl
 ;
 ;
 ;
 ;@ppi $$GSAMISTA^SAMICAS2 = value of 'samistatus' from form
GSAMISTA(sid,form) ; extrinsic returns value of 'samistatus' from form
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
 new stat,root,useform
 set root=$$setroot^%wd("vapals-patients")
 set useform=form
 if form["vapals:" set useform=$p(form,"vapals:",2)
 set stat=$get(@root@("graph",sid,useform,"samistatus"))
 if stat="" set stat="incomplete"
 ;
 quit stat ; end of ppi $$GSAMISTA^SAMICAS2
 ;
 ;
 ;
 ;@ppi-code SSAMISTA^SAMICASE
SSAMISTA ; set samistatus to val in form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ppi;procedure;silent;clean;sac;??% tests
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
 quit  ; end of ppi SSAMISTA^SAMICASE
 ;
 ;
 ;
 ;@wri-code DELFORM^SAMICASE
DELFORM ; post vapals deleteform: delete incomplete form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wri;procedure;silent;clean;sac;??% tests
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
 quit  ; end of wri DELFORM^SAMICASE
 ;
 ;
 ;
INITSTAT ; set all forms to 'incomplete'
 ;
 ;@called by : none
 ;@calls
 ; SSAMISTA^SAMICASE
 ;@input : none
 ;@output
 ; set all forms to 'incomplete'
 ;@tests
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new zi,zj set (zi,zj)=""
 for  set zi=$order(@root@("graph",zi)) quit:zi=""  do  ;
 . for  set zj=$order(@root@("graph",zi,zj)) quit:zj=""  do  ;
 . . if zj["siform" do SSAMISTA^SAMICASE(zi,zj,"complete") quit  ;
 . . do SSAMISTA^SAMICASE(zi,zj,"incomplete")
 ;
 quit  ; end of INITSTAT
 ;
 ;
 ;
EOR ; end of routine SAMICAS2
