%tsutes ;ven/lmry&mcglk&toad-type string-case: test string-case apis ^%tsc ;2018-03-12T04:39Z
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
 ;@last-updated: 2018-03-12T04:39Z
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
 ; group 7: synonyms
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
setex101 ; @TEST setex^%ts(.string,.replace): string & substring undefined
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string,replace
 do setex^%ts(.string,.replace)
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(replace,"")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex101
 ;
 ;
setex102 ; @TEST setex^%ts(.string,""): string undefined, substring is empty string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex102
 ;
 ;
setex103 ; @TEST setex^%ts(.string,.replace): string is empty, substring undefined
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string=""
 new replace
 do setex^%ts(.string,.replace)
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(replace,"")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex103
 ;
 ;
setex104 ; @TEST setex^%ts(.string,""): string and substring are empty string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex104
 ;
 ;
setex105 ; @TEST setex^%ts(.string,"*"): string is empty, substring is punctuation
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do setex^%ts(.string,"*")
 do CHKEQ^%ut(string,"*")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),1)
 ;
 quit  ; end of setex105
 ;
 ;
setex106 ; @TEST setex^%ts(.string,"Sparrowhawk"): string empty, substring is word
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string=""
 do setex^%ts(.string,"Sparrowhawk")
 do CHKEQ^%ut(string,"Sparrowhawk")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),11)
 ;
 quit  ; end of setex106
 ;
 ;
setex107 ; @TEST setex^%ts(.string,""): string is phrase, substring is empty
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Never the way he can follow grows narrower"
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"ever the way he can follow grows narrower")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex107
 ;
 ;
setex108 ; @TEST setex^%ts(.string,"o"): string is phrase, substring is letter
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="In the empty sky."
 do setex^%ts(.string,"o")
 do CHKEQ^%ut(string,"on the empty sky.")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),1)
 ;
 quit  ; end of setex108
 ;
 ;
setex109 ; @TEST setex^%ts(.string,"bright"): no from/to, replaces first char of string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="O the hawk's flight"
 do setex^%ts(.string,"bright")
 do CHKEQ^%ut(string,"bright the hawk's flight")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),6)
 ;
 quit  ; end of setex109
 ;
 ;
 ;
 ; group 2: absolute addressing w/in string
 ;
 ;
setex201 ; @TEST setex^%ts(.string,""): empty substring w/in string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="She lay thus dark and dumb"
 set string("from")=1
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"he lay thus dark and dumb")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex201
 ;
 ;
setex202 ; @TEST setex^%ts(.string,"A"): from set, no to, replaces first letter
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="O Wizard of Earthsea"
 set string("extract","from")=1
 do setex^%ts(.string,"A")
 do CHKEQ^%ut(string,"A Wizard of Earthsea")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),1)
 ;
 quit  ; end of setex202
 ;
 ;
setex203 ; @TEST setex^%ts(.string,"To"): from set, no to, replaces first letter
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="I hear, one must be silent."
 set string("extract","from")=1
 do setex^%ts(.string,"To")
 do CHKEQ^%ut(string,"To hear, one must be silent.")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),2)
 ;
 quit  ; end of setex203
 ;
 ;
setex204 ; @TEST setex^%ts(.string,""): remove letter w/in string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="until at lEast he chooses nothing"
 set string("extract","from")=11
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"until at last he chooses nothing")
 do CHKEQ^%ut(string("extract","from"),10)
 do CHKEQ^%ut(string("extract","to"),10)
 ;
 quit  ; end of setex204
 ;
 ;
setex205 ; @TEST setex^%ts(.string,"c"): replace letter w/in string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="To light a Sandle is to cast a shadow."
 set string("extract","from")=12
 do setex^%ts(.string,"c")
 do CHKEQ^%ut(string,"To light a candle is to cast a shadow.")
 do CHKEQ^%ut(string("extract","from"),12)
 do CHKEQ^%ut(string("extract","to"),12)
 ;
 quit  ; end of setex205
 ;
 ;
