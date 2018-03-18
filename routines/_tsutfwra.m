%tsutfwra ;ven/toad-type string: test findReplaceAll^%ts ;2018-03-18T16:27Z
 ;;1.8;Mash;
 ;
 ; %tsutfwra implements unit tests for ppi findReplaceAll^%ts.
 ; See %tsfwra for the code for findReplaceAll^%ts.
 ; See %tsut for the whole unit-test library.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Find library.
 ; See %tsudf for a detailed map of the String Find library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsutfwra contains no public entry points.
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
 ;@last-updated: 2018-03-18T16:27Z
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
 ;@section 1 unit tests for findReplaceAll^%ts
 ;
 ;
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;@calls
 ; CHKEQ^%ut
 ; findReplaceAll^%ts
 ;
 ;
 ;
findrepa01 ; @TEST findReplaceAll^%ts: no match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplaceAll^%ts(.string,"Kansas","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 ;
 quit  ; end of findrepa01
 ;
 ;
 ;
findrepa02 ; @TEST findReplaceAll^%ts: find & replace all
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplaceAll^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 ;
 do findReplaceAll^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 ;
 quit  ; end of findrepa02
 ;
 ;
 ;
findrepa03 ; @TEST findReplaceAll^%ts: find case-insensitive
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplaceAll^%ts(.string,"Toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 ;
 do findReplaceAll^%ts(.string,"Toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 ;
 quit  ; end of findrepa03
 ;
 ;
 ;
findrepa04 ; @TEST findReplaceAll^%ts: undefined string
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do findReplaceAll^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrepa04
 ;
 ;
 ;
findrepa05 ; @TEST findReplaceAll^%ts: empty string
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do findReplaceAll^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrepa05
 ;
 ;
 ;
findrepa06 ; @TEST findReplaceAll^%ts: empty find
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplaceAll^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 ;
 quit  ; end of findrepa06
 ;
 ;
 ;
findrepa07 ; @TEST findReplaceAll^%ts: empty find & string
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do findReplaceAll^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrepa07
 ;
 ;
 ;
findrepa08 ; @TEST findReplaceAll^%ts: empty replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplaceAll^%ts(.string,"toto")
 do CHKEQ^%ut(string,"toto")
 ;
 do findReplaceAll^%ts(.string,"toto")
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrepa08
 ;
 ;
 ;
findrepa09 ; @TEST findReplaceAll^%ts: empty find & replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do findReplaceAll^%ts(.string)
 do CHKEQ^%ut(string,"totototo")
 ;
 quit  ; end of findrepa09
 ;
 ;
 ;
findrepa10 ; @TEST findReplaceAll^%ts: empty string, find, & replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do findReplaceAll^%ts(.string)
 do CHKEQ^%ut(string,"")
 ;
 quit  ; end of findrepa10
 ;
 ;
 ;
eor ; end of routine %tsutfwra
