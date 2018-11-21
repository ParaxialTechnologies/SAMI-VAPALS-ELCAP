%tsc ;ven/toad-type string: case conversion ;2018-02-23T22:06Z
 ;;1.8;Mash;
 ;
 ; %tsc implements MASH String Library Case Conversion APIs.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsc contains no public entry points.
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
 ;@last-updated: 2018-02-23T22:06Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@original-dev: R. Wally Fort (rwf)
 ;@original-dev-org: U.S. Department of Veterans Affairs
 ; prev. Veterans Administration
 ; National Development Office in San Francisco (vaisf)
 ;
 ;@to-do
 ; do multi-string versions [see JJOHCASE for examples]
 ; apply standard string-length protection consistently
 ; create unit tests for all of these subroutines
 ;
 ;@contents
 ; alphabet = code for API $$alphabet^%ts
 ;  abcdefghijklmnopqrstuvwxyz
 ; ALPHABET = code for API $$ALPHABET^%ts
 ;  ABCDEFGHIJKLMNOPQRSTUVWXYZ
 ; upcase = code for API $$upcase^%ts
 ;  CONVERT STRING TO UPPERCASE
 ; lowcase = code for API $$lowcase^%ts
 ;  convert string to lowercase
 ; capcase = code for API $$capcase^%ts
 ;  Convert String To Capitalized Case
 ; invcase = code for API $$invcase^%ts
 ;  iNVERT cASE (uPPERS TO lOWERS & lOWERS TO uPPERS)
 ; sencase = code for API $$sencase^%ts
 ;  Convert string to sentence-case
 ;
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
alphabet ; code for API $$alphabet^%ts, abcdefghijklmnopqrstuvwxyz
 ;
 ;ven/toad;private;variable;clean;silent;sac;NO tests;;100% tests
 ;@signature
 ; $$alphabet^%ts
 ;@branches-from
 ; $$alphabet^%ts
 ;@called-by
 ; $$upcase^%ts
 ; $$invcase^%ts
 ;@calls: none
 ;@inputs: none
 ;@output = abcdefghijklmnopqrstuvwxyz
 ;@tests: [tbd]
 ;
 quit "abcdefghijklmnopqrstuvwxyz" ; end of $$alphabet^%ts
 ;
 ;
 ;
ALPHABET ; code for API $$ALPHABET^%ts, ABCDEFGHIJKLMNOPQRSTUVWXYZ
 ;
 ;ven/toad;private;variable;clean;silent;sac;NO tests;100% tests
 ;@signature
 ;  $$ALPHABET^%ts
 ;@branches-from
 ; $$ALPHABET^%ts
 ;@called-by
 ; $$upcase^%ts
 ; $$invcase^%ts
 ;@calls: none
 ;@inputs: none
 ;@output = ABCDEFGHIJKLMNOPQRSTUVWXYZ
 ;@tests: [tbd]
 ;
 quit "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ; end of $$ALPHABET^%ts
 ;
 ;
 ;
upcase ; code for API $$upcase^%ts, CONVERT STRING TO UPPERCASE
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;sac;;100% tests
 ;@signature
 ; $$upcase^%ts(string)
 ;@branches-from
 ; $$upcase^%ts
 ;@called-by
 ; $$capcase^%ts
 ; $$sencase^%ts
 ;@calls
 ; $$ALPHABET^%ts
 ; $$alphabet^%ts
 ;@input
 ; string = string to convert
 ;@output = uppercase string
 ;@tests: [tbd]
 ;
 set string=$translate(string,$$alphabet^%ts,$$ALPHABET^%ts)
 ;
 quit string ; return uppercase string; end of $$upcase^%ts
 ;
 ;
 ;
lowcase ; code for API $$lowcase^%ts, convert string to lowercase
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;sac;100% tests
 ;@signature
 ; $$lowcase^%ts(string)
 ;@branches-from
 ; $$lowcase^%ts
 ;@called-by
 ; $$capcase^%ts
 ; $$sencase^%ts
 ;@calls
 ; $$ALPHABET^%ts
 ; $$alphabet^%ts
 ;@input
 ; string = string to convert
 ;@output = lowercase string
 ;@tests: [tbd]
 ;
 set string=$translate(string,$$ALPHABET^%ts,$$alphabet^%ts)
 ;
 quit string ; return lowercase string; end of $$lowcase^%ts
 ;
 ;
 ;
