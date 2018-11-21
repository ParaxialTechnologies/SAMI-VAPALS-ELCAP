%tsfwra ;ven/toad-type string: findReplaceAll^%ts ;2018-03-18T16:48Z
 ;;1.8;Mash;
 ;
 ; %tsfwra implements MASH String Library ppi findReplaceAll^%ts,
 ; which is a simplified substring find & replace call; it is part of
 ; the String Find Library. It is a wrapper around setfind^%ts.
 ; See %tsutfwra for unit tests for findReplaceAll^%ts.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Find Library.
 ; See %tsudf for a detailed map of the String Find library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsfwra contains no public entry points.
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
 ;@last-updated: 2018-03-18T16:48Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; write detailed description of findReplaceAll^%ts
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
 ;@ppi-code findReplaceAll^%ts
findReplaceAll ; simple substring find & replace all
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl&toad;private;procedure;clean;silent;sac;NO tests
 ;@signature
 ; do findReplaceAll^%ts(.string,find,replace)
 ;@branches-from
 ; findReplaceAll^%ts
 ;@ppi-called-by
 ; $$replaceSrc^%wf [deprecated]
 ; wsCASE^SAMICASE
 ; wsNuForm^SAMICASE
 ; fixHref^SAMIFRM
 ; fixSrc^SAMIFRM
 ; SAMISUBS^SAMIFRM
 ; fixHref^SAMIFRM2
 ; fixSrc^SAMIFRM2
 ; getHome^SAMIHOME
 ;@called-by: none
 ;@calls
 ; setfind^%ts
 ;@throughput
 ;.string = string to scan & change
 ;@input
 ; find = substring to find in string
 ; replace = substring to replace it with
 ;@examples
 ;
 ;  new string set string="totototo"
 ;  do findReplaceAll^%ts(.string,"Kansas","Dorothy")
 ; produces
 ;  string="totototo"
 ;
 ;  new string set string="totototo"
 ;  do findReplaceAll^%ts(.string,"toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;
 ;  do findReplaceAll^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string="DorothyDorothy"
 ;
 ;  new string
 ;  do findReplaceAll^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string=""
 ;
 ;  new string set string=""
 ;  do findReplaceAll^%ts(.string,"Toto","Dorothy")
 ; produces
 ;  string=""
 ;
 ;  new string set string="totototo"
 ;  do findReplaceAll^%ts(.string,"","Dorothy")
 ; produces
 ;  string="totototo"
 ;
 ;  new string set string=""
 ;  do findReplaceAll^%ts(.string,"","Dorothy")
 ; produces
 ;  string=""
 ;
 ;  new string set string="totototo"
 ;  do findReplaceAll^%ts(.string,"toto")
 ; produces
 ;  string=""
 ;
 ;  new string set string="totototo"
 ;  do findReplaceAll^%ts(.string)
 ; produces
 ;  string="totototo"
 ;
 ;  new string
 ;  do findReplaceAll^%ts(.string)
 ; produces
 ;  string=""
 ;
 ;
 ;@tests: in %tsutfwra
 ; findrepa01: no next match
 ; findrepa02: find first & next
 ; findrepa03: find case-insensitive
 ; findrepa04: undefined string
 ; findrepa05: empty string
 ; findrepa06: empty find
 ; findrepa07: empty find & string
 ; findrepa08: empty replace
 ; findrepa09: empty find & replace
 ; findrepa10: empty string, find, & replace
 ;
 ; find a substring w/in a string & replace every instance of it
 ; w/another, case-insensitive
 ;
 ; If string contains find, ignoring the case of any letters included,
 ; every instance of it w/in string will be replaced by replace. If
 ; the new substring is the empty string (that is, if find was simply
 ; cut), every instance of find w/in string will be removed. If
 ; string or find are empty, findReplaceAll^%ts will not change string,
 ; other than to ensure it is defined.
 ;
 ;@stanza 2 call setfind^%ts
 ;
 new result set result=$get(string)
 do setfind^%ts(.result,$get(find),$get(replace),"ai")
 set string=result
 ;
 ;@stanza 5 termination
 ;
 quit  ; end of findReplaceAll^%ts
 ;
 ;
 ;
eor ; end of routine %tsfwra
