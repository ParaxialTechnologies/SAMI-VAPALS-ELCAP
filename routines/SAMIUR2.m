SAMIUR2 ;ven/gpl - user reports cont ;2021-10-29t20:32z
 ;;18.0;SAMI;**5,11,12,14,15**;2020-01;Build 11
 ;;18-15
 ;
 ; SAMIUR2 contains subroutines for creating & implementing the
 ; report-definition table.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@dev-main George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org-main Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-update 2021-10-29t20:32z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18-15
 ;@release-date 2020-01
 ;@patch-list **5,11,12,14,15**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@dev-add Alexis R. Carlson (arc)
 ; whatisthehumanspirit@gmail.com
 ;@dev-add Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@module-credits see SAMIHUL
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; see SAMIURUL
 ;
 ;@contents
 ; RPTTBL build report-definition table
 ;
 ; $$DFN2SID study id for patient DFN
 ; $$MKNAV html for navigation to form
 ;
 ; $$SHDET table contents for smoking history
 ; CUMPY forms array of cummulative pack year data
 ; $$TDDT embed date in table cell
 ; $$FMDT convert date to fileman format
 ; $$PKYDT pack-years from start & end & cigs/day
 ; $$PKY pack-years from years & packs/day
 ;
 ; $$AGE age
 ; $$BLINEDT baseline date
 ; $$CONTACT patient street address
 ; $$CTPROT ct protocol
 ; $$DOB date of birth
 ; $$FUDATE followup date
 ; $$GENDER gender
 ; $$IFORM name(s) of incomplete forms
 ; $$LASTEXM patient last exam
 ; $$MANPAT unmatched patient cell
 ; $$MATCH match button cell
 ; $$NAME name w/hyperlink
 ; $$PACKYRS smoking status
 ; $$POSSIBLE possible match cell
 ; $$RECOM recommendation
 ; $$RURAL patient's rural/urban status
 ; $$SID study id
 ; $$SMHIS smoking history cell
 ; $$SMKSTAT smoking status
 ; $$SSN social security number
 ; $$STUDYDT latest study date
 ; $$STUDYTYP latest study type
 ; $$VALS form-values cell
 ; $$WHEN followup text
 ; $$WORKPAT worklist patient name cell
 ;
 ; EPAT patient name w/nav to enrollment
 ; ETHNCTY ethnicity
 ; RACE race
 ; STATUS patient status
 ; WSVALS display form values from graph
 ;
 ;
 ;
 ;@section 1 ppi RPTTBL^SAMIUR2
 ;
 ;
 ;
