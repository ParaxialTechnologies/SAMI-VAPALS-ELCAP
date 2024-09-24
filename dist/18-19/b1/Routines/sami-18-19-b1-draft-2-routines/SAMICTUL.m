SAMICTUL ;ven/gpl - ct report & copy log; 2024-09-24t17:15z
 ;;18.0;SAMI;**10,11,12,13,15**;2020-01-17;Build 1
 ;mdc-e1;SAMICTUL-20240924-E1n9lRx;SAMI-18-19-b1
 ;mdc-v7;B124081;SAMI*18.0*19 SEQ #19
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
 ;@license Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@update 2024-09-24t17:15z
 ;@app-suite Screening Applications Management -SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module CT Report - SAMICT
 ;@release 18-19
 ;@edition-date 2020-01-17
 ;@patches **10,11,12,15,19**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Alexis Carlson (arc)
 ; alexis.carlson@vistaexpertise.net
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
 ;@partner-org International Early Lung Cancer Action Program (IELCAP)
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
 ; 2018-07-01/05 ven/arc&lgc 18-0 8b0a4329,f5ff7eeb,5549cd30
 ;  SAMICTD2 1st version of CT Eval Report, fix init routine, get
 ; lungrads & nonodules working.
 ;
 ; 2018-10-14 ven/arc 18-0 f6e1229
 ;  SAMICTC1 turn on copy forward for cteval new forms
 ;
 ; 2018-12-11/2019-01-22 ven/lgc&lmry 18-0 9925713f,3ceb74b,3bb70c8,
 ; d22e0f21,5368121
 ;  SAMICTC1,2,D2 sac compliance, add license info.
 ;
 ; 2020-02-01/03 ven/arc 18-4 d47135a5,bc32c1cb,5b2e4525,7bcd14a2,
 ; 1c96fe0e,cb0075e8,5e553dd2,9cde6840,dcea0048e,98b7b273,a4f98f19
 ;  SAMICTT0,1,2,3,4,9,A routines (starting as copies of SAMICTR*) to
 ; implement ctreport in text format, start convert nodules to text,
 ; add'l lung findings, fix parag spacing, add impressions sect,
 ; recommendations sect, add'l sects on other abnormalities, breast
 ; abnorm sect, other abnorm sect, tweak format, make it more compact.
 ;
 ; 2021-02-18 ven/gpl 18-10 38fb2d70
 ;  SAMICTT0,1,2,3,4,9,A ct report - insert space after every period.
 ;
 ; 2021-03-04/16 ven/gpl 18-10 e09d5f16,3ea26de9,91793ba3
 ;  SAMICTT1,3,4 ct report: fix normal cardiac default output, CAC
 ; logic, other enhancements.
 ;
 ; 2021-03-23 ven/gpl 18-10 a68f7f31
 ;  SAMICTT3 fix CAC problem.
 ;
 ; 2021-03-21/23 ven/toad 18-10 96f461d
 ;  SAMICTUL: create development log routine.
 ;  SAMICTT0,1,2,3,4,9,A bump date & version, lt refactor.
 ;
 ; 2021-05-14 ven/gpl 18-11
 ;  SAMICTTA (F2hup1P B35394677 E2n+tbl) 0a01cf26
 ; in RCMND change to ctreport for no followup ct w/other followup
 ; recommendations, "Followup" instead of "Other Followup."
 ;
 ; 2021-05-19 ven/gpl 18-11 a21b056,139c6a5
 ;  SAMICTT0 in WSREPORT check for small nodule checkboxes.
 ;  SAMICTT1 in NODULES urgent fix to add to ct report "Small [non-]
 ; calcified nodules are present."
 ;
 ; 2021-05-20/21 ven/mcglk&toad 18-11 43a4557,129e96b
 ;  SAMICTT0,1 bump version & dates.
 ;  SAMICTTA (F3hDd8l B35394711 E2n%wGx) 43a4557c
 ; refactored routines.
 ;  SAMICTTA (FL8+iA B35698365 E3Rw+I%) 129e96b1
 ; upgrade semver f/1.18.0.11-i11 t/1.18.0.11+i11.
 ;
 ; 2021-05-24 ven/gpl 18-11 4aba1a9
 ;  SAMICTC1 in CTCOPY add new param key to control two new opening
 ; blocks, critical fix to copy forward for Is It New field for new ct
 ; eval forms.
 ;
 ; 2021-05-25 ven/toad 18-11 801d7c7
 ;  SAMICTC1 bump version & dates; passim annotate & lt refactor.
 ;  SAMICTUL add SAMICTC* routines to log.
 ;
 ; 2021-06-01 ven/gpl 18-11 e86756e
 ;  SAMICTC1 corrected bug on CT eval copy forward: in CTCOPY stanza
 ; 2 q:isnew="".
 ;
 ; 2021-06-04 ven/toad 18-11 7dd9410c,911264de
 ;  SAMICTC1 fold in gpl chg, log, bump dates.
 ;
 ; 2021-07-19 ven/gpl 18-12 e9359411
 ;  SAMICTD2 chg minimal to mild for emphysema in ct report.
 ;
 ; 2021-08-17 ven/gpl 18-13 023fcdff
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
 ; 2021-10-28 ven/gpl 18-15
 ;  SAMICTT3 (F? B? E?) 194989af
 ; fix detecting no cac score provided.
 ;  SAMICTUL (F19ksFF B106674 E2Hz1Jr) c066b29a
 ; update module-log, bump vers + dates.
 ;  SAMICTUL (F2W+4mZ B106674 E3fCKM2) 46752360
 ; missed a couple little things.
 ;
 ; 2021-10-29 ven/lmry 18-15 3d66553e,6e9594e8
 ;  SAMICTT0 (F? B? E?)
 ; bump vers + dates.
 ;  SAMICTT3 (F? B? E?)
 ; add semi-colon after GENLNL for XINDEX; bump vers + dates.
 ;  SAMICTUL (F2nMtCJ B107594 E3vbBxz) 6e9594e8
 ; XINDEX fixes.
 ;
 ; 2021-11-10 ven/gpl 18-15 c9ab7f07
 ;  SAMICTT3 (F? B? E?)
 ; new logic for CAC & Emphysema report output.
 ;
 ; 2021-11-16 ven/lmry 18-15-b2 89a88ec0
 ;  SAMICTT3 (F? B? E?)
 ;  SAMICTUL (F3sc5+d B108974 E+qel0)
 ; bump vers + dates
 ;
 ; 2024-09-20 ven/gpl 18-19-b1
 ;  SAMICTT4 () d6ca4523
 ;  SAMICTT9 () d6ca4523
 ;  SAMICTTA (F1nOm2b B41320376 EuB8pQ) d6ca4523
 ; CT report changes.
 ;  SAMICTT9 () 9c0cb068
 ; further changes to CT reports.
 ;  SAMICTTA (F2vekZ3 B41346853 E2QmAB) c121db8a
 ; additional changes to CT report.
 ;  SAMICTT0 () 75a48d48
 ; change CT report to use correct Study ID.
 ;  SAMICTT0 () f3cd77f1
 ;  SAMICTT1 () f3cd77f1
 ;  SAMICTT2 () f3cd77f1
 ;  SAMICTT3 () f3cd77f1
 ;  SAMICTT4 () f3cd77f1
 ;  SAMICTT9 () f3cd77f1
 ;  SAMICTTA (FyhgTh B42560817 E3TxLk) f3cd77f1
 ; remove double periods from text in CT reports.
 ;
 ; 2024-09-22 ven/gpl 18-19-b1 2bf9a683
 ;  SAMICTT3 ()
 ; Aortic Valve Calcification bug fixed in CT Report.
 ;
 ; 2024-09-24 ven/toad 18-19-b1
 ;  SAMICTT0 (F3qAecA B112661946 E3wQFOj)
 ;  SAMICTT1 (FDHgIo B154195678 Egyq4v)
 ;  SAMICTT2 (F39yi3O B144641835 E1bbLr)
 ;  SAMICTT3 (F1qxpno B483818586 E1o9ZtO)
 ;  SAMICTT4 (FI%e+H B62798123 E25ZW78)
 ;  SAMICTT9 (F1L1LJi B30429822 E2JP4uz)
 ;  SAMICTTA (F1eQ6rR B49833239 E1+hRO+)
 ;  SAMICTUL (F? B124081 E?)
 ; new ver lines, bump vers + dates + project, add chksums to recent
 ; log entries, update hdr comments, mv subrtn hdr comments before
 ; subs, light refactoring.
 ;
 ;@to-do
 ;
 ; add chksums to older log entries, add details to log
 ;
 ;@contents
 ;
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
