SAMICTRA ;ven/gpl - ielcap: forms ; 1/22/19 1:26pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; no entry from top
 ;
RCMND(rtn,vals,dict) ;
 ; repgen14
 ;
 ;
 ;# Recommendation
 d OUT("</TD></TR>")
 d OUT("</TABLE>")
 d OUT("<TR><TD></TD></TR>")
 d OUT("<!-- Recommendation -->")
 ;
 i $$XVAL("cefu",vals)'="nf" d  ; 2445-2450 gpl1
 . ;d OUT("<TR><TD><FONT SIZE=""+2""><B>")
 . d OUT("<FONT SIZE=""+2""><B>")
 . d OUT("Recommendations:")
 . d OUT("</B></FONT>")
 . ;d OUT("</TD></TR><TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 ;
 n fuw
 s fuw=$$XSUB("cefuw",vals,dict)
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
 i fuw="" d  ;
 . d OUT(para_"<B>A followup CT scan is recommended on "_$$XVAL("cefud",vals)_".</B>"_para)
 e  d  ;
 . d OUT(para_"<B>A followup CT scan is recommended "_fuw_" on "_$$XVAL("cefud",vals)_".</B>"_para)
 ;
 ; #Other followup
 n zfu,ofu,tofu,comma
 s comma=0,tofu=""
 s ofu=""
 f zfu="cefuaf","cefucc","cefupe","cefufn","cefubr","cefupc","cefutb" d  ;
 . i $$XVAL(zfu,vals)="y" s ofu=ofu_zfu
 i $$XVAL("cefuo",vals)'="" s ofu=ofu_"cefuo"
 i ofu'="" d  ;
 . s tofu="Other followup: "
 . i ofu["cefuaf" s tofu=tofu_"Antibiotics" s comma=1
 . i ofu["cefucc" s tofu=tofu_$s(comma:", ",1:"")_"Diagnostic CT" s comma=1
 . i ofu["cefupe" s tofu=tofu_$s(comma:", ",1:"")_"PET" s comma=1
 . i ofu["cefufn" s tofu=tofu_$s(comma:", ",1:"")_"Percutaneous biopsy" s comma=1
 . i ofu["cefubr" s tofu=tofu_$s(comma:", ",1:"")_"Bronchoscpy" s comma=1
 . i ofu["cefupc" s tofu=tofu_$s(comma:", ",1:"")_"Pulmonary consultation" s comma=1
 . i ofu["cefutb" s tofu=tofu_$s(comma:", ",1:"")_"Refer to tumor board" s comma=1
 . i ofu["cefuo" s tofu=tofu_$s(comma:", ",1:"")_$$XVAL("cefuo",vals) s comma=1
 i ofu'="" d OUT(para_tofu_para)
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
 . n lradModifiers
 . s lradModifiers=$$XVAL("celradc",vals)_$$XVAL("celrads",vals)
 . ;
 . i ($$XVAL("celrad",vals)'="-")&($$XVAL("celrad",vals)'="") d  ;
 . . d OUT("The LungRADS category for this scan is: "_$$XVAL("celrad",vals)_" "_lradModifiers)
 . . d OUT(para)
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
 n patstatus
 s patstatus=$$XVAL("cedos",vals)
 i patstatus="sc" d OUT(para_$g(@dict@("study_complete")))
 ;
 ;# Radiologist
 i $$XVAL("cerad",vals)'="" d  ;
 . d OUT("Interpreted by: "_$$XVAL("cerad",vals)_para)
 ;
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
 . i ln["<T" q  ; no markup
 . i ln["</" q  ; no markup
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
