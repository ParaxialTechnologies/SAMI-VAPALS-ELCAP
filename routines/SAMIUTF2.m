SAMIUTF2 ;ven/lgc - UNIT TEST for SAMIFRM2 ; 10/24/18 7:46pm
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
 q
UTINITF1 ; @TEST - initialize one form named form from ary passed by name
 ;D INIT1FRM(form,ary)
 q
UTREGF ; @TEST - ; register elcap forms in form mapping file
 ;REGFORMS()
 q
UTLOADD ; @TEST - import directory full of json data into elcap-patient graph
 ;loadData()
 q
 ;
UTPARSFN ; @TEST - parse filename extracting studyid & form
 ;parseFileName(fn,zid,zform)
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
UTSSUB2 ; used for Dom's new style forms
 ;SAMISUB2(line,form,sid,filter,%j,zhtml)
 q
 ;
UTWSSBF ; background form access
 ;wsSbform(rtn,filter)
 q
 ;
UTWSIFM ; intake form access
 ;wsSiform
 q
 ;
UTCEFRM ; ctevaluation form access
 ;wsCeform(rtn,filter)
 q
 ;
UTFSRC ; fix html src lines to use resources in see/
 ;fixSrc(line)
 q
 ;
UTFHREF ; fix html href lines to use resources in see/
 ; fixHref(line)
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
