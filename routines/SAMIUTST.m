SAMIUTST ;ven/lgc - Unit Test Utilities ; 7/2/19 8:15pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; Routine to push and pull information used during unit testing
 ;   of va-pals routines
 ;
 ; CHANGE 2019-06-3 ven/lgc comment out running BLDRTNS in UTCHKSM
 ;      now that routine edits have settled down
 ;   
 ;
START i $t(^%ut)="" W !,"*** UNIT TEST NOT INSTALLEd ***" Q
 d EN^%ut($t(+0),2)
 q
 ;
 q  ; No entry from top
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
 ; 
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
SVUTARR(arr,title) ;
 q:'$d(arr)
 q:($g(title)="")
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
PLUTARR(arr,title) ;
 K arr
 q:($g(title)="")
 n root s root=$$setroot^%wd("vapals unit tests")
 n gien s gien=$$GETGIEN(root,title)
 ; pull data
 m arr=@root@(gien)
 ; Now fix AGE using DOB
 n cnt set cnt=0
 for  set cnt=$order(arr(cnt)) quit:'cnt  do
 . if arr(cnt)["DOB",arr(cnt)["AGE" do
 . set arr(cnt)=$$FIXAGE^SAMIUTST(arr(cnt))
 q
 ;
 ;Enter
 ;   dfn   = dfn of patient to use as test patient
 ;   title = title of entry in "vapals unit tests"
 ;Return
 ;   pushes a copy of the patient entry in the
 ;     "patient-lookup" Graphstore into the
 ;     "vapals unit tests" Graphstore
SVTSTPT(dfn,title) ; Push a copy of test patient into vapals unit tests
 q:($G(title)="")
 q:'$G(dfn)
 n rootut s rootut=$$setroot^%wd("vapals unit tests")
 n gienut S gienut=$$GETGIEN(rootut,title)
 k @rootut@(gienut)
 s @rootut@(gienut,"title")=title
 ; load data
 n rootpl s rootpl=$$setroot^%wd("patient-lookup")
 n gienpl s gienpl=$O(@rootpl@("dfn",dfn,0))
 m @rootut@(gienut)=@rootpl@(gienpl)
 q
 ;
 ;
 ;Enter
 ;   root   = root of "vapals unit tests" Graphstore
 ;   title  = title of unit test entry
 ;Return
 ;   gien of title in "vapals unit tests"
 ;   NOTE: if this title didn't exist, it is generated
GETGIEN(root,title) ;
 n gien s gien=$o(@root@("B",title,0))
 q:gien gien
 s gien=$o(@root@("A"),-1)+1
 s @root@(gien,"title")=title
 s @root@("B",title,gien)=""
 q gien
 ;
 ;
 ; Build and save an array of all routines used
 ;  by VAPALS.  Then generate and save an array
 ;  of these routines and their present checksums
 ;  as determined by CHECK1
 ;
BLDRTNS ;
 n temp,poo,arc,cnt,str
 s cnt=0
 f  s cnt=cnt+1 s str=$p($t(RTNS+cnt),";;",2) q:str=""  d
 . S temp(cnt)=str
 d SVUTARR(.temp,"vapals routines")
 d PLUTARR(.poo,"vapals routines")
 s cnt=0
 f  s cnt=$o(poo(cnt)) q:'cnt  d
 . n X,Y S X=poo(cnt) X ^%ZOSF("RSUM1")
 . s arc(poo(cnt))=Y
 s cnt="" f  s cnt=$o(arc(cnt)) q:(cnt="")  w !,cnt," = ",arc(cnt)
 d SVUTARR(.arc,"vapals routines checksums")
 q
 ;
 ;@ppi
FIXAGE(SAMISTR) ;
 ;@input
 ;  SAMISTR = line of text
 ;@output
 ;  corrected line of text
 ;
 ; When checking that generated HTML matches that expected
 ;   it is necessary to correct the AGE of the patient 
 ;   in our saved array in case they have passed a birthday
 ;
 set SAMISTR=$get(SAMISTR)
 new X,Y,dob,dobfm,age,strg
 quit:'(SAMISTR["DOB: ") SAMISTR
 quit:'(SAMISTR["AGE: ") SAMISTR
 set dob=$piece($piece(SAMISTR,"DOB: ",2)," ")
 set X=dob do ^%DT set dobfm=Y
 quit:(dobfm<1000000)!(dobfm>9991231) SAMISTR
 set age=$$age^%th(Y)
 quit:(Y=-1) SAMISTR
 set strg=$p(SAMISTR,"AGE: ")_"AGE: "_age_" "
 set strg=strg_$piece($piece(SAMISTR,"AGE:",2)," ",3,999)
 quit strg
 ;
UTFIXAGE ; @TEST - Test that age is corrected according to dob
 n poo,age
 s poo="444-67-8924 DOB: 7/8/1956 AGE: 23 GENDER: M"
 s poo=$$FIXAGE^SAMIUTST(poo)
 s age=$$age^%th(2560708)
 s utsuccess=poo[("AGE: "_age_" ")
 d CHKEQ^%ut(utsuccess,1,"Testing correct age in string FAILED!")
 quit
 ;
 ;
UTCHKSM ; @TEST - Test VAPALS routines checksums
 n poo,arc,temp,nodea,nodet,utsuccess
 d PLUTARR(.temp,"vapals routines checksums")
 d PLUTARR(.poo,"vapals routines")
 s cnt=0,utsuccess=1
 f  s cnt=$o(poo(cnt)) q:'cnt  d
 . n X,Y S X=poo(cnt) X ^%ZOSF("RSUM1")
 . S arc(poo(cnt))=Y
 s nodea=$NA(arc),nodet=$NA(temp)
 w !,!
 f  s nodea=$q(@nodea),nodet=$q(@nodet) q:nodea=""  d
 . i '($qs(nodea,1)=$qs(nodet,1)) s utsuccess=0
 . i '(@nodea=@nodet) s utsuccess=0
 . w !,$qs(nodea,1),"-",@nodea,"   ",$qs(nodet,1),"-",@nodet
 w !,!
 i 'nodet="" s utsuccess=0
 ;
 d CHKEQ^%ut(utsuccess,1,"Testing VAPALS routines checksum FAILED!")
 q
 ;
UTSTGS ; @TEST - Save array to vapals unit tests graphstore
 n poo,arc,root,gienut,title,nodep,nodea
 s poo("TEST1")="TESTING ONE"
 s poo("TEST2")="TESTING TWO"
 s title="TEMP UNIT TEST ARRAY"
 d SVUTARR(.poo,title)
 d PLUTARR(.arc,title)
 ; KILL THE TEMPORARY ENTRY
 n rootut s rootut=$$setroot^%wd("vapals unit tests")
 n gienut s gienut=$$GETGIEN(rootut,title)
 k @rootut@(gienut)
 k @rootut@("B",title)
 s utsuccess=1
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodea=$q(@nodea),nodep=$q(@nodep) q:nodea=""  d
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i 'nodep="" s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing saving/pulling from vapals unit test graphstore FAILED!")
 q
 ;
UTSVTSTP ; @TEST - Push a copy of test patient into vapals unit tests
 n dfn s dfn=$$GET^XPAR("SYS","SAMI SYSTEM TEST PATIENT DFN",,"Q")
 n title s title="myunittest"
 ; kill entry if already existed
 n rootut s rootut=$$setroot^%wd("vapals unit tests")
 n gienut S gienut=$$GETGIEN(rootut,title)
 k @rootut@(gienut)
 ;
 d SVTSTPT(dfn,title)
 s utsuccess=(@rootut@(gienut,"dfn")=dfn)
 d CHKEQ^%ut(utsuccess,1,"Test placing test patient in unit test graphstore FAILED!")
 q
 ;
UTSVARR ; @TEST - Test push and pull of data to unit test graphstore works
 new SAMIUPOO,SAMIUARC
 set SAMIUPOO="TEST line 1"
 set SAMIUPOO="TEST line 2"
 set SAMIUPOO="TEST line 3"
 set SAMIUPOO="TEST line 4"
 do SVUTARR^SAMIUTST(.SAMIUPOO,"UTSVARR^SAMIUTST")
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTSVARR^SAMIUTST")
 n nodep,nodea
 s utsuccess=1
 s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodea=$q(nodea),nodep=$q(nodep) q:nodea=""  d  q:'utsuccess
 . if '(nodea=nodep) s utsuccess=0
 . if '(@nodea=@nodep) s utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing push/pull to unit test graph FAILED!")
 q
 ;
 ;
RTNS ;
 ;;SAMIADMN
 ;;SAMICAS2
 ;;SAMICAS3
 ;;SAMICASE
 ;;SAMICLOG
 ;;SAMICTC1
 ;;SAMICTC2
 ;;SAMICTD2
 ;;SAMICTR
 ;;SAMICTR0
 ;;SAMICTR1
 ;;SAMICTR2
 ;;SAMICTR3
 ;;SAMICTR4
 ;;SAMICTR9
 ;;SAMICTRA
 ;;SAMICTR
 ;;SAMICTRX
 ;;SAMICUL
 ;;SAMIFORM
 ;;SAMIFLD
 ;;SAMIFWS
 ;;SAMIFDM
 ;;SAMIFUL
 ;;SAMIHOM3
 ;;SAMIHOM4
 ;;SAMIFF
 ;;SAMILOG
 ;;SAMIM2M
 ;;SAMINOT1
 ;;SAMINOTI
 ;;SAMIPTLK
 ;;SAMIRU
 ;;SAMISAV
 ;;SAMISRC2
 ;;SAMIUL
 ;;SAMIUR1
 ;;SAMIUR2
 ;;SAMIUR
 ;;SAMIVST1
 ;;SAMIVST2
 ;;SAMIVST3
 ;;SAMIVST4
 ;;SAMIVST5
 ;;SAMIVSTA
 ;;SAMIVUL
 ;;SAMIUTAD
 ;;SAMIUTC1
 ;;SAMIUTC2
 ;;SAMIUTCG
 ;;SAMIUTCR
 ;;SAMIUTD2
 ;;SAMIUTF
 ;;SAMIUTFF
 ;;SAMIUTH3
 ;;SAMIUTH4
 ;;SAMIUTLG
 ;;SAMIUTNI
 ;;SAMIUTN1
 ;;SAMIUTPT
 ;;SAMIUTR0
 ;;SAMIUTR1
 ;;SAMIUTR2
 ;;SAMIUTR3
 ;;SAMIUTR4
 ;;SAMIUTR9
 ;;SAMIUTRA
 ;;SAMIUTRU
 ;;SAMIUTRX
 ;;SAMIUTS2
 ;;SAMIUTST
 ;;SAMIUTSV
 ;;SAMIUTUR
 ;;SAMIUTVA
 ;;SAMIUTVB
 ;;SAMIUTVR
 ;;SAMIUTVS
 ;
 ;
EOR ; end of routine SAMIUTST
