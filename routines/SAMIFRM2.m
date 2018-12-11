SAMIFRM2 ;ven/gpl - ielcap: forms ; 12/11/18 9:21am
 ;;18.0;SAM;;
 ;
 ; Routine SAMIFRM contains subroutines for managing the ELCAP forms,
 ; including initialization and enhancements to the SAMI FORM FILE (311.11)
 ; CURRENTLY UNTESTED & IN PROGRESS
 ;
 ; CHANGE VEN/2018-11-13
 ;  every occurance of SAMIHOM2 changed to SAMIHOM3
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
 ;@last-updated: 2018-03-18T17:15Z
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
 ;@contents
 ; INITFRMS: initial all available forms
 ; INIT1FRM: initialize 1 form from elcap-patient graph (field names only)
 ; REGFORMS: register elcap forms in form mapping file
 ; LOADDATA: import directory full of json data into elcap-patient graph
 ; PRSFLNM: parse filename extracting studyid and form
 ; $$GETDIR: extrinsic which prompts for directory
 ; $$GETFN: extrinsic which prompts for filename
 ; SAMISUBS: ln is passed by reference; filter is passed by reference
 ; SAMISUB2: used for Dom's new style forms
 ; FIXSRC: fix html src lines to use resources in see/
 ; FIXHREF: fix html href lines to use resources in see/
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
 new form set form=""
 ; for each form patient has:
 for  set form=$order(@groot@(patient,form)) quit:form=""  do
 . new array
 . do getVals^%wf("array",form,patient) ; get array of fields & values
 . write !,"using patient: ",patient
 . do INIT1FRM(form,"array") ; initialize form & its fields
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
 new fda,%yerr
 set fda(fn,"?+1,",.01)=form
 write !,"creating form ",form
 do UPDATE^DIE("","fda","","%yerr")
 if $data(%yerr) do  quit  ;
 . write !,"error creating form record ",id,!
 . zwrite %yerr
 . quit
 new %ien set %ien=$order(@fmroot@("B",form,""))
 if %ien="" do  quit  ;
 . write !,"error locating form record ",form
 . quit
 new %j set %j=""
 new vcnt set vcnt=0
 kill fda
 for  set %j=$order(@ary@(%j)) quit:%j=""  do  ;
 . set vcnt=vcnt+1
 . set fda(sfn,"?+"_vcnt_","_%ien_",",.01)=%j
 . quit
 do CLEAN^DILF
 write !,"creating variables for form ",%ien
 do UPDATE^DIE("","fda","","%yerr")
 if $data(%yerr) do  quit  ;
 . write !,"error creating variable record ",%j,!
 . zwrite %yerr
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
 . new fda,%yerr
 . set fda(fn,"?+1,",.01)=zi
 . set fda(fn,"?+1,",2)=$order(ftbl(zi,""))
 . write !,"creating form ",zi," named: ",$order(ftbl(zi,""))
 . do UPDATE^DIE("","fda","","%yerr")
 . if $data(%yerr) do  quit  ;
 . . write !,"error creating form record ",zi,!
 . . zwrite %yerr
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
 new dir
 ; Skip interactive if doing unit test VEN/lgc
 I '$D(%ut) D
 . if '$$GETDIR(.dir,"/home/osehra/www/sample-data-20171129/") quit  ; user exited
 E  S dir="/home/osehra/www/sample-data-UnitTest/"
 ;
 new cmd
 set cmd="""ls "_dir_" > /home/osehra/www/sample-list.txt"""
 zsystem @cmd
 new zlist
 do file2ary^%wd("zlist","/home/osehra/www/","sample-list.txt")
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new json,ary,studyid,form,filename
 new zi set zi=""
 ;
 for  set zi=$order(zlist(zi)) quit:zi=""  do  ;
 . set filename=$get(zlist(zi))
 . quit:filename=""
 . if $length(filename,"-")'=5 write !,"file "_filename_" rejected" quit  ;
 . if filename'[".json" write !,"file "_filename_" rejected" quit  ;
 . kill json,ary
 . do file2ary^%wd("json",dir,filename)
 . do DECODE^VPRJSON("json","ary")
 . do PRSFLNM(filename,.studyid,.form)
 . quit:'$data(ary)
 . merge @root@("graph",studyid,form)=ary
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
GETDIR(KBAIDIR,KBAIDEF) ; extrinsic which prompts for directory
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
 do ^DIR
 if Y="^" quit 0 ;
 set KBAIDIR=Y
 ;
 quit 1 ; end of $$GETDIR
 ;
 ;
 ;