setex206 ; @TEST setex^%ts(.string,"y and wholly"): replace letter with phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="does onlY what he must do"
 set string("extract","from")=9
 do setex^%ts(.string,"y and wholly")
 do CHKEQ^%ut(string,"does only and wholly what he must do")
 do CHKEQ^%ut(string("extract","from"),9)
 do CHKEQ^%ut(string("extract","to"),20)
 ;
 quit  ; end of setex206
 ;
 ;
setex207 ; @TEST setex^%ts(.string,""): remove last letter
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="For a word to be spoken there must be silenceS"
 set string("extract","from")=46
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"For a word to be spoken there must be silence")
 do CHKEQ^%ut(string("extract","from"),45)
 do CHKEQ^%ut(string("extract","to"),45)
 ;
 quit  ; end of setex207
 ;
 ;
setex208 ; @TEST setex^%ts(.string,"s"): replace last letter
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="there must be darkness to see the starT"
 set string("extract","from")=39
 do setex^%ts(.string,"s")
 do CHKEQ^%ut(string,"there must be darkness to see the stars")
 do CHKEQ^%ut(string("extract","from"),39)
 do CHKEQ^%ut(string("extract","to"),39)
 ;
 quit  ; end of setex208
 ;
 ;
setex209 ; @TEST setex^%ts(.string,"o evil"): replace last letter with phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="only men do"
 set string("extract","from")=11
 do setex^%ts(.string,"o evil")
 do CHKEQ^%ut(string,"only men do evil")
 do CHKEQ^%ut(string("extract","from"),11)
 do CHKEQ^%ut(string("extract","to"),16)
 ;
 quit  ; end of setex209
 ;
 ;
 ;
 ; group 3: absolute addressing before string
 ;
 ;
setex301 ; @TEST setex^%ts(.string,""): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="She wept in pain, because she was free"
 set string("extract","from")=0
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"She wept in pain, because she was free")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex301
 ;
 ;
setex302 ; @TEST setex^%ts(.string,"w"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="eight of liberty"
 set string("extract","from")=0
 do setex^%ts(.string,"w")
 do CHKEQ^%ut(string,"weight of liberty")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),1)
 ;
 quit  ; end of setex302
 ;
 ;
setex303 ; @TEST setex^%ts(.string,"A"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Wizard of Earthsea"
 set string("extract","from")=-1
 do setex^%ts(.string,"A")
 do CHKEQ^%ut(string,"A Wizard of Earthsea")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),1)
 ;
 quit  ; end of setex303
 ;
 ;
setex304 ; @TEST setex^%ts(.string,"The"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Tombs of Atuan"
 set string("extract","from")=-3
 do setex^%ts(.string,"The")
 do CHKEQ^%ut(string,"The Tombs of Atuan")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),3)
 ;
 quit  ; end of setex304
 ;
 ;
setex305 ; @TEST setex^%ts(.string,"The"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Farthest Shore"
 set string("extract","from")=-5
 do setex^%ts(.string,"The")
 do CHKEQ^%ut(string,"The   Farthest Shore")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),3)
 ;
 quit  ; end of setex305
 ;
 ;
setex306 ; @TEST setex^%ts(.string,""): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Tehanu"
 set string("extract","from")=-4
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"    Tehanu")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex306
 ;
 ;
setex307 ; @TEST setex^%ts(.string,"The O"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Another Wind"
 set string("extract","from")=-1
 do setex^%ts(.string,"The O")
 do CHKEQ^%ut(string,"The Other Wind")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),5)
 ;
 quit  ; end of setex307
 ;
 ;
 ;
 ; group 4: absolute addressing after string
 ;
 ;
setex401 ; @TEST setex^%ts(.string,""): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="muddle, mystery, mumbling"
 set string("extract","from")=26
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"muddle, mystery, mumbling")
 do CHKEQ^%ut(string("extract","from"),25)
 do CHKEQ^%ut(string("extract","to"),25)
 ;
 quit  ; end of setex401
 ;
 ;
setex402 ; @TEST setex^%ts(.string,""): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="There's no way to use power for good."
 set string("extract","from")=39
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"There's no way to use power for good. ")
 do CHKEQ^%ut(string("extract","from"),38)
 do CHKEQ^%ut(string("extract","to"),38)
 ;
 quit  ; end of setex402
 ;
 ;
