SAMIUTPT ;ven/arc - UNIT TEST for SAMIPTLK ; 20181031T1854Z
 ;;18.0;SAMI;;
 ;
 ;
START
 if $T(^%ut)="" do
 . write !,"*** UNIT TEST NOT INSTALLED ***"
 . quit
 ;
 do EN^%ut($text(+0),3)
 quit
 ;
 ;
STARTUP
 new utsuccess
 quit
 ;
 ;
SETUP
 new rtn,filter,ary,expect,result
 quit
 ;
 ;
TEARDOWN ; ZEXCEPT: rtn,filter,ary,expect,result
 kill rtn,filter,ary,expect,result
 quit
 ;
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 quit
 ;
 ;
UTWSPTLK ; @TEST wsPtLookup^SAMIPTLK
 ; Comments
 ;
 ; Test query string = ""
 set filter("search")=""
 do wsPtLookup^SAMIPTLK(.rtn,.filter)
 new result,expect
 set expect="{""1"":""-1^No patient specified.""}"
 set result=rtn(1)
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "ZZZZ"
 kill rtn,filter
 set filter("search")="ZZZZ"
 do wsPtLookup^SAMIPTLK(.rtn,.filter)
 set expect="{""1"":""""}"
 set result=rtn(1)
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "A"
 kill rtn,filter
 set filter("search")="A"
 do wsPtLookup^SAMIPTLK(.rtn,.filter)
 ; Check first node of rtn
 set expect="{""1"":"
 set result=rtn(1)
 do CHKEQ^%ut(result,expect)
 ; Check last node of rtn
 set expect="""}"
 set result=rtn($order(rtn(""),-1))
 do CHKEQ^%ut(result,expect)
 ;
 ; 
 quit
 ;
 ;
UTWSPTLC ; @TEST wsPtLkup^SAMIPTLK
 ; Comments
 ;
 ; Test query string = ""
 set filter("search")=""
 do wsPtLkup^SAMIPTLK(.rtn,.filter)
 ; Check first node of rtn
 set expect="{""result"":"
 set result=$piece(rtn(1),"[")
 do CHKEQ^%ut(result,expect)
 ; Check last node of rtn
 set expect="}"
 set result=$piece(rtn($order(rtn(""),-1)),"]",2)
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "ZZZZ"
 kill rtn,filter
 set filter("search")="ZZZZ"
 do wsPtLkup^SAMIPTLK(.rtn,.filter)
 set expect=""
 set result=$get(rtn(1))
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "A"
 kill rtn,filter
 set filter("search")="A"
 do wsPtLkup^SAMIPTLK(.rtn,.filter)
 ; Check first node of rtn
 set expect="{""result"":"
 set result=$piece(rtn(1),"[")
 do CHKEQ^%ut(result,expect)
 ; Check last node of rtn
 set expect="}"
 set result=$piece(rtn($order(rtn(""),-1)),"]",2)
 do CHKEQ^%ut(result,expect)
 ;
 ; TODO: Add query using last 5
 ;
 quit
 ;
 ;
EOR ; End of routine SAMIUTPT
