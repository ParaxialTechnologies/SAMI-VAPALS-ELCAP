SAMIUR ;ven/gpl - user reports ;2021-03-30T15:50Z
 ;;18.0;SAMI;**5,10,11**;2020-01;Build 4
 ;;1.18.0.11-i11
 ;
 ; SAMIUR contains a web service & associated subroutines to produce
 ; the VAPALS-ELCAP user reports.
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
 ;@last-updated 2021-03-30T15:50Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.11-i11
 ;@release-date 2020-01
 ;@patch-list **5,10,11**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@additional-dev Alexis R. Carlson (arc)
 ; whatisthehumanspirit@gmail.com
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
 ; 2020-02-10/12 ven/gpl 1.18.0-t04 d543f7bb,f9869dfb,0e4d8b9a
 ;  SAMIUR: 1st version of revised user reports, progress on user
 ; reports, fixed a bug in enrollment report.
 ;
 ; 2020-02-18 ven/lgc 1.18.0-t04 76874314
 ;  SAMIUR: update recently edited routines.
 ;
 ; 2020-03-10/12 ven/gpl 1.18.0-t04 8de06b06,4ad52d64
 ;  SAMIUR: user report date filtering, fix end date logic in UR.
 ;
 ; 2020-04-16/23 ven/lgc 1.18.0-t04 e54b76d1b,89bffd3b
 ;  SAMIUR: SAMIFRM2 > SAMIFORM, SAMISUB2 > LOAD.
 ;
 ; 2020-08-04 ven/gpl 1.18.0-t04 cd865e2b VPA-438
 ;  SAMIUR: requested changes to followup report.
 ;
 ; 2020-09-26 ven/gpl 1.18.0-t04 92b12324 VAP-420
 ;  SAMIUR: add smoking history.
 ;
 ; 2020-01-01/05 ven/arc 1.18.0 399f8547,62e3200f
 ;  SAMIUR: unmatched participant processing.
 ;
 ; 2020-04-29/05-13 ven/gpl 1.18.0.5-i5 e8b8ea2d,61c7d208
 ;  SAMIUR: fixes for reports, worklist functionality.
 ;
 ; 2021-03-22/23 ven/gpl 1.18.0.10-i10 256efe63,ba81b86a2
 ;  SAMIUR: sort all reports by name, added row totals to reports.
 ;
 ; 2021-03-23 ven/toad 1.18.0.10-i10 96f461d0,af86e0eb
 ; SAMIUR: add version info & dev log, lt refactor, fix XINDEX errors.
 ;
 ; 2021-03-29 ven/gpl 1.18.0.11-i11 e809f2a2
 ;  SAMIUR: prevent crash when reports have no matches: in WSREPORT
 ; set SRT="" and uncomment zwrite SRT; in WKLIST add 2 commented-out
 ; debugging lines.
 ;
 ; 2021-03-30 ven/toad 1.18.0.11-i11
 ; SAMIUR: bump version, date, log; in WSREPORT comment zwrite SRT.
 ;
 ;
 ;
