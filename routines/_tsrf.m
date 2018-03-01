%tsrf ;ven/toad-type string: findrep^%ts ;2018-03-01T21:18Z
 ;;1.8;Mash;
 ;
 ; %tsrf implements MASH String Library ppi findrep^%ts, find &
 ; replace a substring; it is part of the String Replace sublibrary.
 ; See %tsutrf for unit tests for findrep^%ts.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsrf contains no public entry points.
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
 ;@copyright: 2012/2018, gpl&toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;@original-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;
 ;@last-updated: 2018-03-01T21:18Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; convert to standardized success or failure flag
 ; apply standard string-length protection consistently
 ; add ability to call by passing object
 ; add feature to load object w/parameters for shorter calls
 ; if r flag passed, don't include in call to setex^%ts
 ; write detailed description of findrep^%ts
 ; develop more examples
 ; write unit tests
 ;
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
 ;@ppi-code findrep^%ts
findrep ; find & replace a substring
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl&toad;private;procedure;clean;silent;sac;NO tests
 ;@signature
 ; do findrep^%ts(.string,find,replace,flags)
 ;@synonyms
 ; fr^%ts
 ; findReplace^%ts
 ;@branches-from
 ; findrep^%ts
 ;@ppi-called-by
 ; wsGetForm^%wf
 ; putErrMsg2^%wf
 ; insError^%wf
 ; value^%wf
 ; uncheck^%wf
 ; check^%wf
 ; $$replaceHref^%wf [deprecated subroutine]
 ;@called-by: none
 ;@calls
 ; findex^%ts
 ; setex^%ts
 ;@throughput
 ;.string = string to scan & change
 ;.string("low","string") = lowercase version of string to scan & change
 ;.string("extract") = 1 if find & replace succeeded; otherwise 0
 ;  if "a" flag, passed, =1 if succeeded at least once
 ;.string("extract","from") = pos of 1st char of substring set
 ;.string("extract","to") = pos of last char of substring set
 ;@input
 ;.string("extract","from") = pos of 1st char of substring to set
 ;.string("extract","to") = pos of last char of substring to set
 ; find = substring to find in string
 ; replace = substring to replace it with
 ; flags = characters that control how find & replace are done
 ;  a or A = find & replace all instances of find in string
 ;  b or B = set for a backward scan
 ;  i or I = case-insensitive scan
 ;  r or R = refresh lower-case versions of string & replace
 ;@examples
 ;
 ; group 1: Find-and-Replace First & Find-and-Replace Next
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"Kansas","Dorothy")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="Dorothytoto"
 ;  string("extract")=1
 ;  string("extract","from")=1
 ;  string("extract","to")=7
 ;
 ; followed by
 ;  do findrep^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=1
 ;  string("extract","from")=8
 ;  string("extract","to")=14
 ;
 ; followed by
 ;  do findrep^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=1
 ;  set string("extract","to")=2
 ;  do findrep^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="toDorothyto"
 ;  string("extract")=1
 ;  string("extract","from")=3
 ;  string("extract","to")=9
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=6
 ;  set string("extract","to")=7
 ;  do findrep^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; group 2: Find Last & Find Previous
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"Kansas","Dorothy","b")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"toto","Dorothy","b")
 ; produces
 ;  string="totoDorothy"
 ;  string("extract")=1
 ;  string("extract","from")=5
 ;  string("extract","to")=11
 ;
 ; followed by
 ;  do findrep^%ts(.string,"toto","Dorothy","b")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=1
 ;  string("extract","from")=1
 ;  string("extract","to")=7
 ;
 ; followed by
 ;  do findrep^%ts(.string,"toto","Dorothy","b")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=7
 ;  set string("extract","to")=8
 ;  do findrep^%ts(.string,"toto","Dorothy","b")
 ; produces
 ;  string="toDorothyto"
 ;  string("extract")=1
 ;  string("extract","from")=3
 ;  string("extract","to")=9
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=1
 ;  set string("extract","to")=2
 ;  do findrep^%ts(.string,"toto","Dorothy","b")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; group 3: Find Case-Insensitive
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; followed by
 ;  do findrep^%ts(.string,"Toto","Dorothy","i")
 ; produces
 ;  string="Dorothytoto"
 ;  string("extract")=1
 ;  string("extract","from")=1
 ;  string("extract","to")=7
 ;
 ; followed by
 ;  do findrep^%ts(.string,"Toto","Dorothy","i")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=1
 ;  string("extract","from")=8
 ;  string("extract","to")=14
 ;
 ; group 4: Boundary Cases
 ;
 ;  new string
 ;  do findrep^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string=""
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string=""
 ;  do findrep^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string=""
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"","Dorothy")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string=""
 ;  do findrep^%ts(.string,"","Dorothy")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"toto")
 ; produces
 ;  string="toto"
 ;  string("extract")=1
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"toto","","b")
 ; produces
 ;  string="toto"
 ;  string("extract")=1
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string)
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string
 ;  do findrep^%ts(.string)
 ; produces
 ;  string=""
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"toto","Dorothy","badflag")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; group 5: Alternate Signatures
 ;
 ;  new string set string="totototo"
 ;  do fr^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="Dorothytoto"
 ;  string("extract")=1
 ;  string("extract","from")=1
 ;  string("extract","to")=7
 ;
 ; followed by
 ;  do findReplace^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=1
 ;  string("extract","from")=8
 ;  string("extract","to")=14
 ;
 ; followed by
 ;  do find^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; group 6: Find & Replace All
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"Toto","Dorothy","abir")
 ; produces
 ;  string="DorothyDorothy"
 ;  string("extract")=1
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findrep^%ts(.string,"Kansas","Dorothy","a")
 ; produces
 ;  string="totototo"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; find a substring w/in a string & replace w/another
 ; Lowercase version of string is used to scan for matches, & it too is
 ; changed to keep it in synch with string.
 ;
 ; If find & replace succeeds, from & to nodes in string array will be
 ; updated to the new substring's position. If the new substring is the
 ; empty string (that is, if find was simply cut), from & to will be
 ; set to the character before the cut, or if the b flag was passed to
 ; the character after the cut (in support of a backward scan).
 ;
 ; See find^%tsef & setextract^%tses for complete descriptions of how
 ; the parameters control the scan & replacement.
 ;
 ; Find & Replace All: findrep^%ts supports an "a" flag that will repeat
 ; the find & replace until the entire string has been scanned. It
 ; returns string("extract")=1 if at least one successful find+replace
 ; was done, otherwise 0. from & to nodes will always be returned = 0
 ; after Find & Replace All.
 ;
 ;@stanza 2 find & replace
 ;
 set flags=$get(flags)
 new all set all=flags["a"!(flags["A") ; find & replace all?
 set:all flags=$translate(flags,"aA") ; findex & setex don't use A flag
 ;
 new success set success=0 ; did we succeed at least once? not yet
 ;
 new done set done=0
 for  do  quit:done
 . do findex^%ts(.string,$get(find),$get(flags))
 . set done=$get(string("extract"))=0 ; failed to find substring?
 . quit:done  ; if not found, can't replace
 . do setex^%ts(.string,$get(replace),$get(flags)) ; replace
 . set done=$get(string("extract"))=0 ; failed to replace substring?
 . quit:done  ; if failed to replace, can't continue
 . set success=1 ; at least one successful find + replace = success
 . set done='all ; if not replacing all, done after first pass
 . quit
 ;
 set string("extract")=success ; return success or failure
 ;
 set:all flags="a"_flags ; restore A flag when done
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of findrep^%ts
 ;
 ;
 ;
eor ; end of routine %tses