capcase ; code for API $$capcase^%ts, Convert String To Capitalized
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;sac;;100% tests
 ;@signature
 ; $$capcase^%ts(string)
 ;@branches-from
 ; $$capcase^%ts
 ;@called by: none
 ;@calls
 ; $$lowcase^%ts
 ; $$upcase^%ts
 ;@input
 ; string = string to convert
 ;@output = capitalized string
 ;@examples
 ;  write $$capcase^%ts("THIS IS CAPITALIZED. (this isn't.)")
 ; produces
 ;  This Is Capitalized. (This Isn't.)
 ;@tests: [tbd]
 ;
 ; Capitalized Case = first letter of each word uppercase, rest lower
 ;
 ; internal
 ;  up = convert next letter to uppercase?
 ;  %p = string-extract position
 ;  char = current character
 ;
 set string=$$lowcase^%ts(string) ; start with lowercase
 new up set up=1 ; flag to convert next letter to uppercase
 new %p ; position of each character
 for %p=1:1:$length(string) do  ; traverse string's characters
 . new char set char=$extract(string,%p) ; get each character
 . if up,char?1L do  ; if cap flag set & char is lc
 . . set $extract(string,%p)=$$upcase^%ts(char) ; convert lc to uc
 . . set up=0 ; and clear cap flag
 . . quit
 . if char?1P,char'="'" do  ; if punctuation but not apostrophe
 . . set up=1 ; set cap flag
 . . quit
 . quit
 ;
 quit string ; return capitalized string; end of $$capcase^%ts
 ;
 ;
 ;
invcase ; code for API $$invcase^%ts, iNVERT cASE (uPPERS TO lOWERS...
 ;
 ;kbaz/zag,ven/toad;private;function;clean;silent;sac;;100% tests
 ;@signature
 ; $$invcase^%ts(string)
 ;@branches-from
 ; $$invcase^%ts
 ;@called by: none
 ;@calls
 ; $$ALPHABET^%ts
 ; $$alphabet^%ts
 ;@input
 ; string = string to convert
 ;@output = inverse-cased string
 ;@examples
 ;  write $$invcase^%ts("tHIS iS cAPITALIZED. (tHIS iSN'T.)")
 ; produces
 ;  This Is Capitalized. (This Isn't.)
 ;@tests: [tbd]
 ;
 ; Inverted Case = lowers replaced with uppers, uppers with lowers
 ;
 new up set up=$$ALPHABET^%ts
 new low set low=$$alphabet^%ts
 new uplow set uplow=up_low
 new lowup set lowup=low_up
 set string=$translate(string,uplow,lowup)
 ;
 quit string ; return inverse-case string; end of $$invcase^%ts
 ;
 ;
 ;
sencase ; code for API $$sencase^%ts, Convert string to sentence case
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;sac;100% tests
 ;@signature
 ; $$sencase^%ts(string)
 ;@branches-from
 ; $$sencase^%ts
 ;@called by: none
 ;@calls
 ; $$lowcase^%ts
 ; $$upcase^%ts
 ;@input
 ; string = string to convert
 ;@output = sentence-case string
 ;@examples
 ;  write $$sencase^%ts("HELLO!!! THIS IS A SENTENCE. (this isn't.)")
 ; produces
 ;  Hello!!! This is a sentence. (This isn't.)
 ;@tests: [tbd]
 ;
 ; Sentence case = first letter of each sentence uppercase, rest lower
 ;
 ; internal
 ;  up = state flag (1 = next letter should be caps)
 ;  %p = string-extract position
 ;  char = current character
 ;
 set string=$$lowcase^%ts(string) ; start with lowercase
 new up set up=1 ; flag to convert next letter to uppercase
 new %p ; position of each character
 for %p=1:1:$length(string) do  ; traverse string's characters
 . new char set char=$extract(string,%p) ; get each character
 . if up,char?1L do  ; if cap flag set & char is lc
 . . set $extract(string,%p)=$$upcase^%ts(char) ; convert lc char to uc
 . . set up=0 ; and clear cap flag
 . . quit
 . if ".!?"[char do  ; if end-of-sentence, punctuation
 . . set up=1 ; set cap flag
 . . quit
 . quit
 ;
 quit string ; return sentence-case string; end of $$sencase^%ts
 ;
 ;
 ;
eor ; end of routine %tsc
