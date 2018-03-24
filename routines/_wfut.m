%wfut ;ven/mcglk&toad-web form: unit tests ;2018-03-24T22:03Z
 ;;1.8;Mash;
 ;
 ; %wfut implements unit tests for the Mash Web Form Library.
 ; See %wfud for documentation introducing the Web Form library.
 ; See %wful for the module's primary-development log.
 ; See %wf for the module's ppis & apis.
 ; It contains two direct-mode interfaces for running unit tests
 ; & reporting code coverage.
 ; %wfut contains no public entry points.
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
 ;@copyright: 2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-24T22:03Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Web Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; create unit tests for entire %ts type-string library
 ;
 ;@contents
 ; ^%wfut: dmi to run Mash Web Form Library unit-test suite
 ; cover^%wfut: dmi to run tests & calculate code coverage
 ; cover01: no-entry-from-top code-coverage tests
 ; XROU: listing of unit-test routines for the Web Form Library
 ;
 ;
 ;@section 1 dmi to run Mash Web Form Library unit-test suite
 ;
 ;
 ;
 do EN^%ut($text(+0),2) ; invoke M-Unit
 ;
 quit  ; end of call from top
 ;
 ;
 ;
 ;@section 2 dmi to run tests & calculate code coverage
 ;
 ;
 ;
cover ; run tests & calculate code coverage
 ;
 ;ven/toad;dmi;procedure;clean;report;sac
 ;
 new namespace
 set namespace="%wf*" ; set namespace for routines being tested
 ;
 ; add routines here in preferred order; this enables us to easily
 ; rearrange these in whatever order we like
 ;----------------------------------------------------------------------------
 new %wfuincl
 set %wfuincl(1)="^%wfut"
 ;----------------------------------------------------------------------------
 ; note that routine references may be specified as:
 ;   * routine        : calls EN^%ut with name as argument
 ;   * ^routine       : calls top of routine
 ;   * label^routine  : calls label in routine
 ; we generally prefer middle form
 ;
 ; to exclude specific routines, do that here:
 ;----------------------------------------------------------------------------
 new %wfuexcl
 set %wfuexcl(1)="cover^%wfut"
 ; set %wfuexcl(#)="EXCLUDEME^TESTROUTINE"
 ;----------------------------------------------------------------------------
 ;
 ; add %wfuexcl values to ^TMP, which tracks this coverage test
 merge ^TMP("%wfu",$job,"XCLUDE")=%wfuexcl
 ;
 ; cover %wf* namespace; '3' specifies verbosity: this will show values
 ; showing total coverage, plus values for each routine in namespace,
 ; plus totals for everything analyzed, along with coverage values
 ; for each tag within routines, as well as lines under each tag that
 ; were *not* covered in analysis. This may be quite a bit of info,
 ; & we may have to modify namespace and/or verbosity to pare this down
 ; until we have a lot more unit tests written.
 ;
 do COVERAGE^%ut(namespace,.%wfuincl,.%wfuexcl,2)
 ;
 quit  ; end of cover
 ;
 ;
 ;
 ;@section 3 no-entry-from-top code-coverage tests
 ;
 ;
 ;
cover01 ; @TEST no entry from top
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 do ^%wf ; all of these are for 100% code coverage
 do ^%wffiler
 do ^%wffmap
 do ^%wfhfind
 do ^%wfhform
 do ^%wfhinput
 do ^%wful
 do ^%wfuthi
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover01
 ;
 ;
 ;
 ;@section 4 unit-test routines for the Web Form Library
 ;
 ;
 ;
XTROU ; routines containing unit tests for ^%ts apis
 ;;%wfuthi; html input tag processing
 ;
 ;
 ;
eor ; end of routine %wfut