WSREPORT(SAMIRTN,filter) ; generate a report based on parameters in the filter
 ;
 ; here are the user reports that are defined:
 ;  1. followup
 ;  2. activity
 ;  3. missingct
 ;  4. incomplete
 ;  5. outreach
 ;  6. enrollment
 ;  7. worklist
 ; the report to generate is passed in parameter samireporttype
 ;
 n debug s debug=0
 i $g(filter("debug"))=1 s debug=1
 i $g(filter("debug"))=1 s debug=1
 k SAMIRTN
 s HTTPRSP("mime")="text/html"
 ;
 n type,temp,site
 s site=$g(filter("siteid"))
 i site="" s site=$g(filter("site"))
 i site="" d  q  ; report site missing
 . d GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 ;
 s type=$g(filter("samireporttype"))
 i type="" d  q  ; report type missing
 . d GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 ;
 i type="unmatched" i $$GET1PARM^SAMIPARM("redactMatchingReport",site) d  q  ;
 . d GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 ;
 d getThis^%wd("temp","table.html") ; page template
 q:'$d(temp)
 ;
 n SAMIPATS
 ;s pats=""
 n datephrase
 d SELECT(.SAMIPATS,type,.datephrase,.filter) ; select patients for the report
 ;q:'$d(SAMIPATS)
 ;
 n ln,cnt,ii
 s (ii,ln,cnt)=0
 f  s ii=$o(temp(ii)) q:+ii=0  q:$g(temp(ii))["<thead"  d  ;
 . s cnt=cnt+1
 . s ln=$g(temp(ii))
 . n samikey,si
 . s (samikey,si)=""
 . d LOAD^SAMIFORM(.ln,samikey,si,.filter)
 . ;i ln["PAGE NAME" d findReplace^%ts(.ln,"PAGE NAME",$$PNAME(type,datephrase))
 . i ln["PAGE NAME" d findReplace^%ts(.ln,"PAGE NAME",$$PNAME(type,""))
 . i ln["CRITERIA" d findReplace^%ts(.ln,"CRITERIA",datephrase)
 . i ln["@@REPORTTYPE@@" d findReplace^%ts(.ln,"@@REPORTTYPE@@",type)
 . ;
 . i ln["name=""start-date""" d findReplace^%ts(.ln,"start-date""","start-date"" value="""_$g(filter("start-date"))_"""")
 . i ln["name=""end-date""" d findReplace^%ts(.ln,"end-date""","end-date"" value="""_$g(filter("end-date"))_"""")
 . s SAMIRTN(cnt)=ln
 . ;
 n RPT,ik
 d RPTTBL^SAMIUR2(.RPT,type,site) ; get the report specs
 i '$d(RPT) d  q  ; don't know about this report
 . d GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 ;
 ; output the header
 ;
 s cnt=cnt+1 s SAMIRTN(cnt)="<thead><tr>"
 s cnt=cnt+1
 n totcnt s totcnt=cnt
 s ir=""
 f  s ir=$o(RPT(ir)) q:ir=""  d  ;
 . s cnt=cnt+1
 . s SAMIRTN(cnt)="<th>"_$g(RPT(ir,"header"))_"</th>"
 s cnt=cnt+1 s SAMIRTN(cnt)="</tr></thead>"
 ;
 s cnt=cnt+1 s SAMIRTN(cnt)="<tbody>"
 ;
 i type'="worklist" d  ; 
 . d NUHREF(.SAMIPATS) ; create the nuhref link for all patients
 ;
 n SRT s SRT=""
 i $g(filter("sort"))="" s filter("sort")="name"
 d SORT(.SRT,.SAMIPATS,.filter)
 ;zwr SRT
 ;
 ;s ij=0
 ;f  s ij=$o(SAMIPATS(ij)) q:+ij=0  d  ;
 ;. n ij2 s ij2=0
 ;. f  s ij2=$o(SAMIPATS(ij,ij2)) q:+ij2=0  d  ;
 ;. . n dfn s dfn=ij2
 n iz,ij,ij2,dfn,rows
 s rows=0
 s (iz,ij,ij2,dfn)=""
 f  s iz=$o(SRT(iz)) q:iz=""  d  ;
 . s ij=$o(SRT(iz,""))
 . s dfn=$o(SRT(iz,ij,""))
 . d  ;
 . . s cnt=cnt+1 s SAMIRTN(cnt)="<tr>"
 . . s ir=""
 . . f  s ir=$o(RPT(ir)) q:ir=""  d  ;
 . . . s cnt=cnt+1
 . . . n XR,XRV
 . . . ;s XR=$g(RPT(ir,"routine"))_"("_ij_",.SAMIPATS)"
 . . . s XR="S XRV="_$g(RPT(ir,"routine"))_"("_ij_","_dfn_",.SAMIPATS)"
 . . . ;s XRV=@XR
 . . . X XR
 . . . s SAMIRTN(cnt)="<td>"_$g(XRV)_"</td>"
 . . ;
 . . s cnt=cnt+1
 . . s SAMIRTN(cnt)="</tr>"_$CHAR(10,13)
 . . s rows=rows+1
 s cnt=cnt+1
 s SAMIRTN(cnt)="<tr><td>Total: "_rows_"</td></tr>"
 s SAMIRTN(totcnt)="<td>Total: "_rows_"</td></tr><tr>"
 ;
 s cnt=cnt+1 s SAMIRTN(cnt)="</tbody>"
 f  s ii=$o(temp(ii)) q:temp(ii)["</tbody>"  d  ;
 . ; skip past template headers and blank body
 f  s ii=$o(temp(ii)) q:+ii=0  d  ;
 . s cnt=cnt+1
 . s ln=$g(temp(ii))
 . n samikey,si
 . s (samikey,si)=""
 . d LOAD^SAMIFORM(.ln,samikey,si,.filter)
 . s SAMIRTN(cnt)=ln
 ;
 quit  ; end of WSREPORT
 ;
 ;
 ;
SORT(SRTN,SAMIPATS,FILTER) ;
 n typ s typ=$g(FILTER("sort"))
 i typ="" s typ="name"
 n iz,dt,dfn,nm
 s (dt,dfn,nm)=""
 s iz=0
 n indx
 f  s dt=$o(SAMIPATS(dt)) q:+dt=0  d  ;
 . f  s dfn=$o(SAMIPATS(dt,dfn)) q:+dfn=0  d  ;
 . . i typ="name" d  ;
 . . . s nm=$g(SAMIPATS(dt,dfn,"name"))
 . . . s nm=$$UPCASE^XLFMSMT(nm)
 . . . i nm="" s nm=" "
 . . . s indx(nm,dt,dfn)=""
 n iiz s iiz=""
 s (dt,dfn)=""
 f  s iiz=$o(indx(iiz)) q:iiz=""  d  ;
 . f  s dt=$o(indx(iiz,dt)) q:dt=""  d  ;
 . . f  s dfn=$o(indx(iiz,dt,dfn)) q:dfn=""  d  ;
 . . . s iz=iz+1
 . . . s SRTN(iz,dt,dfn)=iiz
 ;
 quit  ; end of SORT
 ;
 ;
 ;
NUHREF(SAMIPATS) ; create the nuhref link to casereview for all patients
 n ij
 n root s root=$$setroot^%wd("vapals-patients")
 s ij=0
 f  s ij=$o(SAMIPATS(ij)) q:+ij=0  d  ;
 . n ij2 s ij2=0
 . f  s ij2=$o(SAMIPATS(ij,ij2)) q:+ij2=0  d  ;
 . . n dfn s dfn=ij2
 . . s SAMIPATS(ij,dfn,"sid")=$g(@root@(dfn,"samistudyid"))
 . . n sid s sid=SAMIPATS(ij,dfn,"sid")
 . . s SAMIPATS(ij,dfn,"name")=$g(@root@(dfn,"saminame"))
 . . n name s name=SAMIPATS(ij,dfn,"name")
 . . s SAMIPATS(ij,dfn,"ssn")=$$GETSSN^SAMIFORM(sid)
 . . new nuhref set nuhref="<form method=POST action=""/vapals"">"
 . . set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""casereview"">"
 . . set nuhref=nuhref_"<input type=hidden name=""studyid"" value="_sid_">"
 . . set nuhref=nuhref_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 . . s SAMIPATS(ij,dfn,"nuhref")=nuhref
 ;
 quit  ; end of NUHREF
 ;
 ;
 ;
SELECT(SAMIPATS,ztype,datephrase,filter) ;selects patients for report
 ;
 ;m ^gpl("select")=filter
 n site s site=$g(filter("siteid"))
 i site="" s site=$g(filter("site"))
 q:site=""
 s SAMIPATS("siteid")=site
 n type s type=ztype
 i type="unmatched" d  q  ;
 . d UNMAT(.SAMIPATS,ztype,.datephrase,.filter)
 i type="worklist" d  q  ;
 . d WKLIST(.SAMIPATS,ztype,.datephrase,.filter)
 i $g(type)="" s type="enrollment"
 i type="cumpy" s type="enrollment"
 n strdt,enddt,fmstrdt,fmenddt
 s strdt=$g(filter("start-date"))
 s fmstrdt=$$KEY2FM^SAMICASE(strdt)
 i fmstrdt=-1 d  ;
 . s fmstrdt=2000101
 . i type="followup" s fmstrdt=$$NOW^XLFDT
 . i type="activity" s fmstrdt=$$FMADD^XLFDT($$NOW^XLFDT,-31)
 i strdt="" s filter("start-date")=$$VAPALSDT^SAMICASE(fmstrdt)
 s enddt=$g(filter("end-date"))
 s fmenddt=$$KEY2FM^SAMICASE(enddt)
 i fmenddt=-1 d  ;
 . s fmenddt=$$NOW^XLFDT
 . i type="followup" s fmenddt=$$FMADD^XLFDT($$NOW^XLFDT,31)
 i enddt="" s filter("end-date")=$$VAPALSDT^SAMICASE(fmenddt)
 s datephrase=""
 n zi s zi=0
 n root s root=$$setroot^%wd("vapals-patients")
 ;
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . n sid s sid=$g(@root@(zi,"samistudyid"))
 . q:sid=""
 . q:$e(sid,1,3)'=site
 . n items s items=""
 . d GETITEMS^SAMICASE("items",sid)
 . q:'$d(items)
 . n efmdate,edate,siform,ceform,cefud,fmcefud,cedos,fmcedos
 . s siform=$o(items("siform-"))
 . n inactive s inactive=$g(@root@("graph",sid,siform,"sistatus"))
 . i type="inactive" i inactive'="inactive" q  ; for inactive report
 . i type'="inactive" i inactive="inactive" q  ; for other reports
 . s ceform=$o(items("ceform-a"),-1)
 . s (cefud,fmcefud,cedos,fmcedos)=""
 . i ceform'="" d  ;
 . . s cefud=$g(@root@("graph",sid,ceform,"cefud"))
 . . i cefud'="" s fmcefud=$$KEY2FM^SAMICASE(cefud)
 . . s cedos=$g(@root@("graph",sid,ceform,"cedos"))
 . . i cedos'="" s fmcedos=$$KEY2FM^SAMICASE(cedos)
 . s edate=$g(@root@("graph",sid,siform,"sidc"))
 . i edate="" s edate=$g(@root@("graph",sid,siform,"samicreatedate"))
 . s efmdate=$$KEY2FM^SAMICASE(edate)
 . s edate=$$VAPALSDT^SAMICASE(efmdate)
 . ;
 . i type="followup" d  ;
 . . ;n nplus30 s nplus30=$$FMADD^XLFDT($$NOW^XLFDT,31)
 . . i +fmcefud<fmstrdt q  ; before start date
 . . i (+fmcefud<(fmenddt+1)) d  ; before end date
 . . . i ceform="" q  ; no ct eval so no followup date
 . . . s SAMIPATS(fmcefud,zi,"edate")=edate
 . . . s SAMIPATS(fmcefud,zi)=""
 . . . i ceform="" s cefud="baseline"
 . . . s SAMIPATS(fmcefud,zi,"cefud")=cefud
 . . . s SAMIPATS(fmcefud,zi,"cedos")=cedos
 . . . s SAMIPATS(fmcefud,zi,"ceform")=ceform
 . . . s SAMIPATS(fmcefud,zi,"ceform-vals")=$na(@root@("graph",sid,ceform))
 . . . s SAMIPATS(fmcefud,zi,"siform")=siform
 . . . s SAMIPATS(fmcefud,zi,"siform-vals")=$na(@root@("graph",sid,siform))
 . . . m SAMIPATS(fmcefud,zi,"items")=items
 . . s datephrase=" before "_$$VAPALSDT^SAMICASE(fmenddt)
 . . q
 . i type="activity" d  ;
 . . ;n nminus30 s nminus30=$$FMADD^XLFDT($$NOW^XLFDT,-31)
 . . n anyform s anyform=$o(items("sort",""),-1)
 . . n fmanyform s fmanyform=$$KEY2FM^SAMICASE(anyform)
 . . i +fmanyform<fmstrdt q  ; before the start date
 . . ;i (+fmanyform<(fmenddt+1))!(+efmdate>fmenddt) d  ; need any new form
 . . i (+fmanyform<(fmenddt+1))  d  ;
 . . . s SAMIPATS(efmdate,zi,"edate")=edate
 . . . s SAMIPATS(efmdate,zi)=""
 . . . i ceform="" s cefud="baseline"
 . . . s SAMIPATS(efmdate,zi,"cefud")=cefud
 . . . s SAMIPATS(efmdate,zi,"cedos")=cedos
 . . . s SAMIPATS(efmdate,zi,"ceform")=ceform
 . . . s SAMIPATS(efmdate,zi,"siform")=siform
 . . . m SAMIPATS(efmdate,zi,"items")=items
 . . s datephrase=" after "_$$VAPALSDT^SAMICASE(fmstrdt)
 . ;
 . ; date filter for all the rest of the reports
 . ;
 . i efmdate<fmstrdt q  ; before the start date
 . i efmdate>(fmenddt+1) q  ; after the end date
 . ;
 . i type="incomplete" d  ;
 . . n complete s complete=1
 . . n zj s zj=""
 . . n gr s gr=$na(@root@("graph",sid))
 . . f  s zj=$o(@gr@(zj)) q:zj=""  d  ;
 . . . i $g(@gr@(zj,"samistatus"))="incomplete" d  ;
 . . . . s complete=0
 . . . . s SAMIPATS(efmdate,zi,"iform")=$g(SAMIPATS(efmdate,zi,"iform"))_" "_zj
 . . i complete=0 d  ; has incomplete form(s) 
 . . . s SAMIPATS(efmdate,zi,"edate")=edate
 . . . s SAMIPATS(efmdate,zi)=""
 . . . i ceform="" s cefud="baseline"
 . . . s SAMIPATS(efmdate,zi,"cefud")=cefud
 . . . s SAMIPATS(efmdate,zi,"ceform")=ceform
 . . . s SAMIPATS(efmdate,zi,"siform")=siform
 . . . m SAMIPATS(efmdate,zi,"items")=items
 . . s datephrase=""
 . . q
 . i type="missingct" d  ;
 . . i ceform="" d  ; has incomplete form(s) 
 . . . s SAMIPATS(efmdate,zi,"edate")=edate
 . . . s SAMIPATS(efmdate,zi)=""
 . . . i ceform="" s cefud="baseline"
 . . . s SAMIPATS(efmdate,zi,"cefud")=cefud
 . . . s SAMIPATS(efmdate,zi,"ceform")=ceform
 . . . s SAMIPATS(efmdate,zi,"siform")=siform
 . . . m SAMIPATS(efmdate,zi,"items")=items
 . . s datephrase=""
 . . q
 . i type="outreach" d  ;
 . . q
 . i type="enrollment" d  ;
 . . s SAMIPATS(efmdate,zi,"edate")=edate
 . . s SAMIPATS(efmdate,zi)=""
 . . s SAMIPATS(efmdate,zi,"cefud")=cefud
 . . s SAMIPATS(efmdate,zi,"ceform")=ceform
 . . s SAMIPATS(efmdate,zi,"cedos")=cedos
 . . s SAMIPATS(efmdate,zi,"siform")=siform
 . . m SAMIPATS(efmdate,zi,"items")=items
 . i type="inactive" d  ;
 . . s SAMIPATS(efmdate,zi,"edate")=edate
 . . s SAMIPATS(efmdate,zi)=""
 . . s SAMIPATS(efmdate,zi,"cefud")=cefud
 . . s SAMIPATS(efmdate,zi,"ceform")=ceform
 . . s SAMIPATS(efmdate,zi,"cedos")=cedos
 . . s SAMIPATS(efmdate,zi,"siform")=siform
 . . m SAMIPATS(efmdate,zi,"items")=items
 . s datephrase=" as of "_$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 ;
 quit  ; end of SELECT
 ;
 ;
 ;
UNMAT(SAMIPATS,ztype,datephrase,filter) ;
 ;
 n site
 s site=$g(filter("siteid"))
 i site="" s site=$g(filter("site"))
 i site="" s site=$g(SAMIPATS("siteid"))
 q:site=""
 ;n ssnlbl s ssnlbl=$$GET1PARM^SAMIPARM("socialSecurityNumber",site)
 s datephrase="Unmatched Persons"
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 ;n dfn s dfn=9000000
 n dfn s dfn=0
 f  s dfn=$o(@lroot@("dfn",dfn)) q:+dfn=0  d  ;
 . n ien s ien=$o(@lroot@("dfn",dfn,""))
 . q:ien=""
 . n ordern
 . s ordern=$g(@lroot@(ien,"ORMORCordernumber"))
 . i ordern="" s ordern=$g(@lroot@(ien,"ORM",1,"ordernumber"))
 . i ordern'="" q  ;
 . i $g(@lroot@(ien,"siteid"))'[site q  ;
 . m SAMIPATS(ien,dfn)=@lroot@(ien)
 . new name set name=$g(SAMIPATS(ien,dfn,"saminame"))
 . ;new name set name=$g(SAMIPATS(ien,dfn,"sinamef"))
 . ;set name=name_","_SAMIPATS(ien,dfn,"sinamel")
 . new nuhref set nuhref="<form method=POST action=""/vapals"">"
 . set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""editperson"">"
 . set nuhref=nuhref_"<input type=hidden name=""siteid"" value="_site_">"
 . set nuhref=nuhref_"<input type=hidden name=""dfn"" value="_dfn_">"
 . set nuhref=nuhref_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"_$CHAR(10,13)
 . s SAMIPATS(ien,dfn,"editref")=nuhref
 ;
 quit  ; end of UNMAT
 ;
 ;
 ;
WKLIST(SAMIPATS,ztype,datephrase,filter) ;
 ;
 ; add site
 ; add compare to vapals-patients
 ; add navigation to enrollment
 ;
 k ^gpl("worklist")
 m ^gpl("worklist")=filter
 n site
 s site=$g(filter("siteid"))
 q:site=""
 s datephrase="Work List"
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 n dfn s dfn=0
 f  s dfn=$o(@lroot@("dfn",dfn)) q:+dfn=0  d  ;
 . q:$o(@proot@("dfn",dfn,""))'=""
 . n ien s ien=$o(@lroot@("dfn",dfn,""))
 . q:ien=""
 . ;w !,"dfn= ",dfn
 . ;zwr @lroot@(ien,*)
 . q:$g(@lroot@(ien,"siteid"))'=site
 . m ^gpl("worklist","lroot",ien)=@lroot@(ien)
 . m SAMIPATS(ien,dfn)=@lroot@(ien)
 . new name set name=$g(SAMIPATS(ien,dfn,"saminame"))
 . ;new name set name=$g(SAMIPATS(ien,dfn,"sinamef"))
 . ;set name=name_","_SAMIPATS(ien,dfn,"sinamel")
 . new nuhref set nuhref="<form method=POST action=""/vapals"">"
 . set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""newcase"">"
 . set nuhref=nuhref_"<input type=hidden name=""dfn"" value="_dfn_">"
 . set nuhref=nuhref_"<input type=hidden name=""siteid"" value="_site_">"
 . set nuhref=nuhref_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 . s SAMIPATS(ien,dfn,"workref")=nuhref
 m ^gpl("worklist","pats")=SAMIPATS
 ;
 quit  ; end of WKLIST
 ;
 ;
 ;
PNAME(type,phrase) ; extrinsic returns the PAGE NAME for the report
 ;
 ;i type="followup" q "Followup next 30 days -"_$g(phrase)
 i type="followup" q "Followup "_$g(phrase)
 ;i type="activity" q "Activity last 30 days -"_$g(phrase)
 i type="activity" q "Activity "_$g(phrase)
 i type="missingct" q "Intake but no CT Evaluation"_$g(phrase)
 i type="incomplete" q "Incomplete Forms"_$g(phrase)
 i type="outreach" q "Outreach"_$g(phrase)
 i type="enrollment" q "Enrollment"_$g(phrase)
 i type="inactive" q "Inactive"_$g(phrase)
 ;
 quit "" ; end of $$PNAME
 ;
 ;
 ;
EOR ; end of SAMIUR
