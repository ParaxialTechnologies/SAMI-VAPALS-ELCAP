SAMIUTF2 ;ven/lgc - UNIT TEST for SAMIFRM2 ; 2019-03-25T21:46Z
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: see routine SAMIUL
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ;
STARTUP new utsuccess
 new root set root=$$setroot^%wd("vapals-patients")
 kill @root@("graph","XXX00001")
 new SAMIPOO do PLUTARR^SAMIUTST(.SAMIPOO,"all XXX00001 forms")
 merge @root@("graph","XXX00001")=SAMIPOO
 quit
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 kill utsuccess
 quit
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 do ^SAMIFRM2
 do SUCCEED^%ut
 quit
 ;
UTINITF ; @TEST - initilize form file from elcap-patient graphs
 ;D INITFRMS
 ; Find out what new form will be added
 new utroot set utroot=$$setroot^%wd("vapals-patients")
 if utroot="" do  quit
 . do FAIL^%ut("Error couldn't find vapals-patients graphstore!")
 new utgroot set utgroot=$name(@utroot@("graph"))
 new utpatient set utpatient=$order(@utgroot@(""),-1)
 new utform set utform=""
 ; How many forms does this patient have
 new allforms
 for  set utform=$order(@utgroot@(utpatient,utform)) quit:utform=""  do
 . set allforms(utform)=""
 ; now let SAMIFRM2 build the entries
 do INITFRMS^SAMIFRM2
 ; now see if there are new entries in 311.11 for
 ;   each of these forms
 set utsuccess=1
 set utform="" for  set utform=$order(allforms(utform)) quit:utform=""  do
 . if '$order(^SAMI(311.11,"B",utform,0)) set utsuccess=0
 ;
 ; now delete the new entries from 311.11
 set utform="" for  set utform=$order(allforms(utform)) quit:utform=""  do
 . new DIK,DIERR,DA
 . set DIK="^SAMI(311.11,"
 . set DA=$order(^SAMI(311.11,"B",utform,0))
 . if DA do ^DIK
 do CHKEQ^%ut(utsuccess,1,"Testing initialize file from elcap FAILED!")
 quit
 ;
UTINITF1 ; @TEST - initialize one form named form from ary passed by name
 ;D INIT1FRM(form,ary)
 quit
 ;
UTREGF ; @TEST - ; register elcap forms in form mapping file
 ;REGFORMS()
 ;Delete all entires in 311.11 for these 8 forms
 new uftbl
 set uftbl("bxform","Biopsy_Mediastinoscopy Form.html")=""
 set uftbl("ceform","CT Evaluation Form.html")=""
 set uftbl("sbform2","Background Form.html")=""
 set uftbl("fuform","Follow-up Form.html")=""
 set uftbl("siform","Intake Form.html")=""
 set uftbl("rbform","Intervention and Treatment Form.html")=""
 set uftbl("ptform","PET Evaluation Form.html")=""
 set uftbl("sintake","Schedule Contact.html")=""
 new uzi set uzi=""
 for  set uzi=$order(uftbl(uzi)) quit:uzi=""  do
 . if $order(^SAMI(311.11,"B",uzi,0)) do
 .. new DIK,DA,DIERR
 .. set DIK="^SAMI(311.11,"
 .. set DA=$order(^SAMI(311.11,"B",uzi,0))
 .. do ^DIK
 ; Now run REGFORMS which should rebuild these
 do REGFORMS^SAMIFRM2
 ; Now check each exists again
 set utsuccess=1
 set uzi=""
 for  set uzi=$order(uftbl(uzi)) quit:uzi=""  do
 . if '($order(^SAMI(311.11,"B",uzi,0))) set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing register elcap forms in mapping file FAILED!")
 quit
 ;
