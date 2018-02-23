%tses ;ven/toad-type string: code for setextract^%ts ;2018-02-23T23:03Z
 ;;1.8;Mash;
 ;
 ; %tses implements MASH String Library API $$setextract^%ts, change
 ; (or create) value of positional substring; it is part of the
 ; String Extract sublibrary.
 ; See %tsutes for unit tests for $$setextract^%ts.
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
 ;@last-updated: 2018-02-23T23:03Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; apply standard string-length protection consistently
 ; make stripped down function version
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
 ;@ppi-code setextract^%ts
setextract ; change value of positional substring
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;procedure;clean;silent;sac;NO tests
 ;@signature
 ; setextract^%ts(.string,replace)
 ; setextract^%ts(.string,replace,.from)
 ; setextract^%ts(.string,replace,.from,.to)
 ;@branches-from
 ; setextract^%ts
 ;@ppi-called-by: none yet, but just wait an hour or two
 ;@called-by: none
 ;@calls
 ; $$lowcase^%ts
 ;@throughput
 ;.string = string to set an extract into
 ;.string("low") = lowercase version of string [optional]
 ;[.]from = position w/in string of 1st char to overwrite
 ;[.]to = position w/in string of last char to overwrite [optional]
 ;@input
 ; replace = replacement substring to place into string
 ;@output
 ;@examples
 ;
 ; group 1: two-argument (default addressing)
 ;
 ;  new string,replace
 ;  do setextract^%ts(.string,.replace)
 ; produces string="",replace=""
 ;
 ;  new string
 ;  do setextract^%ts(.string,"")
 ; produces string=""
 ;
 ;  new string set string=""
 ;  new replace
 ;  do setextract^%ts(.string,.replace)
 ; produces string="",replace=""
 ;
 ;  new string set string=""
 ;  do setextract^%ts(.string,"")
 ; produces string=""
 ;
 ;  new string set string=""
 ;  do setextract^%ts(.string,"*")
 ; produces string="*"
 ;
 ;  new string set string=""
 ;  do setextract^%ts(.string,"Sparrowhawk")
 ; produces string="Sparrowhawk"
 ;
 ;  new string set string="Never the way he can follow grows narrower"
 ;  do setextract^%ts(.string,"")
 ; produces string="ever the way he can follow grows narrower"
 ;
 ;  new string set string="In the empty sky."
 ;  do setextract^%ts(.string,"o")
 ; produces string="on the empty sky."
 ;
 ;  new string set string="O the hawk's flight"
 ;  do setextract^%ts(.string,"bright")
 ; produces string="bright the hawk's flight"
 ;
 ; group 2: three-argument, absolute addressing w/in string
 ;
 ;  new string set string="She lay thus dark and dumb"
 ;  do setextract^%ts(.string,"",1)
 ; produces string="he lay thus dark and dumb"
 ;
 ;  new string set string="O Wizard of Earthsea"
 ;  do setextract^%ts(.string,"A",1)
 ; produces string="A Wizard of Earthsea"
 ;
 ;  new string set string="I hear, one must be silent."
 ;  do setextract^%ts(.string,"To",1)
 ; produces string="To hear, one must be silent."
 ;
 ;  new string set string="until at lEast he chooses nothing"
 ;  do setextract^%ts(.string,"",11)
 ; produces string="until at last he chooses nothing"
 ;
 ;  new string set string="To light a Sandle is to cast a shadow."
 ;  do setextract^%ts(.string,"c",12)
 ; produces string="To light a candle is to cast a shadow."
 ;
 ;  new string set string="does onlY what he must do"
 ;  do setextract^%ts(.string,"y and wholly",9)
 ; produces string="does only and wholly what he must do"
 ;
 ;  new string set string="For a word to be spoken there must be silenceS"
 ;  do setextract^%ts(.string,"",$length(string))
 ; produces string="For a word to be spoken there must be silence"
 ;
 ;  new string set string="there must be darkness to see the starT"
 ;  do setextract^%ts(.string,"s",$length(string))
 ; produces string="there must be darkness to see the stars"
 ;
 ;  new string set string="only men do"
 ;  do setextract^%ts(.string,"o evil",$length(string))
 ; produces string="only men do evil"
 ;
 ; group 3: three-argument, absolute addressing before string
 ;
 ;  new string set string="She wept in pain, because she was free"
 ;  do setextract^%ts(.string,"",0)
 ; produces string="She wept in pain, because she was free"
 ;
 ;  new string set string="eight of liberty"
 ;  do setextract^%ts(.string,"w",0)
 ; produces string="weight of liberty"
 ;
 ;  new string set string="Wizard of Earthsea"
 ;  do setextract^%ts(.string,"A",-1)
 ; produces string="A Wizard of Earthsea"
 ;
 ;  new string set string="Tombs of Atuan"
 ;  do setextract^%ts(.string,"The",-3)
 ; produces string="The Tombs of Atuan"
 ;
 ;  new string set string="Farthest Shore"
 ;  do setextract^%ts(.string,"The",-5)
 ; produces string="The   Farthest Shore"
 ;
 ;  new string set string="Tehanu"
 ;  do setextract^%ts(.string,"",-4)
 ; produces string="    Tehanu"
 ;
 ;  new string set string="Another Wind"
 ;  do setextract^%ts(.string,"The O",-1)
 ; produces string="The Other Wind"
 ;
 ; group 4: three-argument, absolute addressing after string
 ;
 ;  new string set string="muddle, mystery, mumbling"
 ;  do setextract^%ts(.string,"",$length(string)+1)
 ; produces string="muddle, mystery, mumbling"
 ;
 ;  new string set string="There's no way to use power for good."
 ;  do setextract^%ts(.string,"",$length(string)+2)
 ; produces string="There's no way to use power for good. "
 ;
 ;  new string set string="All times are changing times"
 ;  do setextract^%ts(.string,"",$length(string)+4)
 ; produces string="All times are changing times   "
 ;
 ;  new string set string="Tales"
 ;  do setextract^%ts(.string," from Earthsea",$length(string)+1)
 ; produces string="Tales from Earthsea"
 ;
 ;  new string set string="to make love"
 ;  do setextract^%ts(.string,"is to unmake power",$length(string)+2)
 ; produces string="to make love is to unmake power"
 ;
 ;  new string set string="The solution lies in secret"
 ;  do setextract^%ts(.string,"cy",$length(string))
 ; produces string="The solution lies in secrecy"
 ;
 ; group 5: three-argument, relative addressing
 ;
 ;  new string set string="The road goes upward towards the light"
 ;  do setextract^%ts(.string,"","b")
 ; produces string="The road goes upward towards the light"
 ;
 ;  new string set string=" dark hand had let go its lifelong hold"
 ;  do setextract^%ts(.string,"A","b")
 ; produces string="A dark hand had let go its lifelong hold"
 ;
 ;  new string set string="a gift given, but a choice made"
 ;  do setextract^%ts(.string,"It is not ","b")
 ; produces string="It is not a gift given, but a choice made"
 ;
 ;  new string set string="courage breaks them."
 ;  do setextract^%ts(.string,"Injustice makes the rules, and ","B")
 ; produces string="Injustice makes the rules, and courage breaks them."
 ;
 ;  new string set string="when you eat illusions you end up hungrier"
 ;  do setextract^%ts(.string,"","a")
 ; produces string="when you eat illusions you end up hungrier"
 ;
 ;  new string set string="Manipulated, one manipulates others"
 ;  do setextract^%ts(.string,".","a")
 ; produces string="Manipulated, one manipulates others."
 ;
 ;  new string set string="Statesmen remember things"
 ;  do setextract^%ts(.string," selectively","a")
 ; produces string="Statesmen remember things selectively"
 ;
 ;  new string set string="I can breathe back the breath"
 ;  do setextract^%ts(.string," that made me live","A")
 ; produces string="I can breathe back the breath that made me live"
 ;
 ;  new string set string="Ignorant power is a bane!"
 ;  do setextract^%ts(.string,"","f")
 ; produces string="Ignorant power is a bane!"
 ;
 ;  new string set string="U can give them back to the world"
 ;  do setextract^%ts(.string,"I","f")
 ; produces string="I can give them back to the world"
 ;
 ;  new string set string="MANHOOD speaks evenly, in a quiet voice"
 ;  do setextract^%ts(.string,"Despair","f")
 ; produces string="Despair speaks evenly, in a quiet voice"
 ;
 ;  new string set string="AUTHORITY makes the rules"
 ;  do setextract^%ts(.string,"Injustice","F")
 ; produces string="Injustice makes the rules"
 ;
 ;  new string set string="To which Silence of course made no reply"
 ;  do setextract^%ts(.string,"","l")
 ; produces string="To which Silence of course made no reply"
 ;
 ;  new string set string="Greed puts out the suM"
 ;  do setextract^%ts(.string,"n","l")
 ; produces string="Greed puts out the sun"
 ;
 ;  new string set string="The world's vast and ANCIENT"
 ;  do setextract^%ts(.string,"strange","l")
 ; produces string="The world’s vast and strange"
 ;
 ;  new string set string="To refuse death is to refuse DOOM"
 ;  do setextract^%ts(.string,"life","L")
 ; produces string="To refuse death is to refuse life"
 ;
 ; group 6: four-argument, absolute addressing w/in string [tbd]
 ;
 ;
 ; group 7: four-argument, absolute addressing before string [tbd]
 ;
 ;
 ; group 8: four-argument, absolute addressing after string [tbd]
 ;
 ;
 ; group 9: four-argument, relative addressing [tbd]
 ;
 ; 
 ; group 10: three- & four-argument, from or to by reference [tbd]
 ;
 ;  new string set string="the terrible pain"
 ;  new to
 ;  do setextract^%ts(.string," boredom of ",13,.to)
 ; produces string="the terrible boredom of pain",to=24
 ;
 ;  new string set string="admit the ATTRACTION of evil"
 ;  new from set from=11
 ;  new to set to=20
 ;  do setextract^%ts(.string,"banality",.from,.to)
 ; produces string="admit the banality of evil",from=11,to=18
 ;
 ;  new string set string="the victory they celebrate is WAR WON WELL"
 ;  new from set from="L"
 ;  new to
 ;  do setextract^%ts(.string,"that of life",.from,.to)
 ; produces string="the victory they celebrate is that of life"
 ;  from=31,to=42
 ; 
 ; group 11: three- & four-argument, reserved from & to values [tbd]
 ;
 ;
 ; group 12: string("low") inclusion [tbd]
 ;
 ;
 ;@tests [tbd]
 ;
 ;@stanza 2 detailed description
 ;
 ; setextract^%ts is an enhanced version of the Mumps set $extract.
 ; It will place characters w/in a string at the specified position.
 ;
 ; I. about string & replace
 ;
 ; If either string or replace is passed undefined or = the empty
 ; string (""), it is said to be empty, because it contains no
 ; characters & no positions. When setextract^%ts sets a value to
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
 ; 2. Create Substring: if string is empty, setextract^%ts will create
 ; a string of spaces & place substring replace w/in that.
 ;
 ; 3. Delete Substring: if replace is empty, then the overwritten
 ; characters in the string are removed but not replaced.
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
 ; setextract^%ts:
 ; a. B-1, B-2, etc., b-1, b-2, etc.
 ; b. A+1, A+2, etc., a+1, a+2, etc.
 ; c. F+1, F+2, etc., f+1, f+2, etc.
 ; d. L-1, L-2, etc., l-1, l-2, etc.
 ; e. all other string values.
 ; For now, if any of these values is used for from, setextract^%ts will
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
 ; III. about from & to as output
 ;
 ; If from or to is passed by reference, setextract^%ts will set them
 ; = the 1st & last character positions of replace w/in the resulting
 ; string. This feature is important to combining setextract^%ts
 ; smoothly w/find^%ts to create find-replace loops that include Find
 ; Next operations. When replace is empty, it has no specific
 ; location, so from & to are set = 0.
 ;
 ; IV. about string("low")
 ;
 ; If string("low") is passed in, it must equal a lowercase version of
 ; string; this requirement is not checked, but failure to do so will be
 ; a contract violation, and the results will be undefined and subject
 ; to change in future versions. If passed in, then it will be changed
 ; in parallel with the changes to string, to keep them in sync. This
 ; feature is important to combining setextract^%ts smoothly w/find^%ts
 ; to create case-insensitive find-replace loops that include Find Next
 ; operations.
 ;
 ;@stanza 3 evaluate inputs
 ;
 ; 3.1. handle empty string or replace
 set string=$get(string)
 set replace=$get(replace)
 new lower set lower=$data(string("low"))#2 ; lowercase string
 new lowrep set lowrep=replace
 if lower,lowrep?.e1u.e do
 . set lowrep=$$lowcase^%ts(lowrep)
 . quit
 ;
 ; 3.2. handle absolute, relative, or reserved from
 set from=$get(from)
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
 . quit:from?1(1"b",1"a",1"f",1"l")1(1"+",1"-")1.n  ; reserved codes
 . quit  ; all other string values are reserved
 ;
 ; 3.3. handle absolute, relative, or reserved to
 set to=$get(to)
 set:to="" to=from ; to defaults to from
 ;
 set:relative to=from ; relative to: ignore to
 ;
 if absolute do  quit:reserved  ; absolute to
 . if +to=to set to=to\1 quit  ; legit = ignore decimals
 . set reserved=1 ; can't mix relative addressing with absolute
 . set string=""
 . quit
 ;
 set:to<from to=from ; to can't be < from
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
 . quit:'lower
 . set string("low")=pad_string("low") ; case-insensitive
 . quit
 ;
 do  ; so long as not inserting the empty string
 . set $extract(string,from,to)=replace ; place substring in string
 . set to=from+replacelen-1 ; update to location
 . quit:'lower
 . set $extract(string("low"),from,to)=lowrep ; case-insensitive
 . quit
 ;
 if replace="" do  ; empty-string replace has no position
 . ; it is used to delete characters
 . set (from,to)=from-1 ; so back up to just before the deletion
 . set:from<1 (from,to)=0 ; but not into negatives
 . quit
 ;
 ;@stanza 6 termination
 ;
 quit  ; end of ppi setextract^%ts
 ;
 ;
 ;
eor ; end of routine %tses
