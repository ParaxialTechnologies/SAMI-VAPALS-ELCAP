SAMICTR1 ;ven/gpl - ielcap: forms ; 12/28/18 10:54am
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
NODULES(rtn,vals,dict) ;
 ;
 ;
 ;# Report on Nodules
 n firstitem
 set firstitem=0
 n ii set ii=1
 ;# Information for each nodule
 f ii=1:1:10 d  ;
 . i $$XSUB("cectch",vals,dict,"cect"_ii_"ch")="px" q  ;
 . i $$XSUB("cectch",vals,dict,"cect"_ii_"ch")="" q  ;
 . i firstitem=0 d  ;
 . . d OUT("<!-- begin nodule info -->")
 . . d OUT("<UL TYPE=disc>")
 . . set firstitem=1
 . ;
 . d OUT("<LI>")
 . n specialcase s specialcase=0
 . n ij,ik
 . s ik=$$XVAL("cect"_ii_"ch",vals)
 . ;f ij="pw","px","pr","pv" i ij=ik s specialcase=1
 . i "pwpxprpv"[ik s specialcase=1
 . ;
 . ;# Example Sentence
 . ;# LUL Nodule 1 is non-calcified, non-solid, 6 mm x 6 mm (with 3 x 3) solid component), smooth edge, previously seen and unchanged. (Series 2, Image 65)
 . ;# [LOCATION] Nodule [N] is [CALCIFICATION], [SOLID], [L] mm x mm, [SMOOTH], [NEW].  (Series [Series], Image [ImageNum]).
 . ;
 . n spic s spic=""
 . i $$XVAL("cect"_ii_"sp",vals)="y" s spic="spiculated, "
 . ;
 . n calcification,calcstr,status
 . s status=$$XVAL("cect"_ii_"st",vals)
 . s @vals@("cect"_ii_"ca")=$s(status="bc":"y",status="pc":"q",1:"n")
 . s calcification=$$XSUB("cectca",vals,dict,"cect"_ii_"ca")
 . i calcification="" s calcstr="is "_spic_$$XSUB("cectnt",vals,dict,"cect"_ii_"nt")_", "
 . e  s calcstr="is "_calcification_", "_spic_$$XSUB("cectnt",vals,dict,"cect"_ii_"nt")_", "
 . ;
 . n scomp
 . s scomp=""
 . i $$XVAL("cect"_ii_"ssl",vals)'="" d  ;
 . . s scomp=" (solid component "_$$XVAL("cect"_ii_"ssl",vals)_" mm x "_$$XVAL("cect"_ii_"ssw",vals)_" mm)"
 . ;
 . s calcstr=calcstr_$$XVAL("cect"_ii_"sl",vals)_" mm x "_$$XVAL("cect"_ii_"sw",vals)_" mm"_scomp_", "
 . ;
 . n smooth
 . ;s smooth=$$XSUB("cectse",vals,dict,"cect"_ii_"se")
 . s smooth=$$XVAL("cect"_ii_"se",vals)
 . i smooth="y" s calcstr=calcstr_"smooth edges, "
 . ;e  s calcstr=calcstr_smooth_" edges, " ;nothing if not smooth
 . ;
 . ; adding distance from costal pleura
 . n pldstr
 . s pldstr="within "_$$XVAL("cect"_ii_"pld",vals)_" mm of the costal pleura"
 . ;
 . n skip s skip=0
 . ;# 3 cases: parenchymal, endobronchial, and both
 . ;
 . n en,loc,nloc,endo,ll
 . s loc=""
 . s nloc=""
 . s en=$$XVAL("cect"_ii_"en",vals)
 . s ll=$$XVAL("cect"_ii_"ll",vals)
 . i ($l(en)<2)!(en="no")!(en="") d  ;
 . . ;# 1) parenchymal only
 . . n X,Y s X=ll
 . . X ^%ZOSF("UPPERCASE")
 . . s loc=Y
 . . s nloc=Y
 . . s endo="Nodule"
 . e  d  ;
 . . i ll="end" d  ;
 . . . ;# 2) Endobronchial only
 . . . i en="tr" d  ;
 . . . . s endo="Endotracheal Nodule"
 . . . . i specialcase=1 d  ;
 . . . . . d OUT("Previously seen "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cectch"_ii_"ch",vals)="n") d  ;
 . . . . . . d OUT(endo_" "_ii_" "_calcstr_" is seen.")
 . . . . . e  d OUT(endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i en="rm" d  ;
 . . . . s endo="Nodule"
 . . . . s nloc=$$XSUB("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . ;d OUT("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . . . d OUT("Previously seen "_endo_" "_ii_" in the "_nloc_" "_calcstr_" ")
 . . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . ;d OUT(nloc_" "_endo_" "_ii_".")
 . . . . . . d OUT(endo_" "_ii_" is seen in the "_nloc_" "_calcstr_".")
 . . . . . ;e  d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . . e  d OUT(endo_" "_ii_" in the "_nloc_" "_calcstr_", "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i en="bi" d  ;
 . . . . s endo="Nodule"
 . . . . s loc=$$XSUB("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . ;d OUT("Previously seen "_endo_" "_ii_" in the "_loc)
 . . . . . d OUT("Previously seen "_endo_" "_ii_" in the "_nloc_" "_calcstr_" ")
 . . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . ;d OUT(endo_" "_ii_" is seen in the "_loc_".")
 . . . . . . d OUT(endo_" "_ii_" is seen in the "_loc_" "_calcstr_".")
 . . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i skip=0 d  ; "default"
 . . . . s endo="Nodule"
 . . . . n X,Y
 . . . . s X=$$XVAL("cect"_ii_"en",vals)
 . . . . X ^%ZOSF("UPPERCASE")
 . . . . s nloc=Y
 . . . . i specialcase=1 d  ;
 . . . . . d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_", likely endobronchial.")
 . . . . e  d  ;
 . . . . . ;i ($$XVAL("cetex",vals)="b")&($$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . . i (($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n")) d  ; gpl 1002
 . . . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" likely endobronchial.")
 . . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_" likely endobronchial.")
 . . . . s skip=1
 . . e  d  ;
 . . . s endo="Nodule"
 . . . s loc=$$XSUB("cectll",vals,dict,"cect"_ii_"ll")
 . . . n X,Y
 . . . s X=$$XVAL("cect"_ii_"en",vals)
 . . . X ^%ZOSF("UPPERCASE")
 . . . s nloc=Y
 . . . i specialcase=1 d  ;
 . . . . d OUT(nloc_" "_endo_" "_ii_" previously seen with possible endobronchial component")
 . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . e  d  ;
 . . . . ;i ($$XVAL("cetex",vals)="b")&($$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . i (($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n")) d  ; gpl 1002
 . . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobronchial component")
 . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobronchial component "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . s skip=1
 . i specialcase=1 d  ;
 . . i skip=0 d  ;
 . . . d OUT("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . e  d  ;
 . . i skip=0 d  ;
 . . . ;# pleural distance only goes here
 . . . i $$XVAL("cect"_ii_"pld",vals)'="" s calcstr=calcstr_" "_pldstr_","
 . . . ;# Special Handling for "newly seen" on baseline
 . . . ;i ($$XVAL("cetex",vals)="b")&($$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . i (($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n")) d  ; gpl 1002
 . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr)
 . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_" ")
 . . d OUT(" (Series "_$$XVAL("cect"_ii_"sn",vals)_",") ; added from 1114 gpl1
 . . ;i $$XVAL("cect"_ii_"inl",vals)=$$XVAL("cect"_ii_"inh",vals) d  ;
 . . ;. d OUT(" image "_$$XVAL("cect"_ii_"inh",vals)_"). ")
 . . ;e  d  ;
 . . ;. d OUT(" image "_$$XVAL("cect"_ii_"inl",vals)_$$XVAL("cect"_ii_"inh",vals)_"). ")
 . . i $$XVAL("cect"_ii_"inh",vals)="" d  ;
 . . . d OUT(" image "_$$XVAL("cect"_ii_"inl",vals)_"). ")
 . . e  d  ;
 . . . d OUT(" image "_$$XVAL("cect"_ii_"inl",vals)_"-"_$$XVAL("cect"_ii_"inh",vals)_"). ")
 . . i $$XVAL("cect"_ii_"co",vals)'="" d OUT($$XVAL("cect"_ii_"co",vals)_". ") ;1122 gpl1
 . . n ac
 . . s ac=$$XVAL("cect"_ii_"ac",vals)
 . . i ac'="" i (ac'="-") i (ac'="s") d  ;
 . . . d OUT($$XSUB("cectac",vals,dict,"cect"_ii_"ac")_" recommended.")
 . ;
 . ; end of nodule processing
 . ;
 i firstitem'=0 d  ;
 . d OUT("</UL>")
 . d OUT("<!-- end nodule info -->")
 d OUT("</p>")
 ;
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
