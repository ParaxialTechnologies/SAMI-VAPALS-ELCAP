SAMIURUL ;ven/gpl - user reports log ;2021-07-06T15:55Z
 ;;18.0;SAMI;**12**;2020-01;
 ;;1.18.0.12-t2+i12
 ;
 ; SAMIURUL contains the development log & module documentation for
 ; the VAPALS-ELCAP user-reports routines SAMIUR & SAMIUR2.
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
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2021, mcglk & toad, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-07-06T15:55Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t2+i12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
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
 ; 2020-02-10/12 ven/gpl 1.18.0-t04 d543f7bb,f9869dfb,0e4d8b9a,5e67489
 ;  SAMIUR,SAMIUR2: 1st version of revised user reports, progress on
 ; user reports, fixed a bug in enrollment report, add rural/urban &
 ; compute.
 ;
 ; 2020-02-18 ven/lgc 1.18.0-t04 76874314
 ;  SAMIUR: update recently edited routines.
 ;
 ; 2020-03-10/12 ven/gpl 1.18.0-t04 8de06b06,4ad52d64
 ;  SAMIUR: user report date filtering, fix end date logic in UR.
 ;
 ; 2019-03-24/28 ven/gpl 1.18.0 1fd4a4c,0cebb36
 ;  SAMIUR2: revise incomplete form report, remove ethnicity from
 ; enrollment report (we can't get it).
 ;
 ; 2020-04-16/23 ven/lgc 1.18.0-t04 e54b76d1b,89bffd3b
 ;  SAMIUR: SAMIFRM2 > SAMIFORM, SAMISUB2 > LOAD.
 ;
 ; 2019-05-08 ven/lgc 1.18.0 2172e51
 ;  SAMIUR2: remove blank last line.
 ;
 ; 2019-06-21 par/dom 1.18.0 c6a4a57 VAP-352
 ;  SAMIUR2: proper spelling of "follow up."
 ;
 ; 2019-08-03/04 ven/gpl 1.18.0 ffc94f6,d03557d,cd865e2b VPA-438
 ;  SAMIUR: requested changes to followup report.
 ;  SAMIUR2: fix smoking status on enrollment report, fix change log
 ; display, add pack years at intake to enrollment report, add
 ; requested changes to followup report.
 ;
 ; 2019-09-26 ven/gpl 1.18.0 92b12324 VAP-420
 ;  SAMIUR: add smoking history.
 ;  SAMIUR2: smoking history, new cummulative packyear processing.
 ;
 ; 2019-10-01 par/dom 1.18.0 4caf1a9 VAP-344
 ;  SAMIUR2: make capitalization consistent.
 ;
 ; 2020-01-01/05 ven/arc 1.18.0 399f8547,62e3200f
 ;  SAMIUR: unmatched participant processing.
 ;  SAMIUR2: add unmatched patient processing.
 ;
 ; 2020-01-10 ven/gpl 1.18.0 1590577
 ;  SAMIUR2: fix return on RACE^SAMIUR2 for cache.
 ;
 ; 2020-04-29/05-13 ven/gpl 1.18.0.5+i5 e8b8ea2d,61c7d208
 ;  SAMIUR: fixes for reports, worklist functionality.
 ;
 ; 2020-05-13/14 ven/gpl 1.18.0.5+i5 61c7d20,b05df41
 ;  SAMIUR2: add worklist functionality, fix gender & dob detection on
 ; reports.
 ;
 ; 2021-03-22/23 ven/gpl 1.18.0.10+i10 256efe63,ba81b86a2
 ;  SAMIUR: sort all reports by name, added row totals to reports.
 ;
 ; 2021-03-23 ven/toad 1.18.0.10+i10 96f461d0,af86e0eb
 ;  SAMIUR: add version info & dev log, lt refactor, fix XINDEX
 ; errors.
 ;
 ; 2021-03-29 ven/gpl 1.18.0.11+i11 e809f2a2
 ;  SAMIUR: prevent crash when reports have no matches: in WSREPORT
 ; set SRT="" and uncomment zwrite SRT; in WKLIST add 2 commented-out
 ; debugging lines.
 ;
 ; 2021-03-30 ven/toad 1.18.0.11+i11 7b14bb2
 ;  SAMIUR: bump version, date, log; in WSREPORT comment zwrite SRT.
 ;
 ; 2021-03-31 ven/gpl 1.18.0.11+i11 66d89cd
 ;  SAMIUR: sort on all uppercase names for reports
 ;
 ; 2021-04-13 ven/gpl 1.18.0.11+i11 a12765b,f09ffef,fb399ab
 ;  SAMIUR: inactive report created.
 ;  SAMIUR2: in RPTTBL,GENDER create inactive report, move last exam
 ; column on followup report, fix gender being blank in reports.
 ;
 ; 2021-05-20/25 ven/mcglk&toad 1.18.0.11+i11
 ;  SAMIUR: annotate, lt refactor, bump version.
 ;  SAMIUR2: passim hdr comments, chg log, annotate, refactor, bump
 ; version.
 ;
 ; 2021-05-29 ven/gpl 1.18.0.12-t2+i12 e6fd5730,a3d6f9a0
 ;  SAMIUR,SAMIUR2 ssn params & matching report, update unmatched
 ; report headings.
 ;
 ; 2021-06-15 ven/gpl 1.18.0.12-t2+i12 7e481426
 ;  SAMIUR add site to editperson navigation.
 ;
 ; 2021-06-28 ven/gpl 1.18.0.12-t2+i12 df0aaea1,1137e2bb
 ;  SAMIUR change definition of inactive to not marked active, change
 ; definition of active to marked active.
 ;
 ; 2021-07-06 ven/mcglk&toad&gpl 1.18.0.12-t2+i12 cbf7e46b,2d642aa4
 ;  SAMIURUL new routine for dev log.
 ;  SAMIUR,SAMIUR2,SAMIURUL move dev log & module docs to SAMIURUL,
 ; bump version & dates.
 ;  SAMIUR in SELECT r/inactive w/status, test for active instead of
 ; inactive.
 ;
 ;
 ;
 ;@contents
 ; SAMIUR user reports
 ; SAMIUR2 user reports cont
 ; SAMIURUL user reports log
 ;
 ; SAMIUR1 [to be added]
 ;
 ;
 ;
EOR ; end of SAMIURUL
