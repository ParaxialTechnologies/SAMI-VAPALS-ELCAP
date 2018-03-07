SAMICASE ;ven/gpl - ielcap: case review page ;2018-03-07T18:48Z
 ;;18.0;SAM;;
 ;
 ; SAMICASE contains subroutines for producing the ELCAP Case Review Page.
 ; It is currently untested & in progress.
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
 ;@last-updated: 2018-03-07T18:48Z
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
 ; 2018-03-07 ven/toad v18.0t04 SAMICASE: merge George changes w/rest,
 ; add white space, spell out mumps elements, add header comments to
 ; new subroutines, r/findReplace^%wf w/findReplace^%ts.
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
 ; wsNewCase^SAMIHOME
 ; wsLookup^SAMISRCH
 ;@calls
 ; $$setroot^%wd
 ; getTemplate
 ; getItems
 ; $$sid2num^SAMIHOME
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
 new groot set groot=$$setroot^%wd("elcap-patients") ; root of patient graphs
 ;
 new temp ; html template
 do getTemplate("temp","casereview")
 quit:'$data(temp)
 ;
 new sid set sid=$get(filter("studyid"))
 if sid="" set sid=$get(filter("fvalue"))
 quit:sid=""
 ;
 new items
 do getItems("items",sid)
 quit:'$data(items)
 ;
 new gien set gien=$$sid2num^SAMIHOME(sid) ; graph ien
 new name set name=$get(@groot@(gien,"saminame"))
 quit:name=""
 new fname set fname=$piece(name,",",2)
 new lname set lname=$piece(name,",")
 ;
 ;@stanza 3 change resource paths to /see/
 ;
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["VEP0001"  do  ;
 . if temp(zi)["/images/" do  ;
 . . new line set line=temp(zi)
 . . do findReplace^%ts(.line,"/images/","/see/","a")
 . . set temp(zi)=line
 . . quit
 . set rtn(zi)=temp(zi)
 . quit
 ;
 ; ready to insert rows for selection
 ;
 ;@stanza 4 intake form
 ;
 new sikey set sikey=$order(items("sifor"))
 if sikey="" set sikey="siform-2017-12-10"
 new sidate set sidate=$$getDateKey(sikey)
 new sidispdate set sidispdate=$$key2dispDate(sidate)
 new geturl set geturl="/form?form="_sikey_"&studyid="_sid
 new posturl set posturl="javascript:subPr('siform','QIhuSAoCYzQAAAtHza8AAAAM')"
 new nuhref set nuhref="<a href=""/nuform?studyid="_sid_"""><img src=""/see/nform.gif""></a>"
 set rtn(zi)="<tr  bgcolor=#bffbff><td> "_sid_" </td><td> "_lname_" </td><td> "_fname_" </td><td> - </td><td>"_sidispdate_"</td><td>Intake </td>"_$char(13)
 set zi=zi+1
 set rtn(zi)="<TD> <a href="""_geturl_"""><img src=""/see/preview.gif""></a>"_nuhref_"</td></tr>"_$char(13)
 ;
 ;@stanza 5 background form
 ;
 new sbkey set sbkey=$order(items("sbfor"))
 if sbkey="" set sbkey="sbform-2017-12-10"
 new sbdate set sbdate=$$getDateKey^SAMICASE(sbkey)
 new sbdispdate set sbdispdate=$$key2dispDate^SAMICASE(sbdate)
 new geturl set geturl="/form?form="_sbkey_"&studyid="_sid
 new posturl set posturl="javascript:subPr('sbform','QIhuSAoCYzQAAAtHza8AAAAM')"
 set zi=zi+1
 set rtn(zi)="<tr  bgcolor=#bffbff><td> "_sid_" </td><td> - </td><td> - </td><td> - </td><td>"_sbdispdate_"</td><td>Background </td>"_$char(13)
 set zi=zi+1
 set rtn(zi)="<TD> <a href="""_geturl_"""><img src=""/see/preview.gif""></a></td></tr>"_$char(13)
 ;
 ;@stanza 6 rest of the forms
 ;
 new zj set zj="" ; each of the rest of the forms
 if $data(items("sort")) do  ; we have more forms
 . for  set zj=$order(items("sort",zj),-1) quit:zj=""  do  ;
 . . new cdate set cdate=zj
 . . new zform set zform=$order(items("sort",cdate,""))
 . . new zkey set zkey=$order(items("sort",cdate,zform,""))
 . . new zname set zname=$order(items("sort",cdate,zform,zkey,""))
 . . new dispdate set dispdate=$$key2dispDate(cdate)
 . . new geturl set geturl="/form?form="_zkey_"&studyid="_sid
 . . ; new posturl set posturl="javascript:subPr('"_zform_"','QIhuSAoCYzQAAAtHza8AAAAM')"
 . . set zi=zi+1
 . . set rtn(zi)="<tr  bgcolor=#bffbff><td> "_sid_" </td><td> - </td><td> - </td><td> - </td><td>"_dispdate_"</td><td>"_zname_" </td>"_$char(13)
 . . set zi=zi+1
 . . set rtn(zi)="<TD> <a href="""_geturl_"""><img src=""/see/preview.gif""></a></td></tr>"_$char(13)
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
 . set loc=loc+1
 . if temp(zi)["home.cgi" do
 . new line set line=temp(zi)
 . do findReplace^%ts(.line,"POST","GET","a")
 . set temp(zi)=line
 . set rtn(loc)=temp(zi)
 . quit
 ;
 ;@stanza 9 termination
 ;
 quit  ; end of wsCASE
 ;
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
 ; getHome^SAMIHOME
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
 new groot set groot=$$setroot^%wd("elcap-patients")
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
 . new zform set zform=$piece(zi,"-",1)
 . if zform="sbform" quit  ;
 . if zform="siform" quit  ;
 . new fname
 . if zform="ceform" set fname="CT Evaluation"
 . if $get(fname)="" set fname="unknown"
 . new zdate set zdate=$extract(zi,$length(zform)+2,$length(zi))
 . set tary("sort",zdate,zform,zi,fname)=""
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
 new Z set Z=$$FMTE^XLFDT(Y,"9D")
 set Z=$translate(Z," ","/")
 ;
 ;@stanza 3 return & termination
 ;
 quit Z  ; return date; end of $$keysdispDate
 ;
 ;
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
 ; $$sid2num^SAMIHOME
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
 new sien set sien=$$sid2num^SAMIHOME(sid)
 quit:+sien=0
 new root set root=$$setroot^%wd("elcap-patients")
 new groot set groot=$name(@root@(sien))
 ;
 new saminame set saminame=$get(@groot@("saminame"))
 quit:saminame=""
 ;
 new tmpl,tout
 do getTemplate("tmpl","nuform")
 quit:'$data(tmpl)
 ;
 new tcnt set tcnt=0
 new zi set zi=0
 for  set zi=$order(tmpl(zi)) quit:+zi=0  quit:tmpl(zi)["nuform"  do  ;
 . new ln set ln=tmpl(zi)
 . if ln["VEP0001" do replaceAll^%ts(.ln,"VEP0001",sid)
 . if ln["Doe, Jane" do replaceAll^%ts(.ln,"Doe, Jane",saminame)
 . set tcnt=tcnt+1
 . set tout(tcnt)=ln
 . quit
 ;
 new ln set ln=tmpl(zi)
 do replaceAll^%ts(.ln,"/cgi-bin/datac/nuform.cgi","/nuform?studyid="_sid)
 set tcnt=tcnt+1 set tout(tcnt)=ln
 ;
 for  set zi=$order(tmpl(zi)) quit:+zi=0  quit:tmpl(zi)["/FORM"  do  ;
 . set ln=tmpl(zi)
 . if ln["OPTION" do  ;
 . . if ln'["ceform" set ln=""
 . . quit
 . if ln["VEP0001" do replaceAll^%ts(.ln,"VEP0001",sid)
 . set tcnt=tcnt+1
 . set tout(tcnt)=ln
 . quit
 set tcnt=tcnt+1
 set tout(tcnt)="</td></tr></table> </body> </html> "
 do ADDCRLF^VPRJRUT(.tout)
 merge rtn=tout
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
 ; $$keyDate^SAMIHOME
 ; getHome^SAMIHOME
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
 merge ^gpl("nuform","vars")=vars
 ;
 set nuform=$get(vars("form"))
 if nuform="" set nuform="ceform"
 ;
 new datekey set datekey=$$keyDate^SAMIHOME($$NOW^XLFDT)
 ;
 new sid set sid=$get(vars("sid"))
 if sid="" do  quit  ;
 . do getHome^SAMIHOME(.RESULT,.ARGS) ; on error return to home page
 . quit
 ;
 if nuform="ceform" do  ;
 . new key set key="ceform-"_datekey
 . set ARGS("form")=key
 . do makeCeform(sid,key)
 . quit
 ;
 do wsGetForm^%wf(.RESULT,.ARGS)
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wsNuFormPost
 ;
 ;
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
 ; $$sid2num^SAMIHOME
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
 new root set root=$$setroot^%wd("elcap-patients")
 new sien set sien=$$sid2num^SAMIHOME(sid)
 quit:+sien=0
 new cdate set cdate=$piece(key,"ceform-",2)
 merge @root@("graph",sid,key)=@root@(sien)
 set @root@("graph",sid,key,"samicreatedate")=cdate
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makeCeform
 ;
 ;
 ;
 ;@section 3 casetbl
 ;
 ;
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
EOR ; end of routine SAMICASE
