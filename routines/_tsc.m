%tsc ;ven/toad-type string: case conversion ;2018-12-14T17:29Z
 ;;1.8;Mash;
 ;
 ; %tsc implements MASH String Library Case Conversion ppis.
 ; See %tsud for an introduction to the String library, including an
 ; intro to the String Case library.
 ; See %tsul for the module's primary-development log.
 ; See %tsumc for meter (do case^%tsumc).
 ; See %tsutc for unit tests (do ^%tsut).
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
 ;@last-updated: 2018-12-14T17:29Z
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
 ;@timing-date: 2018-12-14
 ;@timing-system: andronicus (dev,jvvztm-9.0-ven)
 ;@cpu: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
 ;@ram: 2Gb
 ;@os: Linux Ubuntu 16.04.5 LTS (xenial)
 ;@mumps: YottaDB r1.22 Linux x86_64 (GT.M V6.3-004 Linux x86_64)
 ;
 ; timing performed with all other Vista jobs shut down.
 ; 10,000 iterations were done & duration of call averaged.
 ; values are in microseconds.
 ;
 ;@to-do
 ; do multi-string versions [see JJOHCASE for examples]
 ; apply standard string-length protection consistently
 ; create unit tests for all of these subroutines
 ;
 ;@contents
 ; upalpha = code for ppi $$upalpha^%ts
 ;  ABCDEFGHIJKLMNOPQRSTUVWXYZ
 ; lowalpha = code for ppi $$lowalpha^%ts
 ;  abcdefghijklmnopqrstuvwxyz
 ; upcase = code for ppi $$upcase^%ts
 ;  CONVERT STRING TO UPPERCASE
 ; lowcase = code for ppi $$lowcase^%ts
 ;  convert string to lowercase
 ; capcase = code for ppi $$capcase^%ts
 ;  Convert String To Capitalized Case
 ; invcase = code for ppi $$invcase^%ts
 ;  iNVERT cASE (uPPERS TO lOWERS & lOWERS TO uPPERS)
 ; sencase = code for ppi $$sencase^%ts
 ;  Convert string to sentence-case
 ;
 ;
 ;
 ;@section 1 code
 ;
 ;
 ;
 ;@ppi-code $$upalpha^%ts
upalpha ; return ABCDEFGHIJKLMNOPQRSTUVWXYZ
 ;
 ;ven/toad;private;variable;clean;silent;mdc;100% tests
 ;@signature
 ; $$upalpha^%ts
 ;@synonyms
 ; $$uac^%ts
 ; $$upperAlpha^%ts
 ; $$ALPHABET^%ts [deprecated]
 ;@branches-from
 ; $$upalpha^%ts
 ;@ppi-called-by
 ; $$upcase^%ts
 ; $$lowcase^%ts
 ; $$invcase^%ts
 ;@called-by: none
 ;@calls: none
 ;@inputs: none
 ;@output = ABCDEFGHIJKLMNOPQRSTUVWXYZ
 ;@meter: do case^%tsc
 ;@timing a
 ; count:
 ; total:
 ; min:
 ; max:
 ; mean:
 ; median:
 ; mode:
 ;@tests
 ; upalpha^%tsutc: $$upalpha^%ts
 ; uac^%tsutc: $$uac^%ts
 ; upperAlpha^%tsutc: $$upperAlpha^%ts
 ; ALPHABET^%tsutc: $$ALPHABET^%ts
 ;
 quit "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ; end of $$upalpha^%ts
 ;
 ;
 ;
 ;@ppi-code $$lowalpha^%ts
