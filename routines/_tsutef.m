%tsutc ;ven/lmry&mcglk&toad-type string-case: test string-case apis ^%tsc ;2018-03-04T19:38Z
 ;;1.8;Mash;
 ;
 ; This Mumps Advanced Shell (mash) routine implements unit tests for
 ; Mash String Library string-case apis in %ts. It contains no public entry
 ; points.
 ;
 ; primary development: see routine %tsul
 ;
 ;@primary-dev: Linda M. R. Yaw (lmry)
 ;@additional-dev: Ken McGlothlen (mcglk)
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ;@primary-dev-org: Vista Expertise Network (ven)
 ;@copyright: 2016/2017/2018, ven, all rights reserved
 ;@license: Apache 2.0
 ;
 ;@last-updated: 2018-03-04T19:38Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 ;@contents
 ; group 1: Find First & Find Next
 ; group 2: absolute addressing w/in string
 ; group 3: Find Case-Insensitive
 ; group 4: Boundary Cases
 ;
 ;
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;@calls
 ; CHKEQ^%ut
 ; findex^%ts
 ; fe^%ts
 ;
 ;
 ;
 ; group 1: Find First & Find Next
 ;
 ;
find101 ; @TEST findex^%ts(.string,"Kansas"): attempt to find a substring that is not
 ; contained in the string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findex^%ts(.string,"Kansas")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of find101
 ;
 ;
find102 ; @TEST findex^%ts(.string,"toto"): search for substring that exists in
 ; string more than once
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findex^%ts(.string,"toto")
 do CHKEQ^%ut(string("extract","from")=1
 do CHKEQ^%ut(string("extract","to")=4
 ;
 ; followed by
 do findex^%ts(.string,"toto")
 do CHKEQ^%ut(string("extract","from")=5
 do CHKEQ^%ut(string("extract","to")=8
 ;
 ; followed by
 do findex^%ts(.string,"toto")
 do CHKEQ^%ut(string("extract","from")=0
 do CHKEQ^%ut(string("extract","to")=0
 ;
 quit  ; end of find102
 ;
 ;
find103 ; @TEST findex^%ts(.string,"toto"): search for substring that exists in subject
 ; string more than once but starting after start of first instance of substring
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=1
 set string("extract","to")=2
 do findex^%ts(.string,"toto")
 do CHKEQ^%ut(string("extract","from")=3
 do CHKEQ^%ut(string("extract","to")=6
 ;
 quit  ; end of find103
 ;
 ;
find104 ; @TEST findex^%ts(.string,"toto"): search for substring that exists in subject
 ; string more than once but starting after start of last instance of substring
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=6
 set string("extract","to")=7
 do findex^%ts(.string,"toto")
 do CHKEQ^%ut(string("extract","from")=0
 do CHKEQ^%ut(string("extract","to")=0
 ;
 quit  ; end of find104
 ;
 ;
 ;
 ; group 2: Find Last & Find Previous
 ;
 ;
find201 ; @TEST findex^%ts(.string,"Kansas","b"): search for substring that does not
 ; exist in string from end instead of beginning
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findex^%ts(.string,"Kansas","b")
 do CHKEQ^%ut(string("extract","from")=0
 do CHKEQ^%ut(string("extract","to")=0
 ;
 quit  ; end of find201
 ;
 ;
find202 ; @TEST findex^%ts(.string,"toto","b"): search for substring backwards
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findex^%ts(.string,"toto","b")
 do CHKEQ^%ut(string("extract","from")=5
 do CHKEQ^%ut(string("extract","to")=8
 ;
 do findex^%ts(.string,"toto","b")
 do CHKEQ^%ut(string("extract","from")=1
 do CHKEQ^%ut(string("extract","to")=4
 ;
 do findex^%ts(.string,"toto","b")
 do CHKEQ^%ut(string("extract","from")=0
 do CHKEQ^%ut(string("extract","to")=0
 ;
 quit  ; end of find202
 ;
 ;
find203 ; @TEST findex^%ts(.string,"toto","b"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=7
 set string("extract","to")=8
 do findex^%ts(.string,"toto","b")
 do CHKEQ^%ut(string("extract","from")=3
 do CHKEQ^%ut(string("extract","to")=6
 ;
 quit  ; end of find203
 ;
 ;
find204 ; @TEST setextract^%ts(.string,""): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=1
 set string("extract","to")=2
 do findex^%ts(.string,"toto","b")
 do CHKEQ^%ut(string("extract","from")=0
 do CHKEQ^%ut(string("extract","to")=0
 ;
 quit  ; end of find204
 ;
 ;
 ;
 ; group 3: Find Case-Insensitive
 ;
 ;
find301 ; @TEST setextract^%ts(.string,""): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findex^%ts(.string,"Toto")
 do CHKEQ^%ut(string("extract","from")=0
 do CHKEQ^%ut(string("extract","to")=0
 ;
 do findex^%ts(.string,"Toto","i")
 do CHKEQ^%ut(string("extract","from")=1
 do CHKEQ^%ut(string("extract","to")=4
 ;
 do findex^%ts(.string,"Toto","i")
 do CHKEQ^%ut(string("extract","from")=5
 do CHKEQ^%ut(string("extract","to")=8
 ;
 ;  
 ;
 ; group 4: Boundary Cases
 ;
 ;
eor ; end of routine %tsutef
