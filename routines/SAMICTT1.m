SAMICTT1 ;ven/gpl - ctreport text nodules; 2024-09-24t16:52z
 ;;18.0;SAMI;**4,10,11,19**;2020-01-17;Build 1
 ;mdc-e1;SAMICTT1-20240924-Egyq4v;SAMI-18-19-b1
 ;mdc-v7;B154195678;SAMI*18.0*19 SEQ #19
 ;
 ; SAMICTT1 creates the Nodules section of the ELCAP CT Report in text
 ; format.
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
 ; NODULES nodules section of ctreport in text format
 ; OUT output a line of ct report
 ; HOUT output a ct report header line
 ; $$XVAL patient value for var
 ; $$XSUB dictionary value defined by var
 ;
 ;
 ;
 ;
 ;@section 1 NODULES & related subroutines
 ;
 ;
 ;
 ;
 ;@proc OTHRLUNG
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean;sac?;tests?;port
 ;@called-by
 ; WSREPORT^SAMICTT0
 ;@calls
 ; $$XVAL
 ; OUT
 ; $$XSUB
 ; HOUT
 ;@input
 ; rtn
 ; vals
 ; dict
 ;@output
 ; create nodules section of ct eval report
 ;
 ;
NODULES(rtn,vals,dict) ; nodules section of ctreport in text format
 ;
 ;# Report on Nodules
 n firstitem s firstitem=0
 n outmode s outmode="hold"
 n line s line=""
 n ii s ii=1
 ;# Information for each nodule
 f ii=1:1:10 d  ;
 . i $$XSUB("cectch",vals,dict,"cect"_ii_"ch")="px" q  ;
 . i $$XSUB("cectch",vals,dict,"cect"_ii_"ch")="" q  ;
 . i firstitem=0 d  ;
 . . ;d OUT("<!-- begin nodule info -->")
 . . ;d OUT("<UL TYPE=disc>")
 . . s firstitem=1
 . . q
 . ;
 . ;d OUT("<LI>")
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
 . n vssw s vssw=0
 . n avgss s avgss=0
 . n vssl s vssl=$$XVAL("cect"_ii_"ssl",vals)
 . i vssl'=0 d  ;
 . . s vssw=$$XVAL("cect"_ii_"ssw",vals)
 . . s avgss=(vssl+vssw)/2
 . . s avgss=$j(avgss,1,1)
 . . q
 . n vsl s vsl=$$XVAL("cect"_ii_"sl",vals)
 . n vsw s vsw=$$XVAL("cect"_ii_"sw",vals)
 . n avgs s avgs=$j(vsl+vsw/2,1,1)
 . n scomp s scomp=""
 . ;
 . i $$XVAL("cect"_ii_"ssl",vals)]"" d  ;
 . . ;s scomp=" (solid component "_$$XVAL("cect"_ii_"ssl",vals)_" mm x "_$$XVAL("cect"_ii_"ssw",vals)_" mm average diameter "_avgss_" mm)"
 . . s scomp=", solid component "_$$XVAL("cect"_ii_"ssl",vals)_" mm x "_$$XVAL("cect"_ii_"ssw",vals)_" mm (average diameter of "_avgss_" mm)"
 . . q
 . ;
 . s calcstr=calcstr_$$XVAL("cect"_ii_"sl",vals)_" mm x "_$$XVAL("cect"_ii_"sw",vals)_" mm (average diameter of "_avgs_" mm)"_scomp_", "
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
 . n loc s loc=""
 . n nloc s nloc=""
 . n en s en=$$XVAL("cect"_ii_"en",vals)
 . n ll s ll=$$XVAL("cect"_ii_"ll",vals)
 . n endo
 . ;
 . i $l(en)<2!(en="no")!(en="") d  ;
 . . ;# 1) parenchymal only
 . . n X s X=ll
 . . n Y
 . . X ^%ZOSF("UPPERCASE")
 . . s loc=Y
 . . s nloc=Y
 . . s endo="Nodule"
 . . q
 . ;
 . e  d  ;
 . . i ll="end" d  ;
 . . . ;# 2) Endobronchial only
 . . . i en="tr" d  ;
 . . . . s endo="Endotracheal Nodule"
 . . . . i specialcase=1 d  ;
 . . . . . d OUT("Previously seen "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . . q
 . . . . ;
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cectch"_ii_"ch",vals)="n") d  ;
 . . . . . . d OUT(endo_" "_ii_" "_calcstr_" is seen. ")
 . . . . . . q
 . . . . . e  d OUT(endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . . q
 . . . . s skip=1
 . . . . q
 . . . ;
 . . . i en="rm" d  ;
 . . . . s endo="Nodule"
 . . . . s nloc=$$XSUB("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . ;d OUT("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . . . d OUT("Previously seen "_endo_" "_ii_" in the "_nloc_" "_calcstr_" ")
 . . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . . q
 . . . . ;
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . ;d OUT(nloc_" "_endo_" "_ii_". ")
 . . . . . . d OUT(endo_" "_ii_" is seen in the "_nloc_" "_calcstr_". ")
 . . . . . . q
 . . . . . ;e  d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . . e  d OUT(endo_" "_ii_" in the "_nloc_" "_calcstr_", "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . . q
 . . . . ;
 . . . . s skip=1
 . . . . q
 . . . ;
 . . . i en="bi" d  ;
 . . . . s endo="Nodule"
 . . . . s loc=$$XSUB("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . ;d OUT("Previously seen "_endo_" "_ii_" in the "_loc)
 . . . . . d OUT("Previously seen "_endo_" "_ii_" in the "_nloc_" "_calcstr_" ")
 . . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . . q
 . . . . ;
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . ;d OUT(endo_" "_ii_" is seen in the "_loc_". ")
 . . . . . . d OUT(endo_" "_ii_" is seen in the "_loc_" "_calcstr_". ")
 . . . . . . q
 . . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . . q
 . . . . ;
 . . . . s skip=1
 . . . . q
 . . . ;
 . . . i skip=0 d  ; "default"
 . . . . s endo="Nodule"
 . . . . n X s X=$$XVAL("cect"_ii_"en",vals)
 . . . . n Y
 . . . . X ^%ZOSF("UPPERCASE")
 . . . . s nloc=Y
 . . . . ;
 . . . . i specialcase=1 d  ;
 . . . . . d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_", likely endobronchial. ")
 . . . . . q
 . . . . ;
 . . . . e  d  ;
 . . . . . ;i ($$XVAL("cetex",vals)="b")&($$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . . i (($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n")) d  ; gpl 1002
 . . . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" likely endobronchial. ")
 . . . . . . q
 . . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_" likely endobronchial. ")
 . . . . ;
 . . . . s skip=1
 . . . . q
 . . . q
 . . ;
 . . e  d  ;
 . . . s endo="Nodule"
 . . . s loc=$$XSUB("cectll",vals,dict,"cect"_ii_"ll")
 . . . n X s X=$$XVAL("cect"_ii_"en",vals)
 . . . n Y
 . . . X ^%ZOSF("UPPERCASE")
 . . . s nloc=Y
 . . . ;
 . . . i specialcase=1 d  ;
 . . . . d OUT(nloc_" "_endo_" "_ii_" previously seen with possible endobronchial component")
 . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . q
 . . . ;
 . . . e  d  ;
 . . . . ;i $$XVAL("cetex",vals)="b",$$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n" d  ;
 . . . . i $$XVAL("cetex",vals)="b",$$XVAL("cect"_ii_"ch",vals)="n" d  ; gpl 1002
 . . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobronchial component")
 . . . . . q
 . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobronchial component "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . . q
 . . . ;
 . . . s skip=1
 . . . q
 . . q
 . ;
 . i specialcase=1 d  ;
 . . i skip=0 d  ;
 . . . d OUT("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_". ")
 . . . q
 . . q
 . ;
 . e  d  ;
 . . i skip=0 d  ;
 . . . ;# pleural distance only goes here
 . . . i $$XVAL("cect"_ii_"pld",vals)]"" s calcstr=calcstr_" "_pldstr_","
 . . . ;# Special Handling for "newly seen" on baseline
 . . . ;i $$XVAL("cetex",vals)="b",$$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n" d  ;
 . . . i $$XVAL("cetex",vals)="b",$$XVAL("cect"_ii_"ch",vals)="n" d  ; gpl 1002
 . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr)
 . . . . q
 . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_" ")
 . . . q
 . . ;
 . . d OUT(" (Series "_$$XVAL("cect"_ii_"sn",vals)_",") ; added from 1114 gpl1
 . . ;
 . . ;i $$XVAL("cect"_ii_"inl",vals)=$$XVAL("cect"_ii_"inh",vals) d  ;
 . . ;. d OUT(" image "_$$XVAL("cect"_ii_"inh",vals)_"). ")
 . . ;. q
 . . ;e  d  ;
 . . ;. d OUT(" image "_$$XVAL("cect"_ii_"inl",vals)_$$XVAL("cect"_ii_"inh",vals)_"). ")
 . . ;. q
 . . ;
 . . i $$XVAL("cect"_ii_"inh",vals)="" d  ;
 . . . d OUT(" image "_$$XVAL("cect"_ii_"inl",vals)_"). ")
 . . . q
 . . ;
 . . e  d  ;
 . . . d OUT(" image "_$$XVAL("cect"_ii_"inl",vals)_"-"_$$XVAL("cect"_ii_"inh",vals)_"). ")
 . . . q
 . . ;
 . . i $$XVAL("cect"_ii_"co",vals)]"" d OUT($$XVAL("cect"_ii_"co",vals)_". ") ;1122 gpl1
 . . n ac s ac=$$XVAL("cect"_ii_"ac",vals)
 . . i ac]"",ac'="-",ac'="s" d  ;
 . . . d OUT($$XSUB("cectac",vals,dict,"cect"_ii_"ac")_" recommended. ")
 . . . q
 . . q
 . ;
 . ; end of nodule processing
 . ;
 . s outmode="go"
 . d OUT("")
 . s outmode="hold"
 . q
 ;
 i firstitem'=0 d  ;
 . ;d OUT("</UL>")
 . ;d OUT("<!-- end nodule info -->")
 . q
 ;
 ;d OUT("</p>")
 ;
 ; added 5/19/21 gpl
 s outmode="go"
 i $$XVAL("cectancn",vals)=1 d
 . d OUT("Small non-calcified nodules are present ")
 . q
 ;
 i $$XVAL("cectacn",vals)=1 d
 . d OUT("Small calcified nodules are present ")
 . q
 ;
 d OUT(" ")
 ;
 quit  ; end of NODULES
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
 ; NODULES
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
OUT(ln) ; output ct report line
 ;
 i ln[".." s ln=$p(ln,"..")_"." ; remove double periods at the end
 ;
 i outmode="hold" s line=line_ln q  ;
 s cnt=cnt+1
 ;s debug=1
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
 ;@called-by
 ; NODULES
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
 ; NODULES
 ;@calls none
 ;@input
 ; var
 ; vals is passed by name
 ;@output = patient value for var
 ;
 ;
XVAL(var,vals) ; patient value for var
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
 ; NODULES
 ;@calls none
 ;@input
 ; var
 ; vals & dict are passed by name
 ; valdx is used for nodules ala cect2co with nodule # included
 ;@output = dictionary value for var
 ;
 ;
XSUB(var,vals,dict,valdx) ; dictionary value defined by var
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
EOR ; end of routine SAMICTT1
