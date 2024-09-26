SAMICTUL ;ven/gpl - ct report & copy log ;2021-11-16t21:47z
 ;;18.0;SAMI;**10,11,12,13,15**;2020-01;
 ;;18.15
 ;
 ; SAMICTUL contains routine & module info & the primary development
 ; log for VAPALS-ELCAP's CT Report ctreport web service route, which
 ; is implemented by the SAMICTR* (html) and SAMICTT* (text)
 ; routines. It also contains the log for the SAMICTC* routines that
 ; implement the ct form copy operation.
 ; SAMICTUL contains no public interfaces or executable code.
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
 ;@dev-main George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org-main Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-update 2021-11-16t21:47z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@version 18.15
 ;@release-date 2020-01
 ;@patch-list **10,11,12,15**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Alexis Carlson (arc)
 ; alexis.carlson@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
 ;
 ;@module-credits
 ;@project VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding 2017/2021, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org International Early Lung Cancer Action Program (IELCAP)
 ; http://ielcap.com/
 ;@partner-org Paraxial Technologies (par)
 ; http://paraxialtech.com/
 ;@partner-org Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2018-07-01/05 ven/arc&lgc 18.0 8b0a4329,f5ff7eeb,5549cd30
 ;  SAMICTD2 1st version of CT Eval Report, fix init routine, get
 ; lungrads & nonodules working.
 ;
 ; 2018-10-14 ven/arc 18.0 f6e1229
 ;  SAMICTC1 turn on copy forward for cteval new forms
 ;
 ; 2018-12-11/2019-01-22 ven/lgc&lmry 18.0 9925713f,3ceb74b,3bb70c8,
 ; d22e0f21,5368121
 ;  SAMICTC1,2,D2 sac compliance, add license info.
 ;
 ; 2020-02-01/03 ven/arc 18.4 d47135a5,bc32c1cb,5b2e4525,7bcd14a2,
 ; 1c96fe0e,cb0075e8,5e553dd2,9cde6840,dcea0048e,98b7b273,a4f98f19
 ;  SAMICTT0,1,2,3,4,9,A routines (starting as copies of SAMICTR*) to
 ; implement ctreport in text format, start convert nodules to text,
 ; add'l lung findings, fix parag spacing, add impressions sect,
 ; recommendations sect, add'l sects on other abnormalities, breast
 ; abnorm sect, other abnorm sect, tweak format, make it more compact.
 ;
 ; 2021-02-18 ven/gpl 18.10 38fb2d70
 ;  SAMICTT0,1,2,3,4,9,A ct report - insert space after every period.
 ;
 ; 2021-03-04/16 ven/gpl 18.10 e09d5f16,3ea26de9,91793ba3
 ;  SAMICTT1,3,4 ct report: fix normal cardiac default output, CAC
 ; logic, other enhancements.
 ;
 ; 2021-03-23 ven/gpl 18.10 a68f7f31
 ;  SAMICTT3 fix CAC problem.
 ;
 ; 2021-03-21/23 ven/toad 18.10 96f461d
 ;  SAMICTUL: create development log routine.
 ;  SAMICTT0,1,2,3,4,9,A bump date & version, lt refactor.
 ;
 ; 2021-05-14 ven/gpl 18.11 0a01cf2
 ;  SAMICTTA in RCMND change to ctreport for no followup ct w/other
 ; followup recommendations, "Followup" instead of "Other Followup."
 ;
 ; 2021-05-19 ven/gpl 18.11 a21b056,139c6a5
 ;  SAMICTT0 in WSREPORT check for small nodule checkboxes.
 ;  SAMICTT1 in NODULES urgent fix to add to ct report "Small [non-]
 ; calcified nodules are present."
 ;
 ; 2021-05-20/21 ven/mcglk&toad 18.11 43a4557,129e96b
 ;  SAMICTT0,1 bump version & dates.
 ;
 ; 2021-05-24 ven/gpl 18.11 4aba1a9
 ;  SAMICTC1 in CTCOPY add new param key to control two new opening
 ; blocks, critical fix to copy forward for Is It New field for new ct
 ; eval forms.
 ;
 ; 2021-05-25 ven/toad 18.11 801d7c7
 ;  SAMICTC1 bump version & dates; passim annotate & lt refactor.
 ;  SAMICTUL add SAMICTC* routines to log.
 ;
 ; 2021-06-01 ven/gpl 18.11 e86756e
 ;  SAMICTC1 corrected bug on CT eval copy forward: in CTCOPY stanza
 ; 2 q:isnew="".
 ;
 ; 2021-06-04 ven/toad 18.11 7dd9410c,911264de
 ;  SAMICTC1 fold in gpl chg, log, bump dates.
 ;
 ; 2021-07-19 ven/gpl 18.12 e9359411
 ;  SAMICTD2 chg minimal to mild for emphysema in ct report.
 ;
 ; 2021-08-17 ven/gpl 18.13 023fcdff
 ;  SAMICTT3 correct typo in field name for circumflex in CAC section
 ;
 ; 2021-10-19 ven/gpl 18-15 520cbe86,f9b7b5a1,137e131e,514476c3,ba04a578,
 ;  013dd1ad
 ;  SAMICTT0 remove extra space in front of Description, surpress comparison 
 ;  scans on baseline CT eval
 ;  SAMICTT3 added GENLNL for lymph nodes, fixed pleural effusion logic, if no
 ;  input, say CAC score not provided,new lymph node table generated from the
 ;  ct eval tsv graph
 ;  SAMICTD2 remove above from Impression section of ct rpt and followup note
 ;
 ; 2021-10-21 ven/gpl 18-15 5b9cd54b
 ;  SAMICTT3 fix in lymph node description algorithm
 ;
 ; 2021-10-25 ven/gpl 18-15 d147d56f
 ;  SAMICTT3 corrections to pleura and lymph node report text
 ;
 ; 2021-10-26 ven/gpl 18-15 cd36ee6a,f31f8722
 ;  SAMICTT0 fixed CT report Comparison Scans logic
 ;  SAMICTT3 change working on emphysema score not provided
 ;
 ; 2021-10-28 ven/gpl 18-15 194989af
 ;  SAMICTT3 fix detecting no cac score provided
 ;
 ; 2021-10-29 ven/lmry 18-15 3d66553e,6e9594e8
 ;  SAMICTT0 SAMICTT3 bump versions and dates
 ;  SAMICTT3 add semi-colon after GENLNL for XINDEX
 ;
 ; 2021-11-10 ven/gpl 18-15  c9ab7f07
 ;  SAMICTT3 new logic for CAC and Emphysema report output
 ;
 ; 2021-11-16 ven/lmry 18-15
 ; SAMICTT3 bump versions and dates
 ;
 ;
 ;@contents
 ; SAMICTC1 ceform copy
 ; SAMICTC2 ceform copy continued
 ;
 ; SAMICTD2 cteval-dict init
 ;
 ; SAMICTT0 ctreport text main
 ; SAMICTT1 ctreport text nodules
 ; SAMICTT2 ctreport text other lung
 ; SAMICTT3 ctreport text emphysema
 ; SAMICTT4 ctreport text breast abnorm
 ; SAMICTT9 ctreport text impressions
 ; SAMICTTA ctreport text recommendations
 ; SAMICTUL ctreport log
 ;
 ; SAMICTR* ctreport html format
 ; SAMIUTR* test the SAMICTR routines
 ;
 ;
 ;
EOR ; end of routine SAMICTUL
