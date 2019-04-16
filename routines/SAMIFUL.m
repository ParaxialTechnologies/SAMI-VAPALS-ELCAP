SAMIFUL ;ven/gpl - vapals-elcap: form log ; 4/16/19 1:00pm
 ;;18.0;SAMI;;
 ;
 ; Routine SAMIFUL contains routine & module info & the primary
 ; development log for VAPALS-ELCAP's Form module, SAMIF.
 ; It contains no public interfaces or executable code.
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
 ;@copyright: 2017/2019, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2019-01-17T16:30Z
 ;@application: Screening Applications Management (SAM)
 ;@module: VAPALS-ELCAP (SAMI)
 ;@version: 18.0T04 (fourth development version)
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev: Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;@additional-dev: Domenic DiNatale (dom)
 ; domenic.dinatale@paraxialtech.com
 ;
 ;@module-credits
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017/2019, Bristol-Myers Squibb Foundation (bmsf)
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
 ; 2017-09-19 ven/gpl v18.0t01 SAMIFRM: initialize the SAMI FORM file
 ; from elcap-patient graphs, using mash tools and graphs (%yottaq,^%wd)
 ;
 ; 2017-09-18 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2017-12-18 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-01-03 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-01-14 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-02-04 ven/gpl v18.0t01 SAMIFRM: update
 ;
 ; 2018-02-05/07 ven/toad v18.0t04 SAMIFRM: update license & attribution
 ; & hdr comments, add white space & do-dot quits, spell out language
 ; elements; in SAMISUBS r/replaceAll^%wfhform w/replaceAll^%wf.
 ; r/calls to $$setroot^%yottaq & getVals^%yottaq w/$$setroot^%wdgraph
 ; & getVals^%wf.
 ;
 ; 2018-02-14 ven/toad v18.0t04 SAMIFRM: r/replaceAll^%wf
 ; w/findReplaceAll^%wf, r/ln w/line, add @calls & @called-by tags, break
 ; up some long lines, scope variables in $$GETDIR & $$GETFN.
 ;
 ; 2018-03-01 ven/toad v18.0t04 SAMIFRM: r/findReplaceAll^%wf
 ; w/findReplace^%ts.
 ;
 ; 2018-03-07/08 ven/toad v18.0t04 SAMIFRM: in SAMISUBS
 ; r/$$setroot^%wdgraph w/$$setroot^%wf, fix bug when r/css w/see.
 ;
 ; 2018-03-18 ven/toad SAMI*18.0t04 SAMIFRM2: restore calls to
 ; findReplaceAll^%ts.
 ;
 ; 2018-03-21/04-02 ven/gpl SAMI*18.0t04 SAMIFRM2: max date insertion,
 ; case review navigation changed to post, date order for CT Eval in
 ; case review; changes to support incomplete forms display & processing;
 ; fix to not inject html in the javascript for case review navigation;
 ; fix followup submit.
 ;
 ; 2018-04-24 ven/gpl SAMI*18.0t04 SAMIFRM2: added Pet & Biopsy forms.
 ;
 ; 2018-05-18/21 ven/gpl SAMI*18.0t04 SAMIFRM2: conversion to new graph
 ; & simplified forms processing.
 ;
 ; 2018-05-22 par/dom SAMI*18.0t04 SAMIFRM2: VAP-95 - removed code that
 ; replaced hard-coded date w/"today" from backend, no longer needed.
 ;
 ; 2018-05-24 ven/gpl SAMI*18.0t04 SAMIFRM2: changes for submit processing
 ; on forms.
 ;
 ; 2018-05-25 par/dom SAMI*18.0t04 SAMIFRM2: merge pull request 3 fr/
 ; OSEHRA/VAP-95-Remove-Today-Text-Replacement2. VAP-95 remove today text
 ; replacement.
 ;
 ; 2018-05-25 ven/gpl SAMI*18.0t04 SAMIFRM2: add STUDYID for txt replace;
 ; more changes for STUDYID substitution.
 ;
 ; 2018-07-11 ven/gpl SAMI*18.0t04 SAMIFRM2: added FROZEN variable based
 ; on samistatus=compete.
 ;
 ; 2018-08-19 ven/gpl SAMI*18.0t04 SAMIFRM2: use ssn instead of last5 where
 ; available; revised ssn formatting.
 ;
 ; 2018-09-30 ven/gpl SAMI*18.0t04 SAMIFRM2: header & prefill of intake.
 ;
 ; 2018-10-15 ven/gpl SAMI*18.0t04 SAMIFRM2: initial user reports:
 ; enrollment.
 ;
 ; 2018-10-31 ven/gpl SAMI*18.0t04 SAMIFRM2: new input form features,
 ; report menu fix.
 ;
 ; 2018-11-13 ven/gpl SAMI*18.0t04 SAMIFRM2: every occurance of SAMIHOM2
 ; changed to SAMIHOM3.
 ;
 ; 2018-11-14 ven/gpl SAMI*18.0t04 SAMIFRM2: fix graph store forms.
 ;
 ; 2018-11-29 ven/lgc SAMI*18.0t04 SAMIFRM2: ongoing unit-test work.
 ;
 ; 2018-12-11/12 ven/toad SAMI*18.0t04 SAMIFRM2: update chg log; in SAMISUB2
 ; r/last findReplace^%ts w/a flag and r/w/findReplaceAll^%ts; passim
 ; spell out language elements, update tags called-by, calls, tests;
 ; namespace call-by-ref & call-by-name actuals.
 ;
 ; 2019-01-02/17 ven/toad SAMI*18.0t04 SAMIFRM2: update chg log; in INIT1FRM
 ; r/id w/form; doc signatures, web services, unit tests, dmis, ppis, input,
 ; output, thruput.
 ;  SAMIFUL: create from SAMIFRM2 as primary development log.
 ;  SAMIFLD: create from SAMIFRM2 w/SAMISUB2,GETHDR,GETLAST5,FIXSRC,FIXHREF,
 ; GETNAME,GETSSN; rename SAMISUB2->LOAD, reroute calls, namespace
 ; filter->SAMIFILTER,%j->SAMILNUM,zhtml->SAMIHTML,vals->SAMIVALS (& add to
 ; params), key->form; convert to ppi-code (no params); minor edits.
 ;  SAMIFORM: create from SAMIFRM2 w/all ppi, dmi, & wsi entry points, no
 ; code, goto code in other routines.
 ;  SAMIFWS: create from SAMIFRM2 w/WSSBFORM,WSSIFORM,WSCEFORM; convert to
 ; ppi-code (no params); minor edits.
 ;  SAMIFDM: create from SAMIFRM2 w/renamed INITFRMS->INIT,INIT1FRM->INIT1,
 ; REGFORMS->REGISTER,LOADDATA->IMPORT,PRSFLNM,GETDIR,GETFN; convert to
 ; ppi-code (no params); annotation & minor edits; move unit-test switch to
 ; cover more code.
 ;
 ; 2019-03-26 ven/lgc SAMI*18.0t04 SAMIFLD
 ;  Added changlog code to the end of the LOAD^SAMIFLD code
 ;   to account for the new changelog functionality
 ;
 ; 2019-03-27 ven/lgc SAMI*18.0t04 SAMIFWS
 ;  Commented out line 106,164,and 222 in SAMIFWS.
 ;    GETITEMS^SAMICAS2 does not have formal list
 ;    not have formal list. I think this may have been part
 ;    of temporary debug code
 ;  106;new items do GETITEMS^SAMICAS2("items",sid)
 ;  164;new items do GETITEMS^SAMICAS2("items",sid)
 ;  222;new items do GETITEMS^SAMICAS2("items",sid)
 ;
 ; 2019-03-28 ven/lgc SAMI*18.0t04 SAMIFMD
 ;   Modified IMPORT code in SAMIFMD to account
 ;    for Unit Test where we do not wish to prompt
 ;    user for a directory.  Also modified the directory
 ;    for the json files to be within the repo
 ;
 ; 2019-03-29 ven/lgc SAMI*18*0t04 SAMIFLD
 ;   Modified LOAD to include George's new variables
 ;     for intake notes.
 ;SAMICAS2.m:44: ; FIXHREF^SAMIFRM2 ---FIXHREF^SAMIFORM
 ;SAMICAS2.m:45: ; FIXSRC^SAMIFRM2 ---FIXSRC^SAMIFORM
 ;SAMICAS2.m:48: ; $$GETLAST5^SAMIFRM2 ---GETLAST5^SAMIFORM
 ;SAMICAS2.m:49: ; $$GETSSN^SAMIFRM2 ---GETSSN^SAMIFORM
 ;SAMICAS2.m:50: ; $$GETNAME^SAMIFRM2 ---GETNAME^SAMIFORM
 ;SAMICAS2.m:104: . . do FIXHREF^SAMIFRM2(.ln)  ---FIXHREF^SAMIFORM
 ;SAMICAS2.m:108: . . do FIXSRC^SAMIFRM2(.ln)  ---FIXSRC^SAMIFORM 
 ;SAMICAS2.m:135: new last5 set last5=$$GETLAST5^SAMIFRM2(sid) ---GETLAST5^SAMIFORM
 ;SAMICAS2.m:136: new pssn set pssn=$$GETSSN^SAMIFRM2(sid) ---GETSSN^SAMIFORM
 ;SAMICAS2.m:137: new pname set pname=$$GETNAME^SAMIFRM2(sid) ---GETNAME^SAMIFORM
 ;SAMICAS2.m:447: ; FIXHREF^SAMIFRM2  ---FIXHREF^SAMIFORM
 ;SAMICAS2.m:448: ; FIXSRC^SAMIFRM2 ---FIXSRC^SAMIFORM
 ;SAMICAS2.m:490: . . do FIXHREF^SAMIFRM2(.ln) ---FIXHREF^SAMIFORM
 ;SAMICAS2.m:494: . . do FIXSRC^SAMIFRM2(.ln) ---FIXHREF^SAMIFORM
 ;
 ;SAMICASE.m:28: ; FIXHREF^SAMIFRM2 ---FIXHREF^SAMIFORM
 ;SAMICASE.m:29: ; FIXSRC^SAMIFRM2 ---FIXSRC^SAMIFORM
 ;SAMICASE.m:32: ; $$GETLAST5^SAMIFRM2 ---GETLAST5^SAMIFORM
 ;SAMICASE.m:33: ; $$GETSSN^SAMIFRM2 ---GETSSN^SAMIFORM
 ;SAMICASE.m:34: ; $$GETNAME^SAMIFRM2 ---GETNAME^SAMIFORM
 ;SAMICASE.m:71: ; WSSBFORM^SAMIFRM2 ---WSSBFORM^SAMIFORM
 ;SAMICASE.m:72: ; WSSIFORM^SAMIFRM2 ---WSSIFORM^SAMIFORM
 ;SAMICASE.m:73: ; WSCEFORM^SAMIFRM2 ---WSCEFORM^SAMIFORM
 ;SAMICASE.m:113: ; FIXHREF^SAMIFRM2 ---FIXHREF^SAMIFORM
 ;SAMICASE.m:114: ; FIXSRC^SAMIFRM2 ---FIXSRC^SAMIFORM
 ;
 ;SAMIFLD.m:192: ; $$GETHDR^SAMIFRM2(sid) ---GETNAME^SAMIFORM
 ;SAMIFLD.m:411: quit pssn ; end of $$GETSSN^SAMIFRM2 ---GETSSN^SAMIFORM
 ;SAMIHOM4.m:246: . . d FIXHREF^SAMIFRM2(.ln) ---FIXHREF^SAMIFORM
 ;SAMIHOM4.m:250: . . d FIXSRC^SAMIFRM2(.ln) ---FIXSRC^SAMIFORM
 ;
 ;SAMINOTI.m:43: . D SAMISUB2^SAMIFRM2(.line,samikey,si,.filter) ---SAMISUB2^SAMIFORM
 ;
 ;SAMIUR1.m:53: . d SAMISUB2^SAMIFRM2(.ln,samikey,si,.filter) ---SAMISUB2^SAMIFORM
 ;SAMIUR1.m:85: . . n ssn s ssn=$$GETSSN^SAMIFRM2(sid) ---GETSSN^SAMIFORM
 ;SAMIUR1.m:88: . . . s hdf=$$GETHDR^SAMIFRM2(sid) ---GETHDR^SAMIFLD
 ;SAMIUR1.m:89: . . . s ssn=$$GETSSN^SAMIFRM2(sid) ---GETSSN^SAMIFORM
 ;
 ;SAMIUR.m:49: . d SAMISUB2^SAMIFRM2(.ln,samikey,si,.filter) ---SAMISUB2^SAMIFORM
 ;SAMIUR.m:85: . . s SAMIPATS(ij,dfn,"ssn")=$$GETSSN^SAMIFRM2(sid) ---GETSSN^SAMIFORM
 ;
 ;SAMIUTF.m:1:SAMIUTF ;ven/lgc - UNIT TEST for SAMIFRM2 ; 3/28/19 1:39pm
 ; --- for SAMIFORM,SAMIFLD,SAMIFWS,SAMIFDM
 ;
 ;SAMIUTST
 ;207      ;;SAMIFRM2 --- 207      ;;SAMIFORM
 ;208      ;;SAMIFLD
 ;209      ;;SAMIFWS
 ;210      ;;SAMIFDM
 ;
 ;_tsfwra.m:67: ; FIXHREF^SAMIFRM2 ---FIXHREF^SAMIFORM
 ;_tsfwra.m:68: ; FIXSRC^SAMIFRM2 ---FIXSRC^SAMIFORM
 ;
 ;_tsfwr.m:78: ; SAMISUB2^SAMIFRM2 ---SAMISUB2^SAMIFORM
 ;%tsfwr.m:76: ; SAMISUB2^SAMIFRM2 ---SAMISUB2^SAMIFORM
 ;
 ;_wfhform.m:182: . ;if form["vapals:" do SAMISUB2^SAMIFRM2(.tln,form,sid,.filter,.%j,.zhtml) ---SAMISUB2^SAMIFORM
 ;_wfhform.m:183: . if newstyle=1 do SAMISUB2^SAMIFRM2(.tln,key,sid,.filter,.%j,.zhtml) ---SAMISUB2^SAMIFORM
 ;NOTE: 184-185  if newstyle=0 do SAMISUBS^SAMIFRM(.tln,form,sid,.filter)???
 ;
 ;
 ; 2019-04-16 ven/lgc SAMI*18*0t04 SAMINOT1
 ;   Modified to use SAMIFORM rather than SAMIFRM2
 ;SAMINOT1.m 65       . D SAMISUB2^SAMIFRM2(.line,samikey,si,.filter) SAMISUB2^SAMIFORM
 ;
 ;@contents
 ; SAMIFORM: form library
 ; SAMIFDM: form dmi code
 ; SAMIFLD: form load
 ; SAMIFWS: form web-service code
 ; SAMIFUL: form log
 ; SAMIUTF2: form unit tests
 ;
 ;
 ;
EOR ; end of routine SAMIFUL
