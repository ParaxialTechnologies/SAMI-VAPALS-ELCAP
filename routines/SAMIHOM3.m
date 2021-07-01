SAMIHOM3 ;ven/gpl - homepage web service ;2021-06-16T18:10Z
 ;;18.0;SAMI;**5,12**;2020-01;
 ;;1.18.0.12-t2+i12
 ;
 ; Routine SAMIHOM3 contains subroutines for implementing the IELCAP
 ; Home Page and to provide binding to VistA.
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
 ;@license see routine SAMIUL
 ;@documentation see SAMIHUL
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
 ;@last-updated 2021-06-16T18:10Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t2+i12
 ;@release-date 2020-01
 ;@patch-list **5,12**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; see routine SAMIHUL
 ;@contents
 ;
 ;  web services get vapals & post vapals
 ;
 ; WSHOME wsi WSHOME^SAMIHOM3, get vapals (SAMI homepage)
 ; WSVAPALS wsi WSVAPALS^SAMIHOM3, post vapals (main gateway)
 ;
 ;  web pages & web routes
 ;
 ; DEVHOME wpi DEVHOME^SAMIHOM3, development home page
 ; GETHOME wpi GETHOME^SAMIHOM3, get homepage (not subsequent visit)
 ; WSNEWCAS wri WSNEWCAS^SAMIHOM3, newcase (creates new case)
 ;
 ;  private program interfaces
 ;
 ; $$SID2NUM number part of studyid (XXX0001 -> 1)
 ; $$GENSTDID studyID for number
 ; $$PREFIX letters to use to begin studyId
 ; $$KEYDATE date in StudyId format (yyyy-mm-dd)
 ; PREFILL prefill fields for forms
 ;
 ;  private subroutines
 ;
 ; PATLIST returns a list of patients in ary, passed by name
 ; MKSIFORM create intake form
 ;
 ;  unused &/or deprecated subroutines
 ;
 ; $$SCANFOR scan array looking for value, return index
 ; $$NEXTNUM next number for studyid
 ; $$VALDTNM validate a new name
 ; MKSBFORM create background form
 ; ADDPAT-INDEX calls newCase to add patient dfn to vapals
 ;
 ;
 ;
 ;@section 1 web services get vapals & post vapals
 ;
 ;
 ;
 ;@wsi WSHOME^SAMIHOM3, web service get vapals (SAMI homepage)
WSHOME(SAMIRTN,SAMIFILTER) goto WSHOME^SAMIHOM4
 ;
 ;
 ;
 ;@wsi WSVAPALS^SAMIHOM3, web service post vapals (main gateway)
WSVAPALS(SAMIARG,SAMIBODY,SAMIRESULT) goto WSVAPALS^SAMIHOM4
 ; (all calls come through this gateway)
 ;
 ;
 ;
 ;@section 2 web pages & web routes
 ;
 ;
 ;
 ;@wri WSNEWCAS^SAMIHOM3, newcase (creates new case)
WSNEWCAS(SAMIARGS,SAMIBODY,SAMIRESULT) goto WSNEWCAS^SAMIHOM4
 ;
 ;
 ;
 ;@wpi DEVHOME^SAMIHOM3, development home page
DEVHOME(SAMIRTN,SAMIFILTER) goto DEVHOME^SAMIHOM4
 ;
 ;
 ;
 ;@wpi GETHOME^SAMIHOM3, get homepage (not subsequent visit)
GETHOME(SAMIRTN,SAMIFILTER) goto GETHOME^SAMIHOM4
 ;
 ;
 ;
 ;@section 3 private program interfaces
 ;
 ;
 ;
 ;@API $$SID2NUM^SAMIHOM3, number part of study id
SID2NUM(sid) ; number part of studyid (XXX0001 -> 1)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;public;function;clean;silent;sac;tests
 ;@called-by
 ; getVals^%wfhform
 ; WSCASE^SAMICASE
 ; WSNUFORM^SAMICASE
 ; MKBXFORM^SAMICAS3
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; MKSBFORM^SAMICAS3
 ; filename^SAMICTRT
 ; getVals^SAMIZ1
 ;@calls
 ; $$setroot^%wd
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
 new proot set proot=$$setroot^%wd("vapals-patients")
 new number set number=$order(@proot@("sid",sid,"")) 
 ;
 ;@stanza 3 return & termination
 ;
 quit number ; return number; end of $$sid2num
 ;
 ;
 ;
