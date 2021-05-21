SAMICUL ;ven/gpl - ielcap: case review page log ;2021-05-21T20:47Z
 ;;18.0;SAMI;**9,11**;2020-01;
 ;;1.18.0.11+i11
 ;
 ; SAMICASE contains subroutines for producing the ELCAP Case
 ; Review Page.
 ; SAMICUL contains the development log for the SAMICA* routines.
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
 ;@last-updated 2021-05-21T20:47Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11+i11
 ;@release-date 2020-01
 ;@patch-list **9,11**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@additional-dev Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@additional-dev Domenick DiNatale (ddn)
 ; domenic@intellitechinnovations.com
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
 ; 2018-01-14 ven/gpl 1.18.0-t04 SAMICASE: split from routine SAMIFRM,
 ; include wsCASE, GETTMPL, GETITEMS, casetbl.
 ;
 ; 2018-02-05/08 ven/toad 1.18.0-t04
 ;  SAMICASE: update style, license, & attribution, spell out language
 ; elements, add white space & do-dot quits, r/replaceAll^%wfhfrom w/
 ; replaceAll^%wf, r/$$getTemplate^%wfhform w/$$getTemplate^%wf.
 ;
 ; 2018-02-14 ven/toad 1.18.0-t04
 ; SAMICASE: r/replaceAll^%wf w/findReplaceAll^%wf, r/ln w/line, add
 ; @calls & @called-by tags, break up some long lines.
 ;
 ; 2018-02-27 ven/gpl 1.18.0-t04
 ;  SAMICASE: new subroutines $$KEY2DSPD, $$GETDTKEY; in wsCASE get
 ; 1st & last names from graph, fix paths, key forms in graph w/date.
 ;
 ; 2018-03-01 ven/toad 1.18.0-t04
 ;  SAMICASE: refactor & reorganize new code, add header comments, r/
 ; findReplaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-06 ven/gpl 1.18.0-t04
 ;  SAMICASE: add New Form button, list rest of forms for patient, add
 ; web services wsNuForm & wsNuFormPost & method MKCEFORM, extend
 ; GETITEMS to get rest of forms.
 ;
 ; 2018-03-07/08 ven/toad 1.18.0-t04
 ;  SAMICASE: merge George changes w/ rest, add white space, spell out
 ; M elements, add hdr comments to new subroutines, r/findReplace^%wf
 ; & replaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-11 ven/gpl 1.18.0-t04 9bd663ee
 ;  SAMICAS2: vapals forms working.
 ;
 ; 2018-03-12 ven/gpl 1.18.0-t04 8c36c6a7
 ;  SAMICAS2: new form works now & charts on home page.
 ;
 ; 2018-03-14 ven/gpl 1.18.0-t04 9653650a
 ;  SAMICAS2: revised casereview page link, fixed external url
 ; preservation.
 ;
 ; 2018-03-21 ven/gpl 1.18.0-t04 48868561
 ;  SAMICAS2: max date insertion, case review navigation changed to
 ; post, date order for CT Eval in case review.
 ;
 ; 2018-03-26 ven/gpl 1.18.0-t04 5fa4ee96
 ;  SAMICAS2: changes to support incomplete forms display &
 ; processing.
 ;
 ; 2018-03-27 ven/gpl 1.18.0-t04 cace9756
 ;  SAMICAS2: siforms are always complete.
 ;
 ; 2018-04-02 ven/gpl 1.18.0-t04 00da9146
 ;  SAMICAS2: added followup form.
 ;
 ; 2018-04-24 ven/gpl 1.18.0-t04 22e39d87
 ;  SAMICAS2: added pet & biopsy forms.
 ;
 ; 2018-05-01 ven/gpl 1.18.0-t04 f1751c43
 ;  SAMICAS2: fix problem with new forms: followup & pet.
 ;
 ; 2018-05-18 ven/lgc 1.18.0-t04 9eba8f8c
 ;  SAMICAS2: conversion to new graph and simplified forms processing.
 ;
 ; 2018-05-21 ven/lgc 1.18.0-t04 0d7ed2f7
 ;  SAMICAS2: changes for new navigation html.
 ;
 ; 2018-06-14 ven/lgc 1.18.0-t04 d71f4fe4
 ;  SAMICAS2: changes to make the background form optional.
 ;
 ; 2018-06-20 ven/lgc 1.18.0-t04 bf03b07f
 ;  SAMICAS2: corrections for new forms processing navigation.
 ;
 ; 2018-07-01 ven/lgc 1.18.0-t04 2e1541dc,8b0a4329
 ;  SAMICAS2: add intervention forms to case review page, 1st version
 ; of ct eval report.
 ;
 ; 2018-07-04 ven/lgc 1.18.0-t04 b28c1658
 ;  SAMICAS2: fix a typo.
 ;
 ; 2018-07-10 ven/lgc 1.18.0-t04 2e9662b4
 ;  SAMICAS2: repair SAMIHOM3 & redact report link.
 ;
 ; 2018-08-19 ven/lgc 1.18.0-t04 2ce0cab4
 ;  SAMICAS2: use ssn instead of last5 where available.
 ;
 ; 2018-08-20 ven/lgc 1.18.0-t04 955fd484
 ;  SAMICAS2: fix case review page cr lf issue.
 ;
 ; 2018-08-22 ven/gpl 1.18.0-t04 d67a2fe5
 ;  SAMICAS2: turn off ctreport.
 ;
 ; 2018-08-30 ven/lgc 1.18.0-t04 125f1c8b
 ;  SAMICAS2: add type index to getItems to help find last previous
 ; form of a type.
 ;
 ; 2018-09-04 ven/lgc 1.18.0-t04 3e6e326f
 ;  SAMICAS2: hide report link.
 ;
 ; 2018-10-14 ven/lgc 1.18.0-t04 f6e1229f
 ;  SAMICAS2: turn on copy forward for cteval new forms.
 ;
 ; 2018-10-26 ven/lgc 1.18.0-t04 f19bf1ae
 ;  SAMICAS2: ability to add multiple forms on same day.
 ;
 ; 2018-11-07 ven/gpl 1.18.0-t04 c76b2eac
 ;  SAMICAS2: defend against unit test patient 1.
 ;
 ; 2018-11-13 ven/toad 1.18.0-t04
 ;  SAMICAS2: SAMIHOM2 > SAMIHOM3.
 ;
 ; 2018-11-14 ven/lgc 1.18.0-t04 6e9799ba
 ;  SAMICUL: fix graphstore forms.
 ;
 ; 2018-11-28 ven/lgc 1.18.0-t04 a9539464
 ;  SAMICAS2: work on sac compliance.
 ;
 ; 2018-12-11 ven/lgc 1.18.0-t04 3ceb74b5
 ;  SAMICAS2: update for sac compliance.
 ;
 ; 2018-12-19/20 ven/lgc 1.18.0-t04 7a5d3400,a14554c1
 ;  SAMICAS2: more sac compliance, r/^gpl w/^SAMIGPL.
 ;
 ; 2018-12-26 ven/lgc 1.18.0-t04 8dd6f34d,51eb1635
 ;  SAMICAS2: update for sac compliance, fix accidental reversions.
 ;
 ; 2019-01-10 ven/lgc 1.18.0-t04 2daba010
 ;  SAMICAS2: update for SAC compliance.
 ;
 ; 2019-01-22 ven/lgc 1.18.0-t04 53681219,5ddb29c5
 ;  SAMICAS2: add license info to each SAMI routine; edit for lower
 ; case initials.
 ;
 ; 2019-02-18 ven/lgc 1.18.0-t04 76874314
 ;  SAMICAS2,SAMICAS3: update recently edited routines.
 ;
 ; 2019-03-13 ven/lmry 1.18.0-t04 ef66ef16
 ;  SAMICAS2: spell out some elements missed earlier.
 ;
 ; 2019-03-14 ven/lmry 1.18.0-t04 038507e2
 ;  SAMICAS3: spell out some missed M elements, fix copy/paste errors
 ; in comments for MKFUFORM, MKBXFORM, & MKPTFORM.
 ;
 ; 2019-04-16 ven/lgc 1.18.0-t04 e54b76d1
 ;  SAMICAS2: update for SAMIFORM project.
 ;
 ; 2019-04-23 ven/gpl 1.18.0-t04 ce322911
 ;  SAMICAS2: add intake notes to case review page.
 ;
 ; 2019-06-18 ven/lgc 1.18.0-t04 91022482
 ;  SAMICAS3: switch fr/global ^SAMIGPL to/^SAMIUL.
 ;
 ; 2019-07-01 ven/gpl 1.18.0-t04 cc87cc44
 ;  SAMICAS3: prevent >1 bkgd form/patient.
 ;
 ; 2019-07-07 ven/gpl 1.18.0-t04 776f7451
 ;  SAMICAS3: resolving can't create bkgd form, branch messed up.
 ;
 ; 2019-08-01 ven/lgc 1.18.0-t04 d710f27d
 ;  SAMICAS2: pull displayed facility code from Vista parameter.
 ;
 ; 2019-09-26 ven/gpl 1.18.0-t04 92b12324 vap-420
 ;  SAMICAS3: prefill form date & date of baseline ct on new followup
 ; form.
 ;
 ; 2019-10-01 par/ddn 1.18.0-t04 4caf1a98 vap-344
 ;  SAMICAS2: use proper capitalization of the word "veteran".
 ;
 ; 2020-01-11 ven/lgc 1.18.0.1+i1 5651698a
 ;  SAMICAS2,SAMICAS3: fix duplicate form overwriting.
 ;
 ; 2020-01-17 ven/lgc 1.18.0.1+i1 8557207f
 ;  SAMICAS2: followup note.
 ;
 ; 2020-01-25 ven/lgc 1.18.0.3+i3 6a07a860,6a947567
 ;  SAMICAS3: nodule copy & fix to ru, fix subtle bug in nodule copy.
 ;
 ; 2020-04-11 ven/gpl 1.18.0.5+i5 666f5b91,2f2c29c1
 ;  SAMICAS2: multi-tenancy.
 ;
 ; 2020-05-12 ven/gpl 1.18.0.5+i5 ad11e0ea
 ;  SAMICAS2: fix SITE on case review page.
 ;
 ; 2020-11-12 ven/gpl 1.18.0.9+i9 cec1ccd6
 ;  SAMICAS2,SAMICAS3: ceform date refill upgrade.
 ;
 ; 2020-11-13 ven/gpl 1.18.0.9+i9 dce3c568
 ;  SAMICAS3: prefill ceform prior scans text field.
 ;
 ; 2021-02-18 ven/gpl 1.18.0.9+i9 af2a0b8a
 ;  SAMICAS3: copy last previous CT nodules instead of last nodules in
 ; any form.
 ;
 ; 2021-02-21 ven/gpl 1.18.0.9+i9 3fd704fb
 ;  SAMICAS3: fix bug in prefill logic.
 ;
 ; 2021-03-02 ven/gpl 1.18.0.9+i9 479dc041
 ;  SAMICAS2: return error msg if no CT Eval form exists when
 ; generating a FU note.
 ;
 ; 2021-03-10 ven/toad 1.18.0.9+i9 a46a2cc1
 ;  SAMICUL: update log, convert to new vistaver schema.
 ;  SAMICAS2,SAMICAS3: bump date & patch list, update contents, lt
 ; refactor.
 ;
 ; 2021-03-17 ven/toad 1.18.0.9+i9 62da30b
 ;  SAMICAS2: fix xindex errors: in WSCASE add missing space between
 ; do & comment to prevent syntax error reported as block mismatch.
 ;  SAMICAS3: remove extra spaces at ends of 3 lines.
 ;
 ; 2021-04-16 ven/gpl 1.18.0.11+i11 ac82eec
 ;  SAMICAS3: include baseline scan in prior scans field on prefill.
 ;
 ; 2021-05-14/19 ven/gpl 1.18.0.11+i11 0cbee7b,a21b056,139c6a5,0a0cccc
 ;  SAMICAS3: improved CT eval prefill of past scan dates, urgent
 ; fixes to CT Report & intervention & pet form prefill.
 ;
 ; 2021-05-20/21 ven/mcglk&toad 1.18.0.11+i11
 ;  SAMICAS3: bump version & dates.
 ;
 ;
 ;
EOR ; end of routine SAMICUL
