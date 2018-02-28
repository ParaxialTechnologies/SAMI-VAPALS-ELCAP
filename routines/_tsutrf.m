%tsutrf ;ven/toad-type string: test findrep^%ts ;2018-02-28T20:20Z
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
 ;@last-updated: 2018-02-28T20:20Z
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
 ; group 1: Find First & Find Next
 ;
 ;
 ;
findrep01 ; @TEST findrep^%ts: No Match
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
findrep03 ; @TEST findrep^%ts: Find From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=1
 set string("extract","to")=2
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"toDorothyto")
 do CHKEQ^%ut(string("extract","from"),3)
 do CHKEQ^%ut(string("extract","to"),9)
 ;
 quit  ; end of findrep03
 ;
 ;
 ;
findrep04 ; @TEST findrep^%ts: No Match From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=6
 set string("extract","to")=7
 do findrep^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of findrep04
 ;
 ;
 ;
eor ; end of routine %tsutrf
