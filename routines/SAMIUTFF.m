SAMIUTFF ;ven/lgc - Unit test for SAMIFF ; 3/12/19 1:33pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Alexis R. Carlson (arc)
 ;  larry@fiscientific.com
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 10/26/18 7:56pm
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" q
 d EN^%ut($T(+0),2)
 q
 ;
 ;
STARTUP n utsuccess
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTPRSTSV ; @TEST - Parse TSV file and build graph
 ;
 q
 ;
EOR ;End of routine SAMIUFF
