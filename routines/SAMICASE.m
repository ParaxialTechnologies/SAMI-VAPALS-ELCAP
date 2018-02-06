SAMICASE ;ven/gpl - ielcap: case review page ;2018-02-05T23:25Z
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
 ;@last-updated: 2018-02-05T23:25Z
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
 ; 2018-01-14 ven/gpl v18.0t04 SAMICASE: split from routine SAMIFRM, include wsCASE, getTemplate,
 ; getItems, casetbl.
 ;
 ; 2018-02-05 ven/toad v18.0t04 SAMICASE: update style, license, & attribution, spell out
 ; language elements, add white space & do-dot quits, r/replaceAll^%wfhfrom w/replaceAll^%wf,
 ; r/$$getTemplate^%wfhform w/$$getTemplate^%wf.
 ;
 ;@contents
 ; wsCASE: generates the case review page
 ; getTemplate: returns the html template
 ; getItems: get the items available for studyid sid
 ; casetbl: generates the case review table
 ;
 ;
 ;
 ;@section 1 wsCASE & related ppis
 ;
 ;
 ;
wsCASE(rtn,filter) ; generates the case review page
 ;
 ; filter("studyid")=studyid of the patient
 ;
 kill rtn
 ;
 new groot set groot=$$setroot^%wd("elcap-patients") ; root of patient graphs
 ;
 new temp ; html template
 do getTemplate("temp","casereview")
 quit:'$data(temp)
 ;
 new sid set sid=$g(filter("studyid"))
 if sid="" set sid=$get(filter("fvalue"))
 quit:sid=""
 ;
 new items
 do getItems("items",sid)
 quit:'$data(items)
 ;
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["VEP0001"  do  ;
 . if temp(zi)["/images/" do  ;
 . . new ln set ln=temp(zi)
 . . do replaceAll^%wf(.ln,"/images/","see/")
 . . set temp(zi)=ln
 . . quit
 . set rtn(zi)=temp(zi)
 . quit
 ;
 ; ready to insert rows for selection
 ;
 ; first, the intake form
 ;
 new sikey set sikey=$order(items("sifor"))
 if sikey="" set sikey="siform"
 new geturl set geturl="form?form="_sikey_"&studyid="_sid
 new posturl set posturl="javascript:subPr('siform','QIhuSAoCYzQAAAtHza8AAAAM')"
 set rtn(zi)="<tr  bgcolor=#bffbff><td> "_sid_" </td><td> Doe </td><td> Jane </td><td> 12345 </td><td>24/Aug/2012</td><td>Intake </td>"_$char(13)
 set zi=zi+1
 set rtn(zi)="<TD> <a href="""_geturl_"""><img src=""see/preview.gif""></a></td></tr>"_$char(13)
 ;
 ; second, the background form
 ;
 new sbkey set sbkey=$order(items("sbfor"))
 if sbkey="" set sbkey="sbform"
 new geturl set geturl="form?form="_sbkey_"&studyid="_sid
 new posturl set posturl="javascript:subPr('sbform','QIhuSAoCYzQAAAtHza8AAAAM')"
 set zi=zi+1
 set rtn(zi)="<tr  bgcolor=#bffbff><td> "_sid_" </td><td> - </td><td> - </td><td> 12345 </td><td>24/Aug/2012</td><td>Background </td>"_$char(13)
 set zi=zi+1
 set rtn(zi)="<TD> <a href="""_geturl_"""><img src=""see/preview.gif""></a></td></tr>"_$char(13)
 ; now skip the lines in the template up to tbody
 ; 
 new loc set loc=zi+1
 for  set zi=$order(temp(zi)) quit:+zi=0  quit:temp(zi)["/tbody"  do  ;
 . set x=$get(x)
 . quit
 set zi=zi-1
 ;
 ; now add the rest of the lines
 ;
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . set loc=loc+1
 . if temp(zi)["home.cgi" do
 . new ln set ln=temp(zi)
 . do replaceAll^%wf(.ln,"POST","GET")
 . set temp(zi)=ln
 . set rtn(loc)=temp(zi)
 . quit
 ;
 quit  ; end of wsCASE
 ;
 ;
 ;
getTemplate(return,form) ; returns the html template
 ;
 quit:$get(form)=""
 ;
 new fn set fn=$$getTemplate^%wf(form)
 do getThis^%wd(return,fn)
 ;
 set HTTPRSP("mime")="text/html"
 ;
 quit  ; end of getTemplate
 ;
 ;
 ;
getItems(ary,sid) ; get the items available for studyid sid
 ;
 ; ary is passed by name
 ;
 new groot set groot=$$setroot^%wd("elcap-patients")
 ;
 if '$data(@groot@("graph",sid)) quit  ; nothing there
 ;
 kill @ary
 new zi set zi=""
 for  set zi=$order(@groot@("graph",sid,zi)) quit:zi=""  do  ;
 . set @ary@(zi)=""
 . quit
 ;
 quit  ; end of getItems
 ;
 ;
 ;
casetbl(ary) ; generates the case review table
 ;
 ; ary is passed by name and will be cleared
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
 quit  ; end of casetbl
 ;
 ;
 ;
EOR ; end of routine SAMICASE
