%wfhinput ;ven/gpl-web form: html input tag ;2018-03-06T18:30Z
 ;;1.8;Mash;
 ;
 ; %wfhinput implements the Web Form Library's html input tag
 ; processing methods, such as identifying input type or processing
 ; radio buttons & checkboxes.
 ; See %wfuthi for the unit tests for these methods.
 ; See %wfut for the whole unit-test library.
 ; See %wfud for documentation introducing the Web Form Lbrary,
 ; including an intro to the HTML Input Library.
 ; See %wful for the module's primary-development log.
 ; See %wf for the module's ppis & apis.
 ; %wfhinput contains no public entry points.
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-06T18:30Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Web Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;
 ;@to-do
 ; write unit tests
 ;
 ;@contents
 ; type: code for ppi $$type^%wf, input type
 ; uncheck: code for ppi uncheck^%wf, uncheck radio button or checkbox
 ; check: code for ppi check^%wf, check radio button or checkbox
 ;
 ;
 ;
 ;@section 1 type processing
 ;
 ;
 ;
type ; code for ppi $$type^%wf, input type
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;???% tests
 ;@signature
 ; $$type^%wf(line)
 ;@branches-from
 ; $$type^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls: none
 ;@input
 ; line = line of html including one & only one complete input tag. It
 ;  does not enforce standard input types but returns whatever type
 ;  the input says it is. Likewise, so long as the line contains that
 ;  tag & attribute, it does not care whether the rest of the line or
 ;  even the rest of this tag is standard-compliant. If no input tag
 ;  or type attribute exists in line, returns "".
 ;@output = value of type attribute within input tag
 ;@examples
 ; $$type^%wf("<input type=""radio"">") = "radio"
 ; $$type^%wf("<input type=radio>") = "radio"
 ; $$type^%wf("type=""radio""") = ""
 ; $$type^%wf("<input>") = ""
 ; $$type^%wf("<input type=""faketype"">") = "faketype"
 ; $$type^%wf("nonsense<input type=""button"">nonsense") = "button"
 ; $$type^%wf("<Input tYpe=""rAdIo"">") = "radio"
 ; $$type^%wf("") = ""
 ; $$type^%wf() = ""
 ;@tests: in %wfuthi
 ; type01: html compliant
 ; type02: nonstandard variant
 ; type03: no input tag
 ; type04: no type attribute
 ; type05: nonstandard type value
 ; type06: nonsense around input tag
 ; type07: case-insensitive
 ; type08: empty string
 ; type09: undefined
 ;@to-do
 ; handle splitting tag or attribute across lines
 ;
 ; extrinsic function returns value of input tag's type attribute. It
 ; is case-insensitive.
 ;
 ; Like the rest of web service %wf-wsGetForm, this function is not
 ; designed to handle tags or attributes that split across lines,
 ; nor lines containing multiple input tags.
 ;
 ;@stanza 2 parse & return type attribute's value
 ;
 set line=$get(line)
 new linelow set linelow=$$lowerCase^%ts(line) ; refresh lowercase
 new type set type=""
 ;
 ; handle missing input tag
 if linelow'["<input" ; sets $test
 ;
 ; standard html (quotes around type attribute value)
 else  if linelow[" type=""" do  ; e.g., <input type="radio" ...>
 . set type=$piece($piece(linelow," type=""",2),""" ")
 . quit
 ;
 ; nonstandard html (no quotes around type attribute value)
 else  if linelow[" type=" do  ; e.g., <input type=radio ...>
 . set type=$piece($piece(linelow," type=",2)," ")
 . quit
 ;
 quit type ; return input type, end of $$type^%wf
 ;
 ;
 ;
 ;@section 2 radio/checkbox processing
 ;
 ;
 ;
uncheck ; code for ppi uncheck^%wf, uncheck radio button or checkbox
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;???% tests
 ;@signature
 ; do uncheck^%wf(.line)
 ;@branches-from
 ; uncheck^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; $$lowerCase^%ts
 ; findReplace^%ts
 ;@throughput
 ;.line = line of template html to be replaced by processed html
 ;.line("low") = lowercase version of line for checks & searches
 ;@examples
 ;
 ;  new line
 ;  set line="<input type=radio name=""sbhcs"" value=""n"" checked> no"
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line="<input type=radio name=""sbhcs"" value=""n""> no"
 ;
 ;  new line
 ;  set line="<input type=radio name=""sbphu"" value=""i"" CHECKED> in"
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line="<input type=radio name=""sbphu"" value=""i""> in"
 ;
 ;  new line
 ;  set line="<input type=radio name=""sbphu"" value=""c""> cm"
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line="<input type=radio name=""sbphu"" value=""c""> cm"
 ;
 ;  new line
 ;  set line="<input type=""radio"" name=""sbmpa"" value=""n"" checked=""checked"">no</input>"
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line="<input type=""radio"" name=""sbmpa"" value=""n"">no</input>"
 ;
 ;  new line
 ;  set line="<input type=""radio"" name=""sbmpmi"" value=""n"" checked=checked>no</input>"
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line="<input type=""radio"" name=""sbmpmi"" value=""n"">no</input>"
 ;
 ;  new line set line=""
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line=""
 ;
 ;  new line
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line=""
 ;
 ;@tests: in %wfuthi
 ; unchk01: html compliant
 ; unchk02: uppercase CHECKED
 ; unchk03: not checked
 ; unchk04: nonstandard variant 1
 ; unchk05: nonstandard variant 2
 ; unchk06: empty string
 ; unchk07: undefined
 ;@to-do
 ; handle splitting tag or attribute across lines
 ;
 ; [description tbd]
 ; removes checked attribute from input tag, handles two nonstandard
 ; variants, handles uppercase or mixed case
 ;
 ;@stanza 2 uncheck checkbox or radio button
 ;
 set line=$get(line)
 new linelow set linelow=$$lowerCase^%ts(line) ; refresh lowercase
 new find set find=""
 new doit set doit=0
 ;
 ; html standard
 if linelow[" checked "!(linelow[" checked>") do
 . set find=" checked"
 . set doit=1
 . quit
 ;
 ; nonstandard variant 1
 else  if linelow[" checked=""checked""" do
 . set find=" checked=""checked"""
 . set doit=1
 . quit
 ;
 ; nonstandard variant 2
 else  if linelow[" checked=checked" do
 . set find=" checked=checked"
 . set doit=1
 . quit
 ;
 set line("extract","low")=linelow ; set up lowercase throughput
 do:doit findReplace^%ts(.line,find,"","i") ; cut checked attribute
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of uncheck^%wf
 ;
 ;
 ;
check ; code for ppi check^%wf, check radio button or checkbox
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;???% tests
 ;@signature
 ; do check^%wf(.line,type)
 ;@branches-from
 ; check^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; $$lowerCase^%ts
 ; findReplace^%ts
 ;@throughput
 ;.line = line of template html to be replaced by processed html
 ;.line("low") = lowercase version of line for checks & searches
 ;@input
 ; type = value of input tag's type attribute
 ;@examples
 ;
 ;  new line
 ;  set line="<input type=""radio"" name=""sbdsd"" id=""sbdsd-n"" value=""n""> No"
 ;  new type set type="radio"
 ;  do uncheck^%wf(.line,type)
 ; produces
 ;  line="<input type=""radio"" checked name=""sbdsd"" id=""sbdsd-n"" value=""n""> No"
 ;
 ;  new line
 ;  set line="<input type=radio name=""sbphu"" value=""c""> cm"
 ;  new type set type="radio"
 ;  do uncheck^%wf(.line,type)
 ; produces
 ;  line="<input type=radio checked name=""sbphu"" value=""c""> cm"
 ;
 ;  new line
 ;  set line="<input TYPE=checkbox name=""sbshsua"" value=""a""> cigars"
 ;  new type set type="checkbox"
 ;  do uncheck^%wf(.line,type)
 ; produces
 ;  line="<input TYPE=checkbox checked name=""sbshsua"" value=""a""> cigars"
 ;
 ;  new line set line="<html lang=""en"">"
 ;  new type set type=""
 ;  do uncheck^%wf(.line,type)
 ; produces
 ;  line="<html lang=""en"">"
 ;
 ;  new line set line=""
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line=""
 ;
 ;  new line
 ;  do uncheck^%wf(.line)
 ; produces
 ;  line=""
 ;
 ;@tests: in %wfuthi
 ; chk01: html compliant
 ; chk02: nonstandard variant
 ; chk03: case-insensitive
 ; chk04: no type attribute
 ; chk05: empty string
 ; chk06: undefined
 ;@to-do
 ; handle splitting tag or attribute across lines
 ;
 ; [description tbd]
 ; for radio buttons & checkbox, to be called only after input's
 ; checked attribute has already been cleared, to avoid ending up
 ; with two checked attributes.
 ;
 ;@stanza 2 check the radio button or checkbox
 ;
 set line=$get(line)
 new linelow set linelow=$$lowerCase^%ts(line) ; refresh lowercase
 set type=$get(type)
 new doit set doit=0
 ;
 ; html standard
 new find set find="type="""_type_"""" ; substring to find
 new replace set replace=find_" checked" ; substring to replace it with
 if linelow[find do
 . set doit=1
 . quit
 ;
 ; nonstandard variant: no quotes around type atribute's value
 else  do
 . set find="type="_type
 . quit:linelow'[find
 . set doit=1
 . quit
 ;
 set line("extract","low")=linelow ; set up lowercase throughput
 do:doit findReplace^%ts(.line,find,replace,"i")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of check^%wf
 ;
 ;
 ;
eor ; end of routine %wfhinput
