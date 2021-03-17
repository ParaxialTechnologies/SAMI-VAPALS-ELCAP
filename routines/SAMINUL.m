SAMINUL ;ven/gpl - ielcap: note log ;2021-03-17T18:38Z
 ;;18.0;SAMI;**9**;
 ;;1.18.0.9-i9
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
 ;@last-updated 2021-03-17T18:38Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.9-i9
 ;@release-date 2020-01
 ;@patch-list **9**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@additional-dev Alexis R. Carlson (arc)
 ; whatisthehumanspirit@gmail.com
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
 ; 2020-01-17/20 ven/lgc 1.18.0.1-i1 8557207f,d7d24834,0301ad95.
 ;  659f2526,0ff2b83f,49615242,5bf7c398,dc5f618c
 ;  SAMINOT2: followup note, fixed typos in VC note, followup LCS note
 ; minus CT Eval pulls, LCS note with CT Eval extracts, fixed bug in
 ; LSC CT eval extract, include entire impression section of CT Eval
 ; report in LCS Note, improved import of impressions, limit to one
 ; note per followup form.
 ;
 ; 2021-03-02 ven/gpl 1.18.0.9-i9 479dc041
 ;  SAMINOT2: return error message if no ct eval form exists when
 ; generating a fu note.
 ;
 ; 2021-03-15 ven/toad 1.18.0.9-i9
 ;  SAMINUL: create routine.
 ;  SAMINOT2: bump date & patch list, add contents, lt refactor.
 ;
 ; 2021-03-17 ven/toad 1.18.0.9-i9
 ; SAMINOT2: remove blank from end of 1 line.
 ;
 ;
 ;
EOR ; end of routine SAMINUL
