SAMICASE ;ven/gpl - ielcap forms ;Sep 18,2017@18:01
 ;;18.0;SAM;;
 ;
 ; Routine SAMIFRM contains subroutines for managing the ELCAP forms,
 ; including initialization and enhancements to the SAMI FORM FILE (311.11)
 ;
 ; Primary Development History
 ;
 ; @primary-dev: George P. Lilly (gpl)
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ; @copyright: 2017, Vista Expertise Network (ven), all rights reserved
 ; @license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2017-09-19T11:01Z
 ; @application: Screening Applications Management (SAM)
 ; @module: Screening Applications Management - IELCAP (SAMI)
 ; @suite-of-files: SAMI Forms (311.101-311.199)
 ; @version: 18.0T01 (first development version)
 ; @release-date: not yet released
 ; @patch-list: none yet
 ;
 ; @funding-org: 2017-2018,Bristol-Myers Squibb Foundation (bmsf)
 ;   https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;
 ; 2017-09-19 ven/gpl v18.0t01 SAMIFRM: initialize the SAMI FORM file from elcap-patient graphs,
 ; using mash tools and graphs (%yottaq,^%wd)
 ;
 ;
 ; contents
 ;
 ;
 ;
 ;
 Q
 ;
wsCASE(rtn,filter) ; generates the case review page
 ; filter("studyid")=studyid of the patient
 ;
 k rtn
 ;
 n groot s groot=$$setroot^%wd("elcap-patients") ; root of patient graphs
 ;
 new temp ; html template
 d getTemplate("temp","casereview")
 q:'$d(temp)
 ;
 n sid s sid=$g(filter("studyid"))
 i sid="" s sid=$g(filter("fvalue"))
 q:sid=""
 ;
 n items
 d getItems("items",sid)
 q:'$d(items)
 ;
 n zi s zi=0
 f  s zi=$o(temp(zi)) q:+zi=0  q:temp(zi)["VEP0001"  d  ;
 . i temp(zi)["/images/" d  ;
 . . n ln s ln=temp(zi)
 . . d replaceAll^%wfhform(.ln,"/images/","see/")
 . . s temp(zi)=ln
 . s rtn(zi)=temp(zi)
 ;
 ; ready to insert rows for selection
 ;
 ; first, the intake form
 ;
 n sikey s sikey=$o(items("sifor"))
 i sikey="" s sikey="siform"
 n geturl s geturl="form?form="_sikey_"&studyid="_sid
 n posturl s posturl="javascript:subPr('siform','QIhuSAoCYzQAAAtHza8AAAAM')"
 s rtn(zi)="<tr  bgcolor=#bffbff><td> "_sid_" </td><td> Doe </td><td> Jane </td><td> 12345 </td><td>24/Aug/2012</td><td>Intake </td>"_$C(13)
 s zi=zi+1
 s rtn(zi)="<TD> <a href="""_geturl_"""><img src=""see/preview.gif""></a></td></tr>"_$C(13)
 ;
 ; second, the background form
 ;
 n sbkey s sbkey=$o(items("sbfor"))
 if sbkey="" s sbkey="sbform"
 n geturl s geturl="form?form="_sbkey_"&studyid="_sid
 n posturl s posturl="javascript:subPr('sbform','QIhuSAoCYzQAAAtHza8AAAAM')"
 s zi=zi+1
 s rtn(zi)="<tr  bgcolor=#bffbff><td> "_sid_" </td><td> - </td><td> - </td><td> 12345 </td><td>24/Aug/2012</td><td>Background </td>"_$C(13)
 s zi=zi+1
 s rtn(zi)="<TD> <a href="""_geturl_"""><img src=""see/preview.gif""></a></td></tr>"_$C(13)
 
 ; now skip the lines in the template up to tbody
 ; 
 n loc s loc=zi+1
 f  s zi=$o(temp(zi)) q:+zi=0  q:temp(zi)["/tbody"  d  ;
 . s x=$g(x)
 s zi=zi-1
 ; now add the rest of the lines
 ;
 f  s zi=$o(temp(zi)) q:+zi=0  d  ;
 . s loc=loc+1
 . i temp(zi)["home.cgi" d  
 . n ln s ln=temp(zi)
 . d replaceAll^%wfhform(.ln,"POST","GET")
 . s temp(zi)=ln
 . s rtn(loc)=temp(zi)
 ;
 q
 ;
getTemplate(return,form) ; returns the html template
 ;
 q:$g(form)=""
 ;
 n fn s fn=$$getTemplate^%wfhform(form)
 d getThis^%wd(return,fn)
 ;
 s HTTPRSP("mime")="text/html"
 ;
 q
 ;
getItems(ary,sid) ; get the items available for studyid sid
 ; ary is passed by name
 n groot s groot=$$setroot^%wd("elcap-patients")
 ;
 i '$d(@groot@("graph",sid)) q  ; nothing there
 ;
 k @ary
 n zi s zi=""
 f  s zi=$o(@groot@("graph",sid,zi)) q:zi=""  d  ;
 . s @ary@(zi)=""
 ;
 q
 ;
casetbl(ary) ; generates the case review table
 ; ary is passed by name and will be cleared
 ;
 k @ary
 ;
 s @ary@("siform","form")="siform"
 s @ary@("siform","js")="subPr"
 s @ary@("siform","name")="Intake"
 s @ary@("siform","image")="preview.gif"
 ;
 s @ary@("nuform","form")="nuform"
 s @ary@("nuform","js")="subFr"
 s @ary@("nuform","name")="New Form"
 s @ary@("nuform","image")="nform.gif"
 ;
 s @ary@("sched","form")="sched"
 s @ary@("sched","js")="subSc"
 s @ary@("sched","name")="Schedule"
 s @ary@("sched","image")="schedule.gif"
 ;
 s @ary@("sbform","form")="sbform"
 s @ary@("sbform","js")="subPr"
 s @ary@("sbform","name")="Background"
 s @ary@("sbform","image")="preview.gif"
 ;
 s @ary@("ceform","form")="ceform"
 s @ary@("ceform","js")="subPr"
 s @ary@("ceform","name")="CT Evaluation"
 s @ary@("ceform","image")="preview.gif"
 ;
 s @ary@("report","form")="report"
 s @ary@("report","js")="subRp"
 s @ary@("report","name")="Report"
 s @ary@("report","image")="report.gif"
 ;
 s @ary@("ptform","form")="ptform"
 s @ary@("ptform","js")="subPr"
 s @ary@("ptform","name")="PET Evaluation"
 s @ary@("ptform","image")="preview.gif"
 ;
 s @ary@("bxform","form")="bxform"
 s @ary@("bxform","js")="subPr"
 s @ary@("bxform","name")="Biopsy"
 s @ary@("bxform","image")="preview.gif"
 ;
 s @ary@("rbform","form")="rbform"
 s @ary@("rbform","js")="subPr"
 s @ary@("rbform","name")="Intervention"
 s @ary@("rbform","image")="preview.gif"
 ;
 s @ary@("ceform","form")="ceform"
 s @ary@("ceform","js")="subPr"
 s @ary@("ceform","name")="CT Evaluation"
 s @ary@("ceform","image")="preview.gif"
 ;
 q
 ;
