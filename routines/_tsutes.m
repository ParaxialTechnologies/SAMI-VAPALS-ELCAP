%tsutes ;ven/lmry-type string: test api setex^%ts ;2018-12-14T18:07Z
 ;;1.8;Mash;
 ;
 ; This Mumps Advanced Shell (mash) routine implements unit tests for
 ; Mash String Library api $$setextract^%ts. It contains no public entry
 ; points.
 ;
 ; primary development: see routine %tsul
 ;
 ;@primary-dev: Linda M. R. Yaw (lmry)
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ;@additional-dev: Ken McGlothlen (mcglk)
 ;@additional-dev: Jennifer Hackett
 ;@primary-dev-org: Vista Expertise Network (ven)
 ;@copyright: 2016/2017/2018, ven, all rights reserved
 ;@license: Apache 2.0
 ;
 ;@last-updated: 2018-12-14T18:07Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 ;@contents
 ; group 1: default addressing
 ; group 2: absolute addressing w/in string
 ; group 3: absolute addressing before string
 ; group 4: absolute addressing after string
 ; group 5: relative addressing
 ; group 6: from & to, absolute addressing w/in string [tbd]
 ; group 9: from & to, relative addressing [tbd]
 ; group A: reserved values & other boundary conditions [tbd]
 ; group E: synonyms
 ;
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;@calls
 ; CHKEQ^%ut
 ; setex^%ts
 ; se^%ts
 ; setExtract^%ts
 ; place^%tst
 ;
 ;
 ; group 1: default addressing
 ;
 ;
setex101 ; @TEST setex^%ts(.%tstring,.replace): string & substring undef
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring,replace
 do setex^%ts(.%tstring,.replace)
 do CHKEQ^%ut(%tstring,"")
 do CHKEQ^%ut(replace,"")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex101
 ;
 ;
setex102 ; @TEST setex^%ts(.%tstring,""): string undef, substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex102
 ;
 ;
setex103 ; @TEST setex^%ts(.%tstring,.replace): string="", substring undef
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring=""
 new replace
 do setex^%ts(.%tstring,.replace)
 do CHKEQ^%ut(%tstring,"")
 do CHKEQ^%ut(replace,"")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex103
 ;
 ;
setex104 ; @TEST setex^%ts(.%tstring,""): string & substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring=""
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex104
 ;
 ;
setex105 ; @TEST setex^%ts(.%tstring,"*"): string="", substring=punctuation
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring=""
 do setex^%ts(.%tstring,"*")
 do CHKEQ^%ut(%tstring,"*")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),1)
 ;
 quit  ; end of setex105
 ;
 ;
setex106 ; @TEST setex^%ts(.%tstring,"Sparrowhawk"): string="", substring=word
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring=""
 do setex^%ts(.%tstring,"Sparrowhawk")
 do CHKEQ^%ut(%tstring,"Sparrowhawk")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),11)
 ;
 quit  ; end of setex106
 ;
 ;
setex107 ; @TEST setex^%ts(.%tstring,""): string=phrase, substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Never the way he can follow grows narrower"
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"ever the way he can follow grows narrower")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex107
 ;
 ;
setex108 ; @TEST setex^%ts(.%tstring,"o"): string=phrase, substring=letter
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="In the empty sky."
 do setex^%ts(.%tstring,"o")
 do CHKEQ^%ut(%tstring,"on the empty sky.")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),1)
 ;
 quit  ; end of setex108
 ;
 ;
setex109 ; @TEST setex^%ts(.%tstring,"bright"): no from/to, r/char 1
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="O the hawk's flight"
 do setex^%ts(.%tstring,"bright")
 do CHKEQ^%ut(%tstring,"bright the hawk's flight")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),6)
 ;
 quit  ; end of setex109
 ;
 ;
 ;
 ; group 2: absolute addressing w/in string
 ;
 ;
setex201 ; @TEST setex^%ts(.%tstring,""): substring="", w/in string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="She lay thus dark and dumb"
 set %tstring("from")=1
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"he lay thus dark and dumb")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex201
 ;
 ;
