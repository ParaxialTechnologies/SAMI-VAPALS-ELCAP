SAMICUL ;ven/gpl - case review log; 2024-09-09t12:56z
 ;;18.0;SAMI;**9,11,12,14,15,17,18**;2020-01-17;Build 8
 ;mdc-e1;SAMICUL-20240909-E1nq%WL;SAMI-18-18-b1
 ;mdc-v7;B180174;SAMI*18.0*18 SEQ #18
 ;
 ; SAMICUL contains the development log for the ScreeningPlus Case
 ; Review Page (SAMICA* routines). It contains no executable code.
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
 ;@update 2024-09-09t12:56z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module case review - SAMICA
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release SAMI-18-18
 ;@edition-date 2020-01-17
 ;@patches **9,11,12,14,15,17,18**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@dev-add Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@dev-add Domenick DiNatale (ddn)
 ; domenic@intellitechinnovations.com
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
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
 ; 2018-01-14 ven/gpl 18-t4
 ;  SAMICASE split from routine SAMIFRM, incl wsCASE,GETTMPL,GETITEMS,
 ; casetbl.
 ;
 ; 2018-02-05/08 ven/toad 18-t4
 ;  SAMICASE update style, license, & attribution, spell out language
 ; elements, add white space & do-dot quits, r/replaceAll^%wfhfrom w/
 ; replaceAll^%wf, r/$$getTemplate^%wfhform w/$$getTemplate^%wf.
 ;
 ; 2018-02-14 ven/toad 18-t4
 ;  SAMICASE r/replaceAll^%wf w/findReplaceAll^%wf, r/ln w/line, add
 ; @calls & @called-by tags, break up some long lines.
 ;
 ; 2018-02-27 ven/gpl 18-t4
 ;  SAMICASE new subroutines $$KEY2DSPD, $$GETDTKEY; in wsCASE get
 ; 1st & last names from graph, fix paths, key forms in graph w/date.
 ;
 ; 2018-03-01 ven/toad 18-t4
 ;  SAMICASE refactor & reorganize new code, add header comments, r/
 ; findReplaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-06 ven/gpl 18-t4
 ;  SAMICASE add New Form button, list rest of forms for patient, add
 ; web services wsNuForm & wsNuFormPost & method MKCEFORM, extend
 ; GETITEMS to get rest of forms.
 ;
 ; 2018-03-07/08 ven/toad 18-t4
 ;  SAMICASE merge George changes w/ rest, add white space, spell out
 ; M elements, add hdr comments to new subroutines, r/findReplace^%wf
 ; & replaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-11 ven/gpl 18-t4 9bd663ee
 ;  SAMICAS2 vapals forms working.
 ;
 ; 2018-03-12 ven/gpl 18-t4 8c36c6a7
 ;  SAMICAS2 new form works now & charts on home page.
 ;
 ; 2018-03-14 ven/gpl 18-t4 9653650a
 ;  SAMICAS2 revised casereview page link, fixed external url
 ; preservation.
 ;
 ; 2018-03-21 ven/gpl 18-t4 48868561
 ;  SAMICAS2 max date insertion, case review navigation changed to
 ; post, date order for CT Eval in case review.
 ;
 ; 2018-03-26 ven/gpl 18-t4 5fa4ee96
 ;  SAMICAS2 changes to support incomplete forms display &
 ; processing.
 ;
 ; 2018-03-27 ven/gpl 18-t4 cace9756
 ;  SAMICAS2 siforms are always complete.
 ;
 ; 2018-04-02 ven/gpl 18-t4 00da9146
 ;  SAMICAS2 added followup form.
 ;
 ; 2018-04-24 ven/gpl 18-t4 22e39d87
 ;  SAMICAS2 added pet & biopsy forms.
 ;
 ; 2018-05-01 ven/gpl 18-t4 f1751c43
 ;  SAMICAS2 fix problem with new forms: followup & pet.
 ;
 ; 2018-05-18 ven/lgc 18-t4 9eba8f8c
 ;  SAMICAS2 conversion to new graph and simplified forms processing.
 ;
 ; 2018-05-21 ven/lgc 18-t4 0d7ed2f7
 ;  SAMICAS2 changes for new navigation html.
 ;
 ; 2018-06-14 ven/lgc 18-t4 d71f4fe4
 ;  SAMICAS2 changes to make the background form optional.
 ;
 ; 2018-06-20 ven/lgc 18-t4 bf03b07f
 ;  SAMICAS2 corrections for new forms processing navigation.
 ;
 ; 2018-07-01 ven/lgc 18-t4 2e1541dc,8b0a4329
 ;  SAMICAS2 add intervention forms to case review page, 1st version
 ; of ct eval report.
 ;
 ; 2018-07-04 ven/lgc 18-t4 b28c1658
 ;  SAMICAS2 fix a typo.
 ;
 ; 2018-07-10 ven/lgc 18-t4 2e9662b4
 ;  SAMICAS2 repair SAMIHOM3 & redact report link.
 ;
 ; 2018-08-19 ven/lgc 18-t4 2ce0cab4
 ;  SAMICAS2 use ssn instead of last5 where available.
 ;
 ; 2018-08-20 ven/lgc 18-t4 955fd484
 ;  SAMICAS2 fix case review page cr lf issue.
 ;
 ; 2018-08-22 ven/gpl 18-t4 d67a2fe5
 ;  SAMICAS2 turn off ctreport.
 ;
 ; 2018-08-30 ven/lgc 18-t4 125f1c8b
 ;  SAMICAS2 add type index to getItems to help find last previous
 ; form of a type.
 ;
 ; 2018-09-04 ven/lgc 18-t4 3e6e326f
 ;  SAMICAS2 hide report link.
 ;
 ; 2018-10-14 ven/lgc 18-t4 f6e1229f
 ;  SAMICAS2 turn on copy forward for cteval new forms.
 ;
 ; 2018-10-26 ven/lgc 18-t4 f19bf1ae
 ;  SAMICAS2 ability to add multiple forms on same day.
 ;
 ; 2018-11-07 ven/gpl 18-t4 c76b2eac
 ;  SAMICAS2 defend against unit test patient 1.
 ;
 ; 2018-11-13 ven/toad 18-t4
 ;  SAMICAS2 SAMIHOM2 > SAMIHOM3.
 ;
 ; 2018-11-14 ven/lgc 18-t4 6e9799ba
 ;  SAMICUL fix graphstore forms.
 ;
 ; 2018-11-28 ven/lgc 18-t4 a9539464
 ;  SAMICAS2 work on sac compliance.
 ;
 ; 2018-12-11 ven/lgc 18-t4 3ceb74b5
 ;  SAMICAS2 update for sac compliance.
 ;
 ; 2018-12-19/20 ven/lgc 18-t4 7a5d3400,a14554c1
 ;  SAMICAS2 more sac compliance, r/^gpl w/^SAMIGPL.
 ;
 ; 2018-12-26 ven/lgc 18-t4 8dd6f34d,51eb1635
 ;  SAMICAS2 update for sac compliance, fix accidental reversions.
 ;
 ; 2019-01-10 ven/lgc 18-t4 2daba010
 ;  SAMICAS2 update for SAC compliance.
 ;
 ; 2019-01-22 ven/lgc 18-t4 53681219,5ddb29c5
 ;  SAMICAS2 add license info to each SAMI routine; edit for lower
 ; case initials.
 ;
 ; 2019-02-18 ven/lgc 18-t4 76874314
 ;  SAMICAS2,SAMICAS3 update recently edited routines.
 ;
 ; 2019-03-13 ven/lmry 18-t4 ef66ef16
 ;  SAMICAS2 spell out some elements missed earlier.
 ;
 ; 2019-03-14 ven/lmry 18-t4 038507e2
 ;  SAMICAS3 spell out some missed M elements, fix copy/paste errors
 ; in comments for MKFUFORM, MKBXFORM, & MKPTFORM.
 ;
 ; 2019-04-16 ven/lgc 18-t4 e54b76d1
 ;  SAMICAS2 update for SAMIFORM project.
 ;
 ; 2019-04-23 ven/gpl 18-t4 ce322911
 ;  SAMICAS2 add intake notes to case review page.
 ;
 ; 2019-06-18 ven/lgc 18-t4 91022482
 ;  SAMICAS3 switch fr/global ^SAMIGPL to/^SAMIUL.
 ;
 ; 2019-07-01 ven/gpl 18-t4 cc87cc44
 ;  SAMICAS3 prevent >1 bkgd form/patient.
 ;
 ; 2019-07-07 ven/gpl 18-t4 776f7451
 ;  SAMICAS3 resolving can't create bkgd form, branch messed up.
 ;
 ; 2019-08-01 ven/lgc 18-t4 d710f27d
 ;  SAMICAS2 pull displayed facility code from Vista parameter.
 ;
 ; 2019-09-26 ven/gpl 18-t4 92b12324 vap-420
 ;  SAMICAS3 prefill form date & date of baseline ct on new followup
 ; form.
 ;
 ; 2019-10-01 par/dom 18-t4 4caf1a98 vap-344
 ;  SAMICAS2 (FIM+f B309347987 E3EG98i) use proper capitalization of the word "veteran".
 ;
 ; 2020-01-11 ven/lgc 18 5651698a
 ;  SAMICAS2 (F2GXiGC B319162298 E1CRxLY)
 ;  SAMICAS3 ()
 ; fix duplicate form overwriting.
 ;
 ; 2020-01-17 ven/lgc 18-1 8557207f
 ;  SAMICAS2 (F1bHTm1 B331580525 EXBYvm) followup note.
 ;
 ; 2020-01-25 ven/lgc 18-3 6a07a860,6a947567
 ;  SAMICAS3 nodule copy & fix to ru, fix subtle bug in nodule copy.
 ;
 ; 2020-04-11 ven/gpl 18-5 666f5b91
 ;  SAMICAS2 (F25+rkm B352281238 E11vF2K) multi-tenancy progress.
 ;
 ; 2020-04-11 ven/gpl 18-5 2f2c29c1
 ;  SAMICAS2 (FbUQid B355765098 E3XONvI) the crux of multi-tenancy.
 ;
 ; 2020-05-12 ven/gpl 18-5 ad11e0ea
 ;  SAMICAS2 (F1CMJy8 B375024495 E8GidN) fix SITE on case review page.
 ;
 ; 2020-11-12 ven/gpl 18-9 cec1ccd6
 ;  SAMICAS2 (F2Q4gQo B338677866 EAbsc%)
 ;  SAMICAS3 ()
 ; ceform date refill upgrade.
 ;
 ; 2020-11-13 ven/gpl 18-9 dce3c568
 ;  SAMICAS3 prefill ceform prior scans text field.
 ;
 ; 2021-02-18 ven/gpl 18-9 af2a0b8a
 ;  SAMICAS3 copy last previous CT nodules instead of last nodules in
 ; any form.
 ;
 ; 2021-02-21 ven/gpl 18-9 3fd704fb
 ;  SAMICAS3 fix bug in prefill logic.
 ;
 ; 2021-03-02 ven/gpl 18-9 479dc041
 ;  SAMICAS2 (F7egiN B346281253 E1u9j9a) return error msg if no CT
 ; Eval form exists when generating a FU note.
 ;
 ; 2021-03-10 ven/toad 18-9 a46a2cc1
 ;  SAMICUL update log, convert to new vistaver schema.
 ;  SAMICAS2,SAMICAS3 bump date & patch list, update contents, lt
 ; refactor.
 ;
 ; 2021-03-16 ven/toad 18-9 a46a2cc1
 ;  SAMICAS2 (F1DUSfS B381191061 E3L+oln) update VAPALS-ELCAP
 ; 1.18.0.9-i9 package elements.
 ;
 ; 2021-03-17 ven/toad 18-9 62da30b4
 ;  SAMICAS2 (Fxj+tI B381201104 E34EUOc) fix xindex errors: in WSCASE
 ; add missing space between do & comment to prevent syntax error
 ; reported as block mismatch.
 ;  SAMICAS3 remove extra spaces at ends of 3 lines.
 ;
 ; 2021-04-16 ven/gpl 18-11 ac82eec
 ;  SAMICAS3 include baseline scan in prior scans field on prefill.
 ;
 ; 2021-05-14/19 ven/gpl 18-11 0cbee7b,a21b056,139c6a5,0a0cccc
 ;  SAMICAS3 improved CT eval prefill of past scan dates, urgent
 ; fixes to CT Report & intervention & pet form prefill.
 ;
 ; 2021-05-20/21 ven/mcglk&toad 18-11 43a4557,424ea11,129e96b
 ;  SAMICAS3 bump version & dates.
 ;
 ; 2021-05-24 ven/gpl 18-11 4aba1a9
 ;  SAMICAS3 in MKCEFORM,MKPTFORM,MKBXFORM pass key to
 ; CTCOPY^SAMICTC1 to modulate node-copy operation; critical fix to
 ; copy forward for is it new field for new ct eval forms.
 ;
 ; 2021-05-25 ven/toad 18-11 801d7c74
 ;  SAMICAS3 bump date; passim lt refactor.
 ;  SAMICUL () update logs, bump dates.
 ;
 ; 2021-05-26/27 ven/gpl 18-11 6edc0610,73728821
 ;  SAMICAS3 in MKITFORM add new nodule-copy block to copy forward
 ; for intervention form; in LASTCMP,PRIORCMP init tdt to today to
 ; start before today, to fix last comp & prior scan field prefill in
 ; ct eval form.
 ;
 ; 2021-06-01 ven/toad 18-11 7dd9410c
 ;  SAMICAS3 fold in gpl chgs fr 2021-05-26/27, annotate, adjust news
 ; in nodule copy blocks, bump date.
 ;
 ; 2021-06-04 ven/toad 18-12 7dd9410c
 ;  SAMICUL (F3jrhqk B138062 Egziza) eight versioned, logged,
 ; annotated, refactored routines.
 ;
 ; 2021-06-29 ven/gpl 18-12 50d3998b,a5bbd37a
 ;  SAMICAS3 in LASTCMP fix bug that excluded ct forms from today in
 ; date list, init tdt to today+1 to start today; text-box formatting
 ; for intake & followup notes, new text-processing utils; in MKFUFORM
 ; set basedt to $$BASELNDT or $$LASTCMP or now.
 ;
 ; 2021-06-30/07-06 ven/mcglk&toad&gpl 18-12 d8296fda,b248664b
 ;  SAMICASE,3 bump version & dates.
 ;  SAMICAS3 in MKFUFORM,LASTCMP update calls & called-by.
 ;  SAMICASE,2,3 finish converting to ppi format, annotate; fix typos.
 ;
 ; 2021-07-01 ven/mcglk&toad 18-12 cbf7e46b
 ;  SAMICAS2 (F1yRLtn B443014164 E1W9a3U)
 ;  SAMICUL (F3uTWha B143817 E3ASV%q)
 ; bump version & dates for sami 1.18.0.12-t2+i12.
 ;
 ; 2021-07-06 ven/toad 18-12-b2 b248664b
 ;  SAMICUL (F3irXA1 B144047 E2+qPp6) fold in gpl chgs, fix other
 ; typos, update dates & dev logs.
 ;
 ; 2021-07-14 ven/toad 18-12-b3 e36d755d
 ;  SAMICAS2 (F2zRM7j B443014182 E2X9aJM)
 ;  SAMICUL (F1v%6WV B144065 E1Bzqn7)
 ; bump 12-t2 to 12-t3, log commit ids, date formats.
 ;
 ; 2021-08-01 ven/gpl 18-12 5bd7c627
 ;  SAMICAS2 (F3vS6hS B445298931 E3TAObN) set intake form to
 ; incomplete on creation: in GSAMISTA add final line to conditionally
 ; set stat="incomplete".
 ;
 ; 2021-08-01 ven/gpl 18-12 50620b8b
 ;  SAMICAS3 exclude current date from last compare field when prev ct
 ; report exists: in LASTCMP start w/before today; in PRIORCMP add
 ; line to handle retstr="".
 ;
 ; 2021-08-11 ven/toad 18-12 b16cd38f
 ;  SAMICAS2 (F1TfG16-B445469337-E11Nfz9)
 ;  SAMICUL (F2i2oJW B134436 E1+1eLO)
 ; SAMI 18-12 routines ready to validate.
 ;
 ; 2021-10-04 ven/gpl 18-14-b3 ec3b6e5d
 ;  SAMICAS2 (F3Au2YF B447463868 E2kcIFe) fix for patch 14t3.
 ;
 ; 2021-10-05 ven/lmry 18-14 d4d1b115
 ;  SAMICAS2 (Fh23Ov B447463890 E2Zcbeb)
 ;  SAMICUL (F35Kvr%-B135148-E1mumY2)
 ; update histories, bump vers + dates.
 ;
 ; 2021-10-05 ven/lmry 18-14 48a6bf42
 ;  SAMICUL (F1gOhrP B135148 ELyjQQ) add git ids.
 ;
 ; 2021-10-26 ven/gpl 18-15 23e68f40
 ;  SAMICAS3 init last comparative & prior scan fields to blank if
 ; there were none.
 ;
 ; 2021-10-28 ven/lmry 18-15 818f7924
 ;  SAMICUL (F3ALMBu B136079 EAldk5)
 ; add to module log, bump date + ver.
 ;
 ; 2024-07-24 ven/gpl 18-17-b5 fefbf290
 ;  SAMICAS3 (F1E7OZJ B503791124 E2BHgUe)
 ; chgs for Mt. Sinai MRN & STUDYID.
 ;
 ; 2024-07-25 ven/gpl 18-17-b5 21f8aa18
 ;  SAMICAS4 (F3WIeHw B551554 ETT4%p)
 ; new rtn to generate Mt. Sinai clinical info line to carry over to
 ; CTEVAL from Background form.
 ;
 ; 2024-07-27 ven/gpl 18-17-b5 2e91afbf
 ;  SAMICAS4 (F2yi1x8 B6039908 E3vsSN+)
 ; progress on clinical info for cteval form.
 ;
 ; 2024-07-28 ven/gpl 18-17-b5 386103da
 ;  SAMICAS4 (F9dNf B8278420 E16AsQZ)
 ; background form clinic info text extract for cteval form complete.
 ;
 ; 2024-08-03 ven/gpl 18-17-b5 2524afd6
 ;  SAMICAS4 (F2bZS6W B10844433 E3YjdEP)
 ; add # years since quitting to clinical info string.
 ;
 ; 2024-08-05 ven/gpl 18-17-b5 b92768bc
 ;  SAMICAS4 (F3qefGe B10892126 EnpBKO)
 ; add space after ';' in clinical info text of CT form.
 ;
 ; 2024-08-06 ven/gpl 18-17-b5 8e2a78f0
 ;  SAMICAS4 (F1wlaE0 B12404533 E2tvwV6)
 ; preserve clinical info fr/background form to/CTEVAL.
 ;
 ; 2024-08-12 ven/lmry 18-17-b5 eea98cdb
 ;  SAMICAS3 (F2MCHYU B505739599 EDYWOu)
 ;  SAMICAS4 (F32r7Or B12746608 EwBTMA)
 ;  SAMICUL (FqzTTA B143242 E1nLZ+t)
 ; update history, bump dates + vers.
 ;
 ; 2024-08-16 ven/lmry 18-17-b6 a1a28de6
 ;  SAMICAS3 (F3yMXKa B505739588 EBXwUh)
 ;  SAMICAS4 (F3RsSBA B12746597 EuBeEx)
 ;  SAMICUL (F2GT7n B144151 EIEjF+)
 ; update history, dates, + vers of routines for 18-17-b6.
 ;
 ; 2024-08-16 ven/lmry 18-17-b6 d0224d9e
 ;  SAMICUL (FQG2XL B144151 EgEIfY) some post XINDEX fixes.
 ;
 ; 2024-18-17 ven/lmry 18-17-b6
 ;  SAMICUL update history
 ;  SAMICAS3,4,UL bump dates + vers, 18-18-t1 > 18-17-b6.
 ;
 ; 2024-08-21/22 ven/toad 18-17-b6
 ;  SAMICAS3,4 reorganize subroutines, annotate, move the following
 ; SAMICAS3 subroutines to SAMICAS4 to meet VA SAC routine-size limit:
 ; BASELNDT,KEY2DT,PRIORCMP,SORTFRMS.
 ;  SAMICUL update history.
 ;  SAMICAS3,4,UL update version-control lines, hdr comments.
 ;
 ; 2024-08-26 ven/toad 18-17-b6 bd5cfb4c
 ;  SAMICAS3 (F3NI%og B334055891 E3VZs78)
 ;  SAMICAS4 (F1sojs5 B106029587 E1t8Ort)
 ;  SAMICUL (F1E7l9n B145904 EOAyoU)
 ; Rick's revisions of the 14 routines + recipe file.
 ;
 ; 2024-08-26 ven/mcglk 18-17-b6 [a5dae8e9 in v18-17-b6-sinai]
 ;  SAMICAS3 (F3NI%og B334055891 E3VZs78)
 ;  SAMICAS4 (F1sojs5 B106029587 E1t8Ort)
 ;  SAMICUL (F1E7l9n B145904 EOAyoU)
 ; created side branch v18-17-b6-sinai fr/dev branch
 ; mount-sinai-changes, to use to pkg 18-17. Imported M rtns fr/commit
 ; bd5cfb4c1d58. NOTE: This history will be lost.
 ;
 ; 2024-08-28 ven/gpl 18-18-b1 a2470ae1
 ;  SAMICAS2 (FYGW B567186182 E1ubCwu)
 ; for second build, adds viewer to case review & file upload form: in
 ; WSCASE stanza 6, near top get imgid, near bottom add para for if
 ; zform["image"; in GETITEMS stanza 3 after loop do ADDITEMS^SAMIDCM2
 ; before merge; add WSNUUPLD.
 ;
 ; 2024-09-01 ven/gpl 18-18-b1 5ed25cbc
 ;  SAMICAS2 (FTRKZv B348504868 E2L%nJq)
 ; progress toward file upload feature: in WSCASE stanza 6 push all
 ; handling of zkey subscript down into third nested loop, insert new
 ; handling if zform["file"; in GETITEMS stanza 3 add handling if
 ; zkey1="file"; in GETITEMS & GETDTKEY chg set of zdate to piece
 ; apart zi; in WSNUFORM move old handling of form to OLDNUFORM & r/w/
 ; call to wsGetForm^%wf; do likewise in WSNUUPLD, moving old handling
 ; to OLDPROCESS; add DOCTYPE, TOADPARSE, FILEUP, DEDUP, FILEVIEW; in
 ; KEY2FM chg set of datepart to piece apart key; in GSAMISTA handle
 ; if form["file" or "image".
 ;  SAMICASE (F3D91S2 B2806782 E9J2Gg)
 ; add wrs WSNUUPLD^SAMICASE.
 ;
 ; 2024-09-02 ven/gpl 18-18-b1 c8d135d1
 ;  SAMICAS2 (F3UiZsU B348504868 E1NHUNy) file upload working: add
 ; MINIPARS; in FILEUP call it, comment out set of sid from SAMIARG;
 ; in FILEVIEW set HTTPRSP("mime").
 ;
 ; 2024-09-03 ven/toad&gpl 18-17-b8
 ;  SAMICAS4 stop crash when no background form.
 ;  SAMICUL update history.
 ;  SAMICAS3,CAS4,CSV,CUL,DCM1,FLD,FUL,HOM4,HUL,PAT,SITE,UR,UR2,URUL
 ; bump version.
 ;
 ; 2024-09-03 ven/gpl 18-18-b1 dc4e37b1
 ;  SAMICAS2 (F1VsBEC B348504868 E3OQd1G) some bugs removed from file
 ; upload: in MINIPARS revise debugging code; cut TOADPARSE; in
 ; FILEUP comment out call to MINIPARS.
 ;
 ; 2024-09-04 ven/toad 18-17-b8 [9a98cb08 in v18-17-b6-sinai]
 ;  SAMICAS3 (F3fPcga B334055891 E3VZs78)
 ;  SAMICAS4 (F3WKTYo B106133479 E3rMewp)
 ;  SAMICUL (F3ji8 B147284 E2pffz)
 ; fix crash if no background form, ver + chksums: SAMI-18-17-b8.
 ;
 ; 2024-09-07 ven/gpl 18-18-b1 0645d7c8
 ;  SAMICAS2 (F3a9DT5 B348790202 E1Sjqd2)
 ; fixed mrn bugs: in WSCASE stanza 4 use $$GETIDSID^SAMIUID(sid) to
 ; set useid.
 ;
 ; 2024-09-05/07,09 ven/toad 18-18-b1
 ;  SAMICAS2 09-06 (FxOjdy B381505360 EjWhNz)
 ; update ver-ctrl lines, version, chksums, hdr comments, subrtn hdr
 ; comments, occasional light refactoring.
 ;  SAMICAS2 09-09 (F2IcLpC B382829905 E1vtFzO)
 ; convert from ssn to study id: fold in George's 09-07 mod, b1 bump.
 ;  SAMICASE 09-07 (F3wFq3n B3026427 E1aDWct)
 ; update ver-ctrl lines, version, chksums, hdr comments, service
 ; comments.
 ;  SAMICASE 09-09 (F2WE3Lb B3026427 E1aDWct)
 ; b1 bump.
 ;  SAMICUL 09-05 (F3KdVOH B165224 E1On9iI)
 ;  SAMICUL 09-06 (F3lmjnD B173044 E1EBFSk)
 ;  SAMICUL 09-07 (F2Dr%J B177874 Ek39j2)
 ;  SAMICUL 09-09 (F??? B180174 E???)
 ; update history with 18-17 & 18-18 work + git log + checksums; take
 ; SAMICAS2 history back to 18-0 release; take SAMICUL history back to
 ; 18-12.
 ;
 ;@to-do
 ; finish backfilling checksums + git commit IDs + chg details
 ; finish converting SAMICAS* subroutines to service architecture
 ;  convert calls to use SAMICASE
 ;  update unit tests to match
 ;
 ;@contents
 ;
 ; SAMICASE case review
 ; SAMICAS2 case review continued
 ; SAMICAS3 case review continued
 ; SAMICAS4 case review subroutine library
 ; SAMICUL case review log
 ; SAMIUTS2 case review tests
 ;
 ;
 ;
EOR ; end of routine SAMICUL
