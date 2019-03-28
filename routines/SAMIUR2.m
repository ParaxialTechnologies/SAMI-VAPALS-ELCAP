SAMIUR2 ;ven/gpl - sami user reports ; 1/22/19 1:31pm
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMIUR contains the routines to generate user reports
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
RPTTBL(RPT,TYPE) ; RPT is passed by reference and returns the 
 ; report definition table. TYPE is the report type to be returned
 ; This routine could use a file or a graph in the next version
 ;
 if TYPE="followup" d  q  ;
 . S RPT(1,"header")="F/U Date"
 . S RPT(1,"routine")="$$FUDATE^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")="SSN"
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 . S RPT(4,"header")="Baseline Date"
 . S RPT(4,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(5,"header")="Recommend"
 . S RPT(5,"routine")="$$RECOM^SAMIUR2"
 . S RPT(6,"header")="When"
 . S RPT(6,"routine")="$$WHEN^SAMIUR2"
 . S RPT(7,"header")="Last Exam"
 . S RPT(7,"routine")="$$LASTEXM^SAMIUR2"
 . S RPT(8,"header")="Status"
 . S RPT(8,"routine")="$$STATUS^SAMIUR2"
 . S RPT(9,"header")="Street Addr."
 . S RPT(9,"routine")="$$STREETAD^SAMIUR2"
 if TYPE="activity" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")="SSN"
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="Study Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Type"
 . S RPT(4,"routine")="$$STUDYTYP^SAMIUR2"
 . S RPT(5,"header")="CT Protocol"
 . S RPT(5,"routine")="$$CTPROT^SAMIUR2"
 . S RPT(6,"header")="Follow up"
 . S RPT(6,"routine")="$$RECOM^SAMIUR2"
 . S RPT(7,"header")="When"
 . S RPT(7,"routine")="$$WHEN^SAMIUR2"
 . S RPT(8,"header")="on Date"
 . S RPT(8,"routine")="$$FUDATE^SAMIUR2"
 if TYPE="enrollment" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")="SSN"
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="Study Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Gender"
 . S RPT(4,"routine")="$$GENDER^SAMIUR2"
 . S RPT(5,"header")="Race"
 . S RPT(5,"routine")="$$RACE^SAMIUR2"
 . S RPT(6,"header")="Age"
 . S RPT(6,"routine")="$$AGE^SAMIUR2"
 . S RPT(7,"header")="Urban/Rural"
 . S RPT(7,"routine")="$$RURAL^SAMIUR2"
 . S RPT(8,"header")="Smoking Status"
 . S RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 if TYPE="incomplete" d  q  ;
 . S RPT(1,"header")="Enrollment date"
 . S RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")="SSN"
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 . S RPT(4,"header")="Incomplete form"
 . S RPT(4,"routine")="$$IFORM^SAMIUR2"
 if TYPE="missingct" d  q  ;
 . S RPT(1,"header")="Enrollment date"
 . S RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")="SSN"
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 ;
 q
 ;
DFN2SID(DFN) ;extrinsic returns the studyid for patient DFN
 n root s root=$$setroot^%wd("vapals-patients")
 q $g(@root@(DFN,"sisid"))
 ;
FUDATE(zdt,dfn,SAMIPATS) ; extrinsic returns followup date
 n fud
 s fud="fudate"
 q $g(SAMIPATS(zdt,dfn,"cefud"))
 ;
NAME(zdt,dfn,SAMIPATS) ; extrinsic returns the name including a hyperlink
 n nam
 s nam="Name"
 q $g(SAMIPATS(zdt,dfn,"nuhref"))
 ;
SSN(zdt,dfn,SAMIPATS) ; extrinsic returns SSN
 n ssn
 s ssn="ssn"
 q $g(SAMIPATS(zdt,dfn,"ssn"))
 ;
BLINEDT(zdt,dfn,SAMIPATS) ; extrinsic returns Baseline Date
 n bldt
 s bldt=$g(SAMIPATS(zdt,dfn,"edate"))
 q bldt
 ;
RECOM(zdt,dfn,SAMIPATS) ; extrinsic returns Recommendation
 n recom
 s recom="Full Diagnostic CT"
 q recom
 ;
WHEN(zdt,dfn,SAMIPATS) ; extrinsic returns followup text ie. "in one year"
 n root s root=$$setroot^%wd("vapals-patients")
 n ceform s ceform=$g(SAMIPATS(zdt,dfn,"ceform"))
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 q:ceform="" ""
 n vals s vals=$na(@root@("graph",sid,ceform))
 n DICT
 s DICT("cefuw","1m")="in one month"
 s DICT("cefuw","1y")="in one year"
 s DICT("cefuw","3m")="in three months"
 s DICT("cefuw","6m")="in six months"
 s DICT("cefuw","os")="other as specified"
 n whnx s whnx=$g(@vals@("cefuw"))
 q:whnx="" ""
 s whn=$g(DICT("cefuw",whnx))
 q whn
 ;
LASTEXM(zdt,dfn,SAMIPATS) ; extrinsic returns patient last exam
 n lexm
 s lexm=$g(SAMIPATS(zdt,dfn,"cedos"))
 q lexm
 ;
STATUS(zdt,dfn,SAMIPATS) ; extrinsic returns patient status
 n stat
 n root s root=$$setroot^%wd("vapals-patients")
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 n siform s siform=$g(SAMIPATS(zdt,dfn,"siform"))
 n vals s vals=$na(@root@("graph",sid,siform))
 s stat=$g(@vals@("sistatus"))
 q stat
 ;
STREETAD(zdt,dfn,SAMIPATS) ; extrinsic returns patient street address
 n staddr
 n root s root=$$setroot^%wd("vapals-patients")
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 n siform s siform=$g(SAMIPATS(zdt,dfn,"siform"))
 n vals s vals=$na(@root@("graph",sid,siform))
 s staddr=$g(@vals@("sipsa"))
 q staddr
 ;
STUDYDT(zdt,dfn,SAMIPATS) ; extrinsic returns the lastest Study Date
 n stdt
 s stdt=$g(SAMIPATS(zdt,dfn,"cedos"))
 q stdt
 ;
STUDYTYP(zdt,dfn,SAMIPATS) ; extrinsic returns the latest Study Type
 n root s root=$$setroot^%wd("vapals-patients")
 n ceform s ceform=$g(SAMIPATS(zdt,dfn,"ceform"))
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 q:ceform="" ""
 n vals s vals=$na(@root@("graph",sid,ceform))
 n stypx,styp
 s stypx=$g(@vals@("cetex"))
 s styp=$s(stypx="a":"Annual",stypx="b":"Baseline",stypx="d":"Followup",1:"")
 q styp
 ;
CTPROT(zdt,dfn,SAMIPATS) ; extrinsic returns the CT Protocol
 n root s root=$$setroot^%wd("vapals-patients")
 n ceform s ceform=$g(SAMIPATS(zdt,dfn,"ceform"))
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 q:ceform="" ""
 n vals s vals=$na(@root@("graph",sid,ceform))
 n cectp s cectp=$g(@vals@("cectp"))
 n ctyp
 s ctyp=$s(cectp="l":"Low-Dose CT",cectp="d":"Standard CT",cectp="i":"Limited",1:"")
 q ctyp
 ;
GENDER(zdt,dfn,SAMIPATS) ; extrinsic returns gender
 n root s root=$$setroot^%wd("vapals-patients")
 n gend
 s gend=$g(@root@(dfn,"gender"))
 q:gend="" ""
 s gend=$p(gend,"^",2)
 q gend
 ;
RACE(zdt,dfn,SAMIPATS) ; extrinsic returns race
 n root s root=$$setroot^%wd("vapals-patients")
 n race s race=$g(@root@(dfn,"race"))
 q:race=""
 q race
 ;
ETHNCTY(zdt,dfn,SAMIPATS) ; extrinsic returns ethnicity
 q "ethnicity"
 ;
AGE(zdt,dfn,SAMIPATS) ; extrinsic returns age
 n root s root=$$setroot^%wd("vapals-patients")
 n dob,age
 set dob=$get(@root@(dfn,"sbdob")) ; dob in VAPALS format
 ;
 new X,Y
 set X=dob
 do ^%DT
 set age=$piece($$FMDIFF^XLFDT($$NOW^XLFDT,Y)/365,".")
 q age
 ;
SMKSTAT(zdt,dfn,SAMIPATS) ; extrinsic returns smoking status
 n root s root=$$setroot^%wd("vapals-patients")
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 n siform s siform=$g(SAMIPATS(zdt,dfn,"siform"))
 n vals s vals=$na(@root@("graph",sid,siform))
 n smk
 s smk="unknown"
 if $g(@vals@("siesn")) s smk="Never smoked"
 if $g(@vals@("siesp")) s smk="Past smoker"
 if $g(@vals@("siesc")) s smk="Current smoker"
 if $g(@vals@("siesq")) s smk="Current smoker"
 q smk
 ;
IFORM(zdt,dfn,SAMIPATS) ; extrinsic returns the name(s) of the incomplete forms
 n iform s iform=$g(SAMIPATS(zdt,dfn,"iform"))
 q:iform="" ""  ;
 n return,zkey1,zn,typ
 s return="<table>"
 f zn=2:1  q:$p(iform," ",zn)=""  d  ;
 . s return=return_"<tr><td>"
 . s zkey1=$p(iform," ",zn)
 . n fname
 . if zkey1["ceform" set fname="CT Evaluation" set typ="ceform"
 . if zkey1["sbform" set fname="Background" set typ="sbform"
 . if zkey1["fuform" set fname="Follow-up" set typ="fuform"
 . if zkey1["bxform" set fname="Biopsy" set typ="bxform"
 . if zkey1["ptform" set fname="Pet Evaluation" set typ="ptform"
 . if zkey1["itform" set fname="Intervention" set typ="itform"
 . if zkey1["siform" set fname="Intake Form" set typ="siform"
 . if $get(fname)="" set fname="unknown" set typ=""
 . ;
 . n sid s sid=$$DFN2SID^SAMIUR2(dfn)
 . n zdate s zdate=$$VAPALSDT^SAMICASE($$KEY2FM^SAMICASE(zkey1))
 . s return=return_$$MKNAV(sid,zkey1,fname_" - "_zdate,typ)
 . s return=return_"</td></tr>"
 s return=return_"</table>"
 q return
 ;
MKNAV(sid,zform,fname,form) ; extrinsic return html for navigation to a form
 ;
 n rtn
 set rtn="<form method=""post"" action=""/vapals"">"
 set rtn=rtn_"<input name=""samiroute"" value=""form"" type=""hidden"">"
 set rtn=rtn_" <input name=""studyid"" value="""_sid_""" type=""hidden"">"
 set rtn=rtn_" <input name=""form"" value=""vapals:"_zform_""" type=""hidden"">"
 set rtn=rtn_" <input value="""_fname_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"_$char(13)
 q rtn
 ;
RURAL(zdt,dfn,SAMIPATS) ; extrinsic which returns the rural/urban status
 ; of the patient
 n root s root=$$setroot^%wd("vapals-patients")
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 n siform s siform=$g(SAMIPATS(zdt,dfn,"siform"))
 n vals s vals=$na(@root@("graph",sid,siform))
 n sirs
 s sirs=$g(@vals@("sirs"))
 s sirs=$s(sirs="r":"rural",sirs="u":"urban",sirs="n":"unknown",1:"unknown")
 q sirs
 ;
 
