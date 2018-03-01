%tsutrf ;ven/toad-type string: test findrep^%ts ;2018-03-01T21:10Z
 ;;1.8;Mash;
 ;
 ; %tsutrf implements unit tests for ppi findrep^%ts.
 ; See %tsrf for the code for findrep^%ts.
 ; See %tsut for the whole unit-test library.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsutrf contains no public entry points.
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
 ;@copyright: 2016/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-01T21:10Z
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
 ;@section 1 unit tests for findrep^%ts
 ;
 ;
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;@calls
 ; CHKEQ^%ut
 ; findrep^%ts
 ;
 ;
 ;
 ; group 0: cover tests
 ;
 ;
 ;
cover10 ; @TEST ^%tsutrf: no entry from top
 ;
 ;ven/lmry;test;procedure;clean?;silent?;sac
 ;
 do ^%tsutrf ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover10
 ;
 ;
 ;
cover11 ; @TEST ^%tsrf: no entry from top
 ;
 ;ven/lmry;test;procedure;clean?;silent?;sac
 ;
 do ^%tsrf ; for 100% code coverage
 do CHKEQ^%ut(1,1)
 ;
 quit  ; end of cover11
 ;
 ;
 ;
 ; group 1: Find First & Find Next
 ;
 ;
 ;
findrep01 ; @TEST findrep^%ts: No Next Match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"Kansas","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep01
 ;
 ;
 ;
findrep02 ; @TEST findrep^%ts: Find First & Next
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"Dorothytoto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),8)
 do CHKEQ^%ut(string("extract","to"),14)
 ;
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep02
 ;
 ;
 ;
findrep03 ; @TEST findrep^%ts: Find Next From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=1
 set string("extract","to")=2
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"toDorothyto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),3)
 do CHKEQ^%ut(string("extract","to"),9)
 ;
 quit  ; end of findrep03
 ;
 ;
 ;
findrep04 ; @TEST findrep^%ts: No Match Next From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=6
 set string("extract","to")=7
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep04
 ;
 ;
 ;
 ; group 2: Find Last & Find Previous
 ;
 ;
 ;
findrep05 ; @TEST findrep^%ts: No Previous Match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"Kansas","Dorothy","b")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep05
 ;
 ;
 ;
findrep06 ; @TEST findrep^%ts: Find Last & Previous
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"Dorothytoto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),5)
 do CHKEQ^%ut(string("extract","to"),11)
 ;
 do findrep^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do findrep^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep06
 ;
 ;
 ;
findrep07 ; @TEST findrep^%ts: Find Previous From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=7
 set string("extract","to")=8
 do findrep^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"toDorothyto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),3)
 do CHKEQ^%ut(string("extract","to"),9)
 ;
 quit  ; end of findrep07
 ;
 ;
 ;
findrep08 ; @TEST findrep^%ts: No Match Previous From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=1
 set string("extract","to")=2
 do findrep^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep08
 ;
 ;
 ;
 ; group 3: Find Case-Insensitive
 ;
 ;
 ;
findrep09 ; @TEST findrep^%ts: Find Case-insensitive
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"Toto","Dorothy")
 do CHKEQ^%ut(string,"Dorothytoto")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 do findrep^%ts(.string,"Toto","Dorothy","i")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do findrep^%ts(.string,"toto","Dorothy","i")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),8)
 do CHKEQ^%ut(string("extract","to"),14)
 ;
 quit  ; end of findrep09
 ;
 ;
 ;
 ; group 4: Boundary Cases
 ;
 ;
 ;
findrep10 ; @TEST findrep^%ts: Undefined String
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep10
 ;
 ;
 ;
findrep11 ; @TEST findrep^%ts: Empty String
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep11
 ;
 ;
 ;
findrep12 ; @TEST findrep^%ts: Empty Find
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep12
 ;
 ;
 ;
findrep13 ; @TEST findrep^%ts: Empty Find & String
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do findrep^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep13
 ;
 ;
 ;
findrep14 ; @TEST findrep^%ts: Empty Replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"toto")
 do CHKEQ^%ut(string,"toto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep14
 ;
 ;
 ;
findrep15 ; @TEST findrep^%ts: Empty Replace Backward
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"toto","","b")
 do CHKEQ^%ut(string,"toto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep15
 ;
 ;
 ;
findrep16 ; @TEST findrep^%ts: Empty Find & Replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string)
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep16
 ;
 ;
 ;
findrep17 ; @TEST findrep^%ts: Empty String, Find, & Replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do findrep^%ts(.string)
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep17
 ;
 ;
 ;
findrep18 ; @TEST findrep^%ts: Bad Flag
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"toto","Dorothy","badflag")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep18
 ;
 ;
 ;
 ; group 5: Alternate Signatures
 ;
 ;
 ;
findrep19 ; @TEST findrep^%ts: Alternate Signatures
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do fr^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"Dorothytoto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do findReplace^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),8)
 do CHKEQ^%ut(string("extract","to"),14)
 ;
 do find^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep19
 ;
 ;
 ;
 ; group 6: Find & Replace All
 ;
 ;
 ;
findrep20 ; @TEST findrep^%ts: Alternate Signatures
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do fr^%ts(.string,"toto","Dorothy","abir")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep20
 ;
 ;
 ;
findrep21 ; @TEST findrep^%ts: No Next Match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findrep^%ts(.string,"Kansas","Dorothy","a")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep21
 ;
 ;
 ;
eor ; end of routine %tsutrf
