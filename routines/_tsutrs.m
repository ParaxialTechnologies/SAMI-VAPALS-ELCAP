%tsutrs ;ven/mcglk&toad-type string: test $$strip ;2018-02-22T18:53Z
 ;;1.8;Mash;
 ;
 ; %tsutrs implements seven unit tests for api $$strip^%ts.
 ; See %tsrs for the code for $$strip^%ts.
 ; See %tsut for the whole unit-test library.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsutrs contains no public entry points.
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
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2016/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-22T18:53Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@contents
 ; [all unit tests]
 ;
 ;
 ;
 ;@section 1 unit tests for $$strip^%ts
 ;
 ;
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;@calls
 ; CHKEQ^%ut
 ; $$strip^%ts
 ;
 ;
 ;
strip01 ; @TEST $$strip^%ts(%s): strip single character
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s="In a hole in the ground, there lived a hobbit."
 new result set result="Inaholeintheground,therelivedahobbit."
 do CHKEQ^%ut($$strip^%ts(%s),result)
 ;
 quit  ; end of strip01
 ;
 ;
 ;
strip02 ; @TEST $$strip^%ts(%s,%c): strip single character
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s="In a hole in the ground, there lived a hobbit."
 new %c set %c="h"
 new result set result="In a ole in te ground, tere lived a obbit."
 do CHKEQ^%ut($$strip^%ts(%s,%c),result)
 ;
 quit  ; end of strip02
 ;
 ;
 ;
strip03 ; @TEST $$strip^%ts(%s,%c): strip multiple characters
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s="In a hole in the ground, there lived a hobbit."
 new %c set %c="hd"
 new result set result="In a ole in te groun, tere live a obbit."
 do CHKEQ^%ut($$strip^%ts(%s,%c),result)
 ;
 quit  ; end of strip03
 ;
 ;
 ;
strip04 ; @TEST $$strip^%ts(%s): strip non-existent characters
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s="Inaholeintheground,therelivedahobbit."
 new result set result=%s
 do CHKEQ^%ut($$strip^%ts(%s),result)
 ;
 quit  ; end of strip04
 ;
 ;
 ;
strip05 ; @TEST $$strip^%ts(%s,%c): strip non-existent characters
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s="In a hole in the ground, there lived a hobbit."
 new %c set %c="qx"
 new result set result=%s
 do CHKEQ^%ut($$strip^%ts(%s,%c),result)
 ;
 quit  ; end of strip05
 ;
 ;
 ;
strip06 ; @TEST $$strip^%ts(%s): strip from empty string
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$strip^%ts(%s),result)
 ;
 quit  ; end of strip06
 ;
 ;
 ;
strip07 ; @TEST $$strip^%ts(%s,%c): strip from empty string
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new %c set %c="qx"
 new result set result=%s
 do CHKEQ^%ut($$strip^%ts(%s,%c),result)
 ;
 quit  ; end of strip07
 ;
 ;
 ;
eor ; end of routine %tsutrs