RPTTBL(RPT,TYPE,SITE) ; RPT is passed by reference and returns the 
 ; report definition table. TYPE is the report type to be returned
 ; This routine could use a file or a graph in the next version
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ; WSREPORT^SAMIUR1 (which then calls WSREPORT^SAMIUR)
 ;@calls none (defines calls for WSREPORT^SAMIUR to call)
 ;@input
 ; TYPE = report type to return
 ;@output
 ; .RPT report-definition table
 ;
 ; This routine could use a file or a graph in the next version
 ;
 if TYPE="followup" do  quit  ;
 . set RPT(1,"header")="F/U Date"
 . set RPT(1,"routine")="$$FUDATE^SAMIUR2"
 . set RPT(2,"header")="Name"
 . set RPT(2,"routine")="$$NAME^SAMIUR2"
 . ;set RPT(3,"header")="SSN"
 . set RPT(3,"header")=$$SSNLABEL(SITE)
 . set RPT(3,"routine")="$$SSN^SAMIUR2"
 . set RPT(4,"header")="Baseline Date"
 . set RPT(4,"routine")="$$BLINEDT^SAMIUR2"
 . set RPT(5,"header")="Last Form"
 . set RPT(5,"routine")="$$AFORM^SAMIUR2"
 . set RPT(6,"header")="Form Date"
 . set RPT(6,"routine")="$$AFORMDT^SAMIUR2"
 . set RPT(7,"header")="Recommend"
 . set RPT(7,"routine")="$$RECOM^SAMIUR2"
 . set RPT(8,"header")="Contact Information"
 . set RPT(8,"routine")="$$CONTACT^SAMIUR2"
 . quit
 ;
 if TYPE="activity" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . set RPT(2,"header")=$$SSNLABEL(SITE)
 . set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(2.2,"header")="Active/Inactive"
 . set RPT(2.2,"routine")="$$ACTIVE^SAMIUR2"
 . set RPT(2.5,"header")="Form"
 . set RPT(2.5,"routine")="$$AFORM^SAMIUR2"
 . set RPT(3,"header")="Form Date"
 . ;set RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . set RPT(3,"routine")="$$AFORMDT^SAMIUR2"
 . ;set RPT(4,"header")="Type"
 . ;set RPT(4,"routine")="$$STUDYTYP^SAMIUR2"
 . ;set RPT(5,"header")="CT Protocol"
 . ;set RPT(5,"routine")="$$CTPROT^SAMIUR2"
 . set RPT(6,"header")="Follow-up"
 . set RPT(6,"routine")="$$RECOM^SAMIUR2"
 . ;set RPT(7,"header")="When"
 . ;set RPT(7,"routine")="$$WHEN^SAMIUR2"
 . set RPT(8,"header")="on Date"
 . set RPT(8,"routine")="$$FUDATE^SAMIUR2"
 . quit
 ;
 if TYPE="enrollment" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . set RPT(1.5,"header")="Active/Inactive"
 . set RPT(1.5,"routine")="$$ACTIVE^SAMIUR2"
 . set RPT(2,"header")=$$SSNLABEL(SITE)
 . set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(3,"header")="CT Date"
 . set RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . set RPT(4,"header")="Gender"
 . set RPT(4,"routine")="$$GENDER^SAMIUR2"
 . ; set RPT(5,"header")="Race"
 . ; set RPT(5,"routine")="$$RACE^SAMIUR2"
 . set RPT(6,"header")="Age"
 . set RPT(6,"routine")="$$AGE^SAMIUR2"
 . d  ;
 . . n filter s filter("siteid")=SITE
 . . i $$ISVA^SAMIPARM(.filter) d  ;
 . . . set RPT(7,"header")="Urban/Rural"
 . . . set RPT(7,"routine")="$$RURAL^SAMIUR2"
 . set RPT(8,"header")="Smoking Status"
 . set RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 . set RPT(9,"header")="Pack Years at Intake"
 . set RPT(9,"routine")="$$PACKYRS^SAMIUR2"
 . quit
 ;
 if TYPE="inactive" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . set RPT(2,"header")=$$SSNLABEL(SITE)
 . set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(3,"header")="Enrollment date"
 . set RPT(3,"routine")="$$ENROLLDT^SAMIUR2"
 . ;set RPT(3,"header")="CT Date"
 . ;set RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . ;set RPT(4,"header")="Gender"
 . ;set RPT(4,"routine")="$$GENDER^SAMIUR2"
 . ; set RPT(5,"header")="Race"
 . ; set RPT(5,"routine")="$$RACE^SAMIUR2"
 . ;set RPT(6,"header")="Age"
 . ;set RPT(6,"routine")="$$AGE^SAMIUR2"
 . set RPT(4,"header")="Date of Death"
 . set RPT(4,"routine")="$$INACTDT^SAMIUR2"
 . set RPT(5,"header")="Inactive Reason"
 . set RPT(5,"routine")="$$INACTRE^SAMIUR2"
 . set RPT(6,"header")="Inactive Comment"
 . set RPT(6,"routine")="$$INACTCM^SAMIUR2"
 . ;set RPT(7,"header")="Urban/Rural"
 . ;set RPT(7,"routine")="$$RURAL^SAMIUR2"
 . ;set RPT(8,"header")="Smoking Status"
 . ;set RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 . ;set RPT(9,"header")="Pack Years at Intake"
 . ;set RPT(9,"routine")="$$PACKYRS^SAMIUR2"
 . quit
 ;
 if TYPE="incomplete" do  quit  ;
 . set RPT(1,"header")="Enrollment date"
 . set RPT(1,"routine")="$$ENROLLDT^SAMIUR2"
 . set RPT(2,"header")="Name"
 . set RPT(2,"routine")="$$NAME^SAMIUR2"
 . set RPT(3,"header")=$$SSNLABEL(SITE)
 . set RPT(3,"routine")="$$SSN^SAMIUR2"
 . set RPT(4,"header")="Incomplete form"
 . set RPT(4,"routine")="$$IFORM^SAMIUR2"
 . quit
 ;
 if TYPE="missingct" do  quit  ;
 . set RPT(1,"header")="Last contact date"
 . set RPT(1,"routine")="$$LDOC^SAMIUR2"
 . set RPT(2,"header")="Last contact entry"
 . set RPT(2,"routine")="$$LENTRY^SAMIUR2"
 . set RPT(3,"header")="Name"
 . set RPT(3,"routine")="$$NAME^SAMIUR2"
 . set RPT(4,"header")=$$SSNLABEL(SITE)
 . set RPT(4,"routine")="$$SSN^SAMIUR2"
 . set RPT(5,"header")="Enrollment date"
 . set RPT(5,"routine")="$$ENROLLDT^SAMIUR2"
 . quit
 ;
 if TYPE="cumpy" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . set RPT(2,"header")="Study ID"
 . set RPT(2,"routine")="$$SID^SAMIUR2"
 . set RPT(3,"header")="Form Values"
 . set RPT(3,"routine")="$$VALS^SAMIUR2"
 . set RPT(4,"header")="Smoking History"
 . set RPT(4,"routine")="$$SMHIS^SAMIUR2"
 . quit
 ;
 if TYPE="unmatched2" do  ;
 . set RPT(1,"header")="Unmatched Manual Entry"
 . set RPT(1,"routine")="$$MANPAT^SAMIUR2"
 . set RPT(2,"header")="Possible HL7 Match"
 . set RPT(2,"routine")="$$POSSIBLE^SAMIUR2"
 . set RPT(3,"header")="Match Control"
 . set RPT(3,"routine")="$$MATCH^SAMIUR2"
 . quit
 ;
 if TYPE="unmatched" do  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . ;set RPT(2,"header")=$$SSNLABEL(SITE)
 . ;set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(3,"header")="Last5"
 . set RPT(3,"routine")="$$LAST5^SAMIUR2"
 . set RPT(4,"header")="CT Eval Date"
 . set RPT(4,"routine")="$$ZDT^SAMIUR2"
 . set RPT(5,"header")="Antibiotics"
 . set RPT(5,"routine")="$$RECANTI^SAMIUR2"
 . set RPT(6,"header")="Contrast CT"
 . set RPT(6,"routine")="$$RECCONT^SAMIUR2"
 . set RPT(7,"header")="PET"
 . set RPT(7,"routine")="$$RECPET^SAMIUR2"
 . ;set RPT(8,"header")="Percutaneous biopsy"
 . set RPT(8,"header")="Perc biopsy"
 . set RPT(8,"routine")="$$RECBIOP^SAMIUR2"
 . set RPT(9,"header")="Bronchoscopy"
 . set RPT(9,"routine")="$$RECBRONC^SAMIUR2"
 . ;set RPT(10,"header")="Pulmonary consultation"
 . set RPT(10,"header")="Pulm consult"
 . set RPT(10,"routine")="$$RECPULM^SAMIUR2"
 . ;set RPT(11,"header")="Refer to tumor board"
 . set RPT(11,"header")="Tumor board"
 . set RPT(11,"routine")="$$RECTUMOR^SAMIUR2"
 . ;set RPT(12,"header")="Other"
 . ;set RPT(12,"routine")=""
 . quit
 ;
 if TYPE="worklist" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$WORKPAT^SAMIUR2"
 . set RPT(2,"header")=$$SSNLABEL(SITE)
 . set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(3,"header")="Date of birth"
 . set RPT(3,"routine")="$$DOB^SAMIUR2"
 . set RPT(4,"header")="Gender"
 . set RPT(4,"routine")="$$GENDER^SAMIUR2"
 . quit
 ;
 quit  ; end of ppi RPTTBL^SAMIUR2
 ;
 ;
 ;
 ;@section 2 shared subroutines
 ;
 ;
 ;
