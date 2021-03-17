SAMICAS2 ;ven/gpl - ielcap: case review page ;2021-03-17T15:09Z
 ;;18.0;SAMI;**1,5,9**;;Build 11
 ;;1.18.0.9-i9
 ;
 ; SAMICAS2 contains ppis and other subroutines to support processing
 ; of the VAPALS case review page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@license: see routine SAMIUL
 ;@documentation : see SAMICUL
 ;@contents
 ; WSCASE: generate case review page
 ; $$NOTEHREF = html for list of notes for form
 ; GETTMPL: return html template
 ; $$CNTITEMS = # forms patient has used before deleting patient
 ; GETITEMS: get items available for studyid
 ; $$GETDTKEY = date part of form key
 ; $$KEY2DSPD = date in elcap format from key date
 ; $$VAPALSDT = vapals format for dates
 ;
 ; WSNUFORM: select a new form for patient (get service)
 ; KEY2FM: convert a key to a fileman date
 ;
 ; $$GSAMISTA = value of 'samistatus' from form
 ; SSAMISTA: sets 'samistatus' to val in form
 ; DELFORM: deletes form if incomplete
 ; INITSTAT: set all forms to 'incomplete'
 ;
 ;
 ;
 ;@section 1 wsCASE & related ppis
 ;
 ;
 ;
 ;@ppi WSCASE^SAMICAS2, generate case review page
WSCASE ; generate case review page
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@web service
 ; SAMICASE-wsCASE
 ;@called by :
 ; WSCASE^SAMICASE
 ; _wfhform
 ; %wfhform
 ;@calls :
 ; $$setroot^%wd
 ; GETTMPL^SAMICAS2
 ; GETITEMS^SAMICASE
 ; $$SID2NUM^SAMIHOM3
 ; findReplace^%ts
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; $$GETDTKEY^SAMICAS2
 ; $$KEY2DSPD^SAMICAS2
 ; $$GETLAST5^SAMIFORM
 ; $$GETSSN^SAMIFORM
 ; $$GETNAME^SAMIFORM
 ; $$GSAMISTA^SAMICAS2
 ; D ADDCRLF^VPRJRUT
 ;@input :
 ; .filter =
 ; .filter("studyid")=studyid of the patient
 ;@output :
 ; .rtn
 ;@tests :
 ; SAMIUTS2
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
 ;@stanza 9 termination
 ;
 quit  ; end of ppi WSCASE^SAMICAS2
 ;
 ;
 ;
 ;@ppi $$NOTEHREF^SAMICAS2
