SAMIFRM2 ;ven/gpl - ielcap: forms ; 2/14/19 10:35am
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; Routine SAMIFRM contains subroutines for managing the ELCAP forms,
 ; including initialization and enhancements to the SAMI FORM FILE (311.11)
 ; CURRENTLY UNTESTED & IN PROGRESS
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
 ;@copyright: 2017, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2019-01-02T18:04Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T01 (first development version)
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
 ; 2017-09-19 ven/gpl v18.0t01 SAMIFRM: initialize the SAMI FORM file
 ; from elcap-patient graphs, using mash tools and graphs (%yottaq,^%wd)
 ;
 ; 2017-09-18 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2017-12-18 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-01-03 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-01-14 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-02-04 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-02-05/07 ven/toad v18.0t04 SAMIFRM: update license & attribution
 ; & hdr comments, add white space & do-dot quits, spell out language
 ; elements; in SAMISUBS r/replaceAll^%wfhform w/replaceAll^%wf.
 ; r/calls to $$setroot^%yottaq & getVals^%yottaq w/$$setroot^%wdgraph
 ; & getVals^%wf.
 ;
 ; 2018-02-14 ven/toad v18.0t04 SAMIFRM: r/replaceAll^%wf
 ; w/findReplaceAll^%wf, r/ln w/line, add @calls & @called-by tags, break
 ; up some long lines, scope variables in $$GETDIR & $$GETFN.
 ;
 ; 2018-03-01 ven/toad v18.0t04 SAMIFRM: r/findReplaceAll^%wf
 ; w/findReplace^%ts.
 ;
 ; 2018-03-07/08 ven/toad v18.0t04 SAMIFRM: in SAMISUBS
 ; r/$$setroot^%wdgraph w/$$setroot^%wf, fix bug when r/css w/see.
 ;
 ; 2018-03-18 ven/toad SAMI*18.0t04 SAMIFRM2: restore calls to
 ; findReplaceAll^%ts.
 ;
 ; 2018-03-21/04-02 ven/gpl SAMI*18.0t04 SAMIFRM2: max date insertion,
 ; case review navigation changed to post, date order for CT Eval in
 ; case review; changes to support incomplete forms display & processing;
 ; fix to not inject html in the javascript for case review navigation;
 ; fix followup submit.
 ;
 ; 2018-04-24 ven/gpl SAMI*18.0t04 SAMIFRM2: added Pet & Biopsy forms.
 ;
 ; 2018-05-18/21 ven/gpl SAMI*18.0t04 SAMIFRM2: conversion to new graph
 ; & simplified forms processing.
 ;
 ; 2018-05-22 par/dom SAMI*18.0t04 SAMIFRM2: VAP-95 - removed code that
 ; replaced hard-coded date w/"today" from backend, no longer needed.
 ;
 ; 2018-05-24 ven/gpl SAMI*18.0t04 SAMIFRM2: changes for submit processing
 ; on forms.
 ;
 ; 2018-05-25 par/dom SAMI*18.0t04 SAMIFRM2: merge pull request 3 fr/
 ; OSEHRA/VAP-95-Remove-Today-Text-Replacement2. VAP-95 remove today text
 ; replacement.
 ;
 ; 2018-05-25 ven/gpl SAMI*18.0t04 SAMIFRM2: add STUDYID for txt replace;
 ; more changes for STUDYID substitution.
 ;
 ; 2018-07-11 ven/gpl SAMI*18.0t04 SAMIFRM2: added FROZEN variable based
 ; on samistatus=compete.
 ;
 ; 2018-08-19 ven/gpl SAMI*18.0t04 SAMIFRM2: use ssn instead of last5 where
 ; available; revised ssn formatting.
 ;
 ; 2018-09-30 ven/gpl SAMI*18.0t04 SAMIFRM2: header & prefill of intake.
 ;
 ; 2018-10-15 ven/gpl SAMI*18.0t04 SAMIFRM2: initial user reports:
 ; enrollment.
 ;
 ; 2018-10-31 ven/gpl SAMI*18.0t04 SAMIFRM2: new input form features,
 ; report menu fix.
 ;
 ; 2018-11-13 ven/gpl SAMI*18.0t04 SAMIFRM2: every occurance of SAMIHOM2
 ; changed to SAMIHOM3.
 ;
 ; 2018-11-14 ven/gpl SAMI*18.0t04 SAMIFRM2: fix graph store forms.
 ;
 ; 2018-11-29 ven/lgc SAMI*18.0t04 SAMIFRM2: ongoing unit-test work.
 ;
 ; 2018-12-11/12 ven/toad SAMI*18.0t04 SAMIFRM2: update chg log; in SAMISUB2
 ; r/last findReplace^%ts w/a flag and r/w/findReplaceAll^%ts; passim
 ; spell out language elements, update tags called-by, calls, tests;
 ; namespace call-by-ref & call-by-name actuals.
 ;
 ; 2019-01-02 ven/toad SAMI*18.0t04 SAMIFRM2: update chg log.
 ;
 ;@contents
 ; INITFRMS: initial all available forms
 ; INIT1FRM: initialize 1 form from elcap-patient graph (field names only)
 ;
 ; REGFORMS: register elcap forms in form mapping file
 ; LOADDATA: import directory full of json data into elcap-patient graph
 ; PRSFLNM: parse filename extracting studyid and form
 ;
 ; $$GETDIR = prompt for directory
 ; $$GETFN = prompt for filename
 ;
 ; SAMISUBS: ln is passed by reference; filter is passed by reference
 ; SAMISUB2: used for Dom's new style forms
 ; FIXSRC: fix html src lines to use resources in see/
 ; FIXHREF: fix html href lines to use resources in see/
 ;
 ; $$GETLAST5 = last5 for patient sid
 ; $$GETNAME = name for patient sid
 ; $$GETSSN = ssn for patient sid
 ; $$GETHDR = header string for patient sid
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
INITFRMS ; initilize form file from elcap-patient graphs
 ;
 ;@called-by: ???
 ;@calls
 ; $$setroot^%wd
 ; getVals^%wf
 ; INIT1FRM
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 quit:root=""
 new groot set groot=$name(@root@("graph"))
 new patient set patient=$order(@groot@(""),-1) ; use last patient in graph
 quit:patient=""
 ;
 new form set form=""
 ; for each form patient has:
 for  set form=$order(@groot@(patient,form)) quit:form=""  do
 . new SAMIARRAY
 . do getVals^%wf("SAMIARRAY",form,patient) ; get array of fields & values
 . write !,"using patient: ",patient
 . do INIT1FRM(form,"SAMIARRAY") ; initialize form & its fields
 . quit
 ;
 quit  ; end of INITFRMS
 ;
 ;
 ;
