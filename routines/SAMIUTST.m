SAMIUTST ;ven/lgc - Unit Test Utilities ; 10/25/18 4:31pm
 ;;;SAMI;;
 ;
 ; Routine to push and pull information used during unit testing
 ;   of va-pals routines
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 quit  ; no entry from top
 ;
 ;
 ;@routine-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-07T18:48Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@module-credits
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;
 ; Enter
 ;    arr   =  name of the array of unit test data to save
 ;             e.g. "poo" for poo(1)=xxx,poo(2)=yyy
 ;                  "^TMP("yottaForm",20523)"
 ;    title =  title of the unit test
 ;             e.g. patlist-SAMIHOM3
 ;    NOTE: deletes any earlier entry under this title, thus,
 ;          title must be unique
 ; Return
 ;    loads "vapals unit tests" Graphstore under the
 ;       title entry with the data from the array
SaveUTdata(arr,title) ;
 Q:'$D(arr)
 Q:($g(title)="")
 n root s root=$$setroot^%wd("vapals unit tests")
 n gien s gien=$$Getgien(root,title)
 k @root@(gien)
 ; load data
 n cnt s cnt=""
 f  s cnt=$O(arr(cnt)) q:cnt=""  d
 . s @root@(gien,cnt)=arr(cnt)
 q
 ;
SaveUTarray(arr,title) ;
 Q:'$D(arr)
 Q:($g(title)="")
 n root s root=$$setroot^%wd("vapals unit tests")
 n gien s gien=$$Getgien(root,title)
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
PullUTdata(arr,title) ;
 k arr
 Q:($g(title)="")
 n root s root=$$setroot^%wd("vapals unit tests")
 n gien s gien=$$Getgien(root,title)
 ; pull data
 n cnt s cnt=""
 f  s cnt=$O(@root@(gien,cnt)) q:cnt=""  d
 . s arr(cnt)=@root@(gien,cnt)
 q
 ;
 ;
 ;
 ; Enter
 ;     arr   = array by reference to fill with data from Graphstore
 ;     title = title of the unit test
 ; Return
 ;     arr   = data pulled from the title entry in "vapals unit tests"
 ;             Graphstore
PullUTarr(arr,title) ;
 k arr
 Q:($g(title)="")
 n root s root=$$setroot^%wd("vapals unit tests")
 n gien s gien=$$Getgien(root,title)
 ; pull data
 m arr=@root@(gien)
 q
 ;
 ;
 ;Enter
 ;   dfn   = dfn of patient to use as test patient
 ;   title = title of entry in "vapals unit tests"
 ;Return
 ;   pushes a copy of the patient entry in the
 ;     "patient-lookup" Graphstore into the
 ;     "vapals unit tests" Graphstore
SaveTestPatient(dfn,title) ;
 Q:($g(title)="")
 q:'$g(dfn)
 n rootut s rootut=$$setroot^%wd("vapals unit tests")
 n gienut s gienut=$$Getgien(rootut,title)
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
Getgien(root,title) n gien
 n gien s gien=$O(@root@("B",title,0))
 q:gien gien
 s gien=$O(@root@("A"),-1)+1
 s @root@(gien,"title")=title
 s @root@("B",title,gien)=""
 q gien
 ;
EOR ; end of routine SAMIUTST
