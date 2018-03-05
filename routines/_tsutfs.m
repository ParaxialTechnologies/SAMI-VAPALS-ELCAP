%tsutfs ;ven/toad-type string: test setfind^%ts ;2018-03-05T20:05Z
 ;;1.8;Mash;
 ;
 ; %tsutfs implements unit tests for ppi setfind^%ts.
 ; See %tsfs for the code for setfind^%ts.
 ; See %tsut for the whole unit-test library.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Find library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsutfs contains no public entry points.
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
 ;@last-updated: 2018-03-05T20:05Z
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
 ;@section 1 unit tests for setfind^%ts
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
setfind01 ; @TEST setfind^%ts: No Next Match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"Kansas","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind01
 ;
 ;
 ;
setfind02 ; @TEST setfind^%ts: Find First & Next
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"Dorothytoto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do setfind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),8)
 do CHKEQ^%ut(string("extract","to"),14)
 ;
 do setfind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind02
 ;
 ;
 ;
setfind03 ; @TEST setfind^%ts: Find Next From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=1
 set string("extract","to")=2
 do setfind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"toDorothyto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),3)
 do CHKEQ^%ut(string("extract","to"),9)
 ;
 quit  ; end of setfind03
 ;
 ;
 ;
setfind04 ; @TEST setfind^%ts: No Match Next From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=6
 set string("extract","to")=7
 do setfind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind04
 ;
 ;
 ;
 ; group 2: Find Last & Find Previous
 ;
 ;
 ;
setfind05 ; @TEST setfind^%ts: No Previous Match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"Kansas","Dorothy","b")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind05
 ;
 ;
 ;
setfind06 ; @TEST setfind^%ts: Find Last & Previous
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"totoDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),5)
 do CHKEQ^%ut(string("extract","to"),11)
 ;
 do setfind^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do setfind^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind06
 ;
 ;
 ;
setfind07 ; @TEST setfind^%ts: Find Previous From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=7
 set string("extract","to")=8
 do setfind^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"toDorothyto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),3)
 do CHKEQ^%ut(string("extract","to"),9)
 ;
 quit  ; end of setfind07
 ;
 ;
 ;
setfind08 ; @TEST setfind^%ts: No Match Previous From
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 set string("extract","from")=1
 set string("extract","to")=2
 do setfind^%ts(.string,"toto","Dorothy","b")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind08
 ;
 ;
 ;
 ; group 3: Find Case-Insensitive
 ;
 ;
 ;
setfind09 ; @TEST setfind^%ts: Find Case-insensitive
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"Toto","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 do setfind^%ts(.string,"Toto","Dorothy","i")
 do CHKEQ^%ut(string,"Dorothytoto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do setfind^%ts(.string,"toto","Dorothy","i")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),8)
 do CHKEQ^%ut(string("extract","to"),14)
 ;
 quit  ; end of setfind09
 ;
 ;
 ;
 ; group 4: Boundary Cases
 ;
 ;
 ;
setfind10 ; @TEST setfind^%ts: Undefined String
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do setfind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind10
 ;
 ;
 ;
setfind11 ; @TEST setfind^%ts: Empty String
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do setfind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind11
 ;
 ;
 ;
setfind12 ; @TEST setfind^%ts: Empty Find
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind12
 ;
 ;
 ;
setfind13 ; @TEST setfind^%ts: Empty Find & String
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do setfind^%ts(.string,"","Dorothy")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind13
 ;
 ;
 ;
setfind14 ; @TEST setfind^%ts: Empty Replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"toto")
 do CHKEQ^%ut(string,"toto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind14
 ;
 ;
 ;
setfind15 ; @TEST setfind^%ts: Empty Replace Backward
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"toto","","b")
 do CHKEQ^%ut(string,"toto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind15
 ;
 ;
 ;
setfind16 ; @TEST setfind^%ts: Empty Find & Replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string)
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind16
 ;
 ;
 ;
setfind17 ; @TEST setfind^%ts: Empty String, Find, & Replace
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string
 do setfind^%ts(.string)
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind17
 ;
 ;
 ;
setfind18 ; @TEST setfind^%ts: Bad Flag
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"toto","Dorothy","badflag")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind18
 ;
 ;
 ;
 ; group 5: Alternate Signatures
 ;
 ;
 ;
setfind19 ; @TEST setfind^%ts: Alternate Signatures
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do sf^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"Dorothytoto")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 do setFind^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),8)
 do CHKEQ^%ut(string("extract","to"),14)
 ;
 do replace^%ts(.string,"toto","Dorothy")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind19
 ;
 ;
 ;
 ; group 6: Find & Replace All
 ;
 ;
 ;
setfind20 ; @TEST setfind^%ts: All Backward Case-Insensitive
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"toto","Dorothy","abir")
 do CHKEQ^%ut(string,"DorothyDorothy")
 do CHKEQ^%ut(string("extract"),1)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind20
 ;
 ;
 ;
setfind21 ; @TEST setfind^%ts: All But No Next Match
 ;
 ;ven/toad;test;procedure;clean;silent;sac
 ;
 new string set string="totototo"
 do setfind^%ts(.string,"Kansas","Dorothy","a")
 do CHKEQ^%ut(string,"totototo")
 do CHKEQ^%ut(string("extract"),0)
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setfind21
 ;
 ;
 ;
eor ; end of routine %tsutfs
