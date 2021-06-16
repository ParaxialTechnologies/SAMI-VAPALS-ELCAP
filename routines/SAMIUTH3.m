SAMIUTH3 ;ven/lgc - tests for SAMIHOM3,SAMIHOM4 ;2021-06-16T16:31Z
 ;;18.0;SAMI;;**12**;2020-01;
 ;;1.18.0.12-t2+i12
 ;
 ; Routine SAMIUTH3 contains tests for SAMIHOM3. They can be invoked
 ; directly by calling dmi ^SAMIUTH3, or as part of the whole SAMI
 ; auto-test suite by calling dmis ^SAMIUT or COVERAGE^SAMIUT.
 ;
 ;@license: see routine SAMIUL
 ;@documentation see SAMIHUL
 ;
 ;
 ;
 ;@section 1 test framework
 ;
 ;
 ;
 ;@dmi ^SAMIUTH3
START ; test homepage routine SAMIHOM3
 ;
 if $text(^%ut)="" do  quit
 . write !,"*** M-TEST NOT INSTALLED ***"
 . quit
 do EN^%ut($text(+0),2)
 ;
 quit  ; end of dmi ^SAMIUTH3
 ;
 ;
 ;
STARTUP ;
 ;
 new utsuccess
 D SVAPT1^SAMIUTST  ; save VA's DFN 1 patient data
 D LOADTPT^SAMIUTST  ; load test patient data
 ;
 quit
 ;
 ;
 ;
SHUTDOWN ;
 ;
 ; ZEXCEPT: utsuccess
 ;
 kill utsuccess
 D LVAPT1^SAMIUTST  ; return VA's DPT 1 patient's data
 ;
 quit
 ;
 ;
 ;
 ;@section 2 tests
 ;
 ;
 ;
UTQUIT ; @TEST exercise quit at top of routine
 ;
 do ^SAMIHOM3
 do SUCCEED^%ut
 do ^SAMIHOM4
 do SUCCEED^%ut
 ;
 quit
 ;
 ;
 ;
UTWSHM ; @TEST WSHOME web service for SAMI homepage
 ;
 ; WSHOME(SAMIURTN,SAMIUFLTR)
 ;
 new SAMIUFLTR,SAMIURTN,nodea,nodep,SAMIUARC,SAMIUPOO
 set SAMIUFLTR("test")=1
 do WSHOME^SAMIHOM3(.SAMIURTN,.SAMIUFLTR)
 merge SAMIUARC=SAMIURTN
 kill ^SAMIUT("SAMIUTH3","UTWSHM","SAMIUARC")
 merge ^SAMIUT("SAMIUTH3","UTWSHM","SAMIUARC")=SAMIUARC
 set utsuccess=1
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSHM^SAMIUTH3 test")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodea=$query(@nodea),nodep=$query(@nodep) quit:nodea=""  quit:$qsubscript(nodea,1)>60  do  quit:'utsuccess
 . ; check first 60 lines of configuration.  After that the returned
 . ;   array depends on test patients available
 . if $qsubscript(nodea,1)'=$qsubscript(nodep,1) set utsuccess=0
 . if @nodea'=@nodep set utsuccess=0
 . quit
 do CHKEQ^%ut(utsuccess,1,"Testing web service test FAILED!")
 ;
 quit
 ;
 ;
 ;
