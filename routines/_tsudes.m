%tsudes ;ven/toad-type string: docs 4 setex^%ts ;2018-12-11T15:10Z
 ;;1.8;Mash;
 ;
 ; %tsudes documents MASH String Library ppi setex^%ts, change
 ; (or create) value of positional substring; it is part of the
 ; String Extract sublibrary.
 ; See %tses for the code itself.
 ; See %tsutes for unit tests for setex^%ts.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Extract library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsudes contains no executable software.
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
 ;@copyright: 2012/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-12-11T15:10Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@signatures
 ; do setex^%ts(.string,replace)
 ; do setex^%ts(.string,replace,flags)
 ;@examples
 ;
 ; In the examples that follow, we use shorthand param names.
 ; Actual parameters passed by reference must be namespaced, and
 ; we refer to
 ;  string("extract","from") as from
 ;  string("extract","to") as to
 ;  string("extract") as success
 ;  string("low","string") as stringlow
 ; and in each example we assume all params have been newed prior
 ; to setting up their before values. If a param is not named in the
 ; before case, it means it was not passed. If it is set to <undef>
 ; it means the param was passed by reference without being given a
 ; value. Otherwise, replace is typically passed by value.
 ;
 ;
 ; group 1: default addressing
 ;
 ;
 ; test 101: r/default char of undef w/undef
 ; (cut default char)
 ;    before:
 ;  string=<undef>
 ;  replace=<undef>
 ;    after:
 ;  success=1
 ;  string=""
 ;  replace=""
 ;  from=0
 ;  to=0
 ;
 ; test 102: r/default char of undef w/""
 ; (cut default char)
 ;    before:
 ;  string=<undef>
 ;  replace=""
 ;    after:
 ;  success=1
 ;  string=""
 ;  from=0
 ;  to=0
 ;
 ; test 103: r/default char of "" w/undef
 ; (cut default char)
 ;    before:
 ;  string=""
 ;  replace=<undef>
 ;    after:
 ;  success=1
 ;  string=""
 ;  replace=""
 ;  from=0
 ;  to=0
 ;
 ; test 104: r/default char of "" w/""
 ; (cut default char)
 ;    before:
 ;  string=""
 ;  replace=""
 ;    after:
 ;  success=1
 ;  string=""
 ;  from=0
 ;  to=0
 ;
 ; test 105: r/default char of "" w/"*"
 ;    before:
 ;  string=""
 ;  replace="*"
 ;    after:
 ;  success=1
 ;  string="*"
 ;  from=1
 ;  to=1
 ;
 ; test 106: r/default char of "" w/"Sparrowhawk"
 ;   before:
 ;  string=""
 ;  replace="Sparrowhawk"
 ;   after:
 ;  success=1
 ;  string="Sparrowhawk"
 ;  from=1
 ;  to=11
 ;
 ; test 107: r/1st char (def) of phrase w/""
 ; (cut default char)
 ;    before:
 ;  string="Never the way he can follow grows narrower"
 ;  replace=""
 ;    after:
 ;  success=1
 ;  string="ever the way he can follow grows narrower"
 ;  from=0
 ;  to=0
 ;
 ; test 108: r/default char (def) of phrase w/"o"
 ;    before:
 ;  string="In the empty sky."
 ;  replace="o"
 ;    after:
 ;  success=1
 ;  string="on the empty sky."
 ;  from=1
 ;  to=1
 ;
 ; test 109: r/1st char of phrase w/"bright"
 ; (expand default char)
 ;   before:
 ;  string="O the hawk's flight"
 ;  replace="bright"
 ;   after:
 ;  success=1
 ;  string="bright the hawk's flight"
 ;  from=1
 ;  to=6
 ;
 ;
 ; group 2: absolute addressing w/in string
 ;
 ;
 ; test 201: r/char 1 w/""
 ; (cut char 1)
 ;   before:
 ;  string="She lay thus dark and dumb"
 ;  replace=""
 ;  from=1
 ;   after:
 ;  success=1
 ;  string="he lay thus dark and dumb"
 ;  from=0
 ;  to=0
 ;
 ; test 202: r/char 1 w/"A"
 ;    before:
 ;  string="O Wizard of Earthsea"
 ;  replace="A"
 ;  from=1
 ;    after:
 ;  success=1
 ;  string="A Wizard of Earthsea"
 ;  from=1
 ;  to=1
 ;
 ; test 203: r/char 1 w/"To"
 ; (expand char 1)
 ;    before:
 ;  string="I hear, one must be silent."
 ;  replace="To"
 ;  from=1
 ;    after:
 ;  success=1
 ;  string="To hear, one must be silent."
 ;  from=1
 ;  to=2
 ;
 ; test 204: r/char 11 w/""
 ; (cut char 11)
 ;    before:
 ;  string="until at lEast he chooses nothing"
 ;  replace=""
 ;  from=11
 ;    after:
 ;  success=1
 ;  string="until at last he chooses nothing"
 ;  from=10
 ;  to=10
 ;
 ; test 205: r/char 12 w/"c"
 ;    before:
 ;  string="To light a Sandle is to cast a shadow."
 ;  replace="c"
 ;  from=12
 ;    after:
 ;  success=1
 ;  string="To light a candle is to cast a shadow."
 ;  from=12
 ;  to=12
 ;
 ; test 206: r/char 9 w/phrase
 ; (expand char 9)
 ;    before:
 ;  string="does onlY what he must do"
 ;  replace="y and wholly"
 ;  from=9
 ;    after:
 ;  success=1
 ;  string="does only and wholly what he must do"
 ;  from=9
 ;  to=20
 ;
 ; test 207: r/last char w/""
 ; (cut last char)
 ;    before:
 ;  string="For a word to be spoken there must be silenceS"
 ;  replace=""
 ;  from=46
 ;    after:
 ;  success=1
 ;  string="For a word to be spoken there must be silence"
 ;  from=45
 ;  to=45
 ;
 ; test 208: r/last char w/"s"
 ;    before:
 ;  string="there must be darkness to see the starT"
 ;  replace="s"
 ;  from=39
 ;    after:
 ;  success=1
 ;  string="there must be darkness to see the stars"
 ;  from=39
 ;  to=39
 ;
 ; test 209: r/last char w/phrase
 ; (expand last char)
 ;    before:
 ;  string="only men do"
 ;  replace="o evil"
 ;  from=11
 ;    after:
 ;  success=1
 ;  string="only men do evil"
 ;  from=11
 ;  to=16
 ;
 ;
 ; group 3: absolute addressing before string
 ;
 ;
 ; test 301: r/char 0 w/""
 ; (cut char 0)
 ;    before:
 ;  string="She wept in pain, because she was free"
 ;  replace=""
 ;  from=0
 ;    after:
 ;  success=1
 ;  string="She wept in pain, because she was free"
 ;  from=0
 ;  to=0
 ;
 ; test 302: r/char 0 w/"w"
 ; (insert char 0)
 ;    before:
 ;  string="eight of liberty"
 ;  replace="w"
 ;  from=0
 ;    after:
 ;  success=1
 ;  string="weight of liberty"
 ;  from=1
 ;  to=1
 ;
 ; test 303: r/char -1 w/"A"
 ; (insert char -1, pad w/space)
 ;    before:
 ;  string="Wizard of Earthsea"
 ;  replace="A"
 ;  from=-1
 ;    after:
 ;  success=1
 ;  string="A Wizard of Earthsea"
 ;  from=1
 ;  to=1
 ;
 ; test 304: r/chars -3:-1 w/"The"
 ; (insert at char -3, pad w/space)
 ;    before:
 ;  string="Tombs of Atuan"
 ;  replace="The"
 ;  from=-3
 ;    after:
 ;  success=1
 ;  string="The Tombs of Atuan"
 ;  from=1
 ;  to=3
 ;
 ; test 305: r/chars -5:-3 w/"The"
 ; (insert at char -5, pad w/spaces)
 ;    before:
 ;  string="Farthest Shore"
 ;  replace="The"
 ;  from=-5
 ;    after:
 ;  success=1
 ;  string="The   Farthest Shore"
 ;  from=1
 ;  to=3
 ;
 ; test 306: r/char -4 w/""
 ; (pad left w/spaces)
 ;    before:
 ;  string="Tehanu"
 ;  from=-4
 ;    after:
 ;  success=1
 ;  string="    Tehanu"
 ;  from=0
 ;  to=0
 ;
 ; test 307: r/char -1 w/phrase
 ; (overlapping left replace)
 ;    before:
 ;  string="Another Wind"
 ;  replace="The O"
 ;  from=-1
 ;    after:
 ;  success=1
 ;  string="The Other Wind"
 ;  from=1
 ;  to=5
 ;
 ;
 ; group 4: absolute addressing after string
 ;
 ;
 ; test 401: r/char last+1 w/""
 ; (insert nothing just after string = no-op)
 ;    before:
 ;  string="muddle, mystery, mumbling"
 ;  replace=""
 ;  from=26
 ;    after:
 ;  success=1
 ;  string="muddle, mystery, mumbling"
 ;  from=25
 ;  to=25
 ;
 ; test 402: r/char last+2 w/""
 ; (pad right w/space)
 ;    before:
 ;  string="There's no way to use power for good."
 ;  replace=""
 ;  from=39
 ;    after:
 ;  success=1
 ;  string="There's no way to use power for good. "
 ;  from=38
 ;  to=38
 ;
 ; test 403: r/char last+4 w/""
 ; (pad right w/spaces)
 ;    before:
 ;  string="All times are changing times"
 ;  replace=""
 ;  from=32
 ;    after:
 ;  success=1
 ;  string="All times are changing times   "
 ;  from=31
 ;  to=31
 ;
 ; test 404: r/char last+1 w/phrase
 ; (append)
 ;    before:
 ;  string="Tales"
 ;  replace=" from Earthsea"
 ;  from=6
 ;    after:
 ;  success=1
 ;  string="Tales from Earthsea"
 ;  from=6
 ;  to=19
 ;
 ; test 405: r/char last+2 w/phrase
 ; (append phrase & pad space delimiter)
 ;    before:
 ;  string="to make love"
 ;  replace="is to unmake power"
 ;  from=14
 ;    after:
 ;  success=1
 ;  string="to make love is to unmake power"
 ;  from=14
 ;  to=31
 ;
 ; test 406: r/last char w/"cy"
 ; (replace last char & extend string)
 ;    before:
 ;  string="The solution lies in secret"
 ;  replace="cy"
 ;  from=27
 ;    after:
 ;  success=1
 ;  string="The solution lies in secrecy"
 ;  from=27
 ;  to=28
 ;
 ;
 ; group 5: relative addressing
 ;
 ;
 ; test 501: r/before w/""
 ; (no-op)
 ;    before:
 ;  string="The road goes upward towards the light"
 ;  replace=""
 ;  from="b"
 ;    after:
 ;  success=1
 ;  string="The road goes upward towards the light"
 ;  from=0
 ;  to=0
 ;
 ; test 502: r/before w/"A"
 ; (prepend 1 char)
 ;    before:
 ;  string=" dark hand had let go its lifelong hold"
 ;  replace="A"
 ;  from="b"
 ;    after:
 ;  success=1
 ;  string="A dark hand had let go its lifelong hold"
 ;  from=1
 ;  to=1
 ;
 ; test 503: r/before w/phrase
 ; (prepend phrase)
 ;    before:
 ;  string="a gift given, but a choice made"
 ;  replace="It is not "
 ;  from="b"
 ;    after:
 ;  success=1
 ;  string="It is not a gift given, but a choice made"
 ;  from=1
 ;  to=10
 ;
 ; test 504: r/Before w/clause
 ; (prepend clause)
 ;    before:
 ;  string="courage breaks them."
 ;  replace="Injustice makes the rules, and "
 ;  from="B"
 ;    after:
 ;  success=1
 ;  string="Injustice makes the rules, and courage breaks them."
 ;  from=1
 ;  to=31
 ;
 ; test 505: r/after w/""
 ; (append nothing, no-op)
 ;    before:
 ;  string="when you eat illusions you end up hungrier"
 ;  replace=""
 ;  from="a"
 ;    after:
 ;  success=1
 ;  string="when you eat illusions you end up hungrier"
 ;  from=42
 ;  to=42
 ;
 ; test 506: r/after w/"."
 ; (append period)
 ;    before:
 ;  string="Manipulated, one manipulates others"
 ;  replace="."
 ;  from="a"
 ;    after:
 ;  success=1
 ;  string="Manipulated, one manipulates others."
 ;  from=36
 ;  to=36
 ;
 ; test 507: r/after w/word
 ; (append space & word)
 ;    before:
 ;  string="Statesmen remember things"
 ;  replace=" selectively"
 ;  from="a"
 ;    after:
 ;  success=1
 ;  string="Statesmen remember things selectively"
 ;  from=26
 ;  to=37
 ;
 ; test 508: r/After w/phrase
 ; (append space & phrase)
 ;    before:
 ;  string="I can breathe back the breath"
 ;  replace=" that made me live"
 ;  from="A"
 ;    after:
 ;  success=1
 ;  string="I can breathe back the breath that made me live"
 ;  from=30
 ;  to=47
 ;
 ; test 509: r/first w/""
 ; (replace 1st 0 chars, no-op)
 ;    before:
 ;  string="Ignorant power is a bane!"
 ;  replace=""
 ;  from="f"
 ;    after:
 ;  success=1
 ;  string="Ignorant power is a bane!"
 ;  from=0
 ;  to=0
 ;
 ; test 510: r/first w/"I"
 ; (replace 1st char)
 ;    before:
 ;  string="U can give them back to the world"
 ;  replace="I"
 ;  from="f"
 ;    after:
 ;  success=1
 ;  string="I can give them back to the world"
 ;  from=1
 ;  to=1
 ;
 ; test 511: r/first w/"Despair"
 ; (replace 1st word)
 ;    before:
 ;  string="MANHOOD speaks evenly, in a quiet voice"
 ;  replace="Despair"
 ;  from="f"
 ;    after:
 ;  success=1
 ;  string="Despair speaks evenly, in a quiet voice"
 ;  from=1
 ;  to=7
 ;
 ; test 512: r/First w/"Injustice"
 ; (replace 1st word)
 ;    before:
 ;  string="AUTHORITY makes the rules"
 ;  replace="Injustice"
 ;  from="F"
 ;    after:
 ;  success=1
 ;  string="Injustice makes the rules"
 ;  from=1
 ;  to=9
 ;
 ; test 513: r/last w/""
 ; (cut last char)
 ;    before:
 ;  string="To which Silence of course made no reply"
 ;  replace=""
 ;  from="l"
 ;    after:
 ;  success=1
 ;  string="To which Silence of course made no repl"
 ;  from=39
 ;  to=39
 ;
 ; test 514: r/last w/"n"
 ; (replace last char)
 ;    before:
 ;  string="Greed puts out the suM"
 ;  replace="n"
 ;  from="l"
 ;    after:
 ;  success=1
 ;  string="Greed puts out the sun"
 ;  from=22
 ;  to=22
 ;
 ; test 515: r/last w/"strange"
 ; (replace last word)
 ;    before:
 ;  string="The world's vast and ANCIENT"
 ;  replace="strange"
 ;  from="l"
 ;    after:
 ;  success=1
 ;  string="The world's vast and strange"
 ;  from=22
 ;  to=28
 ;
 ; test 516: r/Last w/"life"
 ; (replace Last word)
 ;    before:
 ;  string="To refuse death is to refuse DOOM"
 ;  replace="life"
 ;  from="L"
 ;    after:
 ;  success=1
 ;  string="To refuse death is to refuse life"
 ;  from=30
 ;  to=33
 ;
 ; test 517: r/Last w/phrase
 ; (replace Last words)
 ;   before:
 ;  string="the victory they celebrate is WAR WON WELL"
 ;  replace="that of life"
 ;  from="L"
 ;   after:
 ;  success=1
 ;  string="the victory they celebrate is that of life"
 ;  from=31
 ;  to=42
 ;
 ; test 518: from="z" (bad value)
 ; (failed call)
 ;    before:
 ;  string="To refuse death is to refuse DOOM"
 ;  replace=""
 ;  from="z"
 ;    after:
 ;  success=0
 ;  string=""
 ;  from=0
 ;  to=0
 ;
 ; test 519: from="Z" (bad value)
 ; (failed call)
 ;    before:
 ;  string="To refuse death is to refuse DOOM"
 ;  replace=""
 ;  from="Z"
 ;    after:
 ;  success=0
 ;  string=""
 ;  from=0
 ;  to=0
 ;
 ; test 520: from="li" (good & bad values)
 ; (failed call)
 ;    before:
 ;  string="To refuse death is to refuse DOOM"
 ;  replace="Life"
 ;  from="li"
 ;    after:
 ;  success=0
 ;  string=""
 ;  from=0
 ;  to=0
 ;
 ; test 521: from="bf" (incompatible good values)
 ; (failed call)
 ;    before:
 ;  string="To refuse death is to refuse DOOM"
 ;  replace="Life"
 ;  from="bf"
 ;    after:
 ;  success=0
 ;  string=""
 ;  from=0
 ;  to=0
 ;
 ;
 ; group 6: from & to, absolute addressing w/in string [tbd]
 ;
 ;
 ; test 601: r/char 13 w/phrase
 ; (replace & expand middle char)
 ;    before:
 ;  string="the terrible pain"
 ;  replace=" boredom of "
 ;  from=13
 ;    after:
 ;  success=1
 ;  string="the terrible boredom of pain"
 ;  from=13
 ;  to=24
 ;
 ; test 602: w/chars 11:20 w/word
 ; (replace word w/shorter word)
 ;    before:
 ;  string="admit the ATTRACTION of evil"
 ;  replace="banality"
 ;  from=11
 ;  to=20
 ;    after:
 ;  success=1
 ;  string="admit the banality of evil"
 ;  from=11
 ;  to=18
 ;
 ;
 ; group 7: from & to, absolute addressing before string [tbd]
 ;
 ;
 ; group 8: from & to, absolute addressing after string [tbd]
 ;
 ;
 ; group 9: from & to, relative addressing [tbd]
 ;
 ;
 ; test 901: r/before:3 w/phrase
 ; (from="b" overrides to=3)
 ;    before:
 ;  string="is to unmake power"
 ;  replace="to make love "
 ;  from="b"
 ;  to=3
 ;    after:
 ;  success=1
 ;  string="to make love is to unmake power"
 ;  from=1
 ;  to=13
 ;
 ; test 902: r/before:before w/clause
 ; (if from="b" then to="b" redundant)
 ;    before:
 ;  string="tired is stupid."
 ;  replace="Go to bed; "
 ;  from="b"
 ;  to="b"
 ;    after:
 ;  success=1
 ;  string="Go to bed; tired is stupid."
 ;  from=1
 ;  to=11
 ;
 ; test 903: from=0, to="b"
 ;    before:
 ;  string=
 ;  replace=
 ;  from=
 ;  to=
 ;    after:
 ;  success=
 ;  string=
 ;  from=
 ;  to=
 ;
 ;  new string set string="is to unmake power"
 ;  set string("extract","from")="0"
 ;  set string("extract","to")="b"
 ;  do setex^%ts(.string,"to make love ")
 ; produces
 ;  string=""
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;
 ; group a: reserved values & other boundary conditions [tbd]
 ;
 ;
 ;  test a01: flags=BAD
 ;   before:
 ;  string=
 ;  replace=
 ;   after:
 ;  string=
 ;  replace=
 ;  success=
 ;  from=
 ;  to=
 ;  new string set string="Greed puts out"
 ;  set string("extract","from")="a"
 ;  do setex^%ts(.string," the sun","BAD")
 ; produces
 ;  string="Greed puts out"
 ;  string("extract")=0
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;
 ; group b: the b flag [tbd]
 ;
 ;
 ; only difference: for deletions, from & to set to +1
 ; except at end, where set to 0
 ;
 ;
 ; group c: the i flag [tbd]
 ;
 ;
 ; show effects on string("low",string")
 ;
 ;  test c01: i flag & prepad
 ;   before:
 ;  string=
 ;  replace=
 ;   after:
 ;  string=
 ;  replace=
 ;  success=
 ;  from=
 ;  to=
 ;  new string
 ;  set string("extract","from")=3
 ;  new insert set insert="The world is in balance."
 ;  do setex^%ts(.string,insert,"i")
 ; produces
 ;  string="  The world is in balance."
 ;  string("extract")=1
 ;  string("extract","from")=3
 ;  string("extract","to")=26
 ;  string("low","string")="  the world is in balance."
 ;
 ;
 ; group d: the r flag [tbd]
 ;
 ;
 ; show effects on string("low",string")
 ;
 ;
 ; group e: synonyms
 ;
 ;
 ;  test e01: se^%ts synonym
 ;   before:
 ;  string=
 ;  replace=
 ;   after:
 ;  string=
 ;  replace=
 ;  success=
 ;  from=
 ;  to=
 ;  new string set string="O the hawk's flight"
 ;  do se^%ts(.string,"bright")
 ; produces
 ;  string="bright the hawk's flight"
 ;  string("extract","from")=1
 ;  string("extract","to")=6
 ;
 ;  test e02: setExtract^%ts synonym
 ;   before:
 ;  string=
 ;  replace=
 ;   after:
 ;  string=
 ;  replace=
 ;  success=
 ;  from=
 ;  to=
 ;  new string set string="O the hawk's flight"
 ;  do setExtract^%ts(.string,"bright")
 ; produces
 ;  string="bright the hawk's flight"
 ;  string("extract","from")=1
 ;  string("extract","to")=6
 ;
 ;  test e03: place^%ts synonym
 ;   before:
 ;  string=
 ;  replace=
 ;   after:
 ;  string=
 ;  replace=
 ;  success=
 ;  from=
 ;  to=
 ;  new string set string="O the hawk's flight"
 ;  do place^%ts(.string,"bright")
 ; produces
 ;  string="bright the hawk's flight"
 ;  string("extract","from")=1
 ;  string("extract","to")=6
 ;
 ;
 ;
eor ; end of routine %tsudes