setex202 ; @TEST setex^%ts(.%tstring,"A"): from=1, to undef, r/char 1
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="O Wizard of Earthsea"
 set %tstring("extract","from")=1
 do setex^%ts(.%tstring,"A")
 do CHKEQ^%ut(%tstring,"A Wizard of Earthsea")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),1)
 ;
 quit  ; end of setex202
 ;
 ;
setex203 ; @TEST setex^%ts(.%tstring,"To"): from=1, to undef, r/char 1
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="I hear, one must be silent."
 set %tstring("extract","from")=1
 do setex^%ts(.%tstring,"To")
 do CHKEQ^%ut(%tstring,"To hear, one must be silent.")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),2)
 ;
 quit  ; end of setex203
 ;
 ;
setex204 ; @TEST setex^%ts(.%tstring,""): remove char w/in string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="until at lEast he chooses nothing"
 set %tstring("extract","from")=11
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"until at last he chooses nothing")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),10)
 do CHKEQ^%ut(%tstring("extract","to"),10)
 ;
 quit  ; end of setex204
 ;
 ;
setex205 ; @TEST setex^%ts(.%tstring,"c"): r/char w/in string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="To light a Sandle is to cast a shadow."
 set %tstring("extract","from")=12
 do setex^%ts(.%tstring,"c")
 do CHKEQ^%ut(%tstring,"To light a candle is to cast a shadow.")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),12)
 do CHKEQ^%ut(%tstring("extract","to"),12)
 ;
 quit  ; end of setex205
 ;
 ;
setex206 ; @TEST setex^%ts(.%tstring,"y and wholly"): r/char w/phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="does onlY what he must do"
 set %tstring("extract","from")=9
 do setex^%ts(.%tstring,"y and wholly")
 do CHKEQ^%ut(%tstring,"does only and wholly what he must do")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),9)
 do CHKEQ^%ut(%tstring("extract","to"),20)
 ;
 quit  ; end of setex206
 ;
 ;
setex207 ; @TEST setex^%ts(.%tstring,""): remove last char
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="For a word to be spoken there must be silenceS"
 set %tstring("extract","from")=46
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"For a word to be spoken there must be silence")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),45)
 do CHKEQ^%ut(%tstring("extract","to"),45)
 ;
 quit  ; end of setex207
 ;
 ;
setex208 ; @TEST setex^%ts(.%tstring,"s"): r/last char
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="there must be darkness to see the starT"
 set %tstring("extract","from")=39
 do setex^%ts(.%tstring,"s")
 do CHKEQ^%ut(%tstring,"there must be darkness to see the stars")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),39)
 do CHKEQ^%ut(%tstring("extract","to"),39)
 ;
 quit  ; end of setex208
 ;
 ;
setex209 ; @TEST setex^%ts(.%tstring,"o evil"): r/last char w/phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="only men do"
 set %tstring("extract","from")=11
 do setex^%ts(.%tstring,"o evil")
 do CHKEQ^%ut(%tstring,"only men do evil")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),11)
 do CHKEQ^%ut(%tstring("extract","to"),16)
 ;
 quit  ; end of setex209
 ;
 ;
 ;
 ; group 3: absolute addressing before string
 ;
 ;
setex301 ; @TEST setex^%ts(.%tstring,""): from=0, substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="She wept in pain, because she was free"
 set %tstring("extract","from")=0
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"She wept in pain, because she was free")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex301
 ;
 ;
setex302 ; @TEST setex^%ts(.%tstring,"w"): from=0, substring=char
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="eight of liberty"
 set %tstring("extract","from")=0
 do setex^%ts(.%tstring,"w")
 do CHKEQ^%ut(%tstring,"weight of liberty")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),1)
 ;
 quit  ; end of setex302
 ;
 ;
setex303 ; @TEST setex^%ts(.%tstring,"A"): from=-1, substring=char
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Wizard of Earthsea"
 set %tstring("extract","from")=-1
 do setex^%ts(.%tstring,"A")
 do CHKEQ^%ut(%tstring,"A Wizard of Earthsea")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),1)
 ;
 quit  ; end of setex303
 ;
 ;
