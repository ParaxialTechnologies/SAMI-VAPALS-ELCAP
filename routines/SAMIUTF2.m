SAMIUTF2 ;ven/lgc - UNIT TEST for SAMIFRM2 ; 11/1/18 1:30pm
 ;;18.0;SAMI;;
 ;
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
 ;
STARTUP n utsuccess
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTINITF ; @TEST - initilize form file from elcap-patient graphs
 ;D INITFRMS
 ; Find out what new form will be added
 n utroot set utroot=$$setroot^%wd("vapals-patients")
 i utroot="" d  q
 . D FAIL^%ut("Error couldn't find vapals-patients graphstore!")
 n utgroot s utgroot=$na(@utroot@("graph"))
 n utpatient set utpatient=$order(@utgroot@(""),-1)
 n utform s utform=""
 ; How manu forms does this patien have
 n allforms
 for  s utform=$order(@utgroot@(utpatient,utform)) quit:utform=""  d
 . s allforms(utform)=""
 ; now let SAMIFRM2 build the entries
 D INITFRMS^SAMIFRM2
 ; now see if there are new entries in 311.11 for
 ;   each of these forms
 s utsuccess=1
 s utform="" f  s utform=$o(allforms(utform)) q:utform=""  d
 . i '$o(^SAMI(311.11,"B",utform,0)) s utsuccess=0
 ;
 ; now delete the new entries from 311.11
 s utform="" f  s utform=$o(allforms(utform)) q:utform=""  d
 . n DIK,DIERR,DA
 . S DIK="^SAMI(311.11,"
 . S DA=$o(^SAMI(311.11,"B",utform,0))
 . i DA D ^DIK
 D CHKEQ^%ut(utsuccess,1,"Testing initialize file from elcap FAILED!")
 ;
 q
UTINITF1 ; @TEST - initialize one form named form from ary passed by name
 ;D INIT1FRM(form,ary)
 q
UTREGF ; @TEST - ; register elcap forms in form mapping file
 ;REGFORMS()
 ;Delete all entires in 311.11 for these 8 forms
 n uftbl
 s uftbl("bxform","Biopsy_Mediastinoscopy Form.html")=""
 s uftbl("ceform","CT Evaluation Form.html")=""
 s uftbl("sbform2","Background Form.html")=""
 s uftbl("fuform","Follow-up Form.html")=""
 s uftbl("siform","Intake Form.html")=""
 s uftbl("rbform","Intervention and Treatment Form.html")=""
 s uftbl("ptform","PET Evaluation Form.html")=""
 s uftbl("sintake","Schedule Contact.html")=""
 n uzi set uzi=""
 for  set uzi=$order(uftbl(uzi)) quit:uzi=""  do
 . I $O(^SAMI(311.11,"B",uzi,0)) D
 .. N DIK,DA,DIERR
 .. S DIK="^SAMI(311.11,"
 .. S DA=$O(^SAMI(311.11,"B",uzi,0))
 .. D ^DIK
 ; Now run REGFORMS which should rebuild these
 D REGFORMS^SAMIFRM2
 ; Now check each exists again
 s utsuccess=1
 s uzi=""
 for  set uzi=$order(uftbl(uzi)) quit:uzi=""  d
 . I '($O(^SAMI(311.11,"B",uzi,0))) s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing register elcap forms in mapping file FAILED!")
 q
 ;
UTLOADD ; @TEST - import directory full of json data into elcap-patient graph
 ;loadData()
 q
 ;
UTPARSFN ; @TEST - parse filename extracting studyid & form
 ;parseFileName(fn,zid,zform)
 n fn,zid,zform
 s fn="XXX00001-bxform-2018-10-21"
 d parseFileName^SAMIFRM2(.fn,.zid,.zform)
 s utsuccess=0
 i zid="XXX00001",zform="bxform-2018-10-21" s utsuccess=1
 D CHKEQ^%ut(utsuccess,1,"Testing parse filename for studyid FAILED!")
 q
 ;
UTGETDIR ; extrinsic which prompts for directory
 ;GETDIR(KBAIDIR,KBAIDEF)
 q
 ;
