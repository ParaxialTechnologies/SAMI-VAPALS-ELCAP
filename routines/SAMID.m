SAMID ;ven/toad - dd: ppis & ddis ; 1/22/19 1:27pm
 ;;18.0;SAMI;
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMID contains the SAMI data-dictionary PPIs & DDIs.
 ; CURRENTLY UNTESTED & IN PROGRESS
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
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017-2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-05T23:50Z
 ;@application: Screening Applications Management - IELCAP (SAMI)
 ;@module: Data Dictionary Support - SAMID
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@module-credits
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log
 ; 2017-11-09 ven/toad v18.0T04 SAMID: create routine; includes
 ; VAL^SAMID stub.
 ;
 ; 2018-01-03 ven/toad v18.0T04 SAMID: add history, ALL, ONE, SSNIN.
 ;
 ; 2018-02-05 ven/toad v18p0t04 SAMID: update license & attribution lines.
 ;
 ;@contents
 ; all data dictionary interfaces & private programming interfaces
 ;
 ;
 ;
 ;@section 1 SAMID data dictionary interfaces
 ;
 ;
 ;
 ;@ddi SSNIN^SAMID, input xform for .09 in 311.101
SSNIN(X,SAMIUPDATE) goto SSNIN^SAMIDSSN
 ;
 ;
 ;
 ;@section 2 SAMIDO dd-output library procedures
 ;
 ;
 ;
 ;@ppi ALL^SAMID, export all sami dds
ALL(SAMILOG) goto ALL^SAMIDOUT
 ;
 ;
 ;@ppi ONE^SAMID, export sami dd
ONE(SAMIDD,SAMIPKG,SAMILOG) goto ONE^SAMIDOUT
 ;
 ;
 ;
 ;@section 3 SAMIDV validation library procedures
 ;
 ;
 ;
 ;@ppi VAL^SAMID, validate form field against dd field
 ; VAL(%prec,%plimit) goto VAL^SAMIDV ; not developed yet
 ;
 ;
 ;
EOR ; end of routine SAMID
