SAMIUR ;ven/gpl - sami user reports ; 4/23/19 10:43am
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMIUR contains the routines to generate user reports
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
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
 ; the report to generate is passed in parameter samireporttype
 ;
 n debug s debug=0
 i $g(filter("debug"))=1 s debug=1
 i $g(filter("debug"))=1 s debug=1
 k SAMIRTN
 s HTTPRSP("mime")="text/html"
 ;
 n type,temp
 s type=$g(filter("samireporttype"))
 i type="" d  q  ; report type missing
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
 d RPTTBL^SAMIUR2(.RPT,type) ; get the report specs
 i '$d(RPT) d  q  ; don't know about this report
 . d GETHOME^SAMIHOM3(.SAMIRTN,.filter) ; send them to home
 ;
 ; output the header
 ;
 s cnt=cnt+1 s SAMIRTN(cnt)="<thead><tr>"
 s ir=""
 f  s ir=$o(RPT(ir)) q:ir=""  d  ;
 . s cnt=cnt+1
 . s SAMIRTN(cnt)="<th>"_$g(RPT(ir,"header"))_"</th>"
 s cnt=cnt+1 s SAMIRTN(cnt)="</tr></thead>"
 ;
 n ij
 n root s root=$$setroot^%wd("vapals-patients")
 s cnt=cnt+1 s SAMIRTN(cnt)="<tbody>"
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
 . . ;
 . . ;k ^gpl("SAMIPATS")
 . . ;m ^gpl("SAMIPATS")=SAMIPATS
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
 . . s SAMIRTN(cnt)="</tr>"
 ;
 s cnt=cnt+1 s SAMIRTN(cnt)="</tbody>"
 f  s ii=$o(temp(ii)) q:temp(ii)["</tbody>"  d  ;
 . ; skip past template headers and blank body
 f  s ii=$o(temp(ii)) q:+ii=0  d  ;
 . s cnt=cnt+1
 . s ln=$g(temp(ii))
 . s SAMIRTN(cnt)=ln
 q
 ;
SELECT(SAMIPATS,type,datephrase,filter) ;selects patients for report
 ;m ^gpl("select")=filter
 i $g(type)="" s type="enrollment"
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
 . n items s items=""
 . d GETITEMS^SAMICASE("items",sid)
 . q:'$d(items)
 . n efmdate,edate,siform,ceform,cefud,fmcefud,cedos,fmcedos
 . s siform=$o(items("siform-"))
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
 . s datephrase=" as of "_$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 q
 ;
PNAME(type,phrase) ; extrinsic returns the PAGE NAME for the report
 ;i type="followup" q "Followup next 30 days -"_$g(phrase)
 i type="followup" q "Followup "_$g(phrase)
 ;i type="activity" q "Activity last 30 days -"_$g(phrase)
 i type="activity" q "Activity "_$g(phrase)
 i type="missingct" q "Intake but no CT Evaluation"_$g(phrase)
 i type="incomplete" q "Incomplete Forms"_$g(phrase)
 i type="outreach" q "Outreach"_$g(phrase)
 i type="enrollment" q "Enrollment"_$g(phrase)
 q ""
 ;
