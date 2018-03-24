%tsef ;ven/toad-type string: findex^%ts ;2018-03-20T19:02Z
 ;;1.8;Mash;
 ;
 ; %tsef implements MASH String Library ppi findex^%ts, find substring;
 ; it is part of the String Extract Library.
 ; See %tsutef for unit tests for findex^%ts.
 ; Compare %tses to see how setex^%ts works with findex^%ts
 ; See %tsud for an introduction to the String Library, including an
 ; intro to the String Extract Library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsef contains no public entry points.
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
 ;@last-updated: 2018-03-20T19:02Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@to-do
 ; add ability to scan backward
 ;  f or F = scan forward
 ; add ability to limit scan to w/in certain characters
 ;  scanfrom & scanto
 ; add ability to call by passing object
 ;  s or S = case-sensitive scan
 ;  call("case")
 ;  call("extract","from")
 ;  call("extract","to")
 ;  call("find")
 ;  call("find","low")
 ;  call("scan","from")
 ;  call("scan","to")
 ;  call("string")
 ;  call("string","low")
 ;  call("way")
 ; add feature to load object w/parameters for shorter calls
 ;  direction => call("direction"), 1 or -1
 ;  find=-1,to=-1 => call("way"), default to 1
 ;  find => call("find")
 ;  from => call("find","from")
 ;  to => call("find","to")
 ; apply standard string-length protection consistently
 ; create findm/findmsg to preload call-message array
 ;
 ; description of future call-message system
 ;
 ; The caller passes in a call message describing the scan to be
 ; performed. This can either be entirely passed as array nodes under
 ; the first parameter, or the caller may set other parameters in the
 ; list to ask findex^%ts to initialize the call message for the caller
 ; based on those values. Where the call message and listed parameters
 ; disagree, the parameters will override the call message, giving
 ; callers a simple mechanism for revising the call message on
 ; subsequent calls to findex^%ts.
 ;
 ; This new call-message system gives callers nuanced control over how
 ; findex^%ts performs the scan, via the call message, for complex scans,
 ; but it also gives one-time callers who want simple scans an easy-to-
 ; use multi-parameter format that can request most typical scans. Some
 ; more mature version of this system will spread to the rest of Mash.
 ;
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
 ;@ppi-code findex^%ts
