SAMIUT7 ;ven/lgc - UNIT TEST for SAMIHL7 ;Oct 04, 2019@20:42
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
 D ^SAMIHL7
 d SUCCEED^%ut
 q
 ;
UTUPDT ; @TEST - Update patient-lookup graph
 ;UPDTPTL^SAMIHL7
 ;
 ; keep track of whether patient-lookup existed before this
 ;   unit test.  If not, delete the graph after testing
 new dien s dien=$order(^%wd(17.040801,"B","patient-lookup",0))
 ; 
 new root s root=$$setroot^%wd("patient-lookup")
 new ptien,newpat set newpat=0
 ;
 ;Build fields variable
 new field,cnt,fields
 set cnt=0
 for  set cnt=cnt+1,field=$Text(FIELDS+cnt) quit:(field["***END***")  do
 . set fields($piece($piece(field,";;",2),"^"))=$piece($piece(field,";;",2),"^",2)
 ;
 D UPDTPTL^SAMIHL7(.fields)
 ;
 ; Now look for entry in patient-lookup graph
 ;
 new ptien set ptien=$order(@root@("dfn",$get(fields("dfn")),0))
 set utsuccess=(ptien>0)
 ;if utsuccess write !,"UPDATE:A patient-lookup graph- ok"
 do CHKEQ^%ut(utsuccess,1,"UPDATE:A patient-lookup graph failed!")
 new ss s ss="",utsuccess=1
 for  set ss=$order(fields(ss)) quit:(ss="")  d  quit:'utsuccess
 . if '($data(@root@(ptien,ss))) set utsuccess=0 quit
 . if '((@root@(ptien,ss))=fields(ss)) s utsuccess=0
 ;if utsuccess write !,"UPDATE:B patient-lookup graph- ok"
 do CHKEQ^%ut(utsuccess,1,"UPDATE:B patient-lookup graph failed!")
 set utsuccess=1
 if '$order(@root@("dfn",fields("dfn"),0)) set utsuccess=0
 if '$order(@root@("ssn",fields("ssn"),0)) set utsuccess=0
 if '$order(@root@("icn",fields("icn"),0)) set utsuccess=0
 if '$order(@root@("last5",fields("last5"),0)) set utsuccess=0
 if '$order(@root@("saminame",fields("saminame"),0)) set utsuccess=0
 ;if utsuccess write !,"UPDATE:C patient-lookup graph- ok"
 do CHKEQ^%ut(utsuccess,1,"UPDATE:C patient-lookup graph failed!")
 ;
 ; Now change some fields and update again
 set fields("saminame")="Noname,HaveI"
 set fields("last5")="H0000"
 ;
 D UPDTPTL^SAMIHL7(.fields)
 set utsuccess=1
 if '(@root@(ptien,"saminame")=fields("saminame")) set utsuccess=0
 if '($order(@root@("last5","H0000",0))=ptien) set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"UPDATE:D patient-lookup graph failed!")
 ;
 ; Now delete entry in patient-lookup graph
 ;
 kill @root@(ptien)
 kill @root@("dfn",fields("dfn"),ptien)
 kill @root@("ssn",fields("ssn"),ptien)
 kill @root@("icn",fields("icn"),ptien)
 kill @root@("last5",fields("last5"),ptien)
 kill @root@("name",fields("saminame"),ptien)
 kill @root@("name",$$UP^XLFSTR(fields("saminame")),ptien)
 kill @root@("sinamel",fields("sinamel"),ptien)
 kill @root@("sinamef",fields("sinamef"),ptien)
 quit
 ;
 ;
FIELDS ;;
 ;;active duty=N
 ;;address1^1234 LOOPdLOOP DRIVE
 ;;address2^second house
 ;;address3^on the LEFT
 ;;age^99
 ;;city^Looptown
 ;;county^CIRCLE
 ;;dfn^987654321
 ;;gender^M
 ;;icn^87654321
 ;;last5^N0000
 ;;marital status^not
 ;;phon^555-555-5555
 ;;saminame^Noname,Ihave
 ;;sbdob^2018-10-03
 ;;sensitive patient^0
 ;;sex^M
 ;;sinamef^Ihave
 ;;sinamel^Noname
 ;;ssn^999990000
 ;;state^WA
 ;;zip^00000
 ;;***END***
 ;
EOR ;End of routine SAMIUT7
