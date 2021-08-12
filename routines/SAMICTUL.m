SAMICTUL ;ven/gpl - ct report & copy log ;2021-07-21t20:19z
 ;;18.0;SAMI;**10,11,12**;2020-01;
 ;;18.12
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
 ;@last-update 2021-07-21t20:19z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@version 18.12
 ;@release-date 2020-01
 ;@patch-list **10,11,12**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Alexis Carlson (arc)
 ; alexis.carlson@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
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
 ;  SAMICTD2 chg minimal to mild for emphesema in ct report.
 ;
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
