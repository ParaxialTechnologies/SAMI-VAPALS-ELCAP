SAMICTT2 ;ven/gpl - ielcap: forms ; 4/22/19 9:04am
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
OTHRLUNG(rtn,vals,dict) ;
 ; repgen2,repgen3
 ;
 ; starts at "Other lung findings:"
 ;
 ;#hputs "Other lung findings:"
 ;
 n sp1 s sp1="  "
 n hfind,lfind,yespp,newct
 s (hfind,lfind,yespp)=0
 s newct=1
 ;
 ;# Add handling for new sections
 ;# ceopp is new, if it doensn't exist skip whole section
 ;# only then should old fields be included.
 ;
 i $g(newct)=1 d  ;
 . i "y"="y" d  ;
 . . s yespp=1
 . . i $$XVAL("cecbc",vals)="y" d  ;
 . . . d HLFIND ;
 . . . d OUT(sp1_"Cyst seen in the "_$$LOBESTR("cecbcl1^cecbcl2^cecbcl3^cecbcl4^cecbcl5",0)_".") d OUT("")
 . . . ;d OUT($$LOBESTR("cecbcl1^cecbcl2^cecbcl3^cecbcl4^cecbcl5",0)_".")
 . . . s yespp=1
 . . if $$XVAL("cecbb",vals)="y" d  ;
 . . . d HLFIND ; 
 . . . ;d OUT("<br>"_"Bleb or bullae seen in the ")
 . . . d OUT(sp1_"Bleb or bullae seen in the "_$$LOBESTR("cecbbl1^cecbbl2^cecbbl3^cecbbl4^cecbbl5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("cebrsb",vals)="y" d  ;
 . . . d HLFIND ; 
 . . . ;d OUT("<br>"_"Bronchiectasis in the ")
 . . . d OUT(sp1_"Bronchiectasis in the "_$$LOBESTR("cebrsbl1^cebrsbl2^cebrsbl3^cebrsbl4^cebrsbl5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("cebrs",vals)="y" d  ;
 . . . if $$XVAL("cebrsb",vals)'="y" d  ;
 . . . . if $$XVAL("cebrss",vals)'="y" d  ;
 . . . . . d HLFIND ;
 . . . . . ;d OUT("<br>"_"Small Airways Disease in the ")
 . . . . . d OUT(sp1_"Small Airways Disease in the "_$$LOBESTR("cebrsl1^cebrsl2^cebrsl3^cebrsl4^cebrsl5",0)_".") d OUT("")
 . . . . . set yespp=1
 . . if $$XVAL("cebrss",vals)="y" d  ;
 . . . d HLFIND ;
 . . . ;d OUT("<br>"_"Small Airways Disease/Bronchiolectasis in the ")
 . . . d OUT(sp1_"Small Airways Disease/Bronchiolectasis in the "_$$LOBESTR("cebrssl1^cebrssl2^cebrssl3^cebrssl4^cebrssl5",0)_".") d OUT("")
 . . . set yespp=1
 . . n numl,str
 . . s numl=0
 . . s str=""
 . . if $$XVAL("cebs",vals)="o" d  ;
 . . . set yespp=1
 . . . set numl=0
 . . . set str="Normal bronchial resection margin on"
 . . . if $$XVAL("cebsrt",vals)="r" d  ;
 . . . . s str=str_" right"
 . . . . s numl=numl+1
 . . . if $$XVAL("cebslt",vals)="l" d  ;
 . . . . if numl>0 d  ;
 . . . . . s str=str_" and"
 . . . . s str=str_" left"
 . . . . s numl=numl+1
 . . . s str=str_"."
 . . . if numl=0 d  ;
 . . . . set str="Normal bronchial resection margin noted."
 . . . d HLFIND ;
 . . . d OUT(sp1_str)
 . . . ;d OUT("<br>")
 . . ;if $$XVAL("cebrsb",vals)="y" d  ;
 . . ;. d HLFIND
 . . ;. d OUT("<br>"_"Bronchiectasis in the ")
 . . ;. d OUT($$LOBESTR("cebrsbl1^cebrsbl2^cebrsbl3^cebrsbl4^cebrsbl5",0)_".")
 . . ;. set yespp=1
 . . if $$XVAL("ceild",vals)="y" d  ;
 . . . d HLFIND
 . . . ;d OUT("<br>"_"Evidence of interstitial lung disease in the ")
 . . . d OUT(sp1_"Evidence of interstitial lung disease in the "_$$LOBESTR("ceildl1^ceildl2^ceildl3^ceildl4^ceildl5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("cerdc",vals)="y" d  ;
 . . . d HLFIND
 . . . ;d OUT("<br>"_"Regional or diffuse consolidation in the ")
 . . . d OUT(sp1_"Regional or diffuse consolidation in the "_$$LOBESTR("cerdcl1^cerdcl2^cerdcl3^cerdcl4^cerdcl5",0)_".") d OUT("")
 . . . set yespp=1
 . . ;# scarring may be more complicated (apical, and bilateral)
 . . if $$XVAL("cescr",vals)="y" d  ;
 . . . d HLFIND
 . . . ;# If apical use "unilateral apical scarring", if bilateral use "bilateral apical scarring"
 . . . ;# Otherwise use our previouse construct
 . . . n done s done=0 ; flag to use for other scarring 
 . . . if $$XVAL("cescrl6",vals)="au" d  ;
 . . . . d OUT(sp1_"Unilateral apical scarring.") d OUT("")
 . . . . s done=1
 . . . else  if $$XVAL("cescrl7",vals)="ab" d  ;
 . . . . d OUT(sp1_"Bilateral apical scarring.") d OUT("")
 . . . . s done=1
 . . . if done=0  d  ;
 . . . . ;d OUT("<br>"_"Scarring in the ")
 . . . . d OUT(sp1_"Scarring in the "_$$LOBESTR("cescrl1^cescrl2^cescrl3^cescrl4^cescrl5",1)_".") d OUT("")
 . . . . set yespp=1
 . . if $$XVAL("cebat",vals)="y" d  ;
 . . . d HLFIND
 . . . ;d OUT("<br>"_"Other atelectasis in the ")
 . . . d OUT(sp1_"Other atelectasis in the "_$$LOBESTR("cebatl1^cebatl2^cebatl3^cebatl4^cebatl5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("cerb",vals)="y" d  ;
 . . . d HLFIND
 . . . ;d OUT("<br>"_"Traction bronchiectasis in the ")
 . . . d OUT(sp1_"Traction bronchiectasis in the "_$$LOBESTR("cerbl1^cerbl2^cerbl3^cerbl4^cerbl5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("cepgo",vals)="y" d  ;
 . . . d HLFIND
 . . . ;d OUT("<br>"_"Peripheral Ground-glass Opacities in the ")
 . . . d OUT(sp1_"Peripheral Ground-glass Opacities in the "_$$LOBESTR("cepgol1^cepgol2^cepgol3^cepgol4^cepgol5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("ceret",vals)="y" d  ;
 . . . d HLFIND
 . . . ;d OUT("<br>"_"Reticulations in the ")
 . . . d OUT(sp1_"Reticulations in the "_$$LOBESTR("ceretl1^ceretl2^ceretl3^ceretl4^ceretl5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("cephc",vals)="y" d  ;
 . . . d HLFIND
 . . . ;d OUT("<br>"_"Honeycombing in the ")
 . . . d OUT(sp1_"Honeycombing in the "_$$LOBESTR("cephcl1^cephcl2^cephcl3^cephcl4^cephcl5",0)_".") d OUT("")
 . . . set yespp=1
 . . if $$XVAL("cepp",vals)="y" d  ;
 . . . set yespp=1
 . . . set numl=0
 . . . set str="Pleural or fissural plaques in the "
 . . . if $$XVAL("cepprt",vals)="r" d  ;
 . . . . s str=str_"right"
 . . . . s numl=numl+1
 . . . if $$XVAL("cepplt",vals)="l" d  ;
 . . . . if numl>0 d  ;
 . . . . . s str=str_" and"
 . . . . s str=str_" left"
 . . . . s numl=numl+1
 . . . . if numl>1 s str=str_" lobes"
 . . . . else  s str=str_" lobe"
 . . . . if $$XVAL("ceppca",vals)="c" s str=str_" with calcifications"
 . . . . s str=str_"."_para
 . . . if numl=0 set str="Pleural or fissural plaques are noted."
 . . . d HLFIND
 . . . d OUT(sp1_str)
 . . ;
 . . ;# Note: Not used for newer CT Evaluation Forms
 . . ;if { 0 == [ string compare y [xval cepc] ] } {
 . . ;  set yespp 1
 . . ;     hlfind
 . . ;     puts "[sidestr {Pleural calcifications} cepcrt cepclt]"
 . . ;
 . . if $$XVAL("cebs",vals)="y" d  ;
 . . . set yespp=1
 . . . set numl=0
 . . . set str="Abnormal bronchial resection margin on"
 . . . d  ;
 . . . . if $$XVAL("cebsrt",vals)="r" d  ;
 . . . . . s str=str_" right"
 . . . . . s numl=numl+1
 . . . . if $$XVAL("cebslt",vals)="l" d  ;
 . . . . . if numl>0 s str=str_" and"
 . . . . . s str=str_" left"
 . . . . . s numl=numl+1
 . . . . s str=str_"."
 . . . if numl=0 set str="<br>"_"Abnormal bronchial resection margin noted."
 . . . d HLFIND
 . . . d OUT(sp1_str)
 . . . ;d OUT(para)
 . . ;
 . . if $L($$XVAL("ceoppa",vals))'=0 d  ;
 . . . ;# puts "Additional Comments on Parenchymal or Pleural Abnormalities:"
 . . . d HLFIND
 . . . d OUT(sp1_$$XVAL("ceoppa",vals)_".") d OUT("")
 . . . ;d OUT(para)
 . . else  if yespp=1  ;d OUT(para)
 q
 ;
LOBESTR(lst,opt) ; extrinsic returns lobes
 ; lst is of the for a^b^c where a,b and c are variable names
 n rtstr,lln,tary
 s tary=""
 s rtstr=""
 s lln=$l(lst,"^")
 f lzi=1:1:lln d  ;
 . n tval
 . s tval=$$XVAL($p(lst,"^",lzi),vals)
 . n X,Y S X=tval X ^%ZOSF("UPPERCASE")
 . s tval=Y
 . i tval'="" s tary($o(tary(""),-1)+1)=tval
 n tcnt s tcnt=$o(tary(""),-1)
 q:tcnt=0
 i tcnt=1 q tary(1)
 i tcnt=2 q tary(1)_" and "_tary(2)
 f lzi=1:1:tcnt s rtstr=rtstr_tary(lzi)_$s(lzi<tcnt:", ",1:"")
 q rtstr
 ;
HLFIND() ; references and sets lfind in calling routine
 i $g(lfind)=0 d  ;
 . d HOUT("Other lung findings:")
 . d OUT("")
 . s lfind=1
 q
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
