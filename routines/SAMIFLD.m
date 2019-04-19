SAMIFLD ;ven/gpl - elcap: form load & case review support ; 4/15/19 2:22pm
 ;;18.0;SAMI;;
 ;
 ; Routine SAMIFLD contains subroutines for processing the ELCAP forms,
 ; specifically loading JSON data into the graphstore for each line.
 ; Since three of those subroutines are also code for ppis called by
 ; WSCASE^SAMICASE, two additional subroutines are included that are not
 ; part of the LOAD opus but are called by WSCASE^SAMICASE.
 ; SAMIFLD contains no public entry points (see SAMIFORM).
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
 ;@copyright: 2017/2019, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2019-01-08T20:59Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - VAPALS-ELCAP (SAMI)
 ;@version: 18.0T04 (fourth development version)
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev: Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;
 ;@module-credits [see SAMIFUL]
 ;
 ;@contents
 ; LOAD: code for ppi LOAD^SAMIFORM
 ;  used for Dom's new style forms
 ;
 ; $$GETHDR = header string for patient sid
 ;
 ; GETLAST5 = code for ppi $$GETLAST5^SAMIFORM
 ;  last5 for patient sid
 ; FIXSRC: code for ppi FIXSRC^SAMIFORM
 ;  fix html src lines to use resources in see/
 ; FIXHREF: code for ppi FIXHREF^SAMIFORM
 ;  fix html href lines to use resources in see/
 ;
 ; GETNAME = code for ppi $$GETNAME^SAMIFORM
 ;  name for patient sid
 ; GETSSN = code for ppi $$GETSSN^SAMIFORM
 ;  ssn for patient sid
 ;
 ;
 ;
 ;@section 1 code for ppi LOAD^SAMIFRM
 ;
 ;
 ;
 ;@ppi-code LOAD^SAMIFORM
