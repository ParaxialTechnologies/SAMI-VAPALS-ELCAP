SAMID ;ven/toad - dd: ppis ;2018-01-03T11:40Z
 ;;18.0;SAMI;
 ;
 ; SAMID contains the SAMI data-dictionary PPIs.
 ; CURRENTLY UNTESTED AND IN PROGRESS
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017-2018, ven, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-01-03T11:40Z
 ;@application: Screening Applications Management - IELCAP (SAMI)
 ;@module: Data Dictionary Support - SAMID
 ;@version: 18.0T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@funding-org: 2017-2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;
 ;@history
 ; 2017-11-09 ven/toad v18.0T04 SAMID: create routine; includes
 ; VAL^SAMID stub.
 ;
 ; 2018-01-02 ven/toad v18.0T04 SAMID: add history, ALL, ONE.
 ;
 ;@contents
 ; all private programming interfaces
 ;
 ;
 ;
 ;@section 1 SAMIDO dd-output library procedures
 ;
 ;
 ;
 ;@PPI ALL^SAMID, export all sami dds
ALL(SAMILOG) goto ALL^SAMIDOUT
 ;
 ;
 ;@PPI ONE^SAMID, export sami dd
ONE(SAMIDD,SAMIPKG,SAMILOG) goto ONE^SAMIDOUT
 ;
 ;
 ;
 ;@section 2 SAMIDV validation library procedures
 ;
 ;
 ;
 ;@PPI VAL^SAMID, validate form field against dd field
VAL(%prec,%plimit) goto VAL^SAMIDV
 ;
 ;
 ;
EOR ; end of routine SAMID