setex403 ; @TEST setex^%ts(.string,""): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="All times are changing times"
 set string("extract","from")=32
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string("extract","from"),31)
 do CHKEQ^%ut(string("extract","to"),31)
 ;
 quit  ; end of setex403
 ;
 ;
setex404 ; @TEST setex^%ts(.string," from Earthsea"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Tales"
 set string("extract","from")=6
 do setex^%ts(.string," from Earthsea")
 do CHKEQ^%ut(string,"Tales from Earthsea")
 do CHKEQ^%ut(string("extract","from"),6)
 do CHKEQ^%ut(string("extract","to"),19)
 ;
 quit  ; end of setex404
 ;
 ;
setex405 ; @TEST setex^%ts(.string,"is to unmake power"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="to make love"
 set string("extract","from")=14
 do setex^%ts(.string,"is to unmake power")
 do CHKEQ^%ut(string,"to make love is to unmake power")
 do CHKEQ^%ut(string("extract","from"),14)
 do CHKEQ^%ut(string("extract","to"),31)
 ;
 quit  ; end of setex405
 ;
 ;
setex406 ; @TEST setex^%ts(.string,"cy"): setex test
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="The solution lies in secret"
 set string("extract","from")=27
 do setex^%ts(.string,"cy")
 do CHKEQ^%ut(string,"The solution lies in secrecy")
 do CHKEQ^%ut(string("extract","from"),27)
 do CHKEQ^%ut(string("extract","to"),28)
 ;
 quit  ; end of setex406
 ;
 ;
 ;
 ; group 5: relative addressing
 ;
 ;
setex501 ; @TEST setex^%ts(.string,""): use "b" flag with empty replace
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="The road goes upward towards the light"
 set string("extract","from")="b"
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"The road goes upward towards the light")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex501
 ;
 ;
setex502 ; @TEST setex^%ts(.string,"A"): setex test use "b" flag to prepend character
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string=" dark hand had let go its lifelong hold"
 set string("extract","from")="b"
 do setex^%ts(.string,"A")
 do CHKEQ^%ut(string,"A dark hand had let go its lifelong hold")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),1)
 ;
 quit  ; end of setex502
 ;
 ;
setex503 ; @TEST setex^%ts(.string,"It is not "): use "b" flag to prepend phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="a gift given, but a choice made"
 set string("extract","from")="b"
 do setex^%ts(.string,"It is not ")
 do CHKEQ^%ut(string,"It is not a gift given, but a choice made")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),10)
 ;
 quit  ; end of setex503
 ;
 ;
setex504 ; @TEST setex^%ts(.string,"Injustice makes the rules, and "): "B" flag
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="courage breaks them."
 set string("extract","from")="B"
 do setex^%ts(.string,"Injustice makes the rules, and ")
 do CHKEQ^%ut(string,"Injustice makes the rules, and courage breaks them.")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),31)
 ;
 quit  ; end of setex504
 ;
 ;
setex505 ; @TEST setex^%ts(.string,""): use "a" flag with empty string for replace
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="when you eat illusions you end up hungrier"
 set string("extract","from")="a"
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"when you eat illusions you end up hungrier")
 do CHKEQ^%ut(string("extract","from"),42)
 do CHKEQ^%ut(string("extract","to"),42)
 ;
 quit  ; end of setex505
 ;
 ;
setex506 ; @TEST setex^%ts(.string,"."): use "a" flag to append period
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="Manipulated, one manipulates others"
 set string("extract","from")="a"
 do setex^%ts(.string,".")
 do CHKEQ^%ut(string,"Manipulated, one manipulates others.")
 do CHKEQ^%ut(string("extract","from"),36)
 do CHKEQ^%ut(string("extract","to"),36)
 ;
 quit  ; end of setex506
 ;
 ;
setex507 ; @TEST setex^%ts(.string," selectively"): use "a" flag to append word
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="Statesmen remember things"
 set string("extract","from")="a"
 do setex^%ts(.string," selectively")
 do CHKEQ^%ut(string,"Statesmen remember things selectively")
 do CHKEQ^%ut(string("extract","from"),26)
 do CHKEQ^%ut(string("extract","to"),37)
 ;
 quit  ; end of setex507
 ;
 ;
