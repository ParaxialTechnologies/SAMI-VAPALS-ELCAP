%tses ;ven/toad-type string: setex^%ts ;2018-02-28T19:33Z
 ;;1.8;Mash;
 ;
 ; %tses implements MASH String Library ppi setex^%ts, change
 ; (or create) value of positional substring; it is part of the
 ; String Extract sublibrary.
 ; See %tsutes for unit tests for setex^%ts.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tses contains no public entry points.
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
 ;@last-updated: 2018-02-28T19:33Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; put back from and to parameters
 ; apply standard string-length protection consistently
 ; add ability to call by passing object
 ;  s or S = case-sensitive replace
 ;  call("case")
 ;  call("extract","from")
 ;  call("extract","to")
 ;  call("replace")
 ;  call("low","string")
 ;  call("string")
 ; add feature to load object w/parameters for shorter calls
 ;  find => call("find")
 ; apply standard string-length protection consistently
 ; create findm/findmsg to preload call-message array
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
 ;@ppi-code setex^%ts
setex ; change value of positional substring
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;procedure;clean;silent;sac;NO tests
 ;@signatures
 ; setex^%ts(.string,replace)
 ; setex^%ts(.string,replace,flags)
 ; setex^%ts(.string,replace,flags)
 ;@synonyms
 ; se^%ts
 ; setExtract^%ts
 ; place^%ts
 ;@branches-from
 ; setex^%ts
 ;@ppi-called-by: none yet, but just wait an hour or two
 ;@called-by: none
 ;@calls
 ; $$lowcase^%ts
 ;@input
 ;.string = string to set an extract into
 ; replace = replacement substring to place into string
 ; flags = characters to control set [optional]
 ;  b or B = set for a backward scan
 ;  i or I = set for a case-insensitive scan
 ;  r or R = refresh lower-case versions of string & replace
 ;@throughput
 ;.string("extract","from") = pos of 1st char of substring to set
 ;.string("extract","to") = pos of last char of substring to set
 ;.string("low","string") = lowercase string value [if i flag]
 ;@examples
 ;
 ; group 1: default addressing
 ;
 ;  new string,replace
 ;  do setex^%ts(.string,.replace)
 ; produces
 ;  string=""
 ;  replace=""
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string=""
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string=""
 ;  new replace
 ;  do setex^%ts(.string,.replace)
 ; produces
 ;  string=""
 ;  replace=""
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string=""
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string=""
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string=""
 ;  do setex^%ts(.string,"*")
 ; produces
 ;  string="*"
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string=""
 ;  do setex^%ts(.string,"Sparrowhawk")
 ; produces
 ;  string="Sparrowhawk"
 ;  string("extract","from")=1
 ;  string("extract","to")=11
 ;
 ;  new string set string="Never the way he can follow grows narrower"
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="ever the way he can follow grows narrower"
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="In the empty sky."
 ;  do setex^%ts(.string,"o")
 ; produces
 ;  string="on the empty sky."
 ;  string("extract","from")=1
 ;  string("extract","to")=1
 ;
 ;  new string set string="O the hawk's flight"
 ;  do setex^%ts(.string,"bright")
 ; produces
 ;  string="bright the hawk's flight"
 ;  string("extract","from")=1
 ;  string("extract","to")=5
 ;
 ; group 2: absolute addressing w/in string
 ;
 ;  new string set string="She lay thus dark and dumb"
 ;  set string("from")=1
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="he lay thus dark and dumb"
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="O Wizard of Earthsea"
 ;  set string("extract","from")=1
 ;  do setex^%ts(.string,"A")
 ; produces
 ;  string="A Wizard of Earthsea"
 ;  string("extract","from")=1
 ;  string("extract","to")=1
 ;
 ;  new string set string="I hear, one must be silent."
 ;  set string("extract","from")=1
 ;  do setex^%ts(.string,"To")
 ; produces
 ;  string="To hear, one must be silent."
 ;  string("extract","from")=1
 ;  string("extract","to")=2
 ;
 ;  new string set string="until at lEast he chooses nothing"
 ;  set string("extract","from")=11
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="until at last he chooses nothing"
 ;  string("extract","from")=10
 ;  string("extract","to")=10
 ;
 ;  new string set string="To light a Sandle is to cast a shadow."
 ;  set string("extract","from")=12
 ;  do setex^%ts(.string,"c")
 ; produces
 ;  string="To light a candle is to cast a shadow."
 ;  string("extract","from")=12
 ;  string("extract","to")=12
 ;
 ;  new string set string="does onlY what he must do"
 ;  set string("extract","from")=9
 ;  do setex^%ts(.string,"y and wholly")
 ; produces
 ;  string="does only and wholly what he must do"
 ;  string("extract","from")=9
 ;  string("extract","to")=20
 ;
 ;  new string set string="For a word to be spoken there must be silenceS"
 ;  set string("extract","from")=46
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="For a word to be spoken there must be silence"
 ;  string("extract","from")=45
 ;  string("extract","to")=45
 ;
 ;  new string set string="there must be darkness to see the starT"
 ;  set string("extract","from")=39
 ;  do setex^%ts(.string,"s")
 ; produces
 ;  string="there must be darkness to see the stars"
 ;  string("extract","from")=39
 ;  string("extract","to")=39
 ;
 ;  new string set string="only men do"
 ;  set string("extract","from")=11
 ;  do setex^%ts(.string,"o evil")
 ; produces
 ;  string="only men do evil"
 ;  string("extract","from")=11
 ;  string("extract","to")=16
 ;
 ; group 3: absolute addressing before string
 ;
 ;  new string set string="She wept in pain, because she was free"
 ;  set string("extract","from")=0
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="She wept in pain, because she was free"
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="eight of liberty"
 ;  set string("extract","from")=0
 ;  do setex^%ts(.string,"w")
 ; produces
 ;  string="weight of liberty"
 ;  string("extract","from")=1
 ;  string("extract","to")=1
 ;
 ;  new string set string="Wizard of Earthsea"
 ;  set string("extract","from")=-1
 ;  do setex^%ts(.string,"A")
 ; produces
 ;  string="A Wizard of Earthsea"
 ;  string("extract","from")=1
 ;  string("extract","to")=1
 ;
 ;  new string set string="Tombs of Atuan"
 ;  set string("extract","from")=-3
 ;  do setex^%ts(.string,"The")
 ; produces
 ;  string="The Tombs of Atuan"
 ;  string("extract","from")=1
 ;  string("extract","to")=3
 ;
 ;  new string set string="Farthest Shore"
 ;  set string("extract","from")=-5
 ;  do setex^%ts(.string,"The")
 ; produces
 ;  string="The   Farthest Shore"
 ;  string("extract","from")=1
 ;  string("extract","to")=3
 ;
 ;  new string set string="Tehanu"
 ;  set string("extract","from")=-4
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="    Tehanu"
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="Another Wind"
 ;  set string("extract","from")=-1
 ;  do setex^%ts(.string,"The O")
 ; produces
 ;  string="The Other Wind"
 ;  string("extract","from")=1
 ;  string("extract","to")=5
 ;
 ; group 4: absolute addressing after string
 ;
 ;  new string set string="muddle, mystery, mumbling"
 ;  set string("extract","from")=26
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="muddle, mystery, mumbling"
 ;  string("extract","from")=25
 ;  string("extract","to")=25
 ;
 ;  new string set string="There's no way to use power for good."
 ;  set string("extract","from")=39
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="There's no way to use power for good. "
 ;  string("extract","from")=38
 ;  string("extract","to")=38
 ;
 ;  new string set string="All times are changing times"
 ;  set string("extract","from")=32
 ;  do setex^%ts(.string,"")
 ; produces string="All times are changing times   "
 ;  string("extract","from")=31
 ;  string("extract","to")=31
 ;
 ;  new string set string="Tales"
 ;  set string("extract","from")=6
 ;  do setex^%ts(.string," from Earthsea")
 ; produces
 ;  string="Tales from Earthsea"
 ;  string("extract","from")=6
 ;  string("extract","to")=19
 ;
 ;  new string set string="to make love"
 ;  set string("extract","from")=14
 ;  do setex^%ts(.string,"is to unmake power")
 ; produces
 ;  string="to make love is to unmake power"
 ;  string("extract","from")=14
 ;  string("extract","to")=31
 ;
 ;  new string set string="The solution lies in secret"
 ;  set string("extract","from")=27
 ;  do setex^%ts(.string,"cy")
 ; produces
 ;  string="The solution lies in secrecy"
 ;  string("extract","from")=27
 ;  string("extract","to")=28
 ;
 ; group 5: relative addressing
 ;
 ;  new string set string="The road goes upward towards the light"
 ;  set string("extract","from")="b"
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="The road goes upward towards the light"
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string=" dark hand had let go its lifelong hold"
 ;  set string("extract","from")="b"
 ;  do setex^%ts(.string,"A")
 ; produces string="A dark hand had let go its lifelong hold"
 ;  string("extract","from")=1
 ;  string("extract","to")=1
 ;
 ;  new string set string="a gift given, but a choice made"
 ;  set string("extract","from")="b"
 ;  do setex^%ts(.string,"It is not ")
 ; produces
 ;  string="It is not a gift given, but a choice made"
 ;  string("extract","from")=1
 ;  string("extract","to")=10
 ;
 ;  new string set string="courage breaks them."
 ;  set string("extract","from")="B"
 ;  do setex^%ts(.string,"Injustice makes the rules, and ")
 ; produces
 ;  string="Injustice makes the rules, and courage breaks them."
 ;  string("extract","from")=1
 ;  string("extract","to")=31
 ;
 ;  new string set string="when you eat illusions you end up hungrier"
 ;  set string("extract","from")="a"
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="when you eat illusions you end up hungrier"
 ;  string("extract","from")=51
 ;  string("extract","to")=51
 ;
 ;  new string set string="Manipulated, one manipulates others"
 ;  set string("extract","from")="a"
 ;  do setex^%ts(.string,".")
 ; produces
 ;  string="Manipulated, one manipulates others."
 ;  string("extract","from")=36
 ;  string("extract","to")=36
 ;
 ;  new string set string="Statesmen remember things"
 ;  set string("extract","from")="a"
 ;  do setex^%ts(.string," selectively")
 ; produces
 ;  string="Statesmen remember things selectively"
 ;  string("extract","from")=26
 ;  string("extract","to")=37
 ;
 ;  new string set string="I can breathe back the breath"
 ;  set string("extract","from")="A"
 ;  do setex^%ts(.string," that made me live")
 ; produces string="I can breathe back the breath that made me live"
 ;  string("extract","from")=30
 ;  string("extract","to")=47
 ;
 ;  new string set string="Ignorant power is a bane!"
 ;  set string("extract","from")="f"
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="Ignorant power is a bane!"
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="U can give them back to the world"
 ;  set string("extract","from")="f"
 ;  do setex^%ts(.string,"I")
 ; produces
 ;  string="I can give them back to the world"
 ;  string("extract","from")=1
 ;  string("extract","to")=1
 ;
 ;  new string set string="MANHOOD speaks evenly, in a quiet voice"
 ;  set string("extract","from")="f"
 ;  do setex^%ts(.string,"Despair")
 ; produces
 ;  string="Despair speaks evenly, in a quiet voice"
 ;  string("extract","from")=1
 ;  string("extract","to")=7
 ;
 ;  new string set string="AUTHORITY makes the rules"
 ;  set string("extract","from")="F"
 ;  do setex^%ts(.string,"Injustice")
 ; produces string="Injustice makes the rules"
 ;  string("extract","from")=1
 ;  string("extract","to")=9
 ;
 ;  new string set string="To which Silence of course made no reply"
 ;  set string("extract","from")="l"
 ;  do setex^%ts(.string,"")
 ; produces
 ;  string="To which Silence of course made no reply"
 ;  string("extract","from")=40
 ;  string("extract","to")=40
 ;
 ;  new string set string="Greed puts out the suM"
 ;  set string("extract","from")="l"
 ;  do setex^%ts(.string,"n")
 ; produces
 ;  string="Greed puts out the sun"
 ;  string("extract","from")=22
 ;  string("extract","to")=22
 ;
 ;  new string set string="The world's vast and ANCIENT"
 ;  set string("extract","from")="l"
 ;  do setex^%ts(.string,"strange")
 ; produces string="The world’s vast and strange"
 ;  string("extract","from")=22
 ;  string("extract","to")=28
 ;
 ;  new string set string="To refuse death is to refuse DOOM"
 ;  set string("extract","from")="L"
 ;  do setex^%ts(.string,"life")
 ; produces string="To refuse death is to refuse life"
 ;  string("extract","from")=30
 ;  string("extract","to")=33
 ;
 ; group 6: from & to, absolute addressing w/in string [tbd]
 ;
 ;  new string set string="the terrible pain"
 ;  set string("extract","from")=13
 ;  do setex^%ts(.string," boredom of ")
 ; produces
 ;  string="the terrible boredom of pain"
 ;  string("extract","from")=13
 ;  string("extract","to")=24
 ;
 ;  new string set string="admit the ATTRACTION of evil"
 ;  set string("extract","from")=11
 ;  set string("extract","to")=20
 ;  do setex^%ts(.string,"banality")
 ; produces
 ;  string="admit the banality of evil"
 ;  string("extract","from")=11
 ;  string("extract","to")=18
 ;
 ;  new string set string="the victory they celebrate is WAR WON WELL"
 ;  set string("extract","from")="L"
 ;  do setex^%ts(.string,"that of life")
 ; produces
 ;  string="the victory they celebrate is that of life"
 ;  string("extract","from")=31
 ;  string("extract","to")=42
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
 ; group 11: reserved values & other boundary conditions [tbd]
 ;
 ;
 ; group 12: the b flag [tbd]
 ;
 ; only difference: for deletions, from & to set to +1
 ; except at end, where set to 0
 ;
 ; group 12: the i flag [tbd]
 ;
 ; show effects on string("low",string")
 ;
 ; group 12: the r flag [tbd]
 ;
 ; show effects on string("low",string")
 ;
 ;@tests [tbd]
 ;
 ;@stanza 2 detailed description
 ;
 ; setex^%ts is an enhanced version of the Mumps set $extract.
 ; It will place characters w/in a string at the specified position.
 ;
 ; (Note: a future version of setex^%ts will support a new call-
 ; message system of passing parameters. For now, the embryonic form
 ; is the behavior of the string array, which find^%ts &
 ; setextract%ts manage.)
 ;
 ; In the discussion that follows, string("extract","from") will be
 ; referred to as from, & string("extract","to") as to.
 ;
 ;
 ; I. about string & replace
 ;
 ; If either string or replace is passed undefined or = the empty
 ; string (""), it is said to be empty, because it contains no
 ; characters & no positions. When setex^%ts sets a value to
 ; empty, it sets it = the empty string. Placing a substring into a
 ; string will never leave that string undefined; canonically, even
 ; the minimal case will leave string empty instead of undefined.
 ; Although replace need only be passed by value, if passed by
 ; reference undefined the same holds true; it will never be left
 ; undefined but will be set to empty.
 ;
 ; Together, string & replace define most or all of the contents of
 ; the place operation, as well as what kind of placement occurs:
 ;
 ; 1. Overwrite Substring: if neither string nor replace is empty,
 ; string will be altered to overwrite the characters at positions
 ; from through to (see below) w/substring replace.
 ;
 ; 2. Create Substring: if string is empty, setex^%ts will create
 ; a string of spaces & place substring replace w/in that.
 ;
 ; 3. Delete Substring: if replace is empty, then the overwritten
 ; characters in the string are removed but not replaced.
 ;
 ;
 ; II. about from & to as input
 ;
 ; from & to are optional. from defaults to 1, just as with $extract.
 ; to defaults to = from. They can have two different kinds of values:
 ;
 ; i. Absolute Addressing: from & to may be integers, in which case they
 ; identify character positions before, within, or after the range from
 ; 1 to string's length. If passed with a decimal part, it is truncated
 ; (any decimal parts will be ignored). If to evaluates to <= from,
 ; it is treated as = from. Values > the string's length extend string
 ; to the right to create the positions, padding with spaces if needed,
 ; just as set $extract does. Values < 1 extend string to the left to
 ; create the positions, which set $extract does not do.
 ;
 ; ii. Relative Addressing: from may be passed as one of four codes:
 ; b, a, f, l (or their uppercase equivalents). In this case, to is
 ; ignored. Other code values are reserved for future versions of
 ; setex^%ts:
 ; a. B-1, B-2, etc., b-1, b-2, etc.
 ; b. A+1, A+2, etc., a+1, a+2, etc.
 ; c. F+1, F+2, etc., f+1, f+2, etc.
 ; d. L-1, L-2, etc., l-1, l-2, etc.
 ; e. all other string values.
 ; For now, if any of these values is used for from, setex^%ts will
 ; set string = empty, but this behavior may not be relied upon in future
 ; versions.
 ;
 ; Together, from & to define the locations w/in string to be altered
 ; by the placement, which in turn defines which characters are
 ; overwritten or created by the place operation. There are five main
 ; categories of placement, categorized by from's value (in each case,
 ; if to is passed it has requirements for its value, and passing it
 ; with any other value will result in setting string = empty):
 ;
 ; a. Place Within: if from's value is not < 1 nor > the length of
 ; string, then to is required either to = 0 or a value w/in that same
 ; range >= from. In this case, the characters located by from & to are
 ; removed & replace is inserted, which may or may not change the length
 ; of string.
 ;
 ; b. Place Before String (Prepend): if from = "b" or "B", then to will
 ; be ignored. In this case, replace is concatenated to the front of
 ; string.
 ;
 ; c. Place After String (Append): if from = "a" or "A", then to will
 ; be ignored. In this case replace is concatenated to the end of
 ; string.
 ;
 ; d. Place First in String: if from = "f" or "F", then to will be
 ; ignored. In this case, replace overwrites the first characters of
 ; string, up to replace's length. If the length of replace is >=
 ; string's length, string will be set to replace.
 ;
 ; e. Place Last in String: if from = "l" or "L", then to will be
 ; ignored. In this case, replace overwrites the last characters of
 ; string, up to replace's length. If the length of replace is >=
 ; string's length, string will be set to replace.
 ;
 ;
 ; III. about from & to as output
 ;
 ; setex^%ts will set from & to = the 1st & last character
 ; positions of replace w/in the resulting string. This feature is
 ; important to combining setex^%ts smoothly w/find^%ts to create
 ; find-replace loops that include Find Next operations.
 ;
 ;
 ; IV. about from & to & the b flag
 ;
 ; When replace is empty, it has no specific location, but any ongoing
 ; scans being performed by find^%ts in concert with setex^%ts do,
 ; so from & to are set to the character before the deleted substring.
 ; If the b or B flag is passed, it means the associated find^%ts
 ; calls are performing a backward scan, so from & to will instead be
 ; set to the character position after the deleted substring. In both
 ; cases, from & to are set so a subsequent call to find^%ts will
 ; neither miss nor repeat any of string's characters in its scan.
 ;
 ; If you are doing stand-alone calls to setex^%ts that are not
 ; being coordinated with calls to find^%ts, feel free to omit the b
 ; flag.
 ;
 ; V. about the i & r flags
 ;
 ; To help make scans more efficient, find^%ts saves a lowercase
 ; version of string in string("low","string") to use in subsequent
 ; calls, to avoid having to recalculate lowercase versions of them each
 ; time find^%ts is called.
 ;
 ; Because setex^%ts manipulates string, it supports the same
 ; case-insensitive flag to instruct it to perform the same changes
 ; on string("low","string") that it does on string, to keep the node in
 ; synch with string. If you change string & plan to call find^%ts again
 ; without killing or newing it, pass setex^%ts the r flag, which
 ; will make it refresh string("low","string") to keep it in synch with
 ; your changes.
 ;
 ; If the i flag is not passed, setex^%ts will only update string.
 ; If you are doing stand-alone calls to setex^%ts that are not
 ; being coordinated with calls to find^%ts, feel free to omit the i & r
 ; flags.
 ;
 ; No flags other than b, i, or r are currently supported. All
 ; other values are reserved. Including any other value in flags will
 ; cause the string placement to fail & set from & to = 0.
 ;
 ;@stanza 3 evaluate inputs
 ;
 ; 3.1. handle empty string or replace
 set string=$get(string)
 set replace=$get(replace)
 ;
 ; 3.2. handle absolute, relative, or reserved from
 set from=$get(string("extract","from"))
 set:from="" from=1 ; default to 1st character
 new absolute set absolute=+from=from ; is from a character position?
 new relative set relative='absolute ; is from a code?
 new reserved set reserved=0
 ;
 set:absolute from=from\1 ; absolute from: ignore decimals
 ;
 if relative do  quit:reserved  ; relative from
 . set:from?1a.e from=$$lowcase^%ts(from) ; case-insensitive codes
 . quit:from?1(1"b",1"a",1"f",1"l")  ; place before,after,first,last
 . set reserved=1
 . set string="" ; reject reserved values
 . set string("extract")=0
 . set string("extract","from")=0
 . set string("extract","to")=0
 . quit:from?1(1"b",1"a",1"f",1"l")1(1"+",1"-")1.n  ; reserved codes
 . quit  ; all other string values are reserved
 ;
 ; 3.3. handle absolute, relative, or reserved to
 set to=$get(string("extract","to"))
 set:to="" to=from ; to defaults to from
 ;
 set:relative to=from ; relative to: ignore to
 ;
 if absolute do  quit:reserved  ; absolute to
 . if +to=to set to=to\1 quit  ; legit = ignore decimals
 . set reserved=1 ; can't mix relative addressing with absolute
 . set string=""
 . set string("extract")=0
 . set string("extract","from")=0
 . set string("extract","to")=0
 . quit
 ;
 set:to<from to=from ; to can't be < from
 ;
 ; 3.4. handle flags
 ;
 set flags=$get(flags)
 ;
 if flags?.e1u.e do  ; if flags contains uppercase values
 . set flags=$$lowcase^%ts(flags) ; convert to lowercase
 . quit
 ;
 new badflags set badflags=$translate(flags,"bir")]"" ; reserved flags
 if badflags do  quit
 . set string("extract")=0
 . set string("extract","from")=0
 . set string("extract","to")=0
 . quit
 ;
 ; 3.5. handle set extract for case-insensitive scan
 ;
 new lower set lower=flags["i" ; lowercase string
 if lower do  ; ensure we have a fresh string("low","string")
 . if $data(string("low","string"))#2,flags'["r" quit
 . set string("low","string")=$$lowcase^%ts(string)
 . quit
 ;
 new lowrep set lowrep=replace
 if lower,lowrep?.e1u.e do
 . set lowrep=$$lowcase^%ts(lowrep)
 . quit
 ;
 ;@stanza 4 calculate placement
 ;
 new stringlen set stringlen=$length(string)
 new replacelen set replacelen=$length(replace)
 new prepad set prepad=0 ; # spaces to prefix to make set $extract work
 ;
 if absolute do  ; absolute addressing
 . quit:from>0  ; set $extract can handle 1 or above
 . set prepad=-from+1 ; prepend absolute value plus one spaces
 . set from=1
 . set to=replacelen
 . set:replace="" to=1 ; to place empty string, ensure to > 0
 . quit
 ;
 else  if from="b" do  ; place substring before string (prepend)
 . set prepad=replacelen ; prepend length of replace spaces
 . set from=1
 . set to=replacelen
 . set:replace="" (prepad,to)=1 ; to place empty string, pad & remove
 . quit
 ;
 else  if from="a" do  ; place substring after string (append)
 . set from=stringlen+1
 . set to=stringlen+replacelen
 . quit
 ;
 else  if from="f" do  ; place substring first in string
 . set from=1
 . set to=replacelen
 . set:replace="" (prepad,to)=1 ; to place empty string, pad & remove
 . quit
 ;
 else  if from="l" do  ; place substring last in string
 . set from=stringlen-replacelen+1
 . set:from<1 from=1
 . set to=stringlen
 . set:replace="" (from,to)=stringlen+1 ; to place empty string
 . quit
 ;
 ;@stanza 5 place substring within string
 ;
 if prepad do  ; if placing replace before string
 . new pad set $extract(pad,prepad+1)="" ; create pad of spaces
 . set string=pad_string ; prepend pad
 . quit:'lower  ; quit if not for a case-insensitive scan
 . set string("low","string")=pad_string("low","string")
 . quit
 ;
 do  ; so long as not inserting the empty string
 . set $extract(string,from,to)=replace ; place substring in string
 . set:lower $extract(string("low","string"),from,to)=lowrep
 . set to=from+replacelen-1 ; update to location
 . quit
 ;
 if replace="" do  ; empty-string replace has no position
 . ; it is used to delete characters
 . set (from,to)=from-1 ; so back up to just before the deletion
 . set:from<1 (from,to)=0 ; but not into negatives
 . quit:flags'["b"  ; done if scanning forward
 . set (from,to)=from+1 ; set from & to = after deletion
 . set:from>stringlen (from,to)=0 ; set to end if overflow
 . quit
 ;
 ;@stanza 6 set return from & to values
 ;
 set string("extract")=1
 set string("extract","from")=from
 set string("extract","to")=to
 ;
 ;@stanza 7 termination
 ;
 quit  ; end of setex^%ts
 ;
 ;
 ;
eor ; end of routine %tses
