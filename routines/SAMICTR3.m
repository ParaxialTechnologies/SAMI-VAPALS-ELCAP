SAMICTR3 ;ven/gpl - ielcap: forms ; 1/23/19 5:14pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; no entry from top
 ;
EMPHYS(rtn,vals,dict) ;
 ; repgen4,repgen5
 ;  
 ;# Emphysema
 ;
 ;if $$XVAL("ceemv",vals)'="e" d  ;
 if $$XVAL("ceem",vals)'="" d  ;
 . if $$XVAL("ceem",vals)="nv" q  ;
 . if $$XVAL("ceem",vals)="no" q  ;
 . D HOUT("Emphysema:")
 . D OUT($$XSUB("ceem",vals,dict)_para)
 ;
 D HOUT("Pleura:")
 ; hputs "Pleura:"
 N pe s pe=0
 ;
 ; # Pleural Effusion
 ; 
 i $$XVAL("cepev",vals)="y" d  ;
 . if $$XVAL("ceper",vals)="-" d  ;
 . . if $$XVAL("cepel",vals)="-" d  ;
 . . . s @vals@("cepev")="e"
 . ;
 . if $$XVAL("cepev",vals)'="e" d  ;
 . . if $$XVAL("ceper",vals)'="-" d  ;
 . . . if $$XVAL("cepel",vals)'="-" d  ;
 . . . . if $$XVAL("cepel",vals)=$$XVAL("ceper",vals) d  ;
 . . . . . d OUT("Bilateral "_$$XSUB("cepe",vals,dict,"cepel")_" pleural effusions."_para)
 . . . . else  d  ;
 . . . . . d OUT("Bilateral pleural effusions ; "_$$XSUB("cepe",vals,dict,"cepel")_" on left,")
 . . . . . d OUT(" and "_$$XSUB("cepe",vals,dict,"ceper")_" on right."_para)
 . . . . . s pe=1
 . . . else  d  ;
 . . . . d OUT("On right "_$$XSUB("cepe",vals,dict,"cepr")_" pleural effusion")
 . . . . d OUT(" and on left "_$$XSUB("cepe",vals,dict,"cepel")_" pleural effusion."_para)
 . . . . s pe=1
 . . else  d  ;
 . . . d OUT("On right "_$$XSUB("cepe",vals,dict,"cepr")_" pleural effusion")
 . . . d OUT(" and on left "_$$XSUB("cepe",vals,dict,"cepel")_" pleural effusion."_para)
 . . . s pe=1
 . ;
 i $$XVAL("cepev",vals)'="y" d  ; 
 . d OUT("No pleural effusions."_para)
 ;  if { $pe == 0 } {
 ;    puts "[tr "No pleural effusions"].${para}"
 ;  }
 ;  
 n yespp s yespp=0
 ;
 if $$XVAL("cebatr",vals)="y" d  ;
 . d OUT("Rounded atelectasis in the ")
 . d OUT($$LOBESTR^SAMICTR2("cebatrl1^cebatrl2^cebatrl3^cebatrl4^cebatrl5",0)_".<br>")
 . s yespp=1
 ;
 if $$XVAL("cept",vals)="y" d  ;
 . s yespp=1
 . s numl=0
 . set str="Pleural thickening/plaques in the "
 . if $$XVAL("ceptrt",vals)="r" d  ;
 . . s str=str_"right"
 . . s numl=numl+1
 . if $$XVAL("ceptlt",vals)="l" d  ;
 . . i numl>0 d  ;
 . . . s str=str_" and"
 . . s str=str_" left"
 . . s numl=numl+1
 . ;if numl>1 d  ;
 . ;. s str=str_" lungs."
 . ;else  d  ;
 . ;. s str=str_" lung."
 . s str=str_"."
 . if numl=0 set str="Pleural thickening/plaques."
 . d OUT(str_"<br>")
 ;
 if $$XVAL("cepu",vals)="y" d  ;
 . s yespp=1
 . if $l($$XVAL("cepus",vals))'=0 d  ;
 . . d OUT("Pleural rumor: "_$$XVAL("cepus",vals))
 . e  d OUT("Pleural tumor.")
 . d OUT("<br>")
 ;
 i yespp=0 d OUT(para)
 ;
 d  ;
 . if $$XVAL("ceoppab",vals)'="" d OUT($$XVAL("ceoppab",vals)_"."_para)
 . else  d
 . . if yespp=1 d OUT(para)
 ;
 ;
 d HOUT("Coronary Artery Calcifications:")
 ;# Coronary Calcification
 n vcac,cac,cacrec
 s (cac,cacrec)=""
 ;
 if $$XVAL("cecccac",vals)'="" d  ;
 . s @vals@("ceccv")="e"
 ;
 d  ;if $$XVAL("ceccv",vals)'="e" d  ;
 . set vcac=$$XVAL("cecccac",vals)
 . if vcac'="" d  ;
 . . s cacrec=""
 . . s cac="The Visual Coronary Artery Calcium (CAC) Score is "_vcac_". "
 . . s cacval=vcac
 . . i cacval>3 s cacrec=$g(@dict@("CAC_recommendation"))_para
 ;
 ;
 n samicac s samicac=0
 i $$XVAL("cecclm",vals)'="no" s samicac=1
 i $$XVAL("ceccld",vals)'="no" s samicac=1
 i $$XVAL("cecclf",vals)'="no" s samicac=1
 i $$XVAL("ceccrc",vals)'="no" s samicac=1
 ;
 i samicac=1 d  ;
 . d OUT($$XSUB("cecc",vals,dict,"cecclm")_" in left main,")
 . d OUT($$XSUB("cecc",vals,dict,"ceccld")_" in left anterior descending,")
 . d OUT($$XSUB("cecc",vals,dict,"cecclf")_" in circumflex, and")
 . d OUT($$XSUB("cecc",vals,dict,"ceccrc")_" in right coronary. "_cac_para)
 ; 
 if $$XVAL("cecca",vals)'="-" d  ;
 . d HOUT("Aortic Calcifications: ")
 . d OUT($$XSUB("cecc",vals,dict,"cecca"))
 ;
 d HOUT("Cardiac Findings:")
 ;
 ;# Pericardial Effusion
 if $$XVAL("ceprevm",vals)'="-" d  ;
 . if $$XVAL("ceprevm",vals)'="no" d  ;
 . . if $$XVAL("ceprevm",vals)'="" d
 . . . d OUT("A "_$$XSUB("ceprevm",vals,dict,"ceprevm")_" pericardial effusion"_"."_para)
 . . . s pe=1
 . . else  d OUT("No pericardial effusion."_para)
 ;
 ;
 ;;# Pulmonary and Aortic Diameter
 i $$XVAL("cepaw",vals)'="" d  ;
 . d OUT("Widest main pulmonary artery diameter is "_$$XVAL("cepaw",vals)_" mm. ")
 . if $$XVAL("ceaow",vals)'="" d  ;
 . . d OUT("Widest ascending aortic diameter at the same level is "_$$XVAL("ceaow",vals)_" mm. ")
 . . if $$XVAL("cepar",vals)'="" d  ;
 . . . d OUT("The ratio is "_$$XVAL("cepar",vals)_".")
 . d OUT(para)
 ;
 ; #"Additional Comments on Cardiac Abnormalities:"
 if $$XVAL("cecommca",vals)'="" d  ;
 . d OUT($$XVAL("cecommca",vals)_"."_para)
 ;
 ;
 d HOUT("Mediastinum:")
 n yesmm s yesmm=0
 n abn
 i ($$XVAL("ceoma",vals)="y")&($$XVAL("ceata",vals)="y") d  ;
 . s yeamm=1
 . s abn=$$CCMSTR("ceatc^ceaty^ceatm",vals)
 . ;d OUT("[abn="_abn_"]")
 . i abn="" d OUT("Noted in the thyroid.")
 . i abn'="" d OUT(abn_" thyroid.")
 . i $$XVAL("ceato",vals)="o" d OUT($$XVAL("ceatos",vals)_"<br>")
 i $$XVAL("ceaya",vals)="y" d  ;
 . s yesmm=1
 . s abn=$$CCMSTR("ceayc^ceayy^ceaym",vals)
 . i abn="" d OUT("Noted in the thymus")
 . i abn'="" d OUT(abn_" thymus.")
 . i $$XVAL("ceayo",vals)="o" d OUT($$XVAL("ceayos",vals)_"<br>")
 ;
 ;   # Non-calcified lymph nodes
 n lnlist,lnlistt
 set lnlist(1)="cemlnl1"
 set lnlist(2)="cemlnl2r"
 set lnlist(3)="cemlnl2l"
 set lnlist(4)="cemlnl3"
 set lnlist(5)="cemlnl4r"
 set lnlist(6)="cemlnl4l"
 set lnlist(7)="cemlnl5"
 set lnlist(8)="cemlnl6"
 set lnlist(9)="cemlnl7"
 set lnlist(10)="cemlnl8"
 set lnlist(11)="cemlnl9"
 set lnlist(12)="cemlnl10r"
 set lnlist(13)="cemlnl10l"
 ;
 set lnlistt(1)="high mediastinal"
 set lnlistt(2)="right upper paratracheal"
 set lnlistt(3)="left upper paratracheal"
 set lnlistt(4)="prevascular/retrotracheal"
 set lnlistt(5)="right lower paratracheal"
 set lnlistt(6)="left lower paratracheal"
 set lnlistt(7)="sub-aortic (A-P window)"
 set lnlistt(8)="para-aortic"
 set lnlistt(9)="subcarinal"
 set lnlistt(10)="para-esophageal"
 set lnlistt(11)="pulmonary ligament"
 set lnlistt(12)="right hilar"
 set lnlistt(13)="left hilar"
 ;
 ;
 if $$XVAL("cemln",vals)="y" d  ;
 . s yesmm=1
 . n llist,item
 . s (llist,item)=""
 . f  s item=$o(lnlist(item)) q:item=""  d  ;
 . . i $$XVAL(lnlist(item),vals)'="" s llist($o(llist(""),-1)+1)=lnlist(item)
 . n lnum,slnum
 . s lnum=$o(llist(""),-1)
 . i lnum=0 d OUT("Enlarged or growing lymph nodes are noted.")
 . i lnum>0 d  ;
 . . s slnum=lnum
 . . d OUT("Enlarged or growing lymph nodes in the ")
 . . s item=""
 . . f  s item=$o(llist(item)) q:item=""  d  ;
 . . . d OUT(lnlistt(item))
 . . . i lnum>2 d OUT(", ")
 . . . i lnum=2 d OUT(" and ")
 . . . s lnum=lnum-1
 . . i slnum>1 d OUT("locations.")
 . . i slnum=1 d OUT("location.")
 ;
 ;
 if $$XVAL("cemlncab",vals)="y" d  ;
 . set yesmm=1
 . d OUT("Calcified lymph nodes present.<br>")
 ;
 if $$XVAL("ceagaln",vals)="y" d  ;
 . set yesmm=1
 . d OUT("Enlarged or growing axillary lymph nodes without central fat are seen.")
 . d OUT($$XVAL("ceagalns",vals)_"<br>")
 ;
 if $$XVAL("cemva",vals)="y" d  ;
 . set yesmm=1
 . if $$XVAL("cemvaa",vals)="a" d  ;
 . . d OUT("Other vascular abnormalities are seen in the aorta.")
 . if $$XVAL("cemvaa",vals)="w" d  ;
 . . d OUT("Other vascular abnormalities are seen in the pulmonary series.")
 . d OUT($$XVAL("cemvaos",vals)_"<br>")
 ;
 ;   # Esophageal
 if $$XVAL("cemeln",vals)="y" d  ;
 . set yesmm=1
 . n elist s elist=""
 . set numl=0
 . if $$XVAL("cemelna",vals)="a" d  ;
 . . s elist($o(elist(""),-1)+1)="Air-fluid level"
 . . s numl=numl+1
 . if $$XVAL("cemelnw",vals)="w" d  ;
 . . s elist($o(elist(""),-1)+1)="Wall thickening"
 . . s numl=numl+1
 . if $$XVAL("cemelnm",vals)="m" d  ;
 . . s elist($o(elist(""),-1)+1)="A mass"
 . . s numl=numl+1
 . if numl=0 d OUT("Esophageal abnormality noted.")
 . e  d  ;
 . . d OUT($g(elist(1)))
 . . if numl=1 d OUT(" is ")
 . . e  d  ;
 . . . if numl=2 d  ;
 . . . . d OUT(" and ")
 . . . e  d OUT(", ")
 . . . d OUT($$LOWC($g(elist(2))))
 . . . if numl=3 d  ;
 . . . . d OUT(", and "_$$LOWC($g(elist(3))))
 . . d OUT("seen in the esophagus.")
 . d OUT($$XVAL("cemelnos",vals)_para)
 ;
 ;
 if $$XVAL("cehhn",vals)="y" d  ;
 . set yesmm=1
 . if $$XVAL("cehhnos",vals)'="" d OUT("Hiatal hernia: "_$$XVAL("cehhnos",vals))
 . if $$XVAL("cehhnos",vals)="" d OUT("Hiatal hernia.")
 . d OUT(para)
 ;
 if $$XVAL("ceomm",vals)="y" d  ;
 . set yesmm=1
 . n tval
 . set tval=$$XVAL("ceommos",vals)
 . set abn=$$CCMSTR("ceamc^ceamy^ceamm",vals)
 . if abn="" d OUT("Abnormality noted in the mediastinum. ")
 . e  d OUT(abn_" mediastinum. ")
 . d OUT(tval_"<br>")
 i yesmm=0 d OUT("No abnormalities."_para)
 i $$XVAL("ceotabnm",vals)'="" d  ;
 . d OUT($$XVAL("ceotabnm",vals)_"."_para)
 d OUT("<p>")
 ;
 ;
 q
 ;
 ;