DFN2SID(DFN) ;studyid for patient DFN
 ;
 ;;private;function;clean;silent;sac
 ;@called-by
 ; $$SID^SAMIUR2
 ; $$IFORM^SAMIUR2
 ; $$VALS^SAMIUR2
 ; $$SMHIS^SAMIUR2
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 quit $get(@root@(DFN,"sisid")) ; end of $$DFN2SID
 ;
 ;
 ;
MKNAV(sid,zform,fname,form) ; html for navigation to form
 ;
 ;;private;function;clean;silent;sac
 ;@called-by
 ; $$IFORM^SAMIUR2
 ;@calls none
 ;
 new rtn set rtn="<form method=""post"" action=""/vapals"">"
 set rtn=rtn_"<input name=""samiroute"" value=""form"" type=""hidden"">"
 set rtn=rtn_" <input name=""studyid"" value="""_sid_""" type=""hidden"">"
 set rtn=rtn_" <input name=""form"" value=""vapals:"_zform_""" type=""hidden"">"
 set rtn=rtn_" <input value="""_fname_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"_$char(13)
 ;
 quit rtn ; end of $$MKNAV
 ;
 ;
 ;
 ;@section 3 smoking history subroutines
 ;
 ;
 ;
SHDET(SID,KEY) ; table contents for smoking history
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; LOAD^SAMIFLD
 ; $$SMHIS^SAMIUR2
 ;@calls
 ; CUMPY
 ;
 ; KEY is the form key of the caller for "current" marker insertion
 ;
 new pyary
 if $get(KEY)="" set KEY=""
 do CUMPY("pyary",SID,KEY)
 ;
 new current set current=$get(pyary("current"))
 new rptcnt set rptcnt=0
 new rptmax set rptmax=$order(pyary("rpt",""),-1)
 quit:+rptmax=0
 ;
 new return set return=""
 new zi set zi=""
 for zi=1:1:rptmax do  ;
 . set rptcnt=rptcnt+1
 . if rptcnt=current set return=return_"<tr data-current-form=""true"">"
 . else  set return=return_"<tr>"
 . set return=return_"<td>"_pyary("rpt",rptcnt,1)_"</td>"
 . set return=return_"<td class=""reported-date"">"_pyary("rpt",rptcnt,2)_"</td>"
 . set return=return_"<td class=""pack-years"">"_pyary("rpt",rptcnt,3)_"</td>"
 . set return=return_"<td class=""cumulative-pack-years"">"_pyary("rpt",rptcnt,4)_"</td>"
 . set return=return_"</tr>"
 . quit
 ;
 quit return ; end of ppi $$SHDET^SAMIUR2
 ;
 ;
 ;
