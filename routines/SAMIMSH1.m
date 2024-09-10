SAMIMSH1 ;ven/gpl - INTEROP with Mt. Sinai ;2021-08-09t17:16z
 ;;18.0;SAMI;**5,12,18**;2020-01;
 ;mdc-e1:SAMIMSH1-2240909-E ;SAMI-18-18-b1
 ;mdc-v7;B  ;SAMI*18.0*18 SEQ #18
 ;
 ; SAMIMSH1 contains services to support interoperability at Mt. Sinai for
 ; ScreeningPlus
 ; 
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;
 ;@routine-credits
 ;
 ;@dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2024, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@update 2024-09-09t16:42z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module import/export - 
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-18
 ;@edition-date 2020-01-17
 ;@patches **18**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;
 ;@module-credits
 ;
 ;@project VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding 2017/2021, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org Paraxial Technologies (par)
 ; http://paraxialtech.com/
 ;@partner-org Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@project I-ELCAP AIRS Automated Image Reading System
 ; https://www.ielcap-airs.org
 ;@funding 2024, Mt. Sinai Hospital (msh)
 ;@partner-org par
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 
wsMSHSCH(RTN,FILTER)
 ;
 ;example items array
 ;g("ceform-2018-12-11")=""
 ;g("fuform-2018-12-11")=""
 ;g("itform-2018-12-11")=""
 ;g("siform-2018-12-11")=""
 ;g("sort",3181211,"vapals:ceform","ceform-2018-12-11","CT Evaluation")=""
 ;g("sort",3181211,"vapals:fuform","fuform-2018-12-11","Follow-up")=""
 ;g("sort",3181211,"vapals:itform","itform-2018-12-11","Intervention")=""
 ;g("type","vapals:ceform","ceform-2018-12-11","CT Evaluation")=""
 ;g("type","vapals:fuform","fuform-2018-12-11","Follow-up")=""
 ;g("type","vapals:itform","itform-2018-12-11","Intervention")=""
 ;
 ; From the intake form, we need the following fields:
 ;
 ;siadcom
 ;sicu54
 ;simdn
 ;simdp
 ;simdpid
 ;simrn
 ;sinamef
 ;sinamel
 ;siph
 ;sirs
 ;
 ;sisao
 ;
 ;sisid
 ;
 ;sisloc
 ;
 ;sivip, sisa
 n sid s sid=$g(FILTER("sid"))
 q:sid=""
 n items
 d GETITEMS^SAMICASE("items",sid)
 q:'$d(items)
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 n siform,ceform
 s siform=$o(items("si"))
 q:siform=""
 n gn s gn=$na(@root@("graph",sid,siform))
 q:'$d(@gn)
 ;M X=@gn
 ;zwr X
 ;b
 ;S RTN="success"
 n ary
 m ary(sid,siform)=@gn
 ;
 n ceform
 s ceform=$o(items("ce"))
 q:ceform=""
 n gn2 s gn2=$na(@root@("graph",sid,ceform))
 q:'$d(@gn2)
 m ary(sid,ceform)=@gn2
 ;
 ;
 ;
 d ENCODE^XLFJSON("ary","RTN")
 Q
 ;
test()
 s filter("sid")="XXX00217"
 d wsMSHSCH^SAMIMSH1(.result,.filter)
 q
 ;
 ;From the CT eval form, we need:
 ;
 ;cerads
 ;
 ;cefu
 ;
 ;cefuw
 ;
 ;cefud
SCHURL()
 ;
 N SITE
 S SITE=$$PICSITE^SAMIMOV
 Q:SITE=""
 S PARMTXT="SchedulingURL"
 ;
 n DIR set DIR(0)="F^1:230" ; free text
 set DIR("A")="SchedulingURL" ; prompt
 set DIR("B")="""" ; default
 ;
 d ^DIR
 ;
 W !,Y
 Q
 ;
EOR ; end of routine SAMIMSH1