GETFN(KBAIFN,KBAIDEF) ; extrinsic which prompts for filename
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
 do ^DIR
 if Y="" quit 0 ;
 if Y="^" quit 0 ;
 set KBAIFN=Y
 ;
 quit 1 ; end of $$GETFN
 ;
 ;
 ;
 ;
SAMISUB2(line,form,sid,filter,%j,zhtml) ; used for Dom's new style forms
 ;
 ; line is passed by reference; filter is passed by reference
 ; can modify any line in the html as needed
 ;
 ;@called-by
 ; wsGetForm^%wf
 ;@calls
 ; FIXSRC
 ; FIXHREF
 ;
 ;
 new touched s touched=0
 ;
 set line=line_$char(13,10) ; insert CRLF at end of every line
 ; for readability in browser
 ;
 n pssn s pssn=$$GETHDR^SAMIFRM2(sid)
 n last5 s last5=$$GETLAST5^SAMIFRM2(sid)
 n useid s useid=pssn
 i useid="" s useid=last5
 ;
 if line["@@FORMKEY@@" do  ;
 . do findReplace^%ts(.line,"@@FORMKEY@@",key)
 . quit
 ;
 if line["@@SID@@" do  ;
 . do findReplace^%ts(.line,"@@SID@@",sid)
 . quit
 ;
 if line["src=" do
 . do FIXSRC(.line) ; insert see/ processor on src= references
 . quit
 ;
 if line["href=" if 'touched do
 . do FIXHREF(.line) ; insert see/ processor on href= references
 . quit
 ;
 if line["Sample, Sammy G" do  ;
 . do findReplace^%ts(.line,"Sample, Sammy G",$g(vals("saminame")))
 ;
 if line["ST0001" do  ;
 . do findReplace^%ts(.line,"ST0001",useid)
 ;
 if line["1234567890" do  ;
 . do findReplace^%ts(.line,"1234567890","")
 ;
 if line["XX0002" do  ;
 . i line["XXX" quit  ;
 . do findReplace^%ts(.line,"XX0002",sid)
 ;
 if line["VEP0001" do  ;
 . do findReplace^%ts(.line,"VEP0001",sid,"a")
 ;
 if line["@@FROZEN@@" do  ;
 . if $g(vals("samistatus"))="complete" d  ;
 . . d findReplace^%ts(.line,"@@FROZEN@@","true")
 . e  d  ;
 . . d findReplace^%ts(.line,"@@FROZEN@@","false")
 ;
 if line["@@NEWFORM@@" do  ;
 . if $g(vals("samifirsttime"))="true" d  ;
 . . d findReplace^%ts(.line,"@@NEWFORM@@","true")
 . e  d  ;
 . . d findReplace^%ts(.line,"@@NEWFORM@@","false")
 ;
 quit  ; end of SAMISUB2
 ;
WSSBFORM(rtn,filter) ; background form access
 n sid s sid=$g(filter("studyid"))
 i sid="" s sid=$g(filter("sid"))
 i +sid>0 s sid=$$GENSTDID^SAMIHOM3(sid)
 ;i sid="" s sid="XXX0001"
 n items d GETITEMS^SAMICAS2("items",sid)
 ;w !,"sid=",sid,!
 ;zwr items
 ;b
 n key s key=$o(items("sbfor"))
 s filter("key")=key
 s filter("form")="vapals:sbform"
 d wsGetForm^%wf(.rtn,.filter)
 q
 ;
WSSIFORM(rtn,filter) ; intake form access
 n sid s sid=$g(filter("studyid"))
 i sid="" s sid=$g(filter("sid"))
 i +sid>0 s sid=$$GENSTDID^SAMIHOM3(sid)
 ;i sid="" s sid="XXX0001"
 n items d GETITEMS^SAMICAS2("items",sid)
 ;w !,"sid=",sid,!
 ;zwr items
 ;b
 n key s key=$o(items("sifor"))
 s filter("key")=key
 s filter("form")="vapals:siform"
 d wsGetForm^%wf(.rtn,.filter)
 q
 ;
WSCEFORM(rtn,filter) ; ctevaluation form access
 n sid s sid=$g(filter("studyid"))
 i sid="" s sid=$g(filter("sid"))
 i +sid>0 s sid=$$GENSTDID^SAMIHOM3(sid)
 ;i sid="" s sid="XXX0001"
 n items d GETITEMS^SAMICAS2("items",sid)
 ;w !,"sid=",sid,!
 ;zwr items
 ;b
 n key s key=$o(items("cefor"))
 s filter("key")=key
 s filter("form")="vapals:ceform"
 d wsGetForm^%wf(.rtn,.filter)
 q
 ;
 ;
FIXSRC(line) ; fix html src lines to use resources in see/
 ;
 ;@called-by
 ; SAMISUB2
 ;@calls
 ; findReplaceAll^%ts
 ;
 if line["src=" do  ;
 . if line["src=""http" quit
 . if line["src=""/" do  quit
 . . do findReplaceAll^%ts(.line,"src=""/","src=""/see/sami/")
 . . quit
 . if line["src=""" do  quit
 . . do findReplaceAll^%ts(.line,"src=""","src=""/see/sami/")
 . . quit
 . if line["src=" do
 . . do findReplaceAll^%ts(.line,"src=","src=/see/sami/")
 . . quit
 . quit
 ;
 quit  ; end of FIXSRC
 ;
 ;
 ;
FIXHREF(line) ; fix html href lines to use resources in see/
 ;
 ;@called-by
 ; SAMISUB2
 ;@calls
 ; findReplaceAll^%ts
 ;
 if line["href=" do  ;
 . quit:line["href=""#"
 . quit:line["href='#"
 . quit:line["href=""http"
 . quit:line["/vapals"
 . if line["href=""/" do  quit
 . . do findReplaceAll^%ts(.line,"href=""/","href=""/","href=""/see/sami/")
 . . quit
 . if line["href=""" do  quit
 . . do findReplaceAll^%ts(.line,"href=""","href=""/see/sami/")
 . . quit
 . if line["href=" do  quit
 . . do findReplaceAll^%ts(.line,"href=","href=/see/sami/")
 . . quit
 . quit
 ;
 quit  ; end of FIXHREF
 ;
 ;
GETLAST5(sid) ; extrinsic returns the last5 for patient sid
 q:$g(sid)="" ""
 n root s root=$$setroot^%wd("vapals-patients")
 n ien s ien=$o(@root@("sid",sid,""))
 q:ien=""
 q @root@(ien,"last5")
 ;
GETNAME(sid) ; extrinsic returns the name for patient sid
 q:$g(sid)="" ""
 n root s root=$$setroot^%wd("vapals-patients")
 n ien s ien=$o(@root@("sid",sid,""))
 q:ien=""
 q @root@(ien,"saminame")
 ;
GETSSN(sid) ; extrinsic returns the ssn for patient sid
 q:$g(sid)="" ""
 n root s root=$$setroot^%wd("vapals-patients")
 n ien s ien=$o(@root@("sid",sid,""))
 q:ien=""
 n pssn
 s pssn=$g(@root@(ien,"sissn"))
 i pssn["sta" s pssn=""
 i pssn="" d  ;
 . n orgssn
 . s orgssn=$g(@root@(ien,"ssn"))
 . q:orgssn=""
 . s pssn=$e(orgssn,1,3)_"-"_$e(orgssn,4,5)_"-"_$e(orgssn,6,9)
 . s @root@(ien,"sissn")=pssn
 q pssn
 ;
GETHDR(sid) ; extrinsic returns header string for patient sid
 q:$g(sid)="" ""
 n root s root=$$setroot^%wd("vapals-patients")
 n ien s ien=$o(@root@("sid",sid,""))
 n dfn s dfn=@root@(ien,"dfn")
 q:ien=""
 ;d PREFILL^SAMIHOM3(dfn) ;update from VistA
 i $g(@root@(ien,"ssn"))="" d PREFILL^SAMIHOM3(dfn) ;update from VistA
 i $g(@root@(ien,"sbdob"))=-1 d PREFILL^SAMIHOM3(dfn) ;update from VistA
 i $g(@root@(ien,"ssn"))="" q "" ; patient info not available
 n pssn,dob,age,sex
 s pssn=$g(@root@(ien,"sissn"))
 i pssn["sta" s pssn=""
 i pssn="" d  ;
 . n orgssn
 . s orgssn=$g(@root@(ien,"ssn"))
 . q:orgssn=""
 . s pssn=$e(orgssn,1,3)_"-"_$e(orgssn,4,5)_"-"_$e(orgssn,6,9)
 . s @root@(ien,"sissn")=pssn
 s dob=$g(@root@(ien,"sbdob")) ; dob in VAPALS format
 s sex=$g(@root@(ien,"sex"))
 N X,Y
 S X=dob
 D ^%DT
 s age=$p($$FMDIFF^XLFDT($$NOW^XLFDT,Y)/365,".")
 s @root@(ien,"age")=age
 n rtn
 s rtn=pssn_" DOB: "_dob_" AGE: "_age_" GENDER: "_sex
 q rtn
 ;
EOR ; end of routine SAMIFRM2
