SAMICAS2 ;ven/gpl - ielcap: case review page ; 11/13/18 10:32am
 ;;18.0;SAM;;
 ;
 ; SAMICASE contains subroutines for producing the ELCAP Case Review Page.
 ; It is currently untested & in progress.
 ;
 ; CHANGE VEN/2018-11-13
 ;   changed all SAMIHOM2 to SAMIHOM3
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-08T17:53Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@module-credits
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
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
 ; 2018-01-14 ven/gpl v18.0t04 SAMICASE: split from routine SAMIFRM,
 ; include wsCASE, getTemplate, getItems, casetbl.
 ;
 ; 2018-02-05/08 ven/toad v18.0t04 SAMICASE: update style, license, &
 ; attribution, spell out language elements, add white space & do-dot
 ; quits, r/replaceAll^%wfhfrom w/replaceAll^%wf, 
 ; r/$$getTemplate^%wfhform w/$$getTemplate^%wf.
 ;
 ; 2018-02-14 ven/toad v18.0t04 SAMICASE: r/replaceAll^%wf
 ; w/findReplaceAll^%wf, r/ln w/line, add @calls & @called-by tags, break
 ; up some long lines.
 ;
 ; 2018-02-27 ven/gpl v18.0t04 SAMICASE: new subroutines $$key2dispDate,
 ; $$getDateKey; in wsCASE get 1st & last names from graph, fix paths,
 ; key forms in graph w/date.
 ;
 ; 2018-03-01 ven/toad v18.0t04 SAMICASE: refactor & reorganize new code,
 ; add header comments, r/findReplaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-06 ven/gpl v18.0t04 SAMICASE: add New Form button, list rest
 ; of forms for patient, add web services wsNuForm & wsNuFormPost &
 ; method makeCeform, extend getItems to get rest of forms.
 ;
 ; 2018-03-07/08 ven/toad v18.0t04 SAMICASE: merge George changes w/rest,
 ; add white space, spell out mumps elements, add header comments to
 ; new subroutines, r/findReplace^%wf & replaceAll^%wf w/findReplace^%ts.
 ;
 ;@contents
 ; wsCASE: generate case review page
 ; $$getDateKey = date part of form key
 ; $$key2dispDate = date in elcap format from key date
 ; getTemplate: return html template
 ; getItems: get items available for studyid
 ;
 ; wsNuForm: select a new form for patient (get service)
 ; wsNuFormPost: post new form selection (post service)
 ; makeCeform: create ct evaluation form
 ;
 ; casetbl: generate case review table
 ;
 ;
 ;
 ;@section 1 wsCASE & related ppis
 ;
 ;
 ;
