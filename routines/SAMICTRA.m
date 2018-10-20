SAMICTRA ;ven/gpl - ielcap: forms ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
recommend(rtn,vals,dict)
 ; repgen14
 ;
 ;
 ;# Recommendation
 d out("</TD></TR>")
 d out("</TABLE>")
 d out("<TR><TD></TD></TR>")
 d out("<!-- Recommendation -->")
 ;
 i $$xval("cefu",vals)'="nf" d  ; 2445-2450 gpl1
 . ;d out("<TR><TD><FONT SIZE=""+2""><B>")
 . d out("<FONT SIZE=""+2""><B>")
 . d out("Recommendations:")
 . d out("</B></FONT>")
 . ;d out("</TD></TR><TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 ;
 n fuw
 s fuw=$$xsub("cefuw",vals,dict)
 ;d out("fuw= "_fuw)
 ;d out("vals= "_vals)
 ;d out(" dict= "_dict)
 ;d out($o(@vals@("cefuw","")))
 ;zwr @vals@(*)
 ;zwr @dict@(*)
 i fuw="" d  ;
 . d out(para_"<B>"_$$xsub("cefu",vals,dict)_" on "_$$xval("cefud",vals)_".</B>"_para)
 e  d  ;
 . d out(para_"<B>"_$$xsub("cefu",vals,dict)_" "_fuw_" on "_$$xval("cefud",vals)_".</B>"_para)
 ;
 ;d out("<TR><TD></TD></TR>")
 ; # LungRADS
 ;
 ;d out("<TR><TD>")
 ;n lrstyle
 ;i $$xval("celrc",vals)'="" s lrstyle=1 ; dom's style
 ;e  s lrstyle=0 ; artit's style
 ;s lrstyle=0
 ;
 d  ;
 . s lradModifiers=$$xval("celradc",vals)_$$xval("celrads",vals)
 . ;
 . i ($$xval("celrad",vals)'="-")&($$xval("celrad",vals)'="") d  ;
 . . d out("The LungRADS category for this scan is: "_$$xval("celrad",vals)_" "_lradModifiers)
 . . d out(para)
 ;
 ;d out("</TD></TR>")
 ;
 ;d out("<TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 ;
 ;# Check if Study is Completed
 ;# Find Current Study ID
 ;# locate most recent followup
 ;# get status (sies)
 ;# if sc=Study Complete and cefu=rs
 ;
 n patstatus
 s patstatus=$$xval("cedos",vals)
 i patstatus="sc" d out(para_$g(@dict@("study_complete")))
 ;
 ;# Radiologist
 i $$xval("cerad",vals)'="" d  ;
 . d out("Interpreted by: "_$$xval("cerad",vals)_para)
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
 . i ln["<T" q  ; no markup
 . i ln["</" q  ; no markup
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
 
