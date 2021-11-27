SAMIZPH1 ;ven/gpl - VAPALS PATIENT IMPORT FOR PHILIDELPHIA ; 2021-09-27t20:30z
 ;;18.0;SAMI;**16**;2020-01;Build 2
 ;18-x-16-t2
 ;
 ;@license: see routine SAMIUL
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@dev-main George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org-main Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-update 2021-09-27t20:30z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18-14-16
 ;@release-date 2020-01
 ;@patch-list **16**
 ;
 ;
 ;@module-credits
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
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2021-09-20/23 ven/gpl sami-18-14-16-t1
 ; SAMIZPH1 develop method to import data from a REDCap data system used by
 ; the Philadelphia VA.
 ;
 ; 2021-09-27 ven/gpl sami-18-14-16-t1
 ; SAMIZPH1 fix bug where Cache was putting the TSV records in overflow
 ;
 ;
 Q
 ;
WSDCMIN(ARGS,BODY,RESULT,ien)    ; recieve from addpatient
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
 . kill BODY  ; 
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
 . s return("error")="Missing patient study details"
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
 . i name="" s vars("name")=name
 . e  s vars("name")=$$normaliz(name)
 . n dob s dob=$g(@gp@("Patient's Birth Date"))
 . i dob="" s dob=20000302
 . s vars("dob")=dob
 . n gender s gender=$g(@gp@("Patient's Sex"))
 . i gender="" s gender="M"
 . s vars("gender")=gender
 . n patid s patid=$g(@gp@("Patient ID"))
 . s vars("patid")=patid
 . n studyDate s studyDate=$g(@gp@("Study Date"))
 . i studyDate'="" s vars("studyDate")=studyDate
 . n trackingIdentifier
 . s trackingIdentifier=$g(@gp@("Tracking Identifier"))
 . s vars("trackingIdentifier")=trackingIdentifier
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
 ;
 ;
 set return("status")="ok"
 set return("siteid")=site
 set return("ien")=ien
 ;
 if $get(ARGS("returngraph"))=1 do  ;
 . merge return("graph")=@root@(ien)
 ;
 n jary
 m jary("result")=return
 d encode^%webjson("jary","RESULT")
 s HTTPRSP("mime")="application/json"
 ;
 q
 ;
MATCH(vars) ; extrinsic which tries to match the message with an
 ; existing record
 ;
 n lroot,proot,droot
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 s droot=$$setroot^%wd("dcm-intake")
 n found s found=0
 n name s name=$$normaliz($g(vars("name")))
 n patid s patid=$g(vars("patid"))
 n dien,lien,pien
 ; first look at the dcm-intake for name matches
 s dien=$o(@droot@("name",name,""))
 i dien'="" d  ; the name has been found locally
 . s found=1
 . n dfn,studyid
 . s dfn=$g(@droot@(dien,"dfn"))
 . i dfn'="" s vars("dfn")=dfn
 . i dfn="" s found=0 q  ;
 . s studyid=$g(@droot@(dien,"studyid"))
 . i studyid="" s found=0 q  ;
 . i studyid'="" s vars("studyid")=studyid
 if found=1 q found
 i dien="" d  ; not here, check patient-lookup
 . s lien=$o(@lroot@("name",name,""))
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
 ;
 Q found
 ;
normaliz(name) ; extrinsic which tries to normalize the name
 ;
 n znam s znam=name
 i name'["," d  ; if no comma, then try a space
 . i $l(name," ")>0 d  ;
 . . n fnam,lnam
 . . s fnam=$p(name," ",1)
 . . s lnam=$p(name," ",$l(name," "))
 . . s fnam=$p(name,lnam,1)
 . . s znam=lnam_","_fnam
 q znam
 ;
nxtdfn() ; next available dfn
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 q $o(@root@("dfn"," "),-1)+1
 ;
getsid(name) ; return studyid
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 n lien s lien=$o(@root@("name",name,""))
 n dfn s dfn=$g(@root@(lien,"dfn"))
 n pien s pien=$o(@proot@("dfn",dfn,""))
 q:pien="" ""
 q $g(@proot@(pien,"sisid"))
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
 . ZWR vars
 Q
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
 ;
WSDCMQ(return,filter) ; web service which returns dcm json
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
 d encode^%webjson("jary","return")
 q
 ;
WSDCMKIL(return,filter) ; kill all but the first entry in dcm-intake
 ;
 n lroot,proot,droot
 n lien,pien,dien s (lien,pien,dien)=""
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patient")
 s droot=$$setroot^%wd("dcm-intake")
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
 q
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
MKSVC() ; create the web services
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
 Q
 ;