lowalpha ; return abcdefghijklmnopqrstuvwxyz
 ;
 ;ven/toad;private;variable;clean;silent;mdc;100% tests
 ;@signature
 ; $$lowalpha^%ts
 ;@synonyms
 ; $$lac^%ts
 ; $$lowerAlpha^%ts
 ; $$alphabet^%ts [deprecated]
 ;@branches-from
 ; $$lowalpha^%ts
 ;@ppi-called-by
 ; $$upcase^%ts
 ; $$lowcase^%ts
 ; $$invcase^%ts
 ;@called-by: none
 ;@calls: none
 ;@inputs: none
 ;@output = abcdefghijklmnopqrstuvwxyz
 ;@meter: do case^%tsc
 ;@timing b
 ; count:
 ; total:
 ; min:
 ; max:
 ; mean:
 ; median:
 ; mode:
 ;@tests
 ; lowalpha^%tsutc: $$lowalpha^%ts
 ; lac^%tsutc: $$lac^%ts
 ; lowerAlpha^%tsutc: $$lowerAlpha^%ts
 ; alphabet^%tsutc: $$alphabet^%ts
 ;
 quit "abcdefghijklmnopqrstuvwxyz" ; end of $$lowalpha^%ts
 ;
 ;
 ;
 ;@ppi-code $$upcase^%ts
upcase ; CONVERT STRING TO UPPERCASE
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;mdc;100% tests
 ;@signature
 ; $$upcase^%ts(string)
 ;@synonyms
 ; $$uc^%ts
 ; $$upperCase^%ts
 ;@branches-from
 ; $$upcase^%ts
 ;@ppi-called-by
 ; $$capcase^%ts
 ; $$sencase^%ts
 ; $$trim^%ts
 ; target^%mp4
 ;@called-by: none
 ;@calls
 ; $$upalpha^%ts
 ; $$lowalpha^%ts
 ;@input
 ; string = string to convert
 ;@output = uppercase string
 ;@meter: do case^%tsc
 ;@timing c
 ; count:
 ; total:
 ; min:
 ; max:
 ; mean:
 ; median:
 ; mode:
 ;@tests
 ; upcase01^%tsutc: string
 ; upcase02^%tsutc: phrase string
 ; upcase03^%tsutc: empty string
 ; upcase04^%tsutc: non-alpha characters
 ; upcase05^%tsutc: mixed alpha & non-alpha characters
 ; uc^%tsutc: $$uc^%ts
 ; upperCase^%tsutc: $$upperCase^%ts
 ;
 set string=$translate(string,$$lowalpha^%ts,$$upalpha^%ts)
 ;
 quit string ; return uppercase string; end of $$upcase^%ts
 ;
 ;
 ;
 ;@ppi-code $$lowcase^%ts
lowcase ; convert string to lowercase
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;mdc;100% tests
 ;@signature
 ; $$lowcase^%ts(string)
 ;@synonyms
 ; $$lc^%ts
 ; $$lowerCase^%ts
 ;@branches-from
 ; $$lowcase^%ts
 ;@ppi-called-by
 ; $$capcase^%ts
 ; $$sencase^%ts
 ; command^%mp
 ; intrin^%mp1
 ; intvar^%mp1
 ; intfunc^%mp1
 ; target^%mp4
 ; form2fields^%wfhfields
 ; wsGetForm^%wfhform
 ; check^%wfhinput
 ; type^%wfhinput
 ; uncheck^%wfhinput
 ; ONE^SAMIDOUT
 ;@called-by: none
 ;@calls
 ; $$upalpha^%ts
 ; $$lowalpha^%ts
 ;@input
 ; string = string to convert
 ;@output = lowercase string
 ;@meter: do case^%tsc
 ;@timing d
 ; count:
 ; total:
 ; min:
 ; max:
 ; mean:
 ; median:
 ; mode:
 ;@tests
 ; lowcase01^%tsutc: string
 ; lowcase02^%tsutc: phrase string
 ; lowcase03^%tsutc: empty string
 ; lowcase04^%tsutc: non-alpha characters
 ; lowcase05^%tsutc: mixed alpha & non-alpha characters
 ; lc^%tsutc: $$lc^%ts
 ; lowerCase^%tsutc: $$lowerCase^%ts
 ;
 set string=$translate(string,$$upalpha^%ts,$$lowalpha^%ts)
 ;
 quit string ; return lowercase string; end of $$lowcase^%ts
 ;
 ;
 ;
 ;@ppi-code $$capcase^%ts
