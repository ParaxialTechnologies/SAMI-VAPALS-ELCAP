SAMIHOM4 ;ven/gpl,arc - homepage web services ;2021-10-29t20:25z
 ;;18.0;SAMI;**1,4,5,6,9,12,15,16**;2020-01
 ;18-15
 ;
 ; SAMIHOM4 contains web services & other subroutines for producing
 ; the ELCAP Home Page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@license see routine SAMIUL
 ;@documentation see SAMIHUL
 ;@contents
 ;
 ;  web service get vapals & related subroutines
 ;
 ; WSHOME code for wsi WSHOME^SAMIHOM3
 ;    get vapals (vapals-elcap homepage)
 ; DEVHOME code for wpi DEVHOME^SAMIHOM3
 ;    development home page
 ; GETHOME code for wpi GETHOME^SAMIHOM3
 ;    get homepage (not subsequent visit)
 ;
 ;  web service post vapals & related subroutines
 ;
 ; WSVAPALS code for wsi WSVAPALS^SAMIHOM3
 ;    post vapals (main gateway)
 ;
 ;  other
 ;
 ; REG manual registration
 ; MKPTLK creates patient-lookup record
 ; UPDTFRMS update demographics in all forms for patient
 ; MERGE merge participant records
 ; ADDUNMAT adds unmatched report web service to system
 ; DELUNMAT deletes unmatched web service
 ; WSUNMAT navigates to unmatched report
 ; $$DUPSSN true if duplicate ssn
 ; $$DUPICN true if duplicate icn
 ; $$BADICN true if ICN checkdigits are wrong
 ; SAVE save patient-lookup record after edit
 ; $$REMATCH possible match ien
 ; SETINFO set information message text
 ; SETWARN set warning message text
 ; RTNERR redisplay page w/error message
 ; RTNPAGE display page
 ; REINDXPL reindex patient lookup
 ; INDXPTLK generate index entries in patient-lookup graph
 ; UNINDXPT remove index entries from patient-lookup graph
 ; $$UCASE uppercase
 ; WSNEWCAS code for wr newcase (creates new case)
 ;
 ;@to-do
 ; Add label comments
 ;
 ;
 ;
 ;@section 1 web service get vapals & related subroutines
 ;
 ;
 ;
 ;@wsi-code WSHOME^SAMIHOM3
WSHOME ; get vapals (vapals-elcap homepage)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wsi;procedure;clean;silent;sac;tests
 ;@signature
 ; do WSHOME^SAMIHOM3(SAMIRTN,SAMIFILTER)
 ;@branches-from
 ; WSHOME^SAMIHOM3
 ;@wsi-called-by
 ; web service get vapals
 ; WSVAPALS^SAMIHOM4
 ; LOGIN^SAMISITE
 ;@called-by none
 ;@calls
 ; DEVHOME^SAMIHOM3
 ; WSVAPALS^SAMIHOM3
 ; GETHOME^SAMIHOM3
 ;@input
 ; SAMIFILTER (no parameters required)
 ;@output
 ; .SAMIRTN
 ;@examples [tbd]
 ;@tests
 ; UTWSHM^SAMIUTH3
 ; UTWSHM1^SAMIUTH3
 ; UTWSHM2^SAMIUTH3
 ;
 ;
 ;@stanza 2 route to appropriate homepage or bypass to other webpage
 ;
 ; present development homepage for testing
 if $get(SAMIFILTER("test"))=1 do  quit
 . do DEVHOME^SAMIHOM3(.SAMIRTN,.SAMIFILTER)
 . quit
 ;
 ; bypass for get access to pages
 if $g(SAMIFILTER("samiroute"))'="" do  quit
 . new SAMIBODY set SAMIBODY(1)=""
 . do WSVAPALS^SAMIHOM3(.SAMIFILTER,.SAMIBODY,.SAMIRTN)
 . quit
 ;
 ; V4W/DLW - bypass for get access from CPRS
 if $get(SAMIFILTER("dfn"))'="" do  quit
 . new dfn set dfn=$get(SAMIFILTER("dfn"))
 . new root set root=$$setroot^%wd("vapals-patients")
 . new studyid set studyid=$get(@root@(dfn,"samistudyid"))
 . new SAMIBODY
 . if studyid'="" do
 . . set SAMIBODY(1)="samiroute=casereview&dfn="_dfn_"&studyid="_studyid
 . . quit
 . else  do
 . . set SAMIBODY(1)="samiroute=lookup&dfn="_dfn_"&studyid="_studyid
 . . quit
 . do WSVAPALS^SAMIHOM3(.SAMIFILTER,.SAMIBODY,.SAMIRTN)
 . quit
 ;
 ; default to VAPALS homepage
 do GETHOME^SAMIHOM3(.SAMIRTN,.SAMIFILTER)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wsi WSHOME^SAMIHOM3
 ;
 ;
 ;
 ;@wpi-code DEVHOME^SAMIHOM3
