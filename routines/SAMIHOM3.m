SAMIHOM3 ;ven/gpl - ielcap: forms ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ; Routine SAMIHOM2 contains subroutines for implementing the ELCAP Home
 ; Page. SAMIHOM3 is further enhanced to provide binding to VistA
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
 ; 2018-01-13 ven/gpl v18.0t04 SAMIHOM2: create routine from SAMIFRM to
 ; implement ELCAP Home Page.
 ;
 ; 2018-02-05 ven/toad v18.0t04 SAMIHOM2: update license & attribution &
 ; hdr comments, add white space & do-dot quits, spell out language
 ; elements.
 ;
 ; 2018-02-27 ven/gpl v18.0t04 SAMIHOM2: new subroutines $$prefix,getHome,
 ; $$scanFor,wsNewCase,prefill,makeSbform,makeSiform,$$validateName,
 ; $$sid2num,$$keyDate,$$genStudyId,$$nextNum to support creation of new
 ; cases.
 ;
 ; 2018-03-01 ven/toad v18.0t04 SAMIHOM2: refactor & reorganize new code,
 ; add header comments, r/findReplaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-06 ven/gpl v18.0t04 SAMIHOM2: ?
 ;
 ; 2018-03-07 ven/toad v18.0t04 SAMIHOM2: in $$sid2num add
 ; wsNuForm^SAMICAS2 to called-by list; in keyDate,getHome update
 ; called-by.
 ;
 ;@contents
 ;
 ;  code for SAMI homepage web service
 ;
 ; wsHOME: web service for SAMI homepage
 ; devhome: temporary home page for development
 ; patlist: returns a list of patients in ary, passed by name
 ; getHome: homepage accessed using GET (not subsequent visit)
 ; $$scanFor = scan array looking for value, return index
 ;
 ;  code for SAMI new case web service
 ;
 ; wsNewCase: web service receives post from home & creates new case
 ; $$nextNum = next number for studyid
 ; $$genStudyId = studyID for number
 ; $$prefix = letters to use to begin studyId
 ; $$keyDate = date in StudyId format (yyyy-mm-dd)
 ; $$validateName = validate a new name
 ; prefill: prefill fields for forms
 ; makeSiform: create intake form
 ; makeSbform: create background form
 ;
 ;  api $$sid2num^SAMIHOM2
 ;
 ; $$sid2num = number part of studyid (XXX0001 -> 1)
 ;
 ;
 ;
 ;@section 1 code for SAMI homepage web service
 ;
 ;
 ;
wsHOME(rtn,filter) ; web service for SAMI homepage
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@called-by
 ;@calls
 ; getHome
 ;@input
 ; filter
 ;@output
 ;.rtn
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; no parameters required
 ;
 ;@stanza 2 present development or temporary homepage
 ;
 if $get(filter("test"))=1 do  quit
 . do devhome(.rtn,.filter)
 . quit
 ;
 if $g(filter("samiroute"))'="" do  quit  ; workaround for "get" access to pages
 . new BODY set BODY(1)=""
 . do wsVAPALS(.filter,.BODY,.rtn) 
 ;
 do getHome(.rtn,.filter) ; VAPALS homepage
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wsHOME
 ;
 ;
 ;
