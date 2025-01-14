SAMIURUL ;ven/gpl - user reports log; 2024-09-10t05:01z
 ;;18.0;SAMI;**12,14,15,17,18**;2020-01-17;Build 8
 ;mdc-e1;SAMIURUL-20240910-EE7ZuE;SAMI-18-18-b1
 ;mdc-v7;B118219;SAMI*18.0*18 SEQ #18
 ;
 ; SAMIURUL contains the development log & module documentation for
 ; the ScreeningPlus user-reports routines SAMIUR & SAMIUR2. It
 ; contains no public interfaces or executable code.
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
 ;@dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2021/2024, mcglk & toad, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@update 2024-09-10t05:01z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module User Reports - SAMIUR
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-18
 ;@edition-date 2020-01-17
 ;@patches **12,14,15,17,18**
 ;
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
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
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2020-02-10/12 ven/gpl 18-t4 d543f7bb,f9869dfb,0e4d8b9a,5e67489f
 ;  SAMIUR,SAMIUR2 1st version of revised user reports, progress on
 ; user reports, fixed a bug in enrollment report, add rural/urban &
 ; compute.
 ;
 ; 2020-02-18 ven/lgc 18-t4 76874314
 ;  SAMIUR update recently edited routines.
 ;
 ; 2020-03-10/12 ven/gpl 18-t4 8de06b06,4ad52d64
 ;  SAMIUR user report date filtering, fix end date logic in UR.
 ;
 ; 2019-03-24/28 ven/gpl 18-t4 1fd4a4c8,0cebb36b
 ;  SAMIUR2 revise incomplete form report, remove ethnicity from
 ; enrollment report (we can't get it).
 ;
 ; 2020-04-16/23 ven/lgc 18-t4 e54b76d1b,89bffd3b
 ;  SAMIUR SAMIFRM2 > SAMIFORM, SAMISUB2 > LOAD.
 ;
 ; 2019-05-08 ven/lgc 18 2172e512
 ;  SAMIUR2 remove blank last line.
 ;
 ; 2019-06-21 par/dom 18 c6a4a57f VAP-352
 ;  SAMIUR2 proper spelling of "follow up."
 ;
 ; 2019-08-03/04 ven/gpl 18 ffc94f65,d03557d4,cd865e2b VPA-438
 ;  SAMIUR requested changes to followup report.
 ;  SAMIUR2 fix smoking status on enrollment report, fix change log
 ; display, add pack years at intake to enrollment report, add
 ; requested changes to followup report.
 ;
 ; 2019-09-26 ven/gpl 18 92b12324 VAP-420
 ;  SAMIUR add smoking history.
 ;  SAMIUR2 smoking history, new cummulative packyear processing.
 ;
 ; 2019-10-01 par/dom 18 4caf1a98 VAP-344
 ;  SAMIUR2 make capitalization consistent.
 ;
 ; 2020-01-01/05 ven/arc 18 399f8547,62e3200f
 ;  SAMIUR unmatched participant processing.
 ;  SAMIUR2 add unmatched patient processing.
 ;
 ; 2020-01-10 ven/gpl 18 1590577c
 ;  SAMIUR2 fix return on RACE^SAMIUR2 for cache.
 ;
 ; 2020-04-29/05-13 ven/gpl 18-5 e8b8ea2d,61c7d208
 ;  SAMIUR fixes for reports, worklist functionality.
 ;
 ; 2020-05-13/14 ven/gpl 18-5 61c7d208,b05df417
 ;  SAMIUR2 add worklist functionality, fix gender & dob detection on
 ; reports.
 ;
 ; 2021-03-22/23 ven/gpl 18-10 256efe63,ba81b86a
 ;  SAMIUR sort all reports by name, added row totals to reports.
 ;
 ; 2021-03-23 ven/toad 18-10 96f461d0,af86e0eb
 ;  SAMIUR add version info & dev log, lt refactor, fix XINDEX
 ; errors.
 ;
 ; 2021-03-29 ven/gpl 18-11 e809f2a2
 ;  SAMIUR prevent crash when reports have no matches: in WSREPORT
 ; set SRT="" and uncomment zwrite SRT; in WKLIST add 2 commented-out
 ; debugging lines.
 ;
 ; 2021-03-30 ven/toad 18-11 7b14bb29
 ;  SAMIUR bump version, date, log; in WSREPORT comment zwrite SRT.
 ;
 ; 2021-03-31 ven/gpl 18-11 66d89cde
 ;  SAMIUR sort on all uppercase names for reports
 ;
 ; 2021-04-13 ven/gpl 18-11 a12765bf,f09ffef9,fb399aba
 ;  SAMIUR inactive report created.
 ;  SAMIUR2 in RPTTBL,GENDER create inactive report, move last exam
 ; column on followup report, fix gender being blank in reports.
 ;
 ; 2021-05-20/25 ven/mcglk&toad 18-11 43a4557c,70fc6ba3,129e96b1,
 ; cee2bf17
 ;  SAMIUR annotate, lt refactor, bump version.
 ;  SAMIUR2 passim hdr comments, chg log, annotate, refactor, bump
 ; version.
 ;
 ; 2021-05-29 ven/gpl 18-12-t2 e6fd5730,a3d6f9a0
 ;  SAMIUR,SAMIUR2 ssn params & matching report, update unmatched
 ; report headings.
 ;
 ; 2021-06-15 ven/gpl 18-12-t2 7e481426
 ;  SAMIUR add site to editperson navigation.
 ;
 ; 2021-06-28 ven/gpl 18-12-t2 df0aaea1,1137e2bb
 ;  SAMIUR change definition of inactive to not marked active, change
 ; definition of active to marked active.
 ;
 ; 2021-07-06 ven/mcglk&toad&gpl 18-12-t2 cbf7e46b,2d642aa4,
 ; b248664b
 ;  SAMIURUL new routine for dev log.
 ;  SAMIUR,SAMIUR2,SAMIURUL move dev log & module docs to SAMIURUL,
 ; bump version & dates.
 ;  SAMIUR in SELECT r/inactive w/status, test for active instead of
 ; inactive.
 ;
 ; 2021-07-12 ven/gpl 18-12-t3 60f4bb05,27c40485,d35bcb46
 ;  SAMIUR in WSREPORT,SORT add contact date & entry to missingct
 ; report.
 ;  SAMIUR2 add contact date & entry to missingct report; add
 ; inactive date reason & comment to inactive report; chg inactive
 ; date to date of death.
 ;
 ; 2021-08-01 ven/gpl 18-12 5bd7c627
 ;  SAMIUR set intake form to incomplete on creation: in SELECT if
 ; type="incomplete" ensure default status is incomplete.
 ;
 ; 2021-08-11 ven/gpl 18-12 4d4f0fc3
 ;  SAMIUR,SAMIUR2 add sorting to tables used for reports.
 ;  SAMIUR in WSREPORT,NUHREF,WKLIST.
 ;  SAMIUR2 in TDDT,BLINEDT,DOB,FUDATE,LASTEXM,INACTDT,LDOC,STUDYDT.
 ;
 ; 2021-08-26 ven/gpl 18-14 de044cf9
 ;  SAMIUR, SAMIUR2 make changes to user reports as requested.
 ; Reports changed were Enrollment, Activity, and Follow-up.
 ;
 ; 2021-08-28 ven/gpl 18-14 cd69ff8b, fbd9196d
 ;  SAMIUR, SAMIUR2 fix bugs in Activity report; fix problem with Work
 ; List.
 ;
 ; 2021-09-09 ven/gpl 18-14 afa4bfc2, 7f668e64, 8d45ebac
 ;  SAMIUR fix bugs in reports showing inactive patients on wrong
 ; reports, "baseline" showing up in F/U date on Follow-up report,
 ; wrong patients on Intake but Missing CT Eval report.
 ;
 ; 2021-10-05 ven/gpl 18-14 3251c582, c4343d69, 368fa7f7, c4343d69
 ; b3cd039b, 237109df, 368fa7f7
 ;  SAMIIUR, SAMIUR2 fix small bugs, make date formats consistent,
 ; bump versions & dates.
 ;
 ; 2021-10-14 ven/gpl 18-14  6a973630
 ;  SAMIUR fix bug where patients with CT Evals would appear on Intake
 ; but no CT report.
 ;
 ; 2021-10-15 ven/lmry 18-14 87fd8eb3
 ;  SAMIUR, SAMIURUL update history, bump dates.
 ;
 ; 2021-10-20 ven/gpl 18-15 b63bfc06
 ;  SAMIUR2  suppress rural column in enrollment report if not VA.
 ;
 ; 2021-10-25 ven/gpl 18-15 b6188d2c
 ;  SAMIUR fix for duplicates in work list & matching reports.
 ;
 ; 2021-10-28 ven/lmry,mcglk 18-15
 ;  SAMIUR, SAMIUR2, SAMIURUL update history, bump dates & versions.
 ;
 ; 2021-10-29 ven/lmry 18-15
 ;  SAMIUR remove blank at end of line for XINDEX.
 ;
 ; 2022-12-15/17 ven/gpl 18-17
 ;  SAMIUR, SAMIUR2 develop new CT Eval Recommendation report.
 ;
 ; 2022-12-30 ven/lmry 18-17  68d5a01
 ;  SAMIUR, SAMIUR2, SAMIURUL update history, bump dates & versions.
 ;
 ; 2022-12-30 ven/lmry 18-17 
 ;  SAMIUR remove blank at end of line for XINDEX.
 ;
 ; 2023-01-04 ven/gpl  18-17
 ;  SAMIUR fix bug to make data appear in new report.
 ;
 ; 2024-08-17 ven/lmry 18-17  a1a28de
 ;  SAMIUR bump dates, update contents, remove space at end of line.
 ;  SAMIUR2 bump dates.
 ;  SAMIURUL add history, bump dates.
 ;
 ; 2024-08-21/22 ven/toad 18-17-b6  bd5cfb4
 ;  SAMIUR annotate.
 ;  SAMIURUL update history.
 ;  SAMIUR,2,UL update version-control lines, hdr comments, comment
 ; out ^gpl debugging lines.
 ;
 ; 2024-09-07 ven/gpl 18-18-b1  e6fdd47 4942369
 ;  SAMIUR2 MRN lookup and display working, fix the recommendations report
 ;   PID field
 ;
 ; 2024-09-10 ven/lmry 18-18-b1
 ;  SAMIUR2 update date/time, version control lines
 ;  SAMIURUL update date/time, version control lines, and module log
 ;
 ;
 ;@contents
 ;
 ; SAMIUR user reports
 ; SAMIUR1 [to be added]
 ; SAMIUR2 user reports cont
 ; SAMIURUL user reports log
 ; SAMIUTUR user reports tests
 ;
 ;
 ;
EOR ; end of SAMIURUL
