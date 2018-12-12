SAMIUTST ;ven/lgc - Unit Test Utilities ; 12/12/18 11:23am
 ;;18.0;SAMI;;
 ;
 ; Routine to push and pull information used during unit testing
 ;   of va-pals routines
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 Q  ; No entry from top
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
 ; @last-updated: 11/1/18 1:39pm
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
 ; ***NOTE: SaveUTarray and PullUTarray will be deleted
 ;          from this routine and replaced by
 ;          SVUTARR and PLUTARR when all XINDEX work 
 ;          on unit tests is completed/lgc
 ; Enter
 ;    arr   =  name of the array of unit test data to save
 ;             e.g. "poo" for poo(1)=xxx,poo(2)=yyy
 ;                  "^TMP("yottaForm",20523)"
 ;    title =  title of the unit test
 ;             e.g. PATLIST-SAMIHOM3
 ;    NOTE: deletes any earlier entry under this title, thus,
 ;          title must be unique
 ; Return
 ;    loads "vapals unit tests" Graphstore under the
 ;       title entry with the data from the array
SaveUTarray(arr,title) ;
 Q:'$D(arr)
 Q:($g(title)="")
 n root s root=$$setroot^%wd("vapals unit tests")
 n gien s gien=$$GETGIEN(root,title)
 k @root@(gien)
 ; load data
 m @root@(gien)=arr
 q
 ;
 ;
 ; Enter
 ;     arr   = array by reference to fill with data from Graphstore
 ;     title = title of the unit test
 ; Return
 ;     arr   = data pulled from the title entry in "vapals unit tests"
 ;             Graphstore
PullUTarray(arr,title) ;
 k arr
 Q:($g(title)="")
 n root s root=$$setroot^%wd("vapals unit tests")
 n gien s gien=$$GETGIEN(root,title)
 ; pull data
 m arr=@root@(gien)
 q
 ;
 ; 
 ; Enter
 ;    ARR   =  name of the array of unit test data to save
 ;             e.g. "poo" for poo(1)=xxx,poo(2)=yyy
 ;                  "^TMP("yottaForm",20523)"
 ;    TITLE =  title of the unit test
 ;             e.g. PATLIST-SAMIHOM3
 ;    NOTE: deletes any earlier entry under this title, thus,
 ;          title must be unique
 ; Return
 ;    loads "vapals unit tests" Graphstore under the
 ;       title entry with the data from the array
SVUTARR(ARR,TITLE) ;
 Q:'$D(ARR)
 Q:($G(TITLE)="")
 N ROOT S ROOT=$$setroot^%wd("vapals unit tests")
 N GIEN s GIEN=$$GETGIEN(ROOT,TITLE)
 k @ROOT@(GIEN)
 ; load data
 M @ROOT@(GIEN)=ARR
 Q
 ;
 ;
 ; Enter
 ;     ARR   = array by reference to fill with data from Graphstore
 ;     TITLE = title of the unit test
 ; Return
 ;     ARR   = data pulled from the title entry in "vapals unit tests"
 ;             Graphstore
PLUTARR(ARR,TITLE) ;
 K ARR
 Q:($G(TITLE)="")
 N ROOT S ROOT=$$setroot^%wd("vapals unit tests")
 N GIEN S GIEN=$$GETGIEN(ROOT,TITLE)
 ; pull data
 M ARR=@ROOT@(GIEN)
 Q
 ;
 ;Enter
 ;   DFN   = dfn of patient to use as test patient
 ;   TITLE = title of entry in "vapals unit tests"
 ;Return
 ;   pushes a copy of the patient entry in the
 ;     "patient-lookup" Graphstore into the
 ;     "vapals unit tests" Graphstore
SVTSTPT(DFN,TITLE) ;
 Q:($G(TITLE)="")
 Q:'$G(DFN)
 N ROOTUT S ROOTUT=$$setroot^%wd("vapals unit tests")
 N GIENUT S GIENUT=$$GETGIEN(ROOTUT,TITLE)
 K @ROOTUT@(GIENUT)
 S @ROOTUT@(GIENUT,"title")=TITLE
 ; load data
 N ROOTPL S ROOTPL=$$setroot^%wd("patient-lookup")
 N GIENPL S GIENPL=$O(@rootpl@("dfn",DFN,0))
 M @ROOTUT@(GIENUT)=@ROOTPL@(GIENPL)
 q
 ;
 ;
 ;Enter
 ;   ROOT   = root of "vapals unit tests" Graphstore
 ;   TITLE  = title of unit test entry
 ;Return
 ;   gien of title in "vapals unit tests"
 ;   NOTE: if this title didn't exist, it is generated
