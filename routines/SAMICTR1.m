SAMICTR1 ;ven/gpl - ielcap: forms ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
nodules(rtn,vals,dict)
 ;
 ;
 ;# Report on Nodules
 n firstitem
 set firstitem=0
 n ii set ii=1
 ;# Information for each nodule
 f ii=1:1:10 d  ;
 . i $$xsub("cectch",vals,dict,"cect"_ii_"ch")="px" q  ;
 . i $$xsub("cectch",vals,dict,"cect"_ii_"ch")="" q  ;
 . i firstitem=0 d  ;
 . . d out("<!-- begin nodule info -->")
 . . d out("<UL TYPE=disc>")
 . . set firstitem=1
 . ;
 . d out("<LI>")
 . n specialcase s specialcase=0
 . n ij,ik
 . s ik=$$xval("cect"_ii_"ch",vals)
 . f ij="pw","px","pr","pv" i ij=ik s specialcase=1
 . ;
 . ;# Example Sentence
 . ;# LUL Nodule 1 is non-calcified, non-solid, 6 mm x 6 mm (with 3 x 3) solid component), smooth edge, previously seen and unchanged. (Series 2, Image 65)
 . ;# [LOCATION] Nodule [N] is [CALCIFICATION], [SOLID], [L] mm x mm, [SMOOTH], [NEW].  (Series [Series], Image [ImageNum]).
 . ;
 . n spic s spic=""
 . i $$xval("cect"_ii_"sp",vals)="y" s spic="spiculated, "
 . ;
 . n calcification,calcstr
 . s calcification=$$xsub("cecta",vals,dict,"cect"_ii_"ca")
 . i calcification="" s calcstr="is "_spic_$$xsub("cectnt",vals,dict,"cect"_ii_"nt")_", "
 . e  s calcstr="is "_calcification_", "_spic_$$xsub("cectnt",vals,dict,"cect"_ii_"nt")_", "
 . ;
 . n scomp
 . s scomp=""
 . i $$xval("cect"_ii_"ssl",vals)'="" d  ;
 . . s scomp=" (solid component "_$$xval("cect"_ii_"ssl",vals)_" mm x "_$$xval("cect"_ii_"ssw",vals)_" mm)"
 . ;
 . s calcstr=calcstr_$$xval("cect"_ii_"sl",vals)_" mm x "_$$xval("cect"_ii_"sw",vals)_" mm"_scomp_", "
 . ;
 . n smooth
 . s smooth=$$xsub("cectse",vals,dict,"cect"_ii_"se")
 . i smooth="" s calcstr=calcstr_"smooth edges, "
 . e  s calcstr=calcstr_smooth_" edges, "
 . ;
 . n skip s skip=0
 . ;# 3 cases: parenchymal, endobronchial, and both
 . ;
 . n en,nloc,endo,ll
 . s en=$$xval("cect"_ii_"en",vals)
 . s ll=$$xval("cect"_ii_"ll",vals)
 . i ($l(en)<2)!(en="no")!(en="") d  ;
 . . ;# 1) parenchymal only
 . . s X=ll
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
 . . . . . d out("Previously seen "_endo_" "_ii_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$xval("cetex",vals)="b")&($$xval("cectch"_ii_"ch",vals)="n") d  ;
 . . . . . . d out(endo_" "_ii_" "_calcstr_" is seen.")
 . . . . . e  d out(endo_" "_ii_" "_calcstr_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i en="rm" d  ;
 . . . . s endo="Nodule"
 . . . . s loc=$$xsub("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . d out("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . . . d out($$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$xval("cetex",vals)="b")&($$xval("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . d out(nloc_" "_endo_" "_ii_".")
 . . . . . e  d out(nloc_" "_endo_" "_ii_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i en="bi" d  ;
 . . . . s endo="Nodule"
 . . . . s loc=$$xsub("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . d out("Previously seen "_endo_" "_ii_" in the "_loc)
 . . . . . d out($$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$xval("cetex",vals)="b")&($$xval("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . d out(endo_" "_ii_" is seen in the "_loc_".")
 . . . . . e  d out(endo_" "_ii_" in the "_loc_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i skip=0 d  ; "default"
 . . . . s endo="Nodule"
 . . . . s X=$$xval("cect"_ii_"en",vals)
 . . . . X ^%ZOSF("UPPERCASE")
 . . . . s nloc=Y
 . . . . i specialcase=1 d  ;
 . . . . . d out(nloc_" "_endo_" "_ii_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_", likely endobronchial.")
 . . . . e  d  ;
 . . . . . i ($$xval("cetex",vals)="b")&($$xsub("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . . . d out(nloc_" "_endo_" "_ii_" "_calcstr_" likely endobronchial.")
 . . . . . e  d out(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_" likely endobronchial.")
 . . . . s skip=1
 . . e  d  ;
 . . . s endo="Nodule"
 . . . s loc=$$xsub("cectll",vals,dict,"cect"_ii_"ll")
 . . . s X=$$xval("cect"_ii_"en",vals)
 . . . X ^%ZOSF("UPPERCASE")
 . . . s nloc=Y
 . . . i specialcase=1 d  ;
 . . . . d out(nloc_" "_endo_" "_ii_" previously seen with possible endobronchial component")
 . . . . d out($$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . e  d  ;
 . . . . i ($$xval("cetex",vals)="b")&($$xsub("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . . d out(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobronchial component")
 . . . . e  d out(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobrochial component "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . s skip=1
 . i specialcase=1 d  ;
 . . i skip=0 d  ;
 . . . d out("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . d out($$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . e  d  ;
 . . i skip=0 d  ;
 . . . ;# Special Handling for "newly seen" on baseline
 . . . i ($$xval("cetex",vals)="b")&($$xsub("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . d out(nloc_" "_endo_" "_ii_" "_calcstr)
 . . . e  d out(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_" ")
 . . d out(" (Series "_$$xval("cect"_ii_"sn",vals)_",") ; added from 1114 gpl1
 . . i $$xval("cect"_ii_"inl",vals)=$$xval("cect"_ii_"inh",vals) d  ;
 . . . d out(" image "_$$xval("cect"_ii_"inh",vals)_"). ")
 . . e  d  ;
 . . . d out(" image "_$$xval("cect"_ii_"inl",vals)_$$xval("cect"_ii_"inh",vals)_"). ")
 . . i $$xval("cect"_ii_"co",vals)'="" d out($$xval("cect"_ii_"co",vals)_". ") ;1122 gpl1
 . . n ac
 . . s ac=$$xval("cect"_ii_"ac",vals)
 . . i ac'="" i (ac'="-") i (ac'="s") d  ;
 . . . d out($$xsub("cectac",vals,dict,"cect"_ii_"ac")_" recommended.")
 . ;
 . ; end of nodule processing
 . ;
 i firstitem'=0 d  ;
 . d out("</UL>")
 . d out("<!-- end nodule info -->")
 d out("</p>")
 ;
 q
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
 
