SAMIHOM3 ;ven/gpl - ielcap: forms ; 2019-08-07T01:13Z
 ;;18.0;SAMI;;;Build 11
 ;
 ;@license: see routine SAMIUL
 ;
 ; Routine SAMIHOM3 contains subroutines for implementing the ELCAP Home
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
 ; 2018-01-13 ven/gpl v18.0t04 SAMIHOM3: create routine from SAMIFRM to
 ; implement ELCAP Home Page.
 ;
 ; 2018-02-05 ven/toad v18.0t04 SAMIHOM3: update license & attribution &
 ; hdr comments, add white space & do-dot quits, spell out language
 ; elements.
 ;
 ; 2018-02-27 ven/gpl v18.0t04 SAMIHOM3: new subroutines $$PREFIX,GETHOME,
 ; $$SCANFOR,WSNEWCAS,PREFILL,MKSBFORM,MKSIFORM,$$VALDTNM,
 ; $$SID2NUM,$$KEYDATE,$$GENSTDID,$$NEXTNUM to support creation of new
 ; cases.
 ;
 ; 2018-03-01 ven/toad v18.0t04 SAMIHOM3: refactor & reorganize new code,
 ; add header comments, r/findReplaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-06 ven/gpl v18.0t04 SAMIHOM3: ?
 ;
 ; 2018-03-07 ven/toad v18.0t04 SAMIHOM3: in $$SID2NUM add
 ; WSNUFORM^SAMICASE to called-by list; in keyDate,GETHOME update
 ; called-by.
 ;
 ;@contents
 ;
 ;  code for SAMI homepage web service
 ;
 ; WSHOME: web service for SAMI homepage
 ; DEVHOME: temporary home page for development
 ; PATLIST: returns a list of patients in ary, passed by name
 ; GETHOME: homepage accessed using GET (not subsequent visit)
 ; $$SCANFOR = scan array looking for value, return index
 ;
 ;  code for SAMI new case web service
 ;
 ; WSNEWCAS: web service receives post from home & creates new case
 ; $$NEXTNUM = next number for studyid
 ; $$GENSTDID = studyID for number
 ; $$PREFIX = letters to use to begin studyId
 ; $$KEYDATE = date in StudyId format (yyyy-mm-dd)
 ; $$VALDTNM = validate a new name
 ; PREFILL: prefill fields for forms
 ; MKSIFORM: create intake form
 ; MKSBFORM: create background form
 ;
 ;  api $$SID2NUM^SAMIHOM3
 ;
 ; $$SID2NUM = number part of studyid (XXX0001 -> 1)
 ;
 ;
 ;
 ;@section 1 code for SAMI homepage web service
 ;
 ;
 ;
 ; web service for SAMI homepage
WSHOME(SAMIRTN,SAMIFILTER) goto WSHOME^SAMIHOM4
 ;
 ;
 ; vapals post web service - all calls come through this gateway
WSVAPALS(SAMIARG,SAMIBODY,SAMIRESULT) goto WSVAPALS^SAMIHOM4
 ;
 ;
DEVHOME(SAMIRTN,SAMIFILTER) goto DEVHOME^SAMIHOM4
 ;
 ;
PATLIST(ARY) ; returns a list of patients in ary, passed by name
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; DEVHOME
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
 new GROOT set GROOT=$$setroot^%wd("vapals-patients")
 ;
 kill @ARY
 new zi set zi=""
 for  set zi=$order(@GROOT@("graph",zi)) quit:zi=""  do  ;
 . set @ARY@(zi)=""
 . quit
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of PATLIST
 ;
 ;
 ;
 ; homepage accessed using GET
GETHOME(SAMIRTN,SAMIFILTER) goto GETHOME^SAMIHOM4
 ;
 ;
SCANFOR(ary,start,what) ; scan array looking for value
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; GETHOME
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
 quit zrtn ; return array index; end of $$$SCANFOR
 ;
 ;
 ;
 ;@section 2 code for SAMI new case web service
 ;
 ;
 ;
 ; receives post from home & creates new case
WSNEWCAS(SAMIARGS,SAMIBODY,SAMIRESULT) goto WSNEWCAS^SAMIHOM4
 ;
 ;
NEXTNUM() ; next number for studyid
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;variable;
 ;@called-by
 ; WSNEWCAS
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
 quit number ; return #; end of $$NEXTNUM
 ;
 ;
 ;
GENSTDID(num,ARG) ; studyID for number
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; WSNEWCAS
 ; wsLookup^SAMISRCH
 ;@calls
 ; $$PREFIX
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
 ;new studyid set studyid=$$GETPRFX^SAMIFORM(.ARG)_$extract(zz,1,5-zl)_num
 ; the prefix is determined by the site or siteid, which should be passed
 ; in ARG
 n tsite s tsite=$g(ARG("siteid"))
 i tsite="" s tsite=$g(ARG("site"))
 i tsite="" s tsite="UNK"
 new studyid set studyid=tsite_$extract(zz,1,5-zl)_num
 ;
 ;@stanza 3 return & termination
 ;
 quit studyid ; return study id; end of $$GENSTDID
 ;
 ;
 ;
