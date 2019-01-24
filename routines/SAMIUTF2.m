SAMIUTF2 ;ven/lgc - UNIT TEST for SAMIFRM2 ; 1/24/19 9:16am
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
 n SAMIPOO D PLUTARR^SAMIUTST(.SAMIPOO,"all XXX00001 forms")
 m @root@("graph","XXX00001")=SAMIPOO
 q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 q
 ;
 ;
UTINITF ; @TEST - initilize form file from elcap-patient graphs
 ;D INITFRMS
 ; Find out what new form will be added
 n utroot set utroot=$$setroot^%wd("vapals-patients")
 i utroot="" d  q
 . d FAIL^%ut("Error couldn't find vapals-patients graphstore!")
 n utgroot s utgroot=$na(@utroot@("graph"))
 n utpatient set utpatient=$order(@utgroot@(""),-1)
 n utform s utform=""
 ; How manu forms does this patien have
 n allforms
 for  s utform=$order(@utgroot@(utpatient,utform)) quit:utform=""  d
 . s allforms(utform)=""
 ; now let SAMIFRM2 build the entries
 d INITFRMS^SAMIFRM2
 ; now see if there are new entries in 311.11 for
 ;   each of these forms
 s utsuccess=1
 s utform="" f  s utform=$o(allforms(utform)) q:utform=""  d
 . i '$o(^SAMI(311.11,"B",utform,0)) s utsuccess=0
 ;
 ; now delete the new entries from 311.11
 s utform="" f  s utform=$o(allforms(utform)) q:utform=""  d
 . n DIK,DIERR,DA
 . s DIK="^SAMI(311.11,"
 . s DA=$o(^SAMI(311.11,"B",utform,0))
 . i DA d ^DIK
 d CHKEQ^%ut(utsuccess,1,"Testing initialize file from elcap FAILED!")
 q
 ;
UTINITF1 ; @TEST - initialize one form named form from ary passed by name
 ;D INIT1FRM(form,ary)
 q
 ;
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
 . i $O(^SAMI(311.11,"B",uzi,0)) d
 .. n DIK,DA,DIERR
 .. s DIK="^SAMI(311.11,"
 .. s DA=$O(^SAMI(311.11,"B",uzi,0))
 .. d ^DIK
 ; Now run REGFORMS which should rebuild these
 d REGFORMS^SAMIFRM2
 ; Now check each exists again
 s utsuccess=1
 s uzi=""
 for  set uzi=$order(uftbl(uzi)) quit:uzi=""  d
 . I '($O(^SAMI(311.11,"B",uzi,0))) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing register elcap forms in mapping file FAILED!")
 q
 ;
UTLOADD ; @TEST - import directory full of json data into elcap-patient graph
 ;LOADDATA()
 ;First be sure the XXX0005 graphstore info doesn't exist
 n root,SAMIUPOO,SAMIUARC,cmd,zlist,nodea,nodep
 set root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX0005")
 ;Check that the folder and three json test files are
 ;  on our client
 s cmd="""mkdir /home/osehra/www/sample-data-UnitTest"""
 zsystem @cmd
 s dir="/home/osehra/www/sample-data-UnitTest/"
 k cmd s cmd="""ls "_dir_" > /home/osehra/www/sample-list.txt"""
 zsystem @cmd
 do file2ary^%wd("zlist","/home/osehra/www/","sample-list.txt")
 i '($g(zlist(1))="XXX0005-ceform-2016-01-01.json") d  q
 . d FAIL^%ut("Error, json files missing!")
 ;
 d LOADDATA^SAMIFRM2
 m SAMIUARC=@root@("graph","XXX0005")
 d PLUTARR^SAMIUTST(.SAMIUPOO,"UTLOADD^SAMIUTF2")
 s nodea=$na(SAMIUARC),nodep=$na(SAMIUPOO)
 f  s nodea=$q(nodea),nodep=$q(nodep) q:nodea=""  d  q:'utsuccess
 . i '(nodea=nodep) s utsuccess=0
 . i '(@nodea=@nodep) s utsuccess=0
 k @root@("graph","XXX0005")
 d CHKEQ^%ut(utsuccess,1,"Testing import json data FAILED!")
 q
 ;
UTPARSFN ; @TEST - parse filename extracting studyid & form
 ;PRSFLNM(fn,zid,zform)
 n fn,zid,zform
 s fn="XXX00001-bxform-2018-10-21"
 d PRSFLNM^SAMIFRM2(.fn,.zid,.zform)
 s utsuccess=0
 i zid="XXX00001",zform="bxform-2018-10-21" s utsuccess=1
 d CHKEQ^%ut(utsuccess,1,"Testing parse filename for studyid FAILED!")
 q
 ;
UTGETDIR ; @TEST - extrinsic which prompts for directory
 ;GETDIR(KBAIDIR,KBAIDEF)
 n dir,udtime
 s udtime=$g(DTIME)
 s DTIME=1
 s utsuccess=$$GETDIR^SAMIFRM2(.dir,"/home/osehra/www/sample-data-UnitTest")
 s DTIME=udtime
 d CHKEQ^%ut(utsuccess,1,"Testing GETDIR FAILED!")
 q
 ;
UTGETFN ; extrinsic which prompts for filename
 ;GETFN(KBAIFN,KBAIDEF)
 q
 ;
