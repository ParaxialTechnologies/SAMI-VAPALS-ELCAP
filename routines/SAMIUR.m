SAMIUR ;ven/gpl - user reports ;2021-07-12t23:19z
 ;;18.0;SAMI;**5,10,11,12**;2020-01;Build 4
 ;;1.18.0.12-t3+i12
 ;
 ; SAMIUR contains a web service & associated subroutines to produce
 ; VAPALS-ELCAP user reports.
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
 ;@last-updated 2021-07-12t23:19z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t3+i12
 ;@release-date 2020-01
 ;@patch-list **5,10,11,12**
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
 ;@module-credits see SAMIHUL
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; see SAMIURUL
 ;
 ;@contents
 ; WSREPORT generate report based on params in filter
 ; SORT sort patients by name
 ; NUHREF create nuhref link to casereview for all patients
 ; PNAME page name for report
 ;
 ; SELECT select patients for report
 ; UNMAT build unmatched persons list
 ; WKLIST build work list
 ;
 ;
 ;
 ;@section 1 wsreport subroutines
 ;
 ;
 ;
WSREPORT(SAMIRTN,filter) ; generate report based on params in filter
 ;
 ;@called-by
 ; WSVAPALS^SAMIHOM4
 ; WSREPORT^SAMIUR1
 ;@calls
 ; GETHOME^SAMIHOM3
 ; getThis^%wd
 ; SELECT
 ; LOAD^SAMIFORM
 ; $$PNAME
 ; findReplace^%ts
 ; RPTTBL^SAMIUR2
 ; NUHREF
 ; SORT
 ; @RPT(ir,"routine"): [from report def table from RPTTBL^SAMIUR2]
 ;  format = $$<tag>^SAMIUR2, where tag =
 ;  AGE       BLINEDT   CONTACT   CTPROT   DOB      FUDATE    GENDER
 ;  IFORM     LASTEXM   MANPAT    MATCH    NAME     PACKYRS   POSSIBLE
 ;  RECOM     RURAL     SID       SMHIS    SMKSTAT  SSN       STUDYDT
 ;  STUDYTYP  VALS      WHEN      WORKPAT
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
 new debug set debug=0
 if $get(filter("debug"))=1 set debug=1
 if $get(filter("debug"))=1 set debug=1
 kill SAMIRTN
 set HTTPRSP("mime")="text/html"
 ;
 new type,temp,site
 s site=$g(filter("siteid"))
 i site="" s site=$g(filter("site"))
 i site="" d  q  ; report site missing
 . d GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 ;
 set type=$get(filter("samireporttype"))
 if type="" do  quit  ; report type missing
 . do GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 . quit
 ;
 if type="unmatched" i $$GET1PARM^SAMIPARM("matchingReportEnabled",site)'="true" do  quit  ;
 . d GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 ;
 do getThis^%wd("temp","table.html") ; page template
 quit:'$data(temp)
 ;
 new SAMIPATS
 ; set pats=""
 new datephrase
 do SELECT(.SAMIPATS,type,.datephrase,.filter) ; select pats for report
 ; quit:'$data(SAMIPATS)
 ;
 new ln,cnt,ii
 set (ii,ln,cnt)=0
 for  do  quit:'ii  quit:$get(temp(ii))["<thead"
 . set ii=$order(temp(ii))
 . quit:'ii
 . quit:$get(temp(ii))["<thead"
 . ;
 . set cnt=cnt+1
 . set ln=$get(temp(ii))
 . new samikey,si
 . set (samikey,si)=""
 . do LOAD^SAMIFORM(.ln,samikey,si,.filter)
 . ; if ln["PAGE NAME" do
 . ; . do findReplace^%ts(.ln,"PAGE NAME",$$PNAME(type,datephrase))
 . ; . quit
 . if ln["PAGE NAME" do
 . . do findReplace^%ts(.ln,"PAGE NAME",$$PNAME(type,""))
 . . quit
 . if ln["CRITERIA" do
 . . do findReplace^%ts(.ln,"CRITERIA",datephrase)
 . . quit
 . if ln["@@REPORTTYPE@@" do
 . . do findReplace^%ts(.ln,"@@REPORTTYPE@@",type)
 . . quit
 . ;
 . if ln["name=""start-date""" do
 . . do findReplace^%ts(.ln,"start-date""","start-date"" value="""_$g(filter("start-date"))_"""")
 . . quit
 . if ln["name=""end-date""" do
 . . do findReplace^%ts(.ln,"end-date""","end-date"" value="""_$g(filter("end-date"))_"""")
 . . quit
 . ;
 . set SAMIRTN(cnt)=ln
 . quit
 ;
 new RPT,ik
 do RPTTBL^SAMIUR2(.RPT,type,site) ; load report definition table
 if '$data(RPT) do  quit  ; don't know about this report
 . do GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 . quit
 ;
 ; output header
 ;
 set cnt=cnt+1 set SAMIRTN(cnt)="<thead><tr>"
 set cnt=cnt+1
 new totcnt set totcnt=cnt
 ;
 set ir=""
 for  do  quit:ir=""  ;
 . set ir=$order(RPT(ir))
 . quit:ir=""
 . set cnt=cnt+1
 . set SAMIRTN(cnt)="<th>"_$get(RPT(ir,"header"))_"</th>"
 . quit
 ;
 set cnt=cnt+1 set SAMIRTN(cnt)="</tr></thead>"
 ;
 set cnt=cnt+1 set SAMIRTN(cnt)="<tbody>"
 ;
 if type'="worklist" do  ;
 . do NUHREF(.SAMIPATS) ; create the nuhref link for all patients
 . quit
 ;
 new SRT set SRT=""
 if $get(filter("sort"))="" d  ; what kind of sort
 . set filter("sort")="name"
 . i type="missingct" s filter("sort")="cdate" ;sort by latest contact
 do SORT(.SRT,.SAMIPATS,.filter)
 ; zwrite SRT
 ;
 ; set ij=0
 ; for  do  quit:'ij  ;
 ; . set ij=$order(SAMIPATS(ij))
 ; . quit:'ij  
 ; . new ij2 set ij2=0
 ; . for  do  quit:'ij2  ;
 ; . . set ij2=$order(SAMIPATS(ij,ij2))
 ; . . quit:'ij2  
 ; . . new dfn set dfn=ij2
 ; . . quit
 ; . quit
 ;
 new iz,ij,ij2,dfn,rows
 set rows=0
 set (iz,ij,ij2,dfn)=""
 for  do  quit:iz=""  ;
 . set iz=$order(SRT(iz))
 . quit:iz=""
 . set ij=$order(SRT(iz,""))
 . set dfn=$order(SRT(iz,ij,""))
 . do  ;
 . . set cnt=cnt+1 set SAMIRTN(cnt)="<tr>"
 . . set ir=""
 . . for  do  quit:ir=""  ;
 . . . set ir=$order(RPT(ir))
 . . . quit:ir=""
 . . . set cnt=cnt+1
 . . . new XR,XRV
 . . . ; set XR=$get(RPT(ir,"routine"))_"("_ij_",.SAMIPATS)"
 . . . set XR="set XRV="_$get(RPT(ir,"routine"))_"("_ij_","_dfn_",.SAMIPATS)"
 . . . ; set XRV=@XR
 . . . xecute XR ; call report-field handlers in ^SAMIUR2
 . . . set SAMIRTN(cnt)="<td>"_$get(XRV)_"</td>"
 . . . quit
 . . ;
 . . set cnt=cnt+1
 . . set SAMIRTN(cnt)="</tr>"_$CHAR(10,13)
 . . set rows=rows+1
 . . quit
 . quit
 ;
 set cnt=cnt+1
 set SAMIRTN(cnt)="<tr><td>Total: "_rows_"</td></tr>"
 set SAMIRTN(totcnt)="<td>Total: "_rows_"</td></tr><tr>"
 ;
 set cnt=cnt+1 set SAMIRTN(cnt)="</tbody>"
 for  do  quit:temp(ii)["</tbody>"  ;
 . set ii=$order(temp(ii))
 . quit:temp(ii)["</tbody>"
 . ; skip past template headers & blank body
 . quit
 ;
 for  do  quit:'ii  ;
 . set ii=$order(temp(ii))
 . quit:'ii
 . set cnt=cnt+1
 . set ln=$get(temp(ii))
 . new samikey,si
 . set (samikey,si)=""
 . do LOAD^SAMIFORM(.ln,samikey,si,.filter)
 . set SAMIRTN(cnt)=ln
 . quit
 ;
 quit  ; end of WSREPORT
 ;
 ;
SORT(SRTN,SAMIPATS,FILTER) ; sort patients by name
 ;
 ;@called-by
 ; WSREPORT
 ;@calls
 ; $$UPCASE^XLFMSMT
 ;
 new typ set typ=$get(FILTER("sort"))
 ;
 if typ="" set typ="name"
 new iz,dt,dfn,nm,cdate
 set (dt,dfn,nm)="" ; note: should dfn be initialized inside loop?
 set iz=0
 ;
 new indx
 for  do  quit:'dt  ;
 . set dt=$order(SAMIPATS(dt))
 . quit:'dt
 . ; note: dfn not re-initialized to "" here; should it be?
 . for  do  quit:'dfn  ;
 . . set dfn=$order(SAMIPATS(dt,dfn))
 . . quit:'dfn
 . . if typ="name" do  ;
 . . . set nm=$get(SAMIPATS(dt,dfn,"name"))
 . . . set nm=$$UPCASE^XLFMSMT(nm)
 . . . if nm="" set nm=" "
 . . . set indx(nm,dt,dfn)=""
 . . . quit
 . . if typ="cdate" do  ;
 . . . set cdate=$$LDOC^SAMIUR2(dt,dfn,.SAMIPATS)
 . . . set cdate=$$FMDT^SAMIUR2(cdate)
 . . . set indx(cdate,dt,dfn)=""
 . . quit
 . quit
 ;
 new iiz set iiz=""
 set (dt,dfn)="" ; note: here, too, should inits be inside loops?
 for  do  quit:iiz=""  ;
 . set iiz=$order(indx(iiz))
 . quit:iiz=""
 . for  do  quit:dt=""  ;
 . . set dt=$order(indx(iiz,dt))
 . . quit:dt=""
 . . for  do  quit:dfn=""  ;
 . . . set dfn=$order(indx(iiz,dt,dfn))
 . . . quit:dfn=""
 . . . set iz=iz+1
 . . . set SRTN(iz,dt,dfn)=iiz
 . . . quit
 . . quit
 . quit
 ;
 quit  ; end of SORT
 ;
 ;
 ;
NUHREF(SAMIPATS) ; create nuhref link to casereview for all patients
 ;
 ;@called-by
 ; WSREPORT
 ;@calls
 ; $$setroot^%wd
 ; $$GETSSN^SAMIFORM
 ;
 new ij
 new root set root=$$setroot^%wd("vapals-patients")
 set ij=0
 for  do  quit:'ij  ;
 . set ij=$order(SAMIPATS(ij))
 . quit:'ij
 . new ij2 set ij2=0
 . for  do  quit:'ij2  ;
 . . set ij2=$order(SAMIPATS(ij,ij2))
 . . quit:'ij2
 . . ;
 . . new dfn set dfn=ij2
 . . set SAMIPATS(ij,dfn,"sid")=$get(@root@(dfn,"samistudyid"))
 . . set SAMIPATS(ij,dfn,"name")=$get(@root@(dfn,"saminame"))
 . . ;
 . . new sid set sid=SAMIPATS(ij,dfn,"sid")
 . . set SAMIPATS(ij,dfn,"ssn")=$$GETSSN^SAMIFORM(sid)
 . . new name set name=SAMIPATS(ij,dfn,"name")
 . . ;
 . . new nuhref set nuhref="<form method=POST action=""/vapals"">"
 . . set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""casereview"">"
 . . set nuhref=nuhref_"<input type=hidden name=""studyid"" value="_sid_">"
 . . set nuhref=nuhref_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 . . set SAMIPATS(ij,dfn,"nuhref")=nuhref
 . . quit
 . quit
 ;
 quit  ; end of NUHREF
 ;
 ;
 ;
PNAME(type,phrase) ; page name for report
 ;
 ;@called-by
 ; WSREPORT
 ;@calls none
 ;
 ; extrinsic returns the PAGE NAME for the report
 ;
 ; if type="followup" quit "Followup next 30 days -"_$get(phrase)
 if type="followup" quit "Followup "_$get(phrase)
 ; if type="activity" quit "Activity last 30 days -"_$get(phrase)
 if type="activity" quit "Activity "_$get(phrase)
 if type="missingct" quit "Intake but no CT Evaluation"_$get(phrase)
 if type="incomplete" quit "Incomplete Forms"_$get(phrase)
 if type="outreach" quit "Outreach"_$get(phrase)
 if type="enrollment" quit "Enrollment"_$get(phrase)
 if type="inactive" quit "Inactive"_$get(phrase)
 ;
 quit "" ; end of $$PNAME
 ;
 ;
 ;
 ;@section 2 select subroutines
 ;
 ;
 ;
SELECT(SAMIPATS,ztype,datephrase,filter) ; select patients for report
 ;
 ;@called-by
 ; WSREPORT
 ;@calls
 ; UNMAT
 ; WKLIST
 ; $$KEY2FM^SAMICASE
 ; $$NOW^XLFDT
 ; $$FMADD^XLFDT
 ; $$VAPALSDT^SAMICASE
 ; $$setroot^%wd
 ; GETITEMS^SAMICASE
 ;
 ; merge ^gpl("select")=filter
 new type set type=ztype
 if type="unmatched" do  quit  ;
 . do UNMAT(.SAMIPATS,ztype,.datephrase,.filter)
 . quit
 if type="worklist" do  quit  ;
 . do WKLIST(.SAMIPATS,ztype,.datephrase,.filter)
 . quit
 if $get(type)="" set type="enrollment"
 if type="cumpy" set type="enrollment"
 new site set site=$get(filter("siteid"))
 ;
 new strdt,enddt,fmstrdt,fmenddt
 set strdt=$get(filter("start-date"))
 set fmstrdt=$$KEY2FM^SAMICASE(strdt)
 if fmstrdt=-1 do  ;
 . set fmstrdt=2000101
 . if type="followup" set fmstrdt=$$NOW^XLFDT
 . if type="activity" set fmstrdt=$$FMADD^XLFDT($$NOW^XLFDT,-31)
 . quit
 if strdt="" set filter("start-date")=$$VAPALSDT^SAMICASE(fmstrdt)
 ;
 set enddt=$get(filter("end-date"))
 set fmenddt=$$KEY2FM^SAMICASE(enddt)
 if fmenddt=-1 do  ;
 . set fmenddt=$$NOW^XLFDT
 . if type="followup" set fmenddt=$$FMADD^XLFDT($$NOW^XLFDT,31)
 . quit
 if enddt="" set filter("end-date")=$$VAPALSDT^SAMICASE(fmenddt)
 ;
 set datephrase=""
 new zi set zi=0
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 for  do  quit:'zi  ;
 . set zi=$order(@root@(zi))
 . quit:'zi
 . ;
 . new sid set sid=$get(@root@(zi,"samistudyid"))
 . quit:sid=""
 . quit:$extract(sid,1,3)'=site
 . ;
 . new items set items=""
 . do GETITEMS^SAMICASE("items",sid)
 . quit:'$data(items)
 . ;
 . new efmdate,edate,siform,ceform,cefud,fmcefud,cedos,fmcedos
 . set siform=$order(items("siform-"))
 . new status set status=$get(@root@("graph",sid,siform,"sistatus"))
 . if type="inactive",status="active" quit  ; for inactive report
 . if type'="inactive",status'="active" quit  ; for other reports
 . ;
 . set ceform=$order(items("ceform-a"),-1)
 . set (cefud,fmcefud,cedos,fmcedos)=""
 . if ceform'="" do  ;
 . . set cefud=$get(@root@("graph",sid,ceform,"cefud"))
 . . if cefud'="" set fmcefud=$$KEY2FM^SAMICASE(cefud)
 . . set cedos=$get(@root@("graph",sid,ceform,"cedos"))
 . . if cedos'="" set fmcedos=$$KEY2FM^SAMICASE(cedos)
 . . quit
 . ;
 . set edate=$get(@root@("graph",sid,siform,"sidc"))
 . if edate="" set edate=$get(@root@("graph",sid,siform,"samicreatedate"))
 . set efmdate=$$KEY2FM^SAMICASE(edate)
 . set edate=$$VAPALSDT^SAMICASE(efmdate)
 . ;
 . ;
 . if type="followup" do  ;
 . . ; new nplus30 set nplus30=$$FMADD^XLFDT($$NOW^XLFDT,31)
 . . if +fmcefud<fmstrdt quit  ; before start date
 . . if +fmcefud<(fmenddt+1) do  ; before end date
 . . . quit:ceform=""  ; no ct eval so no followup date
 . . . set SAMIPATS(fmcefud,zi,"edate")=edate
 . . . set SAMIPATS(fmcefud,zi)=""
 . . . if ceform="" set cefud="baseline"
 . . . set SAMIPATS(fmcefud,zi,"cefud")=cefud
 . . . set SAMIPATS(fmcefud,zi,"cedos")=cedos
 . . . set SAMIPATS(fmcefud,zi,"ceform")=ceform
 . . . set SAMIPATS(fmcefud,zi,"ceform-vals")=$name(@root@("graph",sid,ceform))
 . . . set SAMIPATS(fmcefud,zi,"siform")=siform
 . . . set SAMIPATS(fmcefud,zi,"siform-vals")=$name(@root@("graph",sid,siform))
 . . . merge SAMIPATS(fmcefud,zi,"items")=items
 . . . quit
 . . set datephrase=" before "_$$VAPALSDT^SAMICASE(fmenddt)
 . . quit
 . ;
 . if type="activity" do  ;
 . . ; new nminus30 set nminus30=$$FMADD^XLFDT($$NOW^XLFDT,-31)
 . . new anyform set anyform=$order(items("sort",""),-1)
 . . new fmanyform set fmanyform=$$KEY2FM^SAMICASE(anyform)
 . . if fmanyform<fmstrdt quit  ; before the start date
 . . ; if fmanyform<(fmenddt+1)!(efmdate>fmenddt) do  ; need any new form
 . . if fmanyform<(fmenddt+1)  do  ;
 . . . set SAMIPATS(efmdate,zi,"edate")=edate
 . . . set SAMIPATS(efmdate,zi)=""
 . . . if ceform="" set cefud="baseline"
 . . . set SAMIPATS(efmdate,zi,"cefud")=cefud
 . . . set SAMIPATS(efmdate,zi,"cedos")=cedos
 . . . set SAMIPATS(efmdate,zi,"ceform")=ceform
 . . . set SAMIPATS(efmdate,zi,"siform")=siform
 . . . merge SAMIPATS(efmdate,zi,"items")=items
 . . . quit
 . . set datephrase=" after "_$$VAPALSDT^SAMICASE(fmstrdt)
 . . quit
 . ;
 . ; date filter for all the rest of the reports
 . ;
 . quit:efmdate<fmstrdt  ; before the start date
 . quit:efmdate>(fmenddt+1)  ; after the end date
 . ;
 . if type="incomplete" do  ;
 . . new complete set complete=1
 . . new zj set zj=""
 . . new gr set gr=$name(@root@("graph",sid))
 . . for  do  quit:zj=""  ;
 . . . set zj=$order(@gr@(zj))
 . . . quit:zj=""
 . . . if $get(@gr@(zj,"samistatus"))="incomplete" do  ;
 . . . . set complete=0
 . . . . set SAMIPATS(efmdate,zi,"iform")=$get(SAMIPATS(efmdate,zi,"iform"))_" "_zj
 . . . . quit
 . . . quit
 . . ;
 . . if complete=0 do  ; has incomplete form(s) 
 . . . set SAMIPATS(efmdate,zi,"edate")=edate
 . . . set SAMIPATS(efmdate,zi)=""
 . . . if ceform="" set cefud="baseline"
 . . . set SAMIPATS(efmdate,zi,"cefud")=cefud
 . . . set SAMIPATS(efmdate,zi,"ceform")=ceform
 . . . set SAMIPATS(efmdate,zi,"siform")=siform
 . . . merge SAMIPATS(efmdate,zi,"items")=items
 . . . quit
 . . set datephrase=""
 . . quit
 . ;
 . if type="missingct" do  ;
 . . if ceform="" do  ; has incomplete form(s) 
 . . . set SAMIPATS(efmdate,zi,"edate")=edate
 . . . set SAMIPATS(efmdate,zi)=""
 . . . if ceform="" set cefud="baseline"
 . . . set SAMIPATS(efmdate,zi,"cefud")=cefud
 . . . set SAMIPATS(efmdate,zi,"ceform")=ceform
 . . . set SAMIPATS(efmdate,zi,"siform")=siform
 . . . merge SAMIPATS(efmdate,zi,"items")=items
 . . . quit
 . . set datephrase=""
 . . quit
 . ;
 . if type="outreach" do  ; no-op; hook for future development?
 . . quit
 . ;
 . if type="enrollment" do  ;
 . . set SAMIPATS(efmdate,zi,"edate")=edate
 . . set SAMIPATS(efmdate,zi)=""
 . . set SAMIPATS(efmdate,zi,"cefud")=cefud
 . . set SAMIPATS(efmdate,zi,"ceform")=ceform
 . . set SAMIPATS(efmdate,zi,"cedos")=cedos
 . . set SAMIPATS(efmdate,zi,"siform")=siform
 . . merge SAMIPATS(efmdate,zi,"items")=items
 . . quit
 . ;
 . if type="inactive" do  ;
 . . set SAMIPATS(efmdate,zi,"edate")=edate
 . . set SAMIPATS(efmdate,zi)=""
 . . set SAMIPATS(efmdate,zi,"cefud")=cefud
 . . set SAMIPATS(efmdate,zi,"ceform")=ceform
 . . set SAMIPATS(efmdate,zi,"cedos")=cedos
 . . set SAMIPATS(efmdate,zi,"siform")=siform
 . . merge SAMIPATS(efmdate,zi,"items")=items
 . . quit
 . ;
 . set datephrase=" as of "_$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 . quit
 ;
 quit  ; end of SELECT
 ;
 ;
 ;
UNMAT(SAMIPATS,ztype,datephrase,filter) ; build unmatched persons list
 ;
 ;@called-by
 ; SELECT
 ;@calls
 ; $$setroot^%wd
 ;
 set datephrase="Unmatched Persons"
 new lroot set lroot=$$setroot^%wd("patient-lookup")
 new dfn set dfn=9000000
 for  do  quit:'dfn  ;
 . set dfn=$order(@lroot@("dfn",dfn))
 . quit:'dfn
 . ;
 . new ien set ien=$order(@lroot@("dfn",dfn,""))
 . quit:ien=""
 . n ordern
 . s ordern=$g(@lroot@(ien,"ORMORCordernumber"))
 . i ordern="" s ordern=$g(@lroot@(ien,"ORM",1,"ordernumber"))
 . i ordern'="" q  ;
 . i $g(@lroot@(ien,"siteid"))'[site q  ;
 . ;quit:$get(@lroot@(ien,"remotedfn"))'=""  ;
 . ;
 . merge SAMIPATS(ien,dfn)=@lroot@(ien)
 . ;
 . new name set name=$get(SAMIPATS(ien,dfn,"saminame"))
 . ; new name set name=$get(SAMIPATS(ien,dfn,"sinamef"))
 . ; set name=name_","_SAMIPATS(ien,dfn,"sinamel")
 . new nuhref set nuhref="<form method=POST action=""/vapals"">"
 . set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""editperson"">"
 . set nuhref=nuhref_"<input type=hidden name=""dfn"" value="_dfn_">"
 . set nuhref=nuhref_"<input type=hidden name=""siteid"" value="_site_">"
 . set nuhref=nuhref_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 . set SAMIPATS(ien,dfn,"editref")=nuhref
 . quit
 ;
 quit  ; end of UNMAT
 ;
 ;
 ;
WKLIST(SAMIPATS,ztype,datephrase,filter) ; build work list
 ;
 ;@called-by
 ; SELECT
 ;@calls
 ; $$setroot^%wd
 ;
 ; add site
 ; add compare to vapals-patients
 ; add navigation to enrollment
 ;
 kill ^gpl("worklist")
 merge ^gpl("worklist")=filter
 new site
 set site=$get(filter("siteid"))
 quit:site=""
 set datephrase="Work List"
 new lroot set lroot=$$setroot^%wd("patient-lookup")
 new proot set proot=$$setroot^%wd("vapals-patients")
 ;
 new dfn set dfn=0
 for  set dfn=$order(@lroot@("dfn",dfn)) quit:+dfn=0  do  ;
 . quit:$order(@proot@("dfn",dfn,""))'=""
 . new ien set ien=$order(@lroot@("dfn",dfn,""))
 . quit:ien=""
 . ;
 . ; write !,"dfn= ",dfn
 . ; zwrite @lroot@(ien,*)
 . ;
 . quit:$get(@lroot@(ien,"siteid"))'=site
 . ;
 . merge ^gpl("worklist","lroot",ien)=@lroot@(ien)
 . merge SAMIPATS(ien,dfn)=@lroot@(ien)
 . new name set name=$get(SAMIPATS(ien,dfn,"saminame"))
 . ; new name set name=$get(SAMIPATS(ien,dfn,"sinamef"))
 . ; set name=name_","_SAMIPATS(ien,dfn,"sinamel")
 . new nuhref set nuhref="<form method=POST action=""/vapals"">"
 . set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""newcase"">"
 . set nuhref=nuhref_"<input type=hidden name=""dfn"" value="_dfn_">"
 . set nuhref=nuhref_"<input type=hidden name=""siteid"" value="_site_">"
 . set nuhref=nuhref_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 . set SAMIPATS(ien,dfn,"workref")=nuhref
 . quit
 ;
 merge ^gpl("worklist","pats")=SAMIPATS
 ;
 quit  ; end of WKLIST
 ;
 ;
 ;
EOR ; end of SAMIUR
