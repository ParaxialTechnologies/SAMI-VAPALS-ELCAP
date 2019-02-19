%tsfwr ;ven/toad-type string: findReplace^%ts ; 2/14/19 10:56am
 ;;1.8;Mash;
 ;
 ; %tsfwr implements MASH String Library ppi findReplace^%ts, which
 ; is a simplified substring find & replace call; it is part of the
 ; String Find Library. It is a wrapper around setfind^%ts.
 ; See %tsutfwr for unit tests for findReplace^%ts.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Find Library.
 ; See %tsudf for a detailed map of the String Find library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsfwr contains no public entry points.
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
 ;@last-updated: 2018-12-12T20:20Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; write detailed description of findReplace^%ts
 ; convert to standardized success or failure flag
 ; apply standard string-length protection consistently
 ; develop more examples
 ; write unit tests
 ;
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
 ;@ppi-code findReplace^%ts
findReplace ; simple substring find & replace
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl&toad;private;procedure;clean;silent;mdc;NO tests
 ;@signature
 ; do findReplace^%ts(.string,find,replace,flags)
 ;@branches-from
 ; findReplace^%ts
 ;@ppi-called-by
 ; *%tsutfwr [tests]
 ; form2fields^%wfhfields [dead block]
 ; insError^%wfhform
 ; putErrMsg2^%wfhform
 ; $$replaceHref^%wfhform [deprecated]
 ; value^%wfhform
 ; wsGetForm^%wfhform
 ; check^%wfhinput
 ; uncheck^%wfhinput
 ; WSCASE^SAMICASE
 ; WSNOFORM^SAMICASE
 ; SAMISUB2^SAMIFRM2
 ; WSREPORT^SAMIUR1
 ;@called-by: none
 ;@calls
 ; setfind^%ts
 ;@throughput
 ;.string = string to scan & change
 ;@input
 ; find = substring to find in string
 ; replace = substring to replace it with
 ; flags = [deprecated] ignored, will be removed in future version
 ;@examples
 ;
 ;  new string set string="totototo"
 ;  do findReplace^%ts(.string,"Kansas","Dorothy")
 ; produces
 ;  string="totototo"
 ;
 ;  new string set string="totototo"
 ;  do findReplace^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="Dorothytoto"
 ;
 ; followed by
 ;  do findReplace^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;
 ;  do findReplace^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string="Dorothytoto"
 ;
 ; followed by
 ;  do findReplace^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;
 ;  new string
 ;  do findReplace^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string=""
 ;
 ;  new string set string=""
 ;  do findReplace^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string=""
 ;
 ;  new string set string="totototo"
 ;  do findReplace^%ts(.string,"","Dorothy")
 ; produces
 ;  string="totototo"
 ;
 ;  new string set string=""
 ;  do findReplace^%ts(.string,"","Dorothy")
 ; produces
 ;  string=""
 ;
 ;  new string set string="totototo"
 ;  do findReplace^%ts(.string,"toto")
 ; produces
 ;  string="toto"
 ;
 ;  new string set string="totototo"
 ;  do findReplace^%ts(.string)
 ; produces
 ;  string="totototo"
 ;
 ;  new string
 ;  do findReplace^%ts(.string)
 ; produces
 ;  string=""
 ;
 ;@tests: in %tsutfwr
 ; findrep01: no next match
 ; findrep02: find first & next
 ; findrep03: find case-insensitive
 ; findrep04: undefined string
 ; findrep05: empty string
 ; findrep06: empty find
 ; findrep07: empty find & string
 ; findrep08: empty replace
 ; findrep09: empty find & replace
 ; findrep10: empty string, find, & replace
 ;
 ; find a substring w/in a string & replace w/another, case-insensitive
 ;
 ; If string contains find, ignoring the case of any letters included,
 ; the first instance of it w/in string will be replaced by replace. If
 ; the new substring is the empty string (that is, if find was simply
 ; cut), the first instance of find w/in string will be removed. If
 ; string or find are empty, findReplace^%ts will not change string,
 ; other than to ensure it is defined.
 ;
 ;@stanza 2 call setfind^%ts
 ;
 new result set result=$get(string)
 do setfind^%ts(.result,$get(find),$get(replace),"i")
 set string=result
 ;
 ;@stanza 5 termination
 ;
 quit  ; end of findReplace^%ts
 ;
 ;
 ;
eor ; end of routine %tsfwr