INIT1FRM(form,ary) ; initialize one form named form from ary passed by name
 ;
 ;@called-by
 ; INITFRMS
 ;@calls
 ; UPDATE^DIE
 ; CLEAN^DILF
 ;
 write !,form
 zwrite @ary
 new fn set fn=311.11 ; file number
 new sfn set sfn=311.11001 ; subfile number for variables
 new fmroot set fmroot=$name(^SAMI(311.11))
 ;
 new SAMIFDA,SAMIERR
 set SAMIFDA(fn,"?+1,",.01)=form
 write !,"creating form ",form
 do UPDATE^DIE("","SAMIFDA","","SAMIERR")
 if $data(SAMIERR) do  quit  ;
 . write !,"error creating form record ",id,!
 . zwrite SAMIERR
 . quit
 ;
 new %ien set %ien=$order(@fmroot@("B",form,""))
 if %ien="" do  quit  ;
 . write !,"error locating form record ",form
 . quit
 ;
 new %j set %j=""
 new vcnt set vcnt=0
 kill SAMIFDA
 for  set %j=$order(@ary@(%j)) quit:%j=""  do  ;
 . set vcnt=vcnt+1
 . set SAMIFDA(sfn,"?+"_vcnt_","_%ien_",",.01)=%j
 . quit
 ;
 do CLEAN^DILF
 write !,"creating variables for form ",%ien
 ;
 do UPDATE^DIE("","SAMIFDA","","SAMIERR")
 if $data(SAMIERR) do  quit  ;
 . write !,"error creating variable record ",%j,!
 . zwrite SAMIERR
 . quit
 ;
 quit  ; end of INIT1FRM
 ;
 ;
 ;