UTLOADD ; @TEST - import directory full of json data into elcap-patient graph
 ;LOADDATA()
 ;First be sure the XXX0005 graphstore info doesn't exist
 new root,SAMIUPOO,SAMIUARC,cmd,zlist,nodea,nodep
 set root=$$setroot^%wd("vapals-patients")
 kill @root@("graph","XXX0005")
 ;Check that the folder and three json test files are
 ;  on our client
 set cmd="""mkdir /home/osehra/www/sample-data-UnitTest"""
 zsystem @cmd
 set dir="/home/osehra/www/sample-data-UnitTest/"
 kill cmd set cmd="""ls "_dir_" > /home/osehra/www/sample-list.txt"""
 zsystem @cmd
 do file2ary^%wd("zlist","/home/osehra/www/","sample-list.txt")
 if '($get(zlist(1))="XXX0005-ceform-2016-01-01.json") do  quit
 . do FAIL^%ut("Error, json files missing!")
 ;
 do LOADDATA^SAMIFRM2
 merge SAMIUARC=@root@("graph","XXX0005")
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTLOADD^SAMIUTF2")
 set nodea=$name(SAMIUARC),nodep=$name(SAMIUPOO)
 for  set nodea=$query(nodea),nodep=$query(nodep) quit:nodea=""  do  quit:'utsuccess
 . if '(nodea=nodep) set utsuccess=0
 . if '(@nodea=@nodep) set utsuccess=0
 kill @root@("graph","XXX0005")
 do CHKEQ^%ut(utsuccess,1,"Testing import json data FAILED!")
 quit
 ;
UTPARSFN ; @TEST - parse filename extracting studyid & form
 ;PRSFLNM(fn,zid,zform)
 new fn,zid,zform
 set fn="XXX00001-bxform-2018-10-21"
 do PRSFLNM^SAMIFRM2(.fn,.zid,.zform)
 set utsuccess=0
 if zid="XXX00001",zform="bxform-2018-10-21" set utsuccess=1
 do CHKEQ^%ut(utsuccess,1,"Testing parse filename for studyid FAILED!")
 quit
 ;
UTGETDIR ; @TEST - extrinsic which prompts for directory
 ;GETDIR(KBAIDIR,KBAIDEF)
 new dir,udtime
 set udtime=$get(DTIME)
 set DTIME=1
 set utsuccess=$$GETDIR^SAMIFRM2(.dir,"/home/osehra/www/sample-data-UnitTest")
 set DTIME=udtime
 do CHKEQ^%ut(utsuccess,1,"Testing GETDIR FAILED!")
 quit
 ;
UTGETFN ; extrinsic which prompts for filename
 ;GETFN(KBAIFN,KBAIDEF)
 quit
 ;
UTSSUB2 ; @TEST -  used for Dom's new style forms
 ;SAMISUB2(line,form,sid,filter,%j,zhtml)
 new SAMISID,SAMILINE,uline,SAMIFORM,SAMIFLTR,SAMIJ,SAMIZHTML
 set uline="2018-10-21 and XXX00001 AND src=/see/sami/ and href=/see/sami/ something 444-67-8924 DOB: 7/8/1956 AGE: 62 GENDER: M and  XX0002 XXX00001  false "
 set utsuccess=0
 set SAMISID="XXX00001"
 set SAMILINE="@@FORMKEY@@ and @@SID@@ AND src= and href= something"
 set SAMILINE=SAMILINE_" ST0001 and 1234567890 XX0002 VEP0001 "
 set SAMILINE=SAMILINE_" @@FROZEN@@ "
 set key="2018-10-21"
 set utsuccess=0
 do SAMISUB2^SAMIFRM2(.SAMILINE,.SAMIFORM,SAMISID,.SAMIFLTR,.SAMIJ,.SAMIZHTML)
 set SAMILINE=$extract(SAMILINE,1,145),uline=$extract(uline,1,145)
 if SAMILINE=uline set utsuccess=1
 do CHKEQ^%ut(utsuccess,1,"Testing SAMISUB2 used for Dom's forms FAILED!")
 quit
 ;