setex304 ; @TEST setex^%ts(.%tstring,"The"): from=-3, substring=word
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Tombs of Atuan"
 set %tstring("extract","from")=-3
 do setex^%ts(.%tstring,"The")
 do CHKEQ^%ut(%tstring,"The Tombs of Atuan")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),3)
 ;
 quit  ; end of setex304
 ;
 ;
setex305 ; @TEST setex^%ts(.%tstring,"The"): from=-5, substring=word
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Farthest Shore"
 set %tstring("extract","from")=-5
 do setex^%ts(.%tstring,"The")
 do CHKEQ^%ut(%tstring,"The   Farthest Shore")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),3)
 ;
 quit  ; end of setex305
 ;
 ;
setex306 ; @TEST setex^%ts(.%tstring,""): from=-4, substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Tehanu"
 set %tstring("extract","from")=-4
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"    Tehanu")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex306
 ;
 ;
setex307 ; @TEST setex^%ts(.%tstring,"The O"): from=-1, substring overlaps
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Another Wind"
 set %tstring("extract","from")=-1
 do setex^%ts(.%tstring,"The O")
 do CHKEQ^%ut(%tstring,"The Other Wind")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),5)
 ;
 quit  ; end of setex307
 ;
 ;
 ;
 ; group 4: absolute addressing after string
 ;
 ;
setex401 ; @TEST setex^%ts(.%tstring,""): from=just after, substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="muddle, mystery, mumbling"
 set %tstring("extract","from")=26
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"muddle, mystery, mumbling")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),25)
 do CHKEQ^%ut(%tstring("extract","to"),25)
 ;
 quit  ; end of setex401
 ;
 ;
setex402 ; @TEST setex^%ts(.%tstring,""): from=further after, substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="There's no way to use power for good."
 set %tstring("extract","from")=39
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"There's no way to use power for good. ")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),38)
 do CHKEQ^%ut(%tstring("extract","to"),38)
 ;
 quit  ; end of setex402
 ;
 ;
setex403 ; @TEST setex^%ts(.%tstring,""): from=far after, substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="All times are changing times"
 set %tstring("extract","from")=32
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"All times are changing times   ")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),31)
 do CHKEQ^%ut(%tstring("extract","to"),31)
 ;
 quit  ; end of setex403
 ;
 ;
setex404 ; @TEST setex^%ts(.%tstring," from Earthsea"): from=after, substring=phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Tales"
 set %tstring("extract","from")=6
 do setex^%ts(.%tstring," from Earthsea")
 do CHKEQ^%ut(%tstring,"Tales from Earthsea")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),6)
 do CHKEQ^%ut(%tstring("extract","to"),19)
 ;
 quit  ; end of setex404
 ;
 ;
setex405 ; @TEST setex^%ts(.%tstring,"is to unmake power"): from=after, substring=phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="to make love"
 set %tstring("extract","from")=14
 do setex^%ts(.%tstring,"is to unmake power")
 do CHKEQ^%ut(%tstring,"to make love is to unmake power")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),14)
 do CHKEQ^%ut(%tstring("extract","to"),31)
 ;
 quit  ; end of setex405
 ;
 ;
setex406 ; @TEST setex^%ts(.%tstring,"cy"): from=overlaps end, substring=replacement
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="The solution lies in secret"
 set %tstring("extract","from")=27
 do setex^%ts(.%tstring,"cy")
 do CHKEQ^%ut(%tstring,"The solution lies in secrecy")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),27)
 do CHKEQ^%ut(%tstring("extract","to"),28)
 ;
 quit  ; end of setex406
 ;
 ;
 ;
 ; group 5: relative addressing
 ;
 ;
setex501 ; @TEST setex^%ts(.%tstring,""): from="b", substring="", no-op
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="The road goes upward towards the light"
 set %tstring("extract","from")="b"
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"The road goes upward towards the light")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex501
 ;
 ;
