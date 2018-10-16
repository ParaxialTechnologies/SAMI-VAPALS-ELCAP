SAMIUR ;ven/gpl - sami user reports ;2018-03-08T17:53Z
 ;;18.0;SAM;;
 ;
 ; SAMIUR contains the routines to generate user reports
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
wsReport(rtn,filter) ; generate a report based on parameters in the filter
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
 s debug=0
 i $g(filter("debug"))=1 s debug=1
 ;
 k return
 s HTTPRSP("mime")="text/html"
 ;
 n type,temp
 s type=$g(filter("samireporttype"))
 i type="" d  q  ; report type missing
 . d getHome^SAMIHOM3(.rtn,.filter) ; send them to home
 ;
 d getThis^%wd("temp","table.html") ; page template
 q:'$d(temp)
 ;
 n ln,cnt,ii
 s (ii,ln,cnt)=0
 f  s ii=$o(temp(ii)) q:+ii=0  q:$g(temp(ii))["<tbody"  d  ;
 . s cnt=cnt+1
 . s ln=$g(temp(ii))
 . n samikey,si
 . s (samikey,si)=""
 . D SAMISUB2^SAMIFRM2(.ln,samikey,si,.filter)
 . i ln["PAGE NAME" d findReplace^%ts(.ln,"PAGE NAME",$$PNAME(type))
 . s rtn(cnt)=ln
 . ;
 n pats,ij
 s pats=""
 d select(.pats,type) ; select patients for the report q:'$d(pats)
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 s cnt=cnt+1 s rtn(cnt)="<tbody>"
 s ij=0
 f  s ij=$o(pats(ij)) q:+ij=0  d  ;
 . n sid s sid=$g(@root@(ij,"samistudyid"))
 . n name s name=$g(@root@(ij,"saminame"))
 . new nuhref set nuhref="<form method=POST action=""/vapals"">"
 . set nuhref=nuhref_"<input type=hidden name=""samiroute"" value=""casereview"">"
 . set nuhref=nuhref_"<input type=hidden name=""studyid"" value="_sid_">"
 . set nuhref=nuhref_"<input value="""_name_""" class=""btn btn-link"" role=""link"" type=""submit""></form>"
 . s cnt=cnt+1
 . s rtn(cnt)="<tr><td>"_nuhref_"</td>"
 . n ssn s ssn=$$GETSSN^SAMIFRM2(sid)
 . i ssn="" d  ;
 . . n hdr
 . . s hdf=$$GETHDR^SAMIFRM2(sid)
 . . s ssn=$$GETSSN^SAMIFRM2(sid)
 . s cnt=cnt+1
 . s rtn(cnt)="<td>"_ssn_"</td></tr>"
 ;
 s cnt=cnt+1 s rtn(cnt)="</tbody>"
 ;s ii=ii-1
 f  s ii=$o(temp(ii)) q:+ii=0  d  ;
 . s cnt=cnt+1
 . s ln=$g(temp(ii))
 . s rtn(cnt)=ln
 q
 ;
select(pats,type) ; selects patient for the report
 i $g(type)="" s type="enrollment"
 n zi s zi=0
 n root s root=$$setroot^%wd("vapals-patients")
 ;
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . n sid s sid=$g(@root@(zi,"samistudyid"))
 . q:sid=""
 . n items s items=""
 . d getItems^SAMICAS2("items",sid)
 . q:'$d(items)
 . i type="followup" d  ;
 . . q
 . i type="activity" d  ;
 . . q
 . i type="missingct" d  ;
 . . q
 . i type="incomplete" d  ;
 . . q
 . i type="outreach" d  ;
 . . q
 . i type="enrollment" d  ;
 . . s pats(zi)=""
 q
 ;
PNAME(type) ; extrinsic returns the PAGE NAME for the report
 i type="followup" q "Followup"
 i type="activity" q "Activity"
 i type="missingct" q "Missing CT Evaluation"
 i type="incomplete" q "Incomplete Forms"
 i type="outreach" q "Outreach"
 i type="enrollment" q "Enrollment"
 q ""
 ;