REGFORMS() ; register elcap forms in form mapping file
 ;
 ;@called-by: ???
 ;@calls
 ; UPDATE^DIE
 ;
 new fn set fn=311.11 ; file number
 new sfn set sfn=311.11001 ; subfile number for variables
 new fmroot set fmroot=$name(^SAMI(311.11))
 ;
 ; table of forms
 ;
 new ftbl
 set ftbl("bxform","Biopsy_Mediastinoscopy Form.html")=""
 set ftbl("ceform","CT Evaluation Form.html")=""
 set ftbl("sbform2","Background Form.html")=""
 set ftbl("fuform","Follow-up Form.html")=""
 set ftbl("siform","Intake Form.html")=""
 set ftbl("rbform","Intervention and Treatment Form.html")=""
 set ftbl("ptform","PET Evaluation Form.html")=""
 set ftbl("sintake","Schedule Contact.html")=""
 ;
 new zi set zi=""
 for  set zi=$order(ftbl(zi)) quit:zi=""  do  ;
 . new SAMIFDA,SAMIERR
 . set SAMIFDA(fn,"?+1,",.01)=zi
 . set SAMIFDA(fn,"?+1,",2)=$order(ftbl(zi,""))
 . write !,"creating form ",zi," named: ",$order(ftbl(zi,""))
 . do UPDATE^DIE("","SAMIFDA","","SAMIERR")
 . if $data(SAMIERR) do  quit  ;
 . . write !,"error creating form record ",zi,!
 . . zwrite SAMIERR
 . . quit
 . new %ien set %ien=$order(@fmroot@("B",zi,""))
 . if %ien="" do  quit  ;
 . . write !,"error locating form record ",zi
 . . quit
 . quit
 ;
 quit  ; end of REGFORMS
 ;
 ;
 ;
LOADDATA() ; import directory full of json data into elcap-patient graph
 ;
 ;@called-by: ???
 ;@calls
 ; $$GETDIR
 ; file2ary^%wd
 ; $$setroot^%wd
 ; DECODE^VPRJSON
 ; PRSFLNM
 ;
 new SAMIDIR
 ; Skip interactive if doing unit test VEN/lgc
 if '$data(%ut) do
 . if '$$GETDIR(.SAMIDIR,"/home/osehra/www/sample-data-20171129/") quit  ; user exited
 . quit
 else  set SAMIDIR="/home/osehra/www/sample-data-UnitTest/"
 ;
 new cmd
 set cmd="""ls "_SAMIDIR_" > /home/osehra/www/sample-list.txt"""
 zsystem @cmd
 new SAMILIST
 do file2ary^%wd("SAMILIST","/home/osehra/www/","sample-list.txt")
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new SAMIJSON,SAMIARY,studyid,form,filename
 new zi set zi=""
 ;
 for  set zi=$order(SAMILIST(zi)) quit:zi=""  do  ;
 . set filename=$get(SAMILIST(zi))
 . quit:filename=""
 . if $length(filename,"-")'=5 write !,"file "_filename_" rejected" quit  ;
 . if filename'[".json" write !,"file "_filename_" rejected" quit  ;
 . kill SAMIJSON,SAMIARY
 . do file2ary^%wd("SAMIJSON",SAMIDIR,filename)
 . do DECODE^VPRJSON("SAMIJSON","SAMIARY")
 . do PRSFLNM(filename,.studyid,.form)
 . quit:'$data(SAMIARY)
 . merge @root@("graph",studyid,form)=SAMIARY
 . quit
 ;
 quit  ; end of LOADDATA
 ;
 ;
 ;
