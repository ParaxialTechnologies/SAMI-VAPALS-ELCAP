%ts ;ven/toad-type string: api/ppi library ;2018-03-05T20:24Z
 ;;1.8;Mash;
 ;
 ; %ts is the Mumps String Library, an element of the Mumps
 ; Advanced Shell's Data Type Library. It collects all public
 ; application programmer interfaces in the Mumps String Library.
 ; Its APIs are implemented in other %ts* routines, none of which
 ; contains any public entry points.
 ; See %tsul for the module's primary-development log.
 ; See %tsud for documentation introducing the library.
 ; %ts contains public entry points.
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
 ;@last-updated: 2018-03-05T20:24Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@contents
 ; (all application programmer interfaces)
 ;
 ;
 ;
 ;@section 1 %tsc: string-case tools
 ;
 ;
 ;
 ;@API $$alphabet^%ts, abcdefghijklmnopqrstuvwxyz
alphabet() goto alphabet^%tsc
 ;
 ;@API $$ALPHABET^%ts, ABCDEFGHIJKLMNOPQRSTUVWXYZ
ALPHABET() goto ALPHABET^%tsc
 ;
 ;
 ;
 ;@API $$upcase^%ts, upper case (ALL CAPITAL LETTERS)
upcase(string) goto upcase^%tsc
 ;
 ;@API $$u^%ts, upper case
u(string) goto upcase^%tsc
 ;
 ;@API $$upperCase^%ts, upper case
upperCase(string) goto upcase^%tsc
 ;
 ;
 ;
 ;@API $$lowcase^%ts, lower case (no capital letters)
lowcase(string) goto lowcase^%tsc
 ;
 ;@API $$l^%ts, lower case
l(string) goto lowcase^%tsc
 ;
 ;@API $$lowerCase^%ts, lower case
lowerCase(string) goto lowcase^%tsc
 ;
 ;
 ;
 ;@API $$capcase^%ts, capital case (First Char Of Each Word Capital)
capcase(string) goto capcase^%tsc
 ;
 ;@API $$c^%ts, capital case
c(string) goto capcase^%tsc
 ;
 ;@API $$capitalCase^%ts, capital case
capitalCase(string) goto capcase^%tsc
 ;
 ;
 ;
 ;@API $$invcase^%ts, inverse case (uPPERS TO lOWERS & vice versa)
invcase(string) goto invcase^%tsc
 ;
 ;@API $$i^%ts, inverse case
i(string) goto invcase^%tsc
 ;
 ;@API $$inverseCase^%ts, inverse case
inverseCase(string) goto invcase^%tsc
 ;
 ;
 ;
 ;@API $$sencase^%ts, sentence case (1st character capital)
sencase(string) goto sencase^%tsc
 ;
 ;@API $$s^%ts, sentence case
s(string) goto sencase^%tsc
 ;
 ;@API $$sentenceCase^%ts, sentence case
sentenceCase(string) goto sencase^%tsc
 ;
 ;
 ;
 ;@section 2 %tse: string-extract tools
 ;
 ;
 ;
 ;@API findex^%ts, find extract (find position of substring)
findex(string,find,flags) goto findex^%tsef
 ;
 ;@API fe^%ts, find extract
fe(string,find,flags) goto findex^%tsef
 ;
 ;@API findExtract^%ts, find extract
findExtract(string,find,flags) goto findex^%tsef
 ;
 ;@API find^%ts, find extract
find(string,find,flags) goto findex^%tsef
 ;
 ;
 ;
 ;@API setex^%ts, set extract (change value of positional substring)
setex(string,replace,flags) goto setex^%tses
 ;
 ;@API se^%ts, set extract
se(string,replace,flags) goto setex^%tses
 ;
 ;@API setExtract^%ts, set extract
setExtract(string,replace,flags) goto setex^%tses
 ;
 ;@API place^%ts, set extract
place(string,replace,flags) goto setex^%tses
 ;
 ;
 ;
 ;@section 3 %tsf: string-find tools
 ;
 ;
 ;
 ;@ppi setfind^%ts, set find (find & replace substring)
setfind(string,find,replace,flags) goto setfind^%tsfs
 ;
 ;@ppi sf^%ts, set find
sf(string,find,replace,flags) goto setfind^%tsfs
 ;
 ;@ppi setFind^%ts, set find
setFind(string,find,replace,flags) goto setfind^%tsfs
 ;
 ;@ppi replace^%ts, set find
replace(string,find,replace,flags) goto setfind^%tsfs
 ;
 ;@ppi findReplace^%ts, set find
findReplace(string,find,replace,flags) goto setfind^%tsfs
 ;
 ;
 ;
 ;@section 4 %tsr: string-replace tools
 ;
 ;
 ;
 ;@API $$trim^%ts, trim character from end(s) of string
trim(string,end,char) goto trim^%tsrt
 ;
 ;
 ;
 ;@section 5 %tsv: string-validation tools
 ;
 ;
 ;
 ;@API $$strip^%ts, strip character(s) from string
strip(string,char) goto strip^%tsvs
 ;
 ;
 ;
eor ; end of routine %ts