UTWSSBF ; @TEST - background form access
 ;WSSBFORM(rtn,filter)
 new SAMIFLTR,SAMIRTN,SAMIUARC,SAMIUPOO,nodea,nodep
 set SAMIFLTR("studyid")="XXX00001"
 do WSSBFORM^SAMIFRM2(.SAMIRTN,.SAMIFLTR)
 merge SAMIUARC=@SAMIRTN
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSSBF^SAMIUTF2")
 set utsuccess=1
 set nodep=$name(SAMIUPOO),nodea=$name(SAMIUARC)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do  quit:'utsuccess
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if @nodep["siform" quit
 . if @nodep["meta content" quit
 . if '($qs(nodep,1)=$qs(nodea,1)) set utsuccess=0
 . if '(@nodep=@nodea) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing background form access FAILED!")
 quit
 ;
UTWSIFM ; @TEST - intake form access
 ;WSSIFORM
 new SAMIFLTR,SAMIRTN,SAMIUARC,SAMIUPOO,nodea,nodep
 set SAMIFLTR("studyid")="XXX00001"
 do WSSIFORM^SAMIFRM2(.SAMIRTN,.SAMIFLTR)
 merge SAMIUARC=@SAMIRTN
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTWSIFM^SAMIUTF2")
 set utsuccess=1
 set nodep=$name(SAMIUPOO),nodea=$name(SAMIUARC)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do  quit:'utsuccess
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if @nodep["siform" quit
 . if @nodep["input value=""11/12/2018""" quit
 . if @nodep["meta content" quit
 . if '($qsubscript(nodep,1)=$qsubscript(nodea,1)) set utsuccess=0
 . if '(@nodep=@nodea) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing intake form access FAILED!")
 quit
 ;
UTCEFRM ; @TEST - ctevaluation form access
 ;WSCEFORM(rtn,filter)
 new SAMIFLTR,SAMIRTN,SAMIUARC,SAMIUPOO,nodea,nodep
 set SAMIFLTR("studyid")="XXX00001"
 do WSCEFORM^SAMIFRM2(.SAMIRTN,.SAMIFLTR)
 merge SAMIUARC=@SAMIRTN
 do PLUTARR^SAMIUTST(.SAMIUPOO,"UTCEFRM^SAMIUTF2")
 set utsuccess=1
 set nodep=$name(SAMIUPOO),nodea=$name(SAMIUARC)
 for  set nodep=$query(@nodep),nodea=$query(@nodea) quit:nodep=""  do  quit:'utsuccess
 . if ($extract($translate(@nodep," "),1,10)?4N1P2N1P2N) quit
 . if @nodep["siform" quit
 . if @nodep["meta content" quit
 . if '($qsubscript(nodep,1)=$qsubscript(nodea,1)) set utsuccess=0
 . if '(@nodep=@nodea) set utsuccess=0
 if 'nodea="" set utsuccess=0
 do CHKEQ^%ut(utsuccess,1,"Testing ctevaluation form access FAILED!")
 quit
 ;
UTFSRC ; @TEST - fix html src lines to use resources in see/
 ;FIXSRC(SAMILINE)
 new SAMILINE,SAMILINE2
 set SAMILINE="testing FIXSRC, src=""/"" and src=""/"" end"
 set SAMILINE2="testing FIXSRC, src=""/see/sami/"" and src=""/see/sami/"" end"
 do FIXSRC^SAMIFRM2(.SAMILINE)
 set utsuccess=(SAMILINE=SAMILINE2)
 do CHKEQ^%ut(utsuccess,1,"Testing fix src SAMILINEs FAILED!")
 quit
 ;
UTFHREF ; fix html href SAMILINEs to use resources in see/
 ; FIXHREF(SAMILINE)
 new SAMILINE,SAMILINE2
 set SAMILINE="Some text then hfrf="""" for a test"
 do FIXHREF^SAMIFRM2(.SAMILINE)
 quit
 ;
UTGLST5 ; @TEST - extrinsic returns the last5 for patient sid
 ;GETLAST5(sid)
 new sid set sid="XXX00001"
 set utsuccess=($$GETLAST5^SAMIFRM2(sid)="F8924")
 do CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns last5 FAILED!")
 quit
 ;
UTGTNM ; @TEST - extrinsic returns the name for patient sid
 ;GETNAME(sid)
 new sid set sid="XXX00001"
 set utsuccess=($$GETNAME^SAMIFRM2(sid)="Fourteen,Patient N")
 do CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns name FAILED!")
 quit
 ;
UTGSSN ; @TEST - extrinsic returns the ssn for patient sid
 ;GETSSN(sid)
 new sid set sid="XXX00001"
 set utsuccess=($$GETSSN^SAMIFRM2(sid)="444-67-8924")
 do CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns ssn FAILED!")
 quit
 ;
UTGETHDR ; @TEST - extrinsic returns header string for patient sid
 ;GETHDR(sid)
 new sid set sid="XXX00001"
 set utsuccess=($$GETHDR^SAMIFRM2(sid)="444-67-8924 DOB: 7/8/1956 AGE: 62 GENDER: M")
 do CHKEQ^%ut(utsuccess,1,"Testing extrinsic returns header FAILED!")
 quit
 ;
EOR ;End of routine SAMIUTF2
