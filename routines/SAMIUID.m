SAMIDCM2 ;ven/gpl - SCREEN+ USER ID ROUTINES ; 2022-01-18t00:42z
 ;;18.0;SAMI;**16**;2020-01;Build 2
 ;18-16
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
 ;@last-update 2022-01-18t00:42z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18-16
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
 ;
 ;
 ;
 Q
 ;
 ; The hierarchy of user IDs
 ; 1. pid, if available. this is the manually assigned "Study ID"
 ;    which usually has the format "MRxxxxxxxx"
 ; 2. mrn, if available. this is an external medical record id.
 ;    If the external system is Epic, has the format 123456789 with
 ;    some alphabetics included
 ; 3. ssn, if available. for systems that use the social security number
 ;    for identification. has the format 123-45-6789
 ; 4. last5, if available. the first letter of the last name, and the
 ;    last 4 digits of the ssn - depends on having the ssn
 ; 5. sid, if available. the internal studyid, assigned automatically
 ;    when a person is enrolled. is not changeable by the user.
 ;    has the form XXX123456 where XXX is the site signifier
 ; 6. dfn, alway available. the dfn is the identifier, system assigned,
 ;    which is common to patient-lookup and vapals-patients graphs, and
 ;    is thus the only identifier which is guarentied to exist for every
 ;    person
 ;
GETUID(dfn) ; extrinsic return the id to use 
 ;
 n id s id=""
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 ;
 n debug s debug=$G(DEBUG)
 n lien s lien=$o(@lroot@("dfn",dfn,""))
 w:debug !,"lien= ",lien
 q:lien="" ""
 n pien s pien=$o(@proot@("dfn",dfn,""))
 w:debug !,"pien= ",pien
 q:pien="" ""
 ;
 s id=$g(@proot@(pien,"sipid"))
 if id="" s id=$g(@proot@(pien,"pid"))
 w:debug !,"pid= ",id
 q:id'="" id
 s id=$g(@proot@(pien,"simrn"))
 i id="" s id=$g(@proot@(pien,"mrn"))
 w:debug !,"mrn= ",id
 q:id'="" id
 s id=$g(@lroot@(lien,"sissn"))
 i id="" s id=$g(@lroot@(lien,"ssn"))
 i id="" s id=$g(@proot@(pien,"sissn"))
 w:debug !,"ssn= ",id
 q:id'="" id
 s id=$g(@lroot@(lien,"last5"))
 w:debug !,"last5= ",id
 q:id'="" id
 s id=$g(@proot@(pien,"sid"))
 i id="" s id=$g(@proot@(pien,"sisid"))
 w:debug !,"sid= ",id
 q:id'="" id
 s id=dfn
 w:debug !,"dfn= ",id
 q id
 ;
GETIDSID(sid) ; extrinsic returns id to use based on sid
 n debug s debug=$g(DEBUG)
 n proot s proot=$$setroot^%wd("vapals-patients")
 n pien s pien=$o(@proot@("sid",sid,""))
 w:debug !,"pien= ",pien
 q:pien="" ""
 n dfn s dfn=$g(@proot@(pien,"dfn"))
 w:debug !,"dfn= ",dfn
 q:dfn="" ""
 q $$GETUID(dfn)
 ;