UTGETFN ; extrinsic which prompts for filename
 ;GETFN(KBAIFN,KBAIDEF)
 q
 ;
UTSSUB2 ; @TEST -  used for Dom's new style forms
 ;SAMISUB2(line,form,sid,filter,%j,zhtml)
 n sid,line,uline,form,filter,%j,zhtml
 s uline="2018-10-21 and XXX00001 AND src=/see/sami/ and href=/see/sami/ something 444-67-8924 DOB: 7/8/1956 AGE: 62 GENDER: M and  XX0002 XXX00001  false "
 s utsuccess=0
 s sid="XXX00001"
 s line="@@FORMKEY@@ and @@SID@@ AND src= and href= something"
 s line=line_" ST0001 and 1234567890 XX0002 VEP0001 "
 s line=line_" @@FROZEN@@ "
 s key="2018-10-21"
 s utsuccess=0
 D SAMISUB2^SAMIFRM2(.line,.form,.sid,.filter,.%j,.zhtml)
 s line=$e(line,1,145),uline=$e(uline,1,145)
 i line=uline s utsuccess=1
 D CHKEQ^%ut(utsuccess,1,"Testing SAMISUB2 used for Dom's forms FAILED!")
 q
 ;
UTWSSBF ; @TEST - background form access
 ;wsSbform(rtn,filter)
 n filter,rtn,arc,poo,nodea,nodep
 s filter("studyid")="XXX00001"
 d wsSbform^SAMIFRM2(.rtn,.filter)
 m arc=@rtn
 D PullUTarray^SAMIUTST(.poo,"UTWSSBF^SAMIUTF2")
 s utsuccess=1
 s nodep=$na(poo),nodea=$na(arc)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing background form access FAILED!")
 q
 ;
UTWSIFM ; @TEST - intake form access
 ;wsSiform
 n filter,rtn,arc,poo,nodea,nodep
 s filter("studyid")="XXX00001"
 d wsSiform^SAMIFRM2(.rtn,.filter)
 m arc=@rtn
 D PullUTarray^SAMIUTST(.poo,"UTWSIFM^SAMIUTF2")
 s utsuccess=1
 s nodep=$na(poo),nodea=$na(arc)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing intake form access FAILED!")
 q
 ;
UTCEFRM ; @TEST - ctevaluation form access
 ;wsCeform(rtn,filter)
 n filter,rtn,arc,poo,nodea,nodep
 s filter("studyid")="XXX00001"
 d wsCeform^SAMIFRM2(.rtn,.filter)
 m arc=@rtn
 D PullUTarray^SAMIUTST(.poo,"UTCEFRM^SAMIUTF2")
 s utsuccess=1
 s nodep=$na(poo),nodea=$na(arc)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 i 'nodea="" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing ctevaluation form access FAILED!")
 q
 ;
UTFSRC ; fix html src lines to use resources in see/
 ;fixSrc(line)
 n line,line2
 S line="testing fixSrc, src=""/"" and src=""/"" end"
 s line2="testing fixSrc, src=""/see/sami/"" and src=""/see/sami/"" end"
 d fixSrc^SAMIFRM2(.line)
 s utsuccess=(line=line2)
 D CHKEQ^%ut(utsuccess,1,"Testing fix src lines FAILED!")
 q
 ;
UTFHREF ; fix html href lines to use resources in see/
 ; fixHref(line)
 n line,line2
 S line="Some text then hfrf="""" for a test"
 d fixHref^SAMIFRM2(.line)
 q
 ;
UTGLST5 ; extrinsic returns the last5 for patient sid
 ;GETLAST5(sid)
 q
 ;
UTGTNM ; extrinsic returns the name for patient sid
 ;GETNAME(sid)
 q
 ;
UTGSSN ; extrinsic returns the ssn for patient sid
 ;GETSSN(sid)
 q
UTGETHDR ; extrinsic returns header string for patient sid
 ;GETHDR(sid)
 q
 ;
EOR ;End of routine SAMIUTF2
