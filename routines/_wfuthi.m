%wfuthi ;ven/toad-web form: test %wfhinput ;2018-03-06T17:51Z
 ;;1.8;Mash;
 ;
 ; %wfuthi implements eleven unit tests for apis $$type^%wf,
 ; check^%wf, & uncheck^%wf.
 ; See %wfhinput for the code for those apis.
 ; See %wfut for the whole unit-test library.
 ; See %wfud for documentation introducing the Web Form Lbrary,
 ; including an intro to the HTML Input Library.
 ; See %wful for the module's primary-development log.
 ; See %wf for the module's ppis & apis.
 ; %wfuthi contains no public entry points.
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
 ;@copyright: 2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-06T17:51Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Web Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@contents
 ; [all unit tests]
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%wfut)
 ;  COVERAGE^%ut (called by cover^%wfut)
 ;@calls
 ; CHKEQ^%ut
 ;
 ;
 ;
 ;@section 1 unit tests for $$type^%wf
 ;
 ;
 ;
 ;@calls
 ; $$type^%wf
 ;
 ;
 ;
type01 ; @TEST $$type^%wf: html compliant
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line="<input type=""radio"">"
 new result set result="radio"
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type01
 ;
 ;
 ;
type02 ; @TEST $$type^%wf: nonstandard variant
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line="<input type=radio>"
 new result set result="radio"
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type02
 ;
 ;
 ;
type03 ; @TEST $$type^%wf: no input tag
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line="type=""radio"""
 new result set result=""
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type03
 ;
 ;
 ;
type04 ; @TEST $$type^%wf: no type attribute
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line="<input>"
 new result set result=""
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type04
 ;
 ;
 ;
type05 ; @TEST $$type^%wf: nonstandard type value
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line="<input type=""faketype"">"
 new result set result="faketype"
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type05
 ;
 ;
 ;
type06 ; @TEST $$type^%wf: nonsense around input tag
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line="nonsense<input type=""button"">nonsense"
 new result set result="button"
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type06
 ;
 ;
 ;
type07 ; @TEST $$type^%wf: case-insensitive
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line="<Input TYPE=""rAdIo"">"
 new result set result="radio"
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type07
 ;
 ;
 ;
type08 ; @TEST $$type^%wf: empty string
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line set line=""
 new result set result=""
 do CHKEQ^%ut($$type^%wf(line),result)
 ;
 quit  ; end of type08
 ;
 ;
 ;
type09 ; @TEST $$type^%wf: undefined
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new line
 new result set result=""
 do CHKEQ^%ut($$type^%wf(.line),result)
 ;
 quit  ; end of type09
 ;
 ;
 ;
 ;@section 2 unit tests for uncheck^%wf
 ;
 ;
 ;
 ;@calls
 ; uncheck^%wf
 ;
 ;
 ;
unchk01 ; @TEST uncheck^%wf: html compliant
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input type=radio name="sbhcs" value="n" checked> no"
 new after
 set after="<input type=radio name="sbhcs" value="n"> no"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of unchk01
 ;
 ;
 ;
unchk02 ; @TEST uncheck^%wf: uppercase CHECKED
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input type=radio name="sbphu" value="i" CHECKED> in"
 new after
 set after="<input type=radio name="sbphu" value="i"> in"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of unchk02
 ;
 ;
 ;
unchk03 ; @TEST uncheck^%wf: not checked
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input type=radio name="sbphu" value="c"> cm"
 new after
 set after="<input type=radio name="sbphu" value="c"> cm"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of unchk03
 ;
 ;
 ;
unchk04 ; @TEST uncheck^%wf: nonstandard variant 1
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input type="radio" name="sbmpa" value="n" checked="checked">no</input>"
 new after
 set after="<input type="radio" name="sbmpa" value="n">no</input>"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of unchk04
 ;
 ;
 ;
unchk05 ; @TEST uncheck^%wf: nonstandard variant 2
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input type="radio" name="sbmpmi" value="n" checked=checked>no</input>"
 new after
 set after="<input type="radio" name="sbmpmi" value="n">no</input>"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of unchk05
 ;
 ;
 ;
unchk06 ; @TEST uncheck^%wf: empty string
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before set before=""
 new after set after=""
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of unchk06
 ;
 ;
 ;
unchk07 ; @TEST uncheck^%wf: undefined
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 new after set after=""
 new line
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of unchk07
 ;
 ;
 ;
 ;@section 3 unit tests for check^%wf
 ;
 ;
 ;
 ;@calls
 ; check^%wf
 ;
 ;
 ;
chk01 ; @TEST uncheck^%wf: html compliant
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input type="radio" name="sbdsd" id="sbdsd-n" value="n"> No"
 new after
 set after="<input type="radio" checked name="sbdsd" id="sbdsd-n" value="n"> No"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of chk01
 ;
 ;
 ;
chk02 ; @TEST uncheck^%wf: nonstandard variant
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input type=radio name="sbphu" value="c"> cm"
 new after
 set after="<input type=radio checked name="sbphu" value="c"> cm"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of chk02
 ;
 ;
 ;
chk03 ; @TEST uncheck^%wf: case-insensitive
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 set before="<input TYPE=checkbox name="sbshsua" value="a"> cigars"
 new after
 set after="<input TYPE=checkbox checked name="sbshsua" value="a"> cigars"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of chk03
 ;
 ;
 ;
chk04 ; @TEST uncheck^%wf: no type attribute
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before set before="<html lang="en">"
 new after set after="<html lang="en">"
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of chk04
 ;
 ;
 ;
chk05 ; @TEST uncheck^%wf: empty string
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before set before=""
 new after set after=""
 new line set line=before
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of chk05
 ;
 ;
 ;
chk06 ; @TEST uncheck^%wf: undefined
 ;
 ;ven/toad;test;procedure;clean?;silent?;sac
 ;
 new before
 new after set after=""
 new line
 ;
 do uncheck^%wf(.line)
 do CHKEQ^%ut(line,after)
 ;
 quit  ; end of chk06
 ;
 ;
 ;
eor ; end of routine %wfuthi
