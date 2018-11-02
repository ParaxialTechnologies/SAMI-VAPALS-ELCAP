SAMIUTC2 ;ven/lgc&arc - UNIT TEST for SAMISRC2 ; 20181031T1854Z
 ;;18.0;SAMI;;
 ;
 ;
START
 if $T(^%ut)="" do
 . write !,"*** UNIT TEST NOT INSTALLED ***"
 . quit
 ;
 do EN^%ut($text(+0),3)
 quit
 ;
 ;
STARTUP
 new utsuccess
 quit
 ;
 ;
SETUP
 new args,body,return,expect,result
 quit
 ;
 ;
TEARDOWN ; ZEXCEPT: args,body,return,expect,result
 kill args,body,return,expect,result
 quit
 ;
 ;
SHUTDOWN ; ZEXCEPT: utsuccess,filter,body
 kill utsuccess,filter,body
 quit
 ;
 ;
UTWSLKU ; @TEST wsLookup^SAMISRC2
 ; Comments
 ;
 ; set args("dfn")=1
 ; set args("name")="Fourteen,Patient N"
 ; set args("pt-lookup-input")="Fourteen,Patient N"
 ; set args("samiroute")="casereview"
 ; set args("studyid")="XXX00001"
 ; set body(1)="samiroute=lookup&dfn=1&name=Fourteen%2CPatient+N&studyid=XXX00001&pt-lookup-input=Fourteen%2CPatient+N"
 ;
 ; Test with no patient study ID
 set body(1)=""
 do wsLookup^SAMISRC2(.args,.body,.return)
 set expect="Patient not found"
 set result=filter("samilookuperror")
 do CHKEQ^%ut(result,expect)
 ;
 ; Test with a patient study ID
 kill args,body,return,result,expect
 set body(1)="field=sid&fvalue=XXX00001"
 do wsLookup^SAMISRC2(.args,.body,.return)
 set expect="XXX00001"
 set result=filter("studyid")
 do CHKEQ^%ut(result,expect)
 ;
 q
 ;
 ;
EOR ;End of routine SAMIUTC2