GENSTDID(num,ARG) ; studyID for number
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;tests
 ;@called-by
 ; WSNEWCAS
 ; WSSBFORM^SAMIFWS
 ; WSSIFORM^SAMIFWS
 ; WSCEFORM^SAMIFWS
 ; MOV^SAMIMOV
 ; WSLOOKUP^SAMISRCH
 ;@calls none
 ; $$GETPRFX^SAMIFORM [commented out]
 ;@input
 ; num = number of study id
 ;@output = study id corresponding to number
 ;@examples [tbd]
 ;@tests
 ; UTSTDID^SAMIUTH3
 ;
 ;
 ;@stanza 2 calculate study id
 ;
 new zl set zl=$length(num)
 new zz set zz="00000"
 ;
 ; new studyid set studyid=$$GETPRFX^SAMIFORM(.ARG)_$extract(zz,1,5-zl)_num
 ;
 ; the prefix is determined by the site or siteid, which should be passed
 ; in ARG
 new tsite set tsite=$get(ARG("siteid"))
 if tsite="" set tsite=$get(ARG("site"))
 if tsite="" set tsite="UNK"
 new studyid set studyid=tsite_$extract(zz,1,5-zl)_num
 ;
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
 ;ven/gpl;private;function;clean;silent;sac;tests
 ;@called-by
 ; WSNEWCAS
 ; WSNFPOST^SAMICASE
 ; SAVFILTR^SAMISAV
 ;@calls
 ; $$FMTE^XLFDT
 ;@input
 ; fmdt = date in fileman format
 ;@output = date in study id format
 ;@examples [tbd]
 ;@tests
 ; UTKEYDT^SAMIUTH3
 ;
 ;
 ;@stanza 2 calculate studyid format
 ;
 new zdt set zdt=$$FMTE^XLFDT(fmdt,"7D")
 ;
 new zy set zy=$piece(zdt,"/",1) ; year
 new zm set zm=$piece(zdt,"/",2) ; month
 if $length(zm)=1 set zm="0"_zm
 ;
 new zd set zd=$piece(zdt,"/",3) ; day
 if $length(zd)=1 set zd="0"_zd
 ;
 new studydate set studydate=zy_"-"_zm_"-"_zd
 ;
 ;
 ;@stanza 3 return & termination
 ;
 quit studydate ; return date; end of $$KEYDATE
 ;
 ;
 ;
PREFILL(dfn) ; prefill fields for form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;tests
 ;@called-by
 ; WSNEWCAS
 ; GETHDR^SAMIFLD
 ;@calls
 ; PTINFO^SAMIVSTA
 ; $$setroot^%wd
 ; ^%DT
 ;@input
 ; dfn = patient ien
 ;@output
 ; @root(gien) = ...
 ;  where root = graph root for elcap patients
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 prefill fields
 ;
 ; pull data from VistA
 ;
 ; new ok set ok=$$PTINFO^SAMIVSTA(dfn)
 ; if +ok<1 do ^%ZTER
 ;
 do PTINFO^SAMIVSTA(dfn) ; get additional info on patient
 ;
 ; prefills fields from patient-lookup graph
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new lroot set lroot=$$setroot^%wd("patient-lookup")
 ;
 new lien set lien=$order(@lroot@("dfn",dfn,""))
 quit:lien=""
 ;
 new gien set gien=$order(@root@("dfn",dfn,"")) ; 
 quit:gien=""
 ;
 ; merge prefill fields
 merge @root@(gien)=@lroot@(lien)
 ;
 ; fix format problems
 new saminame set saminame=$get(@root@(gien,"saminame"))
 ;
 ; dob format
 new dob set dob=$get(@lroot@(lien,"sbdob"))
 new X set X=dob
 new Y
 do ^%DT ; convert date to fileman format
 quit:Y=-1
 set dob=Y
 if dob'="" set @root@(gien,"sbdob")=$$VAPALSDT^SAMICASE(dob)
 if dob'="" set @root@(gien,"sidob")=$$VAPALSDT^SAMICASE(dob)
 ;
 ; ssn format
 new ssn set ssn=$get(@lroot@(lien,"ssn"))
 if $length(ssn)=9 set @root@(gien,"sissn")=$extract(ssn,1,3)_"-"_$extract(ssn,4,5)_"-"_$extract(ssn,6,9)
 ;
 ; studyid
 set @root@(gien,"sisid")=@root@(gien,"samistudyid")
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of PREFILL
 ;
 ;
 ;
 ;@section 4 private subroutines
 ;
 ;
 ;