DEVHOME ; development home page
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wpi;procedure;clean;silent;sac;tests
 ;@signature
 ; do DEVHOME^SAMIHOM3(SAMIRTN,SAMIFILTER)
 ;@branches-from
 ; DEVHOME^SAMIHOM3
 ;@wpi-called-by
 ; wsi WSHOME^SAMIHOM3 [web service get vapals]
 ;@called-by none
 ;@calls
 ; htmltb2^%yottaweb
 ; PATLIST^SAMIHOM3
 ; genhtml^%yottautl
 ; addary^%yottautl
 ;@input
 ; SAMIFILTER =
 ;@output
 ;.SAMIRTN =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 present development homepage
 ;
 new gtop,gbot
 do htmltb2^%yottaweb(.gtop,.gbot,"SAMI Test Patients")
 ;
 new html,ary,hpat
 do PATLIST^SAMIHOM3("hpat")
 quit:'$data(hpat)
 ;
 set ary("title")="SAMI Test Patients on this system"
 set ary("header",1)="StudyId"
 set ary("header",2)="Name"
 ;
 new cnt set cnt=0
 new zi set zi=""
 for  do  quit:zi=""
 . set zi=$order(hpat(zi))
 . quit:zi=""
 . ;
 . set cnt=cnt+1
 . new url set url="<a href=""/cform.cgi?studyId="_zi_""">"_zi_"</a>"
 . set ary(cnt,1)=url
 . set ary(cnt,2)=""
 . quit
 ;
 do genhtml^%yottautl("html","ary")
 ;
 do addary^%yottautl("SAMIRTN","gtop")
 do addary^%yottautl("SAMIRTN","html")
 set SAMIRTN($order(SAMIRTN(""),-1)+1)=gbot
 kill SAMIRTN(0)
 ;
 set HTTPRSP("mime")="text/html"
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wpi DEVHOME^SAMIHOM3
 ;
 ;
 ;
 ;@wpi-code GETHOME^SAMIHOM3
GETHOME ; get homepage (not subsequent visit)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wpi;procedure;clean;silent;sac;tests
 ;@signature
 ; do GETHOME^SAMIHOM3(SAMIRTN,SAMIFILTER)
 ;@branches-from
 ; GETHOME^SAMIHOM3
 ;@wpi-called-by
 ; WSHOME
 ; WSVAPALS
 ; SAVE
 ;  WSNEWCAS [commented out]
 ; WSNFPOST^SAMICAS3
 ; WSLOOKUP^SAMISRC2
 ; WSREPORT^SAMIUR
 ; WSREPORT^SAMIUR1
 ;@called-by none
 ;@calls
 ; $$FINDSITE^SAMISITE
 ; GETTMPL^SAMICASE
 ; MERGEHTM^%wf
 ; ADDCRLF^VPRJRUT
 ;@input
 ; SAMIFILTER
 ;@output
 ; .SAMIRTN
 ;@examples [tbd]
 ;@tests
 ; UTGETHM^SAMIUTH3
 ; UTSCAN4^SAMIUTH3
 ;
 ;
 ;@stanza 2 get template for homepage
 ;
 ; Processing for multi-tenancy
 ;
 i $g(HTTPREQ("method"))="GET" d  ;
 . s SAMIFILTER("siteid")=""
 ;
 if $get(SAMIFILTER("siteid"))="" if '$$FINDSITE^SAMISITE(.SAMIRTN,.SAMIFILTER) quit 0
 new SAMISITE,SAMITITL
 set SAMISITE=$get(SAMIFILTER("siteid"))
 set SAMITITL=$get(SAMIFILTER("sitetitle"))
 ;
 new VASITE set VASITE=$$GET1PARM^SAMIPARM("veteransAffairsSite",SAMISITE)
 set SAMIFILTER("veteransAffairsSite")=VASITE
 ;
 new temp,tout,form
 set form="vapals:home"
 do GETTMPL^SAMICASE("temp",form)
 quit:'$data(temp)
 ;
 ;
 ;@stanza 3 process homepage template
 ;
 new err
 do MERGEHTM^%wf(.temp,.SAMIFILTER,.err)
 ;
 do ADDCRLF^VPRJRUT(.temp)
 merge SAMIRTN=temp
 ;
 ;
 ;@stanza 4 termination
 ;
 quit  ; end of wpi GETHOME^SAMIHOM3
 ;
 ;
 ;
 ; below is redacted from GETHOME^SAMIHOM3
 ;
 ;@old-calls
 ; FIXHREF^SAMIFORM
 ; FIXSRC^SAMIFORM
 ; $$GET^XPAR
 ; findReplace^%ts
 ; ADDCRLF^VPRJRUT
 ;
 new cnt set cnt=0
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . ;
 . n ln s ln=temp(zi)
 . n touched s touched=0
 . ;
 . i ln["href" i 'touched d  ;
 . . d FIXHREF^SAMIFORM(.ln)
 . . s temp(zi)=ln
 . ;
 . i ln["src" d  ;
 . . d FIXSRC^SAMIFORM(.ln)
 . . s temp(zi)=ln
 . ;
 . i ln["id" i ln["studyIdMenu" d  ;
 . . s zi=zi+4
 . ;
 . if ln["@@MANUALREGISTRATION@@" do  ; turn off manual registration
 . . n setman,setparm
 . . s setman="true"
 . . s setparm=$$GET^XPAR("SYS","SAMI ALLOW MANUAL ENTRY",,"Q")
 . . i setparm=0 s setman="false"
 . . do findReplace^%ts(.ln,"@@MANUALREGISTRATION@@",setman)
 . . s temp(zi)=ln
 . . quit 
 . set cnt=cnt+1
 . set tout(cnt)=temp(zi)
 . quit
 ;
 ;
 ;@old-stanza 4 add cr/lf & save to return array
 ;
 do ADDCRLF^VPRJRUT(.tout)
 merge SAMIRTN=tout
 ;
 ;
 ;@old-stanza 5 termination
 ;
 quit  ; old end of wpi GETHOME^SAMIHOM3
 ;
 ;
 ;
 ;@section 2 web service post vapals & related subroutines
 ;
 ;
 ;
 ;@wsi-code WSVAPALS^SAMIHOM3
WSVAPALS ; post vapals (main gateway)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wsi;procedure;clean;silent;sac;tests
 ;@signature
 ; do WSVAPALS^SAMIHOM3(SAMIARG,SAMIBODY,SAMIRESULT)
 ;@branches-from
 ; WSVAPALS^SAMIHOM3
 ;@wsi-called-by
 ;@called-by
 ;@calls
 ;@input [tbd]
 ;@output [tbd]
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; all calls come through this gateway
 ;
 k ^SAMIUL("vapals")
 m ^SAMIUL("vapals")=SAMIARG
 m ^SAMIUL("vapals","BODY")=SAMIBODY
 ;
 new vars,SAMIBDY
 set SAMIBDY=$get(SAMIBODY(1))
 do parseBody^%wf("vars",.SAMIBDY)
 m vars=SAMIARG
 i $g(vars("siteid"))'="" d  ;
 . i $g(vars("site"))'=$g(vars("siteid")) s vars("site")=$g(vars("siteid"))
 i $g(vars("site"))="SYS" s vars("site")=""
 i $g(HTTPREQ("method"))="GET" d  ;
 . s vars("site")=""
 m SAMIARG=vars
 m SAMIARG=SAMIBODY
 ;D ^ZTER
 ;
 ; Processing for multi-tenancy
 ;
 if '$d(vars("siteid")) d  ;
 . if $g(vars("studyid"))="" q
 . n sym s sym=$e(vars("studyid"),1,3) ; first 3 chars in studyid
 . i $$SITENM2^SAMISITE(sym)=-1 q
 . s vars("siteid")=sym
 . s vars("site")=sym
 ;
 if $G(vars("site"))'="" d  ;
 . n siteid s siteid=vars("site")
 . s SAMIARG("siteid")=siteid
 . s SAMIARG("sitetitle")=$$SITENM2^SAMISITE(siteid)_" - "_siteid
 k ^gpl("siteselect")
 m ^gpl("siteselect")=SAMIARG
 m ^gpl("siteselect","vars")=vars
 if $G(SAMIARG("siteid"))="" if '$$FINDSITE^SAMISITE(.SAMIRESULT,.SAMIARG) Q 0
 new SAMISITE,SAMITITL
 s SAMISITE=$G(SAMIARG("siteid"))
 i $G(SAMIARG("sitetitle"))="" d  ;
 . s SAMIARG("sitetitle")=$$SITENM2^SAMISITE(SAMISITE)_" - "_SAMISITE
 s SAMITITL=$G(SAMIARG("sitetitle"))
 m vars=SAMIARG
 ;
 k ^SAMIUL("vapals","vars")
 merge ^SAMIUL("vapals","vars")=vars
 merge ^SAMIUL("vapals","vars")=SAMIBODY
 ;
 n route s route=$g(vars("samiroute"))
 ;i route=""  d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home
 i route="" d  q 0
 . n vals
 . s vals("siteid")=""
 . s vals("sitetitle")="Unknown Site"
 . s vals("errorMessage")=""
 . d RTNERR^SAMIHOM4(.SAMIRETURN,"vapals:login",.vals)
 ;
 i route="lookup" d  q 0
 . m SAMIARG=vars
 . d WSLOOKUP^SAMISRC2(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 ;
 i route="login" d  q 0
 . m SAMIARG=vars
 . d LOGIN^SAMISITE(.SAMIRESULT,.SAMIARG)
 ;
 i route="home" d  q 0
 . k ^gpl("home")
 . m ^gpl("home")=SAMIARG
 . s SAMIARG("samiroute")=""
 . d WSHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG)
 ;
 i route="logout" d  q 0
 . ;s SAMIARG("samiroute")="home"
 . ;do WSVAPALS^SAMIHOM3(.SAMIFILTER,.SAMIARG,.SAMIRESULT)
 . ;Q
 . s SAMIARG("sitetitle")="Unknown Site"
 . s SAMIARG("siteid")=""
 . s SAMIARG("errorMessage")=""
 . d RTNERR^SAMIHOM4(.SAMIRESULT,"vapals:login",.SAMIARG)
 ;
 i route="newcase" d  q 0
 . m SAMIARG=vars
 . d WSNEWCAS^SAMIHOM3(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 ;
 i route="casereview" d  q 0
 . m SAMIARG=vars
 . d WSCASE^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 i route="nuform" d  q 0
 . m SAMIARG=vars
 . d WSNUFORM^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 i route="addform" d  q 0
 . m SAMIARG=vars
 . d WSNFPOST^SAMICASE(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 ;
 i route="form" d  q 0
 . m SAMIARG=vars
 . d wsGetForm^%wf(.SAMIRESULT,.SAMIARG)
 ;
 i route="postform" d  q 0
 . m SAMIARG=vars
 . d wsPostForm^%wf(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 . i $g(SAMIARG("form"))["siform" d  ;
 . . n notr s notr=0 ; note return 0 if failure, 1 or greater if success
 . . ; returns the ien of the note that was created and should be sent
 . . s notr=$$NOTE^SAMINOT1(.SAMIARG)
 . . if +notr>0 d  ;
 . . . n SAMIFILTER
 . . . s SAMIFILTER("sid")=$G(SAMIARG("studyid"))
 . . . s SAMIFILTER("key")=$g(SAMIARG("form")) ;
 . . . n tiuien
 . . . s tiuien=+notr
 . . . s SAMIFILTER("notenmbr")=tiuien
 . . . n sendrslt
 . . . ;s sendrslt="1^MSG9239010"
 . . . s sendrslt=$$EN^SAMIORU(.SAMIFILTER) ; send the note to VistA
 . . . i +sendrslt>0 d  ; success
 . . . . n rtnid s rtnid=$p(sendrslt,"^",2) ; return id from HL7
 . . . . ; post the id to the graph here
 . . . . n sid s sid=$G(SAMIARG("studyid"))
 . . . . n form s form=$G(SAMIARG("form"))
 . . . . n nien s nien=$$NTIEN^SAMINOT1(sid,form) ; latest note ien
 . . . . n root s root=$$setroot^%wd("vapals-patients")
 . . . . s @root@("graph",sid,form,"notes",nien,"hl7id")=rtnid
 . . . . s SAMIARG("errorMessage")="Note successfully sent to VistA ID: "_rtnid
 . . . else  d  ;
 . . . . n rtnmsg s rtnmsg=$p(sendrslt,"^",2)
 . . . . s SAMIARG("errorMessage")=rtnmsg
 . . . d WSCASE^SAMICASE(.SAMIRESULT,.SAMIARG)
 . i $g(SAMIARG("form"))["fuform" d  ;
 . . n notr s notr=0 ; note return 0 if failure, 1 or greater if success
 . . ; returns the ien of the note that was created and should be sent
 . . s notr=$$NOTE^SAMINOT2(.SAMIARG)
 . . if +notr>0 d  ;
 . . . n SAMIFILTER
 . . . s SAMIFILTER("sid")=$G(SAMIARG("studyid"))
 . . . s SAMIFILTER("key")=$g(SAMIARG("form")) ;
 . . . n tiuien
 . . . s tiuien=+notr
 . . . s SAMIFILTER("notenmbr")=tiuien
 . . . n sendrslt
 . . . ;s sendrslt="0^Missing ORM Message"
 . . . s sendrslt=$$EN^SAMIORU(.SAMIFILTER) ; send the note to VistA
 . . . i +sendrslt>0 d  ; success
 . . . . n rtnid s rtnid=$p(sendrslt,"^",2) ; return id from HL7
 . . . . ; post the id to the graph here
 . . . . n sid s sid=$G(SAMIARG("studyid"))
 . . . . n form s form=$G(SAMIARG("form"))
 . . . . n nien s nien=$$NTIEN^SAMINOT1(sid,form) ; latest note ien
 . . . . n root s root=$$setroot^%wd("vapals-patients")
 . . . . s @root@("graph",sid,form,"notes",nien,"hl7id")=rtnid
 . . . . s SAMIARG("errorMessage")="Note successfully sent to VistA ID: "_rtnid
 . . . else  d  ;
 . . . . n rtnmsg s rtnmsg=$p(sendrslt,"^",2)
 . . . . i $g(SAMIARG("errorMessage"))="" d  ;
 . . . . . s SAMIARG("errorMessage")=rtnmsg
 . . . d WSCASE^SAMICASE(.SAMIRESULT,.SAMIARG)
 . . e  d WSCASE^SAMICASE(.SAMIRESULT,.SAMIARG)
 . e  d WSCASE^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 i route="deleteform" d  q 0
 . m SAMIARG=vars
 . d DELFORM^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 i route="ctreport" d  q 0
 . m SAMIARG=vars
 . n format s format="html"
 . s format="text"
 . i format="text" d WSNOTE^SAMINOT3(.SAMIRESULT,.SAMIARG) q  ;
 . i format="html" d WSREPORT^SAMICTR0(.SAMIRESULT,.SAMIARG) q  ;
 . ;d wsReport^SAMICTRT(.SAMIRESULT,.SAMIARG)
 ;
 i route="note" d  q 0
 . m SAMIARG=vars
 . d WSNOTE^SAMINOT1(.SAMIRESULT,.SAMIARG)
 ;
 i route="report" d  q 0
 . m SAMIARG=vars
 . d WSREPORT^SAMIUR(.SAMIRESULT,.vars)
 ;
 i route="about" d  q 0
 . m SAMIARG=vars
 . n form
 . s form="vapals:about"
 . d RTNPAGE^SAMIHOM4(.SAMIRESULT,form,.SAMIARG) q  ;
 ;
 i route="addperson" d  q 0
 . m SAMIARG=vars
 . n form
 . s form="vapals:addperson"
 . d RTNPAGE^SAMIHOM4(.SAMIRESULT,form,.SAMIARG) q  ;
 ;
 i route="editperson" d  q 0
 . m SAMIARG=vars
 . n dfn s dfn=$g(vars("dfn")) ; must have a dfn
 . i dfn="" d  q  ;
 . . d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home
 . n root s root=$$setroot^%wd("patient-lookup")
 . n sien s sien=$o(@root@("dfn",dfn,""))
 . i sien="" d  q  ;
 . . d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home
 . s vars("name")=$g(@root@(sien,"saminame"))
 . s tdob=$g(@root@(sien,"dob"))
 . s vars("dob")=$p(tdob,"-",2)_"/"_$p(tdob,"-",3)_"/"_$p(tdob,"-",1)
 . s vars("sbdob")=$g(@root@(sien,"dob"))
 . s vars("gender")=$g(@root@(sien,"sex"))
 . ; s vars("icn")=$g(@root@(sien,"icn"))
 . n tssn s tssn=$g(@root@(sien,"ssn"))
 . s vars("ssn")=$e(tssn,1,3)_"-"_$e(tssn,4,5)_"-"_$e(tssn,6,9)
 . s vars("last5")=$g(@root@(sien,"last5"))
 . s vars("dfn")=$g(@root@(sien,"dfn"))
 . m SAMIARG=vars
 . n form,err,zhtml
 . s form="vapals:editparticipant"
 . d RTNPAGE^SAMIHOM4(.SAMIRESULT,form,.SAMIARG) q  ;
 ;
 i route="register" d  q 0
 . m SAMIARG=vars
 . d REG^SAMIHOM4(.SAMIRESULT,.SAMIARG)
 ; 
 i route="editsave" d  q 0
 . m SAMIARG=vars
 . d SAVE^SAMIHOM4(.SAMIRESULT,.SAMIARG)
 ;
 i route="merge" d  q 0
 . m SAMIARG=vars
 . d MERGE^SAMIHOM4(.SAMIRESULT,.SAMIARG)
 ;
 quit 0  ; end of wsi WSVAPALS^SAMIHOM3
 ;
 ;
 ;
 ;@section 3 other
 ;
 ;
 ;
REG(SAMIRTN,SAMIARG) ; manual registration
 ;
 n name s name=$g(SAMIARG("name"))
 ;
 m ^gpl("reg")=SAMIARG
 n ssn s ssn=SAMIARG("ssn")
 s ssn=$tr(ssn,"-")
 s SAMIARG("errorMessage")=""
 s SAMIARG("errorField")=""
 ; test for duplicate ssn
 ;
 ;i $$DUPSSN(ssn) d  ;
 ;. ;s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Duplicate SSN."
 ;. s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Duplicate SSN error. A person with that SSN is already entered in the system."
 ;. s SAMIARG("errorField")="ssn"
 ;
 ; test for duplicate icn
 ;
 ;n icn s icn=$g(SAMIARG("icn"))
 ;i icn'="" i $$DUPICN(icn) d  ;
 ;. s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Duplicate ICN error. A person with that ICN is already entered in the system."
 ;. s SAMIARG("errorField")="icn"
 ;;
 ;; test for wellformed ICN
 ;;
 ;i icn'="" i $$BADICN(icn) d  ;
 ;. s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Invalid ICN error. The check digits in the ICN do not match"
 ;. s SAMIARG("errorField")="icn"
 ;;
 ; if there is an error, send back to edit with error message
 i $g(SAMIARG("errorMessage"))'="" d  q  ;
 . n form
 . s form="vapals:addperson"
 . d RTNERR(.SAMIRESULT,form,.SAMIARG)
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 n ptlkien s ptlkien=""
 n dfn s dfn=""
 n sien s sien=""
 i ptlkien="" s ptlkien=$o(@root@("AAAAAA"),-1)+1
 n zm
 k SAMIARG("MATCHLOG")
 s zm=$$REMATCH(sien,.SAMIARG)
 i zm>0 d  ;
 . s SAMIARG("MATCHLOG")=zm
 d MKPTLK(ptlkien,.SAMIARG) ; make the patient-lookup record
 ;
 s dfn=$o(@root@("dfn"," "),-1)+1
 n pdfn
 s pdfn=$o(@proot@("dfn"," "),-1)+1
 i pdfn>dfn s dfn=pdfn ; need a dfn that has not been used
 i dfn<9000001 s dfn=9000001
 s @root@(ptlkien,"dfn")=dfn
 d INDXPTLK(ptlkien)
 s SAMIFILTER("samiroute")="addperson"
 s SAMIFILTER("siteid")=$G(SAMIARG("siteid"))
 s SAMIFILTER("sitetitle")=$G(SAMIARG("sitetitle"))
 k SAMIARG ; return to a blank manual registration form
 s SAMIARG("siteid")=$G(SAMIFILTER("siteid"))
 s SAMIARG("sitetitle")=$G(SAMIFILTER("sitetitle"))
 d SETINFO(.SAMIFILTER,name_" was successfully entered")
 ;d SETWARN(.SAMIFILTER,"We might want to give you a warning")
 do WSVAPALS^SAMIHOM3(.SAMIFILTER,.SAMIARG,.SAMIRESULT)
 ;
 quit  ; end of REG
 ;
 ;
 ;
MKPTLK(ptlkien,SAMIARG) ; creates patient-lookup record
 ;
 n ssn s ssn=SAMIARG("ssn")
 s ssn=$tr(ssn,"-")
 n name s name=$g(SAMIARG("name"))
 n sinamef,sinamel
 s sinamel=$p(name,","),sinamel=$$TRIM^XLFSTR(sinamel,"LR")
 s sinamef=$p(name,",",2),sinamef=$$TRIM^XLFSTR(sinamef,"LR")
 s name=sinamel_","_sinamef
 n siteid s siteid=$g(SAMIARG("siteid"))
 i siteid="" s siteid=$g(SAMIARG("site"))
 ;
 s @root@(ptlkien,"siteid")=siteid
 s @root@(ptlkien,"saminame")=name
 s @root@(ptlkien,"sinamef")=sinamef
 s @root@(ptlkien,"sinamel")=sinamel
 n fmdob s fmdob=$$FMDT^SAMIUR2(SAMIARG("dob"))
 n ptlkdob s ptlkdob=$$FMTE^XLFDT(fmdob,7)
 s ptlkdob=$TR(ptlkdob,"/","-")
 s @root@(ptlkien,"dob")=ptlkdob
 s @root@(ptlkien,"sbdob")=ptlkdob
 n gender s gender=SAMIARG("gender")
 s @root@(ptlkien,"gender")=$s(gender="M":"M^MALE",1:"F^FEMALE")
 s @root@(ptlkien,"sex")=SAMIARG("gender")
 ; s @root@(ptlkien,"icn")=SAMIARG("icn")
 s @root@(ptlkien,"ssn")=ssn
 n last5 s last5=$$UCASE($e(name,1))_$e(ssn,6,9)
 s @root@(ptlkien,"last5")=last5
 n mymatch s mymatch=$g(SAMIARG("MATCHLOG"))
 i mymatch'="" s @root@(ptlkien,"MATCHLOG")=mymatch
 ;
 quit  ; end of MKPTLK
 ;
 ;
 ;
UPDTFRMS(dfn) ; update demographics in all forms for patient
 ;
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 n lien s lien=$o(@lroot@("dfn",dfn,""))
 q:lien=""
 n pien s pien=$o(@proot@("dfn",dfn,""))
 q:pien=""
 ; this patient has forms
 m @proot@(pien)=@lroot@(lien) ; refresh the demos in the patient record
 n ssn s ssn=$g(@proot@(pien,"ssn"))
 s @proot@(pien,"sissn")=$e(ssn,1,3)_"-"_$e(ssn,4,5)_"-"_$e(ssn,6,9)
 n sid s sid=$g(@proot@("sisid")) ; studyid 
 q:sid=""  ; no studyid
 n zi s zi=""
 f  s zi=$o(@proot@("graph",sid,zi)) q:zi=""  d  ; for each form
 . m @proot@("graph",sid,zi)=@proot@(pien) ; stamp each form with new demos
 ;
 quit  ; end of UPDTFRMS
 ;
 ;
 ;
MERGE(SAMIRESULT,SAMIARGS) ; merge participant records
 ;
 ; called from pressing the merge button on the unmatched report
 ;
 n toien s toien=$g(SAMIARGS("toien"))
 i toien="" d  q  ;
 . d WSUNMAT(.SAMIRESULT,.SAMIARGS)
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n fromien s fromien=$g(@lroot@(toien,"MATCHLOG"))
 i fromien="" d  q  ;
 . d WSUNMAT(.SAMIRESULT,.SAMIARGS)
 ;
 ; test for remotedfn in from record - not valid if absent
 ;
 i $g(@lroot@(fromien,"remotedfn"))="" d  q  ;
 . d WSUNMAT(.SAMIRESULT,.SAMIARGS)
 ;
 ; remove index entries for from and to records
 ;
 d UNINDXPT(fromien) ; delete index entries
 d UNINDXPT(toien)
 ;
 ; create changelog entry in to record - contains from record
 ;
 m @lroot@(toien,"changelog",$$FMTE^XLFDT($$NOW^XLFDT,5))=@lroot@(fromien)
 ;
 ; change the dfn in the from record to the to record dfn for merging
 ;
 s @lroot@(fromien,"dfn")=@lroot@(toien,"dfn")
 n dfn s dfn=@lroot@(toien,"dfn") ; for use in updating forms
 ;
 ; merge the from record to the to record
 ;
 m @lroot@(toien)=@lroot@(fromien)
 ;
 ; delete the from record
 ;
 k @lroot@(fromien)
 ;
 ; reindex the to record
 ;
 d INDXPTLK(toien)
 ;
 ; propagate the updated from record to every form
 ;
 d UPDTFRMS(dfn) ; updates the patient in the vapals-patient graph
 ;
 ; leave and return to the unmatched report
 ;   note that the form and to records will no longer be in the report
 ;
 d WSUNMAT(.SAMIRESULT,.SAMIARGS)
 ;
 quit  ; end of MERGE
 ;
 ;
 ;
ADDUNMAT ; adds unmatched report web service to system
 ;
 d addService^%webutils("GET","unmatched","WSUNMAT^SAMIHOM4")
 ;
 quit  ; end of ADDUNMAT
 ;
 ;
 ;
DELUNMAT ; deletes unmatched web service
 ;
 d deleteService^%webutils("GET","unmatched")
 ;
 quit  ; end of DELUNMAT
 ;
 ;
 ;
WSUNMAT(SAMIRESULT,SAMIARGS) ; navigates to unmatched report
 ; 
 n filter,bdy
 s bdy=""
 ;s filter("siteid")="PHX"
 s filter("samiroute")="report"
 s filter("samireporttype")="unmatched"
 d WSVAPALS^SAMIHOM3(.filter,.bdy,.SAMIRESULT) ; back to the unmatched report
 ;
 quit  ; end of WSUNMAT
 ;
 ;
 ;
DUPSSN(ssn) ; extrinsic returns true if duplicate ssn
 ;
 n proot s proot=$$setroot^%wd("patient-lookup")
 i $d(@proot@("ssn",ssn)) q 1
 ;
 quit 0 ; end of $$DUPSSN
 ;
 ;
 ;
DUPICN(icn) ; extrinsic returns true if duplicate icn
 ;
 n proot s proot=$$setroot^%wd("patient-lookup")
 n tmpicn s tmpicn=$p(icn,"V",1)
 i $d(@proot@("icn",icn)) q 1
 i $d(@proot@("icn",tmpicn)) q 1
 ;
 quit 0 ; end of $$DUPICN
 ;
 ;
 ;
BADICN(icn) ; extrinsic returns true if ICN checkdigits are wrong
 ;
 n zchk s zchk=$p(icn,"V",2)
 n zicn s zicn=$p(icn,"V",1)
 q:zchk="" 1
 i zchk'=$$CHECKDG^MPIFSPC(zicn) q 1
 ;
 quit 0
 ;
 ;
 ;
SAVE(SAMIRESULT,SAMIARG) ; save patient-lookup record after edit
 ;
 n dfn s dfn=$g(vars("dfn")) ; must have a dfn
 i dfn="" d  q  ;
 . d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home 
 n root s root=$$setroot^%wd("patient-lookup")
 n sien s sien=$o(@root@("dfn",dfn,""))
 i sien="" d  q  ;
 . d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home 
 d UNINDXPT(sien) ; remove old index entries
 n zm
 k SAMIARG("MATCHLOG")
 s zm=$$REMATCH(sien,.SAMIARG)
 i zm>0 d  ;
 . s SAMIARG("MATCHLOG")=zm
 d MKPTLK(sien,.SAMIARG) ; add the updated fields
 d INDXPTLK(sien) ; create new index entries
 d UPDTFRMS(dfn) ; update demographic info in all forms
 n filter,bdy
 s bdy=""
 m filter=SAMIARG
 s filter("samiroute")="report"
 s filter("samireporttype")="unmatched"
 d WSVAPALS^SAMIHOM3(.filter,.bdy,.SAMIRESULT) ; back to the unmatched report
 ;
 quit  ; end of SAVE
 ;
 ;
 ;
REMATCH(sien,SAMIARG) ; extrinsic returns possible match ien
 ;
 ; else zero
 ;
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n ssn,name,icn,x,y
 s ssn=$g(SAMIARG("ssn"))
 i ssn["-" s ssn=$tr(ssn,"-")
 s name=$g(SAMIARG("saminame"))
 i name="" s name=$g(SAMIARG("name"))
 s name=$$UCASE(name)
 ; s icn=$g(SAMIARG("icn"))
 s x=0
 i ssn'="" s x=$o(@lroot@("ssn",ssn,""))
 i x=sien s x=$o(@lroot@("ssn",ssn,x))
 i +x'=0 d  ;
 . s y=$g(@lroot@(x,"dfn"))
 . ;i y>9000000 s x=0
 i x>0 q x
 i name'="" s x=$o(@lroot@("name",name,""))
 i x=sien s x=$o(@lroot@("name",name,x))
 i +x'=0 d  ;
 . s y=$g(@lroot@(x,"dfn"))
 . ;i y>9000000 s x=0
 i x>0 q x
 ;i icn'="" s x=$o(@lroot@("icn",icn,""))
 ;i x=sien s x=$o(@lroot@("icn",icn,x))
 ;i +x'=0 d  ;
 ;. s y=$g(@lroot@(x,"dfn"))
 ;. i y>9000000 s x=0
 ;i x>0 q x
 ;
 quit 0 ; end of $$REMATCH
 ;
 ;
 ;
SETINFO(vars,msg) ; set information message text
 ;
 ; vars are the screen variables passed by reference
 ;
 s vars("infoMessage")=msg
 ;
 quit  ; end of SETINFO
 ;
 ;
 ;
SETWARN(vars,msg) ; set warning message text
 ;
 ; vars are the screen variables passed by reference
 ;
 s vars("warnMessage")=msg
 ;
 quit  ; end of SETWARN
 ;
 ;
 ; 
RTNERR(rtn,form,vals,msg,fld) ; redisplay page w/error message
 ;
 ; rtn is the return array
 ; form is the form the page requires
 ; vals are the values for the page. passed by reference
 ; msg is the error message to be displayed
 ; fld is the name of the field where the cursor should be put
 ;
 n zhtml ; work area for the tempate
 d SAMIHTM^%wf(.zhtml,form,.err)
 d MERGEHTM^%wf(.zhtml,.vals,.err)
 m rtn=zhtml
 set HTTPRSP("mime")="text/html" ; set mime type
 ;
 quit  ; end of RTNERR
 ;
 ;
 ;
RTNPAGE(rtn,form,vals) ; display page
 ;
 ; rtn is the return array
 ; form is the form the page requires
 ; vals are the values for the page. passed by reference
 ;
 n err
 n zhtml ; work area for the tempate
 d SAMIHTM^%wf(.zhtml,form,.err)
 d MERGEHTM^%wf(.zhtml,.vals,.err)
 m SAMIRESULT=zhtml
 set HTTPRSP("mime")="text/html" ; set mime type
 ;
 quit  ; end of RTNPAGE
 ;
 ;
 ;
REINDXPL ; reindex patient lookup
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 n zi s zi=0
 k @root@("ssn")
 k @root@("name")
 k @root@("last5")
 k @root@("sinamef")
 k @root@("sinamel")
 ; k @root@("icn")
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . d INDXPTLK(zi)
 ;
 quit  ; end of REINDXPL
 ;
 ;
 ;
INDXPTLK(ien) ; generate index entries in patient-lookup graph
 ;
 ; for entry ien
 ;
 n proot set proot=$$setroot^%wd("patient-lookup")
 n name s name=$g(@proot@(ien,"saminame"))
 s @proot@("name",name,ien)=""
 n ucname s ucname=$$UCASE(name)
 s @proot@("name",ucname,ien)=""
 n x
 s x=$g(@proot@(ien,"dfn")) ;w !,x
 s:x'="" @proot@("dfn",x,ien)=""
 s x=$g(@proot@(ien,"last5")) ;w !,x
 s:x'="" @proot@("last5",x,ien)=""
 ;
 ; s x=$g(@proot@(ien,"icn")) ;w !,x
 ; i x'["V" d  ;
 ; . i x="" q
 ; . n chk s chk=$$CHECKDG^MPIFSPC(x)
 ; . s @proot@(ien,"icn")=x_"V"_chk
 ; . s x=x_"V"_chk
 ; s:x'="" @proot@("icn",x,ien)=""
 ;
 s x=$g(@proot@(ien,"ssn")) ;w !,x
 s:x'="" @proot@("ssn",x,ien)=""
 s x=$g(@proot@(ien,"sinamef")) ;w !,x
 s:x'="" @proot@("sinamef",x,ien)=""
 s x=$g(@proot@(ien,"sinamel")) w !,x
 s:x'="" @proot@("sinamel",x,ien)=""
 set @proot@("Date Last Updated")=$$HTE^XLFDT($horolog)
 ;
 quit  ; end of INDXPTLK
 ;
 ;
 ;
UNINDXPT(ien) ; remove index entries from patient-lookup graph
 ;
 ; for entry ien
 ;
 n proot set proot=$$setroot^%wd("patient-lookup")
 n name s name=$g(@proot@(ien,"saminame"))
 k @proot@("name",name,ien)
 n ucname s ucname=$$UCASE(name)
 k @proot@("name",ucname,ien)
 n x
 s x=$g(@proot@(ien,"dfn")) ;w !,x
 k:x'="" @proot@("dfn",x,ien)
 s x=$g(@proot@(ien,"last5")) ;w !,x
 k:x'="" @proot@("last5",x,ien)
 ;
 ; s x=$g(@proot@(ien,"icn")) ;w !,x
 ; i x'["V" d  ;
 ; . i x="" q
 ; . n chk s chk=$$CHECKDG^MPIFSPC(x)
 ; . s @proot@(ien,"icn")=x_"V"_chk
 ; . s x=x_"V"_chk
 ; k:x'="" @proot@("icn",x,ien)
 ;
 s x=$g(@proot@(ien,"ssn")) ;w !,x
 k:x'="" @proot@("ssn",x,ien)
 s x=$g(@proot@(ien,"sinamef")) ;w !,x
 k:x'="" @proot@("sinamef",x,ien)
 s x=$g(@proot@(ien,"sinamel")) w !,x
 k:x'="" @proot@("sinamel",x,ien)
 set @proot@("Date Last Updated")=$$HTE^XLFDT($horolog)
 ;
 quit  ; end of UNINDXPT
 ;
 ;
 ;
UCASE(STR) ; extrinsic returns uppercase of STR
 ;
 N X,Y
 S X=STR
 X ^%ZOSF("UPPERCASE")
 ;
 quit Y ; end of $$UCASE
 ;
 ;
 ;
 ;@wri-code WSNEWCAS^SAMIHOM3
WSNEWCAS ; web route newcase (creates new case)
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;wri;procedure;
 ;@signature
 ; do WSNEWCAS^SAMIHOM3(SAMIARGS,SAMIBODY,SAMIRESULT)
 ;@branches-from
 ; wri WSNEWCAS^SAMIHOM3 [wr newcase]
 ;@wri-called-by
 ; wsi WSVAPALS^SAMIHOM3 [ws post vapals]
 ;@called-by none
 ;@calls
 ; parseBody^%wf
 ; $$setroot^%wd
 ;  $$VALDTNM [commented out]
 ;  GETHOME [commented out]
 ;  $$NEXTNUM [commented out]
 ; $$GENSTDID^SAMIHOM3
 ; $$NOW^XLFDT
 ; $$KEYDATE^SAMIHOM3
 ; PREFILL^SAMIHOM3
 ;  makeSbform [commented out]
 ; $$MKSIFORM^SAMIHOM3
 ; wsGetForm^%wf
 ;  WSCASE^SAMICASE [commented out]
 ;@input
 ;.ARGS =
 ; BODY =
 ;.RESULT =
 ;@output: ?
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 create new case
 ;
 merge ^SAMIUL("newCase","ARGS")=SAMIARGS
 merge ^SAMIUL("newCase","BODY")=SAMIBODY
 ;
 new vars,bdy
 set SAMIBDY=$get(SAMIBODY(1))
 if SAMIBDY="" M vars=SAMIARGS
 else  do parseBody^%wf("vars",.SAMIBDY)
 merge ^SAMIUL("newCase","vars")=vars
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 new saminame set saminame=$get(vars("name"))
 if saminame="" s saminame=$get(vars("saminame"))
 ;if $$VALDTNM(saminame,.ARGS)=-1 do  quit  ;
 ;. new r1
 ;. do GETHOME(.r1,.ARGS) ; home page to redisplay
 ;. merge RESULT=r1
 ;. quit
 ;
 new dfn s dfn=$get(vars("dfn"))
 ;if dfn="" do  quit  ;
 ;. new r1
 ;. do GETHOME(.r1,.ARGS) ; home page to redisplay
 ;. merge RESULT=r1
 ;. quit
 ;
 ; new gien set gien=$$NEXTNUM
 new gien set gien=dfn
 ;
 merge ^SAMIUL("newCase","G1")=root
 ; create dfn index
 set @root@("dfn",dfn,gien)=""
 ;
 set @root@(gien,"saminum")=gien
 set @root@(gien,"saminame")=saminame
 ;
 new studyid set studyid=$$GENSTDID^SAMIHOM3(gien,.SAMIARGS)
 set @root@(gien,"samistudyid")=studyid
 set @root@("sid",studyid,gien)=""
 ;
 new datekey set datekey=$$KEYDATE^SAMIHOM3($$NOW^XLFDT)
 set @root@(gien,"samicreatedate")=datekey
 ;
 merge ^SAMIUL("newCase",gien)=@root@(gien)
 ;
 ;
 do PREFILL^SAMIHOM3(dfn) ; prefills from the "patient-lookup" graph
 ;
 new siformkey
 ; do makeSbform(gien) ; create background form for new patient
 set siformkey=$$MKSIFORM^SAMIHOM3(gien) ; create intake for new patient
 ;
 set SAMIARGS("studyid")=studyid
 set SAMIARGS("form")="vapals:"_siformkey
 do wsGetForm^%wf(.SAMIRESULT,.SAMIARGS)
 ; do WSCASE^SAMICASE(.SAMIRESULT,.SAMIARGS) ; navigate to case review page
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of wri WSNEWCAS^SAMIHOM3
 ;
 ;
 ;
EOR ; end of routine SAMIHOM4
