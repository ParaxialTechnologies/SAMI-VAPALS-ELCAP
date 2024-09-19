SAMIFLD ;ven/gpl - form load & case review; 2024-08-22t21:09z
 ;;18.0;SAMI;**10,17**;2020-01-17;Build 8
 ;mdc-e1;SAMIFLD-20240822-Ewpo+;SAMI-18-17-b9
 ;mdc-v7;B288543997;SAMI*18.0*17 SEQ #17
 ;
 ; SAMIFLD contains subroutines for processing ScreeningPlus forms,
 ; loading JSON data into the graphstore for each line. Since three of
 ; those subroutines are also code for ppses called by
 ; WSCASE^SAMICASE, two additional subroutines are included that are
 ; not part of the LOAD opus but are called by WSCASE^SAMICASE.
 ; SAMIFLD contains no public entry points (see SAMIFORM).
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;
 ;@routine-credits
 ;
 ;@dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2024, gpl, all rights reserved
 ;@license Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@update 2024-08-22t21:09z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module Forms - SAMIF
 ;@release 18-17
 ;@edition-date 2020-01-21
 ;@patches **10,17**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;@dev-add Alexis Carlson (arc)
 ; alexis.carlson@vistaexpertise.net
 ;@dev-add Domenic DiNatale (dom)
 ; domenic.dinatale@paraxialtech.com
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@module-credits see SAMIFUL
 ;
 ;@contents
 ;
 ;  1. code for ppses LOAD^SAMIFRM & $$GETHDR^SAMIFLD
 ; LOAD code for pps LOAD^SAMIFORM
 ;  process html line, e.g., load json data into graph
 ; $$XPAND expand # to 8 digits
 ; $$GETHDR pps GETHDR^SAMIFLD
 ;  header string for patient sid
 ; $$GETMRN get MRN, which supercedes ssn as patient id
 ;
 ;  2. code for ppses $$GETLAST5^SAMIFORM, FIXSRC^SAMIFORM, and
 ;     FIXHREF^SAMIFORM
 ; GETLAST5 code for pps $$GETLAST5^SAMIFORM
 ;  last5 for patient sid
 ; FIXSRC code for pps FIXSRC^SAMIFORM
 ;  fix html src lines to use resources in see/
 ; FIXHREF code for pps FIXHREF^SAMIFORM
 ;  fix html href lines to use resources in see/
 ;
 ;  3 code for ppses $$GETNAME^SAMIFORM, $$GETSSN^SAMIFORM, and
 ;    $$GETPRFX^SAMIFORM
 ; GETNAME code for pps $$GETNAME^SAMIFORM
 ;  name for patient sid
 ; GETSSN code for pps $$GETSSN^SAMIFORM
 ;  ssn for patient sid
 ; GETPRFX code for pps $$GETPRFX^SAMIFORM [deprecated]
 ;  retrieve study id prefix from parameter file
 ;
 ;
 ;
 ;
 ;@section 1 code for ppses LOAD^SAMIFRM & $$GETHDR^SAMIFLD
 ;
 ;
 ;
 ;
 ;@pps-code LOAD^SAMIFORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;procedure;clean?;silent;sac?;tests?;port?
 ;@signature
 ; do LOAD^SAMIFORM(.SAMILINE,form,sid,.SAMIFILTER,.SAMILNUM,.SAMIHTML,.SAMIVALS)
 ;@branches-from
 ; LOAD^SAMIFORM
 ;@pps-called-by
 ; wsGetForm^%wf
 ; WSNOTE^SAMINOT1
 ; WSNOTE^SAMINOT2
 ; WSNOTE^SAMINOT3
 ; WSNOTE^SAMINOTI
 ; SUPER^SAMISITE
 ; WSREPORT^SAMIUR
 ; WSREPORT^SAMIUR1
 ;@called-by none
 ;@calls
 ; $$GETHDR^SAMIFLD
 ; $$setroot^%wd
 ; $$GETLAST5^SAMIFORM
 ; findReplace^%ts
 ; $$GET^XPAR
 ; FIXSRC^SAMIFORM
 ; FIXHREF^SAMIFORM
 ; $$GETNAME^SAMIFORM
 ; findReplaceAll^%ts
 ; $$EXISTCE^SAMINOT1
 ; $$EXISTPRE^SAMINOT1
 ; $$EXISTINT^SAMINOT1
 ; $$XPAND
 ; $$SHDET^SAMIUR2
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
 ; UTLOAD^SAMIUTF used for Dom's new style forms
 ;
 ; This line processor/data loader can modify any line in the html as needed.
 ;
 ;