KEYDATE(fmdt) ; date in StudyId format (yyyy-mm-dd)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; WSNEWCAS
 ; WSNFPOST^SAMICASE
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
 quit studydate ; return date; end of $$KEYDATE
 ;
 ;
 ;
VALDTNM(nm,args) ; validate new name
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;
 ;@called-by
 ; WSNEWCAS
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
 quit 1 ; return success; end of $$VALDTNM
 ;
 ;
 ;
PREFILL(dfn) ; prefill fields for form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNEWCAS
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
 ; pull data from VistA
 ;
 ;n ok
 ;s ok=$$PTINFO^SAMIVSTA(dfn)
 ;i +ok<1 D ^ZTER
 d PTINFO^SAMIVSTA(dfn)
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
 n X,Y
 S X=dob
 d ^%DT
 Q:Y=-1
 s dob=Y
 if dob'="" set @root@(gien,"sbdob")=$$VAPALSDT^SAMICASE(dob)
 if dob'="" set @root@(gien,"sidob")=$$VAPALSDT^SAMICASE(dob)
 ; ssn format
 n ssn s ssn=$g(@lroot@(lien,"ssn"))
 if $l(ssn)=9 set @root@(gien,"sissn")=$e(ssn,1,3)_"-"_$e(ssn,4,5)_"-"_$e(ssn,6,9)
 ; studyid
 set @root@(gien,"sisid")=@root@(gien,"samistudyid")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of PREFILL
 ;
 ;
 ;
MKSBFORM(num) ; create background form -- depricated gpl 20180615
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNEWCAS
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
 d SSAMISTA^SAMICASE(sid,"sbform-"_cdate,"incomplete")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKSBFORM
 ;
 ;
 ;
MKSIFORM(num) ; create intake form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSNEWCAS
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
 d SSAMISTA^SAMICASE(sid,"siform-"_cdate,"complete")
 ; initialize form from VistA data
 n zf s zf=$na(@root@("graph",sid,"siform-"_cdate))
 s @zf@("sipsa")=$g(@root@(num,"address1")) ; primary address
 s @zf@("sipan")=$g(@root@(num,"address2")) ; apartment number
 s @zf@("sipc")=$g(@root@(num,"city")) ; city
 s @zf@("sips")=$g(@root@(num,"state")) ; state
 s @zf@("sipcn")=$g(@root@(num,"county")) ; county
 s @zf@("sipcr")="USA" ; country
 s @zf@("sipz")=$g(@root@(num,"zip")) ; zip
 i @zf@("sipz")'="" d  ;
 . n zip s zip=@zf@("sipz")
 . q:zip=""
 . n ru s ru=$$URBRUR^SAMIVSTA(zip)
 . i ru=0 s ru="n"
 . i (ru="r")!(ru="u")!(ru="n") s @zf@("sirs")=ru
 . s @root@(num,"sirs")=$g(@zf@("sirs"))
 n phn s phn=$g(@root@(num,"phone")) ; phone number
 i phn["x" s phn=$p(phn," x",1)
 s @zf@("sippn")=phn
 s @zf@("sidc")=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 s @zf@("sipedc")=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 ; set samifirsttime variable for intake form
 s @zf@("samifirsttime")="true"
 ;
 ;@stanza 3 termination
 ;
 quit "siform-"_cdate ; end of MKSIFORM
 ;
 ;
 ;
 ;@section 4 api $$SID2NUM^SAMIHOM3
 ;
 ;
 ;
 ;@API $$SID2NUM^SAMIHOM3, number part of study id
SID2NUM(sid) ; number part of studyid (XXX0001 -> 1)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;public;function;
 ;@called-by
 ; getVals^%wfhform
 ; WSCASE^SAMICASE
 ; WSNUFORM^SAMICASE
 ; MKCEFORM^SAMICASE
 ;@calls: none
 ;@input
 ; sid = study id
 ;@output = number from study id
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 calculate number
 ;
 ;new number set number=+$extract(sid,4,$length(sid))
 ; we have to look up the number (pien) instead of computing it
 new number,proot
 set proot=$$setroot^%wd("vapals-patients")
 set number=$o(@proot@("sid",sid,"")) 
 ;
 ;@stanza 3 return & termination
 ;
 quit number ; return number; end of $$sid2num
 ;
 ;
ADDPAT(dfn) ; calls newCase to add patient dfn to vapals
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n lien s lien=$o(@lroot@("dfn",dfn,""))
 q:lien=""
 n name s name=$g(@lroot@(lien,"saminame"))
 q:name=""
 n bdy s bdy(1)="saminame="_name_"&dfn="_dfn
 n ARGS,result
 d WSNEWCAS(.ARGS,.bdy,.result)
 ; zwr result
 ;
INDEX ; reindex the vapals-patients graph
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
EOR ; end of routine SAMIHOM3
