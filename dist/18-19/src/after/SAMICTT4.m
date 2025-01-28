SAMICTT4 ;ven/gpl - ctreport text breast abnorm; 2024-09-24t15:33z
 ;;18.0;SAMI;**4,10,19**;2020-01-17;Build 1
 ;mdc-e1;SAMICTT4-20240924-E25ZW78;SAMI-18-19-b1
 ;mdc-v7;B62798123;SAMI*18.0*19 SEQ #19
 ;
 ; SAMICTT4 creates the Breast Abnormalities section of the ELCAP CT
 ; Report in text format.
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
 ; BREAST breast abnormalities section of ct report text
 ; OUT output ct report line
 ; HOUT output ct report header line
 ; $$XVAL patient value for var
 ; $$XSUB dictionary value defined by var
 ;
 ;
 ;
 ;
 ;@section 1 BREAST & related subroutines
 ;
 ;
 ;
 ;
 ;@proc BREAST
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean;sac?;tests?;port
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
 ;@output
 ; create breast abnormalities section of ct report text
 ;
 ;
BREAST(rtn,vals,dict) ; breast abnormalities section of ct report text
 ;
 ; repgen6
 ;
 n sp1 s sp1="  "
 n outmode s outmode="hold"
 n line s line=""
 n destr s destr="is seen"
 n sba s sba=0
 ;   # Breast Abnormalities
 n bd s bd=0
 n brt s brt=0
 n blt s blt=0
 if $$XVAL("ceobard",vals)'="-" s brt=$$XVAL("ceobard",vals)
 if $$XVAL("ceobald",vals)'="-" s brt=$$XVAL("ceobald",vals)
 if blt'=0!(brt'=0) d  ;
 . d OUT("Breast: ")
 . s bd=1
 . q
 s outmode="hold"
 ;
 if $$XVAL("ceara",vals)="y" d  ; our substitute for ceoba, which is null
 . if bd=0 d OUT("Breast:")
 . if $$XVAL("ceara",vals)="y" d  ;
 . . set sba=1
 . . n br set br=$$CCMSTR^SAMICTR3("ceobarc^ceobary^ceobarm",vals)
 . . if br="" d OUT("Noted in right breast: ")
 . . if br]"" d OUT(br_" right breast. ")
 . . d OUT($$XVAL("ceobaros",vals))
 . . q
 . q
 ;
 if $$XVAL("ceafa",vals)="y" d  ; our substitute for ceoba, which is null
 . if bd=0 d OUT("Breast:")
 . if $$XVAL("ceafa",vals)="y" d  ;
 . . set sba=1
 . . n br set br=$$CCMSTR^SAMICTR3("ceobafc^ceobafy^ceobafm",vals)
 . . if br="" d OUT("Noted in left breast: ")
 . . if br]"" d OUT(br_" left breast. ")
 . . d OUT($$XVAL("ceobafos",vals))
 . . q
 . q
 ;
 if bd=1 d  ;
 . if blt=brt d OUT("Density: "_$$XSUB("ceobad",vals,dict,"ceobald"))
 . else  d OUT("Density: Left "_$$XSUB("ceobad",vals,dict,"ceobald")_", Right "_$$XSUB("ceobad",vals,dict,"ceobard")_". ")
 . q
 ;
 if $$XVAL("ceobrc",vals)]"" d  ;
 . if sba=0,bd=0 d OUT("Breast: ")
 . d OUT($$XVAL("ceobrc",vals))
 . q
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
 . . q
 . if $$XVAL("ceags",vals)="s" d  ;
 . . d OUT(sp1_"Gallstones are noted. ")
 . . q
 . if $$XVAL("ceagl",vals)="l" d  ;
 . . d OUT(sp1_"Sludge is seen in the gall bladder. ")
 . . q
 . if $$XVAL("ceago",vals)="y" d  ;
 . . d OUT(sp1_"An abnormality was noted in the gall bladder: ")
 . . q
 . q
 ;
 if $$XVAL("ceagos",vals)]"" d  ;
 . d OUT($$XVAL("ceagos",vals))
 . q
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
 n zaa s zaa=""
 n zan
 f zan=1:1:5  d  ;
 . s zaa=$o(aalist(zan,""))
 . if aalist(zan,zaa,0)="y" d  ;
 . . n zout s zout=$$CCMSTR^SAMICTR3(aalist(zan,zaa,1),vals)
 . . set yesaa=1
 . . if zout="" d  ;
 . . . ;d OUT(aalist(zan,zaa,2))
 . . . if aalist(zan,zaa,2)'="" d OUT(aalist(zan,zaa,2))
 . . . q
 . . if zout]"" d  ;
 . . . d OUT(sp1_"A "_$$LOWC^SAMICTR3(zout)_" "_zaa_". "_aalist(zan,zaa,2))
 . . . q
 . . q
 . q
 ;
 ;# Other Abdominal Abnormalities
 ;
 if $$XVAL("ceaoab",vals)]"" d  ;
 . d OUT($$XVAL("ceaoab",vals)_". ")
 . q
 if yesaa=0  d  ;
 . ;d OUT(sp1_"Limited view of the upper abdomen reveals no abnormalities. ")
 . d OUT(sp1_"Limited view of the upper abdomen reveals nothing remarkable. ")
 . q
 ;
 ;
 ;# Other Chest Abnormalities
 ;
 if $$XVAL("ceotab",vals)]"" d
 . d OUT("Other chest abnormalities:")
 . d OUT($$XVAL("ceotab",vals)_". ")
 . q
 ;
 s outmode="go"
 d OUT("")
 ;
 ;# Bone Abnormalities
 ;
 s outmode="hold"
 if $$XVAL("ceaoabb",vals)]"" d  ;
 . d OUT("Bone:")
 . d OUT($$XVAL("ceaoabb",vals)_para)
 . q
 ;
 d  ;
 . q  ; LungRADS moved to SAMICTRA
 . n lradModifiers
 . s lradModifiers=$$XVAL("celradc",vals)_$$XVAL("celrads",vals)
 . ;
 . i $$XVAL("celrad",vals)'="-",$$XVAL("celrad",vals)]"" d  ;
 . . d OUT("The LungRADS category for this scan is: "_$$XVAL("celrad",vals)_" "_lradModifiers)
 . . d OUT("")
 . . q
 . q
 s outmode="go"
 d OUT("")
 ;
 quit  ; end of BREAST
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
 ; BREAST
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
OUT(ln) ; output a line of ct report
 ;
 i outmode="hold" s line=line_ln q  ;
 s cnt=cnt+1
 i $g(debug)'=1 s debug=0
 n lnn s lnn=$o(@rtn@(" "),-1)+1
 i outmode="go" d  ;
 . s @rtn@(lnn)=line
 . s line=""
 . s lnn=$o(@rtn@(" "),-1)+1
 . q
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
 d OUT(ln)
 ;d OUT("<p><span class='sectionhead'>"_ln_"</span>")
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
 ; BREAST
 ;@calls none
 ;@input
 ; var
 ; vals is passed by name
 ;@output = patient value for var
 ;
 ;
XVAL(var,vals) ; extrinsic returns the patient value for var
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
 ; BREAST
 ;@calls none
 ;@input
 ; var
 ; vals & dict are passed by name
 ; valdx is used for nodules ala cect2co with nodule # included
 ;@output = dictionary value for var
 ;
 ;
XSUB(var,vals,dict,valdx) ; extrinsic which returns the dictionary value defined by var
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
EOR ; end of routine SAMICTT4
