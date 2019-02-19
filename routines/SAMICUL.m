SAMICUL ;ven/gpl - ielcap: case review page log & license ; 2/14/19 10:12am
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMICASE contains subroutines for producing the ELCAP Case Review Page.
 ;
 ; CHANGE ven/2018-11-13
 ;   changed all SAMIHOM2 to SAMIHOM3
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-08T17:53Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
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
 ; 2018-01-14 ven/gpl v18.0t04 SAMICASE: split from routine SAMIFRM,
 ; include wsCASE, GETTMPL, GETITEMS, casetbl.
 ;
 ; 2018-02-05/08 ven/toad v18.0t04 SAMICASE: update style, license, &
 ; attribution, spell out language elements, add white space & do-dot
 ; quits, r/replaceAll^%wfhfrom w/replaceAll^%wf,
 ; r/$$getTemplate^%wfhform w/$$getTemplate^%wf.
 ;
 ; 2018-02-14 ven/toad v18.0t04 SAMICASE: r/replaceAll^%wf
 ; w/findReplaceAll^%wf, r/ln w/line, add @calls & @called-by tags, break
 ; up some long lines.
 ;
 ; 2018-02-27 ven/gpl v18.0t04 SAMICASE: new subroutines $$KEY2DSPD,
 ; $$GETDTKEY; in wsCASE get 1st & last names from graph, fix paths,
 ; key forms in graph w/date.
 ;
 ; 2018-03-01 ven/toad v18.0t04 SAMICASE: refactor & reorganize new code,
 ; add header comments, r/findReplaceAll^%wf w/findReplace^%ts.
 ;
 ; 2018-03-06 ven/gpl v18.0t04 SAMICASE: add New Form button, list rest
 ; of forms for patient, add web services wsNuForm & wsNuFormPost &
 ; method MKCEFORM, extend GETITEMS to get rest of forms.
 ;
 ; 2018-03-07/08 ven/toad v18.0t04 SAMICASE: merge George changes w/rest,
 ; add white space, spell out mumps elements, add header comments to
 ; new subroutines, r/findReplace^%wf & replaceAll^%wf w/findReplace^%ts.
 ;
 ;
EOR ; end of routine SAMICUL