PRSFLNM(fn,zid,zform) ; parse filename extracting studyid & form
 ;
 ;             ie XXX0001-bxform-2004-02-01
 ; yields studyid=XXX0001
 ;                 & form=bxform-2004-02-01
 ;
 ;@called-by
 ; LOADDATA
 ;@calls: none
 ;
 set zid=$piece(fn,"-",1)
 new loc set loc=$find(fn,"-")
 set zform=$extract(fn,loc,$length(fn))
 set zform=$piece(zform,".",1)
 ;
 quit  ; end of PRSFLNM
 ;
 ;
 ;
GETDIR(KBAIDIR,KBAIDEF) ; prompt for directory
 ;
 ; returns true if the user gave values
 ;
 ;@called-by
 ; LOADDATA
 ;@calls
 ; ^DIR
 ;
 new DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 set DIR(0)="F^3:240"
 set DIR("A")="File Directory"
 if '$data(KBAIDEF) set KBAIDEF="/home/osehra/www/"
 set DIR("B")=KBAIDEF
 ;
 do ^DIR
 ;
 if Y="^" quit 0 ;
 set KBAIDIR=Y
 ;
 quit 1 ; end of $$GETDIR
 ;
 ;
 ;
GETFN(KBAIFN,KBAIDEF) ; prompt for filename
 ;
 ; returns true if the user gave values
 ;
 ;@called-by: ???
 ;@calls
 ; ^DIR
 ;
 new DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 set DIR(0)="F^3:240"
 set DIR("A")="File Name"
 if '$data(KBAIDEF) set KBAIDEF="outpatient-list.txt"
 set DIR("B")=KBAIDEF
 ;
 do ^DIR
 ;
 if Y="" quit 0 ;
 if Y="^" quit 0 ;
 set KBAIFN=Y
 ;
 quit 1 ; end of $$GETFN
 ;
 ;
 ;