LOAD ; process html line, e.g., load json data into graph
 ;
 new touched set touched=0
 ;
 set SAMILINE=SAMILINE_$char(13,10) ; insert CRLF at end of every line
 ; for readability in browser
 ;
 new pssn set pssn=$$GETHDR(sid)
 i pssn=""  d  ; for participants without a sid - ie not registered
 . n dfn,lien
 . s dfn=$g(SAMIFILTER("dfn")) ; if no sid, maybe a dfn
 . q:dfn=""
 . n lroot s lroot=$$setroot^%wd("patient-lookup") ; 
 . s lien=$o(@lroot@("dfn",dfn,""))
 . q:lien=""
 . n ssn s ssn=$g(@lroot@(lien,"ssn"))
 . q:ssn=""
 . s pssn=$e(ssn,1,3)_"-"_$e(ssn,4,5)_"-"_$e(ssn,6,9)
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
 if SAMILINE["@@SITE@@" do  ; insert site id
 . n siteid s siteid=$g(SAMIVALS("siteid"))
 . i siteid="" s siteid=$g(SAMIFILTER("siteid"))
 . q:siteid=""
 . do findReplace^%ts(.SAMILINE,"@@SITE@@",siteid)
 . quit
 ;
 if SAMILINE["@@SITETITLE@@" do  ; insert site title
 . n sitetit s sitetit=$g(SAMIVALS("sitetitle"))
 . i sitetit="" s sitetit=$g(SAMIFILTER("sitetitle"))
 . q:sitetit=""
 . do findReplace^%ts(.SAMILINE,"@@SITETITLE@@",sitetit)
 . quit
 ;
 if SAMILINE["@@MANUALREGISTRATION@@" do  ; turn off manual registration
 . n setman,setparm
 . s setman="true"
 . s setparm=$$GET^XPAR("SYS","SAMI ALLOW MANUAL ENTRY",,"Q")
 . i setparm=0 s setman="false"
 . do findReplace^%ts(.SAMILINE,"@@MANUALREGISTRATION@@",setman)
 ; 
 if SAMILINE["@@DFN@@" do  ; insert patient study id
 . n dfn s dfn=$g(SAMIVALS("dfn"))
 . q:dfn=""
 . do findReplace^%ts(.SAMILINE,"@@DFN@@",dfn)
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
 . . new zien set zien=SAMILNUM_"."_$$XPAND(zi)
 . . set zhtml(zien)=@clog@(zi)
 . set zhtml(SAMILNUM_"."_$$XPAND($order(@clog@(""),-1)+1))="</pre>"
 ;
 if SAMILINE["commlog" d  ;
 . new root set root=$$setroot^%wd("vapals-patients")
 . new clog set clog=$na(@root@("graph",sid,form,"comlog"))
 . if '$d(@clog) q  ;
 . do findReplace^%ts(.SAMILINE,"</pre>","")
 . new zi set zi=""
 . for  set zi=$order(@clog@(zi)) quit:zi=""  d  ;
 . . new zien set zien=SAMILNUM_"."_$$XPAND(zi)
 . . set zhtml(zien)=@clog@(zi)
 . set zhtml(SAMILNUM_"."_$$XPAND($order(@clog@(""),-1)+1))="</pre>"
 ;
 ;if form["fuform" d  ;
 i SAMILINE["pack-years-history" d  ;
 . d  ;
 . . i SAMILINE'["id" q  ;
 . . n zzi s zzi=SAMILNUM
 . . f  s zzi=$o(SAMIHTML(zzi)) q:zzi>(SAMILNUM+20)  q:SAMIHTML(zzi)["tbody"  d
 . . . s SAMIHTML(zzi)=SAMIHTML(zzi)_$char(13,10)
 . . ;s SAMIHTML(zzi)="<tbody>"_$$SHDET^SAMIUR2(sid)
 . . s SAMILNUM=zzi+1
 . . s SAMILINE=$$SHDET^SAMIUR2(sid,form)_"</tbody>"
 ;
 i SAMILINE["@@ERROR_MESSAGE@@" d  ;
 . n errMsg s errMsg=$get(SAMIVALS("errorMessage"))
 . if errMsg="" q  ; no error message
 . do findReplace^%ts(.SAMILINE,"@@ERROR_MESSAGE@@",errMsg)
 ;
 i SAMILINE["@@ERROR_FIELDS@@" d  ;
 . n errFld s errFld=$get(SAMIVALS("errorField"))
 . if errFld="" q  ; no error field
 . do findReplace^%ts(.SAMILINE,"@@ERROR_FIELDS@@",errFld)
 ;
 i SAMILINE["@@INFO_MESSAGE@@" d  ;
 . n infoMsg s infoMsg=$get(SAMIVALS("infoMessage"))
 . if infoMsg="" q  ; no message
 . do findReplace^%ts(.SAMILINE,"@@INFO_MESSAGE@@",infoMsg)
 ;
 i SAMILINE["@@WARN_MESSAGE@@" d  ;
 . n warnMsg s warnMsg=$get(SAMIVALS("warnMessage"))
 . if warnMsg="" q  ; no message
 . do findReplace^%ts(.SAMILINE,"@@WARN_MESSAGE@@",warnMsg)
 ;
 quit  ; end of pps LOAD^SAMIFORM
 ;
 ;
 ;
 ;
 ;@func $$XPAND
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;tests?;port
 ;@called-by
 ; LOAD
 ;@calls none
 ;@input
 ; zi = # to pad
 ;@output = # expanded to 8 digits by prefixing 0 & appending 1 so 10,
 ; 20, etc. collate properly
 ;@tests [tbd]
 ;
 ;
XPAND(zi) ; expand # to 8 digits
 ;
 ;@stanza 2 algorithm
 ;
 new g1 set g1=8-$length(zi)
 new g2 set $piece(g2,"0",g1)=""
 new g3 set g3=g2_zi_"1"
 ;
 ;@stanza 3 termination
 ;
 quit g3 ; end of $$XPAND
 ;
 ;
 ;
 ;
 ;@pps $$GETHDR^SAMIFLD
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;clean;silent;sac;tests?;port
 ;@signature
 ; $$GETHDR^SAMIFLD(sid)
 ;@called-by
 ; LOAD^SAMIFLD
 ; WSREPORT^SAMIUR1
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
 ; UTGETHDR^SAMIUTF hdr string for patient sid
 ;@to-do
 ;  convert to pps GETHDR^SAMIFORM
 ;
 ;
GETHDR(sid) ; header string for patient sid
 ;
 ;@stanza 2 find patient
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 new dfn set dfn=@root@(ien,"dfn")
 quit:ien=""
 ;
 ;
 ;@stanza 3 prefill with vista data
 ;
 ; do PREFILL^SAMIHOM3(dfn) ; update from Vista
 if $get(@root@(ien,"ssn"))="" do PREFILL^SAMIHOM3(dfn) ; update from Vista
 if $get(@root@(ien,"sbdob"))=-1 do PREFILL^SAMIHOM3(dfn) ; update from Vista
 ;
 ;
 ;@stanza 4 ssn
 ;
 n pssn s pssn="" ; will be ssn with dashes
 ; if $get(@root@(ien,"ssn"))="" quit "" ; patient info not available
 if $get(@root@(ien,"ssn"))'="" do  ;
 . set pssn=$get(@root@(ien,"sissn"))
 . if pssn["sta" set pssn=""
 . if pssn="" do  ;
 . . new orgssn
 . . set orgssn=$get(@root@(ien,"ssn"))
 . . quit:orgssn=""
 . . set pssn=$extract(orgssn,1,3)_"-"_$extract(orgssn,4,5)_"-"_$extract(orgssn,6,9)
 . . set @root@(ien,"sissn")=pssn
 . . quit
 . . q
 . q
 ;
 ;
 ;@stanza 5 age
 ;
 new dob set dob=$get(@root@(ien,"sbdob")) ; dob in VAPALS format
 i dob["-" s dob=$e(dob,6,7)_"/"_$e(dob,9,10)_"/"_$e(dob,1,4)
 i dob'["/" s dob=$e(dob,5,6)_"/"_$e(dob,7,8)_"/"_$e(dob,1,4)
 new X set X=dob
 new Y
 do ^%DT
 ;
 ; change ven/lgc 20190628 - calculate age with Mash
 ;new age set age=$piece($$FMDIFF^XLFDT($$NOW^XLFDT,Y)/365,".")
 new age s age=$$age^%th(Y)
 ; look for similar constructs throughout SMAI to convert to Mash
 ;
 set @root@(ien,"age")=age
 ;
 ;
 ;@stanza 6 sex, mrn, pid, assemble header
 ;
 new sex set sex=$get(@root@(ien,"sex"))
 ;
 new simrn,sipid
 set simrn=$$GETMRN(sid,.sipid)
 ;set sipid=$g(@root@(ien,"sipid"))
 ;
 new rtn set rtn=""
 if simrn'="" do  ;
 . set rtn=sipid_" "_simrn_" DOB: "_dob_" GENDER: "_sex
 else  do  ;
 . set rtn=pssn_" DOB: "_dob_" AGE: "_age_" GENDER: "_sex
 ;
 ;
 ;@stanza 7 termination
 ;
 quit rtn ; end of pps $$GETHDR^SAMIFLD
 ;
 ;
 ;
 ;
 ;@func $$GETMRN
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;tests?;port
 ;@called-by
 ; $$GETHDR^SAMIFLD
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient study id
 ;@output = medical record #
 ;.pid = patient id
 ;@tests
 ; UTGETHDR^SAMIUTF hdr string for patient sid
 ;@to-do
 ;  convert to pps GETHDR^SAMIFORM
 ;
 ;
GETMRN(sid,pid) ; get MRN, which supercedes ssn as patient id
 ;
 ;@stanza 2 calculate mrn & pid
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 new simrn,sipid
 ;set simrn=$get(@root@(ien,"simrn"))
 ;set sipid=$get(@root@(ien,"sipid"))
 set (simrn,sipid)=""
 ;
 if simrn="" d  ;
 . new siform
 . set siform=$order(@root@("graph",sid,"siform"))
 . quit:siform=""
 . set simrn=$get(@root@("graph",sid,siform,"simrn"))
 . q
 ;
 if sipid="" d  ;
 . new siform
 . set siform=$order(@root@("graph",sid,"siform"))
 . quit:siform=""
 . set sipid=$get(@root@("graph",sid,siform,"sipid"))
 . set pid=sipid
 . q
 ;
 ;
 ;@stanza 3 termination
 ;
 quit simrn ; end of $$GETMRN
 ;
 ;
 ;
 ;
 ;@section 2 code for ppses $$GETLAST5^SAMIFORM, FIXSRC^SAMIFORM, and
 ; FIXHREF^SAMIFORM
 ;
 ;
 ;
 ;
 ;@pps-code $$GETLAST5^SAMIFORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;clean?;silent;sac?;tests?;port?
 ;@signature
 ; $$GETLAST5^SAMIFORM(sid)
 ;@branches-from
 ; GETLAST5^SAMIFORM
 ;@pps-called-by
 ; WSCASE^SAMICAS2
 ; LOAD
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient study id
 ;@output = patient's BS5 (first initial of last name, last 4 of ssn)
 ;@tests
 ; UTGLST5^SAMIUTF2 last5 for patient sid
 ;
 ;
GETLAST5 ; last5 for patient sid
 ;
 ;@stanza 2 calculate it
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 ;
 ;@stanza 3 termination
 ;
 quit $get(@root@(ien,"last5")) ; end of pps $$GETLAST5^SAMIFORM
 ;
 ;
 ;
 ;
 ;@pps-code FIXSRC^SAMIFORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;procedure;clean?;silent?;sac?;tests?;port?
 ;@signature
 ; do FIXSRC^SAMIFORM(.SAMILINE)
 ;@branches-from
 ; FIXSRC^SAMIFORM
 ;@pps-called-by
 ; WSCASE^SAMICAS2
 ; GETHOME^SAMIHOM3 [redacted]
 ; LOAD
 ;@called-by none
 ;@calls
 ; findReplaceAll^%ts
 ;@thruput
 ;.SAMILINE = line of html to change
 ;@tests
 ; UTFSRC^SAMIUTF2 fix html src lines to use resources in see/
 ;
 ;
FIXSRC ; fix html src lines to use resources in see/
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
 quit  ; end of pps FIXSRC^SAMIFORM
 ;
 ;
 ;
 ;
 ;@pps-code FIXHREF^SAMIFORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;procedure;clean?;silent?;sac?;tests?;port?
 ;@signature
 ; do FIXHREF^SAMIFORM(.SAMILINE)
 ;@branches-from
 ; FIXHREF^SAMIFORM
 ;@pps-called-by
 ; WSCASE^SAMICAS2
 ; GETHOME^SAMIHOM3 [redacted]
 ; LOAD
 ;@called-by none
 ;@calls
 ; findReplaceAll^%ts
 ;@thruput
 ;.SAMILINE = line of html to change
 ;@tests
 ; UTFHREF^SAMIUTF2 fix html href lines to use resources in see/
 ;
 ;
FIXHREF ; fix html href lines to use resources in see/
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
 quit  ; end of pps FIXHREF^SAMIFORM
 ;
 ;
 ;
 ;
 ;@section 3 code for ppses $$GETNAME^SAMIFORM, $$GETSSN^SAMIFORM, and
 ; $$GETPRFX^SAMIFORM
 ;
 ;
 ;
 ;
 ;@pps-code $$GETNAME^SAMIFORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;clean?;silent?;sac?;tests?;port?
 ;@signature
 ; $$GETNAME^SAMIFORM(sid)
 ;@branches-from
 ; GETNAME^SAMIFORM
 ;@pps-called-by
 ; WSCASE^SAMICAS2
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient study id
 ;@output = patient's name
 ;@tests
 ; UTGTNM^SAMIUTF2 name for patient sid
 ;
GETNAME ; name for patient sid
 ;
 quit:$get(sid)="" ""
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 quit:ien=""
 ;
 quit @root@(ien,"saminame") ; end of pps $$GETNAME^SAMIFORM
 ;
 ;
 ;
 ;
 ;@pps-code $$GETSSN^SAMIFORM
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;clean?;silent?;sac?;tests?;port?
 ;@signature
 ; $$GETSSN^SAMIFORM(sid)
 ;@branches-from
 ; GETSSN^SAMIFORM
 ;@pps-called-by
 ; WSCASE^SAMICAS2
 ; NUHREF^SAMIUR
 ; WSREPORT^SAMIUR1
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; sid = patient study id
 ;@output = patient's ssn
 ;@tests
 ; UTGSSN^SAMIUTF2 ssn for patient sid
 ;
 ;
GETSSN ; ssn for patient sid
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
 quit pssn ; end of pps $$GETSSN^SAMIFORM
 ;
 ;
 ;
 ;
 ;@pps-code $$GETPRFX^SAMIFORM [deprecated]
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;clean;silent;sac;tests?;port
 ;@signature
 ; $$GETPRFX^SAMIFORM()
 ;@branches-from
 ; GETPRFX^SAMIFORM
 ;@pps-called-by
 ; WSCASE^SAMICAS2 [commented out]
 ; $$GENSTDID^SAMIHOM3 [commented out]
 ;@calls
 ; $$GET^XPAR [commented out]
 ;@output = patient's ssn
 ;@tests
 ; None yet
 ;
 ;
GETPRFX ; retrieve study ID prefix from parameter file
 ;
 ; This subroutine is deprecated as of the multi-tenancy features.
 ;
 new prefix
 ;set prefix=$$GET^XPAR("SYS","SAMI SID PREFIX",,"Q")
 s prefix=$g(ARG("siteid"))
 i prefix="" s prefix=$g(ARG("site"))
 if $get(prefix)="" set prefix="UNK"
 ;
 quit prefix ; end of pps $$GETPRFX^SAMIFORM
 ;
 ;
 ;
EOR ; end of routine SAMIFLD
