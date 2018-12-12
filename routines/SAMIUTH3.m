SAMIUTH3 ;ven/lgc - UNIT TEST for SAMIHOM3 ; 12/11/18 7:14pm
 ;;18.0;SAMI;;
 ;
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 ;
 ; ===================== UNIT TESTS =====================
 ;
STARTUP n utsuccess
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n poo D PullUTarray^SAMIUTST(.poo,"all XXX00001 forms")
 m @root@("graph","XXX00001")=poo
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
UTWSHM ; @TEST - Testing web service for SAMI homepage test
 ; WSHOME(rtn,filter)
 n filter,rtn,nodea,nodep,arc,poo
 s filter("test")=1
 d WSHOME^SAMIHOM3(.rtn,.filter)
 m arc=rtn
 s utsuccess=1
 D PullUTarray^SAMIUTST(.poo,"UTWSHM^SAMIUTH3 test")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodea=$q(@nodea),nodep=$q(@nodep) q:(nodea="")  q:($qs(nodea,1)>60)  d  q:'utsuccess
 .; check first 60 lines of configuration.  After that the returned
 .;   array depends on test patients available
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service test FAILED!")
 q
 ;
UTWSHM1 ; @TEST - Testing web service for SAMI homepage samiroute=""
 k filter,rtn,nodea,nodep,arc,poo
 s filter("samiroute")=""
 d WSHOME^SAMIHOM3(.rtn,.filter)
 m arc=rtn
 s utsuccess=1
 D PullUTarray^SAMIUTST(.poo,"UTWSHM^SAMIUTH3 samiroute null")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodea=$q(@nodea),nodep=$q(@nodep) q:(nodea="")  d  q:'utsuccess
 . i $E($TR(@nodea,""""" "),1,10)?4N1"."2N1"."2N q
 . i (@nodea["meta content") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service null samiroute FAILED!")
 Q
 ;
UTWSHM2 ; @TEST - Testing web service for SAMI homepage dfn=1
 k filter,rtn,nodea,nodep,arc,poo
 s filter("dfn")=1
 d WSHOME^SAMIHOM3(.rtn,.filter)
 m arc=rtn
 s utsuccess=1
 D PullUTarray^SAMIUTST(.poo,"UTWSHM^SAMIUTH3 dfn=1")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodea=$q(@nodea),nodep=$q(@nodep) q:(nodea="")  d  q:'utsuccess
 . i $E($TR(@nodea,""""" "),1,10)?4N1"."2N1"."2N q
 . i (@nodea["meta content") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodep="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service dfn=1 FAILED!")
 q
 ;
UTDVHM ; @TEST - Testing temporary home page for development
 ; devhome(rtn,filter)
 n filter,rtn,poo
 d DEVHOME^SAMIHOM3(.rtn,.filter)
 D PullUTarray^SAMIUTST(.poo,"UTDVHM^SAMIUTH3")
 s utsuccess=1
 ; Check the first 60 nodes match as these represent
 ;  the parameters for the html page, but not the list
 ;  of patients - which will vary from day to day
 n cnt s cnt=0
 f  s cnt=$O(rtn(cnt)) q:cnt>60  d
 . i '(rtn(cnt)=poo(cnt)) s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing building temp home page FAILED!")
 q
 ;
UTPTLST ; @TEST - Tesing pulling all patients from vapals-patients
 ; D PATLIST(ary)
 n cnt,poo s cnt=""
 D PATLIST^SAMIHOM3("poo")
 new groot set groot=$$setroot^%wd("vapals-patients")
 s utsuccess=($D(poo)=10)
 D CHKEQ^%ut(utsuccess,1,"Testing pulling patients from vapals-patients FAILED!")
 q
 ;
UTGETHM ; @TEST - Testing pulling HTML for home.
 ;D GETHOME(rtn,filter)
 n poo,arc,nodea,nodep,filter
 s utsuccess=1
 D GETHOME^SAMIHOM3(.poo,.filter)
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTGETHM^SAMIHOM3")
 s utsuccess=1
 s nodep=$na(poo),nodea=$na(arc)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 .; if the first non space 10 characters are a date, skip
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i (@nodep["meta content") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i '(nodea="") s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing pulling HTML home page FAILED!")
 q
 ;
UTSCAN4 ; @TEST - Testing scanning array for a given entry
 ;D GETHOME(rtn,filter)
 ; S X=$$scanFor(ary,start,what)
 n from,to,str,x,rndm,poo,filter s rndm=$R(150)
 D GETHOME^SAMIHOM3(.poo,.filter)
 s str=$g(poo(rndm))
 n start s start=1
 f  s start=$$SCANFOR^SAMIHOM3(.poo,start,str) q:(start=0)  q:(start=rndm)
 s utsuccess=(start=rndm)
 D CHKEQ^%ut(utsuccess,1,"Testing scanning array for a given string FAILED!")
 q
 ;
UTNXTN ; @TEST - Testing finding next entry number for "vapals-patients"
 ; S X=$$nextNum
 n root s root=$$setroot^%wd("vapals-patients")
 n cnt,lstntry
 s cnt=0 f  s cnt=$O(@root@(cnt)) q:'+cnt  s lstntry=cnt
 s utsuccess=((lstntry+1)=$$NEXTNUM^SAMIHOM3)
 D CHKEQ^%ut(utsuccess,1,"Testing finding next entry in vapals-patients FAILED!")
 q
 ;
UTPFX ; @TEST - Testing getting study prefix
 ;$$prefix
 D CHKEQ^%ut($$PREFIX^SAMIHOM3,"XXX","Testing getting study prefix FAILED!")
 q
 ;
UTSTDID ; @TEST - Testing generating study ID
 ;$$genStudyId(nmb)
 n studyID s studyID=$$GENSTDID^SAMIHOM3(123)
 D CHKEQ^%ut(studyID,"XXX00123","Testing getting study id FAILED!")
 q
 ;
UTKEYDT ; @TEST - Testing generating key date from fm date
 ;$$keyDate(fmdt)
 n fmdt s fmdt="3181018"
 D CHKEQ^%ut($$KEYDATE^SAMIHOM3(fmdt),"2018-10-18","Testing generation of key date FAILED!")
 q
 ;
UTVALNM ; @TEST - Testing validate name function
 ;$$validateName(nm,args)
 n args,nm s args="",nm="POO"
 s x=$$VALDTNM^SAMIHOM3(nm,.args),nm="POO,poo"
 s y=$$VALDTNM^SAMIHOM3(nm,.args),utsuccess=((x+y)=0)
 D CHKEQ^%ut(utsuccess,1,"Testing validate name function FAILED!")
 q
 ;
UTINDX ; @TEST - Testing re-index of vapals-patients Graphstore
 ; d INDEX^SAMIHOM3
 n root s root=$$setroot^%wd("vapals-patients")
 s dfn1=$o(@root@("dfn",0))
 k @root@("dfn",dfn1)
 s dfn2=$o(@root@("dfn",0))
 d INDEX^SAMIHOM3
 s utsuccess=(dfn1'=dfn2)
 D CHKEQ^%ut(utsuccess,1,"Testing reindex of vapals-patients FAILED!")
 q
 ;
 ;
UTADDPT ; @TEST Testing addPatient adding a new patient to vapals-patients
 ;*** Removes XXX00001 from vapals-patients file
 ;     so kills extra nodes in ceform-2018-01-21, thus
 ;     must put these back for other unit tests
 ;     See STARTUP section in other unit test routines
 ;addPatient(dfn)
 n rootvp,rootpl,dfn,gien,studyid,gienut,rootut
 s rootvp=$$setroot^%wd("vapals-patients")
 s rootpl=$$setroot^%wd("patient-lookup")
 ;
 ; get test patient
 s rootut=$$setroot^%wd("vapals unit tests")
 s gienut=$O(@rootut@("B","patient-lookup test patient",0))
 s dfn=@rootut@(gienut,"dfn")
 ;
 ; clear test patient from vapals-patients Graphstore
 s studyid="XXX00001"
 k @rootvp@("sid",studyid)
 k @rootvp@("graph",studyid)
 k @rootvp@(dfn)
 k @rootvp@("dfn",dfn)
 ;
 ; generate new entry in vapals-patients, HTML in ^TMP("yottaForm",n)
 d ADDPAT^SAMIHOM3(dfn)
 ;
 ; check new entry in vapals-patients
 s utsuccess=($D(@rootvp@(dfn))=10),studyid=@rootvp@(dfn,"sisid")
 ;
 D CHKEQ^%ut(utsuccess,1,"Testing addPatient adding new patient to vapals-patients FAILED!")
 q
 ;
 ; builds new si-form and loads vapals-patients Graphstore
 ;  @rootvp@(dfn,"graph"), @rootvp@(dfn,"graph"), @rootvp@(dfn)
 ;     and calls PTINFO and update both Graphstore files
UTWSNC ; @TEST - Testing wsNewCase adding a new case to vapals-patients Graphstore
 ;wsNewCase(ARGS,BODY,RESULT)
 ;
 n rootvp,rootpl,rootut,gienut,dfn,bdy,saminame,ARGS,result
 n utna,uthtml,arc,poo
 s rootvp=$$setroot^%wd("vapals-patients")
 s rootpl=$$setroot^%wd("patient-lookup")
 s rootut=$$setroot^%wd("vapals unit tests")
 s gienut=$O(@rootut@("B","patient-lookup test patient",0))
 s dfn=@rootut@(gienut,"dfn")
 s saminame=@rootut@(gienut,"saminame")
 n bdy S bdy(1)="saminame="_saminame_"&dfn="_dfn
 ;
 ; clear test patient from vapals-patients Graphstore
 s studyid="XXX00001"
 k @rootvp@("sid",studyid)
 k @rootvp@("graph",studyid)
 k @rootvp@(dfn)
 k @rootvp@("dfn",dfn)
 ;
 ; generate new entry in vapals-patients
 ;   HTML result will be in ^TMP("yottaForm",n)
 d WSNEWCAS^SAMIHOM3(.ARGS,.bdy,.result)
 ;
 ; check new entry in vapals-patients
 s utna=($g(@rootvp@(dfn,"samistudyid"))=ARGS("studyid"))
 ;
 ; check HTML matches that saved in vapals unit tests
 ;  e.g. ARGS("form")="vapals:siform-2018-10-18"
 ;       ARGS("studyid")="XXX00001"
 ;  e.g. result="^TMP(""yottaForm"",20523)"
 i utna s uthtml=1 d
 . D PullUTarray^SAMIUTST(.arc,"UTWSNC^SAMIUTH3")
 . s rooty=$NA(^TMP("yottaForm",+$P(result,",",2)))
 . m poo=@rooty
 . s nodea=$na(arc),nodep=$na(poo)
 . f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 ..; skip certain lines that will contain dates
 .. i @nodep["meta content" q
 .. i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 .. i @nodep["siform"  q
 .. i $e($tr($p(@nodea,"=",2),""""),1,10)?2N1"/"2N1"/"4N q
 ..;
 .. i '($qs(nodea,1)=$qs(nodep,1)) s uthtml=0
 .. i '(@nodea=@nodep) s uthtml=0
 i '(nodea="") s uthtml=0
 ;
 s utsuccess=$S((utna+uthtml=2):1,1:0)
 D CHKEQ^%ut(utsuccess,1,"Testing wsNewCase adding new patient to vapals-patients FAILED!")
 q
 ;
 ;
UTWSVP1 ; @TEST - Test WSVAPALS API route=""
 N ARG,BODY,RESULT,route,poo,cnt,arc,filter,nodea,nodep
 ; testing route="". RESULT should have HTML
 s route="" D WSVAPALS^SAMIHOM3(.ARG,.BODY,.RESULT)
 m poo=RESULT
 ;
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTWSVP1^SAMIUTH3")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i (@nodep["meta content") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=0  FAILED!")
 q
 ;
UTWSVP2 ; @TEST - Test WSVAPALS API route="lookup"
 N ARG,BODY,RESULT,route,poo,arc,cnt,filter
 ; testing route=lookup"". RESULT should have HTML
 ; look up ELCAP patient (patient in vapals-patients
 s ARG("field")="sid",ARG("fvalue")="XXX00001"
 S ARG("samiroute")="lookup"
 D WSVAPALS^SAMIHOM3(.ARG,.BODY,.RESULT)
 m poo=RESULT
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTWSVP2^SAMIUTH3")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i (@nodep["meta content") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=lookup  FAILED!")
 q
 ;
UTWSVP3 ; @TEST - Test WSVAPALS API route="casereview"
 N ARG,BODY,RESULT,route,poo,arc,filter
 s ARG("field")="sid",ARG("fvalue")="XXX00001"
 s ARG("samiroute")="casereview"
 D WSVAPALS^SAMIHOM3(.ARG,.BODY,.RESULT)
 m poo=RESULT
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTWSVP3^SAMIUTH3")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i (@nodep["meta content") q
 . i (@nodep["XXX") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=casereview  FAILED!")
 q
 ;
UTWSVP4 ; @TEST - Test WSVAPALS API route="addform"
 N ARG,BODY,RESULT,route,poo,arc,filter
 s ARG("field")="sid",ARG("fvalue")="XXX00001"
 s ARG("samiroute")="addform"
 D WSVAPALS^SAMIHOM3(.ARG,.BODY,.RESULT)
 m poo=RESULT
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTWSVP4^SAMIUTH3")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i (@nodep["meta content") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=addform  FAILED!")
 q
 ;
UTWSVP5 ; @TEST - Test WSVAPALS API route="form"
 N ARG,BODY,RESULT,route,poo,arc,filter
 s ARG("field")="sid",ARG("fvalue")="XXX00001"
 s ARG("samiroute")="form"
 D WSVAPALS^SAMIHOM3(.ARG,.BODY,.RESULT)
 m poo=RESULT
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTWSVP5^SAMIUTH3")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i (@nodep["meta content") q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=form  FAILED!")
 q
 ;
UTSIFRM ; @TEST - Testing creating a background form
 ; d makeSiform(num)
 n root,num,sid,cdate,poo
 S num=1
 set root=$$setroot^%wd("vapals-patients")
 set sid=$get(@root@(num,"samistudyid"))
 i sid="" d  q
 . D FAIL^%ut("Error, no sid for dfn=1!")
 set cdate=$get(@root@(num,"samicreatedate"))
 i cdate="" d  q
 . D FAIL^%ut("Error, no samigratedate for dfn=1!")
 m poo=@root@("graph",sid,"siform-"_cdate)
 k @root@("graph",sid,"siform-"_cdate)
 D MKSIFORM^SAMIHOM3(num)
 ; look for Sbform
 s utsuccess=$d(@root@("graph",sid,"siform-"_cdate))
 k @root@("graph",sid,"sbform-"_cdate)
 m @root@("graph",sid,"sbform-"_cdate)=poo
 D CHKEQ^%ut(utsuccess,10,"Testing makeSiform FAILED!")
 q
 ;
UTSBFRM ; @TEST - Testing creating a background form
 ; d makeSbform(num)
 n root,num,sid,cdate
 S num=1
 set root=$$setroot^%wd("vapals-patients")
 set sid=$get(@root@(num,"samistudyid"))
 i sid="" d  q
 . D FAIL^%ut("Error, no sid for dfn=1!")
 set cdate=$get(@root@(num,"samicreatedate"))
 i cdate="" d  q
 . D FAIL^%ut("Error, no samigratedate for dfn=1!")
 k @root@("graph",sid,"sbform-"_cdate)
 D MKSBFORM^SAMIHOM3(num)
 ; look for Sbform
 s utsuccess=$d(@root@("graph",sid,"sbform-"_cdate))
 k @root@("graph",sid,"sbform-"_cdate)
 D CHKEQ^%ut(utsuccess,10,"Testing makeSbform FAILED!")
 q
 ;
EOR ;End of routine SAMIUTH3
