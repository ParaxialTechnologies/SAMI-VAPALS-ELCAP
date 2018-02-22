%tsut ;ven/mcglk&toad-type string: unit tests ;2018-02-22T23:15Z
 ;;1.8;Mash;
 ;
 ; %tsut implements unit tests for the Mash String Library.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; It contains two direct-mode interfaces for running unit tests
 ; & reporting code coverage.
 ; %tsut contains no public entry points.
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: Ken McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev: Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2016/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-22T23:15Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; create unit tests for entire %ts type-string library
 ;
 ;@contents
 ; ^%tsut: dmi to run Mash String Datatype library unit-test suite
 ; cover^%tsut: dmi to run tests & calculate code coverage
 ;
 ;
 ;
 ;@section 1 dmi to run Mash String Datatype library unit-test suite
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
 set namespace="%ts*" ; set namespace for routines being tested
 ;
 ; add routines here in preferred order; this enables us to easily
 ; rearrange these in whatever order we like
 ;----------------------------------------------------------------------------
 new %tsuincl
 set %tsuincl(1)="^%tsut"
 ;----------------------------------------------------------------------------
 ; note that routine references may be specified as:
 ;   * routine        : calls EN^%ut with name as argument
 ;   * ^routine       : calls top of routine
 ;   * label^routine  : calls label in routine
 ; we generally prefer middle form
 ;
 ; to exclude specific routines, do that here:
 ;----------------------------------------------------------------------------
 set %tsuexcl(1)=""
 ; set %tsuexcl(#)="EXCLUDEME^TESTROUTINE"
 ;----------------------------------------------------------------------------
 ;
 ; add %tsuexcl values to ^TMP, which tracks this coverage test
 merge ^TMP("%tsu",$job,"XCLUDE")=%tsuexcl
 ;
 ; cover %ts* namespace; '3' specifies verbosity: this will show values
 ; showing total coverage, plus values for each routine in namespace,
 ; plus totals for everything analyzed, along with coverage values
 ; for each tag within routines, as well as lines under each tag that
 ; were *not* covered in analysis. This may be quite a bit of info,
 ; & we may have to modify namespace and/or verbosity to pare this down
 ; until we have a lot more unit tests written.
 ;
 do COVERAGE^%ut(namespace,.%tsuincl,.%tsuexcl,2)
 ;
 quit  ; end of cover
 ;
 ;
 ;
 ;@section 3 no-entry-from-top code-coverage tests
 ;
 ;
 ;
cover01 ; @TEST ^%ts: no entry from top
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 do ^%ts ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover01
 ;
 ;
 ;
cover02 ; @TEST ^%tsud: no entry from top
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 do ^%tsud ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover02
 ;
 ;
 ;
cover03 ; @TEST ^%tsudr: no entry from top
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 do ^%tsudr ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover03
 ;
 ;
 ;
cover04 ; @TEST ^%tsul: no entry from top
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 do ^%tsul ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover04
 ;
 ;
 ;
cover05 ; @TEST ^%tsrs: no entry from top
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 do ^%tsrs ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover05
 ;
 ;
 ;
cover06 ; @TEST ^%tsrt: no entry from top
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 do ^%tsrt ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover06
 ;
 ;
 ;
cover07 ; @TEST ^%tsutrs: no entry from top
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 do ^%tsutrs ; for 100% code coverag
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover07
 ;
 ;
 ;
cover08 ; @TEST ^%tsutrt: no entry from top
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 do ^%tsutrt ; for 100% code coverag
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover08
 ;
 ;
 ;
 ;@section 4 unit-test routines for the String library
 ;
 ;
 ;
XTROU ; routines containing unit tests for ^%ts apis
 ;;%tsutrs; $$strip^%ts
 ;;%tsutrt; $$trim^%ts
 ;;%tsutc; $$alphabet^%ts, $$ALPHABET^%ts, $$upcase^%ts
 ;
 ;
 ;
eor ; end of routine %tsut