setex502 ; @TEST setex^%ts(.%tstring,"A"): from="b", prepend char
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring=" dark hand had let go its lifelong hold"
 set %tstring("extract","from")="b"
 do setex^%ts(.%tstring,"A")
 do CHKEQ^%ut(%tstring,"A dark hand had let go its lifelong hold")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),1)
 ;
 quit  ; end of setex502
 ;
 ;
setex503 ; @TEST setex^%ts(.%tstring,"It is not "): from="b", prepend phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="a gift given, but a choice made"
 set %tstring("extract","from")="b"
 do setex^%ts(.%tstring,"It is not ")
 do CHKEQ^%ut(%tstring,"It is not a gift given, but a choice made")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),10)
 ;
 quit  ; end of setex503
 ;
 ;
setex504 ; @TEST setex^%ts(.%tstring,"Injustice makes the rules, and "): from="B"
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="courage breaks them."
 set %tstring("extract","from")="B"
 do setex^%ts(.%tstring,"Injustice makes the rules, and ")
 do CHKEQ^%ut(%tstring,"Injustice makes the rules, and courage breaks them.")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),31)
 ;
 quit  ; end of setex504
 ;
 ;
setex505 ; @TEST setex^%ts(.%tstring,""): from="a", substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="when you eat illusions you end up hungrier"
 set %tstring("extract","from")="a"
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"when you eat illusions you end up hungrier")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),42)
 do CHKEQ^%ut(%tstring("extract","to"),42)
 ;
 quit  ; end of setex505
 ;
 ;
setex506 ; @TEST setex^%ts(.%tstring,"."): from="a", append period
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="Manipulated, one manipulates others"
 set %tstring("extract","from")="a"
 do setex^%ts(.%tstring,".")
 do CHKEQ^%ut(%tstring,"Manipulated, one manipulates others.")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),36)
 do CHKEQ^%ut(%tstring("extract","to"),36)
 ;
 quit  ; end of setex506
 ;
 ;
setex507 ; @TEST setex^%ts(.%tstring," selectively"): from="a", append word
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="Statesmen remember things"
 set %tstring("extract","from")="a"
 do setex^%ts(.%tstring," selectively")
 do CHKEQ^%ut(%tstring,"Statesmen remember things selectively")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),26)
 do CHKEQ^%ut(%tstring("extract","to"),37)
 ;
 quit  ; end of setex507
 ;
 ;
setex508 ; @TEST setex^%ts(.%tstring," that made me live"): from="A"
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="I can breathe back the breath"
 set %tstring("extract","from")="A"
 do setex^%ts(.%tstring," that made me live")
 do CHKEQ^%ut(%tstring,"I can breathe back the breath that made me live")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),30)
 do CHKEQ^%ut(%tstring("extract","to"),47)
 ;
 quit  ; end of setex508
 ;
 ;
setex509 ; @TEST setex^%ts(.%tstring,""): from="f", substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Ignorant power is a bane!"
 set %tstring("extract","from")="f"
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"Ignorant power is a bane!")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex509
 ;
 ;
setex510 ; @TEST setex^%ts(.%tstring,"I"): from="f", r/char 1
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="U can give them back to the world"
 set %tstring("extract","from")="f"
 do setex^%ts(.%tstring,"I")
 do CHKEQ^%ut(%tstring,"I can give them back to the world")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),1)
 ;
 quit  ; end of setex510
 ;
 ;
setex511 ; @TEST setex^%ts(.%tstring,"Despair"): from="f", r/beginning
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="MANHOOD speaks evenly, in a quiet voice"
 set %tstring("extract","from")="f"
 do setex^%ts(.%tstring,"Despair")
 do CHKEQ^%ut(%tstring,"Despair speaks evenly, in a quiet voice")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),7)
 ;
 quit  ; end of setex511
 ;
 ;
setex512 ; @TEST setex^%ts(.%tstring,"Injustice"): from="F"
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="AUTHORITY makes the rules"
 set %tstring("extract","from")="F"
 do setex^%ts(.%tstring,"Injustice")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),9)
 ;
 quit  ; end of setex512
 ;
 ;