setex508 ; @TEST setex^%ts(.string," that made me live"): use "A" flag to append phrase
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="I can breathe back the breath"
 set string("extract","from")="A"
 do setex^%ts(.string," that made me live")
 do CHKEQ^%ut(string,"I can breathe back the breath that made me live")
 do CHKEQ^%ut(string("extract","from"),30)
 do CHKEQ^%ut(string("extract","to"),47)
 ;
 quit  ; end of setex508
 ;
 ;
setex509 ; @TEST setex^%ts(.string,""): Use "f" flag with empty string to replace
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Ignorant power is a bane!"
 set string("extract","from")="f"
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"Ignorant power is a bane!")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex509
 ;
 ;
setex510 ; @TEST setex^%ts(.string,"I"): Use "f" flag to replace beginning character
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="U can give them back to the world"
 set string("extract","from")="f"
 do setex^%ts(.string,"I")
 do CHKEQ^%ut(string,"I can give them back to the world")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),1)
 ;
 quit  ; end of setex510
 ;
 ;
setex511 ; @TEST setex^%ts(.string,"Despair"): Use "f" flag to replace beginning
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="MANHOOD speaks evenly, in a quiet voice"
 set string("extract","from")="f"
 do setex^%ts(.string,"Despair")
 do CHKEQ^%ut(string,"Despair speaks evenly, in a quiet voice")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),7)
 ;
 quit  ; end of setex511
 ;
 ;
setex512 ; @TEST setex^%ts(.string,"Injustice"): Use "F" flag to replace beginning
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="AUTHORITY makes the rules"
 set string("extract","from")="F"
 do setex^%ts(.string,"Injustice")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),9)
 ;
 quit  ; end of setex512
 ;
 ;
setex513 ; @TEST setex^%ts(.string,""): use "l" flag with empty replace
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="To which Silence of course made no reply"
 set string("extract","from")="l"
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string,"To which Silence of course made no reply")
 do CHKEQ^%ut(string("extract","from"),40)
 do CHKEQ^%ut(string("extract","to"),40)
 ;
 quit  ; end of setex513
 ;
 ;
setex514 ; @TEST setex^%ts(.string,"n"): use "l" flag to replace end character
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="Greed puts out the suM"
 set string("extract","from")="l"
 do setex^%ts(.string,"n")
 do CHKEQ^%ut(string,"Greed puts out the sun")
 do CHKEQ^%ut(string("extract","from"),22)
 do CHKEQ^%ut(string("extract","to"),22)
 ;
 quit  ; end of setex514
 ;
 ;
setex515 ; @TEST setex^%ts(.string,"strange"): use "l" flag to replace end of string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac 
 ;
 new string set string="The world's vast and ANCIENT"
 set string("extract","from")="l"
 do setex^%ts(.string,"strange")
 do CHKEQ^%ut(string,"The world's vast and strange")
 do CHKEQ^%ut(string("extract","from"),22)
 do CHKEQ^%ut(string("extract","to"),28)
 ;
 quit  ; end of setex515
 ;
 ;
setex516 ; @TEST setex^%ts(.string,"life"): use "L" flag to replace end of string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="To refuse death is to refuse DOOM"
 set string("extract","from")="L"
 do setex^%ts(.string,"life")
 do CHKEQ^%ut(string("extract","from"),30)
 do CHKEQ^%ut(string("extract","to"),33)
 ;
 quit  ; end of setex516
 ;
 ;
setex517 ; @TEST setex^%ts(.string,"life"): use bad flag
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="To refuse death is to refuse DOOM"
 set string("extract","from")="z"
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex517
 ;
 ;
setex518 ; @TEST setex^%ts(.string,"life"): use uppercase bad flag
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="To refuse death is to refuse DOOM"
 set string("extract","from")="Z"
 do setex^%ts(.string,"")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex518
 ;
 ;
setex519 ; @TEST setex^%ts(.string,"life"): use two flags
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="To refuse death is to refuse DOOM"
 set string("extract","from")="li"
 do setex^%ts(.string,"Life")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex519
 ;
 ;
setex520 ; @TEST setex^%ts(.string,"life"): use two flags
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="To refuse death is to refuse DOOM"
 set string("extract","from")="bf"
 do setex^%ts(.string,"Life")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex520
 ;
 ;
