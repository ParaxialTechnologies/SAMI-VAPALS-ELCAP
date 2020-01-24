SAMICTR4 ;ven/gpl - ielcap: forms ; 3/19/19 1:27pm
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
BREAST(rtn,vals,dict) ;
 ; repgen6
 n destr s destr="is seen"
 n sba set sba=0
 ;   # Breast Abnormalities
 n bd,brt,blt
 s (bd,brt,blt)=0
 if $$XVAL("ceobard",vals)'="-" s brt=$$XVAL("ceobard",vals)
 if $$XVAL("ceobald",vals)'="-" s brt=$$XVAL("ceobald",vals)
 if (blt'=0)!(brt'=0) d  ;
 . d OUT("Breast:")
 . s bd=1
 if $$XVAL("ceara",vals)="y" d  ; our substitute for ceoba, which is null
 . if bd=0 d OUT("Breast:")
 . if $$XVAL("ceara",vals)="y" d  ;
 . . set sba=1
 . . n br
 . . set br=$$CCMSTR^SAMICTR3("ceobarc^ceobary^ceobarm",vals)
 . . if br="" d OUT("Noted in right breast: ")
 . . if br'="" d OUT(br_" right breast.")
 . . d OUT($$XVAL("ceobaros",vals)_"<br>")
 if $$XVAL("ceafa",vals)="y" d  ; our substitute for ceoba, which is null
 . if bd=0 d OUT("Breast:")
 . if $$XVAL("ceafa",vals)="y" d  ;
 . . set sba=1
 . . n br
 . . set br=$$CCMSTR^SAMICTR3("ceobafc^ceobafy^ceobafm",vals)
 . . if br="" d OUT("Noted in left breast: ")
 . . if br'="" d OUT(br_" left breast.")
 . . d OUT($$XVAL("ceobafos",vals)_"<br>")
 if bd=1 d  ;
 . if blt=brt d OUT("Density: "_$$XSUB("ceobad",vals,dict,"ceobald"))
 . else  d OUT("Density: Left "_$$XSUB("ceobad",vals,dict,"ceobald")_", Right "_$$XSUB("ceobad",vals,dict,"ceobard")_".")
 if $$XVAL("ceobrc",vals)'="" d OUT($$XVAL("ceobrc",vals)_para)
 else  if sba=1 d OUT(para)
 ;
 ;
 d OUT("Abdomen: ")
 n yesaa s yesaa=0
 ;  # Special Handling for the gallbladder
 ;
 if $$XVAL("ceaga",vals)="y" d  ;
 . d OUT("Limited view of the upper abdomen reveals the following: <br>")
 . set yesaa=1
 . if $$XVAL("ceagh",vals)="h" d  ;
 . . d OUT("status post cholecystectomy. <br>")
 . if $$XVAL("ceags",vals)="s" d  ;
 . . d OUT("Gallstones are noted. <br>")
 . if $$XVAL("ceagl",vals)="l" d  ;
 . . d OUT("Sludge is seen in the gall bladder. <br>")
 . if $$XVAL("ceago",vals)="y" d  ;
 . . d OUT("An abnormality was noted in the gall bladder: <br>")
 if $$XVAL("ceagos",vals)'="" d  ;
 . d OUT($$XVAL("ceagos",vals)_"<br>")
 ;
 n aalist
 s aalist(1,"spleen",0)=$$XVAL("ceasa",vals)
 s aalist(1,"spleen",1)="ceasc^ceasy^ceasm"
 s aalist(1,"spleen",2)=$$XVAL("ceasos",vals)
 s aalist(2,"liver",0)=$$XVAL("ceala",vals)
 s aalist(2,"liver",1)="cealc^cealy^cealm"
 s aalist(2,"liver",2)=$$XVAL("cealos",vals)
 s aalist(3,"pancreas",0)=$$XVAL("ceapa",vals)
 s aalist(3,"pancreas",1)="ceapc^ceapy^ceapm"
 s aalist(3,"pancreas",2)=$$XVAL("ceapos",vals)
 s aalist(4,"adrenals",0)=$$XVAL("ceaaa",vals)
 s aalist(4,"adrenals",1)="ceaac^ceaay^ceaam"
 s aalist(4,"adrenals",2)=$$XVAL("ceaaos",vals)
 s aalist(5,"kidneys",0)=$$XVAL("ceaka",vals)
 s aalist(5,"kidneys",1)="ceakc^ceaky^ceakm"
 s aalist(5,"kidneys",2)=$$XVAL("ceakos",vals)
 ;
 n zan,zaa s zaa=""
 f zan=1:1:5  d  ;
 . s zaa=$o(aalist(zan,""))
 . if aalist(zan,zaa,0)="y" d  ;
 . . n zout
 . . s zout=$$CCMSTR^SAMICTR3(aalist(zan,zaa,1),vals)
 . . set yesaa=1
 . . if zout="" d  ;
 . . . ;d OUT(aalist(zan,zaa,2))
 . . . if aalist(zan,zaa,2)'="" d OUT(aalist(zan,zaa,2)_"<br>")
 . . if zout'="" d  ;
 . . . d OUT("A "_$$LOWC^SAMICTR3(zout)_" "_zaa_". "_aalist(zan,zaa,2)_"<br>")
 ;
 ;# Other Abdominal Abnormalities
 ;
 if $$XVAL("ceaoab",vals)'="" d  ;
 . d OUT($$XVAL("ceaoab",vals)_"."_para)
 if yesaa=0  d  ;
 . d OUT("Limited view of the upper abdomen reveals no abnormalities."_para)
 ;
 d OUT("</p>")
 ;
 ;# Other Chest Abnormalities
 ;
 if $$XVAL("ceotab",vals)'="" d
 . d OUT("Other chest abnormalities:")
 . d OUT($$XVAL("ceotab",vals)_"."_para)
 ;
 ;# Bone Abnormalities
 ;
 if $$XVAL("ceaoabb",vals)'="" d  ;
 . d OUT("Bone:")
 . d OUT($$XVAL("ceaoabb",vals)_para)
 d  ;
 . q  ; LungRADS moved to SAMICTRA
 . n lradModifiers
 . s lradModifiers=$$XVAL("celradc",vals)_$$XVAL("celrads",vals)
 . ;
 . i ($$XVAL("celrad",vals)'="-")&($$XVAL("celrad",vals)'="") d  ;
 . . d OUT("The LungRADS category for this scan is: "_$$XVAL("celrad",vals)_" "_lradModifiers)
 . . d OUT(para)
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
 ;
