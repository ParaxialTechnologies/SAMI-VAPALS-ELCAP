%tsutc ;ven/lmry&mcglk&toad-type string-case: test $$case^%tsc ;2018-02-22T02:58Z
 ;;1.7;Mash;
 ;
 ; This Mumps Advanced Shell (mash) routine implements unit tests for
 ; Mash String Library string-case apis in %ts. It contains no public entry
 ; points.
 ;
 ; primary development: see routine %tslog
 ;
 ;@primary-dev: Linda M. R. Yaw (lmry)
 ;@additional-dev: Ken McGlothlen (mcglk)
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ;@primary-dev-org: Vista Expertise Network (ven)
 ;@copyright: 2016/2017/2018, ven, all rights reserved
 ;@license: Apache 2.0
 ;
 ;@last-updated: 2018-02-22T02:58Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.7T03
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 ; strip* = unit tests for $$strip^%ts
 ;@called-by:
 ;   M-Unit
 ;
 ;
 ;
alpha01 ; @TEST $$alphabet^%ts(): return lower case English alphabet
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new result set result="abcdefghijklmnopqrstuvwxyz."
 do CHKEQ^%ut($$alphabet^%ts,result)
 ;
 quit  ; end of alpha01
 ;
 ;
 ;
ALPHA01 ; @TEST $$ALPHABET^%ts(%s,%c): Return upper case English alphabet
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
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
eor ; end of routine %tsurs