findex ; find position of substring
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;procedure;clean;silent;sac;NO tests
 ;@signatures
 ; do findex^%ts(.string)
 ; do findex^%ts(.string,find)
 ; do findex^%ts(.string,find,flags)
 ;@synonyms
 ; fe^%ts
 ; findExtract^%ts
 ; find^%ts
 ;@branches-from
 ; findex^%ts
 ;@ppi-called-by: none yet, but just wait an hour or two
 ;@called-by: none
 ;@calls: $$lowcase^%ts
 ;@input
 ;.string = string to search for substring
 ; find = substring to find in string
 ; flags = characters to control scan [optional]
 ;  b or B = scan backward
 ;  i or I = case-insensitive scan
 ;  r or R = refresh lower-case versions of string & find
 ;@throughput
 ;.string("extract","from") = pos of 1st char of substring found
 ;.string("extract","to") = pos of last char of substring found
 ;.string("low","find") = lowercase find value [if i flag]
 ;.string("low","string") = lowercase string value [if i flag]
 ;
 ;@examples
 ;
 ; group 1: Find First & Find Next
 ;
 ;  new string set string="totototo"
 ;  do findex^%ts(.string,"Kansas")
 ; produces
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findex^%ts(.string,"toto")
 ; produces
 ;  string("extract","from")=1
 ;  string("extract","to")=4
 ;
 ; followed by
 ;  do findex^%ts(.string,"toto")
 ; produces
 ;  string("extract","from")=5
 ;  string("extract","to")=8
 ;
 ; followed by
 ;  do findex^%ts(.string,"toto")
 ; produces
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=1
 ;  set string("extract","to")=2
 ;  do findex^%ts(.string,"toto")
 ; produces
 ;  string("extract","from")=3
 ;  string("extract","to")=6
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=6
 ;  set string("extract","to")=7
 ;  do findex^%ts(.string,"toto")
 ; produces
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; group 2: Find Last & Find Previous
 ;
 ;  new string set string="totototo"
 ;  do findex^%ts(.string,"Kansas","b")
 ; produces
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  do findex^%ts(.string,"toto","b")
 ; produces
 ;  string("extract","from")=5
 ;  string("extract","to")=8
 ;
 ; followed by
 ;  do findex^%ts(.string,"toto","b")
 ; produces
 ;  string("extract","from")=1
 ;  string("extract","to")=4
 ;
 ; followed by
 ;  do findex^%ts(.string,"toto","b")
 ; produces
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=7
 ;  set string("extract","to")=8
 ;  do findex^%ts(.string,"toto","b")
 ; produces
 ;  string("extract","from")=3
 ;  string("extract","to")=6
 ;
 ;  new string set string="totototo"
 ;  set string("extract","from")=1
 ;  set string("extract","to")=2
 ;  do findex^%ts(.string,"toto","b")
 ; produces
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; group 3: Find Case-Insensitive
 ;
 ;  new string set string="totototo"
 ;  do findex^%ts(.string,"Toto")
 ; produces
 ;  string("extract","from")=0
 ;  string("extract","to")=0
 ;
 ; followed by
 ;  do findex^%ts(.string,"Toto","i")
 ; produces
 ;  string("extract","from")=1
 ;  string("extract","to")=4
 ;
 ; followed by
 ;  do findex^%ts(.string,"Toto","i")
 ; produces
 ;  string("extract","from")=5
 ;  string("extract","to")=8
 ;
 ;  
 ;
 ; group 4: Boundary Cases
 ;
 ;
 ;@tests [tbd]
 ;
 ;
 ;@stanza 2 detailed description
 ;
 ;
 ; findex^%ts is an enhanced version of the Mumps $find function. It
 ; will find the position of a substring (find) w/in a string.
 ;
 ; (Note: a future findex^%ts will support a new call-message
 ; system of passing parameters. For now, the embryonic form is the
 ; behavior of the string array, which findex^%ts & setex^%ts manage.)
 ;
 ; In the discussion that follows, string("extract","from") will be
 ; referred to as from, & string("extract","to") as to.
 ;
 ;
 ; I. about string & find
 ;
 ; So long as string and find are both non-empty, findex^%ts will scan
 ; string looking for find.
 ;
 ; If either string or find is passed undefined or = the empty
 ; string (""), it is said to be empty, because it contains no
 ; characters & no positions. If find is empty, it is contained in
 ; every string but at no position, so it cannot be found. If string
 ; is empty, it contains no string but the empty string, and that at
 ; no position, so no string can be found in it. If string or find
 ; is empty, findex^%ts will set from & to = 0 to indicate a failed
 ; scan.
 ;
 ; string must be passed by reference = the string to scan; if it is
 ; passed by value, findex^%ts is a no-op, because it returns its
 ; results as nodes in from & to in the string array (see below). If
 ; string is passed undefined, findex^%ts will set it = the empty
 ; string ("").
 ;
 ; find is passed by value. It = the substring to look for in string.
 ; If find is passed by reference undefined, findex^%ts will set it =
 ; the empty string ("").
 ;
 ;
 ; II. Find First: two-argument findex^%ts
 ;
 ; If from & to are not set, then two-argument findex^%ts finds the 1st
 ; occurrence of find within string. It sets from = the position within
 ; string of the 1st character of the found substring & to = the
 ; position of the last character of the found substring. Together they
 ; precisely identify where the scan found the substring.
 ;
 ; If the scan does not find the substring in string, then from & to
 ; are set = 0.
 ;
 ; The other Extract calls in the String Library, such as setex^%ts are
 ; designed to update these same two nodes if they use them to alter
 ; the string, so that a subsequent call to findex^%ts will resume at
 ; the correct location (see below).
 ;
 ;
 ; III. Find Next: two-argument findex^%ts
 ;
 ; After a call to findex^%ts, if its scan found the substring & set
 ; from & to, another call to findex^%ts with the string array & find
 ; parameter set just the way findex^%ts left them will locate the next
 ; instance of substring & update from & to = the new location or set
 ; them = 0 if there was only the one instance of substring to be
 ; found.
 ;
 ; Since from & to act like inputs as well as outputs, if you want to
 ; scan for a different substring w/in the same string from the
 ; beginning, you need to kill string("extract") to clear the prior
 ; results.
 ;
 ; Conversely, you can set from & to manually before calling findex^%ts
 ; to control where the scan begins. The scan will begin (or resume)
 ; at character position to+1.
 ;
 ; from & to represent string's character positions as a ring that
 ; begins and ends at position 0; other than 0, only positions 1
 ; through the length of string are possible. Decimals are ignored,
 ; just truncated. all negative values are treated as 0. So are
 ; all values greater than the length of string. If from & to are
 ; passed = strings isntead of numbers, they will be coerced into
 ; numbers following the Mumps rules, so if from = "12 cats" it will
 ; be treated as 12, but "cats 12" will be treated as 0. If they
 ; are passed empty (undefined or = the empty string), they will be
 ; set = 0, meaning start at the beginning (see Find First above).
 ;
 ; (Note: a future version of findex^%ts will introduce new parameters
 ; for controlling where a scan begins & ends, though if they are not
 ; passed, the current behavior will continue to work.)
 ;
 ; The Find Next capability need not be used to search for the same
 ; find value each time; scanning a structured string might involve
 ; searching for one find value & then another. There is no requirement
 ; that the size of the window between from & to match the length of
 ; find on input.
 ;
 ;
 ; IV. Find Last: two-argument findex^%ts + b flag
 ;
 ; If we set up a Find First call to findex^%ts but also include a b or
 ; B in the flags parameter, it will scan backward instead of forward &
 ; so find the last instance of substring within string instead of the
 ; first. As usual, if substring is not found, from & to will be set
 ; = 0.
 ;
 ; If the b flag is not passed, findex^%ts defaults to scanning forward.
 ;
 ;
 ; V. Find Previous: two-argument findex^%ts + b flag
 ;
 ; Likewise, if we set up a Find Next call but include b or B in flags,
 ; findex^%ts will continue its backward scan from where it left off &
 ; find the previous instance of substring in string, setting its output
 ; nodes to the result.
 ;
 ; When the b flag is passed, Find Previous scans begin at from-1 &
 ; scans earlier positions (instead of beginning at to+1 & scanning
 ; later positions). If from = 0, as per the rules of the find number
 ; ring, from-1 is treated as the last character position in string.
 ; Otherwise, the same interpretation rules for from & to apply as
 ; scanning forward.
 ;
 ;
 ; VI. Case-insensitive Find: two-argument findex^%ts + i flag
 ;
 ; If flags includes i or I, the scan will be case-insensitive, so for
 ; example substring "Toto" would be found in string "totototo".
 ;
 ; To help make scans more efficient, findex^%ts will save a lowercase
 ; version of string in string("low","string") & of find in
 ; string("low","find") to use in subsequent calls, to avoid having to
 ; recalculate lowercase versions of them each time findex^%ts is called.
 ;
 ; Other Extract calls in the String Library that manipulate string &
 ; support the case-insensitive flag will perform the same changes on
 ; string("low") to keeps nodes in synch with string. If you change
 ; string or find & plan to call findex^%ts again without killing or
 ; newing them, pass the r flag, which will make findex^%ts refresh the
 ; string("low") nodes to keep them in synch with your changes.
 ;
 ; If the i flag is not passed, findex^%ts defaults to a case-sensitive
 ; scan. No flags other than b, i, or r are currently supported. All
 ; other values are reserved. Including any other value in flags will
 ; cause the scan to fail & set from & to = 0.
 ;
 ;
 ;@stanza 3 handle defaults, coercion, reserved values
 ;
 set string=$get(string)
 set find=$get(find)
 ;
 new from,to
 set from=$get(string("extract","from"))\1 ; reduce from to integers
 set:from<0 from=0 ; negative = 0
 new stringlen set stringlen=$length(string)
 set:from>stringlen from=0 ; too long = 0
 ;
 set to=$get(string("extract","to"))\1 ; reduce to to integers
 set:to<0 to=0 ; negative = 0
 set:to>stringlen to=0 ; too long = 0
 ;
 set flags=$get(flags)
 ;
 if flags?.e1u.e do  ; if flags contains uppercase values
 . set flags=$$lowcase^%ts(flags) ; convert to lowercase
 . quit
 ;
 new badflags set badflags=$translate(flags,"bir")]"" ; reserved flags
 ;
 ;
 ;@stanza 4 set up direction of scan
 ;
 new way,begin ; direction & where to start
 ;
 if badflags do  ; if bad flags, there will be no scan
 . set begin=0
 . quit
 ;
 else  if flags'["b" do  ; if scanning forward
 . set way=1 ; normal direction
 . set begin=to+1 ; begin after previously found substring
 . set:begin>stringlen begin=0 ; no scan, ran out of string
 . quit
 ;
 else  do  ; if scanning backward
 . set way=-1 ; reverse direction
 . set begin=from-1 ; begin before previously found substring
 . set:begin<1 begin=0 ; no scan, ran out of string
 . set:from=0 begin=stringlen ; begin at end of string
 . quit
 ;
 ;
 ;@stanza 5 set up case-sensitivity of scan
 ;
 new scanme,lookfor
 new case set case=flags["i" ; case insensitive?
 ;
 if 'case do  ; if case-sensitive scan, set that up
 . set scanme=string
 . set lookfor=find
 . quit
 ;
 else  do  ; if case-insensitive scan, set that up instead
 . if $get(string("low","string"))=""!(flags["r") do
 . . set string("low","string")=$$lowcase^%ts(string)
 . . quit
 . if $get(string("low","find"))=""!(flags["r") do
 . . set string("low","find")=$$lowcase^%ts(find)
 . . quit
 . set scanme=string("low","string")
 . set lookfor=string("low","find")
 . quit
 ;
 ;
 ;@stanza 6 perform scan
 ;
 new found set found=0 ; where did our scan find the substring
 set found("from")=0
 set found("to")=0
 ;
 ; if empty string, empty find, or ran out of string, then no scan
 new findlen set findlen=$length(find)
 if 'stringlen!'findlen!'begin ; if nothing can be found
 ;
 else  if way=1 do  ; forward scan
 . set found=$find(scanme,lookfor,begin) ; find substring
 . if 'found quit  ; done if couldn't find it
 . set found("to")=found-1 ; otherwise remember where
 . set found("from")=found-findlen
 . set found=1
 . quit
 ;
 else  do  ; backward scan
 . new winto set winto=begin ; end position of window into string
 . new winfrom,window
 . for  do  quit:found!'winfrom  ; traverse until found or done
 . . set winfrom=winto-findlen+1 ; start position of window
 . . if winfrom<1 do  quit  ; window has backed past start of string
 . . . set winfrom=0 ; no more substring instances to be found
 . . . quit
 . . set window=$extract(string,winfrom,winto) ; extract window
 . . set found=window=find ; did we find it?
 . . if found do  quit  ; if so, remember where
 . . . set found("from")=winfrom
 . . . set found("to")=winto
 . . . quit
 . . set winto=winto-1 ; shift end of window to previous position
 . . quit
 . quit
 ;
 ;
 ;@stanza 7 return results
 ;
 kill string("extract")
 merge string("extract")=found
 ;
 ;
 ;@stanza 8 termination
 ;
 quit  ; end of ppi findex^%ts
 ;
 ;
 ;
eor ; end of routine %tsef