wsVAPALS(ARG,BODY,RESULT) ; vapals post web service - all calls come through this gateway
 m ^gpl("vapals")=ARG
 m ^gpl("vapals","BODY")=BODY
 ;
 new vars,bdy
 set bdy=$get(BODY(1))
 do parseBody^%wf("vars",.bdy)
 m vars=ARG
 merge ^gpl("vapals","vars")=vars
 ;
 n route s route=$g(vars("samiroute"))
 i route=""  d getHome(.RESULT,.ARG) ; on error go home
 ;
 i route="lookup" d  q  ;
 . m ARG=vars
 . d wsLookup^SAMISRC2(.ARG,.BODY,.RESULT)
 ;
 i route="newcase" d  q  ;
 . m ARG=vars
 . d wsNewCase(.ARG,.BODY,.RESULT)
 ;
 i route="casereview" d  q  ;
 . m ARG=vars
 . d wsCASE^SAMICAS2(.RESULT,.ARG)
 ;
 i route="nuform" d  q  ;
 . m ARG=vars
 . d wsNuForm^SAMICAS2(.RESULT,.ARG)
 ;
 i route="addform" d  q  ;
 . m ARG=vars
 . d wsNuFormPost^SAMICAS2(.ARG,.BODY,.RESULT)
 ;
 i route="form" d  q  ;
 . m ARG=vars
 . d wsGetForm^%wf(.RESULT,.ARG)
 ;
 i route="postform" d  q  ;
 . m ARG=vars
 . d wsPostForm^%wf(.ARG,.BODY,.RESULT)
 ;
 i route="deleteform" d  q  ;
 . m ARG=vars
 . d deleteForm^SAMICAS2(.RESULT,.ARG)
 ;
 i route="ctreport" d  q  ;
 . m ARG=vars
 . d wsReport^SAMICTR(.RESULT,.ARG)
 ;
 q
 ;
