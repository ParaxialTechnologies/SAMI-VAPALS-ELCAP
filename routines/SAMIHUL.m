SAMIHUL ;ven/gpl - ielcap: home page log ;2021-03-17T18:34Z
 ;;18.0;SAMI;**9**;
 ;;1.18.0.9-i9
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
 ;@last-updated 2021-03-17T18:34Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.9-i9
 ;@release-date 2020-01
 ;@patch-list **9**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
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
 ; 2018-12-18/20 ven/arc 1.18.0-t04 3088307f,4271b46b,dfbb0bca,
 ;  b8ff6da9,fd1bceee
 ;  SAMIHOM4: va sac compliance & variable namespacing.
 ;
 ; 2019-01-01/02-18 ven/lgc 1.18.0-t04 0880027c,18aa0fec,fcd635c1,
 ;  53681219,76874314
 ;  SAMIHOM4: updates for va sac & code coverage, add license info.
 ;
 ; 2019-04-15 ven/gpl 1.18.0-t04 b403bf01
 ;  SAMIHOM4: support for new intake notes.
 ;
 ; 2019-04-16 ven/lgc 1.18.0-t04 e54b76d1
 ;  SAMIHOM4: update for SAMIFORM project.
 ;
 ; 2019-06-18 ven/arc 1.18.0-t04 91022482
 ;  SAMIHOM4: switch fr/global ^SAMIGPL to/^SAMIUL.
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
 ; 2020-01-17/20 ven/lgc 1.18.0.1-i1 8557207f,dc5f618c
 ;  SAMIHOM4: followup note, limit to one note per followup form.
 ;
 ; 2020-02-01/02 ven/lgc 1.18.0.4-i4 3065146d,36ae0ed1
 ;  SAMIHOM4: set options for text based ctreport, switch default
 ; ctreport to text.
 ;
 ; 2020-04-02/11 ven/gpl 1.18.0.5-i5 d36b7cad,36607664,befde317,
 ;  56bfaed6,666f5b91,2f2c29c1
 ;  SAMIHOM4: multitenancy + fix bug in WSVAPALS.
 ;
 ; 2020-04-18/05-07 ven/gpl 1.18.0.5-i5 29d7dba7,d55de214,521e0bdc,
 ;  d018f52e,476b2ff4,61c7d208
 ;  SAMIHOM4: fix bug & weird error in manual registration, fix bug in
 ; logout, logout working, superuser site selection, worklist
 ; functionality.
 ;
 ; 2020-08-06 ven/gpl 1.18.0.6-i6 781744c3
 ;  SAMIHOM4: changes to support hl7 transmission of notes.
 ;
 ; 2020-09-22 ven/gpl 1.18.0.9-i9 06459eda
 ;  SAMIHOM4: correct to match kids file.
 ;
 ; 2021-03-02 ven/gpl 1.18.0.9-i9 479dc041
 ;  SAMIHOM4: return error message if no ct eval form exists when
 ; generating a fu note.
 ;
 ; 2021-03-11 ven/toad 1.18.0.9-i9 a46a2cc1
 ;  SAMIHUL: create routine.
 ;  SAMIHOM4: bump date & patch list, add contents, lt refactor.
 ;
 ; 2021-03-17 ven/toad 1.18.0.9-i9
 ; SAMIHOM4: remove blank from end of 1 line.
 ;
 ;
 ;
EOR ; end of routine SAMIHUL