UTSSUB2 ; @TEST -  used for Dom's new style forms
 ;SAMISUB2(line,form,sid,filter,%j,zhtml)
 n SAMISID,SAMILINE,uline,SAMIFORM,SAMIFLTR,SAMIJ,SAMIZHTML
 s uline="2018-10-21 and XXX00001 AND src=/see/sami/ and href=/see/sami/ something 444-67-8924 DOB: 7/8/1956 AGE: 62 GENDER: M and  XX0002 XXX00001  false "
 s utsuccess=0
 s SAMISID="XXX00001"
 s SAMILINE="@@FORMKEY@@ and @@SID@@ AND src= and href= something"
 s SAMILINE=SAMILINE_" ST0001 and 1234567890 XX0002 VEP0001 "
 s SAMILINE=SAMILINE_" @@FROZEN@@ "
 s key="2018-10-21"
 s utsuccess=0
 d SAMISUB2^SAMIFRM2(.SAMILINE,.SAMIFORM,SAMISID,.SAMIFLTR,.SAMIJ,.SAMIZHTML)
 s SAMILINE=$e(SAMILINE,1,145),uline=$e(uline,1,145)
 i SAMILINE=uline s utsuccess=1
 d CHKEQ^%ut(utsuccess,1,"Testing SAMISUB2 used for Dom's forms FAILED!")
 q
 ;
UTWSSBF ; @TEST - background form access
 ;WSSBFORM(rtn,filter)
 n SAMIFLTR,SAMIRTN,SAMIUARC,SAMIUPOO,nodea,nodep
 s SAMIFLTR("studyid")="XXX00001"
 d WSSBFORM^SAMIFRM2(.SAMIRTN,.SAMIFLTR)
 m SAMIUARC=@SAMIRTN
 D PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSSBF^SAMIUTF2")
 s utsuccess=1
 s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i @nodep["siform" q
 . i @nodep["meta content" q
 . i '($qs(nodep,1)=$qs(nodea,1)) s utsuccess=0
 . i '(@nodep=@nodea) s utsuccess=0
 i 'nodea="" s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing background form access FAILED!")
 q
 ;
UTWSIFM ; @TEST - intake form access
 ;WSSIFORM
 n SAMIFLTR,SAMIRTN,SAMIUARC,SAMIUPOO,nodea,nodep
 s SAMIFLTR("studyid")="XXX00001"
 d WSSIFORM^SAMIFRM2(.SAMIRTN,.SAMIFLTR)
 m SAMIUARC=@SAMIRTN
 d PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSIFM^SAMIUTF2")
 s utsuccess=1
 s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i @nodep["siform" q
 . i @nodep["input value=""11/12/2018""" q
 . i @nodep["meta content" q
 . i '($qs(nodep,1)=$qs(nodea,1)) s utsuccess=0
 . i '(@nodep=@nodea) s utsuccess=0
 i 'nodea="" s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing intake form access FAILED!")
 q
 ;
UTCEFRM ; @TEST - ctevaluation form access
 ;WSCEFORM(rtn,filter)
 n SAMIFLTR,SAMIRTN,SAMIUARC,SAMIUPOO,nodea,nodep
 s SAMIFLTR("studyid")="XXX00001"
 d WSCEFORM^SAMIFRM2(.SAMIRTN,.SAMIFLTR)
 m SAMIUARC=@SAMIRTN
 d PLUTARR^SAMIUTST(.SAMIUPOO,"UTCEFRM^SAMIUTF2")
 s utsuccess=1
 s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i ($e($tr(@nodep," "),1,10)?4N1P2N1P2N) q
 . i @nodep["siform" q
 . i @nodep["meta content" q
 . i '($qs(nodep,1)=$qs(nodea,1)) s utsuccess=0
 . i '(@nodep=@nodea) s utsuccess=0
 i 'nodea="" s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing ctevaluation form access FAILED!")
 q
 ;
UTFSRC ; @TEST - fix html src lines to use resources in see/
 ;FIXSRC(SAMILINE)
 n SAMILINE,SAMILINE2
 s SAMILINE="testing FIXSRC, src=""/"" and src=""/"" end"
 s SAMILINE2="testing FIXSRC, src=""/see/sami/"" and src=""/see/sami/"" end"
 d FIXSRC^SAMIFRM2(.SAMILINE)
 s utsuccess=(SAMILINE=SAMILINE2)
 d CHKEQ^%ut(utsuccess,1,"Testing fix src SAMILINEs FAILED!")
 q
 ;
UTFHREF ; fix html href SAMILINEs to use resources in see/
 ; FIXHREF(SAMILINE)
 n SAMILINE,SAMILINE2
 s SAMILINE="Some text then hfrf="""" for a test"
 d FIXHREF^SAMIFRM2(.SAMILINE)
 q
 ;
UTGLST5 ; @TEST - extrinsic returns the last5 for patient sid
 ;GETLAST5(sid)
 n sid s sid="XXX00001"
 s utsuccess=($$GETLAST5^SAMIFRM2(sid)="F8924")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns last5 FAILED!")
 q
 ;
UTGTNM ; @TEST - extrinsic returns the name for patient sid
 ;GETNAME(sid)
 n sid s sid="XXX00001"
 s utsuccess=($$GETNAME^SAMIFRM2(sid)="Fourteen,Patient N")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns name FAILED!")
 q
 ;
UTGSSN ; @TEST - extrinsic returns the ssn for patient sid
 ;GETSSN(sid)
 n sid s sid="XXX00001"
 s utsuccess=($$GETSSN^SAMIFRM2(sid)="444-67-8924")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns ssn FAILED!")
 q
 ;
UTGETHDR ; @TEST - extrinsic returns header string for patient sid
 ;GETHDR(sid)
 n sid s sid="XXX00001"
 s utsuccess=($$GETHDR^SAMIFRM2(sid)="444-67-8924 DOB: 7/8/1956 AGE: 62 GENDER: M")
 d CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns header FAILED!")
 q
 ;
EOR ;End of routine SAMIUTF2
