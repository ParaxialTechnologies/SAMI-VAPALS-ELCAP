%tses ;ven/toad-type string: setex^%ts ;2018-12-14T17:58Z
 ;;1.8;Mash;
 ;
 ; %tses implements MASH String Library ppi setex^%ts, change
 ; (or create or delete) value of positional substring; it is part
 ; of the String Extract sublibrary.
 ; See %tsutes for unit tests for setex^%ts.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Extract library.
 ; See %tsudes for more info about setex^%ts, including examples.
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
 ;@last-updated: 2018-12-14T17:58Z
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
 ;  s or S = case-sensitive set-extract
 ;  call("case")
 ;  call("extract","from")
 ;  call("extract","to")
 ;  call("newval")
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
 ; do setex^%ts(.string,newval)
 ; do setex^%ts(.string,newval,flags)
 ; [reminder: namespace params passed by reference]
 ;@synonyms
 ; se^%ts
 ; setExtract^%ts
 ; place^%ts
 ;@branches-from
 ; setex^%ts
 ;@ppi-called-by: none yet, but just wait an hour or two
 ; setfind^%ts (setfind^%tsfs)
 ; *^%tsutes (tests)
 ;@called-by: none
 ;@calls
 ; $$lowcase^%ts
 ;@input
 ;.string = string to set a new extract value into
 ; newval = new value to set into string extract
 ; flags = characters to control set [optional]
 ;  b or B = set for a backward scan
 ;  i or I = set for a case-insensitive scan
 ;  r or R = refresh lower-case versions of string & newval
 ;@throughput
 ;.string("extract","from") = pos of 1st char of extract
 ;.string("extract","to") = pos of last char of extract
 ; if passed as input, they id position of old extract value
 ; when returned as output, they id position of new value
 ; if new value is not same length as old value, from & to change
 ;.string("low","string") = lowercase string value [if i flag]
 ;@output
 ;.string("extract") = 1 if the set-extract succeeded; else 0.
 ;@examples: see %tsudes
 ;
 ;@tests [tbd]: do ^%tsut (in %tsutes, see examples)
 ;
 ;@stanza 2 detailed description
 ;
 ; setex^%ts is an enhanced version of the Mumps set $extract.
 ; It sets an extract into a string.
 ;
 ; An extract is a substring of a string, where that substring is
 ; identified by start and end character positions. For example,
 ; in the string "one pebble" there are many extracts. The extract
 ; from positions 1 to 2 is "on"; from 1 to 5 is "one p"; from 3 to
 ; 6 is "e pe". In the explanations that follow, we can abbreviate
 ; them by referring to as extract 1:2, extract 1:5, or extract 3:6.
 ;
 ; setex^%ts sets the extract equal to a new value, which replaces
 ; the extract's old value. For example, if we set extract 2:3 of
 ; "one pebble" = "ld" we produce "old pebble"; if instead we set
 ; extract 7:8 = "op" we produce "one people".
 ;
 ; setex^%ts expands the extract addressing system beyond what the
 ; Mumps set $extract provides and adds additional options, to create
 ; a more general-purpose tool.
 ;
 ; (Note: a future version of setex^%ts will support a new call-
 ; message system of passing parameters. For now, the embryonic form
 ; is the behavior of the string array, which find^%ts &
 ; setextract%ts manage.)
 ;
 ; In the discussion that follows, string("extract","from") will be
 ; referred to as from, string("extract","to") as to, and
 ; string("extract") as success.
 ;
 ;
 ; I. about string & newval
 ;
 ; If either string or newval is passed undefined or = the empty
 ; string (""), it is said to be empty, because it contains no
 ; characters & no positions. When setex^%ts sets a value to
 ; empty, it sets it = the empty string. Placing a substring into a
 ; string will never leave that string undefined; canonically, even
 ; the minimal case will leave string empty instead of undefined.
 ; Although newval need only be passed by value, if passed by
 ; reference undefined the same holds true; it will never be left
 ; undefined but will be set to empty.
 ;
 ; Together, string & newval define most or all of the contents of
 ; the set-extract operation, as well as what kind of set occurs:
 ;
 ; 1. Overwrite Extract: if neither string nor newval is empty,
 ; string will be altered to overwrite the characters at positions
 ; from through to (see below) w/substring newval.
 ;
 ; 2. Create Extract: if string is empty, setex^%ts will create
 ; a string of spaces & place substring newval w/in that.
 ;
 ; 3. Delete Extract: if newval is empty, the overwritten characters
 ; in string are removed.
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
 ; (any decimal parts will be ignored). If the resulting to < from,
 ; setex^%ts does not change string or any other throughput or output,
 ; analogous to how Mumps set $extract handles this case, except that
 ; success = 1 (a successful no-op).
 ;
 ; ii. Relative Addressing: from may be passed as one of four codes:
 ; b, a, f, l (or uppercase equivalents), designating the following
 ; four special character positions and uses:
 ;  b = before, character position 0, to prepend
 ;  a = after, character position string-length + 1, to append
 ;  f = first, character position 1, to overwrite string beginning
 ;  l = last, character position string-length, to overwrite string end
 ; These special codes let us avoid having to hardcode math involving
 ; string or substring lengths, let us write code that more clearly
 ; states its intent, and let us use just one call, setex^%ts, instead
 ; of having to create a whole suite of very similar calls to perform
 ; these related operations.
 ;
 ; When from uses relative addressing, the use of to is reserved; to
 ; must not be passed, because the special from value translates to
 ; specific absolute addresses for from & to, depending on the relative
 ; address used. Passing to results in a failed call (see VI below).
 ;
 ; In addition, other relative code values are reserved for future
 ; versions of setex^%ts, such as:
 ; a. B-1, B-2, etc., b-1, b-2, etc.
 ; b. A+1, A+2, etc., a+1, a+2, etc.
 ; c. F+1, F+2, etc., f+1, f+2, etc.
 ; d. L-1, L-2, etc., l-1, l-2, etc.
 ; e. all other string values.
 ; Passing from = a reserved value results in a failed call (see VI
 ; below).
 ;
 ; iii. Mixed Addressing: There are challenges with mixing absolute
 ; and relative addressing (e.g., from=0 and to="b"), because they are
 ; based on two different number lines. Absolute addressing assumes a
 ; number line infinite in both directions from a fixed origin; any
 ; conceivable integer, positive, negative, or 0, represents a valid
 ; address (character position). Relative addressing assumes a number
 ; line that is only infinite in one direction from its fixed origin,
 ; relative to one of the four special character positions. Although
 ; there are many useful ways to combine absolute and relative
 ; addressing, there are also combinations that cannot be valid. A
 ; future version of setex^%ts will work out these & support these
 ; valid combinations. For now, passing from & to with mixed addressing
 ; results in a failed call (see VI below).
 ;
 ; Together, from & to define the extract in string to set to newval;
 ; they define which characters are overwritten or created by the
 ; set-extract operation. There are six main categories of sets,
 ; categorized by from's value:
 ;
 ; a. Set Within String: if from & to are >= 1 and <= string's length,
 ; you are setting an extract within the existing string. In this case,
 ; newval replaces the old value of the extract, which may or may not
 ; change string's length. If from = 1 and to = string's length, you
 ; completely replace string.
 ;
 ; b. Set to Extend String: if from or to is < 1 or > string's length,
 ; the extract to change reaches beyond one or both ends of string, so
 ; you extend it. You might prepend or append to string, which may or
 ; may not overlap with one or both ends of the string. If it overlaps
 ; both ends of string, you completely replace string.
 ;
 ; c. Set Before String (Prepend): if from = "b" or "B", newval is
 ; concatenated to the front of string.
 ;
 ; d. Set After String (Append): if from = "a" or "A", newval is
 ; concatenated to the end of string.
 ;
 ; e. Set First in String: if from = "f" or "F", newval overwrites
 ; the first characters of string, up to newval's length. If newval's
 ; length >= string's length, string is set = newval.
 ;
 ; f. Set Last in String: if from = "l" or "L", newval overwrites the
 ; last characters of string, up to newval's length. If newval's
 ; length >= string's length, string is set = newval.
 ;
 ;
 ; III. about from & to as output
 ;
 ; setex^%ts will set from & to = the 1st & last character
 ; positions of newval w/in the resulting string. This feature is
 ; important to combining setex^%ts smoothly w/find^%ts to create
 ; find-replace loops that include Find Next operations.
 ;
 ;
 ; IV. about from & to & the b flag
 ;
 ; When newval is empty, it has no specific location, but any ongoing
 ; scans being performed by find^%ts in concert with setex^%ts do,
 ; so from & to are set to the character before the deleted extract.
 ; If the b or B flag is passed, it means the associated find^%ts
 ; calls are performing a backward scan, so from & to will instead be
 ; set to the character position after the deleted extract. In both
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
 ; synch with string. If between calls to the Mumps String Library you
 ; change string & plan to call find^%ts again without killing or newing
 ; it, pass setex^%ts the r flag, to refresh string("low","string") to
 ; keep it in synch with your changes.
 ;
 ; If the i flag is not passed, setex^%ts will only update string.
 ; If you are doing stand-alone calls to setex^%ts that are not
 ; being coordinated with calls to find^%ts, feel free to omit the i & r
 ; flags.
 ;
 ; All other values of flags are reserved. Passing flags = any other value
 ; results in a failed call (see VI below).
 ;
 ; VI. failed calls
 ;
 ; A failed call to setex^%ts (see cases above) sets success & from
 ; & to = 0 and string="". Failed calls usually result from the use
 ; of reserved values, which future versions of setex^%ts might add
 ; to provide new features.
 ;
 ;@stanza 3 evaluate inputs
 ;
 ; 3.1. handle string or newval (empty)
 set string=$get(string)
 set newval=$get(newval)
 ;
 ; 3.2. handle from (absolute, relative, or reserved)
 new from set from=$get(string("extract","from"))
 set:from="" from=1 ; default to 1st character
 new absolute set absolute=+from=from ; is from a character position?
 new relative set relative='absolute ; is from an address code?
 new reserved set reserved=0 ; is a reserved value, so call should fail?
 ;
 set:absolute from=from\1 ; absolute from: coerce to integer
 ;
 if relative do  quit:reserved  ; relative from
 . set:from?1a.e from=$$lowcase^%ts(from) ; case-insensitive codes
 . quit:from?1(1"b",1"a",1"f",1"l")  ; place before,after,first,last
 . do fail ; don't use reserved address codes
 . quit:from?1(1"b",1"a",1"f",1"l")1(1"+",1"-")1.n  ; reserved codes
 . quit  ; all other string values are reserved
 ;
 ; 3.3. handle to (absolute, relative, or reserved)
 new to set to=$get(string("extract","to"))
 ;
 if absolute do  quit:reserved  ; absolute to
 . set:to="" to=from ; to defaults to from
 . if +to=to set to=to\1 quit  ; legit = coerce to integer
 . do fail ; don't mix relative addressing with absolute
 . quit
 ;
 new noop set noop=0
 if absolute do  quit:noop  ; absolute to
 . quit:to'<from  ; is to in proper range
 . set noop=1 ; if to<from, setex^%ts makes no change
 . set string("extract")=1
 . quit
 ;
 if relative do  quit:reserved
 . quit:to=""
 . do fail ; don't pass to if from is relative
 . quit
 ;
 ; 3.4. handle flags
 ;
 set flags=$get(flags)
 ;
 do  quit:reserved
 . set:flags?.e1u.e flags=$$lowcase^%ts(flags) ; case-insensitive flags
 . quit:$translate(flags,"bir")="" ; supported flags
 . do fail ; don't use reserved flags
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
 new lownew set lownew=newval
 if lower,lownew?.e1u.e do
 . set lownew=$$lowcase^%ts(lownew)
 . quit
 ;
 ;@stanza 4 calculate placement
 ;
 new stringlen set stringlen=$length(string)
 new newvalen set newvalen=$length(newval)
 new prepad set prepad=0 ; # spaces to prefix to make set $extract work
 ;
 if absolute do  ; absolute addressing
 . quit:from>0  ; set $extract can handle 1 or above
 . set prepad=-from+1 ; prepend absolute value plus one space
 . set from=1
 . set to=newvalen
 . set:newval="" to=1 ; to place empty string, ensure to > 0
 . quit
 ;
 else  if from="b" do  ; place newval before string (prepend)
 . set prepad=newvalen ; prepend newval's length in spaces
 . set from=1
 . set to=newvalen
 . set:newval="" (prepad,to)=1 ; to place empty string, pad & remove
 . quit
 ;
 else  if from="a" do  ; place newval after string (append)
 . set from=stringlen+1
 . set to=stringlen+newvalen
 . quit
 ;
 else  if from="f" do  ; place newval first in string
 . set from=1
 . set to=newvalen
 . set:newval="" (prepad,to)=1 ; to place empty string, pad & remove
 . quit
 ;
 else  if from="l" do  ; place newval last in string
 . set from=stringlen-newvalen+1
 . set:from<1 from=1
 . set to=stringlen
 . set:newval="" (from,to)=stringlen+1 ; to place empty string
 . quit
 ;
 ;@stanza 5 place newval within string
 ;
 if prepad do  ; if placing newval before string
 . new pad set $extract(pad,prepad+1)="" ; create pad of spaces
 . set string=pad_string ; prepend pad
 . set stringlen=stringlen+prepad ; update string length
 . quit:'lower  ; quit if not for a case-insensitive scan
 . set string("low","string")=pad_string("low","string")
 . quit
 ;
 do  ; place it
 . set $extract(string,from,to)=newval ; place newval in string
 . set:lower $extract(string("low","string"),from,to)=lownew
 . set to=from+newvalen-1 ; update to location
 . set stringlen=$length(string) ; update string length
 . quit
 ;
 if newval="" do  ; empty newval has no position
 . ; it is used to delete extract
 . set (from,to)=from-1 ; so back up to just before the deletion
 . set:from<1 (from,to)=0 ; but not into negatives
 . quit:flags'["b"  ; done if scanning forward
 . set (from,to)=from+1 ; else, set from & to = after deletion
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
fail ; set return values for failed call
 ;
 set reserved=1
 set string=""
 set string("extract")=0
 set string("extract","from")=0
 set string("extract","to")=0 
 ;
 quit  ; end of fail
 ;
 ;
 ;
eor ; end of routine %tses
