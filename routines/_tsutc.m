%tsutc ;ven/lmry-type string-case: test ppis ^%tsc ;2018-12-12T04:14Z
 ;;1.8;Mash;
 ;
 ; This Mumps Advanced Shell (mash) routine implements unit tests for
 ; Mash String Library string-case ppis in %ts. It contains no public entry
 ; points.
 ;
 ; primary development: see routine %tsul
 ;
 ;@primary-dev: Linda M. R. Yaw (lmry)
 ;@additional-dev: Ken McGlothlen (mcglk)
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ;@primary-dev-org: Vista Expertise Network (ven)
 ;@copyright: 2016/2017/2018, ven, all rights reserved
 ;@license: Apache 2.0
 ;
 ;@last-updated: 2018-12-12T04:14Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.7T03
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 ;@contents
 ; Group 1: Alphabet
 ;  upalpha: unit test for $$upalpha^%ts
 ;  uac: unit test for $$uac^%ts
 ;  upperAlpha: unit test for $$upperAlpha^%ts
 ;  ALPHABET: unit test for $$ALPHABET^%ts
 ;  lowalpha: unit test for $$lowalpha^%ts
 ;  lac: unit test for $$lac^%ts
 ;  lowerAlpha: unit test for $$lowerAlpha^%ts
 ;  alphabet: unit test for $$alphabet^%ts
 ; Group 2: Upper Case
 ;  upcase*: unit tests for $$upcase^%ts
 ;  u: unit test for $$u^%ts
 ;  upperCase: unit test for $$upperCase^%ts
 ; Group 3: Lower Case
 ;  lowcase*: unit tests for $$lowcase^%ts
 ;  l: unit test for $$l^%ts
 ;  lowerCase: unit test for $$lowerCase^%ts
 ; Group 4: Capital Case
 ;  capcase*: unit tests for $$capcase^%ts
 ;  c: unit test for $$c^%ts
 ;  capitalCase: unit test for $$capitalCase^%ts
 ; Group 5: Inverse Case
 ;  invcase*: unit tests for $$invcase^%ts
 ;  i: unit test for $$i^%ts
 ;  inverseCase: unit test for $$inverseCase^%ts
 ; Group 6: Sentence Case
 ;  sencase*: unit tests for $$sencase^%ts
 ;  s: unit test for $$s^%ts
 ;  sentenceCase: unit test for $$sentenceCase^%ts
 ; 
 ;@called-by:
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;
 ;
 ; Group 1: Alphabet
 ;
 ;
upalpha ; @TEST $$upalpha^%ts(%s,%c): return uppercase alphabet
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 new result set result="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 do CHKEQ^%ut($$upalpha^%ts,result)
 ;
 quit  ; end of upalpha
 ;
 ;
uac ; @TEST $$uac^%ts(%s,%c): test synonym
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 new result set result="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 do CHKEQ^%ut($$uac^%ts,result)
 ;
 quit  ; end of uac
 ;
 ;
upperAlpha ; @TEST $$upperAlpha^%ts(%s,%c): test synonym
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 new result set result="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 do CHKEQ^%ut($$upperAlpha^%ts,result)
 ;
 quit  ; end of upperAlpha
 ;
 ;
ALPHABET ; @TEST $$ALPHABET^%ts(%s,%c): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new result set result="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 do CHKEQ^%ut($$ALPHABET^%ts,result)
 ;
 quit  ; end of ALPHABET
 ;
 ;
 ;
lowalpha ; @TEST $$lowalpha^%ts(): return lowercase alphabet
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 new result set result="abcdefghijklmnopqrstuvwxyz"
 do CHKEQ^%ut($$lowalpha^%ts,result)
 ;
 quit  ; end of lowalpha
 ;
 ;
lac ; @TEST $$lac^%ts(): test synonym
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 new result set result="abcdefghijklmnopqrstuvwxyz"
 do CHKEQ^%ut($$lac^%ts,result)
 ;
 quit  ; end of lac
 ;
 ;
lowerAlpha ; @TEST $$lowerAlpha^%ts(): test synonym
 ;
 ;ven/toad;test;procedure;clean;silent;mdc
 ;
 new result set result="abcdefghijklmnopqrstuvwxyz"
 do CHKEQ^%ut($$lowerAlpha^%ts,result)
 ;
 quit  ; end of lowerAlpha
 ;
 ;
alphabet ; @TEST $$alphabet^%ts(): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new result set result="abcdefghijklmnopqrstuvwxyz"
 do CHKEQ^%ut($$alphabet^%ts,result)
 ;
 quit  ; end of alphabet
 ;
 ;
 ;
 ; Group 2: Upper Case
 ;
 ;
upcase01 ; @TEST $$upcase^%ts(%s): string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="Terrarium"                     
 new result set result="TERRARIUM"
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase01
 ;
 ;
upcase02 ; @TEST $$upcase^%ts(%s): phrase string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="Snow falls on the trees."
 new result set result="SNOW FALLS ON THE TREES."
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase02
 ;
 ;
upcase03 ; @TEST $$upcase^%ts(%s): empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase03
 ;
 ;
upcase04 ; @TEST $$upcase^%ts(%s): non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase04
 ;
 ;
upcase05 ; @TEST $$upcase^%ts(%s): mixed alpha & non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="34 trucks, 53 tractors"
 new result set result="34 TRUCKS, 53 TRACTORS"
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase05
 ;
 ;
