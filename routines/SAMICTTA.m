SAMICTTA ;ven/gpl - ctreport text recommendations; 2024-09-24t14:31z
 ;;18.0;SAMI;**4,10,11,19**;2020-01-17;Build 1
 ;mdc-e1;SAMICTTA-20240924-E1+hRO+;SAMI-18-19-b1
 ;mdc-v7;B49833239;SAMI*18.0*19 SEQ #19
 ;
 ; SAMICTTA creates the Recommendations section of the ELCAP CT Report
 ; in text format.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;
 ;@license see routine SAMIUL
 ;@documentation see SAMICTUL
 ;
 ;@contents
 ;
 ; RCMND recommendations section of ctreport in text format
 ; OUT output ct report line
 ; HOUT output ct report header line
 ; $$XVAL patient value for var
 ; $$XSUB dictionary value defined by var
 ;
 ;
 ;
 ;
 ;@section 1 RCMND & related subroutines
 ;
 ;
 ;
 ;
 ;@proc RCMND
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean;sac?;tests?;port
 ;@called-by
 ; WSREPORT^SAMICTT0
 ;@calls
 ; $$XVAL
 ; OUT
 ; $$XSUB
 ;@input
 ; rtn
 ; vals
 ; dict
 ;@output
 ; create impressions section of ct report in text format
 ;
 ;
