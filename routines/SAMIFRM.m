SAMIFRM ;ven/gpl - ielcap: forms ;2018-02-07T20:45Z
 ;;18.0;SAM;;
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
 ;@last-updated: 2018-02-07T20:45Z
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
 ;@contents
 ; INITFRMS: initial all available forms
 ; INITFRM: initialize 1 form from elcap-patient graph (field names only)
 ; REGFORMS: register elcap forms in form mapping file
 ; loadData: import directory full of json data into elcap-patient graph
 ; parseFileName: parse filename extracting studyid and form
 ; $$GETDIR: extrinsic which prompts for directory
 ; $$GETFN: extrinsic which prompts for filename
 ; SAMISUBS: ln is passed by reference; filter is passed by reference
 ; SAMISUB2: used for Dom's new style forms
 ; fixSrc: fix html src lines to use resources in see/
 ; fixHref: fix html href lines to use resources in see/
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
INITFRMS ; initilize form file from elcap-patient graphs
 ;
 new root set root=$$setroot^%wdgraph("elcap-patients")
 quit:root=""
 new groot set groot=$name(@root@("graph"))
 new patient set patient=$order(@groot@(""),-1) ; use last patient in graph
 quit:patient=""
 new form set form=""
 for  set form=$order(@groot@(patient,form)) quit:form=""  do  ; for each form patient has
 . new array
 . do getVals^%wf("array",form,patient) ; get array of fields & values
 . write !,"using patient: ",patient
 . do INIT1FRM(form,"array") ; initialize form & its fields
 ;
 quit  ; end of INITFRMS
 ;
 ;
 ;
INIT1FRM(form,ary) ; initialize one form named form from ary passed by name 
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
REGFORMS() ; register elcap forms in the form mapping file
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
loadData() ; import a directory full of json data into the elcap-patient graph
 ;
 new dir
 if '$$GETDIR(.dir,"/home/osehra/www/sample-data-20171129/") quit  ; user exited
 new cmd
 set cmd="""ls "_dir_" > /home/osehra/www/sample-list.txt"""
 zsystem @cmd
 new zlist
 do file2ary^%wd("zlist","/home/osehra/www/","sample-list.txt")
 ;
 new root set root=$$setroot^%wd("elcap-patients")
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
 . do parseFileName(filename,.studyid,.form)
 . quit:'$data(ary)
 . merge @root@("graph",studyid,form)=ary
 . quit
 ;
 quit  ; end of loadData
 ;
 ;
 ;
parseFileName(fn,zid,zform) ; parse filename extracting studyid & form
 ;
 ;             ie XXX0001-bxform-2004-02-01
 ; yields studyid=XXX0001
 ;                 & form=bxform-2004-02-01
 ;
 set zid=$piece(fn,"-",1)
 new loc set loc=$find(fn,"-")
 set zform=$extract(fn,loc,$length(fn))
 set zform=$piece(zform,".",1)
 ;
 quit  ; end of parseFileName
 ;
 ;
 ;
GETDIR(KBAIDIR,KBAIDEF) ; extrinsic which prompts for directory
 ;
 ; returns true if the user gave values
 ;
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
SAMISUBS(ln,form,sid,filter,%j,zhtml) ; ln is passed by reference; filter is passed by reference
 ;
 ; changes line ln by doing replacements needed for all SAMI forms
 ;
 new dbg set dbg=$get(filter("debug"))
 if dbg'="" set dbg="&debug="_dbg
 new target set target="form?form="_form_"&studyId="_sid_dbg
 if ln["datae.cgi" do replaceAll^%wf(.ln,"/cgi-bin/datac/datae.cgi",target)
 ;
 if form="bxform" do  ; 
 . if ln["mgtsys." set ln="<link type=""text/css"" rel=""stylesheet"" media=""all"" href=""Biopsy_Mediastinoscopy%20Form_files/mgtsys.css"">"
 . if ln["mgtsys-print.css" set ln="<link type=""text/css"" rel=""stylesheet"" media=""print"" href=""Biopsy_Mediastinoscopy%20Form_files/mgtsys-print.css"">"
 . quit
 ;
 if ln["/cgi-bin/datac/cform.cgi" do
 . do replaceAll^%wf(.ln,"/cgi-bin/datac/cform.cgi","cform.cgi?studyid="_sid)
 . do replaceAll^%wf(.ln,"POST","GET")
 . quit
 ;
 if ln["VEP0001" do replaceAll^%wf(.ln,"VEP0001",sid)
 ;
 if ln["home.cgi" do replaceAll^%wf(.ln,"POST","GET")
 ;
 if ln["/css/" do replaceAll^%wf(.ln,"/css/","see/")
 if ln["/js/" do replaceAll^%wf(.ln,"/js/","see/")
 if ln["/images/" do replaceAll^%wf(.ln,"/images/","see/")
 ;
 quit  ; end of SAMISUBS
 ;
 ;
 ;
SAMISUB2(ln,form,sid,filter,%j,zhtml) ; used for Dom's new style forms
 ;
 ; ln is passed by reference; filter is passed by reference
 ; can modify any line in the html as needed
 ;
 ; the following didn't work so is commented out.
 ; fix to handle javascript separately
 ; caution: the following might modify %j to skip over javascript
 ;
 ; if ln["<script" do  ;
 ; . if ln["</script" quit  ;
 ; . new zi set zi=%j
 ; . new max set max=$order(zhtml(" "),-1)
 ; . for zi=%j,1,max quit:zhtml(zi)["</script"  do  ;
 ; . . set ln=zhtml(zi)
 ; . . if ln["src=" do fixSrc(.ln)
 ; . . if ln["href=" do fixHref(.ln) 
 ; . . set ln=ln_$char(13,10)
 ; . . set zhtml(zi)=ln
 ; . . quit
 ; . set %j=zi+1
 ; . set ln=zhtml(%j)
 ; . quit
 ;
 set ln=ln_$char(13,10) ; insert CRLF at end of every line
 ; for readability in browser
 ;
 if ln["src=" do fixSrc(.ln) ; insert see/ processor on src= references
 if ln["href=" do fixHref(.ln) ; insert see/ processor on href= references
 ;
 quit  ; end of SAMISUB2
 ;
 ;
 ;
fixSrc(ln) ; fix html src lines to use resources in see/
 ;
 if ln["src=" do  ;
 . if ln["src=""/" do replaceAll^%wf(.ln,"src=""/","src=""see/") quit  ;
 . if ln["src=""" do replaceAll^%wf(.ln,"src=""","src=""see/") quit  ;
 . if ln["src=" do replaceAll^%wf(.ln,"src=","src=see/")
 . quit
 ;
 quit  ; end of fixSrc
 ;
 ;
 ;
fixHref(ln) ; fix html href lines to use resources in see/
 ;
 if ln["href=" do  ;
 . if ln["href=""#" quit  ;
 . if ln["href='#" quit  ;
 . if ln["href=""/" do replaceAll^%wf(.ln,"href=""/","href=""/","href=""see/") quit  ;
 . if ln["href=""" do replaceAll^%wf(.ln,"href=""","href=""see/") quit  ;
 . if ln["href=" do replaceAll^%wf(.ln,"href=","href=see/") quit  ;
 . quit
 ;
 quit  ; end of fixHref
 ;
 ;
 ;
EOR ; end of routine SAMIFRM
