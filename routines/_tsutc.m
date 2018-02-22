%tsutc ;ven/lmry&mcglk&toad-type string-case: test string-case apis ^%tsc ;2018-02-22T11:33Z
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
 ;@last-updated: 2018-02-22T11:33Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.7T03
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 ; alpha01 = unit test for $$alphabet^%ts
 ; ALPHA01 = unit test for $$alphabet^%ts
 ; upcase* = unit tests for $$upcase^%ts
 ; 
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
 new result set result=""ABCDEFGHIJKLMNOPQRSTUVWXYZ""
 do CHKEQ^%ut($$ALPHABET^%ts,result)
 ;
 quit  ; end of ALPHA01
 ;
 ;
 ;
upcase01 ; @TEST $$upcase^%ts(%s): Convert string to uppercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="Terrarium"                     
 new result set result="TERRARIUM"
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase01
 ;
 ;
 ;
upcase02 ; @TEST $$upcase^%ts(%s): Convert phrase string to uppercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="Snow falls on the trees."
 new result set result="SNOW FALLS ON THE TREES."
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase02
 ;
 ;
 ;
upcase03 ; @TEST $$upcase^%ts(%s): See what happens with the empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase03
 ;
 ;
 ;
upcase04 ; @TEST $$upcase^%ts(%s): what happens with non-alpha characters
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase04
 ;
 ;
 ;
upcase05 ; @TEST $$upcase^%ts(%s): mixed alpha and non-alpha characters
 ;
 ;ven/mcglk&toad;test;procedure;clean;silent;sac
 ;
 new %s set %s="34 trucks, 53 tractors"
 new result set result="34 TRUCKS, 53 TRACTORS"
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase05
 ;
 ;
 ;
eor ; end of routine %tsutc
