SAMIUR2 ;ven/gpl - sami user reports ;2021-05-21T14:57Z
 ;;18.0;SAMI;**5,11**;2020-01;Build 11
 ;;1.18.0.11-i11
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
 ;@primary-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-05-21T14:57Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11-i11
 ;@release-date 2020-01
 ;@patch-list **5,11**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@additional-dev Alexis R. Carlson (arc)
 ; whatisthehumanspirit@gmail.com
 ;@additional-dev Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@module-credits
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
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2019-02-10/14 ven/gpl 1.18.0 d543f7b,f9869df,5e67489
 ;  SAMIUR2: 1st version of revised user reports, progress, add rural/
 ; urban & compute.
 ;
 ; 2019-03-24/28 ven/gpl 1.18.0 1fd4a4c,0cebb36
 ;  SAMIUR2: revise incomplete form report, remove ethnicity from
 ; enrollment report (we can't get it).
 ;
 ; 2019-05-08 ven/lgc 1.18.0 2172e51
 ;  SAMIUR2: remove blank last line.
 ;
 ; 2019-06-21 par/dom 1.18.0 c6a4a57 VAP-352
 ;  SAMIUR2: proper spelling of "follow up."
 ;
 ; 2019-08-03/04 ven/gpl 1.18.0 ffc94f6,d03557d,cd865e2 VPA-438
 ;  SAMIUR2: fix smoking status on enrollment report, fix change log
 ; display, add pack years at intake to enrollment report, add
 ; requested changes to followup report.
 ;
 ; 2019-09-26 ven/gpl 1.18.0 92b1232 VAP-420
 ;  SAMIUR2: smoking history, new cummulative packyear processing.
 ;
 ; 2019-10-01 par/dom 1.18.0 4caf1a9 VAP-344
 ;  SAMIUR2: make capitalization consistent.
 ;
 ; 2020-01-01/05 ven/arc 1.18.0 399f854,62e3200
 ;  SAMIUR2: add unmatched patient processing.
 ;
 ; 2020-01-10 ven/gpl 1.18.0 1590577
 ;  SAMIUR2: fix return on RACE^SAMIUR2 for cache.
 ;
 ; 2020-05-13/14 ven/gpl 1.18.0.5-i5 61c7d20,b05df41
 ;  SAMIUR2: add worklist functionality, fix gender & dob detection on
 ; reports.
 ;
 ; 2021-04-13 ven/gpl 1.18.0.11-i11 a12765b,f09ffef,fb399ab
 ;  SAMIUR2: in RPTTBL,GENDER create inactive report, move last exam
 ; column on followup report, fix gender being blank in reports.
 ;
 ; 2021-05-20/21 ven/mcglk&toad 1.18.0.11-i11
 ;  SAMIUR2: passim hdr comments, chg log, annotate, refactor, bump
 ; version.
 ;
 ;@contents
 ; RPTTBL build report-definition table
 ;
 ; $$DFN2SID study id for patient DFN
 ; $$MKNAV html for navigation to form
 ;
 ; $$SHDET table contents for smoking history
 ; CUMPY forms array of cummulative pack year data
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
RPTTBL(RPT,TYPE) ; build report-definition table
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
 . set RPT(3,"header")="SSN"
 . set RPT(3,"routine")="$$SSN^SAMIUR2"
 . set RPT(4,"header")="Baseline Date"
 . set RPT(4,"routine")="$$BLINEDT^SAMIUR2"
 . set RPT(6,"header")="Recommend"
 . set RPT(6,"routine")="$$RECOM^SAMIUR2"
 . set RPT(7,"header")="When"
 . set RPT(7,"routine")="$$WHEN^SAMIUR2"
 . set RPT(5,"header")="Last Exam"
 . set RPT(5,"routine")="$$LASTEXM^SAMIUR2"
 . set RPT(8,"header")="Contact Information"
 . set RPT(8,"routine")="$$CONTACT^SAMIUR2"
 . quit
 ;
 if TYPE="activity" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . set RPT(2,"header")="SSN"
 . set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(3,"header")="CT Date"
 . set RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . set RPT(4,"header")="Type"
 . set RPT(4,"routine")="$$STUDYTYP^SAMIUR2"
 . set RPT(5,"header")="CT Protocol"
 . set RPT(5,"routine")="$$CTPROT^SAMIUR2"
 . set RPT(6,"header")="Follow-up"
 . set RPT(6,"routine")="$$RECOM^SAMIUR2"
 . set RPT(7,"header")="When"
 . set RPT(7,"routine")="$$WHEN^SAMIUR2"
 . set RPT(8,"header")="on Date"
 . set RPT(8,"routine")="$$FUDATE^SAMIUR2"
 . quit
 ;
 if TYPE="enrollment" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . set RPT(2,"header")="SSN"
 . set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(3,"header")="CT Date"
 . set RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . set RPT(4,"header")="Gender"
 . set RPT(4,"routine")="$$GENDER^SAMIUR2"
 . ; set RPT(5,"header")="Race"
 . ; set RPT(5,"routine")="$$RACE^SAMIUR2"
 . set RPT(6,"header")="Age"
 . set RPT(6,"routine")="$$AGE^SAMIUR2"
 . set RPT(7,"header")="Urban/Rural"
 . set RPT(7,"routine")="$$RURAL^SAMIUR2"
 . set RPT(8,"header")="Smoking Status"
 . set RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 . set RPT(9,"header")="Pack Years at Intake"
 . set RPT(9,"routine")="$$PACKYRS^SAMIUR2"
 . quit
 ;
 if TYPE="inactive" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$NAME^SAMIUR2"
 . set RPT(2,"header")="SSN"
 . set RPT(2,"routine")="$$SSN^SAMIUR2"
 . set RPT(3,"header")="CT Date"
 . set RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . set RPT(4,"header")="Gender"
 . set RPT(4,"routine")="$$GENDER^SAMIUR2"
 . ; set RPT(5,"header")="Race"
 . ; set RPT(5,"routine")="$$RACE^SAMIUR2"
 . set RPT(6,"header")="Age"
 . set RPT(6,"routine")="$$AGE^SAMIUR2"
 . set RPT(7,"header")="Urban/Rural"
 . set RPT(7,"routine")="$$RURAL^SAMIUR2"
 . set RPT(8,"header")="Smoking Status"
 . set RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 . set RPT(9,"header")="Pack Years at Intake"
 . set RPT(9,"routine")="$$PACKYRS^SAMIUR2"
 . quit
 ;
 if TYPE="incomplete" do  quit  ;
 . set RPT(1,"header")="Enrollment date"
 . set RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . set RPT(2,"header")="Name"
 . set RPT(2,"routine")="$$NAME^SAMIUR2"
 . set RPT(3,"header")="SSN"
 . set RPT(3,"routine")="$$SSN^SAMIUR2"
 . set RPT(4,"header")="Incomplete form"
 . set RPT(4,"routine")="$$IFORM^SAMIUR2"
 . quit
 ;
 if TYPE="missingct" do  quit  ;
 . set RPT(1,"header")="Enrollment date"
 . set RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . set RPT(2,"header")="Name"
 . set RPT(2,"routine")="$$NAME^SAMIUR2"
 . set RPT(3,"header")="SSN"
 . set RPT(3,"routine")="$$SSN^SAMIUR2"
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
 if TYPE="unmatched" do  ;
 . set RPT(1,"header")="Unmatched Entry"
 . set RPT(1,"routine")="$$MANPAT^SAMIUR2"
 . set RPT(2,"header")="Possible Match"
 . set RPT(2,"routine")="$$POSSIBLE^SAMIUR2"
 . set RPT(3,"header")="Match Control"
 . set RPT(3,"routine")="$$MATCH^SAMIUR2"
 . quit
 ;
 if TYPE="worklist" do  quit  ;
 . set RPT(1,"header")="Name"
 . set RPT(1,"routine")="$$WORKPAT^SAMIUR2"
 . set RPT(2,"header")="SSN"
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
 new set zend=$$FMDT(ENDT)
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
 ;
BLINEDT(zdt,dfn,SAMIPATS) ; baseline date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls none
 ;
 new bldt set bldt=$get(SAMIPATS(zdt,dfn,"edate"))
 ;
 quit bldt ; end of ppi $$BLINEDT^SAMIUR2
 ;
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
 ;@calls none
 ;
 new dob set dob=$get(SAMIPATS(ien,dfn,"dob"))
 if dob="" set dob=$get(SAMIPATS(ien,dfn,"sbdob"))
 ;
 quit dob ; end of ppi $$DOB^SAMIUR2
 ;
 ;
 ;
FUDATE(zdt,dfn,SAMIPATS) ; followup date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls none
 ;
 new fud set fud="fudate"
 ;
 quit $get(SAMIPATS(zdt,dfn,"cefud")) ; end of ppi $$FUDATE^SAMIUR2
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
 . if zkey1["fuform" set fname="Follow-up" set typ="fuform"
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
 ;@calls none
 ;
 new lexm set lexm=$get(SAMIPATS(zdt,dfn,"cedos"))
 ;
 quit lexm ; end of ppi $$LASTEXM^SAMIUR2
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
STUDYDT(zdt,dfn,SAMIPATS) ; latest study date
 ;
 ;;ppi;function;clean;silent;sac
 ;@called-by
 ; WSREPORT^SAMIUR
 ;@calls none
 ;
 new stdt set stdt=$get(SAMIPATS(zdt,dfn,"cedos"))
 ;
 quit stdt ; end of ppi $$STUDYDT^SAMIUR2
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