setex513 ; @TEST setex^%ts(.%tstring,""): from="l", substring=""
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="To which Silence of course made no reply"
 set %tstring("extract","from")="l"
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"To which Silence of course made no reply")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),40)
 do CHKEQ^%ut(%tstring("extract","to"),40)
 ;
 quit  ; end of setex513
 ;
 ;
setex514 ; @TEST setex^%ts(.%tstring,"n"): from="l", r/last char
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Greed puts out the suM"
 set %tstring("extract","from")="l"
 do setex^%ts(.%tstring,"n")
 do CHKEQ^%ut(%tstring,"Greed puts out the sun")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),22)
 do CHKEQ^%ut(%tstring("extract","to"),22)
 ;
 quit  ; end of setex514
 ;
 ;
setex515 ; @TEST setex^%ts(.%tstring,"strange"): from="l", r/end of string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc 
 ;
 new %tstring set %tstring="The world's vast and ANCIENT"
 set %tstring("extract","from")="l"
 do setex^%ts(.%tstring,"strange")
 do CHKEQ^%ut(%tstring,"The world's vast and strange")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),22)
 do CHKEQ^%ut(%tstring("extract","to"),28)
 ;
 quit  ; end of setex515
 ;
 ;
setex516 ; @TEST setex^%ts(.%tstring,"life"): from="L"
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="To refuse death is to refuse DOOM"
 set %tstring("extract","from")="L"
 do setex^%ts(.%tstring,"life")
 do CHKEQ^%ut(%tstring,"To refuse death is to refuse life")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),30)
 do CHKEQ^%ut(%tstring("extract","to"),33)
 ;
 quit  ; end of setex516
 ;
 ;
setex517 ; @TEST setex^%ts(.%tstring,"life"): from=bad
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="To refuse death is to refuse DOOM"
 set %tstring("extract","from")="z"
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring,"")
 do CHKEQ^%ut(%tstring("extract"),0)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex517
 ;
 ;
setex518 ; @TEST setex^%ts(.%tstring,"life"): from=bad uppercase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="To refuse death is to refuse DOOM"
 set %tstring("extract","from")="Z"
 do setex^%ts(.%tstring,"")
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex518
 ;
 ;
setex519 ; @TEST setex^%ts(.%tstring,"life"): from=good value & bad value
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="To refuse death is to refuse DOOM"
 set %tstring("extract","from")="li"
 do setex^%ts(.%tstring,"Life")
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex519
 ;
 ;
setex520 ; @TEST setex^%ts(.%tstring,"life"): from=incompatible values
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="To refuse death is to refuse DOOM"
 set %tstring("extract","from")="bf"
 do setex^%ts(.%tstring,"Life")
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex520
 ;
 ;
 ;
 ; group 6: from & to, absolute addressing w/in string
 ;
 ;
setex601 ; @TEST setex^%ts(.%tstring," boredom of "): from, r/char w/phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="the terrible pain"
 set %tstring("extract","from")=13
 do setex^%ts(.%tstring," boredom of ")
 do CHKEQ^%ut(%tstring,"the terrible boredom of pain")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),13)
 do CHKEQ^%ut(%tstring("extract","to"),24)
 ;
 quit  ; end of setex601
 ;
 ;
setex602 ; @TEST setex^%ts(.%tstring,"banality"): from & to, r/word
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="admit the ATTRACTION of evil"
 set %tstring("extract","from")=11
 set %tstring("extract","to")=20
 do setex^%ts(.%tstring,"banality")
 do CHKEQ^%ut(%tstring,"admit the banality of evil")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),11)
 do CHKEQ^%ut(%tstring("extract","to"),18)
 ;
 quit  ; end of setex602
 ;
 ;
setex603 ; @TEST setex^%ts(.%tstring,"that of life"): from="L", r/end of string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="the victory they celebrate is WAR WON WELL"
 set %tstring("extract","from")="L"
 do setex^%ts(.%tstring,"that of life")
 do CHKEQ^%ut(%tstring,"the victory they celebrate is that of life")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),31)
 do CHKEQ^%ut(%tstring("extract","to"),42)
 ;
 quit  ; end of setex603
 ;
 ;
 ; group 9: from & to, relative addressing [tbd]
 ;
 ;
