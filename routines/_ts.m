%ts ;ven/toad-type string: api/ppi library ;2018-12-12T14:32Z
 ;;1.8;Mash;
 ;
 ; %ts is the Mumps String Library, an element of the Mumps
 ; Advanced Shell's Data Type Library. It collects all Mumps
 ; String Library interfaces, both public application program
 ; interfaces (apis) and private program interfaces (ppis).
 ; Its interfaces are implemented in other %ts* routines, none
 ; of which contains any public entry points.
 ; See %tsul for the module's primary-development log.
 ; See %tsud for documentation introducing the library.
 ; %ts version 1.8 contains no public apis, only private ppis.
 ; Applications may only call these ppis after negotiating a
 ; private subscription.
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
 ;@last-updated: 2018-12-12T14:32Z
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
 ;@ppi $$upalpha^%ts, abcdefghijklmnopqrstuvwxyz
upalpha() goto upalpha^%tsc
 ;
 ;@ppi $$uac^%ts, idem
uac() goto upalpha^%tsc
 ;
 ;@ppi $$upperAlpha^%ts, idem
upperAlpha() goto upalpha^%tsc
 ;
 ;
 ;
 ;@ppi $$lowalpha^%ts, ABCDEFGHIJKLMNOPQRSTUVWXYZ
lowalpha() goto lowalpha^%tsc
 ;
 ;@ppi $$lac^%ts, idem
lac() goto lowalpha^%tsc
 ;
 ;@ppi $$lowerAlpha^%ts, idem
lowerAlpha() goto lowalpha^%tsc
 ;
 ;
 ;
 ;@ppi $$upcase^%ts, upper case (ALL CAPITAL LETTERS)
upcase(string) goto upcase^%tsc
 ;
 ;@ppi $$uc^%ts, idem
uc(string) goto upcase^%tsc
 ;
 ;@ppi $$upperCase^%ts, idem
upperCase(string) goto upcase^%tsc
 ;
 ;
 ;
 ;@ppi $$lowcase^%ts, lower case (no capital letters)
lowcase(string) goto lowcase^%tsc
 ;
 ;@ppi $$lc^%ts, idem
lc(string) goto lowcase^%tsc
 ;
 ;@ppi $$lowerCase^%ts, idem
lowerCase(string) goto lowcase^%tsc
 ;
 ;
 ;
 ;@ppi $$capcase^%ts, capital case (First Char Of Each Word Capital)
capcase(string) goto capcase^%tsc
 ;
 ;@ppi $$cc^%ts, idem
cc(string) goto capcase^%tsc
 ;
 ;@ppi $$capitalCase^%ts, idem
capitalCase(string) goto capcase^%tsc
 ;
 ;
 ;
 ;@ppi $$invcase^%ts, inverse case (uPPERS TO lOWERS & vice versa)
invcase(string) goto invcase^%tsc
 ;
 ;@ppi $$ic^%ts, idem
ic(string) goto invcase^%tsc
 ;
 ;@ppi $$inverseCase^%ts, idem
inverseCase(string) goto invcase^%tsc
 ;
 ;
 ;
 ;@ppi $$sencase^%ts, sentence case (Character one capital)
sencase(string) goto sencase^%tsc
 ;
 ;@ppi $$sc^%ts, idem
sc(string) goto sencase^%tsc
 ;
 ;@ppi $$sentenceCase^%ts, idem
sentenceCase(string) goto sencase^%tsc
 ;
 ;
 ;
 ;@section 2 %tse: string-extract tools
 ;
 ;
 ;
 ;@ppi findex^%ts, find extract (find position of substring)
findex(string,find,flags) goto findex^%tsef
 ;
 ;@ppi fe^%ts, idem
fe(string,find,flags) goto findex^%tsef
 ;
 ;@ppi findExtract^%ts, idem
findExtract(string,find,flags) goto findex^%tsef
 ;
 ;@ppi find^%ts, idem
find(string,find,flags) goto findex^%tsef
 ;
 ;
 ;
 ;@ppi setex^%ts, set extract (change value of positional substring)
setex(string,newval,flags) goto setex^%tses
 ;
 ;@ppi se^%ts, idem
se(string,newval,flags) goto setex^%tses
 ;
 ;@ppi setExtract^%ts, idem
setExtract(string,newval,flags) goto setex^%tses
 ;
 ;@ppi place^%ts, idem
place(string,newval,flags) goto setex^%tses
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
 ;@ppi sf^%ts, idem
sf(string,find,replace,flags) goto setfind^%tsfs
 ;
 ;@ppi setFind^%ts, idem
setFind(string,find,replace,flags) goto setfind^%tsfs
 ;
 ;
 ;
 ;@ppi findReplace^%ts, simple substring find & replace
findReplace(string,find,replace,flags) goto findReplace^%tsfwr
 ;
 ;
 ;
 ;@ppi findReplaceAll^%ts, simple substring find & replace all
findReplaceAll(string,find,replace,flags) goto findReplaceAll^%tsfwra
 ;
 ;
 ;
 ;@section 4 %tsj: string-justify tools
 ;
 ;
 ;
 ;@ppi $$trim^%ts, trim character from end(s) of string
trim(string,end,char) goto trim^%tsjt
 ;
 ;
 ;
 ;@section 5 %tsv: string-validation tools
 ;
 ;
 ;
 ;@ppi $$strip^%ts, strip character(s) from string
strip(string,char) goto strip^%tsvs
 ;
 ;
 ;
eor ; end of routine %ts