CUMPY(PYARY,sid,KEY) ; forms array of cummulative pack year data
 ;
 ;;ppi;procedure;clean;silent;sac
 ;@called-by
 ; SSTATUS^SAMINOT2
 ; SSTATUS^SAMINOT3
 ; $$SHDET
 ;@calls
 ; $$setroot^%wd
 ; GETITEMS^SAMICASE
 ; $$GETDTKEY^SAMICAS2
 ; $$KEY2DSPD^SAMICAS2
 ; $$FMDT
 ; $$PKYDT
 ;
 ; PYARY passed by name
 ; KEY is the current form key for matching to a row
 ;
 kill @PYARY
 new root set root=$$setroot^%wd("vapals-patients")
 ; new sid set sid=$get(@root@(DFN,"samistudyid"))
 ; quit:sid=""
 ;
 new items set items=""
 do GETITEMS^SAMICASE("items",sid)
 quit:'$data(items)
 merge @PYARY@("items")=items
 ;
 new siform set siform=$order(items("siform"))
 quit:siform=""
 if siform=$get(KEY) set @PYARY@("current")=1 ;this row is the current form
 ;
 set @PYARY@("rpt",1,1)="Intake" ; Form
 new kdate set kdate=$$GETDTKEY^SAMICAS2(siform)
 new keydate set keydate=$$KEY2DSPD^SAMICAS2(kdate)
 set @PYARY@("rpt",1,2)=keydate ; Reported Date
 ;
 new vals set vals=$name(@root@("graph",sid,siform))
 new lastcum set lastcum=$get(@vals@("sippy"))
 set @PYARY@("rpt",1,3)=lastcum ; Pack Years
 set @PYARY@("rpt",1,4)=lastcum ; Cumulative
 ;
 new lastdt set lastdt=keydate
 new rptcnt set rptcnt=1
 new zi set zi=""
 for  do  quit:zi=""  ;
 . set zi=$order(items("type","vapals:fuform",zi))
 . quit:zi=""
 . ;
 . set rptcnt=rptcnt+1
 . set @PYARY@("rpt",rptcnt,1)="Follow-up"
 . new kdate set kdate=$$GETDTKEY^SAMICAS2(zi)
 . new keydate set keydate=$$KEY2DSPD^SAMICAS2(kdate)
 . set @PYARY@("rpt",rptcnt,2)=keydate ; Reported Date
 . ;
 . set vals=$name(@root@("graph",sid,zi))
 . new newpd set newpd=$g(@vals@("sippd"))
 . new usedate set usedate=keydate
 . new siq set siq=$get(@vals@("siq")) ; quit date on followup form
 . if siq'="" do  ; quit date provided
 . . quit:$$FMDT(siq)<$$FMDT(lastdt)  ; quit date out of range
 . . quit:$$FMDT(siq)>$$FMDT(keydate)  ; quit date out of range
 . . set usedate=siq ; use the quit date as end of range
 . . quit
 . new newpy set newpy=$$PKYDT(lastdt,usedate,newpd)
 . set @vals@("sippy")=newpy
 . ;
 . set ^gpl("current","KEY")=$get(KEY)
 . set ^gpl("current","zi")=zi
 . if zi=$get(KEY) do
 . . set @PYARY@("current")=rptcnt ;this row is the current form
 . . quit
 . ;
 . new newcum set newcum=""
 . if newpy'="" set newcum=lastcum+newpy
 . set @PYARY@("rpt",rptcnt,3)=newpy ; Pack Years
 . set @PYARY@("rpt",rptcnt,4)=newcum ; Cumulative
 . set lastdt=keydate
 . set lastcum=newcum
 . quit
 ;
 quit  ; end of ppi CUMPY^SAMIUR2
 ;
 ;
 ;
