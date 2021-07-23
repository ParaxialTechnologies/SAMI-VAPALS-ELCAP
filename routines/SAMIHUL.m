SAMIHUL ;ven/gpl - ielcap: home page log ;2021-07-01t16:19z
 ;;18.0;SAMI;**9,12**;
 ;;1.18.0.12-t3+i12
 ;
 ; SAMIHOME contains subroutines for producing the ELCAP Home Page.
 ; SAMIHUL contains the development log for the SAMIHOM* routines.
 ; It contains no executable code.
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
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-07-01t16:19z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t3+i12
 ;@release-date 2020-01
 ;@patch-list **9,12**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@additional-dev Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@additional-dev Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@additional-dev Alexis R. Carlson (arc)
 ; whatisthehumanspirit@gmail.com
 ;@additional-dev Domenick DiNatale (ddn)
 ; domenic@intellitechinnovations.com
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
 ; 2018-01-13 ven/gpl 1.18.0-t4
 ;  SAMIHOM3: create routine from SAMIFRM to implement ELCAP Home Page.
 ;
 ; 2018-02-05 ven/toad 1.18.0-t4
 ;  SAMIHOM3: update license & attribution & hdr comments, add white
 ; space & do-dot quits, spell out language elements.
 ;
 ; 2018-02-27 ven/gpl 1.18.0-t4
 ;  SAMIHOM3: new subroutines PREFIX,GETHOME,SCANFOR,WSNEWCAS,PREFILL,
 ; MKSBFORM,MKSIFORM,VALDTNM,SID2NUM,KEYDATE,GENSTDID,NEXTNUM to
 ; support creation of new cases.
 ;
 ; 2018-03-01 ven/toad 1.18.0-t4
 ;  SAMIHOM3 refactor & reorganize new code, add hdr comments,
 ; r/findReplaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-06 ven/gpl 1.18.0-t4
 ;  SAMIHOM3: ?
 ;
 ; 2018-03-07 ven/toad 1.18.0-t4
 ;  SAMIHOM3: in $$SID2NUM add WSNUFORM^SAMICASE to called-by; in
 ; keyDate,GETHOME update called-by.
 ;
 ; 2018-05-18/25 ven/lgc&arc 1.18.0-t4 76020fd,81b1048,65afd99
 ;  SAMIHOM3: new SAMIHOM3 for new patient search page, chg submit
 ; processing on forms, fix bug in postform.
 ;
 ; 2018-06-14/07-10 ven/lgc&arc 1.18.0-t4 d71f4fe,8b0a432,ce345db,
 ; 402b6a8,14f991d,2e9662b
 ;  SAMIHOM3: make background form optional; 1st version of CT Eval
 ; Report; reorg ctreport routines & 1st crack at impressions &
 ; recommendations; note produced for intake form on submit; add
 ; support for routing by patient in CPRS Tools Menu, modify
 ; wsHOME^SAMIHOM3 to properly route VA-PALS web app when launced via
 ; CPRS Tools Menu; repair SAMIHOM3 & redact report link.
 ;
 ; 2018-08-22 ven/gpl 1.18.0-t4 6e696a9
 ;  SAMIHOM3: add PTINFO call to vista to pull ssn.
 ;
 ; 2018-09-30/11-01 ven/lgc&arc 1.18.0-t4 d93c640,482f522,a8e4226,
 ; ee5e8a1
 ;  SAMIHOM3: hdr & prefill of intake; new input form features, report
 ; menu fix; set urban/rural status at siform setup; handle zip code
 ; unknown.
 ;
 ; 2018-11-09/2019-01-22 ven/lgc&arc&lmry 1.18.0-t4 bac4f73,5400035,
 ; dd341e0,a953946,e2a44e6,2356c2b,3ceb74b,3088307,4271b46,7a5d340,
 ; dfbb0bc,fd1bcee,8dd6f34,51eb163,dbdb5a4,0880027,ccba017,5368121
 ;  SAMIHOM3: unit tests, annotation, sac compliance, XINDEX bugs, fix
 ; accidental reversions, add license info.
 ;
 ; 2018-12-18/20 ven/arc 1.18.0-t04 3088307f,4271b46b,dfbb0bca,
 ;  b8ff6da9,fd1bceee
 ;  SAMIHOM4: va sac compliance & variable namespacing.
 ;
 ; 2019-01-01/02-18 ven/lgc 1.18.0-t04 0880027c,18aa0fec,fcd635c1,
 ;  53681219,76874314
 ;  SAMIHOM3: update w/ recent changes.
 ;  SAMIHOM4: updates for va sac & code coverage, add license info.
 ;
 ; 2019-04-15 ven/gpl 1.18.0-t04 b403bf01
 ;  SAMIHOM4: support for new intake notes.
 ;
 ; 2019-04-16 ven/lgc 1.18.0-t04 e54b76d1
 ;  SAMIHOM4: update for SAMIFORM project.
 ;
 ; 2019-04-17 ven/gpl 1.18.0-t4 7d1f86db
 ;  SAMIHOM3: prefill date on intake prelim discussion section.
 ;
 ; 2019-06-18 ven/arc 1.18.0-t04 91022482
 ;  SAMIHOM4: switch fr/global ^SAMIGPL to/^SAMIUL.
 ;
 ; 2019-08-05 ven/gpl 1.18.0-t4 9c0c2ed3
 ;  SAMIHOM3: add GETPRFX to get right prefix at registration.
 ;
 ; 2019-08-07 ven/lgc&arc 1.18.0-t4 603194b9,37967fc5
 ;  SAMIHOM3: consolidate calls to retrieve facility prefix.
 ;
 ; 2019-11-22 par/ddn 1.18.0-t04 b2cc389d vap-458
 ;  SAMIHOM4: manual registration.
 ;
 ; 2020-01-01/05 ven/lgc 1.18.0 c169f4b1,5928064a,62e3200f
 ;  SAMIHOM4: support for unmatched patient processing, more changes
 ; for participant matching, unmatched participant processing ready
 ; for testing.
 ;
 ; 2020-01-08/10 ven/gpl 1.18.0 a002f850,47dfe3cd
 ;  SAMIHOM4: bug fix for unmatched processing, turn off & on manual
 ; registration link on home page.
 ;
 ; 2020-01-10 ven/gpl 1.18.0 4c8e6ebc,76b465cb
 ;  SAMIHOM4: 3 quits with returns for cache.
 ;
 ; 2020-01-16 ven/lgc 1.18.0 0a2af965
 ;  SAMIHOM4: bulk commit due to switch to cache.
 ;
 ; 2020-01-17/20 ven/lgc 1.18.0.1+i1 8557207f,dc5f618c
 ;  SAMIHOM4: followup note, limit to one note per followup form.
 ;
 ; 2020-02-01/02 ven/lgc 1.18.0.4+i4 3065146d,36ae0ed1
 ;  SAMIHOM4: set options for text based ctreport, switch default
 ; ctreport to text.
 ;
 ; 2020-04-02/11 ven/gpl 1.18.0.5+i5 d36b7cad,36607664,befde317,
 ;  56bfaed6,666f5b91,2f2c29c1
 ;  SAMIHOM3: multitenancy; in GENSTDID add ARG param, determin prefix
 ; from site or siteid (ARG) instead of calling $$GETPRFX^SAMIFORM.
 ;  SAMIHOM4: multitenancy + fix bug in WSVAPALS.
 ;
 ; 2020-04-18/05-07 ven/gpl 1.18.0.5+i5 29d7dba7,d55de214,521e0bdc,
 ;  d018f52e,476b2ff4,61c7d208
 ;  SAMIHOM4: fix bug & weird error in manual registration, fix bug in
 ; logout, logout working, superuser site selection, worklist
 ; functionality.
 ;
 ; 2020-08-06 ven/gpl 1.18.0.6+i6 781744c3
 ;  SAMIHOM4: changes to support hl7 transmission of notes.
 ;
 ; 2020-09-22 ven/gpl 1.18.0.9+i9 06459eda
 ;  SAMIHOM4: correct to match kids file.
 ;
 ; 2021-03-02 ven/gpl 1.18.0.9+i9 479dc041
 ;  SAMIHOM4: return error message if no ct eval form exists when
 ; generating a fu note.
 ;
 ; 2021-03-11 ven/toad 1.18.0.9+i9 a46a2cc1
 ;  SAMIHUL: create routine.
 ;  SAMIHOM4: bump date & patch list, add contents, lt refactor.
 ;
 ; 2021-03-17 ven/toad 1.18.0.9+i9
 ; SAMIHOM4: remove blank from end of 1 line.
 ;
 ; 2021-05-29 ven/gpl 1.18.0.12-t2+i12 59ea0811
 ;  SAMIHOM3: in SID2NUM look up by pien instead of relying on sid
 ; containing pien.
 ;
 ; 2021-06-15 ven/gpl 1.18.0.12-t2+i12 e247ea59
 ;  SAMIHOM4: eliminate icn.
 ;
 ; 2021-06-15/16 ven/mcglk&toad 1.18.0.12-t2+i12 cbf7e46b,fa794d60
 ;  SAMIHOM3 move log to SAMIHUL, bump dates & versions, annotate,
 ; reorg, lt refactor.
 ;  SAMIHOM4 bump dates & versions; begin annotate, reorg, lt refactor
 ; but interrupted by addition of critical fix to patch & bronchitis,
 ; so leave refactor unfinished (but stable as far as it went).
 ;  SAMIUTH3 bump dates & versions, lt refactor, add COVER, in UTSCAN4
 ; fix $random bug, but after discovering the SAMI test suite is so
 ; far out of date that it fails catastrophically with thousands of
 ; errors, back out changes and leave as it was.
 ;
 ;@contents
 ; SAMIHOM3 homepage interface library
 ; SAMIHOM4 homepage subroutines
 ; SAMIHUL homepage development log
 ; SAMIUTH3 tests for SAMIHOM3
 ; SAMIUTH4 tests for SAMIHOM4
 ;
 ;
 ;
EOR ; end of routine SAMIHUL