RCMND(rtn,vals,dict) ; recommendations section of ctreport text format
 ;
 ; repgen14
 ;
 ;# Recommendation
 ;d OUT("</TD></TR>")
 ;d OUT("</TABLE>")
 ;d OUT("<TR><TD></TD></TR>")
 ;d OUT("<!-- Recommendation -->")
 ;
 i $$XVAL("cefu",vals)'="nf" d  ; 2445-2450 gpl1
 . ;d OUT("<TR><TD><FONT SIZE=""+2""><B>")
 . ;d OUT("<FONT SIZE=""+2""><B>")
 . d OUT("")
 . d OUT("Recommendations:")
 . d OUT("")
 . ;d OUT("</B></FONT>")
 . ;d OUT("</TD></TR><TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 . q
 ;
 n fuw s fuw=$$XSUB("cefuw",vals,dict)
 ;d OUT("fuw= "_fuw)
 ;d OUT("vals= "_vals)
 ;d OUT(" dict= "_dict)
 ;d OUT($o(@vals@("cefuw","")))
 ;zwr @vals@(*)
 ;zwr @dict@(*)
 ;i fuw="" d  ;
 ;. d OUT(para_"<B>"_$$XSUB("cefu",vals,dict)_" on "_$$XVAL("cefud",vals)_".</B>"_para)
 ;e  d  ;
 ;. d OUT(para_"<B>"_$$XSUB("cefu",vals,dict)_" "_fuw_" on "_$$XVAL("cefud",vals)_".</B>"_para)
 ;
 ; request 9/17/2024 to handle Annual followup differently from 
 ; other followup
 i $$XVAL("cefuw",vals)="1y" d  ; it is an annual followup
 . ;d OUT(para_"<B>A followup CT scan is recommended on "_$$XVAL("cefud",vals)_".</B>"_para)
 . i $$XVAL("cefud",vals)="" d  q  ; no date given
 . . d OUT("An annual CT scan is recommended. ") d OUT("")
 . . q
 . e  d OUT("An annual CT scan is recommended on "_$$XVAL("cefud",vals)_". ") d OUT("")
 . q
 ; 
 i $$XVAL("cefuw",vals)'="1y" d  ;
 . i fuw="" d  ;
 . . ;d OUT(para_"<B>A followup CT scan is recommended on "_$$XVAL("cefud",vals)_".</B>"_para)
 . . i $$XVAL("cefud",vals)="" q  ; no date given
 . . d OUT("A follow-up CT scan is recommended on "_$$XVAL("cefud",vals)_". ") d OUT("")
 . . q
 . e  d  ;
 . . ;d OUT(para_"<B>A followup CT scan is recommended "_fuw_" on "_$$XVAL("cefud",vals)_".</B>"_para)
 . . d OUT("A follow-up CT scan is recommended "_fuw_" on "_$$XVAL("cefud",vals)_". ") d OUT("")
 . . q
 . q
 ;
 ; #Other followup
 n comma s comma=0
 n tofu s tofu=""
 n ofu s ofu=""
 n zfu
 f zfu="cefuaf","cefucc","cefupe","cefufn","cefubr","cefupc","cefutb" d  ;
 . i $$XVAL(zfu,vals)="y" s ofu=ofu_zfu
 . q
 i $$XVAL("cefuo",vals)'="" s ofu=ofu_"cefuo"
 ;
 i ofu'="" d  ;
 . s tofu="Follow-up: "
 . i ofu["cefuaf" s tofu=tofu_"Antibiotics" s comma=1
 . i ofu["cefucc" s tofu=tofu_$s(comma:", ",1:"")_"Diagnostic CT" s comma=1
 . i ofu["cefupe" s tofu=tofu_$s(comma:", ",1:"")_"PET" s comma=1
 . i ofu["cefufn" s tofu=tofu_$s(comma:", ",1:"")_"Percutaneous biopsy" s comma=1
 . i ofu["cefubr" s tofu=tofu_$s(comma:", ",1:"")_"Bronchoscopy" s comma=1
 . i ofu["cefupc" s tofu=tofu_$s(comma:", ",1:"")_"Pulmonary consultation" s comma=1
 . i ofu["cefutb" s tofu=tofu_$s(comma:", ",1:"")_"Refer to tumor board" s comma=1
 . i ofu["cefuo" s tofu=tofu_$s(comma:", ",1:"")_$$XVAL("cefuoo",vals) s comma=1
 . q
 ;
 i ofu'="" d OUT(para_tofu_para) d OUT("")
 ;d OUT("<TR><TD></TD></TR>")
 ; # LungRADS
 ;
 ;d OUT("<TR><TD>")
 ;n lrstyle
 ;i $$XVAL("celrc",vals)'="" s lrstyle=1 ; dom's style
 ;e  s lrstyle=0 ; artit's style
 ;s lrstyle=0
 ;
 d  ;
 . q  ; LUNGRADS moved to SAMICTR4
 . n lradModifiers
 . s lradModifiers=$$XVAL("celradc",vals)_$$XVAL("celrads",vals)
 . ;
 . i $$XVAL("celrad",vals)'="-",$$XVAL("celrad",vals)'="" d  ;
 . . d OUT("The LungRADS category for this scan is: "_$$XVAL("celrad",vals)_" "_lradModifiers)
 . . d OUT(para)
 . . q
 . q
 ;
 ;d OUT("</TD></TR>")
 ;
 ;d OUT("<TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 ;
 ;# Check if Study is Completed
 ;# Find Current Study ID
 ;# locate most recent followup
 ;# get status (sies)
 ;# if sc=Study Complete and cefu=rs
 ;
 n patstatus s patstatus=$$XVAL("cedos",vals)
 ;i patstatus="sc" d OUT(para_$g(@dict@("study_complete")))
 i patstatus="sc" d OUT($g(@dict@("study_complete"))) d OUT("")
 ;
 ;# Radiologist
 i $$XVAL("cerad",vals)'="" d  ;
 . d OUT("Interpreted by: "_$$XVAL("cerad",vals)) d OUT("")
 . q
 ;
 ;d OUT("<TR><TD></TD></TR>")
 ; # LungRADS
 ;
 ;d OUT("<TR><TD>")
 n lrstyle
 i $$XVAL("celrc",vals)'="" s lrstyle=1 ; dom's style
 e  s lrstyle=0 ; artit's style
 s lrstyle=0
 ;
 d  ;
 . ;q  ; LUNGRADS moved to SAMICTR4
 . n lradModifiers
 . s lradModifiers=$$XVAL("celradc",vals)_$$XVAL("celrads",vals)
 . ;
 . i $$XVAL("celrad",vals)'="-",$$XVAL("celrad",vals)'="" d  ;
 . . d OUT("The LungRADS category for this scan is: "_$$XVAL("celrad",vals)_" "_lradModifiers)
 . . d OUT("")
 . . q
 . q
 ;
 ;d OUT("</TD></TR>")
 ;
 ;d OUT("<TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 ;
 quit  ; end of RCMND
 ;
 ;
 ;
 ;
 ;@proc OUT
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean;sac?;tests?;port
 ;@called-by
 ; RCMND
 ;@calls none
 ;@input
 ; ln = output to add
 ; ]rtn output array
 ; ]debug
 ;@thruput
 ; cnt
 ;@output
 ; line added to ct report
 ;
 ;
OUT(ln) ; output ct report line
 ;
 i ln[".." s ln=$p(ln,"..")_"." ; remove double periods at the end
 ;
 s cnt=cnt+1
 ;s debug=1
 n lnn s lnn=$o(@rtn@(" "),-1)+1
 s @rtn@(lnn)=ln
 ;
 i $g(debug)=1 d  ;
 . i ln["<T" q  ; no markup
 . i ln["</" q  ; no markup
 . n zs s zs=$STACK
 . n zp s zp=$STACK(zs-2,"PLACE")
 . s @rtn@(lnn)=zp_":"_ln
 . q
 ;
 quit  ; end of OUT
 ;
 ;
 ;
 ;
 ;@proc HOUT
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean;sac?;tests?;port
 ;@called-by none
 ;@calls
 ; OUT
 ;@input
 ; ln = header output to add
 ; ]rtn output array
 ;@output
 ; header line added to ct report
 ;
 ;
HOUT(ln) ; output ct report header line
 ;
 d OUT("<p><span class='sectionhead'>"_ln_"</span>")
 ;
 quit  ; end of HOUT
 ;
 ;
 ;
 ;
 ;@func $$XVAL
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;silent;clean;sac?;tests?;port
 ;@called-by
 ; RCMND
 ;@calls none
 ;@input
 ; var
 ; vals is passed by name
 ;@output = patient value for var
 ;
 ;
XVAL(var,vals) ; patient value for var
 ;
 n zr s zr=$g(@vals@(var))
 ;i zr="" s zr="["_var_"]"
 ;
 quit zr ; end of $$XVAL
 ;
 ;
 ;
 ;
 ;@func $$XSUB
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;silent;clean;sac?;tests?;port
 ;@called-by
 ; RCMND
 ;@calls none
 ;@input
 ; var
 ; vals and dict are passed by name
 ; valdx is used for nodules ala cect2co with the nodule number included
 ;@output = dictionary value for var
 ;
 ;
XSUB(var,vals,dict,valdx) ; dictionary value defined by var
 ;
 ;n dict s dict=$$setroot^%wd("cteval-dict")
 n zdx s zdx=$g(valdx)
 i zdx="" s zdx=var
 ;
 n zv s zv=$g(@vals@(zdx))
 ;i zv="" s zr="["_var_"]" q zr
 i zv="" s zr="" q zr
 ;
 n zr s zr=$g(@dict@(var,zv))
 ;i zr="" s zr="["_var_","_zv_"]"
 ;
 quit zr ; end of $$XSUB
 ;
 ;
 ;
EOR ; end of routine SAMICTTA