UTWSHM1 ; @TEST WSHOME web service for SAMI homepage samiroute=""
 ;
 kill SAMIUFLTR,SAMIURTN,nodea,nodep,SAMIUARC,SAMIUPOO
 set SAMIUFLTR("samiroute")=""
 do WSHOME^SAMIHOM3(.SAMIURTN,.SAMIUFLTR)
 merge SAMIUARC=SAMIURTN
 kill ^SAMIUT("SAMIUTH3","UTWSHM1","SAMIUARC")
 merge ^SAMIUT("SAMIUTH3","UTWSHM1","SAMIUARC")=SAMIUARC
 set utsuccess=1
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSHM1^SAMIUTH3 samiroute null")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodea=$query(@nodea),nodep=$query(@nodep) quit:nodea=""  do  quit:'utsuccess
 . quit:$extract($translate(@nodea,""""" "),1,10)?4N1"."2N1"."2N
 . quit:@nodea["meta content"
 . if $qsubscript(nodea,1)'=$qsubscript(nodep,1) set utsuccess=0
 . if @nodea'=@nodep set utsuccess=0
 . quit
 if nodep]"" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing web service null samiroute FAILED!")
 ;
 quit
 ;
 ;
 ;
UTWSHM2 ; @TEST WSHOME web service for SAMI homepage dfn=1
 ;
 kill SAMIUFLTR,SAMIURTN,nodea,nodep,SAMIUARC,SAMIUPOO
 set SAMIUFLTR("dfn")=1
 do WSHOME^SAMIHOM3(.SAMIURTN,.SAMIUFLTR)
 merge SAMIUARC=SAMIURTN
 kill ^SAMIUT("SAMIUTH3","UTWSHM2","SAMIUARC")
 merge ^SAMIUT("SAMIUTH3","UTWSHM2","SAMIUARC")=SAMIUARC
 set utsuccess=1
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSHM2^SAMIUTH3 dfn=1")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodea=$query(@nodea),nodep=$query(@nodep) quit:nodea=""  do  quit:'utsuccess
 . quit:$extract($translate(@nodea,""""" "),1,10)?4N1"."2N1"."2N
 . quit:@nodea["meta content"
 . if $qsubscript(nodea,1)'=$qsubscript(nodep,1) set utsuccess=0
 . if @nodea'=@nodep set utsuccess=0
 . quit
 if nodep]"" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing web service dfn=1 FAILED!")
 ;
 quit
 ;
 ;
 ;
UTDVHM ; @TEST DEVHOME temporary home page for development
 ;
 ; do DEVHOME(SAMIURTN,SAMIUFLTR)
 ;
 new SAMIUFLTR,SAMIURTN,SAMIUPOO
 do DEVHOME^SAMIHOM3(.SAMIURTN,.SAMIUFLTR)
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTDVHM^SAMIUTH3")
 set utsuccess=1
 ; Check the first 60 nodes match as these represent
 ;  the parameters for the html page, but not the list
 ;  of patients - which will vary from day to day
 new cnt set cnt=0
 for  set cnt=$order(SAMIURTN(cnt)) quit:cnt>60  do
 . if SAMIURTN(cnt)'=SAMIUPOO(cnt) set utsuccess=0
 . quit
 do CHKEQ^%ut(utsuccess,1,"Testing building temp home page FAILED!")
 ;
 quit
 ;
 ;
 ;
UTPTLST ; @TEST PATLIST pull all patients from vapals-patients
 ;
 ; do PATLIST(ary)
 ;
 new cnt,SAMIUPOO set cnt=""
 do PATLIST^SAMIHOM3("SAMIUPOO")
 new groot set groot=$$setroot^%wd("vapals-patients")
 set utsuccess=$data(SAMIUPOO)=10
 do CHKEQ^%ut(utsuccess,1,"Testing pulling patients from vapals-patients FAILED!")
 ;
 quit
 ;
 ;
 ;
UTGETHM ; @TEST GETHOME pull HTML for home
 ;
 ; do GETHOME(SAMIURTN,SAMIUFLTR)
 ;
 new SAMIUPOO,SAMIUARC,nodea,nodep,SAMIUFLTR
 set utsuccess=1
 do GETHOME^SAMIHOM3(.SAMIUPOO,.SAMIUFLTR)
 kill ^SAMIUT("SAMIUTH3","UTGETHM","SAMIUPOO")
 merge ^SAMIUT("SAMIUTH3","UTGETHM","SAMIUPOO")=SAMIUPOO
 ; Get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTGETHM^SAMIHOM3")
 set utsuccess=1
 set nodep=$name(SAMIUPOO),nodea=$name(SAMIUARC)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do  quit:'utsuccess
 . ; if the first non space 10 characters are a date, skip
 . quit:$extract($translate(@nodep," "),1,10)?4N1P2N1P2N
 . quit:@nodep["meta content"
 . if $qsubscript(nodea,1)'=$qsubscript(nodep,1) set utsuccess=0
 . if @nodea'=@nodep set utsuccess=0
 . quit
 if nodea]"" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing pulling HTML home page FAILED!")
 ;
 quit
 ;
 ;
 ;
UTSCAN4 ; @TEST SCANFOR scan array for given entry
 ;
 ; do GETHOME(SAMIURTN,SAMIUFLTR)
 ; set X=$$SCANFOR(ary,start,what)
 ;
 new SAMIUSTR,rndm,SAMIUPOO,SAMIUFLTR set rndm=$random(150)
 do GETHOME^SAMIHOM3(.SAMIUPOO,.SAMIUFLTR)
 set SAMIUSTR=$get(SAMIUPOO(rndm))
 new SAMIUSTART set SAMIUSTART=1
 for  set SAMIUSTART=$$SCANFOR^SAMIHOM3(.SAMIUPOO,SAMIUSTART,SAMIUSTR) quit:SAMIUSTART=0  quit:SAMIUSTART=rndm
 set utsuccess=SAMIUSTART=rndm
 do CHKEQ^%ut(utsuccess,1,"Testing scanning array for a given string FAILED!")
 ;
 quit
 ;
 ;
 ;
UTNXTN ; @TEST NEXTNUM find next entry number for vapals-patients
 ;
 ; set X=$$NEXTNUM
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new cnt,lstntry
 set cnt=0 for  set cnt=$order(@root@(cnt)) quit:'cnt  set lstntry=cnt
 set utsuccess=lstntry+1=$$NEXTNUM^SAMIHOM3
 do CHKEQ^%ut(utsuccess,1,"Testing finding next entry in vapals-patients FAILED!")
 ;
 quit
 ;
 ;
 ;
UTSTDID ; @TEST GENSTDID generate study ID
 ;
 ; $$GENSTDID(nmb)
 ;
 new studyID set studyID=$$GENSTDID^SAMIHOM3(123)
 do CHKEQ^%ut(studyID,"XXX00123","Testing getting study id FAILED!")
 ;
 quit
 ;
 ;
 ;
UTKEYDT ; @TEST KEYDATE generate key date from fm date
 ;
 ; $$KEYDATE(fmdt)
 ;
 new SAMIUFMDT set SAMIUFMDT="3181018"
 do CHKEQ^%ut($$KEYDATE^SAMIHOM3(SAMIUFMDT),"2018-10-18","Testing generation of key date FAILED!")
 ;
 quit
 ;
 ;
 ;
UTVALNM ; @TEST VALDTNM validate name function
 ;
 ; $$VALDTNM(nm,args)
 ;
 new SAMIUARGS,nm set SAMIUARGS="",nm="POO"
 new SAMIUX,SAMIUY
 set SAMIUX=$$VALDTNM^SAMIHOM3(nm,.SAMIUARGS)
 set nm="POO,SAMIUPOO"
 set SAMIUY=$$VALDTNM^SAMIHOM3(nm,.SAMIUARGS)
 set utsuccess=SAMIUX+SAMIUY=0
 do CHKEQ^%ut(utsuccess,1,"Testing validate name function FAILED!")
 ;
 quit
 ;
 ;
 ;
UTINDX ; @TEST INDEX re-index of vapals-patients graphstore
 ;
 ; do INDEX^SAMIHOM3
 ;
 new root,dfn1,dfn2
 set root=$$setroot^%wd("vapals-patients")
 set dfn1=$order(@root@("dfn",0))
 kill @root@("dfn",dfn1)
 set dfn2=$order(@root@("dfn",0))
 do INDEX^SAMIHOM3
 set utsuccess=dfn1'=dfn2
 do CHKEQ^%ut(utsuccess,1,"Testing reindex of vapals-patients FAILED!")
 ;
 quit
 ;
 ;
 ;
UTADDPT ; @TEST ADDPAT add new patient to vapals-patients
 ;
 ; *** Removes XXX00001 from vapals-patients file
 ;     so kills extra nodes in ceform-2018-01-21, thus
 ;     must put these back for other unit tests
 ;     See STARTUP section in other unit test routines
 ;
 ; ADDPAT(dfn)
 ;
 new rootvp,rootpl,dfn,gien,studyid,gienut,rootut
 set rootvp=$$setroot^%wd("vapals-patients")
 set rootpl=$$setroot^%wd("patient-lookup")
 ;
 ; get test patient loaded when unit tests start
 set dfn=1
 set gienut=$order(@rootpl@("dfn",dfn,0))
 ;
 ; clear test patient from vapals-patients Graphstore
 set studyid="XXX00001"
 kill @rootvp@("sid",studyid)
 kill @rootvp@("graph",studyid)
 kill @rootvp@(dfn)
 kill @rootvp@("dfn",dfn)
 ;
 ; generate new entry in vapals-patients, HTML in ^TMP("yottaForm",n)
 do ADDPAT^SAMIHOM3(dfn)
 hang 1
 ;
 ; check new entry in vapals-patients
 set utsuccess=$data(@rootvp@(dfn))=10
 set studyid=@rootvp@(dfn,"sisid")
 ;
 do CHKEQ^%ut(utsuccess,1,"Testing ADDPATient adding new patient to vapals-patients FAILED!")
 ;
 quit
 ;
 ;
 ;
UTWSNC ; @TEST WSNEWCAS add new case to vapals-patients graphstore
 ;
 ; do WSNEWCAS(ARGS,BODY,RESULT)
 ;
 ; builds new si-form and loads vapals-patients graphstore
 ;  @rootvp@(dfn,"graph"), @rootvp@(dfn,"graph"), @rootvp@(dfn)
 ;     and calls PTINFO and update both graphstore files
 ;
 new rootvp,rootpl,gien,dfn,saminame,utna,uthtml
 new SAMIUBODY,SAMIUARGS,SAMIURSLT,SAMIUARC,SAMIUPOO
 set rootvp=$$setroot^%wd("vapals-patients")
 set rootpl=$$setroot^%wd("patient-lookup")
 ; get test patient loaded when unit tests start
 set dfn=1
 set gien=$order(@rootpl@("dfn",dfn,0))
 ;
 set saminame=@rootpl@(gien,"saminame")
 new SAMIUBODY set SAMIUBODY(1)="saminame="_saminame_"&dfn="_dfn
 ;
 ; clear test patient from vapals-patients graphstore
 set studyid="XXX00001"
 kill @rootvp@("sid",studyid)
 kill @rootvp@("graph",studyid)
 kill @rootvp@(dfn)
 kill @rootvp@("dfn",dfn)
 ;
 ; generate new entry in vapals-patients
 ;   HTML result will be in ^TMP("yottaForm",n)
 do WSNEWCAS^SAMIHOM3(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 hang 2
 ;
 ; check new entry in vapals-patients
 set utna=$get(@rootvp@(dfn,"samistudyid"))=SAMIUARGS("studyid")
 set utsuccess=1
 ;
 ; check HTML matches that saved in vapals unit tests
 ;  e.g. SAMIUARGS("form")="vapals:siform-2018-10-18"
 ;       SAMIUARGS("studyid")="XXX00001"
 ;  e.g. result="^TMP(""yottaForm"",20523)"
 if utna set uthtml=1 do
 . do PLUTARR^SAMIUTST(.SAMIUARC,"UTWSNC^SAMIUTH3")
 . new rooty set rooty=$name(^TMP("yottaForm",+$piece(SAMIURSLT,",",2)))
 . set rooty=$name(^TMP("yottaForm",+$piece(SAMIURSLT,",",2)))
 . merge SAMIUPOO=@rooty
 . ;
 . set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 . for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do  quit:'utsuccess
 . . ; skip certain lines that will contain dates
 . . quit:@nodep["meta content"
 . . quit:$extract($translate(@nodep," "),1,10)?4N1P2N1P2N
 . . quit:@nodep["siform"
 . . quit:$piece($extract($translate($piece(@nodea,"=",2),""""),1,10)," ")?.N1"/".N1"/"4N
 . . quit:@nodea["4/19/2019"
 . . quit:@nodea["const frozen"
 . . quit:@nodea["const newForm"
 . . ;
 . . if $qsubscript(nodea,1)'=$qsubscript(nodep,1) set uthtml=0
 . . if @nodea'=@nodep set uthtml=0
 . . quit
 . quit
 if nodea]"" set uthtml=0
 ;
 set utsuccess=$select(utna+uthtml=2:1,1:0)
 do CHKEQ^%ut(utsuccess,1,"Testing WSNEWCAS adding new patient to vapals-patients FAILED!")
 ;
 quit
 ;
 ;
 ;
UTSIFRM ; @TEST MKSIFORM create Siform
 ;
 ; do MKSIFORM(num)
 ;
 new root,SAMIUNUM,sid,cdate,SAMIUPOO
 set SAMIUNUM=1
 set root=$$setroot^%wd("vapals-patients")
 set sid=$get(@root@(SAMIUNUM,"samistudyid"))
 if sid="" do  quit
 . do FAIL^%ut("Error, no sid for dfn=1!")
 . quit
 set cdate=$get(@root@(SAMIUNUM,"samicreatedate"))
 if cdate="" do  quit
 . do FAIL^%ut("Error, no samigratedate for dfn=1!")
 . quit
 merge SAMIUPOO=@root@("graph",sid,"siform-"_cdate)
 kill @root@("graph",sid,"siform-"_cdate)
 do MKSIFORM^SAMIHOM3(SAMIUNUM)
 ;
 ; look for Siform
 set utsuccess=$data(@root@("graph",sid,"siform-"_cdate))
 kill @root@("graph",sid,"siform-"_cdate)
 merge @root@("graph",sid,"siform-"_cdate)=SAMIUPOO
 do CHKEQ^%ut(utsuccess,10,"Testing makeSiform FAILED!")
 ;
 quit
 ;
 ;
 ;
UTSBFRM ; @TEST MKSBFORM create background form
 ;
 ; do MKSBFORM(num)
 ;
 new root,SAMIUNUM,sid,cdate
 set SAMIUNUM=1
 set root=$$setroot^%wd("vapals-patients")
 set sid=$get(@root@(SAMIUNUM,"samistudyid"))
 if sid="" do  quit
 . do FAIL^%ut("Error, no sid for dfn=1!")
 . quit
 set cdate=$get(@root@(SAMIUNUM,"samicreatedate"))
 if cdate="" do  quit
 . do FAIL^%ut("Error, no samigratedate for dfn=1!")
 . quit
 kill @root@("graph",sid,"sbform-"_cdate)
 do MKSBFORM^SAMIHOM3(SAMIUNUM)
 hang 2
 ;
 ; look for Sbform
 set utsuccess=+$data(@root@("graph",sid,"sbform-"_cdate))
 kill @root@("graph",sid,"sbform-"_cdate)
 do CHKEQ^%ut(utsuccess,10,"Testing makeSbform FAILED!")
 ;
 quit
 ;
 ; 
 ;
UTPOSTF ; TEST WSVAPALS API route="postform" build TIU
 ;
 ; No unit test at this time.  Problems with clinic and that
 ;   there may be a dfn 1 patient in file 2 so I need to manage a
 ;   path that will not generate a tiu on a real patient
 ;
 new SAMIUARG,SAMIUBODY,SAMIURSLT,route,SAMIUPOO,SAMIUARC,SAMIUFLTR
 ; get name of existing siform for our test patient
 set root=$$setroot^%wd("vapals-patients")
 new glbrt set glbrt=$name(@root@("graph","XXX00001","siform"))
 set SAMIUARG("form")=$order(@glbrt)
 ;
 kill ^TMP("UNIT TEST","UTTASK^SAMIUTVA")
 set SAMIUARG("samiroute")="postform"
 set SAMIUARG("studyid")="XXX00001"
 do WSVAPALS^SAMIHOM3(.SAMIUARG,.SAMIUBODY,.SAMIURSLT)
 hang 2
 kill ^SAMIUT("SAMIUTH3","UTPOSTF","SAMIURSLT")
 merge ^SAMIUT("SAMIUTH3","UTPOSTF","SAMIURSLT")=SAMIURSLT
 new tiuien set tiuien=$get(^TMP("UNIT TEST","UTTASK^SAMIUTVA"))
 if '$get(tiuien) do  quit
 . do FAIL^%ut("Error, New TIU note not created")
 . quit
 merge SAMIUPOO=SAMIURSLT
 set utsuccess=1
 kill ^SAMIUT("UTPOSTF","SAMIUTH3","SAMIUPOO")
 merge ^SAMIUT("UTPOSTF","SAMIUTH3","SAMIUPOO")=SAMIUPOO
 ;
 ; get array saved in "vapals unit tests" for this unit test
 do PLUTARR^SAMIUTST(.SAMIUARC,"UTPOSTF^SAMIUTH3")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do
 . quit:$extract($translate(@nodep," "),1,10)?4N1P2N1P2N
 . quit:@nodep["meta content"
 . quit:@nodep["Date of contact:"
 . quit:@nodep["Date of chart review:"
 . quit:@nodep["Date of intake discussion contact:"
 . if $qsubscript(nodea,1)'=$qsubscript(nodep,1) set utsuccess=0
 . if @nodea'=@nodep set utsuccess=0
 . quit
 if nodea]"" set utsuccess=0
 ;
 ; delete the tiu note just created
 new chkdel set chkdel=$$DELTIU^SAMIVSTA(tiuien)
 ;
 do CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS postform  FAILED!")
 ;
 quit
 ;
 ;
 ;
EOR ; end of routine SAMIUTH3
