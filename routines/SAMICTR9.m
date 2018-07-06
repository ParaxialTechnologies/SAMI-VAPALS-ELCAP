SAMICTR9 ;ven/gpl - ielcap: forms ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
lungrads(rtn,vals,dict)
 ; repgen13
 ;
 ; # LungRADS
 ;
 n lrstyle
 i $$xval("celrc",vals)'="" s lrstyle=1 ; dom's style
 e  s lrstyle=0 ; artit's style
 ;
 i lrstyle=0 d  ; Artit's style
 . s lradModifiers=$$xval("celradc",vals)_$$xval("celrads",vals)
 . ;
 . i ($$xval("celrad",vals)'="-")&($$xval("celrad",vals)'="") d  ;
 . . d out("The LungRADS category for this scan is: "_$$xval("celrad",vals)_lradModifiers)
 . . d out(para)
 ;
 i lrstyle=1 d  ; Dom's style
 . s X=$$xval("celrmc",vals)_$$xval("celrms",vals)
 . s Y=""
 . X ^%ZOSF("UPPERCASE")
 . s lradModifiers=Y
 . ;
 . i ($$xval("celrc",vals)'="-")&($$xval("celrc",vals)'="") d  ;
 . . d out("The LungRADS category for this scan is: "_$$xval("celrc",vals)_lradModifiers)
 . . d out(para)
 ;
 ; # Impression
 d out("</TD></TR></TABLE><TR><TD>")
 d out("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 d out("</TD></TR>")
 d out("<!-- impression -->")
 d out("<TR><TD>")
 d out("<FONT SIZE=""+2"">")
 d out("<B>IMPRESSION:</B>")
 d out("</FONT>")
 d out("</TD></TR><TR><TD><TABLE>")
 d out("<TR><TD WIDTH=20></TD><TD>")
 ;
 d out($$xsub("ceimn",vals,dict)_para)
 ;
 q
 ;
 ;
out(ln)
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
hout(ln)
 d out("<p><span class='sectionhead'>"_ln_"</span>")
 q
 ;
xval(var,vals) ; extrinsic returns the patient value for var
 ; vals is passed by name
 n zr
 s zr=$g(@vals@(var))
 ;i zr="" s zr="["_var_"]"
 q zr
 ;
xsub(var,vals,dict,valdx) ; extrinsic which returns the dictionary value defined by var
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
 
