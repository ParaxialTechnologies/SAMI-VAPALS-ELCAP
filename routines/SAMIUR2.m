SAMIUR2 ;ven/gpl - sami user reports ; 5/8/19 10:57am
 ;;18.0;SAM;;;Build 11
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMIUR contains the routines to generate user reports
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
RPTTBL(RPT,TYPE,SITE) ; RPT is passed by reference and returns the
 ; report definition table. TYPE is the report type to be returned
 ; This routine could use a file or a graph in the next version
 ;
 if TYPE="followup" d  q  ;
 . S RPT(1,"header")="F/U Date"
 . S RPT(1,"routine")="$$FUDATE^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")=$$SSNLABEL(SITE)
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 . S RPT(4,"header")="Baseline Date"
 . S RPT(4,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(6,"header")="Recommend"
 . S RPT(6,"routine")="$$RECOM^SAMIUR2"
 . S RPT(7,"header")="When"
 . S RPT(7,"routine")="$$WHEN^SAMIUR2"
 . S RPT(5,"header")="Last Exam"
 . S RPT(5,"routine")="$$LASTEXM^SAMIUR2"
 . S RPT(8,"header")="Contact Information"
 . S RPT(8,"routine")="$$CONTACT^SAMIUR2"
 if TYPE="activity" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")=$$SSNLABEL(SITE)
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="CT Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Type"
 . S RPT(4,"routine")="$$STUDYTYP^SAMIUR2"
 . S RPT(5,"header")="CT Protocol"
 . S RPT(5,"routine")="$$CTPROT^SAMIUR2"
 . S RPT(6,"header")="Follow-up"
 . S RPT(6,"routine")="$$RECOM^SAMIUR2"
 . S RPT(7,"header")="When"
 . S RPT(7,"routine")="$$WHEN^SAMIUR2"
 . S RPT(8,"header")="on Date"
 . S RPT(8,"routine")="$$FUDATE^SAMIUR2"
 if TYPE="enrollment" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")=$$SSNLABEL(SITE)
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="CT Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Gender"
 . S RPT(4,"routine")="$$GENDER^SAMIUR2"
 . ;S RPT(5,"header")="Race"
 . ;S RPT(5,"routine")="$$RACE^SAMIUR2"
 . S RPT(6,"header")="Age"
 . S RPT(6,"routine")="$$AGE^SAMIUR2"
 . S RPT(7,"header")="Urban/Rural"
 . S RPT(7,"routine")="$$RURAL^SAMIUR2"
 . S RPT(8,"header")="Smoking Status"
 . S RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 . S RPT(9,"header")="Pack Years at Intake"
 . S RPT(9,"routine")="$$PACKYRS^SAMIUR2"
 if TYPE="inactive" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")=$$SSNLABEL(SITE)
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="CT Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Gender"
 . S RPT(4,"routine")="$$GENDER^SAMIUR2"
 . ;S RPT(5,"header")="Race"
 . ;S RPT(5,"routine")="$$RACE^SAMIUR2"
 . S RPT(6,"header")="Age"
 . S RPT(6,"routine")="$$AGE^SAMIUR2"
 . S RPT(7,"header")="Urban/Rural"
 . S RPT(7,"routine")="$$RURAL^SAMIUR2"
 . S RPT(8,"header")="Smoking Status"
 . S RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 . S RPT(9,"header")="Pack Years at Intake"
 . S RPT(9,"routine")="$$PACKYRS^SAMIUR2"
 if TYPE="inactive" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")="SSN"
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="CT Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Gender"
 . S RPT(4,"routine")="$$GENDER^SAMIUR2"
 . ;S RPT(5,"header")="Race"
 . ;S RPT(5,"routine")="$$RACE^SAMIUR2"
 . S RPT(6,"header")="Age"
 . S RPT(6,"routine")="$$AGE^SAMIUR2"
 . S RPT(7,"header")="Urban/Rural"
 . S RPT(7,"routine")="$$RURAL^SAMIUR2"
 . S RPT(8,"header")="Smoking Status"
 . S RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 . S RPT(9,"header")="Pack Years at Intake"
 . S RPT(9,"routine")="$$PACKYRS^SAMIUR2"
 if TYPE="incomplete" d  q  ;
 . S RPT(1,"header")="Enrollment date"
 . S RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")=$$SSNLABEL(SITE)
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 . S RPT(4,"header")="Incomplete form"
 . S RPT(4,"routine")="$$IFORM^SAMIUR2"
 if TYPE="missingct" d  q  ;
 . S RPT(1,"header")="Enrollment date"
 . S RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")=$$SSNLABEL(SITE)
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 if TYPE="cumpy" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")="Study ID"
 . S RPT(2,"routine")="$$SID^SAMIUR2"
 . S RPT(3,"header")="Form Values"
 . S RPT(3,"routine")="$$VALS^SAMIUR2"
 . S RPT(4,"header")="Smoking History"
 . S RPT(4,"routine")="$$SMHIS^SAMIUR2"
 if TYPE="unmatched" d  ;
 . S RPT(1,"header")="Unmatched Entry"
 . S RPT(1,"routine")="$$MANPAT^SAMIUR2"
 . S RPT(2,"header")="Possible Match"
 . S RPT(2,"routine")="$$POSSIBLE^SAMIUR2"
 . S RPT(3,"header")="Match Control"
 . S RPT(3,"routine")="$$MATCH^SAMIUR2"
 if TYPE="worklist" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$WORKPAT^SAMIUR2"
 . S RPT(2,"header")=$$SSNLABEL(SITE)
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="Date of birth"
 . S RPT(3,"routine")="$$DOB^SAMIUR2"
 . S RPT(4,"header")="Gender"
 . S RPT(4,"routine")="$$GENDER^SAMIUR2"
 ;
 q
 ;
SID(zdt,dfn,SAMIPATS) ; extrinsic returns SID
 q $$DFN2SID(dfn)
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
SSNLABEL(SITE) ; extrinsic returns label for SSN (ie PID)
 N RTN
 S RTN=$$GET1PARM^SAMIPARM("socialSecurityNumber",SITE)
 I RTN="" S RTN="SSN"
 Q RTN
 ;
SSN(zdt,dfn,SAMIPATS) ; extrinsic returns SSN
 n ssn,tssn
 s tssn=$g(SAMIPATS(zdt,dfn,"ssn"))
 s ssn=tssn
 i ssn'["-" s ssn=$e(tssn,1,3)_"-"_$e(tssn,4,5)_"-"_$e(tssn,6,9)
 q ssn
 ;
BLINEDT(zdt,dfn,SAMIPATS) ; extrinsic returns Baseline Date
 n bldt
 s bldt=$g(SAMIPATS(zdt,dfn,"edate"))
 q bldt
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
CONTACT(zdt,dfn,SAMIPATS) ; extrinsic returns patient street address
 n contact s contact=""
 n root s root=$$setroot^%wd("vapals-patients")
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 n siform s siform=$g(SAMIPATS(zdt,dfn,"siform"))
 n vals s vals=$na(@root@("graph",sid,siform))
 s contact=$g(@vals@("sinamef"))_" "_$g(@vals@("sinamel"))
 s contact=contact_"<br>"_$g(@vals@("sipsa"))
 i $g(@vals@("sipan"))'="" s contact=contact_" Apt "_$g(@vals@("sipan"))
 i $g(@vals@("sipcn"))'="" s contact=contact_"<br>County "_@vals@("sipcn")
 i $g(@vals@("sipc"))'="" s contact=contact_" <br>"_@vals@("sipc")_", "
 s contact=contact_" "_$g(@vals@("sips"))_" "_$g(@vals@("sipz"))_"     "
 q contact
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
RECOM(zdt,dfn,SAMIPATS) ; extrinsic returns Recommendation
 n root s root=$$setroot^%wd("vapals-patients")
 n ceform s ceform=$g(SAMIPATS(zdt,dfn,"ceform"))
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 q:ceform="" ""
 n vals s vals=$na(@root@("graph",sid,ceform))
 n cefuw s cefuw=$g(@vals@("cefuw"))
 n recom s recom=""
 s recom=$s(cefuw="1y":"Annual Repeat",cefuw="nw":"Now",cefuw="1m":"1 month",cefuw="3m":"3 months",cefuw="6m":"6 months",cefuw="os":"Other",1:"")
 i $g(@vals@("cefuaf"))="y" s recom=recom_", Antibiotics"
 i $g(@vals@("cefucc"))="y" s recom=recom_", Contrast CT"
 i $g(@vals@("cefupe"))="y" s recom=recom_", PET"
 i $g(@vals@("cefufn"))="y" s recom=recom_", Percutaneous biopsy"
 i $g(@vals@("cefubr"))="y" s recom=recom_", Bronchoscopy"
 i $g(@vals@("cefupc"))="y" s recom=recom_", Pulmonary consultation"
 i $g(@vals@("cefutb"))="y" s recom=recom_", Refer to tumor board"
 i $g(@vals@("cefunf"))="y" s recom=recom_", No other further follow-up"
 i $e(recom,1,2)=", " s recom=$e(recom,3,$l(recom))
 q recom
 ;
GENDER(zdt,dfn,SAMIPATS) ; extrinsic returns gender
 n root s root=$$setroot^%wd("vapals-patients")
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n gend
 s gend=$g(SAMIPATS(zdt,dfn,"gender"))
 i gend="" d
 . n pien s pien=$o(@root@("dfn",dfn,""))
 . i pien'="" d  ;
 . . s gend=$g(@root@(pien,"sex"))
 . . i gend="" s gend=$g(@root@(pien,"gender"))
 . i gend="" d  ;
 . . n lien s lien=$o(@lroot@("dfn",dfn,""))
 . . s gend=$g(@lroot@(lien,"gender"))
 i gend["^" s gend=$p(gend,"^",1)
 q:gend="" ""
 q gend
 ;
RACE(zdt,dfn,SAMIPATS) ; extrinsic returns race
 n root s root=$$setroot^%wd("vapals-patients")
 n race s race=$g(@root@(dfn,"race"))
 q:race="" ""
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
 if $g(@vals@("siesm"))="n" s smk="Never smoked"
 if $g(@vals@("siesm"))="p" s smk="Past smoker"
 if $g(@vals@("siesm"))="c" s smk="Current smoker"
 ;if $g(@vals@("siesq"))=1 s smk="Cu"
 q smk
 ;
PACKYRS(zdt,dfn,SAMIPATS) ; extrinsic returns smoking status
 n root s root=$$setroot^%wd("vapals-patients")
 n sid s sid=$g(@root@(dfn,"samistudyid"))
 n siform s siform=$g(SAMIPATS(zdt,dfn,"siform"))
 n vals s vals=$na(@root@("graph",sid,siform))
 n pkyrs
 s pkyrs=$g(@vals@("sippy"))
 q pkyrs
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
 . if zkey1["ptform" set fname="PET Evaluation" set typ="ptform"
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
VALS(zdt,dfn,SAMIPATS) ; extrinsic returns contents of form values cell
 n vrtn s vrtn=""
 n vsid s vsid=$$DFN2SID(dfn)
 n vgr s vgr="/vals?sid="_vsid_"&form="
 q:'$d(SAMIPATS)
 n vzi s vzi=""
 f  s vzi=$o(SAMIPATS(zdt,dfn,"items",vzi)) q:vzi="sort"  q:vzi=""  d  ;
 . s vrtn=vrtn_"<a href="""_vgr_vzi_""">"_vzi_"</a><br>"
 q vrtn
 ;
WSVALS(RTN,FILTER) ;web service to display form values from the graph
 n root s root=$$setroot^%wd("vapals-patients")
 n sid s sid=$g(FILTER("sid"))
 i sid="" s sid=$g(FILTER("studyid"))
 q:sid=""
 n zform s zform=$g(FILTER("form"))
 n groot
 i zform="" s groot=$na(@root@("graph",sid))
 e  s groot=$na(@root@("graph",sid,zform))
 s FILTER("root")=$e(groot,2,$l(groot))
 d wsGtree^SYNVPR(.RTN,.FILTER)
 q
 ;
PKYDT(STDT,ENDT,PKS,CIGS) ; Extrinsic returns pack-years
 ; if PKS is not provided, 20/CIGS will be used for packs per day
 n pkyr s pkyr=""
 i $g(PKS)="" d  ;
 . i $g(CIGS)="" s PKS=0 q  ;
 . s PKS=20/CIGS
 n zst,zend,zdif
 s zst=$$FMDT(STDT)
 i zst=-1 s zst=STDT
 s zend=$$FMDT(ENDT)
 i zend=-1 s zend=ENDT ; probably a fileman date already
 s zdif=$$FMDIFF^XLFDT(zend,zst)/365.24
 s pkyr=$$PKY(zdif,PKS)
 ;
 q pkyr
 ;
PKY(YRS,PKS) ; Extrinsic returns pack-years from years (YRS) and
 ; packs per day (PKS)
 ;
 n rtn s rtn=""
 s rtn=YRS*PKS
 i $l($p(rtn,".",2))>2 d  ;
 . n zdec s zdec=$p(rtn,".",2)
 . s rtn=$p(rtn,".",1)_"."_$e(zdec,1,2)
 . i $e(zdec,3)>4 s rtn=rtn+.01
 i rtn'["." s rtn=rtn_".0"
 q rtn
 ;
FMDT(ZDT) ; Extrinsic returns the fileman date of ZDT
 N X,Y
 S X=ZDT
 D ^%DT
 Q Y
 ;
SMHIS(zdt,dfn,SAMIPATS) ; extrinsic returns contents of smoking history cell
 ;
 n zrtn s zrtn=""
 s zrtn=zrtn_"<div class=""row""><div class=""col-md-12""><table class=""table"" id=""pack-years-history"">"
 s zrtn=zrtn_"<thead><tr><th>Form </th><th> Reported Date </th>"
 s zrtn=zrtn_"<th>Pack Years</th><th>Cumulative</th></tr></thead><tbody>"
 s zrtn=zrtn_$$SHDET($$DFN2SID(dfn))
 s zrtn=zrtn_"</tbody></table></div></div>"
 q zrtn
 ;
SHDET(SID,KEY) ; Extrinsic returns table contents for smoking history
 ; KEY is the form key of the caller for "current" marker insertion
 n pyary
 i $g(KEY)="" s KEY=""
 d CUMPY("pyary",SID,KEY)
 n current s current=$g(pyary("current"))
 n rptcnt,rptmax
 s rptcnt=0
 s rptmax=$o(pyary("rpt",""),-1)
 q:+rptmax=0
 n return
 s return=""
 n zi s zi=""
 f zi=1:1:rptmax d  ;
 . s rptcnt=rptcnt+1
 . i rptcnt=current s return=return_"<tr data-current-form=""true"">"
 . e  s return=return_"<tr>"
 . s return=return_"<td>"_pyary("rpt",rptcnt,1)_"</td>"
 . s return=return_"<td class=""reported-date"">"_pyary("rpt",rptcnt,2)_"</td>"
 . s return=return_"<td class=""pack-years"">"_pyary("rpt",rptcnt,3)_"</td>"
 . s return=return_"<td class=""cumulative-pack-years"">"_pyary("rpt",rptcnt,4)_"</td>"
 . s return=return_"</tr>"
 k pyary
 q return
 ;
DOB(ien,dfn,SAMIPATS) ; extrinsic returns the Date of Birth
 n dob
 s dob=$g(SAMIPATS(ien,dfn,"dob"))
 i dob="" s dob=$g(SAMIPATS(ien,dfn,"sbdob"))
 q dob
 ;
WORKPAT(ien,dfn,SAMIPATS) ; extrinsic returns worklist patient name cell
 n zcell
 s zcell=""
 s zcell=zcell_$g(SAMIPATS(ien,dfn,"workref"))
 q zcell
 ;
MANPAT(ien,dfn,SAMIPATS) ; extrinsic returns the unmatched patient cell
 n zcell
 s zcell=""
 ;s zcell=zcell_$g(SAMIPATS(ien,dfn,"saminame"))
 s zcell=zcell_$g(SAMIPATS(ien,dfn,"editref"))
 s zcell=zcell_"<br>Date of Birth: "_$g(SAMIPATS(ien,dfn,"dob"))
 s zcell=zcell_" Gender: "_$g(SAMIPATS(ien,dfn,"sex"))
 n ssn s ssn=$g(SAMIPATS(ien,dfn,"ssn"))
 i ssn="" d  ;
 . n lroot s lroot=$$setroot^%wd("patient-lookup")
 . n tssn s tssn=$g(@lroot@(ien,"ssn"))
 . s ssn=$e(tssn,1,3)_"-"_$e(tssn,4,5)_"-"_$e(tssn,6,9)
 s zcell=zcell_"<br>SSN: "_ssn
 s zcell=zcell_"<br>dfn: "_dfn
 q zcell
 ;
POSSIBLE(ien,dfn,SAMIPATS) ; extrinsic returns possible match cell
 n zcell
 s zcell=""
 n matien s matien=$g(SAMIPATS(ien,dfn,"MATCHLOG"))
 i matien="" q zcell
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 i '$d(@lroot@(matien)) q zcell
 s zcell=zcell_$g(@lroot@(matien,"saminame"))
 s zcell=zcell_"<br>Date of Birth: "_$g(@lroot@(matien,"sbdob"))
 s zcell=zcell_" Gender: "_$g(@lroot@(matien,"sex"))
 n tssn s tssn=$g(@lroot@(matien,"ssn"))
 n ssn s ssn=tssn
 i tssn'["-" s ssn=$e(tssn,1,3)_"-"_$e(tssn,4,5)_"-"_$e(tssn,6,9)
 s zcell=zcell_"<br>SSN: "_ssn
 s zcell=zcell_"<br>dfn: "_$g(@lroot@(matien,"dfn"))
 ;
 q zcell
 ;
MATCH(ien,dfn,SAMIPATS) ; extrinsic returns the match button cell
 ;
 n matien s matien=$g(SAMIPATS(ien,dfn,"MATCHLOG"))
 i matien="" q ""
 ;
 new nuhref set nuhref="<form method=POST action=""/vapals"">"
 set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""merge"">"
 set nuhref=nuhref_"<input type=hidden name=""toien"" value="_ien_">"
 set nuhref=nuhref_"<input value=""Merge"" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 q nuhref
 ;
CUMPY(PYARY,sid,KEY) ; forms array of cummulative pack year data
 ; PYARY passed by name
 ; KEY is the current form key for matching to a row
 k @PYARY
 n root s root=$$setroot^%wd("vapals-patients")
 ;n sid s sid=$g(@root@(DFN,"samistudyid"))
 ;q:sid=""
 n items s items=""
 d GETITEMS^SAMICASE("items",sid)
 q:'$d(items)
 m @PYARY@("items")=items
 n siform
 s siform=$o(items("siform"))
 q:siform=""
 i siform=$g(KEY) s @PYARY@("current")=1 ;this row is the current form
 n vals
 s vals=$na(@root@("graph",sid,siform))
 n kdate s kdate=$$GETDTKEY^SAMICAS2(siform)
 n keydate s keydate=$$KEY2DSPD^SAMICAS2(kdate)
 s @PYARY@("rpt",1,1)="Intake" ; Form
 s @PYARY@("rpt",1,2)=keydate ; Reported Date
 n lastcum s lastcum=$g(@vals@("sippy"))
 s @PYARY@("rpt",1,3)=lastcum ; Pack Years
 s @PYARY@("rpt",1,4)=lastcum ; Cumulative
 n lastdt s lastdt=keydate
 n rptcnt s rptcnt=1
 n zi s zi=""
 f  s zi=$o(items("type","vapals:fuform",zi)) q:zi=""  d  ;
 . s rptcnt=rptcnt+1
 . s @PYARY@("rpt",rptcnt,1)="Follow-up"
 . n kdate s kdate=$$GETDTKEY^SAMICAS2(zi)
 . n keydate s keydate=$$KEY2DSPD^SAMICAS2(kdate)
 . s @PYARY@("rpt",rptcnt,2)=keydate ; Reported Date
 . s vals=$na(@root@("graph",sid,zi))
 . n newpd s newpd=$g(@vals@("sippd"))
 . n usedate,siq s usedate=keydate
 . s siq=$g(@vals@("siq")) ; quit date on followup form
 . i siq'="" d  ; quit date provided
 . . if $$FMDT(siq)<$$FMDT(lastdt) q  ; quit date out of range
 . . if $$FMDT(siq)>$$FMDT(keydate) q  ; quit date out of range
 . . s usedate=siq ; use the quit date as end of range
 . n newpy s newpy=$$PKYDT(lastdt,usedate,newpd)
 . s @vals@("sippy")=newpy
 . s ^gpl("current","KEY")=$g(KEY)
 . s ^gpl("current","zi")=zi
 . i zi=$g(KEY) s @PYARY@("current")=rptcnt ;this row is the current form
 . n newcum s newcum=""
 . i newpy'="" s newcum=lastcum+newpy
 . s @PYARY@("rpt",rptcnt,3)=newpy ; Pack Years
 . s @PYARY@("rpt",rptcnt,4)=newcum ; Cumulative
 . s lastdt=keydate
 . s lastcum=newcum
 q
 ;
EPAT(ien,dfn,SAMIPATS) ; extrinsic the patient name with navigation
 ; to enrollment
 q
 ;