capcase ; Convert String To Capitalized
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;mdc;100% tests
 ;@signature
 ; $$capcase^%ts(string)
 ;@synonyms
 ; $$cc^%ts
 ; $$capitalCase^%ts
 ;@branches-from
 ; $$capcase^%ts
 ;@ppi-called by: none
 ;@called-by: none
 ;@calls
 ; $$lowcase^%ts
 ; $$upcase^%ts
 ;@input
 ; string = string to convert
 ;@output = capitalized string
 ;@meter: do case^%tsc
 ;@timing e
 ; count:
 ; total:
 ; min:
 ; max:
 ; mean:
 ; median:
 ; mode:
 ;@examples
 ;  write $$capcase^%ts("THIS IS CAPITALIZED. (this isn't.)")
 ; produces
 ;  This Is Capitalized. (This Isn't.)
 ;@tests
 ; capcase01^%tsutc: uppercase string
 ; capcase02^%tsutc: lowercase phrase
 ; capcase03^%tsutc: empty string
 ; capcase04^%tsutc: non-alpha characters
 ; capcase05^%tsutc: mixed upper & lowercase characters
 ; cc^%tsutc: $$cc^%ts
 ; capitalCase^%tsutc: $$capitalCase^%ts
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
 ;@ppi-code $$invcase^%ts
invcase ; iNVERT cASE (uPPERS TO lOWERS & vICE vERSA)
 ;
 ;kbaz/zag,ven/toad;private;function;clean;silent;mdc;100% tests
 ;@signature
 ; $$invcase^%ts(string)
 ;@synonyms
 ; $$ic^%ts
 ; $$inverseCase^%ts
 ;@branches-from
 ; $$invcase^%ts
 ;@ppi-called by: none
 ;@called-by: none
 ;@calls
 ; $$upalpha^%ts
 ; $$lowalpha^%ts
 ;@input
 ; string = string to convert
 ;@output = inverse-cased string
 ;@meter: do case^%tsc
 ;@timing f
 ; count:
 ; total:
 ; min:
 ; max:
 ; mean:
 ; median:
 ; mode:
 ;@examples
 ;  write $$invcase^%ts("tHIS iS cAPITALIZED. (tHIS iSN'T.)")
 ; produces
 ;  This Is Capitalized. (This Isn't.)
 ;@tests
 ; invcase01^%tsutc: uppercase & lowercase string
 ; invcase02^%tsutc: mixed-case phrase
 ; invcase03^%tsutc: empty string
 ; invcase04^%tsutc: non-alpha characters
 ; ic^%tsutc: $$ic^%ts
 ; inverseCase^%tsutc: $$inverseCase^%ts
 ;
 ; Inverted Case = lowers replaced with uppers, uppers with lowers
 ;
 new up set up=$$upalpha^%ts
 new low set low=$$lowalpha^%ts
 new uplow set uplow=up_low
 new lowup set lowup=low_up
 set string=$translate(string,uplow,lowup)
 ;
 quit string ; return inverse-case string; end of $$invcase^%ts
 ;
 ;
 ;
 ;@ppi-code $$sencase^%ts
sencase ; Convert string to sentence case
 ;
 ;isf/rwf,ven/toad;private;function;clean;silent;mdc;100% tests
 ;@signature
 ; $$sencase^%ts(string)
 ;@synonyms
 ; $$sc^%ts
 ; $$sentenceCase^%ts
 ;@branches-from
 ; $$sencase^%ts
 ;@ppi-called by: none
 ;@called-by: none
 ;@calls
 ; $$lowcase^%ts
 ; $$upcase^%ts
 ;@input
 ; string = string to convert
 ;@output = sentence-case string
 ;@meter: do case^%tsc
 ;@timing g
 ; count:
 ; total:
 ; min:
 ; max:
 ; mean:
 ; median:
 ; mode:
 ;@examples
 ;  write $$sencase^%ts("HELLO!!! THIS IS A SENTENCE. (this isn't.)")
 ; produces
 ;  Hello!!! This is a sentence. (This isn't.)
 ;@tests
 ; sencase01^%tsutc: uppercase string
 ; sencase02^%tsutc: lowercase phrase
 ; sencase03^%tsutc: empty string
 ; sencase04^%tsutc: non-alpha characters
 ; sencase05^%tsutc: mixed upper & lowercase characters to Sentence
 ; sencase06^%tsutc: more than one Sentence, different puncuation
 ; sc^%tsutc: $$sc^%ts
 ; sentenceCase^%tsutc: $$sentenceCase^%ts
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
