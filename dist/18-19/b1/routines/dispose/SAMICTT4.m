SAMICTT4 ;ven/gpl - ctreport text breast abnorm ;2021-03-22T15:18Z
 ;;18.0;SAMI;**4,10**;2020-01;Build 2
 ;;1.18.0.10-i10
 ;
 ; SAMICTT4 creates the Breast Abnormalities section of the ELCAP CT
 ; Report in text format.
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
 ; BREAST: breast abnormalities section of ct report text
 ; OUT: output a line of ct report
 ; OUTOLD: old version of out
 ; HOUT: output a ct report header line
 ; $$XVAL = patient value for var
 ; $$XSUB = dictionary value defined by var
 ;
 ;
 ;
 ;@section 1 BREAST & related subroutines
 ;
 ;
 ;
BREAST(rtn,vals,dict) ; breast abnormalities section of ct report text
 ;
 ; repgen6
 ;
 ;@called-by
 ; WSREPORT^SAMICTT0
 ;@calls
 ; $$XVAL
 ; OUT
 ; $$CCMSTR^SAMICTR3
 ; $$XSUB
 ; $$LOWC^SAMICTR3
 ;@input
 ; rtn
 ; vals
 ; dict
 ;@output: create breast abnormalities section of ct report text
 ;
 n sp1 s sp1="  "
 n outmode s outmode="hold"
 n line s line=""
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
 s outmode="hold"
 if $$XVAL("ceara",vals)="y" d  ; our substitute for ceoba, which is null
 . if bd=0 d OUT("Breast:")
 . if $$XVAL("ceara",vals)="y" d  ;
 . . set sba=1
 . . n br
 . . set br=$$CCMSTR^SAMICTR3("ceobarc^ceobary^ceobarm",vals)
 . . if br="" d OUT("Noted in right breast: ")
 . . if br'="" d OUT(br_" right breast. ")
 . . d OUT($$XVAL("ceobaros",vals))
 if $$XVAL("ceafa",vals)="y" d  ; our substitute for ceoba, which is null
 . if bd=0 d OUT("Breast:")
 . if $$XVAL("ceafa",vals)="y" d  ;
 . . set sba=1
 . . n br
 . . set br=$$CCMSTR^SAMICTR3("ceobafc^ceobafy^ceobafm",vals)
 . . if br="" d OUT("Noted in left breast: ")
 . . if br'="" d OUT(br_" left breast. ")
 . . d OUT($$XVAL("ceobafos",vals))
 if bd=1 d  ;
 . if blt=brt d OUT("Density: "_$$XSUB("ceobad",vals,dict,"ceobald"))
 . else  d OUT("Density: Left "_$$XSUB("ceobad",vals,dict,"ceobald")_", Right "_$$XSUB("ceobad",vals,dict,"ceobard")_". ")
 if $$XVAL("ceobrc",vals)'="" d OUT($$XVAL("ceobrc",vals))
 else  if sba=1 d OUT("")
 s outmode="go"
 d OUT("")
 ;
 ;
 s outmode="hold"
 d OUT("Abdomen: ")
 n yesaa s yesaa=0
 ;  # Special Handling for the gallbladder
 ;
 if $$XVAL("ceaga",vals)="y" d  ;
 . d OUT(sp1_"Limited view of the upper abdomen reveals the following: ")
 . set yesaa=1
 . if $$XVAL("ceagh",vals)="h" d  ;
 . . d OUT(sp1_"status post cholecystectomy. ")
 . if $$XVAL("ceags",vals)="s" d  ;
 . . d OUT(sp1_"Gallstones are noted. ")
 . if $$XVAL("ceagl",vals)="l" d  ;
 . . d OUT(sp1_"Sludge is seen in the gall bladder. ")
 . if $$XVAL("ceago",vals)="y" d  ;
 . . d OUT(sp1_"An abnormality was noted in the gall bladder: ")
 if $$XVAL("ceagos",vals)'="" d  ;
 . d OUT($$XVAL("ceagos",vals))
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
 . . . if aalist(zan,zaa,2)'="" d OUT(aalist(zan,zaa,2))
 . . if zout'="" d  ;
 . . . d OUT(sp1_"A "_$$LOWC^SAMICTR3(zout)_" "_zaa_". "_aalist(zan,zaa,2))
 ;
 ;# Other Abdominal Abnormalities
 ;
 if $$XVAL("ceaoab",vals)'="" d  ;
 . d OUT($$XVAL("ceaoab",vals)_". ")
 if yesaa=0  d  ;
 . ;d OUT(sp1_"Limited view of the upper abdomen reveals no abnormalities. ")
 . d OUT(sp1_"Limited view of the upper abdomen reveals nothing remarkable. ")
 ;
 ;
 ;# Other Chest Abnormalities
 ;
 if $$XVAL("ceotab",vals)'="" d
 . d OUT("Other chest abnormalities:")
 . d OUT($$XVAL("ceotab",vals)_". ")
 ;
 s outmode="go"
 d OUT("")
 ;
 ;# Bone Abnormalities
 ;
 s outmode="hold"
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
 . . d OUT("")
 s outmode="go"
 d OUT("")
 ;
 quit  ; end of BREAST
 ;
 ;
 ;
OUT(ln) ; output a line of ct report
 ;
 ;@called-by
 ; BREAST
 ;@calls none
 ;@input
 ; ln = output to add
 ;@output: line added to report
 ;
 i outmode="hold" s line=line_ln q  ;
 s cnt=cnt+1
 n lnn
 i $g(debug)'=1 s debug=0
 s lnn=$o(@rtn@(" "),-1)+1
 i outmode="go" d  ;
 . s @rtn@(lnn)=line
 . s line=""
 . s lnn=$o(@rtn@(" "),-1)+1
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
OUTOLD(ln) ; old version of out
 ;
 ;@called-by none
 ;@calls none
 ;@input
 ; ln = output to add
 ;@output: line added to report
 ;
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
 quit  ; end of OUTOLD
 ;
 ;
 ;
HOUT(ln) ; output a ct report header line
 ;
 ;@called-by none
 ;@calls
 ; OUT
 ;@input
 ; ln = header output to add
 ;@output: header line added to report
 ;
 d OUT(ln)
 ;d OUT("<p><span class='sectionhead'>"_ln_"</span>")
 ;
 quit  ; end of HOUT
 ;
 ;
 ;
XVAL(var,vals) ; extrinsic returns the patient value for var
 ;
 ;@called-by
 ; BREAST
 ;@calls none
 ;@input
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
 ; BREAST
 ;@calls none
 ;@input
 ; vals and dict are passed by name
 ; valdx is used for nodules ala cect2co with the nodule number included
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
EOR ; end of routine SAMICTT4
