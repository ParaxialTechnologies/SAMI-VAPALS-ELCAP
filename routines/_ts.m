%ts ;ven/toad-type string: api/ppi library ;2018-02-28T19:34Z
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
 ;@last-updated: 2018-02-28T19:34Z
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
 ;@API $$u^%ts, CONVERT STRING TO UPPERCASE
u(string) goto upcase^%tsc
 ;
 ;@API $$upcase^%ts, CONVERT STRING TO UPPERCASE
upcase(string) goto upcase^%tsc
 ;
 ;@API $$upperCase^%ts, CONVERT STRING TO UPPERCASE
upperCase(string) goto upcase^%tsc
 ;
 ;
 ;
 ;@API $$l^%ts, convert string to lowercase
l(string) goto lowcase^%tsc
 ;
 ;@API $$lowcase^%ts, convert string to lowercase
lowcase(string) goto lowcase^%tsc
 ;
 ;@API $$lowerCase^%ts, convert string to lowercase
lowerCase(string) goto lowcase^%tsc
 ;
 ;
 ;
 ;@API $$c^%ts, Convert String To Capitalized Case
c(string) goto capcase^%tsc
 ;
 ;@API $$capcase^%ts, Convert String To Capitalized Case
capcase(string) goto capcase^%tsc
 ;
 ;@API $$capitalCase^%ts, Convert String To Capitalized Case
capitalCase(string) goto capcase^%tsc
 ;
 ;
 ;
 ;@API $$i^%ts, iNVERSE cASE (uPPERS TO lOWERS & lOWERS TO uPPERS)
i(string) goto invcase^%tsc
 ;
 ;@API $$invcase^%ts, iNVERSE cASE (uPPERS TO lOWERS & lOWERS TO uPPERS)
invcase(string) goto invcase^%tsc
 ;
 ;@API $$inverseCase^%ts, iNVERSE cASE (uPPERS TO lOWERS & lOWERS TO uPPERS)
inverseCase(string) goto invcase^%tsc
 ;
 ;
 ;
 ;@API $$s^%ts, Convert string to sentence-case
s(string) goto sencase^%tsc
 ;
 ;@API $$sencase^%ts, Convert string to sentence-case
sencase(string) goto sencase^%tsc
 ;
 ;@API $$sentenceCase^%ts, Convert string to sentence-case
sentenceCase(string) goto sencase^%tsc
 ;
 ;
 ;
 ;@section 2 %tse: string-extract tools
 ;
 ;
 ;
 ;@API fe^%ts, find position of substring
fe(string,find,flags) goto findex^%tsef
 ;
 ;@API findex^%ts, find position of substring
findex(string,find,flags) goto findex^%tsef
 ;
 ;@API findExtract^%ts, find position of substring
findExtract(string,find,flags) goto findex^%tsef
 ;
 ;@API find^%ts, find position of substring
find(string,find,flags) goto findex^%tsef
 ;
 ;
 ;
 ;@API se^%ts, change value of positional substring
se(string,replace,flags) goto setex^%tses
 ;
 ;@API setex^%ts, change value of positional substring
setex(string,replace,flags) goto setex^%tses
 ;
 ;@API setExtract^%ts, change value of positional substring
setExtract(string,replace,flags) goto setex^%tses
 ;
 ;@API place^%ts, change value of positional substring
place(string,replace,flags) goto setex^%tses
 ;
 ;
 ;
 ;@section 3 %tsr: string-replace tools
 ;
 ;
 ;
 ;@ppi fr^%ts, find & replace substring
fr(string,find,replace,flags) goto findrep^%tsrf
 ;
 ;@ppi findrep^%ts, find & replace substring
findrep(string,find,replace,flags) goto findrep^%tsrf
 ;
 ;@ppi findReplace^%ts, find & replace substring
findReplace(string,find,replace,flags) goto findrep^%tsrf
 ;
 ;
 ;
 ;@API $$sr^%ts, strip character(s) from string
sr(string,char) goto strip^%tsrs
 ;
 ;@API $$strip^%ts, strip character(s) from string
strip(string,char) goto strip^%tsrs
 ;
 ;
 ;
 ;@API $$tr^%ts, trim character from end(s) of string
tr(string,end,char) goto trim^%tsrt
 ;
 ;@API $$trim^%ts, trim character from end(s) of string
trim(string,end,char) goto trim^%tsrt
 ;
 ;
 ;
eor ; end of routine %ts