setex521 ; @TEST setex^%ts(.string,"life"): use reserved flag
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="To refuse death is to refuse DOOM"
 set string("extract","from")="r"
 do setex^%ts(.string,"Life")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex521
 ;
 ;
 ;
 ; group 6: from & to, absolute addressing w/in string
 ;
 ;
setex601 ; @TEST setex^%ts(.string," boredom of "): insert replace within string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="the terrible pain"
 set string("extract","from")=13
 do setex^%ts(.string," boredom of ")
 do CHKEQ^%ut(string,"the terrible boredom of pain")
 do CHKEQ^%ut(string("extract","from"),13)
 do CHKEQ^%ut(string("extract","to"),24)
 ;
 quit  ; end of setex601
 ;
 ;
setex602 ; @TEST setex^%ts(.string,"banality"): set "to" to replace within string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="admit the ATTRACTION of evil"
 set string("extract","from")=11
 set string("extract","to")=20
 do setex^%ts(.string,"banality")
 do CHKEQ^%ut(string,"admit the banality of evil")
 do CHKEQ^%ut(string("extract","from"),11)
 do CHKEQ^%ut(string("extract","to"),18)
 ;
 quit  ; end of setex602
 ;
 ;
setex603 ; @TEST setex^%ts(.string,"that of life"): Use "L" flag to replace end of string
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="the victory they celebrate is WAR WON WELL"
 set string("extract","from")="L"
 do setex^%ts(.string,"that of life")
 do CHKEQ^%ut(string,"the victory they celebrate is that of life")
 do CHKEQ^%ut(string("extract","from"),31)
 do CHKEQ^%ut(string("extract","to"),42)
 ;
 quit  ; end of setex603
 ;
 ;
setex604 ; @TEST setex^%ts(.string,"to make love "): from relative, to absolute
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
  new string set string="is to unmake power"
 set string("extract","from")="b"
 set string("extract","to")=3
 do setex^%ts(.string,"to make love ")
 do CHKEQ^%ut(string,"to make love is to unmake power")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),13)
 ;
 quit  ; end of setex604
 ;
 ;
setex605 ; @TEST setex^%ts(.string,"to make love "): put flag in from and to
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
  new string set string="is to unmake power"
 set string("extract","from")="b"
 set string("extract","to")="b"
 do setex^%ts(.string,"to make love ")
 do CHKEQ^%ut(string,"to make love is to unmake power")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),13)
 ;
 quit  ; end of setex605
 ;
 ;
setex606 ; @TEST setex^%ts(.string,"to make love "): put flag in to
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
  new string set string="is to unmake power"
 set string("extract","from")="0"
 set string("extract","to")="b"
 do setex^%ts(.string,"to make love ")
 do CHKEQ^%ut(string,"")
 do CHKEQ^%ut(string("extract","from"),0)
 do CHKEQ^%ut(string("extract","to"),0)
 ;
 quit  ; end of setex606
 ;
 ;
 ; group 7: synonyms
 ;
 ;
setex701 ; @TEST se^%ts(.string,"bright"): test se^%ts synonym
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="O the hawk's flight"
 do se^%ts(.string,"bright")
 do CHKEQ^%ut(string,"bright the hawk's flight")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),6)
 ;
 quit  ; end of setex701
 ;
 ;
setex702 ; @TEST setExtract^%ts(.string,"bright"): test setExtract^%ts synonym
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="O the hawk's flight"
 do setExtract^%ts(.string,"bright")
 do CHKEQ^%ut(string,"bright the hawk's flight")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),6)
 ;
 quit  ; end of setex702
 ;
 ;
setex703 ; @TEST place^%ts(.string,"bright"): test place^%ts synonym
 ;
 ;ven/toad&lmry;test;procedure;clean;silent;sac
 ;
 new string set string="O the hawk's flight"
 do place^%ts(.string,"bright")
 do CHKEQ^%ut(string,"bright the hawk's flight")
 do CHKEQ^%ut(string("extract","from"),1)
 do CHKEQ^%ut(string("extract","to"),6)
 ;
 quit  ; end of setex703
 ;
 ;
eor ; end of routine %tsutes
