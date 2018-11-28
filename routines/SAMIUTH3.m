SAMIUTH3 ;ven/lgc - UNIT TEST for SAMIHOM3 ; 11/21/18 9:39am
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
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
UTPTLST ; @TEST - Tesing pulling all patients from vapals-patients
 ; D PATLIST(ary)
 n cnt,poo s cnt=""
 D PATLIST^SAMIHOM3("poo")
 new groot set groot=$$setroot^%wd("vapals-patients")
 s utsuccess=1
 f  s cnt=$O(poo(cnt)) q:(cnt="")  d  q:(utsuccess=0)
 . i '($d(@groot@("dfn",+$tr(cnt,"X"),+$tr(cnt,"X")))) d
 .. s utsuccess=0
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
 f  s start=$$scanFor^SAMIHOM3(.poo,start,str) q:(start=0)  q:(start=rndm)
 s utsuccess=(start=rndm)
 D CHKEQ^%ut(utsuccess,1,"Testing scanning array for a given string FAILED!")
 q
 ;
UTNXTN ; @TEST - Testing finding next entry number for "vapals-patients"
 ; S X=$$nextNum
 n root s root=$$setroot^%wd("vapals-patients")
 n cnt,lstntry
 s cnt=0 f  s cnt=$O(@root@(cnt)) q:'+cnt  s lstntry=cnt
 s utsuccess=((lstntry+1)=$$nextNum^SAMIHOM3)
 D CHKEQ^%ut(utsuccess,1,"Testing finding next entry in vapals-patients FAILED!")
 q
 ;
UTPFX ; @TEST - Testing getting study prefix
 ;$$prefix
 D CHKEQ^%ut($$prefix^SAMIHOM3,"XXX","Testing getting study prefix FAILED!")
 q
 ;
UTSTDID ; @TEST - Testing generating study ID
 ;$$genStudyId(nmb)
 n studyID s studyID=$$genStudyId^SAMIHOM3(123)
 D CHKEQ^%ut(studyID,"XXX00123","Testing getting study id FAILED!")
 q
 ;
UTKEYDT ; @TEST - Testing generating key date from fm date
 ;$$keyDate(fmdt)
 n fmdt s fmdt="3181018"
 D CHKEQ^%ut($$keyDate^SAMIHOM3(fmdt),"2018-10-18","Testing generation of key date FAILED!")
 q
 ;
UTVALNM ; @TEST - Testing validate name function
 ;$$validateName(nm,args)
 n args,nm s args="",nm="POO"
 s x=$$validateName^SAMIHOM3(nm,.args),nm="POO,poo"
 s y=$$validateName^SAMIHOM3(nm,.args),utsuccess=((x+y)=0)
 D CHKEQ^%ut(utsuccess,1,"Testing validate name function FAILED!")
 q
 ;
UTINDX ; @TEST - Testing re-index of vapals-patients Graphstore
 ; d index^SAMIHOM3
 n root s root=$$setroot^%wd("vapals-patients")
 s dfn1=$o(@root@("dfn",0))
 k @root@("dfn",dfn1)
 s dfn2=$o(@root@("dfn",0))
 d index^SAMIHOM3
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
 k:$L(studyid) @rootvp@("sid",studyid),@rootvp@("graph",studyid)
 k @rootvp@(dfn),@rootvp@("dfn",dfn)
 ;
 ; generate new entry in vapals-patients, HTML in ^TMP("yottaForm",n)
 d addPatient^SAMIHOM3(dfn)
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
 n rootvp,rootpl,rootut,gienut,dfn,bdy,saminame,ARGS,result,utna,uthtml
 n utna,uthtm,arc,poo
 s rootvp=$$setroot^%wd("vapals-patients")
 s rootpl=$$setroot^%wd("patient-lookup")
 s rootut=$$setroot^%wd("vapals unit tests")
 s gienut=$O(@rootut@("B","patient-lookup test patient",0))
 s dfn=@rootut@(gienut,"dfn")
 s saminame=@rootut@(gienut,"saminame")
 n bdy S bdy(1)="saminame="_saminame_"&dfn="_dfn
 ; generate new entry in vapals-patients
 ;   HTML result will be in ^TMP("yottaForm",n)
 d wsNewCase^SAMIHOM3(.ARGS,.bdy,.result)
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
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s success=0 s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=0  FAILED!")
 q
 ;
UTWSVP2 ; @TEST - Test WSVAPALS API route="lookup"
 N ARG,BODY,RESULT,route,poo,arc,cnt,filter
 ; testing route=lookup"". RESULT should have HTML
 ; look up ELCAP patient (patient in vapals-patients
 s ARG("field")="sid",ARG("fvalue")="XXX00001",route="lookup"
 D WSVAPALS^SAMIHOM3(.ARG,.BODY,.RESULT)
 m poo=RESULT
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTWSVP2^SAMIUTH3")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s success=0 s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=lookup  FAILED!")
 q
 ;
UTWSVP3 ; @TEST - Test WSVAPALS API route="casereview"
 N ARG,BODY,RESULT,route,poo,arc,filter
 s ARG("field")="sid",ARG("fvalue")="XXX00001",route="casereview"
 D WSVAPALS^SAMIHOM3(.ARG,.BODY,.RESULT)
 m poo=RESULT
 s utsuccess=1
 ; Get array saved in "vapals unit tests" for this unit test
 D PullUTarray^SAMIUTST(.arc,"UTWSVP3^SAMIUTH3")
 s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i '($qs(nodea,1)=$qs(nodep,1)) s utsuccess=0
 . i '(@nodea=@nodep) s success=0 s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing WSVAPALS route=casereview  FAILED!")
 q
 ;
 ;
 ; Testing WSVAPALS notes
 ; s vars("samiroute")=""
 ;   d GETHOME(.RESULT,.ARG) ; on error go home
 ;D GETHOME^SAMIHOM3(rtn,filter)
 ; s vars("samiroute")="lookup"
 ;   d wsLookup^SAMISRC2(.ARG,.BODY,.RESULT)
 ; s vars("samiroute")="newcase"
 ;   d wsNewCase^SAMIHOM3(.ARG,.BODY,.RESULT)
 ; s vars("samiroute")="casereview"
 ;   d wsCASE^SAMICAS2(.RESULT,.ARG)
 ; s vars("samiroute")="nuform"
 ;   d wsNuForm^SAMICAS2(.RESULT,.ARG)
 ; s vars("samiroute")="addform"
 ;   d wsNuFormPost^SAMICAS2(.ARG,.BODY,.RESULT)
 ; s vars("samiroute")="form"
 ;   d wsGetForm^%wf(.RESULT,.ARG)
 ; s vars("samiroute")="postform"
 ;   d wsPostForm^%wf(.ARG,.BODY,.RESULT)
 ; WSVAPALS(ARG,BODY,RESULT) ; vapals post web service
 q
 ;
 ;
EOR ;End of routine SAMIUTH3
