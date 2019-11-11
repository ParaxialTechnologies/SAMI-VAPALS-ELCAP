SAMIUT7T ;ven/lgc - UNIT TEST for SAMITIU ;Oct 04, 2019@18:27
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" Q
 d EN^%ut($T(+0),2)
 q
 ;
STARTUP n utsuccess
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMITIU
 d SUCCEED^%ut
 q
 ;
UTEN ; @TEST - Saving and parsing an HL7 message
 ;EN^SAMITIU
 ;
 ;Find a message in 772 and 773 and build variables expected
 ;  when trapping an incoming message
 ;
 new ok,HLMTIENS,HLMTIEN,HLNEXT,HLNODE,HLQUIT,HL
 set HLMTIENS="A",ok=0,HLNODE="",HLQUIT="",HL("MTP")=1
 for  set HLMTIENS=$order(^HLMA(HLMTIENS),-1) do  quit:ok
 . set HL("FS")=$E(^HLMA(HLMTIENS,"MSH",1,0),4,4)
 . set:'($piece(^HLMA(HLMTIENS,"MSH",1,0),HL("FS"),9)["ACK") ok=1
 ;
 set HLMTIEN=+^HLMA(HLMTIENS,0) 
 set HL("ECH")=$piece(^HLMA(HLMTIENS,"MSH",1,0),HL("FS"),2)
 set HLNEXT="D HLNEXT^HLCSUTL"
 ;
 ; NOTE: existence of %ut during unit testing prevents
 ;   the patient-lookup graph actually being updated in SAMIHL7
 D EN^SAMITIU
 ;
 ; Now check ^KBAP("SAMITIU" global for message contents
 new node s node=$na(^KBAP("SAMITIU",0)),utsuccess=1
 for  X HLNEXT Q:HLQUIT'>0  do  quit:HLNODE=""  quit:'utsuccess
 . set node=$Q(@node)
 . set utsuccess=(@node=HLNODE) 
 do CHKEQ^%ut(utsuccess,1,"Move HL7 message to ^KBAP global failed")
 quit
 ;
 ;
EOR ;End of routine SAMIUT7T