SAMISUB2(SAMILINE,form,sid,filter,%j,zhtml) ; used for Dom's new style forms
 ;
 ; line is passed by reference; filter is passed by reference
 ; can modify any line in the html as needed
 ;
 ;@called-by
 ; wsGetForm^%wf
 ; WSNOTE^SAMINOTI
 ; WSREPORT^SAMIUR1
 ;@calls
 ; $$GETHDR^SAMIFRM2
 ; $$GETLAST5^SAMIFRM2
 ; findReplace^%ts
 ; findReplaceAll^%ts
 ; FIXSRC
 ; FIXHREF
 ;@tests
 ; UTSSUB2^SAMIUTF2: used for Dom's new style forms
 ;
 new touched set touched=0
 ;
 set SAMILINE=SAMILINE_$char(13,10) ; insert CRLF at end of every line
 ; for readability in browser
 ;
 new pssn set pssn=$$GETHDR^SAMIFRM2(sid)
 new last5 set last5=$$GETLAST5^SAMIFRM2(sid)
 new useid set useid=pssn
 if useid="" set useid=last5
 ;
 if SAMILINE["@@FORMKEY@@" do  ;
 . do findReplace^%ts(.SAMILINE,"@@FORMKEY@@",key)
 . quit
 ;
 if SAMILINE["@@SID@@" do  ;
 . do findReplace^%ts(.SAMILINE,"@@SID@@",sid)
 . quit
 ;
 if SAMILINE["src=" do
 . do FIXSRC(.SAMILINE) ; insert see/ processor on src= references
 . quit
 ;
 if SAMILINE["href=" if 'touched do
 . do FIXHREF(.SAMILINE) ; insert see/ processor on href= references
 . quit
 ;
 if SAMILINE["Sample, Sammy G" do  ;
 . do findReplace^%ts(.SAMILINE,"Sample, Sammy G",$get(vals("saminame")))
 . quit
 ;
 if SAMILINE["ST0001" do  ;
 . do findReplace^%ts(.SAMILINE,"ST0001",useid)
 . quit
 ;
 if SAMILINE["1234567890" do  ;
 . do findReplace^%ts(.SAMILINE,"1234567890","")
 . quit
 ;
 if SAMILINE["XX0002" do  ;
 . if SAMILINE["XXX" quit  ;
 . do findReplace^%ts(.SAMILINE,"XX0002",sid)
 . quit
 ;
 if SAMILINE["VEP0001" do  ;
 . do findReplaceAll^%ts(.SAMILINE,"VEP0001",sid)
 . quit
 ;
 if SAMILINE["@@FROZEN@@" do  ;
 . if $get(vals("samistatus"))="complete" do  ;
 . . do findReplace^%ts(.SAMILINE,"@@FROZEN@@","true")
 . . quit
 . else  do  ;
 . . do findReplace^%ts(.SAMILINE,"@@FROZEN@@","false")
 . . quit
 . quit
 ;
 if SAMILINE["@@NEWFORM@@" do  ;
 . if $get(vals("samifirsttime"))="true" do  ;
 . . do findReplace^%ts(.SAMILINE,"@@NEWFORM@@","true")
 . . quit
 . else  do  ;
 . . do findReplace^%ts(.SAMILINE,"@@NEWFORM@@","false")
 . . quit
 . quit
 ;
 if SAMILINE["@@CHART_ELIGIBILITY_NOTE_EXISTS@@" d  ;
 . n zexist
 . s zexist=$$EXISTCE^SAMINOT1(sid,form)
 . do findReplace^%ts(.SAMILINE,"@@CHART_ELIGIBILITY_NOTE_EXISTS@@",zexist)
 ;
 if SAMILINE["@@PRE_ENROLLMENT_NOTE_EXISTS@@" d  ;
 . n zexist
 . s zexist=$$EXISTPRE^SAMINOT1(sid,form)
 . do findReplace^%ts(.SAMILINE,"@@PRE_ENROLLMENT_NOTE_EXISTS@@",zexist)
 ;
 if SAMILINE["@@INTAKE_NOTE_EXISTS@@" d  ;
 . n zexist
 . s zexist=$$EXISTINT^SAMINOT1(sid,form)
 . do findReplace^%ts(.SAMILINE,"@@INTAKE_NOTE_EXISTS@@",zexist)
 ;
 if SAMILINE["changelog" d  ;
 . new root set root=$$setroot^%wd("vapals-patients")
 . new clog set clog=$na(@root@("graph",sid,form,"changelog"))
 . if '$d(@clog) q  ;
 . do findReplace^%ts(.SAMILINE,"</pre>","")
 . new zi set zi=""
 . for  set zi=$order(@clog@(zi)) quit:zi=""  d  ;
 . . new zien set zien=+(%j_"."_zi)
 . . set zhtml(zien)=@clog@(zi)
 . set zhtml(%j_"."_$order(@clog@(""),-1)+1)="</pre>"
 ;
 quit  ; end of SAMISUB2
 ;
 ;
 ;
WSSBFORM(SAMIRTN,SAMIFILTER) ; background form access
 ;
 ;@called-by
 ;@calls
 ; $$GENSTDID^SAMIHOM3
 ; GETITEMS^SAMICASE
 ; wsGetForm^%wf
 ;
 new sid set sid=$get(SAMIFILTER("studyid"))
 if sid="" set sid=$get(SAMIFILTER("sid"))
 if +sid>0 set sid=$$GENSTDID^SAMIHOM3(sid)
 ;if sid="" set sid="XXX0001"
 ;
 new items do GETITEMS^SAMICASE("items",sid)
 ;write !,"sid=",sid,!
 ;zwrite items
 ;break
 ;
 new key set key=$order(items("sbfor"))
 set SAMIFILTER("key")=key
 set SAMIFILTER("form")="vapals:sbform"
 do wsGetForm^%wf(.SAMIRTN,.SAMIFILTER)
 ;
 quit  ; end of WSSBFORM
 ;
 ;
 ;
WSSIFORM(SAMIRTN,SAMIFILTER) ; intake form access
 ;
 ;@called-by
 ;@calls
 ; $$GENSTDID^SAMIHOM3
 ; GETITEMS^SAMICASE
 ; wsGetForm^%wf
 ;
 new sid set sid=$get(SAMIFILTER("studyid"))
 if sid="" set sid=$get(SAMIFILTER("sid"))
 if +sid>0 set sid=$$GENSTDID^SAMIHOM3(sid)
 ;if sid="" set sid="XXX0001"
 ;
 new items do GETITEMS^SAMICASE("items",sid)
 ;write !,"sid=",sid,!
 ;zwrite items
 ;break
 ;
 new key set key=$order(items("sifor"))
 set SAMIFILTER("key")=key
 set SAMIFILTER("form")="vapals:siform"
 do wsGetForm^%wf(.SAMIRTN,.SAMIFILTER)
 ;
 quit  ; end of WSSIFORM
 ;
 ;
 ;
WSCEFORM(SAMIRTN,SAMIFILTER) ; ctevaluation form access
 ;
 ;@called-by
 ;@calls
 ; $$GENSTDID^SAMIHOM3
 ; GETITEMS^SAMICASE
 ; wsGetForm^%wf
 ;
 new sid set sid=$get(SAMIFILTER("studyid"))
 if sid="" set sid=$get(SAMIFILTER("sid"))
 if +sid>0 set sid=$$GENSTDID^SAMIHOM3(sid)
 ;if sid="" set sid="XXX0001"
 ;
 new items do GETITEMS^SAMICASE("items",sid)
 ;write !,"sid=",sid,!
 ;zwrite items
 ;break
 ;
 new key set key=$order(items("cefor"))
 set SAMIFILTER("key")=key
 set SAMIFILTER("form")="vapals:ceform"
 do wsGetForm^%wf(.SAMIRTN,.SAMIFILTER)
 ;
 quit  ; end of WSCEFORM
 ;
 ;
 ;
FIXSRC(SAMILINE) ; fix html src lines to use resources in see/
 ;
 ;@called-by
 ; WSCASE^SAMICASE
 ; SAMISUB2
 ;@calls
 ; findReplaceAll^%ts
 ;
 if SAMILINE["src=" do  ;
 . if SAMILINE["src=""http" quit
 . if SAMILINE["src=""/" do  quit
 . . do findReplaceAll^%ts(.SAMILINE,"src=""/","src=""/see/sami/")
 . . quit
 . if SAMILINE["src=""" do  quit
 . . do findReplaceAll^%ts(.SAMILINE,"src=""","src=""/see/sami/")
 . . quit
 . if SAMILINE["src=" do
 . . do findReplaceAll^%ts(.SAMILINE,"src=","src=/see/sami/")
 . . quit
 . quit
 ;
 quit  ; end of FIXSRC
 ;
 ;
 ;
FIXHREF(SAMILINE) ; fix html href lines to use resources in see/
 ;
 ;@called-by
 ; WSCASE^SAMICASE
 ; SAMISUB2
 ;@calls
 ; findReplaceAll^%ts
 ;
 if SAMILINE["href=" do  ;
 . quit:SAMILINE["href=""#"
 . quit:SAMILINE["href='#"
 . quit:SAMILINE["href=""http"
 . quit:SAMILINE["/vapals"
 . if SAMILINE["href=""/" do  quit
 . . do findReplaceAll^%ts(.SAMILINE,"href=""/","href=""/","href=""/see/sami/")
 . . quit
 . if SAMILINE["href=""" do  quit
 . . do findReplaceAll^%ts(.SAMILINE,"href=""","href=""/see/sami/")
 . . quit
 . if SAMILINE["href=" do  quit
 . . do findReplaceAll^%ts(.SAMILINE,"href=","href=/see/sami/")
 . . quit
 . quit
 ;
 quit  ; end of FIXHREF
 ;
 ;
 ;
GETLAST5(sid) ; extrinsic returns the last5 for patient sid
 ;
 ;@called-by
 ; WSCASE^SAMICASE
 ;@calls
 ; $$setroot^%wd
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 quit @root@(ien,"last5")
 ;
 ;
 ;
GETNAME(sid) ; extrinsic returns the name for patient sid
 ;
 ;@called-by
 ; WSCASE^SAMICASE
 ;@calls
 ; $$setroot^%wd
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 quit @root@(ien,"saminame") ; end of $$GETNAME
 ;
 ;
 ;
GETSSN(sid) ; extrinsic returns the ssn for patient sid
 ;
 ;@called-by
 ; WSCASE^SAMICASE
 ;@calls
 ; $$setroot^%wd
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 new pssn
 set pssn=$get(@root@(ien,"sissn"))
 if pssn["sta" set pssn=""
 if pssn="" do  ;
 . new orgssn
 . set orgssn=$get(@root@(ien,"ssn"))
 . quit:orgssn=""
 . set pssn=$extract(orgssn,1,3)_"-"_$extract(orgssn,4,5)_"-"_$extract(orgssn,6,9)
 . set @root@(ien,"sissn")=pssn
 . quit
 ;
 quit pssn ; end of $$GETSSN
 ;
 ;
 ;
GETHDR(sid) ; extrinsic returns header string for patient sid
 ;
 ;@called-by
 ;@calls
 ; $$setroot^%wd
 ; PREFILL^SAMIHOM3
 ; ^%DT
 ; $$NOW^XLFDT
 ; $$FMDIFF^XLFDT
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 new dfn set dfn=@root@(ien,"dfn")
 quit:ien=""
 ;
 ;do PREFILL^SAMIHOM3(dfn) ;update from VistA
 if $get(@root@(ien,"ssn"))="" do PREFILL^SAMIHOM3(dfn) ;update from VistA
 if $get(@root@(ien,"sbdob"))=-1 do PREFILL^SAMIHOM3(dfn) ;update from VistA
 ;
 if $get(@root@(ien,"ssn"))="" quit "" ; patient info not available
 new pssn,dob,age,sex
 set pssn=$get(@root@(ien,"sissn"))
 if pssn["sta" set pssn=""
 if pssn="" do  ;
 . new orgssn
 . set orgssn=$get(@root@(ien,"ssn"))
 . quit:orgssn=""
 . set pssn=$extract(orgssn,1,3)_"-"_$extract(orgssn,4,5)_"-"_$extract(orgssn,6,9)
 . set @root@(ien,"sissn")=pssn
 . quit
 ;
 set dob=$get(@root@(ien,"sbdob")) ; dob in VAPALS format
 set sex=$get(@root@(ien,"sex"))
 ;
 new X,Y
 set X=dob
 do ^%DT
 set age=$piece($$FMDIFF^XLFDT($$NOW^XLFDT,Y)/365,".")
 set @root@(ien,"age")=age
 ;
 new rtn
 set rtn=pssn_" DOB: "_dob_" AGE: "_age_" GENDER: "_sex
 ;
 quit rtn ; end of $$GETHDR
 ;
 ;
 ;
EOR ; end of routine SAMIFRM2
