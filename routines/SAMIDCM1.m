SAMIDCM1 ;ven/gpl - import patient from siemens ai; 2024-09-09t16:33z
 ;;18.0;SAMI;**16,17,18**;2020-01-17;Build 7
 ;mdc-e1;SAMIDCM1-20240909-E2LXhrL;SAMI-18-18-b1
 ;mdc-v7;B233069568;SAMI*18.0*18 SEQ #18
 ;
 ; SAMIDCM1 contains services to support importing a patient into
 ; ScreeningPlus from the Siemens AI.
 ;
 quit  ; no entry from top
 ;
 ;@license: see routine SAMIUL
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
 ;@license see routine SAMIUL
 ;
 ;@update 2024-09-09t16:33z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module import/export - SAMIDCM
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-17
 ;@edition-date 2020-01-17
 ;@patches **16,17,18**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@module-credits
 ;
 ;@project VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding 2017/2021, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org Paraxial Technologies (par)
 ; http://paraxialtech.com/
 ;@partner-org Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@project I-ELCAP AIRS Automated Image Reading System
 ; https://www.ielcap-airs.org
 ;@funding 2024, Mt. Sinai Hospital (msh)
 ;@partner-org par
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2024-08-07 ven/gpl 18-17-b5 b0b30440
 ;  SAMIDCM1 (F2kt1Ls B105843717 E3RA5X%)
 ; add web service to send img transactions: in MKSVC add service post
 ; dcmimgin.
 ;
 ; 2024-08-10 ven/gpl 18-17-b5 dd7c2196
 ;  SAMIDCM1 (F1XOyAb B109906029 E2Dhqcd)
 ; accept img json format: in WSDCMIN process @gp@("PatientName"); in
 ; normaliz handle Dicom separator.
 ;
 ; 2024-08-12 ven/lmry 18-17-b5 eea98cdb
 ;  SAMIDCM1 (F3XvGle B114466365 E%EcRX)
 ; bump dates + vers, add log.
 ;
 ; 2024-08-16 ven/lmry 18-17-b6 a1a28de6
 ;  SAMIDCM1 (F1Lt37K B115986477 E1B17x2)
 ; update history, dates, + vers of routines for 18-17-b6.
 ;
 ; 2024-08-21/22 ven/toad 18-17-b6
 ;  SAMIDCM1 update version-control lines, dates, history, annotate;
 ; getsid>GETSID, normaliz>NORMALIZ.
 ;
 ; 2024-08-26 ven/toad 18-17-b8 bd5cfb4c
 ;  SAMIDCM1 (F1ZaHnp B200371935 ErbJMe)
 ; Rick's revisions of the 14 routines + recipe file: passim.
 ;
 ; 2024-08-26 ven/mcglk 18-17-b8 a5dae8e9 [in temp v18-17-b6-sinai]
 ;  SAMIDCM1 (F1ZaHnp B200371935 ErbJMe)
 ; Imported M routines from commit bd5cfb4c1d58. NOTE: This history
 ; will be lost.
 ;
 ; 2024-09-04 ven/toad 18-17-b8 9a98cb08 [in temp v18-17-b6-sinai]
 ;  SAMIDCM1 (F2CEdt9 B200371935 ErbJMe)
 ; version & checksums: SAMI-18-17-b8.
 ;
 ; 2024-09-06 ven/mcglk 18-17-b8 ffdb0310
 ;  SAMIDCM1 (F2CEdt9 B200371935 ErbJMe)
 ; Pulling in more modified routines from 18-17-b8.
 ;
 ; 2024-09-08 ven/gpl 18-18-b1 e04caa1a
 ;  SAMIDCM1 (F1wj36B B210253473 Ea3qP)
 ; fixing an emrn processing bug: in WSDCMIN add patid chk for
 ; @gp@("PatientID"); in $$MATCH add MRN support.
 ;
 ; 2024-09-09 ven/toad 18-18-b1
 ;  SAMIDCM1 (F??? B233069568 E???)
 ; bump version, complete log, in MKSVC add subrtn hdr comments.
 ;
 ;@to-do
 ;  fill in log before 18-17
 ;
 ;@contents
 ;
 ;  1. web services & direct-mode service:
 ; WSDCMIN web services post dcmin & dcmimgin, receive from addpatient
 ; WSDCMQ web service get dcmquery, return dcm json
 ; WSDCMKIL web service get dcmreset, kill all but 1st entry in dcm-intake
 ; T1 TEST CREATE A JOHN DOE PATIENT
 ;
 ;  2. supplementary subroutines:
 ; $$MATCH match message with an existing record
 ; $$NORMALIZ normalize the name
 ; $$nxtdfn next available dfn
 ;
 ;  3. unused supplementary subroutines:
 ; $$GETSID studyid
 ; IDXDCM index a dcm entry after patient record creation
 ;
 ;  4. init subroutine to create web services:
 ; MKSVC create web services
 ;
 ;
 ;
 ;
 ;@ws WSDCMIN^SAMIDCM1 web services post dcmin & dcmimgin
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ws;procedure;clean?;silent;sac?;??% tests;port?
 ;@called-by
 ; web service post dcmin
 ; web service post dcmimgin
 ;@calls
 ; $$DUZ^SYNDHP69 [commented out]
 ; $$setroot^%wd
 ; decode^%webjson
 ; indexFhir [commented out]
 ; $$NORMALIZ
 ; $$MATCH^SAMIDCM1
 ; CREATE^SAMIZPH1
 ; encode^%webjson
 ;@input
 ; ARGS =
 ; BODY =
 ; RESULT =
 ; ien =
 ;@output [tbd]
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
WSDCMIN(ARGS,BODY,RESULT,ien) ; receive from addpatient
 ;
 s U="^"
 ;S DUZ=1
 ;S DUZ("AG")="V"
 ;S DUZ(2)=500
 ;N USER S USER=$$DUZ^SYNDHP69
 ;
 new json,root,gr,id,return
 set root=$$setroot^%wd("dcm-intake")
 if $get(ien)="" do
 . set ien=$order(@root@(" "),-1)+1
 . set gr=$name(@root@(ien,"json"))
 . do decode^%webjson("BODY",gr)
 . kill BODY ;
 . q
 ;
 ;do indexFhir(ien)
 ;
 set site=$get(ARGS("siteid"))
 if site="" set site="XXX" ; default to test site
 if site'="" set @root@("SITE",site,ien)="" ;
 ;
 ; patient name
 ;
 ;
 n gp s gp=$na(@root@(ien,"json","patient_study_details"))
 i '$d(@gp) d  ;
 . s gp=$na(@root@(ien,"patient_details"))
 . q:$d(@gp)
 . s gp=$na(@root@(ien,"json"))
 . q:$d(@gp@("PatientName"))
 . s return("error")="Missing patient study details"
 . q
 ;
 ;patient_study_details 
 ;--Frame of Reference UID 1.3.6.1.4.1.14519.5.2.1.6279.6001.178796764874541005921876698858
 ;--Manufacturer Siemens Healthineers
 ;--Manufacturer's Model Name AIRC Research
 ;--Patient ID LIDC-IDRI-0492
 ;--Patient's Birth Date 
 ;--\s 
 ;--Patient's Name 
 ;--\s 
 ;--Patient's Sex F
 ;--SOP Class UID 1.2.840.10008.5.1.4.1.1.88.34
 ;--Series Description AIRC Research Structured Report
 ;--Slice Thickness 1
 ;--\n 1.0
 ;--Study Date 20000101
 ;--\s 
 ;--Tracking Identifier L2
 ;--Tracking Unique Identifier
 ;
 d  ; Extract Identifying information
 . n vars
 . n name s name=$g(@gp@("Patient's Name"))
 . i name="" s name=$g(@gp@("PatientName"))
 . i name="" s vars("name")=name
 . e  s vars("name")=$$NORMALIZ(name)
 . n dob s dob=$g(@gp@("Patient's Birth Date"))
 . i dob="" s dob=20000302
 . s vars("dob")=dob
 . n gender s gender=$g(@gp@("Patient's Sex"))
 . i gender="" s gender="M"
 . s vars("gender")=gender
 . n patid s patid=$g(@gp@("Patient ID"))
 . i patid="" s patid=$g(@gp@("PatientID"))
 . s vars("patid")=patid
 . n studyDate s studyDate=$g(@gp@("Study Date"))
 . i studyDate'="" s vars("studyDate")=studyDate
 . n trackID s trackID=$g(@gp@("Tracking Identifier"))
 . s vars("trackingIdentifier")=trackID
 . s vars("site")=site
 . s vars("ssn")=999999999
 . s vars("sistatus")="active"
 . ;
 . i '$$MATCH^SAMIDCM1(.vars) d CREATE^SAMIZPH1(.vars)
 . m @root@(ien)=vars
 . s name=$g(vars("name"))
 . i name'="" s @root@("name",name,ien)=""
 . n studyid s studyid=$g(vars("studyid"))
 . i studyid'="" s @root@("studyid",studyid,ien)=""
 . n dfn s dfn=$g(vars("dfn"))
 . i dfn'="" s @root@("dfn",dfn,ien)=""
 . i patid'="" s @root@("patid",patid,ien)=""
 . q
 ;
 ;
 set return("status")="ok"
 set return("siteid")=site
 set return("ien")=ien
 ;
 if $get(ARGS("returngraph"))=1 do  ;
 . merge return("graph")=@root@(ien)
 . q
 ;
 n jary
 m jary("result")=return
 d encode^%webjson("jary","RESULT")
 s HTTPRSP("mime")="application/json"
 ;
 quit  ; end of ws WSDCMIN^SAMIDCM1
 ;
 ;
 ;
 ;
 ;@ws-code WSDCMQ^SAMIDCM1 web service get dcmquery
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ws;procedure;clean?;silent;sac?;??% tests;port?
 ;@called-by
 ; web service get dcmquery
 ;@calls
 ; $$setroot^%wd
 ; encode^%webjson
 ;@input
 ; return =
 ; filter =
 ;@output [tbd]
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
WSDCMQ(return,filter) ; return dcm json
 ;
 n root s root=$$setroot^%wd("dcm-intake")
 n sid s sid=$g(filter("studyid"))
 i sid="" s sid=$g(filter("sid"))
 i sid="" q ""
 n ien s ien=$o(@root@("studyid",sid,""))
 i ien="" q ""
 ;n ien s ien=$o(@root@(" "),-1)
 ;
 n jary,json
 n cnt s cnt=0
 s ien=""
 f  s ien=$o(@root@("studyid",sid,ien)) q:ien=""  d  ;
 . s cnt=cnt+1
 . m jary("result",cnt)=@root@(ien,"json")
 . q
 d encode^%webjson("jary","return")
 ;
 quit  ; end of ws WSDCMQ^SAMIDCM1
 ;
 ;
 ;
 ;
 ;@ws-code WSDCMKIL^SAMIDCM1 web service get dcmreset
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ws;procedure;clean?;silent;sac?;??% tests;port?
 ;@called-by
 ; web service get dcmreset
 ;@calls
 ; $$setroot^%wd
 ; UNINDXPT^SAMIHOM4
 ; INDXPTLK^SAMIHOM4
 ;@input
 ; return =
 ; filter =
 ;@output [tbd]
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
WSDCMKIL(return,filter) ; kill all but the 1st entry in dcm-intake
 ;
 n lroot,proot,droot
 n lien,pien,dien s (lien,pien,dien)=""
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patient")
 s droot=$$setroot^%wd("dcm-intake")
 ;
 n nam s nam="DOE"
 f i="DOE","PATIENT" d  ;
 . s nam=i
 . f  s nam=$o(@lroot@("name",nam)) q:nam=""  q:nam'[i  d  ;
 . . f  s lien=$o(@lroot@("name",nam,lien)) q:lien=""  d  ;
 . . . ;w !,nam," ",lien
 . . . d UNINDXPT^SAMIHOM4(lien)
 . . . n newnam
 . . . s newnam="ZZZ"_$e(nam,4,$l(nam))
 . . . s @lroot@(lien,"saminame")=newnam
 . . . s @lroot@(lien,"name")=newnam
 . . . s @lroot@(lien,"fname")=$p(newnam,",",2)
 . . . s @lroot@(lien,"lname")=$p(newnam,",",1)
 . . . d INDXPTLK^SAMIHOM4(lien)
 . . . q
 . . q
 . q
 ;
 n atmp s atmp=@droot@(0)
 k @droot
 s @droot@(0)=atmp
 ;i $d(^webbak(587)) d  ;
 ;. m @droot=^webbak(587) ; restore default
 i $d(^webbak(667)) d  ;
 . m @droot=^webbak(667) ; restore default
 . n sid,sidien
 . ;f dfn="9000227"  d  ;
 . f dfn="9000057","9000058" d  ;
 . . s lien=$o(@lroot@("dfn",dfn,""))
 . . q:lien=""
 . . d UNINDXPT^SAMIHOM4(lien)
 . . n newname
 . . s newname="DOE"_dfn_",JOHN"
 . . s @lroot@(lien,"name")=newname
 . . s @lroot@(lien,"saminame")=newname
 . . s @lroot@(lien,"fname")=$p(newname,",",2)
 . . s @lroot@(lien,"lname")=$p(newname,",",1)
 . . d INDXPTLK^SAMIHOM4(lien)
 . . q
 . q
 ;
 quit  ; end of ws WSDCMKIL^SAMIDCM1
 ;
 ;
 ;
 ;
 ;n root s root=$$setroot^%wd("dcm-intake")
 ;n sid s sid=$g(@root@(1,"sid"))
 ;i sid="" s sid="XXX0023"
 ;n atmp m atmp=@root@(1)
 ;d purgegraph^%wd("dcm-intake")
 ;s root=$$setroot^%wd("dcm-intake")
 ;m @root@(1)=atmp
 ;s @root@("sid",sid,1)=""
 q
 ;
 ;
 ;
 ;
 ;@dms T1^SAMIDCM1
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;dms;procedure;clean?;silent;sac?;??% tests;port?
 ;@called-by [tbd]
 ;@calls
 ; $$nxtdfn^SAMIDCM1
 ; CREATE^SAMIZPH1
 ;@input [tbd]
 ;@output [tbd]
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
T1() ; TEST CREATE A JOHN DOE PATIENT
 ;
 D  ;
 . n vars
 . s vars("dob")=20000302
 . s vars("gender")="M"
 . n nxtdfn s nxtdfn=$$nxtdfn^SAMIDCM1()
 . s vars("saminame")="DOE"_nxtdfn_",JOHN"
 . s vars("name")=vars("saminame")
 . s vars("site")="XXX"
 . s vars("ssn")=999999999
 . s vars("sistatus")="active"
 . d CREATE^SAMIZPH1(.vars)
 . x "ZWR vars"
 . q
 ;
 quit  ; end of T1
 ;
 ;
 ;
 ;
 ;@section 2 supplementary subroutines
 ;
 ;
 ;
 ;
 ;@func $$MATCH^SAMIDCM1
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean?;silent;sac?;??% tests;port?
 ;@called-by
 ; WSDCMIN^SAMIDCM1
 ;@calls
 ; $$setroot^%wd
 ; $$NORMALIZ
 ; ENROLL^SAMIZPH1
 ;@input
 ; vars =
 ;@output = normalized name
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
MATCH(vars) ; extrinsic which tries to match the message with an
 ; existing record
 ;
 n lroot,proot,droot
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 s droot=$$setroot^%wd("dcm-intake")
 n found s found=0
 n name s name=$$NORMALIZ($g(vars("name")))
 n patid s patid=$g(vars("patid"))
 s vars("simrn")=patid
 n dien,lien,pien
 ;
 ; first look at the dcm-intake for name matches
 s dien=$o(@droot@("mrn",patid,""))
 i dien="" s dien=$o(@droot@("name",name,""))
 i dien'="" d  ; the name or mrn has been found locally
 . s found=1
 . n dfn,studyid
 . s dfn=$g(@droot@(dien,"dfn"))
 . i dfn'="" s vars("dfn")=dfn
 . i dfn="" s found=0 q  ;
 . s studyid=$g(@droot@(dien,"studyid"))
 . i studyid="" s found=0 q  ;
 . i studyid'="" s vars("studyid")=studyid
 . s vars("simrn")=patid
 . q
 ;
 if found=1 q found
 ;
 i dien="" d  ; not here, check patient-lookup
 . n patid s patid=$g(vars("patid"))
 . s lien=$o(@lroot@("mrn",patid,""))
 . i lien="" s lien=$o(@lroot@("name",name,""))
 . i lien="" s found=0 q  ;
 . i lien'="" s found=1
 . n dfn,studyid
 . s dfn=$g(@lroot@(lien,"dfn"))
 . s vars("dfn")=dfn
 . i dfn="" s found=0 q  ;
 . s pien=$o(@proot@("dfn",dfn,""))
 . d ENROLL^SAMIZPH1(.vars)
 . s pien=$o(@proot@("dfn",dfn,""))
 . i pien="" s found=0 q  ;
 . s studyid=$g(@proot@(pien,"studyid"))
 . s vars("studyid")=studyid
 . i studyid="" s found=0 q  ;
 . s vars("simrn")=patid
 . q
 ;
 quit found ; end of $$MATCH^SAMIDCM1
 ;
 ;
 ;
 ;
 ;@func $$NORMALIZ^SAMIDCM1
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean?;silent;sac?;??% tests;port?
 ;@called-by
 ; WSDCMIN^SAMIDCM1
 ; $$MATCH^SAMIDCM1
 ;@calls none
 ;@input
 ; name =
 ;@output = normalized name
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
NORMALIZ(name) ; extrinsic which tries to normalize the name
 ;
 n znam s znam=name
 i name["^" d  q znam  ;; if name has Dicom separator
 . s znam=$tr(znam,"^",",")
 . q
 ;
 i name'["," d  ; if no comma, then try a space
 . i $l(name," ")>0 d  ;
 . . n fnam,lnam
 . . s fnam=$p(name," ",1)
 . . s lnam=$p(name," ",$l(name," "))
 . . s fnam=$p(name,lnam,1)
 . . s znam=lnam_","_fnam
 . . q
 . q
 ;
 quit znam ; end of $$NORMALIZ^SAMIDCM1
 ;
 ;
 ;
 ;
 ;@var $$nxtdfn^SAMIDCM1
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;variable;clean?;silent;sac?;??% tests;port?
 ;@called-by
 ; T1^SAMIDCM1
 ; REGISTER^SAMILD2
 ; REGISTER^SAMILOAD
 ; REGISTER^SAMIZPH1
 ;@calls
 ; $$setroot^%wd
 ;@input [tbd]
 ;@output = available dfn
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
nxtdfn() ; next available dfn
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 ;
 q $o(@root@("dfn"," "),-1)+1 ; end of $$nxtdfn^SAMIDCM1
 ;
 ;
 ;
 ;
 ;@section 3 unused supplementary subroutines
 ;
 ;
 ;
 ;
 ;@func $$GETSID^SAMIDCM1
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean?;silent;sac?;??% tests;port?
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; name =
 ;@output = study id
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
GETSID(name) ; return studyid
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 n lien s lien=$o(@root@("name",name,""))
 n dfn s dfn=$g(@root@(lien,"dfn"))
 n pien s pien=$o(@proot@("dfn",dfn,""))
 q:pien="" ""
 ;
 quit $g(@proot@(pien,"sisid")) ; end of $$GETSID^SAMIDCM1
 ;
 ;
 ;
 ;
 ;@proc IDXDCM^SAMIDCM1
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean?;silent;sac?;??% tests;port?
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; dien =
 ; ARY =
 ;@output [tbd]
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
IDXDCM(dien,ARY) ; index a dcm entry after patient record creation
 ;
 n droot s droot=$$setroot^%wd("dcm-intake")
 i $d(ARY) m @droot@(dien)=ARY
 d  ;
 . n x
 . s x=$g(@droot@(dien,"dfn"))
 . if x'="" s @droot@("dfn",x,dien)=""
 . s x=$g(@droot@(dien,"saminame"))
 . i x="" s x=$g(@droot@(dien,"name"))
 . i x'="" s @droot@("name",x,dien)=""
 . s x=$g(@droot@(dien,"studyid"))
 . i x="" s x=$g(@droot@(dien,"sid"))
 . i x'="" s @droot@("sid",x,dien)=""
 . q
 ;
 quit  ; end of IDXDCM
 ;
 ;
 ;
 ;
 ;@section 4 init subroutine to create web services
 ;
 ;
 ;
 ;
 ;@dms MKSVC^SAMIDCM1
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;dms;procedure;silent;clean?;sac?;tests?;port?
 ;@called-by none
 ;@calls
 ; deleteService^%webutils
 ; addService^%webutils
 ;@input none
 ;@output
 ; creates web services:
 ;  post dcmimgin
 ;  post dcmin
 ;  post dcmquery
 ;  post dcmreset
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
MKSVC() ; create web services
 ;
 d deleteService^%webutils("POST","dcmimgin")
 d addService^%webutils("POST","dcmimgin","WSDCMIN^SAMIDCM1")
 ;
 d deleteService^%webutils("POST","dcmin")
 d addService^%webutils("POST","dcmin","WSDCMIN^SAMIDCM1")
 ;
 d deleteService^%webutils("GET","dcmquery")
 d addService^%webutils("GET","dcmquery","WSDCMQ^SAMIDCM1")
 ;
 d deleteService^%webutils("GET","dcmreset")
 d addService^%webutils("GET","dcmreset","WSDCMKIL^SAMIDCM1")
 ;
 quit  ; end of dms MKSVC^SAMIDCM1
 ;
 ;
 ;
EOR ; end of routine SAMIDCM1
