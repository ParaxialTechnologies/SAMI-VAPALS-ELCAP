%ts ;ven/toad-type string: api/ppi library ;2018-02-22T19:14Z
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
 ;@last-updated: 2018-02-22T19:14Z
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
 ; @API $$alphabet^%ts, abcdefghijklmnopqrstuvwxyz
alphabet() goto alphabet^%tsc
 ;
 ; @API $$ALPHABET^%ts, ABCDEFGHIJKLMNOPQRSTUVWXYZ
ALPHABET() goto ALPHABET^%tsc
 ;
 ;
 ; @API $$upcase^%ts, CONVERT STRING TO UPPERCASE
upcase(string) goto upcase^%tsc
 ;
 ; @API $$u^%ts, CONVERT STRING TO UPPERCASE
u(string) goto upcase^%tsc
 ;
 ;
 ; @API $$lowcase^%ts, convert string to lowercase
lowcase(string) goto lowcase^%tsc
 ;
 ; @API $$l^%ts, convert string to lowercase
l(string) goto lowcase^%tsc
 ;
 ;
 ; @API $$capcase^%ts, Convert String To Capitalized Case
capcase(string) goto capcase^%tsc
 ;
 ; @API $$c^%ts, Convert String To Capitalized Case
c(string) goto capcase^%tsc
 ;
 ;
 ; @API $$invcase^%ts, iNVERT cASE (uPPERS TO lOWERS & lOWERS TO uPPERS)
invcase(string) goto invcase^%tsc
 ;
 ; @API $$i^%ts, iNVERT cASE (uPPERS TO lOWERS & lOWERS TO uPPERS)
i(string) goto invcase^%tsc
 ;
 ;
 ; @API $$sencase^%ts, Convert string to sentence-case
sencase(string) goto sencase^%tsc
 ;
 ; @API $$s^%ts, Convert string to sentence-case
s(string) goto sencase^%tsc
 ;
 ;
 ;
 ;@section 2 %tsr: string-replace tools
 ;
 ;
 ;
 ; @API $$strip^%ts, strip character(s) from string
strip(string,char) goto strip^%tsrs
 ;
 ;
 ; @API $$trim^%ts, trim character from end(s) of string
trim(string,end,char) goto trim^%tsrt
 ;
 ;
 ;
eor ; end of routine %ts
