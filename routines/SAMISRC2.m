SAMISRC2 ;ven/gpl - ielcap: home page search ; 2/14/19 10:49am
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMISRCH contains subroutines for searching for patients on the
 ; ELCAP home page.
 ; It is currently untested & in progress.
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
 ;@last-updated: 2018-03-07T18:49Z
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
 ; 2018-03-06 ven/gpl v18.0t04 SAMISRCH: created new routine w/web
 ; service subroutine WSLOOKUP.
 ;
 ; 2018-03-07 ven/toad v18.0t04 SAMISRCH: update style, spell out
 ; language elements, add white space & do-dot quits.
 ;
 ;@contents
 ;
 ;
 ;
 ;@section 1 web service
 ;
 ;
 ;
WSLOOKUP(ARGS,BODY,RESULT) ; look up ELCAP patient
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@called-by
 ; web service SAMISRCH-WSLOOKUP
 ;@calls
 ; parseBody^%wf
 ; $$setroot^%wd
 ; $$GENSTDID^SAMIHOME
 ; WSCASE^SAMICASE
 ; GETHOME^SAMIHOME
 ;@input
 ;.ARGS =
 ;.BODY =
 ;@output
 ;.RESULT =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 initialize
 ;
 merge ^SAMIGPL("lookup")=ARGS
 merge ^SAMIGPL("lookup","body")=BODY
 ;
 new vars,bdy
 set bdy=$get(BODY(1))
 do parseBody^%wf("vars",.bdy)
 merge ^SAMIGPL("lookup","vars")=vars
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 new sien,trtn
 if $get(vars("field"))="sid" do  ; searching by studyid
 . set sien=$get(vars("fvalue"))
 . if sien="" quit  ; nothing entered to search by
 . if +sien=0 do  ; starts with alphabetics
 . . set sien=$extract(sien,4,$length(sien)) ; get rid of the prefix
 . . quit
 . set sien=+sien ; lose the leading zeros
 . if +sien=0 quit  ; didn't work
 . if $data(@root@(sien)) do  ; there is a record at that location
 . . set filter("studyid")=$$GENSTDID^SAMIHOM3(sien)
 . . do WSCASE^SAMICASE(.trtn,.filter)
 . . quit
 . quit
 ;
 if $data(trtn) do  quit  ; have the case review page
 . merge RESULT=trtn
 . quit
 ;
 ; on failure, resturn to the home page, maybe pass an error message
 ;
 set filter("samilookuperror")="Patient not found"
 do GETHOME^SAMIHOM3(.trtn,.filter)
 merge RESULT=trtn
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of WSLOOKUP
 ;
 ;
 ;
EOR ; end of routine SAMISRCH
