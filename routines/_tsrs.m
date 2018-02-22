%tsrs ;ven/toad-type string: code for $$strip ;2018-02-22T18:47Z
 ;;1.8;Mash;
 ;
 ; %tsrs implements MASH String Library API $$strip^%ts, strip
 ; character(s) from string; it is part of the String Replace
 ; sublibrary.
 ; See %tsutrs for unit tests for $$strip^%ts.
 ; See %tsudr for notes on the String Replace sublibrary.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsrs contains no public entry points.
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
 ;@copyright: 2012/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-22T18:47Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@original-dev: R. Wally Fort (rwf)
 ;@original-dev-org: U.S. Department of Veterans Affairs
 ; prev. Veterans Administration
 ; National Development Office in San Francisco (vaisf)
 ;
 ;@to-do
 ; apply standard string-length protection consistently
 ;
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
strip ; code for API $$strip^%ts, strip character(s) from string
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;sac;100% tests
 ;@signatures
 ; $$strip^%ts(string)
 ; $$strip^%ts(string,char)
 ;@branches-from
 ; $$strip^%ts
 ;@called-by: none
 ;@calls: none
 ;@input
 ; string = string to edit
 ; char = characters to strip, defaults to space
 ;@output = edited string
 ;@examples
 ; write "[",$$strip^%ts("  A B C  "),"]" => [ABC]
 ; write "[",$$strip^%ts("//A B C//","/"),"]" => [A B C]
 ; write "[",$$strip^%ts("//A B C//","/ "),"]" => [ABC]
 ; write "[",$$strip^%ts("//A B C//","@"),"]" => [//A B C//]
 ; write "[",$$strip^%ts("//A B C//",""),"]" => [//A B C//]
 ; write "[",$$strip^%ts("","/"),"]" => []
 ;@tests: in %tsutrs
 ; strip01: strip single character
 ; strip02: strip single character
 ; strip03: strip multiple characters
 ; strip04: strip non-existent characters
 ; strip05: strip non-existent characters
 ; strip06: strip from empty string
 ; strip07: strip from empty string
 ;
 set string=$get(string) ; avoid undefined error
 set char=$get(char," ") ; default to stripping spaces
 set string=$translate(string,char,"")
 ;
 quit string ; return stripped string; end of $$strip^%ts
 ;
 ;
eor ; end of routine %tsrs
