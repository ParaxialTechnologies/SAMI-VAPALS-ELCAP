SAMICTT9 ;ven/gpl - ctreport text impressions; 2024-09-24t15:05z
 ;;18.0;SAMI;**4,10,19**;2020-01-17;Build 1
 ;mdc-e1;SAMICTT9-20240924-E1zMgz6;SAMI-18-19-b1
 ;mdc-v7;B30422718;SAMI*18.0*19 SEQ #19
 ;
 ; SAMICTT9 creates the Impressions section of the ELCAP CT Report in
 ; text format.
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
 ; IMPRSN impressions section of ctreport text format
 ; OUT output ct report line
 ; HOUT output ct report header line
 ; $$XVAL patient value for var
 ; $$XSUB dictionary value defined by var
 ;
 ;
 ;
 ;
 ;@section 1 IMPRSN & related subroutines
 ;
 ;
 ;
 ;
 ;@proc IMPRSN
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean;sac?;tests?;port
 ;@called-by
 ; WSREPORT^SAMICTT0
 ;@calls
 ; OUT
 ; $$XSUB
 ; $$XVAL
 ;@input
 ; rtn
 ; vals
 ; dict
 ;@output
 ; create impressions section of ct report in text format
 ;
 ;
IMPRSN(rtn,vals,dict) ; impressions section of ctreport text format
 ;
 ; repgen13
 ;
 ; # Impression
 ;d OUT("</TD></TR></TABLE><TR><TD>")
 ;d OUT("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 ;d OUT("</TD></TR>")
 ;d OUT("<!-- impression -->")
 ;d OUT("<TR><TD>")
 ;d OUT("<FONT SIZE=""+2"">")
 ;d OUT("<B>IMPRESSION:</B>")
 ;d OUT("</FONT>")
 ;d OUT("</TD></TR><TR><TD><TABLE>")
 ;d OUT("<TR><TD WIDTH=20></TD><TD>")
 d OUT("")
 d OUT("IMPRESSION:")
 d OUT("")
 ;
 d OUT($$XSUB("ceimn",vals,dict)_para)
 ;
 ;# Report CAC Score and Extent of Emphysema
 s cacval=0
 d  ;if $$XVAL("ceccv",vals)'="e" d  ;
 . set vcac=$$XVAL("cecccac",vals)
 . if vcac]"" d  ;
 . . s cacrec=""
 . . s cac="The Visual Coronary Artery Calcium (CAC) Score is "_vcac_". "
 . . s cacval=vcac
 . . i cacval>3 s cacrec=$g(@dict@("CAC_recommendation"))_para
 . . q
 . q
 ;
 ;i cacval>0 d  ;
 d  ;
 . d OUT("")
 . ;d OUT(cac_" "_cacrec_" ") d OUT("")
 . d  ;if $$XVAL("ceemv",vals)="e" d  ;
 . . if $$XVAL("ceem",vals)'="no" d  ;
 . . . if $$XVAL("ceem",vals)="nv" q  ;
 . . . d OUT("Emphysema: "_$$XSUB("ceem",vals,dict)) d OUT("")
 . . . ;d OUT($$XSUB("ceem",vals,dict)_". ") d OUT("")
 . . . q
 . . q
 . i cacval=0 d  ;
 . . d OUT("Coronary Artery Calcifications: None. The Visual Coronary Artery Calcium (CAC) score is 0") d OUT("")
 . . q
 . e  d OUT(cac_" "_cacrec_" ") d OUT("")
 . q
 ;
 i $$XVAL("ceclini",vals)="y" d  ;
 . d OUT($$XVAL("ceclin",vals)_". ") d OUT("")
 . q
 ;
 i $$XVAL("ceoppai",vals)="y" d  ;
 . d OUT($$XVAL("ceoppa",vals)_". ") d OUT("")
 . q
 ;
 i $$XVAL("ceoppabi",vals)="y" d  ;
 . d OUT($$XVAL("ceoppab",vals)_". ") d OUT("")
 . q
 ;
 i $$XVAL("cecommcai",vals)="y" d  ;
 . d OUT($$XVAL("cecommca",vals)_". ") d OUT("")
 . q
 ;
 i $$XVAL("ceotabnmi",vals)="y" d  ;
 . d OUT($$XVAL("ceotabnm",vals)_". ") d OUT("")
 . q
 ;
 i $$XVAL("ceobrci",vals)="y" d  ;
 . d OUT($$XVAL("ceobrc",vals)_". ") d OUT("")
 . q
 ;
 i $$XVAL("ceaoabbi",vals)="y" d  ;
 . d OUT($$XVAL("ceaoabb",vals)_". ") d OUT("")
 . q
 ;
 i $$XVAL("ceaoabi",vals)="y" d  ;
 . d OUT($$XVAL("ceaoab",vals)_". ") d OUT("")
 . q
 ;
 ;# Impression Remarks
 i $$XVAL("ceimre",vals)'="" d  ;
 . d OUT($$XVAL("ceimre",vals)_". ") d OUT("")
 . q
 ;
 n special s special=$S($$XVAL("ceimspr",vals)="y":1,1:0)
 n insuff s insuff=$S($$XVAL("ceimsii",vals)="y":1,1:0)
 i special!insuff d  ;
 . d OUT("")
 . d OUT("SPECIAL HANDLING:")
 . d OUT("")
 . i special d  ;
 . . d OUT("Read requires special attention by attending radiologist")
 . . d OUT("")
 . . q
 . i insuff d  ;
 . . d OUT("Insufficient information for sign off")
 . . d OUT("")
 . . q
 . q
 ;
 quit  ; end of IMPRSN
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
 ; IMPRSN
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
 ;i $e(ln,$l(ln)-2,$l(ln))=".." s ln=$e(ln,1,$l(ln)-1) ; remove double dots
 i ln[".." s ln=$p(ln,"..")_"."
 s cnt=cnt+1
 ;s debug=1
 n lnn s lnn=$o(@rtn@(" "),-1)+1
 s @rtn@(lnn)=ln
 ;
 i $g(debug)=1 d  ;
 . i ln["<" q  ; no markup
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
 ; IMPRSN
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
 ; IMPRSN
 ;@calls none
 ;@input
 ; var
 ; vals & dict are passed by name
 ; valdx is used for nodules ala cect2co with nodule # included
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
EOR ; end of routine SAMICTT9
