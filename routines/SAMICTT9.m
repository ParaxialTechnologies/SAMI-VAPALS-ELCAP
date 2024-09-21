SAMICTT9 ;ven/gpl - ctreport text impressions ;2021-03-22T15:17Z
 ;;18.0;SAMI;**4,10**;2020-01;Build 2
 ;;1.18.0.10-i10
 ;
 ; SAMICTT9 creates the Impressions section of the ELCAP CT Report in
 ; text format.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@license see routine SAMIUL
 ;@documentation see SAMICTUL
 ;@contents
 ; IMPRSN: impressions section of ctreport text format
 ; OUT: output a line of ct report
 ; OUTOLD: old version of out
 ; HOUT: output a ct report header line
 ; $$XVAL = patient value for var
 ; $$XSUB = dictionary value defined by var
 ;
 ;
 ;
 ;@section 1 IMPRSN & related subroutines
 ;
 ;
 ;
IMPRSN(rtn,vals,dict) ; impressions section of ctreport text format
 ;
 ; repgen13
 ;
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
 ;@output: create impressions section of ct report in text format
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
 . if vcac'="" d  ;
 . . s cacrec=""
 . . s cac="The Visual Coronary Artery Calcium (CAC) Score is "_vcac_". "
 . . s cacval=vcac
 . . i cacval>3 s cacrec=$g(@dict@("CAC_recommendation"))_para
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
 . i cacval=0 d  ;
 . . d OUT("Coronary Artery Calcifications: None. The Visual Coronary Artery Calcium (CAC) score is 0") d OUT("")
 . e  d OUT(cac_" "_cacrec_" ") d OUT("")
 ;
 i $$XVAL("ceclini",vals)="y" d  ;
 . d OUT($$XVAL("ceclin",vals)_". ") d OUT("")
 ;
 i $$XVAL("ceoppai",vals)="y" d  ;
 . d OUT($$XVAL("ceoppa",vals)_". ") d OUT("")
 ;
 i $$XVAL("ceoppabi",vals)="y" d  ;
 . d OUT($$XVAL("ceoppab",vals)_". ") d OUT("")
 ;
 i $$XVAL("cecommcai",vals)="y" d  ;
 . d OUT($$XVAL("cecommca",vals)_". ") d OUT("")
 ;
 i $$XVAL("ceotabnmi",vals)="y" d  ;
 . d OUT($$XVAL("ceotabnm",vals)_". ") d OUT("")
 ;
 i $$XVAL("ceobrci",vals)="y" d  ;
 . d OUT($$XVAL("ceobrc",vals)_". ") d OUT("")
 ;
 i $$XVAL("ceaoabbi",vals)="y" d  ;
 . d OUT($$XVAL("ceaoabb",vals)_". ") d OUT("")
 ;
 i $$XVAL("ceaoabi",vals)="y" d  ;
 . d OUT($$XVAL("ceaoab",vals)_". ") d OUT("")
 ;
 ;# Impression Remarks
 i $$XVAL("ceimre",vals)'="" d  ;
 . d OUT($$XVAL("ceimre",vals)_". ") d OUT("")
 ;
 n special,insuff
 s special=$S($$XVAL("ceimspr",vals)="y":1,1:0)
 s insuff=$S($$XVAL("ceimsii",vals)="y":1,1:0)
 i (special)!(insuff) d  ;
 . d OUT("")
 . d OUT("SPECIAL HANDLING:")
 . d OUT("")
 . i special d  ;
 . . d OUT("Read requires special attention by attending radiologist") 
 . . d OUT("")
 . i insuff d  ;
 . . d OUT("Insufficient information for sign off")
 . . d OUT("")
 ;
 quit  ; end of IMPRSN
 ;
 ;
 ;
OUT(ln) ; output a line of ct report
 ;
 ;@called-by
 ; IMPRSN
 ;@calls none
 ;@input
 ; ln = output to add
 ;@output: line added to ct report
 ;
 ;i $e(ln,$l(ln)-2,$l(ln))=".." s ln=$e(ln,1,$l(ln)-1) ; remove double dots
 i ln[".." s ln=$p(ln,"..")_"."
 s cnt=cnt+1
 n lnn
 ;s debug=1
 s lnn=$o(@rtn@(" "),-1)+1
 s @rtn@(lnn)=ln
 ;
 i $g(debug)=1 d  ;
 . i ln["<" q  ; no markup
 . n zs s zs=$STACK
 . n zp s zp=$STACK(zs-2,"PLACE")
 . s @rtn@(lnn)=zp_":"_ln
 ;
 quit  ; end of OUT
 ;
 ;
 ;
HOUT(ln) ; output a ct report header line
 ;
 ;@called-by none
 ;@calls
 ; OUT
 ;@input
 ; ln = output to add
 ;@output: header line added to ct report
 ;
 d OUT("<p><span class='sectionhead'>"_ln_"</span>")
 ;
 quit  ; end of HOUT
 ;
 ;
 ;
XVAL(var,vals) ; extrinsic returns the patient value for var
 ;
 ;@called-by
 ; IMPRSN
 ;@calls none
 ;@input
 ; var
 ; vals is passed by name
 ;@output = patient value for var
 ;
 n zr
 s zr=$g(@vals@(var))
 ;i zr="" s zr="["_var_"]"
 ;
 quit zr ; end of $$XVAL
 ;
 ;
 ;
XSUB(var,vals,dict,valdx) ; extrinsic which returns the dictionary value defined by var
 ;
 ;@called-by
 ; IMPRSN
 ;@calls none
 ;@input
 ; var
 ; vals & dict are passed by name
 ; valdx is used for nodules ala cect2co with nodule # included
 ;@output = dictionary value for var
 ;
 ;n dict s dict=$$setroot^%wd("cteval-dict")
 n zr,zv,zdx
 s zdx=$g(valdx)
 i zdx="" s zdx=var
 s zv=$g(@vals@(zdx))
 ;i zv="" s zr="["_var_"]" q zr
 i zv="" s zr="" q zr
 s zr=$g(@dict@(var,zv))
 ;i zr="" s zr="["_var_","_zv_"]"
 ;
 quit zr ; end of $$XSUB
 ;
 ;
 ;
EOR ; end of routine SAMICTT9
