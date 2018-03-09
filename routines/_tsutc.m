%tsutc ;ven/lmry&mcglk&toad-type string-case: test string-case apis ^%tsc ;2018-03-09T02:38Z
 ;;1.8;Mash;
 ;
 ; This Mumps Advanced Shell (mash) routine implements unit tests for
 ; Mash String Library string-case apis in %ts. It contains no public entry
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
 ;@last-updated: 2018-03-09T02:38Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.7T03
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 :@contents
 ; Group 1: Alphabet
 ;  alpha01 = unit test for $$alphabet^%ts
 ;  ALPHA01 = unit test for $$ALPHABET^%ts
 ; Group 2: Upper Case
 ;  upcase* = unit tests for $$upcase^%ts
 ;  u01 = unit test for $$u^%ts
 ;  upper = unit test for $$upperCase^%ts
 ; Group 3: Lower Case
 ;  lowcase* = unit tests for $$lowcase^%ts
 ;  l01 = unit test for $$l^%ts
 ;  lower = unit test for $$lowerCase^%ts
 ; Group 4: Capital Case
 ;  capcase* = unit tests for $$capcase^%ts
 ;  c01 = unit test for $$c^%ts
 ;  capital = unit test for $$capitalCase^%ts
 ; Group 5: Inverse Case
 ;  invcase* = unit tests for $$invcase^%ts
 ;  i01 = unit test for $$i^%ts
 ;  inverse = unit test for $$inverseCase^%ts
 ; Group 6: Sentence Case
 ;  sencase* = unit tests for $$sencase^%ts
 ;  s01 = unit test for $$s^%ts
 ;  sentence = unit test for $$sentenceCase^%ts
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
alpha01 ; @TEST $$alphabet^%ts(): return lower case English alphabet
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new result set result="abcdefghijklmnopqrstuvwxyz"
 do CHKEQ^%ut($$alphabet^%ts,result)
 ;
 quit  ; end of alpha01
 ;
 ;
ALPHA01 ; @TEST $$ALPHABET^%ts(%s,%c): Return upper case English alphabet
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new result set result="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 do CHKEQ^%ut($$ALPHABET^%ts,result)
 ;
 quit  ; end of ALPHA01
 ;
 ;
 ;
 ; Group 2: Upper Case
 ;
 ;
upcase01 ; @TEST $$upcase^%ts(%s): Convert string to uppercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="Terrarium"                     
 new result set result="TERRARIUM"
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase01
 ;
 ;
upcase02 ; @TEST $$upcase^%ts(%s): Convert phrase string to uppercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="Snow falls on the trees."
 new result set result="SNOW FALLS ON THE TREES."
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase02
 ;
 ;
upcase03 ; @TEST $$upcase^%ts(%s): See what happens with the empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase03
 ;
 ;
upcase04 ; @TEST $$upcase^%ts(%s): what happens with non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase04
 ;
 ;
upcase05 ; @TEST $$upcase^%ts(%s): mixed alpha and non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="34 trucks, 53 tractors"
 new result set result="34 TRUCKS, 53 TRACTORS"
 do CHKEQ^%ut($$upcase^%ts(%s),result)
 ;
 quit  ; end of upcase05
 ;
 ;
u01 ; @TEST $$u^%ts(%s): Convert string to uppercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="Terrarium"                     
 new result set result="TERRARIUM"
 do CHKEQ^%ut($$u^%ts(%s),result)
 ;
 quit  ; end of u01
 ;
 ;
upper ; @TEST $$upperCase^%ts(%s): Convert string to uppercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="Terrarium"                     
 new result set result="TERRARIUM"
 do CHKEQ^%ut($$upperCase^%ts(%s),result)
 ;
 quit  ; end of upper
 ;
 ;
 ;
 ; Group 3: Lower Case
 ;
 ;
lowcase01 ; @TEST $$lowcase^%ts(%s): Convert string to lowercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="terrarium"
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase01
 ;
 ;
lowcase02 ; @TEST $$lowcase^%ts(%s): Convert phrase string to lowercase
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="SNOW FALLS ON THE TREES."
 new result set result="snow falls on the trees."
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase02
 ;
 ;
lowcase03 ; @TEST $$lowcase^%ts(%s): See what happens with the empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase03
 ;
 ;
lowcase04 ; @TEST $$lowcase^%ts(%s): what happens with non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase04
 ;
 ;
lowcase05 ; @TEST $$lowcase^%ts(%s): mixed alpha and non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="34 TRUCKS, 53 TRACTORS"
 new result set result="34 trucks, 53 tractors"
 do CHKEQ^%ut($$lowcase^%ts(%s),result)
 ;
 quit  ; end of lowcase05
 ;
 ;
l01 ; @TEST $$l^%ts(%s): Test synonym $$l^%ts
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="terrarium"
 do CHKEQ^%ut($$l^%ts(%s),result)
 ;
 quit  ; end of l01
 ;
 ;