u ; @TEST $$u^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="Terrarium"                     
 new result set result="TERRARIUM"
 do CHKEQ^%ut($$u^%ts(%s),result)
 ;
 quit  ; end of u
 ;
 ;
upperCase ; @TEST $$upperCase^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="Terrarium"                     
 new result set result="TERRARIUM"
 do CHKEQ^%ut($$upperCase^%ts(%s),result)
 ;
 quit  ; end of upperCase
 ;
 ;
 ;
 ; Group 3: Lower Case
 ;
 ;
lowcase01 ; @TEST $$lowcase^%ts(%s): string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="terrarium"
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase01
 ;
 ;
lowcase02 ; @TEST $$lowcase^%ts(%s): phrase string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="SNOW FALLS ON THE TREES."
 new result set result="snow falls on the trees."
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase02
 ;
 ;
lowcase03 ; @TEST $$lowcase^%ts(%s): empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase03
 ;
 ;
lowcase04 ; @TEST $$lowcase^%ts(%s): non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase04
 ;
 ;
lowcase05 ; @TEST $$lowcase^%ts(%s): mixed alpha & non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="34 TRUCKS, 53 TRACTORS"
 new result set result="34 trucks, 53 tractors"
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase05
 ;
 ;
l ; @TEST $$l^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="terrarium"
 do CHKEQ^%ut($$l^%ts(%s),result)
 ;
 quit  ; end of l
 ;
 ;
lowerCase ; @TEST $$lowerCase^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="terrarium"
 do CHKEQ^%ut($$lowerCase^%ts(%s),result)
 ;
 quit  ; end of lowerCase
 ;
 ;
 ;
 ; Group 4: Capital Case
 ;
 ;
capcase01 ; @TEST $$capcase^%ts(%s): uppercase string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="Terrarium"
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase01
 ;
 ;
capcase02 ; @TEST $$capcase^%ts(%s): lowercase phrase
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="snow falls on the trees."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase02
 ;
 ;
capcase03 ; @TEST $$capcase^%ts(%s): empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase03
 ;
 ;
capcase04 ; @TEST $$capcase^%ts(%s): non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase04
 ;
 ;
capcase05 ; @TEST $$capcase^%ts(%s): mixed upper & lowercase characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer Sits In The Window Seat."
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase05
 ;
 ;
c ; @TEST $$c^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer Sits In The Window Seat."
 do CHKEQ^%ut($$c^%ts(%s),result)
 ;
 quit  ; end of c
 ;
 ;
capitalCase ; @TEST $$capitalCase^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer Sits In The Window Seat."
 do CHKEQ^%ut($$capitalCase^%ts(%s),result)
 ;
 quit  ; end of capitalCase
 ;
 ;
 ;
 ;Group 5: Inverse Case
 ;
 ;
invcase01 ; @TEST $$invcase^%ts(%s): uppercase & lowercase string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="tERRARIUM"                     
 new result set result="Terrarium"
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase01
 ;
 ;
invcase02 ; @TEST $$invcase^%ts(%s): mixed-case phrase
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="sNOW fALLS oN tHE tREES."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase02
 ;
 ;
invcase03 ; @TEST $$invcase^%ts(%s): empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase03
 ;
 ;
invcase04 ; @TEST $$invcase^%ts(%s): non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase04
 ;
 ;
i ; @TEST $$i^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="sNOW fALLS oN tHE tREES."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$i^%ts(%s),result)
 ;
 quit  ; end of i
 ;
 ;
inverseCase ; @TEST $$inverseCase^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="sNOW fALLS oN tHE tREES."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$inverseCase^%ts(%s),result)
 ;
 quit  ; end of inverseCase
 ;
 ;
 ;
 ; Group 6: Sentence Case
 ;
 ;
sencase01 ; @TEST $$sencase^%ts(%s): uppercase string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="Terrarium"
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase01
 ;
 ;
sencase02 ; @TEST $$sencase^%ts(%s): lowercase phrase
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="snow falls on the trees."
 new result set result="Snow falls on the trees."
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase02
 ;
 ;
sencase03 ; @TEST $$sencase^%ts(%s): empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase03
 ;
 ;
sencase04 ; @TEST $$sencase^%ts(%s): non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase04
 ;
 ;
sencase05 ; @TEST $$sencase^%ts(%s): mixed upper & lowercase characters to Sentence
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer sits in the window seat."
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase05
 ;
 ;
sencase06 ; @TEST $$sencase^%ts(%s): more than one Sentence, different puncuation
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="hello from outer space. wish you were here! what are you doing now? nothing?"
 new result set result="Hello from outer space. Wish you were here! What are you doing now? Nothing?"
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase06
 ;
 ;
s ; @TEST $$s^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer sits in the window seat."
 do CHKEQ^%ut($$s^%ts(%s),result)
 ;
 quit  ; end of s
 ;
 ;
sentenceCase ; @TEST $$sentenceCase^%ts(%s): test synonym
 ;
 ;ven/lmry;test;procedure;clean;silent;mdc
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer sits in the window seat."
 do CHKEQ^%ut($$sentenceCase^%ts(%s),result)
 ;
 quit  ; end of sentenceCase
 ;
 ;
 ;
eor ; end of routine %tsutc
