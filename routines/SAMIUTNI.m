SAMIUTNI ;ven/lgc - UNIT TEST for SAMINOTI ; 10/30/18 9:35am
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
UTWSNOTE ; @TEST - web service which returns a text note
 ;wsNote(return,filter)
 n filter,poo,arc
 s filter("studyid")="XXX00001"
 s filter("form")="ceform-2018-10-21"
 ; pull text note
 d wsNote^SAMINOTI(.poo,.filter)
 ; get array of what text note should look like
 d PullUTarray^SAMIUTST(.arc,"UTWSNOTE^SAMIUTNI")
 ; compare the two
 n nodep,nodea s nodep=$na(poo),nodea=$na(arc)
 s utsuccess=1
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i '(@nodep=@nodea) s utsuccess=0
 i utsuccess s utsuccess=(nodea="")
 D CHKEQ^%ut(utsuccess,1,"Testing web service return a note FAILED!")
 q
 ;
UTNOTFLT ; @TEST - extrnisic which creates a note
 ;note(filter)
 n filter,root,vals,poo
 s filter("studyid")="XXX00001"
 s filter("form")="ceform-2018-10-21"
 s root=$$setroot^%wd("vapals-patients")
 s vals=$na(@root@("graph",filter("studyid"),filter("form"),"note"))
 ; kill any existing note
 k @vals
 ; build new note
 d note^SAMINOTI(.filter)
 ; pull array with what the note should look like in global
 d PullUTarray^SAMIUTST(.poo,"UTNOTFLT^SAMIUTNI")
 ; now compare the two
 s utsuccess=1
 n nodep s nodep=$na(poo)
 f  s nodep=$q(@nodep),vals=$q(@vals) q:(nodep="")  d  q:'utsuccess
 . i '(@nodep=@vals) s utsuccess=0
 i utsuccess s utsuccess=($qs(vals,6)'["note")
 D CHKEQ^%ut(utsuccess,1,"Testing extrinsic which creates note FAILED!")
 q
 ;
UTOUT ; @TEST - Testing out(ln)
 ;out(ln)
 n cnt,dest,poo
 s cnt=1,dest="poo",poo(1)="First line of test"
 n ln s ln="Second line test"
 s utsuccess=0
 D out^SAMINOTI(ln)
 s utsuccess=($g(poo(2))="Second line test")
 D CHKEQ^%ut(utsuccess,1,"Testing out(ln) adds line to array FAILED!")
 q
 ;
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 s utsuccess=0
 s arc(1)="Testing xval"
 s utsuccess=($$xval^SAMINOTI(1,"arc")="Testing xval")
 D CHKEQ^%ut(utsuccess,1,"Testing xval(var,vals) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTNI
