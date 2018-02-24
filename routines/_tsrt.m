%tsrt ;ven/toad-type string: $$trim^%ts ;2018-02-24T15:59Z
 ;;1.8;Mash;
 ;
 ; %tsrt implements MASH String Library ppi $$trim^%ts, trim character
 ; from end(s) of string; it is part of the String Replace sublibrary.
 ; See %tsutrt for unit tests for $$trim^%ts.
 ; See %tsudr for notes on the String Replace sublibrary.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsrt contains no public entry points.
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
 ;@last-updated: 2018-02-24T15:59Z
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
 ;@ppi-code $$trim^%ts
trim ; trim character from end(s) of string
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;sac;100% tests
 ;@signatures
 ; $$trim^%ts(string)
 ; $$trim^%ts(string,end)
 ; $$trim^%ts(string,end,char)
 ;@branches-from
 ; $$trim^%ts
 ;@called-by: none
 ;@calls
 ; $$u^%ts
 ;@input
 ; string = string to edit
 ; end = L for left, R for right, LR for both, default to both
 ; char = character to trim, default to space
 ;@output = edited string
 ;@examples
 ; write "[",$$trim^%ts("  A B C  "),"]" => [A B C]
 ; write "[",$$trim^%ts("  A B C  ","LR"),"]" => [A B C]
 ; write "[",$$trim^%ts("  A B C  ","L"),"]" => [A B C  ]
 ; write "[",$$trim^%ts("  A B C  ","R"),"]" => [  A B C]
 ; write "[",$$trim^%ts("  A B C  ",""),"]" => [  A B C  ]
 ; write "[",$$trim^%ts("      "),"]" => []
 ; write "[",$$trim^%ts("  A B C  ",,"/"),"]" => [  A B C  ]
 ; write "[",$$trim^%ts("//A B C//",,"/"),"]" => [A B C]
 ; write "[",$$trim^%ts("","LR","/"),"]" => []
 ;@tests: in %tsutrt
 ; trim01: trim spaces from both ends
 ; trim02: trim spaces from both ends
 ; trim03: trim spaces from both ends
 ; trim04: trim spaces from beginning
 ; trim05: trim spaces from beginning
 ; trim06: trim spaces from end
 ; trim07: trim spaces from end
 ; trim08: no-op
 ; trim09: something other than a space
 ; trim10: missing second argument
 ; trim11: trim to nothing
 ;
 ;@stanza 2 calculate trim characters from ends
 ;
 ; trim space (or other char) from left, right, or both ends of string
 ;
 set string=$get(string) ; ensure string defined
 set char=$get(char," ") ; default to trimming spaces
 if $translate(string,char)="" quit "" ; nothing but trim?
 set end=$$u^%ts($get(end,"LR")) ; default to both ends
 ;
 new %nr set %nr=$length(string) ; start at right end
 if end["R" do  ; if trimming right end
 . for %nr=$length(string):-1:1 quit:$extract(string,%nr)'=char
 . quit
 ;
 new %nl set %nl=1 ; start at left end
 if end["L" do  ; if trimming left end
 . for %nl=1:1:$length(string) quit:$extract(string,%nl)'=char
 . quit
 ;
 set string=$extract(string,%nl,%nr) ; trim string
 ;
 ;@stanza 3 return & termination
 ;
 quit string ; return trimmed string; end of $$trim^%ts
 ;
 ;
 ;
eor ; end of routine %tsrt