NOTEHREF ; extrinsic returns html for the list of notes for the form
 ;
 n notehref,ntlist
 s notehref=""
 i form["sifor" d NTLIST^SAMINOT1("ntlist",sid,form)
 i form["fufor" d NTLIST^SAMINOT2("ntlist",sid,form)
 i $o(ntlist(""))="" q notehref
 set notehref="<table>"
 n zi
 s zi=0
 f  s zi=$o(ntlist(zi)) q:+zi=0  d  ;
 . set notehref=notehref_"<td><form method=POST action=""/vapals"">"
 . set notehref=notehref_"<input type=hidden name=""nien"" value="""_$g(ntlist(zi,"nien"))_""">"
 . set notehref=notehref_"<input type=hidden name=""samiroute"" value=""note"">"
 . set notehref=notehref_"<input type=hidden name=""studyid"" value="_sid_">"
 . set notehref=notehref_"<input type=hidden name=""form"" value="_form_">"
 . set notehref=notehref_"<input value="""_$g(ntlist(zi,"name"))_""" class=""btn btn-link"" role=""link"" type=""submit""></form></td></tr>"
 set notehref=notehref_"</table>"
 ;
 q notehref ; end of ppi $$NOTEHREF^SAMICAS2
 ;
 ;
 ;
 ;@ppi GETTMPL^SAMICAS2, get html template
GETTMPL ; get html template
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; GETTMPL^SAMICASE
 ;@calls
 ; $$getTemplate^%wf
 ; getThis^%wd
 ;@input
 ; return = name of array to return template in
 ; form = name of form
 ;@output
 ; @return = template
 ;@examples [tbd]
 ;@tests [tbd]
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
 ;@stanza 3 termination
 ;
 quit  ; end of ppi GETTMPL^SAMICAS2
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
 ;@ppi GETITEMS^SAMICAS2, get items available for studyid
GETITEMS ; get items available for studyid
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called by
 ; GETITEMS^SAMICASE
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; @ary = returned items available
 ; sid = patient's study ID (e.g. "XXX00001")
 ;@output
 ;@tests
 ; SAMIUTS2
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
 ;@stanza 3 get rest of forms (many-to-one, get dates)
 ;
 new tary
 for  set zi=$order(@ary@(zi)) quit:zi=""  do  ;
 . new zkey1,zform set zkey1=$piece(zi,"-",1)
 . ;if zkey1="sbform" quit  ;
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
 . new zdate set zdate=$extract(zi,$length(zkey1)+2,$length(zi))
 . quit:$get(zdate)=""
 . quit:$get(zform)=""
 . quit:$get(zi)=""
 . quit:$get(fname)=""
 . set tary("sort",zdate,zform,zi,fname)=""
 . set tary("type",zform,zi,fname)=""
 . quit
 merge @ary=tary
 ;
 ;@stanza 4 termination
 ;
 quit  ; end of ppi GETITEMS^SAMICAS2
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
 ;@ppi $$VAPALSDT^SAMICAS2, vapals format for dates
VAPALSDT ; extrinsic which return the vapals format for dates
 ; fmdate is the date in fileman format
 ;
 ;@called by
 ; VAPALSDT^SAMICASE
 ;@calls
 ; $$FMTE^XLFDT
 ;@input
 ; fmdate = date in fileman format
 ;@output
 ; vapals date format
 ;@tests
 ; SAMIUTS2
 ;
 ;new Z set Z=$$FMTE^XLFDT(fmdate,"9D")
 ;set Z=$translate(Z," ","/")
 ;
 new Z set Z=$$FMTE^XLFDT(fmdate,"5D")
 ;
 quit Z ; end of ppi $$VAPALSDT^SAMICAS2
 ;
 ;
 ;
 ;@section 2 WSNUFORM & related ppis
 ;
 ;
 ;
WSNUFORM ; select new form for patient (get service)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@called by
 ; WSNUFORM^SAMICASE
 ;@web service
 ;  SAMICASE-wsNuForm
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
 ; SAMIUTS
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
 ;@stanza 3 termination
 ;
 quit  ; end of WSNUFORM
 ;
 ;
 ;
 ;@ppi KEY2FM^SAMICAS2, convert a key to a fileman date
KEY2FM ; convert a key to a fileman date
 ;
 ;@called by
 ; SAVFILTR^SAMISAV
 ; SELECT^SAMIUR1
 ;@calls
 ; ^%DT
 ;@input
 ; key = vapals key (e.g.
 ;@output
 ;@examples
 ;  $$KEY2FM("sbform-2018-02-26") = 3180226
 ;@tests
 ; SAMIUTS2
 ;
 new datepart,X,Y,frm
 set datepart=key
 if $length(key,"-")=4 do  ; allow key to be the whole key ie ceform-2018-10-3
 . set frm=$piece(key,"-",1)
 . set datepart=$piece(key,frm_"-",2)
 set X=datepart
 do ^%DT
 ;
 quit Y ; end of ppi KEY2FM^SAMICAS2
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
 ;
 quit stat ; end of ppi $$GSAMISTA^SAMICAS2
 ;
 ;
 ;
 ;@ppi SSAMISTA^SAMICAS2, sets 'samistatus' to val in form
SSAMISTA ; sets 'samistatus' to val in form
 ;
 ;@called by
 ; SSAMISTA^SAMICASE
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid   = patient's studyid
 ; form  = specific study form (e.g. "sbform-2018-02-26")
 ; value = status (complete, incomplete)
 ;@output
 ; sets 'samistatus' to val in form
 ;@tests
 ;
 new root,useform
 set root=$$setroot^%wd("vapals-patients")
 set useform=form
 if form["vapals:" set useform=$piece(form,"vapals:",2)
 if '$d(@root@("graph",sid,useform)) quit  ; no form there
 set @root@("graph",sid,useform,"samistatus")=val
 ;
 quit  ; end of ppi SSAMISTA^SAMICAS2
 ;
 ;
 ;
 ;@ppi DELFORM^SAMICAS2 - deletes incomplete form
DELFORM ; deletes form if incomplete
 ; will not delete intake or background forms
 ;
 ;@called by
 ; DELFORM^SAMICASE
 ;@calls
 ; $$setroot^%wd
 ; $$GSAMISTA^SAMICAS2
 ; WSCASE^SAMICAS2
 ;@input
 ; .ARGS=
 ; .ARGS("studyid")
 ; .ARGS("form")
 ;@output
 ; @RESULT
 ;@tests
 ; SAMIUTS2
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid,form
 set sid=$get(ARGS("studyid"))
 quit:sid=""
 set form=$get(ARGS("form"))
 quit:form=""
 if form["siform" quit  ;
 ;if '$data(@root@("graph",sid,form)) quit  ; form does not exist
 if $$GSAMISTA(sid,form)="incomplete" do  ;
 . kill @root@("graph",sid,form)
 kill ARGS("samiroute")
 do WSCASE^SAMICASE(.RESULT,.ARGS)
 ;
 quit  ; end of ppi DELFORM^SAMICAS2
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
