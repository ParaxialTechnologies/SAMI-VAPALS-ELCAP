SAMIMSH1 ;ven/gpl - INTEROP with Mt. Sanai ;2021-08-09t17:16z
 ;;18.0;SAMI;**5,12**;2020-01;
 ;;18.12
 ;
 ; 
 ; 
 ;
 quit  ; no entry from top
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
