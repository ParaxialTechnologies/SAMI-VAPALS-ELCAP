SAMIUTCG ;ven/lgc - UNIT TEST for SAMICLOG ; 4/1/19 10:34am
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
START i $t(^%ut)="" w !,"*** UNIT TEST NOT INSTALLED ***" q
 d EN^%ut($T(+0),2)
 q
 ;
 ;
STARTUP n utsuccess
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n SAMIUPOO d PLUTARR^SAMIUTST(.SAMIUPOO,"all XXX00001 forms")
 m @root@("graph","XXX00001")=SAMIUPOO
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMICLOG
 d SUCCEED^%ut
 q
 ;
UTCLOG ; @TEST - Storing change log events in vapals-patients graphstore
 ;
 n poo,pootxt,cnt s cnt=0
 s poo("sidc")="2019-03-25"
 f pootxt="silnip","silnph","silnth","silnml","silnpp","silnvd","silnot" s poo(pootxt)=1
 f  s cnt=cnt+1,pootxt=$p($t(INTKVARS+cnt^SAMICLOG),";;",2) q:(pootxt="")  d
 . s poo($p(pootxt,"^"))=cnt
 ;
 ; kill any existing changelog entries in our test patient
 n root s root=$$setroot^%wd("vapals-patients")
 s sid="XXX00001"
 s form="siform-2018-11-13"
 k @root@("graph",sid,form,"changelog")
 ; set the samifirsttime node null or changlog will not proceed
 s @root@("graph",sid,form,"samifirsttime")=""
 ;
 ; Build changelog entries
 D CLOG^SAMICLOG(sid,form,"poo")
 ;
 ; Check that changelog entries exist for our test patient
 ;
 n arc
 m arc=^%wd(17.040801,23,"graph","XXX00001","siform-2018-11-13","changelog")
 k poo D PLUTARR^SAMIUTST(.poo,"UTCLOG^SAMIUTCG")
 n nodep,nodea s nodep=$na(poo),nodea=$na(arc)
 s utsuccess=1
 f  s nodea=$q(@nodea),nodep=$q(@nodep) q:nodea=""  d
 . i '(@nodea=@nodep) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Storing change log events in vapals-patients graphstore FAILED!")
 q
 ;
 ;
EOR ;End of routine SAMIUTCG
