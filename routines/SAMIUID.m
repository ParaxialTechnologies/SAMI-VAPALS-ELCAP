SAMIUID ;ven/gpl - user id; 2024-09-10t02:37z
 ;;18.0;SAMI;**18**;2020-01-17;
 ;mdc-e1;SAMIUID-20240910-E2WaTc0;SAMI-18-18-b1
 ;mdc-v7;B15836538;SAMI*18.0*18 SEQ #18
 ;
 ; SAMIUID contains private program services to identify the current
 ; ScreeningPlus user.
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
 ;@license see routine SAMIUL
 ;
 ;@update 2024-09-10t02:37z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-18
 ;@edition-date 2020-01-17
 ;@patches **18**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
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
 ; 2024-09-07 ven/gpl 18-18-b1 e6fdd47d
 ;  SAMIUID (F2LNW6y B9193785 E31giZd)
 ; add rtn w/GETUID,GETIDSID: mrn lookup + display working.
 ;
 ; 2024-09-10 ven/toad 18-18-b1
 ;  SAMIUID (F??? B15836538 E???)
 ; add hdr + subrtn hdr comments, log, bump version + dates.
 ;
 ;@to-do
 ;
 ; fill in log before 18-18, add details
 ;
 ;@contents
 ;
 ; $$GETUID = id to use
 ; $$GETIDSID = id to use based on sid
 ;
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
 ;
 ;@function $$GETUID
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;silent;clean?;sac?;tests?;port?
 ;@called-by
 ; $$GETIDSID^SAMIUID
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; dfn
 ;@output = uid
 ;@examples [tbd]
 ;@tests [tbd]
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
 ;
 n pien s pien=$o(@proot@("dfn",dfn,""))
 w:debug !,"pien= ",pien
 q:pien="" ""
 ;
 s id=$g(@proot@(pien,"sipid"))
 if id="" s id=$g(@proot@(pien,"pid"))
 w:debug !,"pid= ",id
 q:id]"" id
 ;
 s id=$g(@proot@(pien,"simrn"))
 i id="" s id=$g(@proot@(pien,"mrn"))
 w:debug !,"mrn= ",id
 q:id]"" id
 ;
 s id=$g(@lroot@(lien,"sissn"))
 i id="" s id=$g(@lroot@(lien,"ssn"))
 i id="" s id=$g(@proot@(pien,"sissn"))
 w:debug !,"ssn= ",id
 q:id]"" id
 ;
 s id=$g(@lroot@(lien,"last5"))
 w:debug !,"last5= ",id
 q:id]"" id
 ;
 s id=$g(@proot@(pien,"sid"))
 i id="" s id=$g(@proot@(pien,"sisid"))
 w:debug !,"sid= ",id
 q:id]"" id
 ;
 s id=dfn
 w:debug !,"dfn= ",id
 ;
 quit id ; end of $$GETUID
 ;
 ;
 ;
 ;
 ;@pps $$GETIDSID^SAMIUID
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;pps;function;silent;clean?;sac?;tests?;port?
 ;@called-by [tbd]
 ;@calls
 ; $$setroot^%wd
 ; $$GETUID
 ;@input
 ; sid
 ;@output = id to use
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
GETIDSID(sid) ; id to use based on sid
 ;
 n debug s debug=$g(DEBUG)
 n proot s proot=$$setroot^%wd("vapals-patients")
 n pien s pien=$o(@proot@("sid",sid,""))
 w:debug !,"pien= ",pien
 q:pien="" ""
 ;
 n dfn s dfn=$g(@proot@(pien,"dfn"))
 w:debug !,"dfn= ",dfn
 ;
 quit:dfn="" ""
 quit $$GETUID(dfn) ; end of pps $$GETIDSID^SAMIUID
 ;
 ;
 ;
EOR ; end of routine SAMIUID