setex901 ; @TEST setex^%ts(.%tstring,"to make love "): from="b", to=3
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="is to unmake power"
 set %tstring("extract","from")="b"
 set %tstring("extract","to")=3
 do setex^%ts(.%tstring,"to make love ")
 do CHKEQ^%ut(%tstring,"to make love is to unmake power")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),13)
 ;
 quit  ; end of setex901
 ;
 ;
setex902 ; @TEST setex^%ts(.%tstring,"to make love "): from & to="b"
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="is to unmake power"
 set %tstring("extract","from")="b"
 set %tstring("extract","to")="b"
 do setex^%ts(.%tstring,"to make love ")
 do CHKEQ^%ut(%tstring,"to make love is to unmake power")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),13)
 ;
 quit  ; end of setex902
 ;
 ;
setex903 ; @TEST setex^%ts(.%tstring,"to make love "): from=0, to="b"
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="is to unmake power"
 set %tstring("extract","from")=0
 set %tstring("extract","to")="b"
 do setex^%ts(.%tstring,"to make love ")
 do CHKEQ^%ut(%tstring,"")
 do CHKEQ^%ut(%tstring("extract"),0)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setex903
 ;
 ;
 ; group a: reserved values & other boundary conditions [tbd]
 ;
 ;
setexa01 ; @TEST setex^%ts(.%tstring," the sun","BAD"): flags=BAD
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="Greed puts out"
 set %tstring("extract","from")="a"
 do setex^%ts(.%tstring," the sun","BAD")
 do CHKEQ^%ut(%tstring,"Greed puts out")
 do CHKEQ^%ut(%tstring("extract"),0)
 do CHKEQ^%ut(%tstring("extract","from"),0)
 do CHKEQ^%ut(%tstring("extract","to"),0)
 ;
 quit  ; end of setexa01
 ;
 ;
 ; group c: the i flag [tbd]
 ;
 ;
setexc01 ; @TEST setex^%ts(.%tstring,insert,"i"): flags=i & prepad
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 ; show effects on string("low",string")
 ;
 new %tstring
 set %tstring("extract","from")=3
 new insert set insert="The world is in balance."
 do setex^%ts(.%tstring,insert,"i")
 do CHKEQ^%ut(%tstring,"  The world is in balance.")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),3)
 do CHKEQ^%ut(%tstring("extract","to"),26)
 do CHKEQ^%ut(%tstring("low","string"),"  the world is in balance.")
 ;
 quit  ; end of setexc01
 ;
 ;
 ; group e: synonyms
 ;
 ;
setexe01 ; @TEST se^%ts(.%tstring,"bright"): test se^%ts synonym
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="O the hawk's flight"
 do se^%ts(.%tstring,"bright")
 do CHKEQ^%ut(%tstring,"bright the hawk's flight")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),6)
 ;
 quit  ; end of setexe01
 ;
 ;
setexe02 ; @TEST setExtract^%ts(.%tstring,"bright"): test setExtract^%ts synonym
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="O the hawk's flight"
 do setExtract^%ts(.%tstring,"bright")
 do CHKEQ^%ut(%tstring,"bright the hawk's flight")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),6)
 ;
 quit  ; end of setexe02
 ;
 ;
setexe03 ; @TEST place^%ts(.%tstring,"bright"): test place^%ts synonym
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;mdc
 ;
 new %tstring set %tstring="O the hawk's flight"
 do place^%ts(.%tstring,"bright")
 do CHKEQ^%ut(%tstring,"bright the hawk's flight")
 do CHKEQ^%ut(%tstring("extract"),1)
 do CHKEQ^%ut(%tstring("extract","from"),1)
 do CHKEQ^%ut(%tstring("extract","to"),6)
 ;
 quit  ; end of setexe03
 ;
 ;
eor ; end of routine %tsutes