CCMSTR(lst,vals) ; extrinsic that forms phrases
 n retstr s retstr=""
 n lblist s lblist=""
 n lb,ib s ib=""
 f lb=1:1:$l(lst,"^") d  ;
 . n lvar s lvar=$p(lst,"^",lb)
 . s ib=$$XVAL($p(lst,"^",lb),vals)
 . if ib'="" d  ;
 . . i ib="y" d  ; 
 . . . i $f("ceasc cealc ceapc ceapc ceaac ceakc",lvar)>0 s lblist($o(lblist(""),-1)+1)="Calcification"
 . . . ;i "ceasc cealc ceapc ceapc ceaac ceakc"[lb s lblist($o(lblist(""),-1)+1)="Calcification"
 . . . else  s lblist($o(lblist(""),-1)+1)="Cyst"
 . . i ib="c" s lblist($o(lblist(""),-1)+1)="Calcification"
 . . i ib="m" s lblist($o(lblist(""),-1)+1)="Mass"
 i $o(lblist(""),-1)=1 s retstr=retstr_lblist(1)_" is seen in the"
 e  i $o(lblist(""),-1)=2 s retstr=retstr_lblist(1)_" and "_$$LOWC(lblist(2))_" are seen in the"
 e  i $o(lblist(""),-1)=3 s retstr=retstr_"Calicification, cyst, and mass are seen in the"
 q retstr
 ;
LOWC(X) ;  CONVERT X TO LOWERCASE
 Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
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