lower ; @TEST $$lowerCase^%ts(%s): test synonym $$lowerCase^%t
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="terrarium"
 do CHKEQ^%ut($$lowerCase^%ts(%s),result)
 ;
 quit  ; end of lower
 ;
 ;
 ;
 ; Group 4: Capital Case
 ;
 ;
capcase01 ; @TEST $$capcase^%ts(%s): Convert uppercase string to Capitalized
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="Terrarium"
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase01
 ;
 ;
capcase02 ; @TEST $$capcase^%ts(%s): Convert lowercase phrase to Capitalized
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="snow falls on the trees."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase02
 ;
 ;
capcase03 ; @TEST $$capcase^%ts(%s): See what happens with the empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase03
 ;
 ;
capcase04 ; @TEST $$capcase^%ts(%s): what happens with non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase04
 ;
 ;
capcase05 ; @TEST $$capcase^%ts(%s): mixed upper and lowercase characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer Sits In The Window Seat."
 do CHKEQ^%ut($$capcase^%ts(%s),result)
 ;
 quit  ; end of capcase05
 ;
 ;
c01 ; @TEST $$c^%ts(%s): test synonym $$c^%ts
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer Sits In The Window Seat."
 do CHKEQ^%ut($$c^%ts(%s),result)
 ;
 quit  ; end of c01
 ;
 ;
capital ; @TEST $$capitalCase^%ts(%s): test synonym $$capitalCase^%ts
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer Sits In The Window Seat."
 do CHKEQ^%ut($$capitalCase^%ts(%s),result)
 ;
 quit  ; end of capital
 ;
 ;
 ;
 ;Group 5: Inverse Case
 ;
 ;
invcase01 ; @TEST $$invcase^%ts(%s): Invert uppercase and lowercase string
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="tERRARIUM"                     
 new result set result="Terrarium"
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase01
 ;
 ;
invcase02 ; @TEST $$invcase^%ts(%s): Invert mixed case phrase.
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="sNOW fALLS oN tHE tREES."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase02
 ;
 ;
invcase03 ; @TEST $$invcase^%ts(%s): See what happens with the empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase03
 ;
 ;
invcase04 ; @TEST $$invcase^%ts(%s): what happens with non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$invcase^%ts(%s),result)
 ;
 quit  ; end of invcase04
 ;
 ;
i01 ; @TEST $$i^%ts(%s): Test synonym $$i^%ts
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="sNOW fALLS oN tHE tREES."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$i^%ts(%s),result)
 ;
 quit  ; end of i01
 ;
 ;
inverse ; @TEST $$i^%ts(%s): Test synonym $$inverseCase^%ts
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="sNOW fALLS oN tHE tREES."
 new result set result="Snow Falls On The Trees."
 do CHKEQ^%ut($$inverseCase^%ts(%s),result)
 ;
 quit  ; end of inverse
 ;
 ;
 ;
 ; Group 6: Sentence Case
 ;
 ;
sencase01 ; @TEST $$sencase^%ts(%s): Convert uppercase string to Sentence case
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="TERRARIUM"                     
 new result set result="Terrarium"
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase01
 ;
 ;
sencase02 ; @TEST $$sencase^%ts(%s): Convert lowercase phrase to Sentence case
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="snow falls on the trees."
 new result set result="Snow falls on the trees."
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase02
 ;
 ;
sencase03 ; @TEST $$sencase^%ts(%s): See what happens with the empty string
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s=""
 new result set result=%s
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase03
 ;
 ;
sencase04 ; @TEST $$sencase^%ts(%s): what happens with non-alpha characters
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="23,980"
 new result set result=%s
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase04
 ;
 ;
sencase05 ; @TEST $$sencase^%ts(%s): mixed upper and lowercase characters to Sentence.
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
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
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="hello from outer space. wish you were here! what are you doing now? nothing?"
 new result set result="Hello from outer space. Wish you were here! What are you doing now? Nothing?"
 do CHKEQ^%ut($$sencase^%ts(%s),result)
 ;
 quit  ; end of sencase06
 ;
 ;
s01 ; @TEST $$s^%ts(%s): test synonym $$s^%ts
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer sits in the window seat."
 do CHKEQ^%ut($$s^%ts(%s),result)
 ;
 quit  ; end of s01
 ;
 ;
sentence ; @TEST $$sentenceCase^%ts(%s): test synonym $$sentenceCase^%ts
 ;
 ;ven/lmry;test;procedure;clean;silent;sac
 ;
 new %s set %s="JeNNifer siTs in ThE WinDow Seat."
 new result set result="Jennifer sits in the window seat."
 do CHKEQ^%ut($$sentenceCase^%ts(%s),result)
 ;
 quit  ; end of sentence
 ;
 ;
 ;
eor ; end of routine %tsutc
