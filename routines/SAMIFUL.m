SAMIFUL ;ven/gpl - vapals-elcap: form log ;2021-03-21T23:32Z
 ;;18.0;SAMI;**10**;2020-01;
 ;;1.18.0.10-i10
 ;
 ; SAMIFUL contains routine & module info & the primary development
 ; log for VAPALS-ELCAP's Form module, SAMIF.
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
 ;@primary-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated 2021-03-21T23:32Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@version 1.18.0.10-i10
 ;@release-date 2020-01
 ;@patch-list **10**
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
 ;@module-log
 ; 2017-09-19 ven/gpl 1.18.0-t01 
 ;  SAMIFRM: initialize SAMI FORM file from elcap-patient graphs,
 ; using mash tools & graphs (%yottaq,^%wd).
 ;
 ; 2017-09-18 ven/gpl 1.18.0-t01
 ;  SAMIFRM: update.
 ;
 ; 2017-12-18 ven/gpl 1.18.0-t01
 ;  SAMIFRM: update.
 ;
 ; 2018-01-03 ven/gpl 1.18.0-t01
 ;  SAMIFRM: update.
 ;
 ; 2018-01-14 ven/gpl 1.18.0-t01
 ;  SAMIFRM: update.
 ;
 ; 2018-02-04 ven/gpl 1.18.0-t01
 ;  SAMIFRM: update.
 ;
 ; 2018-02-05/07 ven/toad 1.18.0-t04
 ;  SAMIFRM: update license & attribution & hdr comments, add white
 ; space & do-dot quits, spell out language elements; in SAMISUBS
 ; replaceAll^%wfhform > replaceAll^%wf; $$setroot^%yottaq > 
 ; $$setroot^%wdgraph; getVals^%yottaq > getVals^%wf.
 ;
 ; 2018-02-14 ven/toad 1.18.0-t04
 ;  SAMIFRM: replaceAll^%wf > findReplaceAll^%wf, ln > line, add
 ; @calls & @called-by tags, break up some long lines, scope variables
 ; in $$GETDIR & $$GETFN.
 ;
 ; 2018-03-01 ven/toad 1.18.0-t04
 ;  SAMIFRM: findReplaceAll^%wf > findReplace^%ts.
 ;
 ; 2018-03-07/08 ven/toad 1.18.0-t04
 ;  SAMIFRM: in SAMISUBS $$setroot^%wdgraph > $$setroot^%wf, fix bug
 ; when r/css w/see.
 ;
 ; 2018-03-18 ven/toad 1.18.0-t04
 ;  SAMIFRM2: restore calls to findReplaceAll^%ts.
 ;
 ; 2018-03-21/04-02 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: insert max date, chg case review navigation to post,
 ; date order for CT Eval in case review; support incomplete forms
 ; display & processing; fix to not inject html in javascript for case
 ; review navigation; fix followup submit.
 ;
 ; 2018-04-24 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: add Pet & Biopsy forms.
 ;
 ; 2018-05-18/21 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: convert to new graph, simplify forms processing.
 ;
 ; 2018-05-22 par/dom 1.18.0-t04
 ;  SAMIFRM2: VAP-95 - remove code that replaced hard-coded date
 ; w/"today" from backend, no longer needed.
 ;
 ; 2018-05-24 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: changes for submit processing on forms.
 ;
 ; 2018-05-25 par/dom 1.18.0-t04
 ;  SAMIFRM2: merge pull request 3 fr/OSEHRA/VAP-95-Remove-Today-Text-
 ; Replacement2. VAP-95 remove today text replacement.
 ;
 ; 2018-05-25 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: add STUDYID for txt replace; more changes for STUDYID
 ; substitution.
 ;
 ; 2018-07-11 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: add FROZEN variable based on samistatus=compete.
 ;
 ; 2018-08-19 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: use ssn instead of last5 where available; revise ssn
 ; formatting.
 ;
 ; 2018-09-30 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: header & prefill of intake.
 ;
 ; 2018-10-15 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: initial user reports: enrollment.
 ;
 ; 2018-10-31 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: new input form features, report menu fix.
 ;
 ; 2018-11-13 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: SAMIHOM2 > SAMIHOM3.
 ;
 ; 2018-11-14 ven/gpl 1.18.0-t04
 ;  SAMIFRM2: fix graph store forms.
 ;
 ; 2018-11-29 ven/lgc 1.18.0-t04
 ;  SAMIFRM2: ongoing unit-test work.
 ;
 ; 2018-12-11/12 ven/toad 1.18.0-t04
 ;  SAMIFRM2: update chg log; in SAMISUB2 r/last findReplace^%ts w/a
 ; flag & r/w/findReplaceAll^%ts; passim spell out language elements,
 ; update tags called-by, calls, tests; namespace call-by-ref & call-
 ; by-name actuals.
 ;
 ; 2019-01-02/17 ven/toad 1.18.0-t04
 ;  SAMIFRM2: update chg log; in INIT1FRM id > form; doc signatures,
 ; web services, unit tests, dmis, ppis, input, output, thruput.
 ;  SAMIFUL: create from SAMIFRM2 as primary development log.
 ;  SAMIFLD: create from SAMIFRM2 w/SAMISUB2,GETHDR,GETLAST5,FIXSRC,
 ; FIXHREF,GETNAME,GETSSN; SAMISUB2 > LOAD, reroute calls, namespace
 ; filter > SAMIFILTER, %j > SAMILNUM, zhtml > SAMIHTML, vals >
 ; SAMIVALS (& add to params), key > form; convert to ppi-code (no
 ; params); minor edits.
 ;  SAMIFORM: create from SAMIFRM2 w/all ppi, dmi, & wsi entry points,
 ; no code, goto code in other routines.
 ;  SAMIFWS: create from SAMIFRM2 w/WSSBFORM,WSSIFORM,WSCEFORM;
 ; convert to ppi-code (no params); minor edits.
 ;  SAMIFDM: create from SAMIFRM2, INITFRMS > INIT, INIT1FRM > INIT1,
 ; REGFORMS > REGISTER, LOADDATA > IMPORT,PRSFLNM,GETDIR,GETFN;
 ; convert to ppi-code (no params); annotate & minor edits; move unit-
 ; test switch to cover more code.
 ;  related changes:
 ;  SAMICAS2,SAMICASE,SAMIFLD,SAMINOTI,SAMIUR,SAMIUR1,SAMIUTF,%tsfwr,
 ; %tsfwra,%wfhform: passim SAMIFRM2 > SAMIFORM.
 ;  SAMIUTST: SAMIFRM2 > SAMIFORM, add SAMIFLD,SAMIFDM,SAMIFWS.
 ;
 ; 2019-03-26 ven/lgc 1.18.0-t04
 ;  SAMIFLD: Add changlog code to end of LOAD^SAMIFLD code to account
 ; for new changelog functionality.
 ;
 ; 2019-03-27 ven/lgc 1.18.0-t04
 ;  SAMIFWS: Comment out lines 106, 164, 222 in SAMIFWS;
 ; GETITEMS^SAMICAS2 does not have formal list, may have been part of
 ; temporary debug code.
 ; 106;new items do GETITEMS^SAMICAS2("items",sid)
 ; 164;new items do GETITEMS^SAMICAS2("items",sid)
 ; 222;new items do GETITEMS^SAMICAS2("items",sid)
 ;
 ; 2019-03-28 ven/lgc 1.18.0-t04
 ; SAMIFDM: in IMPORT account for unit test where we do not wish to
 ; prompt user for directory; also modified directory for json files
 ; in repo.
 ;
 ; 2019-03-29 ven/lgc 1.18*0-t04
 ;  SAMIFLD: in LOAD include George's new variables for intake notes.
 ;
 ; 2019-04-16 ven/lgc 1.18.0-t04 e54b76d1
 ;  SAMIFDM,SAMIFLD,SAMIFORM,SAMIFWS: SAMIFRM2 > SAMIFORM.
 ;
 ; 2019-04-16 ven/lgc 1.18.0-t04 e54b76d1
 ;  SAMINOT1: SAMIFRM2 > SAMIFORM.
 ;
 ; 2019-04-18 ven/gpl 1.18.0-t04 2b6f0d63
 ;  SAMIFLD: fix missing patient name.
 ;
 ; 2019-04-22 ven/lgc 1.18.0-t04 e7afbfa1
 ;  SAMIFWS: removal of SAMIFRM2 reference.
 ;
 ; 2019-04-23 ven/lgc 1.18.0-t04 529e8f2f,89bffd3b
 ;  SAMIFDM: comment out zwrite commands.
 ;  SAMIFORM: SAMISUB2 > LOAD.
 ;
 ; 2019-05-08 ven/lgc 1.18.0-t04 33dfa8c2
 ;  SAMIFDM: replace zsystem command with MASH call.
 ;
 ; 2019-06-10/19 ven/arc 1.18.0-t04 5d7a987d,c69b6787
 ;  SAMIFDM: chg explicit paths, unify paths to unit test json data.
 ;
 ; 2019-06-28/07-08 ven/lgc 1.18.0-t04 703c3050
 ;  SAMIFLD: fix patient age calculations, calculate patient age
 ; w/MASH age^%th.
 ;
 ; 2019-08-01 ven/arc 1.18.0-t04 d710f27d
 ;  SAMIFLD,SAMIFORM: pull displayed facility code from vista
 ; parameter.
 ;
 ; 2019-08-03 ven/gpl 1.18.0-t04 bea65f7b,ffc94f65
 ;  SAMIFLD: fix bugs in Have You Ever Smoked processing in changelog
 ; & intake note, fix smoking status on enrollment report, fix change
 ; log display.
 ;
 ; 2019-08-05 ven/gpl 1.18.0-t04 4ee0d3e6
 ;  SAMIFLD: add GETPRFX to avoid colision with VAP-435.
 ;
 ; 2019-08-14 ven/gpl 1.18.0-t04 0aa37766,4e6f4fdf,08d45d99
 ;  SAMIFLD: resolve conflict over semicolon in comment, merge pull
 ; request #70 from OSEHRA/VAP-426-eversmoked, merge with 417.
 ;
 ; 2019-09-26 ven/gpl 1.18.0-t04 92b12324 VAP-420
 ;  SAMIFLD: add smoking history to intake/followup forms (#75).
 ;
 ; 2019-10-22 ven/lgc 1.18.0-t04 613e8ff4
 ;  SAMIFLD: update unit test routines for dfn 1.
 ;
 ; 2019-11-22 par/dom 1.18.0 b2cc389d VAP-458
 ;  SAMIFLD: add new manual registration page.
 ;
 ; 2020-01-21 ven/arc 1.18.0 a4c143be
 ;  SAMIFLD: patient matching additions.
 ;
 ; 2020-04-07/11 ven/gpl 1.18.0.5-i5 36607664,c8f4cf30,2f2c29c1
 ;  SAMIFLD,SAMIFORM,SAMIFWS: multi-tenancy.
 ;
 ; 2021-03-16 ven/gpl 1.18.0.10-i10 002071de
 ;  SAMIFLD: dob age calculation fix from hl7 dob format.
 ;
 ; 2021-03-21 ven/toad 1.18.0.10-i10
 ;  SAMIFLD: bump date & version, lt refactor.
 ;
 ;
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
