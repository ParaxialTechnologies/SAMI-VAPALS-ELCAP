SAMICTUL ;ven/gpl - ctreport log ;2021-03-23T17:10Z
 ;;18.0;SAMI;**10**;2020-01;
 ;;1.18.0.10-i10
 ;
 ; SAMICTUL contains routine & module info & the primary development
 ; log for VAPALS-ELCAP's CT Report ctreport web service route, which
 ; is implemented by the SAMICTR* (html) and SAMICTT* (text)
 ; routines.
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
 ;@primary-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated 2021-03-23T17:10Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@version 1.18.0.10-i10
 ;@release-date 2020-01
 ;@patch-list **10**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Alexis Carlson (arc)
 ; alexis.carlson@vistaexpertise.net
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
 ;@module-log
 ;
 ; 2020-02-01/03 ven/arc 1.18.0.4-i4 d47135a5,bc32c1cb,5b2e4525,
 ;  7bcd14a2,1c96fe0e,cb0075e8,5e553dd2,9cde6840,dcea0048e,98b7b273,
 ; a4f98f19
 ;  SAMICTT0,1,2,3,4,9,A: routines (starting as copies of SAMICTR*) to
 ; implement ctreport in text format, start convert nodules to text,
 ; add'l lung findings, fix parag spacing, add impressions sect,
 ; recommendations sect, add'l sects on other abnormalities, breast
 ; abnorm sect, other abnorm sect, tweak format, make it more compact.
 ;
 ; 2021-02-18 ven/gpl 1.18.0.10-i10 38fb2d70
 ;  SAMICTT0,1,2,3,4,9,A: ct report - insert space after every period.
 ;
 ; 2021-03-04/16 ven/gpl 1.18.0.10-i10 e09d5f16,3ea26de9,91793ba3
 ;  SAMICTT1,3,4: ct report: fix normal cardiac default output, CAC
 ; logic, other enhancements.
 ;
 ; 2021-03-23 ven/gpl 1.18.0.10-i10 a68f7f31
 ;  SAMICTT3: fix CAC problem.
 ;
 ; 2021-03-21/23 ven/toad 1.18.0.10-i10
 ;  SAMICTUL: create development log routine.
 ;  SAMICTT0,1,2,3,4,9,A: bump date & version, lt refactor.
 ;
 ;
 ;
 ;@contents
 ; SAMICTT0: ctreport text main
 ; SAMICTT1: ctreport text nodules
 ; SAMICTT2: ctreport text other lung
 ; SAMICTT3: ctreport text emphysema
 ; SAMICTT4: ctreport text breast abnorm
 ; SAMICTT9: ctreport text impressions
 ; SAMICTTA: ctreport text recommendations
 ; SAMICTUL: ctreport log
 ;
 ; SAMICTR*: ctreport html format
 ; SAMIUTR*: test the SAMICTR routines
 ;
 ;
 ;
EOR ; end of routine SAMICTUL