TDDT(ZDT) ; embed date in table cell
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; BLINEDT
 ; DOB
 ; FUDATE
 ; LASTEXM
 ; INACTDT
 ; LDOC
 ; STUDYDT
 ;@calls
 ; ^%DT
 ;
 new X,Y,Z
 set X=ZDT
 do ^%DT
 if Y=-1 set Y=""
 set Z=$$VAPALSDT^SAMICASE(Y)
 new cell
 set cell="<td data-order="""_Y_""" data-search="""_Z_""">"_Z_"</td>"
 ;
 quit cell ; end of $$TDDT
 ; 
 ;
 ;
FMDT(ZDT) ; convert date to fileman format
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; MKPTLK^SAMIHOM4
 ; $$PKYDT
 ; CUMPY
 ;@calls
 ; ^%DT
 ;
 new Y
 new X set X=ZDT
 do ^%DT
 ;
 quit Y ; end of ppi $$FMDT^SAMIUR2
 ;
 ;
 ;
PKYDT(STDT,ENDT,PKS,CIGS) ; pack-years from start & end & cigs/day
 ;
 ;;private;function;clean;silent;sac
 ;@called-by
 ; CUMPY
 ;@calls
 ; $$FMDT
 ; $$FMDIFF^XLFDT
 ; $$PKY
 ;
 ; if PKS is not provided, 20/CIGS will be used for packs per day
 ;
 new pkyr set pkyr=""
 if $get(PKS)="" do  ;
 . if $get(CIGS)="" set PKS=0 quit  ;
 . set PKS=20/CIGS
 . quit
 new zst set zst=$$FMDT(STDT)
 set:zst=-1 zst=STDT
 ;
 new zend set zend=$$FMDT(ENDT)
 set:zend=-1 zend=ENDT ; probably a fileman date already
 ;
 new zdif set zdif=$$FMDIFF^XLFDT(zend,zst)/365.24
 ;
 set pkyr=$$PKY(zdif,PKS)
 ;
 quit pkyr ; end of $$PKYDT
 ;
 ;
 ;
PKY(YRS,PKS) ; pack-years from years & packs/day
 ;
 ;;private;function;clean;silent;sac
 ;@called-by
 ; $$PKYDT
 ;@calls none
 ;@input
 ; YRS = years
 ; PKS = packs/day
 ;
 new rtn set rtn=""
 set rtn=YRS*PKS
 if $length($piece(rtn,".",2))>2 do  ;
 . new zdec set zdec=$piece(rtn,".",2)
 . set rtn=$piece(rtn,".",1)_"."_$extract(zdec,1,2)
 . if $extract(zdec,3)>4 set rtn=rtn+.01
 . quit
 set:rtn'["." rtn=rtn_".0"
 ;
 quit rtn ; end of $$PKY
 ;
 ;
 ;
 ;@section 4 active column ppis
 ;
 ;
 ;
ACTIVE(zdt,dfn,SAMIPATS) ; Active/Inactive column
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 new active set active="inactive"
 if $get(@vals@("sistatus"))="active" set active="active"
 ;
 quit active
 ; 
AFORM(zdt,dfn,SAMIPATS) ; Name of most recent form
 Q $GET(SAMIPATS(zdt,dfn,"aform"))
 ;
AFORMDT(zdt,dfn,SAMIPATS) ; Date of most recent form
 N ZD S ZD=$GET(SAMIPATS(zdt,dfn,"aformdt"))
 Q $$VAPALSDT^SAMICASE(ZD)
 ;
AGE(zdt,dfn,SAMIPATS) ; age
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ; ^%DT
 ; $$NOW^XLFDT
 ; $$FMDIFF^XLFDT
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new dob set dob=$get(@root@(dfn,"sbdob")) ; dob in VAPALS format
 ;
 new Y
 new X set X=dob
 do ^%DT
 ;
 new age set age=$piece($$FMDIFF^XLFDT($$NOW^XLFDT,Y)/365,".")
 ;
 quit age ; end of ppi $$AGE^SAMIUR2
 ;
 ;
RECANTI(zdt,dfn,SAMIPATS) ; returns X if recommendation was checked
 Q $S($get(SAMIPATS(zdt,dfn,"cefuaf"))="y":"X",1:"")
 ;
RECCONT(zdt,dfn,SAMIPATS) ; returns X if recommendation was checked
 Q $S($get(SAMIPATS(zdt,dfn,"cefucc"))="y":"X",1:"")
 ;
RECPET(zdt,dfn,SAMIPATS) ; returns X if recommendation was checked
 Q $S($get(SAMIPATS(zdt,dfn,"cefupe"))="y":"X",1:"")
 ;
RECBIOP(zdt,dfn,SAMIPATS) ; returns X if recommendation was checked
 Q $S($get(SAMIPATS(zdt,dfn,"cefufn"))="y":"X",1:"")
 ;
RECBRONC(zdt,dfn,SAMIPATS) ; returns X if recommendation was checked
 Q $S($get(SAMIPATS(zdt,dfn,"cefubr"))="y":"X",1:"")
 ;
RECPULM(zdt,dfn,SAMIPATS) ; returns X if recommendation was checked
 Q $S($get(SAMIPATS(zdt,dfn,"cefupc"))="y":"X",1:"")
 ;
RECTUMOR(zdt,dfn,SAMIPATS) ; returns X if recommendation was checked
 Q $S($get(SAMIPATS(zdt,dfn,"cefutb"))="y":"X",1:"")
 ;
LAST5(zdt,dfn,SAMIPATS) ; return last5
 Q $get(SAMIPATS(zdt,dfn,"last5"))
 ;
ZDT(zdt,dfn,SAMIPATS) ; insertable index date
 Q $$TDDT(zdt)
 ;
ENROLLDT(zdt,dfn,SAMIPATS) ; enrollment date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$TDDT
 ;
 new enroldt set enroldt=$get(SAMIPATS(zdt,dfn,"edate"))
 ;
 quit $$TDDT(enroldt) ; end of ppi $$ENROLLDT^SAMIUR2
 ;
 ;
BLINEDT(zdt,dfn,SAMIPATS) ; baseline date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$TDDT
 ;
 new bldt set bldt=$get(SAMIPATS(zdt,dfn,"baseline"))
 ;
 quit $$TDDT(bldt) ; end of ppi $$BLINEDT^SAMIUR2
 ;
 ;
CONTACT(zdt,dfn,SAMIPATS) ; patient street address
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new contact set contact=""
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 q:siform=""
 new vals set vals=$name(@root@("graph",sid,siform))
 set contact=$get(@vals@("sinamef"))_" "_$get(@vals@("sinamel"))
 set contact=contact_"<br>"_$get(@vals@("sipsa"))
 if $get(@vals@("sipan"))'="" do
 . set contact=contact_" Apt "_$get(@vals@("sipan"))
 . quit
 if $get(@vals@("sipcn"))'="" do
 . set contact=contact_"<br>County "_@vals@("sipcn")
 . quit
 if $get(@vals@("sipc"))'="" do
 . set contact=contact_" <br>"_@vals@("sipc")_", "
 . quit
 set contact=contact_" "_$get(@vals@("sips"))_" "_$get(@vals@("sipz"))_"     "
 ;
 new phone set phone=$get(@vals@("sippn"))
 if phone'="" set contact=contact_" <br>Phone: "_phone
 ;
 quit contact ; end of ppi $$CONTACT^SAMIUR2
 ;
 ;
 ;
CTPROT(zdt,dfn,SAMIPATS) ; ct protocol
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new ceform set ceform=$get(SAMIPATS(zdt,dfn,"ceform"))
 quit:ceform="" ""
 ;
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new vals set vals=$name(@root@("graph",sid,ceform))
 new cectp set cectp=$get(@vals@("cectp"))
 new ctyp set ctyp=$select(cectp="l":"Low-Dose CT",cectp="d":"Standard CT",cectp="i":"Limited",1:"")
 ;
 quit ctyp ; end of ppi $$CTPROT^SAMIUR2
 ;
 ;
 ;
DOB(ien,dfn,SAMIPATS) ; date of birth
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$TDDT
 ;
 new dob set dob=$get(SAMIPATS(ien,dfn,"dob"))
 if dob="" set dob=$get(SAMIPATS(ien,dfn,"sbdob"))
 ;
 quit $$TDDT(dob) ; end of ppi $$DOB^SAMIUR2
 ;
 ;
 ;
FUDATE(zdt,dfn,SAMIPATS) ; followup date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $TDDT
 ;
 new fud set fud="fudate"
 new date set date=$get(SAMIPATS(zdt,dfn,"cefud"))
 ;
 quit $$TDDT(date) ; end of ppi $$FUDATE^SAMIUR2
 ;
 ;
 ;
GENDER(zdt,dfn,SAMIPATS) ; gender
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new lroot set lroot=$$setroot^%wd("patient-lookup")
 ;
 new gend set gend=$get(SAMIPATS(zdt,dfn,"gender"))
 if gend="" do
 . new pien set pien=$order(@root@("dfn",dfn,""))
 . if pien'="" do  ;
 . . set gend=$get(@root@(pien,"sex"))
 . . if gend="" set gend=$get(@root@(pien,"gender"))
 . . quit
 . if gend="" do  ;
 . . new lien set lien=$order(@lroot@("dfn",dfn,""))
 . . set gend=$get(@lroot@(lien,"gender"))
 . . quit
 if gend["^" set gend=$piece(gend,"^",1)
 ;
 quit gend ; end of ppi $$GENDER^SAMIUR2
 ;
 ;
 ;
IFORM(zdt,dfn,SAMIPATS) ; name(s) of incomplete forms
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$DFN2SID^SAMIUR2
 ; $$KEY2FM^SAMICASE
 ; $$VAPALSDT^SAMICASE
 ; $$MKNAV
 ;
 new iform set iform=$get(SAMIPATS(zdt,dfn,"iform"))
 quit:iform="" ""  ;
 ;
 new zkey1,zn,typ
 new return set return="<table>"
 for zn=2:1  quit:$piece(iform," ",zn)=""  do  ;
 . set return=return_"<tr><td>"
 . set zkey1=$piece(iform," ",zn)
 . ;
 . new fname
 . if zkey1["ceform" set fname="CT Evaluation" set typ="ceform"
 . if zkey1["sbform" set fname="Background" set typ="sbform"
 . if zkey1["fuform" set fname="Participant Follow-up" set typ="fuform"
 . if zkey1["bxform" set fname="Biopsy" set typ="bxform"
 . if zkey1["ptform" set fname="PET Evaluation" set typ="ptform"
 . if zkey1["itform" set fname="Intervention" set typ="itform"
 . if zkey1["siform" set fname="Intake Form" set typ="siform"
 . if $get(fname)="" set fname="unknown" set typ=""
 . ;
 . new sid set sid=$$DFN2SID^SAMIUR2(dfn)
 . new zdate set zdate=$$VAPALSDT^SAMICASE($$KEY2FM^SAMICASE(zkey1))
 . set return=return_$$MKNAV(sid,zkey1,fname_" - "_zdate,typ)
 . set return=return_"</td></tr>"
 . quit
 ;
 set return=return_"</table>"
 ;
 quit return ; end of ppi $$IFORM^SAMIUR2
 ;
 ;
 ;
LASTEXM(zdt,dfn,SAMIPATS) ; patient last exam
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$TDDT
 ;
 new lexm set lexm=$get(SAMIPATS(zdt,dfn,"cedos"))
 ;
 quit $$TDDT(lexm) ; end of ppi $$LASTEXM^SAMIUR2
 ;
 ;
 ;
INACTDT(zdt,dfn,SAMIPATS) ; inactive date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ; $$TDDT
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 ;
 quit $$TDDT($get(@vals@("sidod")))
 ;
 ;
 ;
INACTRE(zdt,dfn,SAMIPATS) ; inactive date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 ;
 quit $get(@vals@("sistachg"))
 ;
 ;
 ;
INACTCM(zdt,dfn,SAMIPATS) ; inactive date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 ;
 quit $get(@vals@("sistreas"))
 ;
 ;
 ;
LDE(zdt,dfn,SAMIPATS) ; last date and entry in com log
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 ;
 n comien,comdt,comntry
 s (comdt,comntry)=""
 s comien=$o(@vals@("comlog"," "),-1)
 i comien="" d  q comdt
 . s comdt=$g(@vals@("sidc"))
 s comntry=$g(@vals@("comlog",comien))
 s comdt=$p($p(comntry,"[",2),"@",1)
 ;
 quit comdt_"^"_comntry
 ;
 ;
 ;
LDOC(zdt,dfn,SAMIPATS) ; last date of contact
 ;
 quit $$TDDT($piece($$LDE(zdt,dfn,.SAMIPATS),"^",1))
 ;
 ;
 ;
LENTRY(zdt,dfn,SAMIPATS) ; last contact entry
 ;
 quit $piece($$LDE(zdt,dfn,.SAMIPATS),"^",2)
 ;
 ;
 ;
MANPAT(ien,dfn,SAMIPATS) ; unmatched patient cell
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new zcell set zcell=""
 ; set zcell=zcell_$get(SAMIPATS(ien,dfn,"saminame"))
 set zcell=zcell_$get(SAMIPATS(ien,dfn,"editref"))
 set zcell=zcell_"<br>Date of Birth: "_$get(SAMIPATS(ien,dfn,"dob"))
 set zcell=zcell_" Gender: "_$get(SAMIPATS(ien,dfn,"sex"))
 ;
 new ssn set ssn=$get(SAMIPATS(ien,dfn,"ssn"))
 if ssn="" do  ;
 . new lroot set lroot=$$setroot^%wd("patient-lookup")
 . new tssn set tssn=$get(@lroot@(ien,"ssn"))
 . set ssn=$extract(tssn,1,3)_"-"_$extract(tssn,4,5)_"-"_$extract(tssn,6,9)
 . quit
 set zcell=zcell_"<br>SSN: "_ssn
 ;
 set zcell=zcell_"<br>dfn: "_dfn
 ;
 quit zcell ; end of ppi $$MANPAT^SAMIUR2
 ;
 ;
 ;
MATCH(ien,dfn,SAMIPATS) ; match button cell
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls none
 ;
 new matien set matien=$get(SAMIPATS(ien,dfn,"MATCHLOG"))
 quit:matien="" ""
 ;
 new nuhref set nuhref="<form method=POST action=""/vapals"">"
 set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""merge"">"
 set nuhref=nuhref_"<input type=hidden name=""toien"" value="_ien_">"
 set nuhref=nuhref_"<input value=""Merge"" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 ;
 quit nuhref ; end of ppi $$MATCH^SAMIUR2
 ;
 ;
 ;
NAME(zdt,dfn,SAMIPATS) ; name w/hyperlink
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls none
 ;
 new nam set nam="Name"
 ;
 quit $get(SAMIPATS(zdt,dfn,"nuhref")) ; end of ppi $$NAME^SAMIUR2
 ;
 ;
 ;
PACKYRS(zdt,dfn,SAMIPATS) ; smoking status
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 new pkyrs set pkyrs=$get(@vals@("sippy"))
 ;
 quit pkyrs ; end of ppi $$PACKYRS^SAMIUR2
 ;
 ;
 ;
POSSIBLE(ien,dfn,SAMIPATS) ; possible match cell
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new zcell set zcell=""
 new matien set matien=$get(SAMIPATS(ien,dfn,"MATCHLOG"))
 quit:matien="" zcell
 ;
 new lroot set lroot=$$setroot^%wd("patient-lookup")
 quit:'$data(@lroot@(matien)) zcell
 ;
 set zcell=zcell_$get(@lroot@(matien,"saminame"))
 set zcell=zcell_"<br>Date of Birth: "_$get(@lroot@(matien,"sbdob"))
 set zcell=zcell_" Gender: "_$get(@lroot@(matien,"sex"))
 ;
 new tssn set tssn=$get(@lroot@(matien,"ssn"))
 new ssn set ssn=tssn
 if tssn'["-" set ssn=$extract(tssn,1,3)_"-"_$extract(tssn,4,5)_"-"_$extract(tssn,6,9)
 set zcell=zcell_"<br>SSN: "_ssn
 ;
 set zcell=zcell_"<br>dfn: "_$get(@lroot@(matien,"dfn"))
 ;
 quit zcell ; end of ppi $$POSSIBLE^SAMIUR2
 ;
 ;
 ;
RECOM(zdt,dfn,SAMIPATS) ; recommendation
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new ceform set ceform=$get(SAMIPATS(zdt,dfn,"ceform"))
 quit:ceform="" ""
 ;
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new vals set vals=$name(@root@("graph",sid,ceform))
 new cefuw set cefuw=$get(@vals@("cefuw"))
 ;
 new recom set recom=""
 set recom=$select(cefuw="1y":"Annual Repeat",cefuw="nw":"Now",cefuw="1m":"1 month",cefuw="3m":"3 months",cefuw="6m":"6 months",cefuw="os":"Other",1:"")
 if $get(@vals@("cefuaf"))="y" set recom=recom_", Antibiotics"
 if $get(@vals@("cefucc"))="y" set recom=recom_", Contrast CT"
 if $get(@vals@("cefupe"))="y" set recom=recom_", PET"
 if $get(@vals@("cefufn"))="y" set recom=recom_", Percutaneous biopsy"
 if $get(@vals@("cefubr"))="y" set recom=recom_", Bronchoscopy"
 if $get(@vals@("cefupc"))="y" set recom=recom_", Pulmonary consultation"
 if $get(@vals@("cefutb"))="y" set recom=recom_", Refer to tumor board"
 if $get(@vals@("cefunf"))="y" set recom=recom_", No other further follow-up"
 if $extract(recom,1,2)=", " set recom=$extract(recom,3,$length(recom))
 ;
 quit recom ; end of ppi $$RECOM^SAMIUR2
 ;
 ;
 ;
RURAL(zdt,dfn,SAMIPATS) ; patient's rural/urban status
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 new sirs set sirs=$get(@vals@("sirs"))
 set sirs=$select(sirs="r":"rural",sirs="u":"urban",sirs="n":"unknown",1:"unknown")
 ;
 quit sirs ; end of ppi $$RURAL^SAMIUR2
 ;
 ;
 ;
SID(zdt,dfn,SAMIPATS) ; study ID
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$DFN2SID
 ;
 quit $$DFN2SID(dfn) ; end of ppi $$SID^SAMIUR2
 ;
 ;
 ;
SMHIS(zdt,dfn,SAMIPATS) ; smoking history cell
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$DFN2SID
 ; $$SHDET
 ;
 new zrtn set zrtn=""
 set zrtn=zrtn_"<div class=""row""><div class=""col-md-12""><table class=""table"" id=""pack-years-history"">"
 set zrtn=zrtn_"<thead><tr><th>Form </th><th> Reported Date </th>"
 set zrtn=zrtn_"<th>Pack Years</th><th>Cumulative</th></tr></thead><tbody>"
 set zrtn=zrtn_$$SHDET($$DFN2SID(dfn))
 set zrtn=zrtn_"</tbody></table></div></div>"
 ;
 quit zrtn ; end of ppi $$SMHIS^SAMIUR2
 ;
 ;
 ;
SMKSTAT(zdt,dfn,SAMIPATS) ; smoking status
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 ;
 new smk set smk="unknown"
 if $get(@vals@("siesm"))="n" set smk="Never smoked"
 if $get(@vals@("siesm"))="p" set smk="Past smoker"
 if $get(@vals@("siesm"))="c" set smk="Current smoker"
 ; if $get(@vals@("siesq"))=1 set smk="Cu"
 ;
 quit smk ; end of ppi $$SMKSTAT^SAMIUR2
 ;
 ;
 ;
SSN(zdt,dfn,SAMIPATS) ; social security number
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls none
 ;
 new tssn set tssn=$get(SAMIPATS(zdt,dfn,"ssn"))
 new ssn set ssn=tssn
 if ssn'["-" do
 . set ssn=$extract(tssn,1,3)_"-"_$extract(tssn,4,5)_"-"_$extract(tssn,6,9)
 . quit
 ;
 quit ssn ; end of ppi $$SSN^SAMIUR2
 ;
 ;
 ;
SSNLABEL(SITE) ; extrinsic returns label for SSN (ie PID)
 new RTN
 set RTN=$$GET1PARM^SAMIPARM("socialSecurityNumber",SITE)
 if RTN="" set RTN="SSN"
 quit RTN
 ;
 ;
 ;
STUDYDT(zdt,dfn,SAMIPATS) ; latest study date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$TDDT
 ;
 new stdt set stdt=$get(SAMIPATS(zdt,dfn,"cedos"))
 ;
 quit $$TDDT(stdt) ; end of ppi $$STUDYDT^SAMIUR2
 ;
 ;
 ;
STUDYTYP(zdt,dfn,SAMIPATS) ; latest study type
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new ceform set ceform=$get(SAMIPATS(zdt,dfn,"ceform"))
 quit:ceform="" ""
 ;
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new vals set vals=$name(@root@("graph",sid,ceform))
 new stypx set stypx=$get(@vals@("cetex"))
 new styp set styp=$select(stypx="a":"Annual",stypx="b":"Baseline",stypx="d":"Followup",1:"")
 ;
 quit styp ; end of ppi $$STUDYTYP^SAMIUR2
 ;
 ;
 ;
VALS(zdt,dfn,SAMIPATS) ; form-values cell
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$DFN2SID
 ;
 new vrtn set vrtn=""
 new vsid set vsid=$$DFN2SID(dfn)
 new vgr set vgr="/vals?sid="_vsid_"&form="
 quit:'$data(SAMIPATS)
 ;
 new vzi set vzi=""
 for  do  quit:vzi="sort"  quit:vzi=""
 . set vzi=$order(SAMIPATS(zdt,dfn,"items",vzi))
 . quit:vzi="sort"
 . quit:vzi=""
 . set vrtn=vrtn_"<a href="""_vgr_vzi_""">"_vzi_"</a><br>"
 . quit
 ;
 quit vrtn ; end of $$VALS^SAMIUR2
 ;
 ;
 ;
WHEN(zdt,dfn,SAMIPATS) ; followup text
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new ceform set ceform=$get(SAMIPATS(zdt,dfn,"ceform"))
 quit:ceform="" ""
 ;
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new vals set vals=$name(@root@("graph",sid,ceform))
 new whnx set whnx=$get(@vals@("cefuw"))
 quit:whnx="" ""
 ;
 new DICT
 set DICT("cefuw","1m")="in one month"
 set DICT("cefuw","1y")="in one year"
 set DICT("cefuw","3m")="in three months"
 set DICT("cefuw","6m")="in six months"
 set DICT("cefuw","os")="other as specified"
 set whn=$get(DICT("cefuw",whnx))
 ;
 quit whn ; end of ppi $$WHEN^SAMIUR2
 ;
 ;
 ;
WORKPAT(ien,dfn,SAMIPATS) ; worklist patient name cell
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls none
 ;
 new zcell set zcell=""
 set zcell=zcell_$get(SAMIPATS(ien,dfn,"workref"))
 ;
 quit zcell ; end of ppi $$WORKPAT^SAMIUR2
 ;
 ;
 ;
 ;@section 5 unused subroutines
 ;
 ;
 ;
EPAT(ien,dfn,SAMIPATS) ; patient name w/nav to enrollment
 ;
 ;;private;procedure;clean;silent;sac
 ;@called-by none
 ;@calls none
 ;
 quit  ; end of $$EPAT
 ;
 ;
 ;
ETHNCTY(zdt,dfn,SAMIPATS) ; ethnicity
 ;
 ;;private;function;clean;silent;sac
 ;@called-by none
 ;@calls none
 ;
 quit "ethnicity" ; end of $$ETHNCTY
 ;
 ;
 ;
RACE(zdt,dfn,SAMIPATS) ; race
 ;
 ;;private;function;clean;silent;sac
 ;@called-by none [call commented out in RPTTBL]
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new race set race=$get(@root@(dfn,"race"))
 ;
 quit race ; end of $$RACE
 ;
 ;
 ;
STATUS(zdt,dfn,SAMIPATS) ; patient status
 ;
 ;;private;function;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(@root@(dfn,"samistudyid"))
 new siform set siform=$get(SAMIPATS(zdt,dfn,"siform"))
 new vals set vals=$name(@root@("graph",sid,siform))
 new stat set stat=$get(@vals@("sistatus"))
 ;
 quit stat ; end of $$STATUS
 ;
 ;
 ;
WSVALS(RTN,FILTER) ; display form values from graph
 ;
 ;;web service;procedure;clean;silent;sac
 ;@called-by none
 ;@calls
 ; $$setroot^%wd
 ; wsGtree^SYNVPR
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new sid set sid=$get(FILTER("sid"))
 if sid="" set sid=$get(FILTER("studyid"))
 quit:sid=""
 ;
 new zform set zform=$get(FILTER("form"))
 new groot
 if zform="" set groot=$name(@root@("graph",sid))
 else  set groot=$name(@root@("graph",sid,zform))
 set FILTER("root")=$extract(groot,2,$length(groot))
 ;
 do wsGtree^SYNVPR(.RTN,.FILTER)
 ;
 quit  ; end of ws WSVALS^SAMIUR2
 ;
 ;
 ;
EOR ; end of routine SAMIUR2