devhome(rtn,filter) ; temporary home page for development
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsHOME
 ;@calls
 ; htmltb2^%yottaweb
 ; patlist
 ; genhtml^%yottautl
 ; addary^%yottautl
 ;@input
 ; filter =
 ;@output
 ;.rtn =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 ?
 ;
 new gtop,gbot
 do htmltb2^%yottaweb(.gtop,.gbot,"SAMI Test Patients")
 ;
 new html,ary,hpat
 do patlist("hpat")
 quit:'$data(hpat)
 ;
 set ary("title")="SAMI Test Patients on this system"
 set ary("header",1)="StudyId"
 set ary("header",2)="Name"
 ;
 new cnt set cnt=0
 new zi set zi=""
 for  set zi=$order(hpat(zi)) quit:zi=""  do  ;
 . set cnt=cnt+1
 . new url set url="<a href=""/cform.cgi?studyId="_zi_""">"_zi_"</a>"
 . set ary(cnt,1)=url
 . set ary(cnt,2)=""
 . quit
 ;
 do genhtml^%yottautl("html","ary")
 ;
 do addary^%yottautl("rtn","gtop")
 do addary^%yottautl("rtn","html")
 set rtn($order(rtn(""),-1)+1)=gbot
 kill rtn(0)
 ;
 set HTTPRSP("mime")="text/html"
 ;
 ;@stanza ? termination
 ;
 quit  ; end of devhome
 ;
 ;
 ;
patlist(ary) ; returns a list of patients in ary, passed by name
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; devhome
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; ary = name of array to return patient list in
 ;@output
 ; @ary = array containing list of patients
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 build list of patients
 ;
 new groot set groot=$$setroot^%wd("vapals-patients")
 ;
 kill @ary
 new zi set zi=""
 for  set zi=$order(@groot@("graph",zi)) quit:zi=""  do  ;
 . set @ary@(zi)=""
 . quit
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of patlist
 ;
 ;
 ;
getHome(rtn,filter) ; homepage accessed using GET
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsHOME
 ; wsNewCase
 ; wsNuFormPost^SAMICAS2
 ; wsLookup^SAMISRCH
 ;@calls
 ; getTemplate^SAMICAS2
 ; findReplace^%ts
 ; $$scanFor
 ; ADDCRLF^VPRJRUT
 ;@input
 ; filter =
 ;@output
 ;.rtn =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 get template for homepage
 ;
 new temp,tout
 do getTemplate^SAMICAS2("temp","vapals:home")
 quit:'$data(temp)
 ;
 ;@stanza 3 process homepage template
 ;
 new cnt set cnt=0
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . ;
 . n ln s ln=temp(zi)
 . n touched s touched=0
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
 . i ln["id" i ln["studyIdMenu" d  ;
 . . s zi=zi+4
 . ; 
 . i ln["casereview.html" d  ;
 . . d findReplace^%ts(.ln,"casereview.html","/vapals")
 . . s cnt=cnt+1
 . . s tout(cnt)=ln
 . . s cnt=cnt+1
 . . s tout(cnt)="<input type=hidden name=""samiroute"" value=""lookup"">"
 . . s zi=zi+1
 . ;
 . i ln["intake.html" d  ;
 . . d findReplace^%ts(.ln,"intake.html","/vapals")
 . . s cnt=cnt+1
 . . s tout(cnt)=ln
 . . s cnt=cnt+1
 . . s tout(cnt)="<input type=hidden name=""samiroute"" value=""newcase"">"
 . . s zi=zi+1
 . ;
 . set cnt=cnt+1
 . set tout(cnt)=temp(zi)
 . quit
 ;
 ;@stanza 4 add cr/lf & save to return array
 ;
 do ADDCRLF^VPRJRUT(.tout)
 merge rtn=tout
 ;
 ;@stanza 5 termination
 ;
 quit  ; end of getHome
 ;
 ;
 ;
scanFor(ary,start,what) ; scan array looking for value
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; getHome
 ;@calls: none
 ;@input
 ;.ary = array to scan
 ; start = index to begin scanning at
 ; what = value to scan array for
 ;@output = array index where value was found
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 scan array
 ;
 ;  returns the index in the array where what occurs
 ;  ary is passed by reference
 ;
 new limit s limit=0
 new %1 set %1=start
 for  set %1=$order(ary(%1)) quit:+%1=0  quit:limit>1000  quit:ary(%1)[what  do  ;
 . set limit=limit+1
 . ;W !,ary(%1)
 . quit
 ;
 ;@stanza 3 return & termination
 n zrtn
 s zrtn=%1
 i %1<start s zrtn=start
 i %1>1000 s zrtn=start
 ;
 quit zrtn ; return array index; end of $$$scanFor
 ;
 ;
 ;
 ;@section 2 code for SAMI new case web service
 ;
 ;
 ;
wsNewCase(ARGS,BODY,RESULT) ; receives post from home & creates new case
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ;@calls
 ; parseBody^%wf
 ; $$setroot^%wd
 ; $$nextNum
 ; $$genStudyId
 ; $$NOW^XLFDT
 ; $$keyDate
 ; $$validateName
 ; getHome
 ; prefill
 ; makeSbform
 ; makeSiform
 ; wsCASE^SAMICAS2
 ;@input
 ;.ARGS =
 ; BODY =
 ;.RESULT =
 ;@output: ?
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 ?
 ;
 merge ^gpl("newCase","ARGS")=ARGS
 merge ^gpl("newCase","BODY")=BODY
 ;
 new vars,bdy
 set bdy=$get(BODY(1))
 do parseBody^%wf("vars",.bdy)
 merge ^gpl("newCase","vars")=vars
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 new saminame set saminame=$get(vars("name"))
 if saminame="" s saminame=$get(vars("saminame"))
 ;if $$validateName(saminame,.ARGS)=-1 do  quit  ;
 ;. new r1
 ;. do getHome(.r1,.ARGS) ; home page to redisplay
 ;. merge RESULT=r1
 ;. quit
 ;
 new dfn s dfn=$get(vars("dfn"))
 ;if dfn="" do  quit  ;
 ;. new r1
 ;. do getHome(.r1,.ARGS) ; home page to redisplay
 ;. merge RESULT=r1
 ;. quit
 ;
 ;new gien set gien=$$nextNum
 new gien set gien=dfn
 ;
 m ^gpl("newCase","G1")=root
 ; create dfn index
 set @root@("dfn",dfn,gien)=""
 ;
 set @root@(gien,"saminum")=gien
 set @root@(gien,"saminame")=saminame
 ;
 new studyid set studyid=$$genStudyId(gien)
 set @root@(gien,"samistudyid")=studyid
 set @root@("sid",studyid,gien)=""
 ;
 new datekey set datekey=$$keyDate($$NOW^XLFDT)
 set @root@(gien,"samicreatedate")=datekey
 ;
 merge ^gpl("newCase",gien)=@root@(gien)
 ;
 ;
 do prefill(dfn) ; prefills from the "patient-lookup" graph
 ;
 n siformkey
 ;do makeSbform(gien) ; create a background form for new patient
 set siformkey=$$makeSiform(gien) ; create an intake for for new patient
 ;
 set ARGS("studyid")=studyid
 set ARGS("form")="vapals:"_siformkey
 do wsGetForm^%wf(.RESULT,.ARGS)
 ;do wsCASE^SAMICAS2(.RESULT,.ARGS) ; navigate to the case review page
 ;
 ;@stanza ? termination
 ;
 quit  ; end of wsNewCase
 ;
 ;
 ;
nextNum() ; next number for studyid
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;variable;
 ;@called-by
 ; wsNewCase
 ;@calls
 ; $$setroot^%wd
 ;@input: none
 ;@output = next number for study id
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 calculate next number
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new number set number=$order(@root@("  "),-1)+1
 ;
 ;@stanza 3 return & termination
 ;
 quit number ; return #; end of $$nextNum
 ;
 ;
 ;
genStudyId(num) ; studyID for number
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; wsNewCase
 ; wsLookup^SAMISRCH
 ;@calls
 ; $$prefix
 ;@input
 ; num = number of study id
 ;@output = study id corresponding to number
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 calculate study id
 ;
 new zl set zl=$length(num)
 new zz set zz="00000"
 new studyid set studyid=$$prefix_$extract(zz,1,5-zl)_num
 ;
 ;@stanza 3 return & termination
 ;
 quit studyid ; return study id; end of $$genStudyId
 ;
 ;
 ;
prefix() ; letters to use to begin studyId
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;variable;
 ;@called-by
 ; $$genStudyId
 ;@calls: none
 ;@input: none
 ;@output = study id prefix
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 return & termination
 ;
 quit "XXX" ; return study id prefix; end of $$prefix
 ;
 ;
 ;
keyDate(fmdt) ; date in StudyId format (yyyy-mm-dd)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; wsNewCase
 ; wsNuFormPost^SAMICAS2
 ;@calls
 ; $$FMTE^XLFDT
 ;@input
 ; fmdt = date in fileman format
 ;@output = date in study id format
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 calculate studyid format
 ;
 new zdt set zdt=$$FMTE^XLFDT(fmdt,"7D")
 ;
 new zy,zm,zd
 set zy=$piece(zdt,"/",1)
 set zm=$piece(zdt,"/",2)
 if $length(zm)=1 set zm="0"_zm
 set zd=$piece(zdt,"/",3)
 if $length(zd)=1 set zd="0"_zd
 ;
 new studydate set studydate=zy_"-"_zm_"-"_zd
 ;
 ;@stanza 3 return & termination
 ;
 quit studydate ; return date; end of $$keyDate
 ;
 ;
 ;
validateName(nm,args) ; validate new name
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; wsNewCase
 ;@calls: none
 ;@input
 ; nm = name to validate
 ;.args = array to return error messages
 ;@output = 1 if valid, -1 if not
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 screen for invalid name
 ;
 if nm'["," do  quit -1 ;
 . set args("saminuerror")="invalid name"
 . quit
 ;
 ;@stanza 3 return & termination
 ;
 quit 1 ; return success; end of $$validateName
 ;
 ;
 ;
prefill(dfn) ; prefill fields for form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNewCase
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; gien =
 ;@output
 ; @root(gien) = ...
 ;  where root = graph root for elcap patients
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 prefill fields
 ;
 ; prefills fields from patient-lookup graph
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new lroot s lroot=$$setroot^%wd("patient-lookup")
 new lien s lien=$o(@lroot@("dfn",dfn,""))
 q:lien=""
 n gien s gien=$o(@root@("dfn",dfn,"")) ; 
 q:gien=""
 ; merge prefill fields
 m @root@(gien)=@lroot@(lien)
 ; fix format problems
 new saminame set saminame=$get(@root@(gien,"saminame"))
 ; dob format
 n dob s dob=$g(@lroot@(lien,"sbdob"))
 s dob=$$HL7TFM^XLFDT(dob)
 if dob'="" set @root@(gien,"sbdob")=$$vapalsDate^SAMICAS2(dob)
 if dob'="" set @root@(gien,"sidob")=$$vapalsDate^SAMICAS2(dob)
 ; ssn format
 n ssn s ssn=$g(@lroot@(lien,"ssn"))
 if $l(ssn)=9 set @root@(gien,"sissn")=$e(ssn,1,3)_"-"_$e(ssn,4,5)_"-"_$e(ssn,6,9)
 ; studyid
 set @root@(gien,"sisid")=@root@(gien,"samistudyid")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of prefill
 ;
 ;
 ;
makeSbform(num) ; create background form -- depricated gpl 20180615
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNewCase
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; num = index where new form should be built
 ;@output
 ; @root(num) = ...
 ;  where root = graph root for elcap patients
 ; @root@("graph")
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 build background form & place graph
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(num,"samistudyid"))
 quit:sid=""
 new cdate set cdate=$get(@root@(num,"samicreatedate"))
 quit:cdate=""
 merge @root@("graph",sid,"sbform-"_cdate)=@root@(num)
 d setSamiStatus^SAMICAS2(sid,"sbform-"_cdate,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of makeSbform
 ;
 ;
 ;
makeSiform(num) ; create intake form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; wsNewCase
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; num = index where new form should be built
 ;@output
 ; @root(num) = ...
 ;  where root = graph root for elcap patients
 ; @root@("graph")
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 build intake form & place graph
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(num,"samistudyid"))
 quit:sid=""
 new cdate set cdate=$get(@root@(num,"samicreatedate"))
 quit:cdate=""
 merge @root@("graph",sid,"siform-"_cdate)=@root@(num)
 d setSamiStatus^SAMICAS2(sid,"siform-"_cdate,"complete")
 ;
 ;@stanza 3 termination
 ;
 quit "siform-"_cdate ; end of makeSiform
 ;
 ;
 ;
 ;@section 4 api $$sid2num^SAMIHOM2
 ;
 ;
 ;
 ;@API $$sid2num^SAMIHOM2, number part of study id
sid2num(sid) ; number part of studyid (XXX0001 -> 1)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;public;function;
 ;@called-by
 ; getVals^%wfhform
 ; wsCASE^SAMICAS2
 ; wsNuForm^SAMICAS2
 ; makeCeform^SAMICAS2
 ;@calls: none
 ;@input
 ; sid = study id
 ;@output = number from study id
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 calculate number
 ;
 new number set number=+$extract(sid,4,$length(sid))
 ;
 ;@stanza 3 return & termination
 ;
 quit number ; return number; end of $$sid2num
 ;
 ;
addPatient(dfn) ; calls newCase to add patient dfn to vapals
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n lien s lien=$o(@lroot@("dfn",dfn,""))
 q:lien=""
 n name s name=$g(@lroot@(lien,"saminame"))
 q:name=""
 n bdy s bdy(1)="saminame="_name_"&dfn="_dfn
 n ARGS,result
 d wsNewCase(.ARGS,.bdy,.result)
 zwr result
 ;
index ; reindex the vapals-patients graph
 n root s root=$$setroot^%wd("vapals-patients")
 n zi s zi=0
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . n dfn,sid
 . s dfn=@root@(zi,"dfn")
 . s sid=@root@(zi,"samistudyid")
 . s @root@("dfn",dfn,zi)=""
 . s @root@("sid",sid,zi)="" 
 q
 ;
EOR ; end of routine SAMIHOM2