PATLIST(ARY) ; returns a list of patients in ary, passed by name
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;tests
 ;@called-by
 ; DEVHOME
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; ARY = name of array to return patient list in
 ;@output
 ; @ary = array containing list of patients
 ;@examples [tbd]
 ;@tests
 ; UTPTLST^SAMIUTH3
 ;
 ;
 ;@stanza 2 build list of patients
 ;
 new GROOT set GROOT=$$setroot^%wd("vapals-patients")
 ;
 kill @ARY
 new zi set zi=""
 for  do  quit:zi=""
 . set zi=$order(@GROOT@("graph",zi))
 . quit:zi=""
 . set @ARY@(zi)=""
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of PATLIST
 ;
 ;
 ;
MKSIFORM(num) ; create intake form
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;tests
 ;@called-by
 ; WSNEWCAS
 ;@calls
 ; $$setroot^%wd
 ; SSAMISTA^SAMICASE
 ; $$URBRUR^SAMIVSTA
 ; $$NOW^XLFDT
 ; $$VAPALSDT^SAMICASE
 ;@input
 ; num = index where new form should be built
 ;@output
 ; @root(num) = ...
 ;  where root = graph root for elcap patients
 ; @root@("graph")
 ;@examples [tbd]
 ;@tests
 ; UTSIFRM^SAMIUTH3
 ;
 ;
 ;@stanza 2 create & place graph for new intake form
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(num,"samistudyid"))
 quit:sid=""
 ;
 new cdate set cdate=$get(@root@(num,"samicreatedate"))
 quit:cdate=""
 ;
 merge @root@("graph",sid,"siform-"_cdate)=@root@(num)
 ;
 ; update form samistatus to complete
 do SSAMISTA^SAMICASE(sid,"siform-"_cdate,"complete")
 ;
 ;
 ;@stanza 3 init new intake form from vista data
 ;
 new zf set zf=$name(@root@("graph",sid,"siform-"_cdate))
 set @zf@("sipsa")=$get(@root@(num,"address1")) ; primary address
 set @zf@("sipan")=$get(@root@(num,"address2")) ; apartment #
 set @zf@("sipc")=$get(@root@(num,"city")) ; city
 set @zf@("sips")=$get(@root@(num,"state")) ; state
 set @zf@("sipcn")=$get(@root@(num,"county")) ; county
 set @zf@("sipcr")="USA" ; country
 ;
 set @zf@("sipz")=$get(@root@(num,"zip")) ; zip
 if @zf@("sipz")'="" do
 . new zip set zip=@zf@("sipz")
 . quit:zip=""
 . ;
 . new ru set ru=$$URBRUR^SAMIVSTA(zip) ; urban/rural from zip
 . if ru=0 set ru="n"
 . if ru="r"!(ru="u")!(ru="n") set @zf@("sirs")=ru
 . set @root@(num,"sirs")=$get(@zf@("sirs"))
 . quit
 ;
 new phn set phn=$get(@root@(num,"phone")) ; phone #
 if phn["x" set phn=$piece(phn," x",1)
 set @zf@("sippn")=phn
 ;
 set @zf@("sidc")=$$VAPALSDT^SAMICASE($$NOW^XLFDT) ; intake discussion
 set @zf@("sipedc")=$$VAPALSDT^SAMICASE($$NOW^XLFDT) ; pre-enroll disc
 ; set samifirsttime variable for intake form
 set @zf@("samifirsttime")="true"
 ;
 ;
 ;@stanza 3 termination
 ;
 quit "siform-"_cdate ; end of MKSIFORM
 ;
 ;
 ;
 ;@section 5 unused &/or deprecated subroutines
 ;
 ;
 ;
SCANFOR(ary,start,what) ; scan array looking for value
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;tests
 ;@called-by none
 ;@calls: none
 ;@input
 ; .ary = array to scan
 ; start = index to begin scanning at
 ; what = value to scan array for
 ;@output = array index where value was found
 ;@examples [tbd]
 ;@tests
 ; UTSCAN4^SAMIUTH3
 ;
 ;
 ;@stanza 2 scan array
 ;
 new %1 set %1=start
 new limit
 for limit=0:1:1001  do  quit:'%1  quit:ary(%1)[what
 . set %1=$order(ary(%1))
 . quit:'%1
 . quit:ary(%1)[what
 . ; write !,ary(%1)
 . quit
 ;
 new zrtn set zrtn=%1
 if %1<start set zrtn=start
 if %1>1000 set zrtn=start
 ;
 ;
 ;@stanza 3 return & termination
 ;
 quit zrtn ; return array index; end of $$$SCANFOR
 ;
 ;
 ;
NEXTNUM() ; next number for studyid
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;variable;clean;silent;sac;tests
 ;@called-by none
 ; WSNEWCAS [commented out]
 ;@calls
 ; $$setroot^%wd
 ;@input: none
 ;@output = next number for study id
 ;@examples [tbd]
 ;@tests
 ; UTNXTN^SAMIUTH3
 ;
 ;
 ;@stanza 2 calculate next number
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new number set number=$order(@root@("  "),-1)+1
 ;
 ;
 ;@stanza 3 return & termination
 ;
 quit number ; return #; end of $$NEXTNUM
 ;
 ;
 ;
VALDTNM(nm,args) ; validate new name
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;tests
 ;@called-by none
 ; WSNEWCAS [commented out]
 ;@calls none
 ;@input
 ; nm = name to validate
 ; .args = array to return error messages
 ;@output = 1 if valid, -1 if not
 ;@examples [tbd]
 ;@tests
 ; UTVALNM^SAMIUTH3
 ;
 ;
 ;@stanza 2 screen for invalid name
 ;
 if nm'["," do  quit -1
 . set args("saminuerror")="invalid name"
 . quit
 ;
 ;
 ;@stanza 3 return & termination
 ;
 quit 1 ; return success; end of $$VALDTNM
 ;
 ;
 ;
MKSBFORM(num) ; create background form [deprecated]
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;tests
 ;@called-by none
 ; WSNEWCAS [commented out by gpl 2018-06-15]
 ;@calls
 ; $$setroot^%wd
 ; SSAMISTA^SAMICASE
 ;@input
 ; num = index where new form should be built
 ;@output
 ; @root(num) = ...
 ;  where root = graph root for elcap patients
 ; @root@("graph")
 ;@examples [tbd]
 ;@tests
 ; UTSBFRM^SAMIUTH3
 ;
 ;
 ;@stanza 2 build background form & place graph
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(num,"samistudyid"))
 quit:sid=""
 ;
 new cdate set cdate=$get(@root@(num,"samicreatedate"))
 quit:cdate=""
 ;
 merge @root@("graph",sid,"sbform-"_cdate)=@root@(num)
 ;
 ; update form samistatus to complete
 do SSAMISTA^SAMICASE(sid,"sbform-"_cdate,"incomplete")
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of MKSBFORM
 ;
 ;
 ;
ADDPAT(dfn) ; calls newCase to add patient dfn to vapals
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;;private;procedure;clean;silent;sac;tests
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; WSNEWCAS
 ;@falls-thru-to
 ; INDEX
 ;@input
 ; dfn = patient ien
 ;@output
 ; new patient is added to vapals graphstore
 ;@tests
 ; UTADDPT^SAMIUTH3
 ;
 ;
 ;@stanza 2 add patient to graphstore
 ;
 new lroot set lroot=$$setroot^%wd("patient-lookup")
 new lien set lien=$order(@lroot@("dfn",dfn,""))
 quit:lien=""
 ;
 new name set name=$get(@lroot@(lien,"saminame"))
 quit:name=""
 ;
 new bdy set bdy(1)="saminame="_name_"&dfn="_dfn
 new ARGS,result
 ;
 do WSNEWCAS(.ARGS,.bdy,.result) ; add to graphstore
 ; zwrite result
 ;
 ;
INDEX ;@stanza 3 reindex vapals-patients graph
 ;
 ;@falls-thru-from
 ; ADDPAT
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 new zi set zi=0
 for  do  quit:+zi=0
 . set zi=$order(@root@(zi))
 . quit:+zi=0
 . ;
 . new dfn set dfn=@root@(zi,"dfn") ; patient ien
 . new sid set sid=@root@(zi,"samistudyid") ; study id
 . set @root@("dfn",dfn,zi)="" ; patient ien index
 . set @root@("sid",sid,zi)="" ; study id index
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit ; end of ADDPAT-INDEX
 ;
 ;
 ;
EOR ; end of routine SAMIHOM3
