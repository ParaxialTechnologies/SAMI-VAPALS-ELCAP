SAMIFLD ;ven/gpl - elcap: form load & case review ;2021-03-21T23:51Z
 ;;18.0;SAMI;**10**;2020-01;Build 11
 ;;1.18.0.10-i10
 ;
 ; SAMIFLD contains subroutines for processing ELCAP forms, loading
 ; JSON data into the graphstore for each line. Since three of those
 ; subroutines are also code for ppis called by WSCASE^SAMICASE, two
 ; additional subroutines are included that are not part of the LOAD
 ; opus but are called by WSCASE^SAMICASE.
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
 ;@primary-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated 2021-03-21T23:51Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - VAPALS-ELCAP (SAMI)
 ;@version 1.18.0.10-i10
 ;@release-date 2020-01
 ;@patch-list **10**
 ;@build 11
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;@additional-dev Alexis Carlson (arc)
 ; alexis.carlson@vistaexpertise.net
 ;@additional-dev Domenic DiNatale (dom)
 ; domenic.dinatale@paraxialtech.com
 ;
 ;@module-credits [see SAMIFUL]
 ;
 ;@contents
 ; LOAD: code for ppi LOAD^SAMIFORM
 ;  process html line, e.g., load json data into graph
 ;
 ; $$xpand = expand # to 8 digits
 ; $$GETHDR-AGE = header string for patient sid
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
 ; GETPRFX = code for ppi $$GETPRFX^SAMIFORM [deprecated]
 ;  retrieve study id prefix from parameter file
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
 ; $$xpand
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
 . . new zien set zien=SAMILNUM_"."_$$xpand(zi)
 . . set zhtml(zien)=@clog@(zi)
 . set zhtml(SAMILNUM_"."_$$xpand($order(@clog@(""),-1)+1))="</pre>"
 ;
 if SAMILINE["commlog" d  ;
 . new root set root=$$setroot^%wd("vapals-patients")
 . new clog set clog=$na(@root@("graph",sid,form,"comlog"))
 . if '$d(@clog) q  ;
 . do findReplace^%ts(.SAMILINE,"</pre>","")
 . new zi set zi=""
 . for  set zi=$order(@clog@(zi)) quit:zi=""  d  ;
 . . new zien set zien=SAMILNUM_"."_$$xpand(zi)
 . . set zhtml(zien)=@clog@(zi)
 . set zhtml(SAMILNUM_"."_$$xpand($order(@clog@(""),-1)+1))="</pre>"
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
 quit  ; end of ppi LOAD^SAMIFORM
 ;
 ;
 ;
xpand(zi) ; expand # to 8 digits
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;0% tests
 ;@called-by
 ; LOAD
 ;@calls none
 ;@input
 ; zi = # to expand
 ;@output = # expanded to 8 digits by prefixing 0 & appending 1 so 10,
 ; 20, etc. collate properly
 ;
 ;@stanza 2 algorithm
 ;
 new g1 set g1=8-$length(zi)
 new g2 set $piece(g2,"0",g1)=""
 new g3 set g3=g2_zi_"1"
 ;
 ;@stanza 3 termination
 ;
 quit g3 ; end of $$xpand
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
 ;
AGE new dob set dob=$get(@root@(ien,"sbdob")) ; dob in VAPALS format
 i dob["-" s dob=$e(dob,6,7)_"/"_$e(dob,9,10)_"/"_$e(dob,1,4)
 i dob'["/" s dob=$e(dob,5,6)_"/"_$e(dob,7,8)_"/"_$e(dob,1,4)
 new X set X=dob
 new Y
 do ^%DT
 ;
 ; change ven/lgc 20190628 - calculate age with MASH 
 ;
 ;new age set age=$piece($$FMDIFF^XLFDT($$NOW^XLFDT,Y)/365,".")
 new age s age=$$age^%th(Y)
 ;
 set @root@(ien,"age")=age
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
 quit rtn ; end of $$GETHDR-AGE
 ;
GETMRN(sid,pid) ; get the MRN, which supercedes the ssn as the patient identifier
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new ien set ien=$order(@root@("sid",sid,""))
 new simrn,sipid
 ;set simrn=$get(@root@(ien,"simrn"))
 ;set sipid=$get(@root@(ien,"sipid"))
 set (simrn,sipid)=""
 if simrn="" d  ;
 . new siform
 . set siform=$order(@root@("graph",sid,"siform"))
 . quit:siform=""
 . set simrn=$get(@root@("graph",sid,siform,"simrn"))
 if sipid="" d  ;
 . new siform
 . set siform=$order(@root@("graph",sid,"siform"))
 . quit:siform=""
 . set sipid=$get(@root@("graph",sid,siform,"sipid"))
 . set pid=sipid
 quit simrn
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
 quit $get(@root@(ien,"last5")) ; end of ppi $$GETLAST5^SAMIFORM
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
 ;@section 3 code for ppis $$GETNAME,$$GETSSN,$$GETPRFX^SAMIFORM
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
 quit pssn ; end of ppi $$GETSSN^SAMIFORM
 ;
 ;
 ;
 ;@ppi-code $$GETPRFX^SAMIFORM [deprecated]
GETPRFX ; Retrieve study ID prefix from parameter file
 ; This subroutine is deprecated as of the multi-tenancy features.
 ;
 ;@signature
 ; $$GETPRFX^SAMIFORM()
 ;@branches-from
 ; GETPRFX^SAMIFORM
 ;@ppi-called-by
 ; WSCASE^SAMICAS2
 ;@calls
 ; $$GET^XPAR
 ;@output = patient's ssn
 ;@tests
 ; None yet
 ;
 new prefix
 ;set prefix=$$GET^XPAR("SYS","SAMI SID PREFIX",,"Q")
 s prefix=$g(ARG("siteid"))
 i prefix="" s prefix=$g(ARG("site"))
 if $get(prefix)="" set prefix="UNK"
 ;
 quit prefix ; end of ppi $$GETPRFX^SAMIFORM
 ;
 ;
 ;
EOR ; end of routine SAMIFLD
