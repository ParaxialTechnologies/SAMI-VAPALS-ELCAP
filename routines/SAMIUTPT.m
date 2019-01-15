SAMIUTPT ;ven/arc - Unit test for SAMIPTLK ; 1/14/19 11:39am
 ;;18.0;SAMI;;
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2018-10-31T1854Z
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;  Add query using last 5
 ;
 ; @section 1 code
 ;
START ;
 if $t(^%ut)="" do
 . write !,"*** UNIT TEST NOT INSTALLED ***"
 . quit
 ;
 do EN^%ut($text(+0),3)
 quit
 ;
 ;
STARTUP ;
 quit
 ;
 ;
SETUP ;
 new SAMIURTN,SAMIUFLTR,expect,result
 quit
 ;
 ;
TEARDOWN ; ZEXCEPT: SAMIURTN,SAMIUFLTR,expect,result
 kill SAMIURTN,SAMIUFLTR,expect,result
 quit
 ;
 ;
SHUTDOWN ;
 quit
 ;
 ;
UTWSPTLK ; @TEST WSPTLOOK^SAMIPTLK
 ; Comments
 ;
 ; Test query string = ""
 set SAMIUFLTR("search")=""
 do WSPTLOOK^SAMIPTLK(.SAMIURTN,.SAMIUFLTR)
 new result,expect
 set expect="{""1"":""-1^No patient specified.""}"
 set result=SAMIURTN(1)
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "ZZZZ"
 kill SAMIURTN,SAMIUFLTR
 set SAMIUFLTR("search")="ZZZZ"
 do WSPTLOOK^SAMIPTLK(.SAMIURTN,.SAMIUFLTR)
 set expect="{""1"":""""}"
 set result=SAMIURTN(1)
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "A"
 kill SAMIURTN,SAMIUFLTR
 set SAMIUFLTR("search")="A"
 do WSPTLOOK^SAMIPTLK(.SAMIURTN,.SAMIUFLTR)
 ; Check first node of SAMIURTN
 set expect="{""1"":"
 set result=SAMIURTN(1)
 do CHKEQ^%ut(result,expect)
 ; Check last node of SAMIURTN
 set expect="""}"
 set result=SAMIURTN($order(SAMIURTN(""),-1))
 do CHKEQ^%ut(result,expect)
 ;
 ; 
 quit
 ;
 ;
UTWSPTLC ; @TEST WSPTLKUP^SAMIPTLK
 ; Comments
 ;
 ; Test query string = ""
 set SAMIUFLTR("search")=""
 do WSPTLKUP^SAMIPTLK(.SAMIURTN,.SAMIUFLTR)
 ; Check first node of SAMIURTN
 set expect="{""result"":"
 set result=$piece(SAMIURTN(1),"[")
 do CHKEQ^%ut(result,expect)
 ; Check last node of SAMIURTN
 set expect="}"
 set result=$piece(SAMIURTN($order(SAMIURTN(""),-1)),"]",2)
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "ZZZZ"
 kill SAMIURTN,SAMIUFLTR
 set SAMIUFLTR("search")="ZZZZ"
 do WSPTLKUP^SAMIPTLK(.SAMIURTN,.SAMIUFLTR)
 set expect=""
 set result=$get(SAMIURTN(1))
 do CHKEQ^%ut(result,expect)
 ;
 ; Test query string = "A"
 kill SAMIURTN,SAMIUFLTR
 set SAMIUFLTR("search")="A"
 do WSPTLKUP^SAMIPTLK(.SAMIURTN,.SAMIUFLTR)
 ; Check first node of SAMIURTN
 set expect="{""result"":"
 set result=$piece(SAMIURTN(1),"[")
 do CHKEQ^%ut(result,expect)
 ; Check last node of SAMIURTN
 set expect="}"
 set result=$piece(SAMIURTN($order(SAMIURTN(""),-1)),"]",2)
 do CHKEQ^%ut(result,expect)
 ;
 ; TODO: Add query using last 5
 ;
 quit
 ;
 ;
EOR ; End of routine SAMIUTPT