LOAD ; process html line, e.g., load json data into graph
 ;
 ;@signature
 ; do LOAD^SAMIFORM(.SAMILINE,form,sid,.SAMIFILTER,.SAMILNUM,.SAMIHTML,.SAMIVALS)
 ;@branches-from
 ; LOAD^SAMIFORM
 ;@ppi-called-by
 ; wsGetForm^%wf
 ; WSNOTE^SAMINOTI
 ; WSREPORT^SAMIUR1
 ;@called-by: none
 ;@calls
 ; $$GETHDR
 ; $$GETLAST5^SAMIFORM
 ; findReplace^%ts
 ; findReplaceAll^%ts
 ; FIXSRC^SAMIFORM
 ; FIXHREF^SAMIFORM
 ;@thruput
 ;.SAMILINE = line of html
 ; SAMILINE("low") = lowercase line for easier checks
 ;.SAMIFILTER = work-parameters array
 ; SAMIFILTER("debug") = 1 to debug some fields, 2 to debug more fields
 ; SAMIFILTER("errormessagestyle") = 2 (default) = use current error msg style
 ; SAMIFILTER("form") = form id (e.g., "vapals:sbform")
 ; SAMIFILTER("key") = graph key for saved form (e.g., "ceform-2019-07-01")
 ; SAMIFILTER("studyid") = patient study id (e.g., "XXX00045")
 ; SAMIFILTER("fvalue") = deprecated
 ;.SAMILNUM = html line #, in case need to reset cursor to skip lines
 ;.SAMIHTML = complete html form, in case other lines need changing
 ;@input
 ; form = form id
 ; sid = patient study id
 ;.SAMIVALS = field values
 ; SAMIVALS("saminame")
 ; SAMIVALS("samistatus")
 ; SAMIVALS("samifirsttime")
 ;@tests
 ; UTSSUB2^SAMIUTF2: used for Dom's new style forms
 ;
 ; This line processor/data loader can modify any line in the html as needed.
 ;
 new touched set touched=0
 ;
 set SAMILINE=SAMILINE_$char(13,10) ; insert CRLF at end of every line
 ; for readability in browser
 ;
 new pssn set pssn=$$GETHDR(sid)
 new last5 set last5=$$GETLAST5^SAMIFORM(sid)
 new useid set useid=pssn
 if useid="" set useid=last5
 ;
 if SAMILINE["@@FORMKEY@@" do  ; insert form id (graph key for new forms)
 . do findReplace^%ts(.SAMILINE,"@@FORMKEY@@",form) ; key -> form, test me
 . quit
 ;
 if SAMILINE["@@SID@@" do  ; insert patient study id
 . do findReplace^%ts(.SAMILINE,"@@SID@@",sid)
 . quit
 ;
 if SAMILINE["src=" do  ; repoint src directory references
 . do FIXSRC^SAMIFORM(.SAMILINE) ; insert see/ processor on src= references
 . quit
 ;
 if SAMILINE["href=" if 'touched do  ; repoint href directory references
 . do FIXHREF^SAMIFORM(.SAMILINE) ; insert see/ processor on href= references
 . quit
 ;
 if SAMILINE["Sample, Sammy G" do  ; insert actual patient name
 . ;do findReplace^%ts(.SAMILINE,"Sample, Sammy G",$get(SAMIVALS("saminame")))
 . do findReplace^%ts(.SAMILINE,"Sample, Sammy G",$$GETNAME^SAMIFORM(sid))
 . quit
 ;
 if SAMILINE["ST0001" do  ; insert patient ssn or last 5
 . do findReplace^%ts(.SAMILINE,"ST0001",useid)
 . quit
 ;
 if SAMILINE["1234567890" do  ; cut patient id placeholder
 . do findReplace^%ts(.SAMILINE,"1234567890","")
 . quit
 ;
 if SAMILINE["XX0002" do  ; insert patient study id
 . if SAMILINE["XXX" quit  ;
 . do findReplace^%ts(.SAMILINE,"XX0002",sid)
 . quit
 ;
 if SAMILINE["VEP0001" do  ; insert patient study id
 . do findReplaceAll^%ts(.SAMILINE,"VEP0001",sid)
 . quit
 ;
 if SAMILINE["@@FROZEN@@" do  ; insert whether form is frozen
 . if $get(SAMIVALS("samistatus"))="complete" do  ;
 . . do findReplace^%ts(.SAMILINE,"@@FROZEN@@","true")
 . . quit
 . else  do  ;
 . . do findReplace^%ts(.SAMILINE,"@@FROZEN@@","false")
 . . quit
 . quit
 ;
 if SAMILINE["@@NEWFORM@@" do  ; insert whether first edit of form
 . if $get(SAMIVALS("samifirsttime"))="true" do  ;
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
 quit  ; end of ppi LOAD^SAMIFORM
 ;
 ;
 ;
GETHDR(sid) ; header string for patient sid
 ;
 ;@signature
 ; $$GETHDR^SAMIFORM(sid)
 ;@called-by
 ; LOAD
 ;@calls
 ; $$setroot^%wd
 ; PREFILL^SAMIHOM3
 ; ^%DT
 ; $$NOW^XLFDT
 ; $$FMDIFF^XLFDT
 ;@input
 ; sid = patient study id
 ;@output = header string (patient id dob age gender)
 ;@tests
 ; UTGETHDR^SAMIUTF2: header string for patient sid
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 new dfn set dfn=@root@(ien,"dfn")
 quit:ien=""
 ;
 ; do PREFILL^SAMIHOM3(dfn) ; update from Vista
 if $get(@root@(ien,"ssn"))="" do PREFILL^SAMIHOM3(dfn) ; update from Vista
 if $get(@root@(ien,"sbdob"))=-1 do PREFILL^SAMIHOM3(dfn) ; update from Vista
 ;
 if $get(@root@(ien,"ssn"))="" quit "" ; patient info not available
 new pssn set pssn=$get(@root@(ien,"sissn"))
 if pssn["sta" set pssn=""
 if pssn="" do  ;
 . new orgssn
 . set orgssn=$get(@root@(ien,"ssn"))
 . quit:orgssn=""
 . set pssn=$extract(orgssn,1,3)_"-"_$extract(orgssn,4,5)_"-"_$extract(orgssn,6,9)
 . set @root@(ien,"sissn")=pssn
 . quit
 ;
 new dob set dob=$get(@root@(ien,"sbdob")) ; dob in VAPALS format
 new X set X=dob
 new Y
 do ^%DT
 new age set age=$piece($$FMDIFF^XLFDT($$NOW^XLFDT,Y)/365,".")
 set @root@(ien,"age")=age
 ;
 new sex set sex=$get(@root@(ien,"sex"))
 ;
 new rtn set rtn=pssn_" DOB: "_dob_" AGE: "_age_" GENDER: "_sex
 ;
 quit rtn ; end of $$GETHDR
 ;
 ;
 ;
 ;@section 2 code for ppis $$GETLAST5^SAMIFORM,FIXSRC^SAMIFORM,FIXHREF^SAMIFORM
 ;
 ;
 ;
 ;@ppi-code $$GETLAST5^SAMIFORM
GETLAST5 ; last5 for patient sid
 ;
 ;@signature
 ; $$GETHDR^SAMIFORM(sid)
 ;@branches-from
 ; GETLAST5^SAMIFORM
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ; LOAD
 ;@called-by: none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient study id
 ;@output = patient's BS5 (first initial of last name, last 4 of ssn)
 ;@tests
 ; UTGLST5^SAMIUTF2: last5 for patient sid
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 quit @root@(ien,"last5") ; end of ppi $$GETLAST5^SAMIFORM
 ;
 ;
 ;
 ;@ppi-code FIXSRC^SAMIFORM
FIXSRC ; fix html src lines to use resources in see/
 ;
 ;@signature
 ; do FIXSRC^SAMIFORM(.SAMILINE)
 ;@branches-from
 ; FIXSRC^SAMIFORM
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ; LOAD
 ;@called-by: none
 ;@calls
 ; findReplaceAll^%ts
 ;@thruput
 ;.SAMILINE = line of html to change
 ;@tests
 ; UTFSRC^SAMIUTF2: fix html src lines to use resources in see/
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
 quit  ; end of ppi FIXSRC^SAMIFORM
 ;
 ;
 ;
 ;@ppi-code FIXHREF^SAMIFORM
FIXHREF ; fix html href lines to use resources in see/
 ;
 ;@signature
 ; do FIXHREF^SAMIFORM(.SAMILINE)
 ;@branches-from
 ; FIXHREF^SAMIFORM
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ; LOAD
 ;@called-by: none
 ;@calls
 ; findReplaceAll^%ts
 ;@thruput
 ;.SAMILINE = line of html to change
 ;@tests
 ; UTFHREF^SAMIUTF2: fix html href lines to use resources in see/
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
 quit  ; end of ppi FIXHREF^SAMIFORM
 ;
 ;
 ;
 ;@section 3 code for ppis $$GETNAME^SAMIFORM,$$GETSSN^SAMIFORM
 ;
 ;
 ;
 ;@ppi-code $$GETNAME^SAMIFORM
GETNAME ; name for patient sid
 ;
 ;@signature
 ; $$GETNAME^SAMIFORM(sid)
 ;@branches-from
 ; GETNAME^SAMIFORM
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ;@called-by: none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient study id
 ;@output = patient's name
 ;@tests
 ; UTGTNM^SAMIUTF2: name for patient sid
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 quit @root@(ien,"saminame") ; end of ppi $$GETNAME^SAMIFORM
 ;
 ;
 ;
 ;@ppi-code $$GETSSN^SAMIFORM
GETSSN ; ssn for patient sid
 ;
 ;@signature
 ; $$GETSSN^SAMIFORM(sid)
 ;@branches-from
 ; GETSSN^SAMIFORM
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ;@called-by: none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient study id
 ;@output = patient's ssn
 ;@tests
 ; UTGSSN^SAMIUTF2: ssn for patient sid
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 new pssn set pssn=$get(@root@(ien,"sissn"))
 if pssn["sta" set pssn=""
 if pssn="" do  ;
 . new orgssn set orgssn=$get(@root@(ien,"ssn"))
 . quit:orgssn=""
 . set pssn=$extract(orgssn,1,3)_"-"_$extract(orgssn,4,5)_"-"_$extract(orgssn,6,9)
 . set @root@(ien,"sissn")=pssn
 . quit
 ;
 quit pssn ; end of $$GETSSN^SAMIFORM
 ;
 ;
 ;
EOR ; end of routine SAMIFLD
