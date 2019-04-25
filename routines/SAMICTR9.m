SAMICTR9 ;ven/gpl - ielcap: forms ; 12/28/18 10:26am
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
IMPRSN(rtn,vals,dict) ;
 ; repgen13
 ;
 ;
 ; # Impression
 d OUT("</TD></TR></TABLE><TR><TD>")
 d OUT("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 d OUT("</TD></TR>")
 d OUT("<!-- impression -->")
 d OUT("<TR><TD>")
 d OUT("<FONT SIZE=""+2"">")
 d OUT("<B>IMPRESSION:</B>")
 d OUT("</FONT>")
 d OUT("</TD></TR><TR><TD><TABLE>")
 d OUT("<TR><TD WIDTH=20></TD><TD>")
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
 i cacval>0 d  ;
 . d OUT(cac_" "_cacrec_" "_para)
 . d  ;if $$XVAL("ceemv",vals)="e" d  ;
 . . if $$XVAL("ceem",vals)'="no" d  ;
 . . . if $$XVAL("ceem",vals)="nv" q  ;
 . . . d OUT("Emphysema:")
 . . . d OUT($$XSUB("ceem",vals,dict)_"."_para)
 ;
 i $$XVAL("ceclini",vals)="y" d  ;
 . d OUT($$XVAL("ceclin",vals)_"."_para)
 ;
 i $$XVAL("ceoppai",vals)="y" d  ;
 . d OUT($$XVAL("ceoppa",vals)_"."_para)
 ;
 i $$XVAL("ceoppabi",vals)="y" d  ;
 . d OUT($$XVAL("ceoppab",vals)_"."_para)
 ;
 i $$XVAL("cecommcai",vals)="y" d  ;
 . d OUT($$XVAL("cecommca",vals)_"."_para)
 ;
 i $$XVAL("ceotabnmi",vals)="y" d  ;
 . d OUT($$XVAL("ceotabnm",vals)_"."_para)
 ;
 i $$XVAL("ceobrci",vals)="y" d  ;
 . d OUT($$XVAL("ceobrc",vals)_"."_para)
 ;
 i $$XVAL("ceaoabbi",vals)="y" d  ;
 . d OUT($$XVAL("ceaoabb",vals)_"."_para)
 ;
 i $$XVAL("ceaoabi",vals)="y" d  ;
 . d OUT($$XVAL("ceaoab",vals)_"."_para)
 ;
 ;# Impression Remarks
 i $$XVAL("ceimre",vals)'="" d  ;
 . d OUT($$XVAL("ceimre",vals)_"."_para)
 q
 ;
 ;
OUT(ln) ;
 s cnt=cnt+1
 n lnn
 ;s debug=1
 s lnn=$o(@rtn@(" "),-1)+1
 s @rtn@(lnn)=ln
 i $g(debug)=1 d  ;
 . i ln["<" q  ; no markup
 . n zs s zs=$STACK
 . n zp s zp=$STACK(zs-2,"PLACE")
 . s @rtn@(lnn)=zp_":"_ln
 q
 ;
HOUT(ln) ;
 d OUT("<p><span class='sectionhead'>"_ln_"</span>")
 q
 ;
XVAL(var,vals) ; extrinsic returns the patient value for var
 ; vals is passed by name
 n zr
 s zr=$g(@vals@(var))
 ;i zr="" s zr="["_var_"]"
 q zr
 ;
XSUB(var,vals,dict,valdx) ; extrinsic which returns the dictionary value defined by var
 ; vals and dict are passed by name
 ; valdx is used for nodules ala cect2co with the nodule number included
 ;n dict s dict=$$setroot^%wd("cteval-dict")
 n zr,zv,zdx
 s zdx=$g(valdx)
 i zdx="" s zdx=var
 s zv=$g(@vals@(zdx))
 ;i zv="" s zr="["_var_"]" q zr
 i zv="" s zr="" q zr
 s zr=$g(@dict@(var,zv))
 ;i zr="" s zr="["_var_","_zv_"]"
 q zr
 ;