GETGIEN(ROOT,TITLE) ;
 N GIEN S GIEN=$O(@ROOT@("B",TITLE,0))
 Q:GIEN GIEN
 S GIEN=$O(@ROOT@("A"),-1)+1
 S @ROOT@(GIEN,"TITLE")=TITLE
 S @ROOT@("B",TITLE,GIEN)=""
 Q GIEN
 ;
 ;
 ; Build and save an array of all routines used
 ;  by VAPALS.  Then generate and save an array
 ;  of these routines and their present checksums
 ;  as determined by CHECK1
 ;
BLDRTNS ;
 N TEMP,POO,ARC,CNT,STR
 S CNT=0
 F  S CNT=CNT+1 S STR=$P($T(RTNS+CNT),";;",2) Q:STR=""  D
 . S TEMP(CNT)=STR
 D SVUTARR(.TEMP,"vapals routines")
 D PLUTARR(.POO,"vapals routines")
 S CNT=0
 F  S CNT=$O(POO(CNT)) Q:'CNT  D
 . N X,Y S X=POO(CNT) X ^%ZOSF("RSUM1")
 . S ARC(POO(CNT))=Y
 ZWR ARC
 D SVUTARR(.ARC,"vapals routines checksums")
 Q
 ;
 ;
UTCHKSM ; @TEST - Test VAPALS routines checksums
 N POO,ARC,TEMP,NODEA,NODET,UTSUCCESS
 D PLUTARR(.TEMP,"vapals routines checksums")
 D PLUTARR(.POO,"vapals routines")
 S CNT=0,UTSUCCESS=1
 F  S CNT=$O(POO(CNT)) Q:'CNT  D
 . N X,Y S X=POO(CNT) X ^%ZOSF("RSUM1")
 . S ARC(POO(CNT))=Y
 S NODEA=$NA(ARC),NODET=$NA(TEMP)
 W !,!
 F  S NODEA=$Q(@NODEA),NODET=$Q(@NODET) Q:NODEA=""  D
 . I '($QS(NODEA,1)=$QS(NODET,1)) S UTSUCCESS=0
 . I '(@NODEA=@NODET) S UTSUCCESS=0
 . W !,$QS(NODEA,1),"-",@NODEA,"   ",$QS(NODET,1),"-",@NODET
 W !,!
 I 'NODET="" S UTSUCCESS=0
 ;
 D CHKEQ^%ut(UTSUCCESS,1,"Testing VAPALS routines checksum FAILED!")
 Q
 ;
UTSTGS ; @TEST - Save array to vapals unit tests graphstore
 N POO,ARC,ROOT,GIENUT,TITLE,NODEP,NODEA
 S POO("TEST1")="TESTING ONE"
 S POO("TEST2")="TESTING TWO"
 S TITLE="TEMP UNIT TEST ARRAY"
 D SVUTARR(.POO,TITLE)
 D PLUTARR(.ARC,TITLE)
 ; KILL THE TEMPORARY ENTRY
 N ROOTUT S ROOTUT=$$setroot^%wd("vapals unit tests")
 N GIENUT S GIENUT=$$GETGIEN(ROOTUT,TITLE)
 K @ROOTUT@(GIENUT)
 K @ROOTUT@("B",TITLE)
 S UTSUCCESS=1
 S NODEA=$NA(ARC),NODEP=$NA(POO)
 F  S NODEA=$Q(@NODEA),NODEP=$Q(@NODEP) Q:NODEA=""  D
 . I '($QS(NODEA,1)=$QS(NODEP,1)) S UTSUCCESS=0
 . I '(@NODEA=@NODEP) S UTSUCCESS=0
 I 'NODEP="" S UTSUCCESS=0
 D CHKEQ^%ut(UTSUCCESS,1,"Testing saving/pulling from vapals unit test graphstore FAILED!")
 ;
RTNS ;
 ;;SAMIM2M
 ;;KBANSCAU
 ;;SAMIADMN
 ;;SAMICAS2
 ;;SAMICTC1
 ;;SAMICTD2
 ;;SAMICTR
 ;;SAMICTR0
 ;;SAMICTR1
 ;;SAMICTR9
 ;;SAMICTRA
 ;;SAMICTRX
 ;;SAMIFRM2
 ;;SAMIHOM3
 ;;SAMINOTI
 ;;SAMIPTLK
 ;;SAMISRC2
 ;;SAMIUR1
 ;;SAMIVSTA
 ;;SAMIVSTS
 ;;SAMIRU
 ;;SAMISAV
 ;;
 ;
 ;
EOR ; end of routine SAMIUTST
