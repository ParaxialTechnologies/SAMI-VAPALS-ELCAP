%tsutfwr ;ven/toad-type string: test findReplace^%ts ;2018-03-18T16:30Z
 ;;1.8;Mash;
 ;
 ; %tsutfwr implements unit tests for ppi findReplace^%ts.
 ; See %tsfwr for the code for findReplace^%ts.
 ; See %tsut for the whole unit-test library.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Find library.
 ; See %tsudf for a detailed map of the String Find library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsutfwr contains no public entry points.
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
 ;@additional-dev: Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2016/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-18T16:30Z
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
 ;@section 1 unit tests for findReplace^%ts
 ;
 ;
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;@calls
 ; CHKEQ^%ut
 ; findReplace^%ts
 ;
 ;
 ;
findrep01 ; @TEST findReplace^%ts: no next match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplace^%ts(.string,"Kansas","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 ;
 quit  ; end of findrep01
 ;
 ;
 ;
findrep02 ; @TEST findReplace^%ts: find first & next
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplace^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"Dorothytoto")
 ;
 do findReplace^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 ;
 do findReplace^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 ;
 quit  ; end of findrep02
 ;
 ;
 ;
findrep03 ; @TEST findReplace^%ts: find case-insensitive
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplace^%ts(.string,"Toto","Dorothy")
 do CHKEQ^%ut(string,"Dorothytoto")
 ;
 do findReplace^%ts(.string,"Toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 ;
 quit  ; end of findrep03
 ;
 ;
 ;
findrep04 ; @TEST findReplace^%ts: undefined string
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do findReplace^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrep04
 ;
 ;
 ;
findrep05 ; @TEST findReplace^%ts: empty string
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do findReplace^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrep05
 ;
 ;
 ;
findrep06 ; @TEST findReplace^%ts: empty find
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplace^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 ;
 quit  ; end of findrep06
 ;
 ;
 ;
findrep07 ; @TEST findReplace^%ts: empty find & string
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do findReplace^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrep07
 ;
 ;
 ;
findrep08 ; @TEST findReplace^%ts: empty replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplace^%ts(.string,"toto")
 do CHKEQ^%ut(string,"toto")
 ;
 do findReplace^%ts(.string,"toto")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrep08
 ;
 ;
 ;
findrep09 ; @TEST findReplace^%ts: empty find & replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplace^%ts(.string)
 do CHKEQ^%ut(string,"totototo")
 ;
 quit  ; end of findrep09
 ;
 ;
 ;
findrep10 ; @TEST findReplace^%ts: empty string, find, & replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do findReplace^%ts(.string)
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrep10
 ;
 ;
 ;
eor ; end of routine %tsutfwr
