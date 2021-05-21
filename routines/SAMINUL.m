SAMINUL ;ven/gpl - ielcap: note log ;2021-05-21T20:47Z
 ;;18.0;SAMI;**9,10,11**;2020-01;build 2
 ;;1.18.0.11+i11
 ;
 ; SAMINOTE contains subroutines for producing the ELCAP Note Pages.
 ; SAMINUL contains the development log for the SAMINOT* routines.
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
 ;@version 1.18.0.10+i11
 ;@release-date 2020-01
 ;@patch-list **9,10,11**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@additional-dev Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@additional-dev Alexis R. Carlson (arc)
 ; whatisthehumanspirit@gmail.com
 ;@additional-dev Domenic DiNatale (dom)
 ; domenic.dinatale@paraxialtech.com
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
 ; 2019-04-04/18 ven/gpl 1.18.0-t04 c0bb7dbf,f7b48936,9d1f2cdc,
 ;  ba5f366d,5b2e32dc,ce322911
 ;  SAMINOT1: flags for intake form, fix crash on intake form, initial
 ; version of new intake notes, revise text for pre-enrollment
 ; discusstion note, complete new intake notes, add intake notes to
 ; case review page.
 ;
 ; 2019-04-16/23 ven/lgc 1.18.0-t04 e54b76d1,21388d8a,f0505e51,
 ;  89bffd3b
 ;  SAMINOT1: SAMIFRM2 > SAMIFORM, remove spaces at end of lines,
 ; control characters, SAMISUB2 > LOAD.
 ;
 ; 2019-04-23 ven/toad 1.18.0-t04 423a3946
 ;  SAMINOT1: resolve gpl/lgc collision, restore SAMISUB2 > LOAD.
 ;
 ; 2019-04-30 ven/gpl 1.18.0-t04 cf73510c
 ;  SAMINOT1: additions to intake note for prior scans & format.
 ;
 ; 2019-05-07 ven/lmry 1.18.0-t04 4a8ead45
 ;  SAMINOT1: edit SAMINOT1 for XINDEX.
 ;
 ; 2019-05-07 ven/lgc 1.18.0-t04 f63ef57c
 ;  SAMINOT1: cleanup for XINDEX.
 ;
 ; 2019-06-18 ven/arc 1.18.0-t04 91022482
 ;  SAMINOT1: ^SAMIGPL > ^SAMIUL.
 ;
 ; 2019-07-01 ven/gpl 1.18.0-t04 72868e60
 ;  SAMINOT1: update shared decision making text in intake note.
 ;
 ; 2019-08-03/14 ven/gpl 1.18.0-t04 bea65f7b,578f61d4
 ;  SAMINOT1: fix bugs in Have you ever smoked processing in changelog
 ; & intake note, restored ever smoked comment field to intake note.
 ;
 ; 2019-09-06 par/dom 1.18.0-t04 2ff47189 VAP-452
 ;  SAMINOT1: patient > participant.
 ;
 ; 2019-09-26 ven/gpl 1.18.0-t04 92b12324 VAP-420
 ;  SAMINOT1: smoking history.
 ;
 ; 2019-10-01 par/dom 1.18.0-t04 37c418a1,4caf1a98 VAP-457,344
 ;  SAMINOT1: remove thorax, capitalization consistency.
 ;
 ; 2020-01-17/20 ven/lgc 1.18.0.1+i1 8557207f,d7d24834,0301ad95.
 ;  659f2526,0ff2b83f,49615242,5bf7c398,dc5f618c
 ;  SAMINOT2: followup note, fixed typos in VC note, followup LCS note
 ; minus CT Eval pulls, LCS note with CT Eval extracts, fixed bug in
 ; LSC CT eval extract, include entire impression section of CT Eval
 ; report in LCS Note, improved import of impressions, limit to one
 ; note per followup form.
 ;
 ; 2020-01-23 ven/arc 1.18.0.2+i2 9a24242a
 ;  SAMINOT1: fix word wrap on intake note & typos in ct
 ; eval report.
 ;
 ; 2020-08-12 ven/gpl 1.18.0.6+i6 781744c3
 ;  SAMINOT1: chg to support hl7 transmission of notes.
 ;
 ; 2020-09-22 ven/gpl 1.18.0.6+i6 06459eda
 ;  SAMINOT1: fix to match kids file.
 ;
 ; 2021-02-01/24 ven/gpl 1.18.0.8+i8 8e4ec441,cde71a55
 ;  SAMINOT1: fix intake note format, fix error that sent note twice
 ; to VistA.
 ;
 ; 2021-03-02 ven/gpl 1.18.0.9+i9 479dc041
 ;  SAMINOT2: return error message if no ct eval form exists when
 ; generating a fu note.
 ;
 ; 2021-03-15/16 ven/toad 1.18.0.9+i9 a46a2cc1
 ;  SAMINUL: create routine.
 ;  SAMINOT2: bump date & patch list, add contents, lt refactor.
 ;
 ; 2021-03-17 ven/toad 1.18.0.9+i9 62da30b4
 ; SAMINOT2: remove blank from end of 1 line.
 ;
 ; 2021-03-22 ven/gpl 1.18.0.10+i10 6319a1eb
 ;  SAMINOT1: fix logic bug in detecting pre-enrollment existing.
 ;
 ; 2021-03-23 ven/toad 1.18.0.10+i10 96f461d0
 ;  SAMINOT1: bump date & patch list, lt refactor.
 ;
 ; 2021-03-29 ven/gpl 1.18.0.11+i11 6cd83445 VAP-483
 ;  SAMINOT1: allow N/A for shared decision making on intake form:
 ; in INNOTE new & set shareddm & use to call SDM or report n/a, based
 ; on siidmdc.
 ;
 ; 2021-03-30/05-21 ven/mcglk&toad 1.18.0.11+i11 7b14bb2,
 ;  SAMINOT1: bump version, date, log, add quit to stop block mismatch
 ; complaint from XINDEX.
 ;
 ;
 ;
EOR ; end of routine SAMINUL