wsCASE(rtn,filter) ; generate case review page
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@called-by
 ; web service SAMICASE-wsCASE
 ; wsNewCase^SAMIHOM3
 ; wsLookup^SAMISRCH
 ;@calls
 ; $$setroot^%wd
 ; getTemplate
 ; getItems
 ; $$sid2num^SAMIHOM3
 ; findReplace^%ts
 ; $$getDateKey
 ; $$key2dispDate
 ;@input
 ;.filter =
 ;.filter("studyid")=studyid of the patient
 ;@output
 ;.rtn =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 initialize
 ;
 kill rtn
 ;
 new groot set groot=$$setroot^%wd("vapals-patients") ; root of patient graphs
 ;
 new temp ; html template
 do getTemplate("temp","vapals:casereview")
 quit:'$data(temp)
 ;
 new sid set sid=$get(filter("studyid"))
 if sid="" set sid=$get(filter("studyId"))
 if sid="" set sid=$get(filter("fvalue"))
 quit:sid=""
 ;
 new items
 do getItems("items",sid)
 quit:'$data(items)
 ;
 new gien set gien=$$sid2num^SAMIHOM3(sid) ; graph ien
 new name set name=$get(@groot@(gien,"saminame"))
 quit:name=""
 new fname set fname=$piece(name,",",2)
 new lname set lname=$piece(name,",")
 ;
 ;@stanza 3 change resource paths to /see/
 ;
 n cnt s cnt=0
 new zi set zi=0
 ;for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["VEP0001"  do  ;
 for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["tbody"  do  ;
 . n ln s ln=temp(zi)
 . n touched s touched=0
 . ;
 . i ln["id" i ln["studyIdMenu" d  ;
 . . s zi=zi+4
 . ;
 . i ln["home.html" d  ;
 . . d findReplace^%ts(.ln,"home.html","/vapals")
 . . s temp(zi)=ln
 . . s touched=1
 . ;
 . i ln["href" i 'touched d  ;
 . . d fixHref^SAMIFRM2(.ln)
 . . s temp(zi)=ln
 . ;
 . i ln["src" d  ;
 . . d fixSrc^SAMIFRM2(.ln)
 . . s temp(zi)=ln
 . ;
 . s cnt=cnt+1
 . set rtn(cnt)=temp(zi)
 . quit
 ;
 ; ready to insert rows for selection
 ;
 ;@stanza 4 intake form
 ;
 new sikey set sikey=$order(items("sifor"))
 if sikey="" set sikey="siform-2017-12-10"
 new sidate set sidate=$$getDateKey(sikey)
 s sikey="vapals:"_sikey
 new sidispdate set sidispdate=$$key2dispDate(sidate)
 ;new geturl set geturl="/form?form=vapals:siform&studyid="_sid_"&key="_sikey
 new nuhref set nuhref="<form method=POST action=""/vapals"">"
 set nuhref=nuhref_"<td><input type=hidden name=""samiroute"" value=""nuform"">"
 set nuhref=nuhref_"<input type=hidden name=""studyid"" value="_sid_">"
 set nuhref=nuhref_"<input value=""New Form"" class=""btn label label-warning"" role=""link"" type=""submit""></form></td>"
 new notehref set notehref="<form method=POST action=""/vapals"">"
 set notehref=notehref_"<input type=hidden name=""samiroute"" value=""note"">"
 set notehref=notehref_"<input type=hidden name=""studyid"" value="_sid_">"
 set notehref=notehref_"<input type=hidden name=""form"" value="_$p(sikey,":",2)_">"
 set notehref=notehref_"<input value=""Intake Note"" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 s cnt=cnt+1
 n last5 s last5=$$GETLAST5^SAMIFRM2(sid)
 n pssn s pssn=$$GETSSN^SAMIFRM2(sid)
 n pname s pname=$$GETNAME^SAMIFRM2(sid)
 n useid s useid=pssn
 i useid="" s useid=last5
 ;set rtn(cnt)="<tr><td> "_sid_" </td><td> "_lname_" </td><td> "_fname_" </td><td> - </td><td>"_sidispdate_"</td><td>"_$char(13)
 set rtn(cnt)="<tr><td> "_useid_" </td><td> "_pname_" </td><td> XXX </td><td>"_sidispdate_"</td><td>"_$char(13)
 s cnt=cnt+1
 set rtn(cnt)="<form method=""post"" action=""/vapals"">"
 set cnt=cnt+1
 set rtn(cnt)="<input name=""samiroute"" value=""form"" type=""hidden"">"
 set rtn(cnt)=rtn(cnt)_" <input name=""studyid"" value="""_sid_""" type=""hidden"">"
 set rtn(cnt)=rtn(cnt)_" <input name=""form"" value="""_sikey_""" type=""hidden"">"
 set rtn(cnt)=rtn(cnt)_" <input value=""Intake"" class=""btn btn-link"" role=""link"" type=""submit"">"
 ;
 new samistatus s samistatus=""
 if $$getSamiStatus(sid,sikey)="incomplete" set samistatus="(incomplete)"
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
 . . new zk s zk=""
 . . f  s zk=$order(items("sort",cdate,zk)) q:zk=""  d  ;
 . . . new zform set zform=zk
 . . . new zkey set zkey=$order(items("sort",cdate,zform,""))
 . . . new zname set zname=$order(items("sort",cdate,zform,zkey,""))
 . . . new dispdate set dispdate=$$key2dispDate(cdate)
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
 . . . new samistatus s samistatus=""
 . . . if $$getSamiStatus(sid,zform)="incomplete" set samistatus="(incomplete)"
 . . . set cnt=cnt+1
 . . . set rtn(cnt)="</form>"_samistatus_"</td>"
 . . . set cnt=cnt+1
 . . . i zform["ceform" d  ;
 . . . . new rpthref set rpthref="<form method=POST action=""/vapals"">"
 . . . . set rpthref=rpthref_"<td><input type=hidden name=""samiroute"" value=""ctreport"">"
 . . . . set rpthref=rpthref_"<input type=hidden name=""form"" value="_$p(zform,":",2)_">"
 . . . . set rpthref=rpthref_"<input type=hidden name=""studyid"" value="_sid_">"
 . . . . set rpthref=rpthref_"<input value=""Report"" class=""btn label label-warning"" role=""link"" type=""submit""></form></td>"
 . . . . s rtn(cnt)=rpthref_"</tr>"
 . . . . ;s rtn(cnt)="</tr>" ; turn off report 
 . . . e  set rtn(cnt)="<td></td></tr>"
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
 . n line
 . s line=temp(zi)
 . if line["XX0002" d  ;
 . . do findReplace^%ts(.line,"XX0002",sid)
 . set cnt=cnt+1
 . set rtn(cnt)=line
 . quit
 ;
 D ADDCRLF^VPRJRUT(.rtn)
 set HTTPRSP("mime")="text/html" ; set mime type
 ;
 ;@stanza 9 termination
 ;
 quit  ; end of wsCASE
 ;
 ;
getTemplate(return,form) ; get html template
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsCASE
 ; wsNuForm
 ; GETHOME^SAMIHOM3
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
 quit  ; end of getTemplate
 ;
 ;
countItems(sid) ; extrinsic returns how many forms the patient has
 ; used before deleting a patient
 new groot set groot=$$setroot^%wd("vapals-patients")
 quit:'$data(@groot@("graph",sid)) 0  ; nothing there
 n cnt,zi
 s zi=""
 s cnt=0
 f  s zi=$o(@groot@("graph",sid,zi)) q:zi=""  d  ;
 . s cnt=cnt+1
 q cnt
 ;
getItems(ary,sid) ; get items available for studyid
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsCASE
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; ary = name of array to return items in (pass by name)
 ; sid = study id
 ;@output
 ; @ary = array of items
 ;@examples [tbd]
 ;@tests [tbd]
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
 . if zkey1="sbform" s zform="vapals:sbform"
 . if zkey1="sbform" s fname="Background"
 . if zkey1="ceform" s zform="vapals:ceform"
 . if zkey1="fuform" s zform="vapals:fuform"
 . if zkey1="fuform" s fname="Follow-up"
 . if zkey1="bxform" s fname="Biopsy"
 . if zkey1="bxform" s zform="vapals:bxform"
 . if zkey1="ptform" s zform="vapals:ptform"
 . if zkey1="ptform" s fname="Pet Evaluation"
 . if zkey1="itform" s zform="vapals:itform"
 . if zkey1="itform" s fname="Intervention"
 . if $get(fname)="" set fname="unknown"
 . new zdate set zdate=$extract(zi,$length(zkey1)+2,$length(zi))
 . q:$g(zdate)=""
 . q:$g(zform)=""
 . q:$g(zi)=""
 . q:$g(fname)=""
 . set tary("sort",zdate,zform,zi,fname)=""
 . set tary("type",zform,zi,fname)=""
 . quit
 merge @ary=tary
 ;
 ;@stanza 4 termination
 ;
 quit  ; end of getItems
 ;
 ;
 ;
getDateKey(formid) ; date portion of form key
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; wsCASE
 ;@calls: none
 ;@input
 ; formid = form key
 ;@output = date from form key
 ;@examples [tbd]
 ; $$getDateKey("sbform-2018-02-26") = "2018-02-26"
 ;@tests [tbd]
 ;
 ;@stanza 2 calculate date from key
 ;
 new frm set frm=$piece(formid,"-")
 new date set date=$piece(formid,frm_"-",2)
 ;
 ;@stanza 3 return & termination
 ;
 quit date ; return date; end of $$getDateKey
 ;
 ;
 ;
key2dispDate(zkey) ; date in elcap format from key date
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; wsCASE
 ;@calls
 ; ^%DT
 ; $$FMTE^XLFDT
 ;@input
 ; zkey = date in any format %DT can process
 ;@output = date in elcap format
 ;@examples [tbd]
 ; date 2018-02-26 => 26/Feb/2018
 ;@tests [tbd]
 ;
 ;@stanza 2 convert date to elcap display format
 ;
 new X set X=zkey
 new Y
 do ^%DT
 ;new Z set Z=$$FMTE^XLFDT(Y,"9D")
 ;set Z=$translate(Z," ","/")
 n zdate
 s zdate=$$vapalsDate(Y)
 ;
 ;@stanza 3 return & termination
 ;
 quit zdate  ; return date; end of $$keysdispDate
 ;
 ;
vapalsDate(fmdate) ; extrinsic which return the vapals format for dates
 ; fmdate is the date in fileman format
 ;new Z set Z=$$FMTE^XLFDT(fmdate,"9D")
 ;set Z=$translate(Z," ","/")
 new Z set Z=$$FMTE^XLFDT(fmdate,"5D")
 q Z
 ;
 ;@section 2 wsNuForm, wsNuFormPost, & related ppis
 ;
 ;
 ;
wsNuForm(rtn,filter) ; select new form for patient (get service)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@called-by
 ; web service SAMICASE-wsNuForm
 ;@calls
 ; $$sid2num^SAMIHOM3
 ; $$setroot^%wd
 ; getTemplate
 ; findReplace^%ts
 ; ADDCRLF^VPRJRUT
 ;@input
 ;.filter =
 ;.filter("studyid")=studyid of the patient
 ;@output
 ;.rtn =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 get select-new-form form
 ;
 new sid set sid=$get(filter("studyid"))
 quit:sid=""
 new sien set sien=$$sid2num^SAMIHOM3(sid)
 quit:+sien=0
 new root set root=$$setroot^%wd("vapals-patients")
 new groot set groot=$name(@root@(sien))
 ;
 new saminame set saminame=$get(@groot@("saminame"))
 quit:saminame=""
 ;
 new temp,tout
 do getTemplate("temp","vapals:nuform")
 quit:'$data(temp)
 ;
 n cnt s cnt=0
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . n ln s ln=temp(zi)
 . n touched s touched=0
 . ;
 . ;i ln["id" i ln["studyIdMenu" d  ;
 . ;. s zi=zi+4
 . ;
 . ;i ln["home.html" d  ;
 . ;. d findReplace^%ts(.ln,"home.html","/vapals")
 . ;. s temp(zi)=ln
 . ;. s touched=1
 . ;
 . i ln["href" i 'touched d  ;
 . . d fixHref^SAMIFRM2(.ln)
 . . s temp(zi)=ln
 . ;
 . i ln["src" d  ;
 . . d fixSrc^SAMIFRM2(.ln)
 . . s temp(zi)=ln
 . ;
 . ;i ln["form" i ln["todo" d  ;
 . ;. d findReplace^%ts(.ln,"todo","/vapals")
 . ;. s cnt=cnt+1
 . ;. s rtn(cnt)=ln
 . ;. s cnt=cnt+1
 . ;. s rtn(cnt)="<input type=hidden name=""samiroute"" value=""addform"">"
 . ;. s cnt=cnt+1
 . ;. s rtn(cnt)="<input type=hidden name=""sid"" value="_sid_">"
 . ;. s zi=zi+1
 . ;
 . ;i ln["background" s temp(zi)=""
 . ;i ln["background" d  ;
 . ;. d findReplace^%ts(.ln,"background","sbform")
 . ;. s temp(zi)=ln
 . ;i ln["followup" d  ;
 . ;. d findReplace^%ts(.ln,"followup","fuform")
 . ;. s temp(zi)=ln
 . ;i ln["pet" d  ;
 . ;. d findReplace^%ts(.ln,"pet","ptform")
 . ;. s temp(zi)=ln
 . ;i ln["ctevaluation" d  ;
 . ;. d findReplace^%ts(.ln,"ctevaluation","ceform")
 . ;. s temp(zi)=ln
 . ;i ln["biopsy" d  ;
 . ;. d findReplace^%ts(.ln,"biopsy","bxform")
 . ;. s temp(zi)=ln
 . ;i ln["newform" d  ;
 . ;. s temp(zi)=""
 . ;. s temp(zi+1)=""
 . ;
 . if ln["@@SID@@" do  ;
 . . do findReplace^%ts(.ln,"@@SID@@",sid)
 . . s temp(zi)=ln
 . . quit
 . ;
 . ;i ln["<script" i temp(zi+1)["function" d  ;
 . ;. s zi=$$scanFor^SAMIHOM3(.temp,zi,"</script")
 . ;. s zi=zi+1
 . ; 
 . s cnt=cnt+1
 . set rtn(cnt)=temp(zi)
 ;
 ;m tout=rtn
 ;do ADDCRLF^VPRJRUT(.tout)
 ;merge rtn=tout
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wsNuForm
 ;
 ;
 ;
wsNuFormPost(ARGS,BODY,RESULT) ; post new form selection (post service)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@called-by
 ; web service SAMICASE-wsNuFormPost
 ;@calls
 ; parseBody^%wf
 ; $$NOW^XLFDT
 ; $$keyDate^SAMIHOM3
 ; GETHOME^SAMIHOM3
 ; makeCeform
 ; wsGetForm^%wf
 ;@input
 ;.ARGS =
 ;.BODY =
 ;@output
 ;.RESULT =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 get new form
 ;
 new vars,bdy
 set bdy=$get(BODY(1))
 do parseBody^%wf("vars",.bdy)
 m vars=ARGS
 merge ^gpl("nuform","vars")=vars
 ;
 new sid set sid=$get(vars("studyid"))
 i sid="" s sid=$g(ARGS("sid"))
 if sid="" do  quit  ;
 . do GETHOME^SAMIHOM3(.RESULT,.ARGS) ; on error return to home page
 . quit
 ;
 set nuform=$get(vars("form"))
 if nuform="" set nuform="ceform"
 ;
 new datekey set datekey=$$keyDate^SAMIHOM3($$NOW^XLFDT)
 ;
 ; check to see if form already exists
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 i $d(@root@("graph",sid,nuform_"-"_datekey)) d  ; already exists
 . i nuform="siform" q
 . n lastone
 . s lastone=$o(@root@("graph",sid,nuform_"-a  "),-1)
 . q:lastone=""
 . s newfm=$$key2fm(lastone)
 . s datekey=$$keyDate^SAMIHOM3($$FMADD^XLFDT(newfm,1)) ; add one day to the last form
 ;
 if nuform="sbform" do  ;
 . new key set key="sbform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:sbform"
 . do makeSbform(sid,key)
 . quit
 ;
 if nuform="ceform" do  ;
 . new key set key="ceform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:ceform"
 . do makeCeform(sid,key)
 . quit
 ;
 if nuform="fuform" do  ;
 . new key set key="fuform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:fuform"
 . do makeFuform(sid,key)
 . quit
 ;
 if nuform="bxform" do  ;
 . new key set key="bxform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:bxform"
 . do makeBxform(sid,key)
 . quit
 ;
 if nuform="ptform" do  ;
 . new key set key="ptform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:ptform"
 . do makePtform(sid,key)
 . quit
 ;
 if nuform="itform" do  ;
 . new key set key="itform-"_datekey
 . set ARGS("key")=key
 . set ARGS("studyid")=sid
 . set ARGS("form")="vapals:itform"
 . do makeItform(sid,key)
 . quit
 ;
 do wsGetForm^%wf(.RESULT,.ARGS)
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wsNuFormPost
 ;
key2fm(key) ; convert a key to a fileman date
 ; 
 n datepart,X,Y,frm
 s datepart=key
 i $l(key,"-")=4 d  ; allow key to be the whole key ie ceform-2018-10-3
 . s frm=$p(key,"-",1)
 . s datepart=$p(key,frm_"-",2)
 s X=datepart
 d ^%DT
 q Y
 ;
 ;
makeSbform(sid,key) ; create background form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNuFormPost
 ;@calls
 ; $$setroot^%wd
 ; $$sid2num^SAMIHOM3
 ;@input
 ; sid = studiy id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$sid2num^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"sbform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 d setSamiStatus^SAMICAS2(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makeSbform
 ;
makeCeform(sid,key) ; create ct evaluation form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNuFormPost
 ;@calls
 ; $$setroot^%wd
 ; $$sid2num^SAMIHOM3
 ;@input
 ; sid = studiy id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$sid2num^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"ceform-",2)
 new items,prevct
 d getItems^SAMICAS2("items",sid)
 s prevct=""
 i $d(items("type","vapals:ceform")) d  ;previous cteval exists
 . s prevct=$o(items("type","vapals:ceform",""),-1) ; latest ceform
 i prevct'="" d  ;
 . n target,source
 . s source=$na(@root@("graph",sid,prevct))
 . s target=$na(@root@("graph",sid,key))
 . d CTCOPY^SAMICTC1(source,target)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 d setSamiStatus^SAMICAS2(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makeCeform
 ;
makeFuform(sid,key) ; create Follow-up form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNuFormPost
 ;@calls
 ; $$setroot^%wd
 ; $$sid2num^SAMIHOM3
 ;@input
 ; sid = studiy id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$sid2num^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"fuform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 d setSamiStatus^SAMICAS2(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makeFuform
 ;
makePtform(sid,key) ; create ct evaluation form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNuFormPost
 ;@calls
 ; $$setroot^%wd
 ; $$sid2num^SAMIHOM3
 ;@input
 ; sid = studiy id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$sid2num^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"ptform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 d setSamiStatus^SAMICAS2(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makePtform
 ;
makeItform(sid,key) ; create intervention form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNuFormPost
 ;@calls
 ; $$setroot^%wd
 ; $$sid2num^SAMIHOM3
 ;@input
 ; sid = studiy id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$sid2num^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"itform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 d setSamiStatus^SAMICAS2(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makePtform
 ;
makeBxform(sid,key) ; create ct evaluation form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNuFormPost
 ;@calls
 ; $$setroot^%wd
 ; $$sid2num^SAMIHOM3
 ;@input
 ; sid = studiy id
 ; key =
 ;@output
 ; @root@("graph",sid,key)
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 create ct eval form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sien set sien=$$sid2num^SAMIHOM3(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"bxform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 d setSamiStatus^SAMICAS2(sid,key,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makeBxform
 ;
 ;
 ;
 ;@section 3 casetbl
 ;
getSamiStatus(sid,form) ; extrinsic returns the value of 'samistatus' from the form
 n stat,root,useform
 s root=$$setroot^%wd("vapals-patients")
 s useform=form
 i form["vapals:" s useform=$p(form,"vapals:",2)
 s stat=$g(@root@("graph",sid,useform,"samistatus"))
 q stat
 ;
setSamiStatus(sid,form,val) ; sets 'samistatus' to val in form
 n root,useform
 s root=$$setroot^%wd("vapals-patients")
 s useform=form
 i form["vapals:" s useform=$p(form,"vapals:",2)
 i '$d(@root@("graph",sid,useform)) q  ; no form there
 s @root@("graph",sid,useform,"samistatus")=val
 q
 ;
deleteForm(RESULT,ARGS) ; deletes a form if it is incomplete
 ; will not delete intake or background forms
 n root s root=$$setroot^%wd("vapals-patients")
 n sid,form
 s sid=$g(ARGS("studyid"))
 q:sid=""
 s form=$g(ARGS("form"))
 q:form=""
 i form["siform" q  ;
 ;i '$d(@root@("graph",sid,form)) q  ; form does not exist
 i $$getSamiStatus^SAMICAS2(sid,form)="incomplete" d  ;
 . kill @root@("graph",sid,form)
 k ARGS("samiroute")
 d wsCASE^SAMICAS2(.RESULT,.ARGS)
 q
 ;
initStatus ; set all forms to 'incomplete'
 n root s root=$$setroot^%wd("vapals-patients")
 n zi,zj s (zi,zj)=""
 f  s zi=$o(@root@("graph",zi)) q:zi=""  d  ;
 . f  s zj=$o(@root@("graph",zi,zj)) q:zj=""  d  ;
 . . if zj["siform" d setSamiStatus^SAMICAS2(zi,zj,"complete") q  ;
 . . d setSamiStatus^SAMICAS2(zi,zj,"incomplete")
 q
 ;
casetbl(ary) ; generates case review table
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by: ?
 ;@calls: none
 ;@throughput
 ; ary = name of array (passed by name, will be cleared)
 ;@output
 ; @ary = ?
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 build table
 ;
 kill @ary
 ;
 set @ary@("siform","form")="siform"
 set @ary@("siform","js")="subPr"
 set @ary@("siform","name")="Intake"
 set @ary@("siform","image")="preview.gif"
 ;
 set @ary@("nuform","form")="nuform"
 set @ary@("nuform","js")="subFr"
 set @ary@("nuform","name")="New Form"
 set @ary@("nuform","image")="nform.gif"
 ;
 set @ary@("sched","form")="sched"
 set @ary@("sched","js")="subSc"
 set @ary@("sched","name")="Schedule"
 set @ary@("sched","image")="schedule.gif"
 ;
 set @ary@("sbform","form")="sbform"
 set @ary@("sbform","js")="subPr"
 set @ary@("sbform","name")="Background"
 set @ary@("sbform","image")="preview.gif"
 ;
 set @ary@("ceform","form")="ceform"
 set @ary@("ceform","js")="subPr"
 set @ary@("ceform","name")="CT Evaluation"
 set @ary@("ceform","image")="preview.gif"
 ;
 set @ary@("report","form")="report"
 set @ary@("report","js")="subRp"
 set @ary@("report","name")="Report"
 set @ary@("report","image")="report.gif"
 ;
 set @ary@("ptform","form")="ptform"
 set @ary@("ptform","js")="subPr"
 set @ary@("ptform","name")="PET Evaluation"
 set @ary@("ptform","image")="preview.gif"
 ;
 set @ary@("bxform","form")="bxform"
 set @ary@("bxform","js")="subPr"
 set @ary@("bxform","name")="Biopsy"
 set @ary@("bxform","image")="preview.gif"
 ;
 set @ary@("rbform","form")="rbform"
 set @ary@("rbform","js")="subPr"
 set @ary@("rbform","name")="Intervention"
 set @ary@("rbform","image")="preview.gif"
 ;
 set @ary@("ceform","form")="ceform"
 set @ary@("ceform","js")="subPr"
 set @ary@("ceform","name")="CT Evaluation"
 set @ary@("ceform","image")="preview.gif"
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of casetbl
 ;
 ;
 ;
EOR ; end of routine SAMICAS2
