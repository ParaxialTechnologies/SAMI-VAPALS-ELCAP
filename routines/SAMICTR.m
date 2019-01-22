SAMICTR ;ven/gpl - ielcap: forms ; 1/22/19 1:25pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; no entry from top
 ;
WSREPORT(return,filter) ; web service which returns an html cteval report
 ;
 n debug s debug=0
 i $g(filter("debug"))=1 s debug=1
 ;
 ;s rtn=$na(^TMP("SAMICTR",$J))
 n rtn s rtn="return"
 k @rtn
 s HTTPRSP("mime")="text/html"
 ;
 n cnt s cnt=0 ; line number
 ;
 ; set up dictionary and patient values
 ;
 n dict,vals
 ;d INIT^SAMICTD2("dict")
 s dict=$$setroot^%wd("cteval-dict")
 s dict=$na(@dict@("cteval-dict"))
 i $g(@dict@("pet"))="" d INIT2GPH^SAMICTD2 ; initialize the dictionary first time
 n si
 s si=$g(filter("studyid"))
 i si="" d  ;
 . s si="XXX0004"
 q:si=""
 n samikey
 s samikey=$g(filter("form"))
 i samikey="" d  ;
 . s samikey="ceform-2018-03-12"
 n root s root=$$setroot^%wd("vapals-patients")
 i $g(filter("studyid"))="" s root=$$setroot^%wd("elcap-patients")
 s vals=$na(@root@("graph",si,samikey))
 ;W !,vals
 ;zwr @vals@(*)
 i '$d(@vals) d  q  ;
 . w !,"error, patient values not found"
 ;
 ; report parameters
 ;
 n nt,sectionheader,dummy,cac,tex,para,legout,lang,langread
 ;
 s nt=1
 s sectionheader=1
 s dummy="******"
 s cac=""
 s tex=0
 s para="<p>"
 s legout=0
 n qheader s qheader=1
 ;
 s lang=""
 s langread=0
 ;
 n auth
 s auth("perm")="a"
 s auth("inst")=$g(filter("auth"))
 ;
 n newct s newct=0
 i $$XVAL("ceoppa",vals)'="" s newct=1
 ;
 n registryForm s registryForm=0
 i $$XVAL("ceaf",vals)'="" s registryForm=1
 ;
 d OUT("<HTML><HEAD>")
 d OUT("<TITLE>CT Evaluation Report</TITLE>")
 d OUT("<link rel='stylesheet' href='/css/report.css'>")
 d OUT("</HEAD>")
 d OUT("<BODY BGCOLOR=""#ffffff"" TEXT=""#000000"">")
 d OUT("<TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640""><TR><TD>")
 d OUT("<FONT SIZE=""+2""><CENTER>")
 d OUT("<B>CT Evaluation Report</B>")
 d OUT("</CENTER></FONT>")
 d OUT("</TD></TR><TR><TD>")
 d OUT("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 d OUT("</TD></TR>")
 ;
 d OUT("<!-- patient information -->")
 d OUT("<TR><TD><TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640"">")
 ;
 ;# Queens specific header
 if qheader d  ;
 . d OUT("<TR><TD WIDTH=""85""><B>Exam Date: </B></TD><TD>")
 . d OUT($$XVAL("cedos",vals))
 . d OUT("</TD></TR>")
 . ;
 . d OUT("<TR><TD><B>Type:</B></TD><TD>")
 . d OUT($$XSUB("cetex",vals,dict)_" "_$$XSUB("cectp",vals,dict))
 . d OUT("</TD></TR>")
 . ;
 . d OUT("<TR><TD><B>Study ID:</B></TD><TD>")
 . d OUT(si)
 . d OUT("</TD></TR>")
 . ;
 . ;   set svc [exec vcrc -c12 -n $si]
 . d OUT("<TR><TD><B>SVC:</B></TD><TD>")
 . ;d OUT(svc)
 . d OUT("</TD></TR>")
 ;
 i $$XVAL("sidob",vals)>0 d  ;
 . d OUT("<TD><B>Date of Birth:</B></TD><TD>")
 . d OUT($$XVAL("sidob",vals))
 . d OUT("</TD></TR>")
 e  d  ;
 . d OUT("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 d OUT("</TABLE>")
 d OUT("</TD></TR><TR><TD>")
 d OUT("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 d OUT("</TD></TR>")
 d OUT("<!-- report -->")
 d OUT("<TR><TD>")
 d OUT("<FONT SIZE=""+2""><B>")
 d OUT("Report:")
 d OUT("</B></FONT>")
 d OUT("</TD></TR><TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 ;
 i $$XVAL("ceclin",vals)'="" d  ;
 . d HOUT("Clinical Information: ")
 . d OUT($$XVAL("ceclin",vals))
 ;
 n nopri s nopri=1
 d HOUT("Comparison CT Scans: ")
 if $$XVAL("cedcs",vals)'="" d  ;
 . d OUT($$XSUB("cetex",vals,dict)_". ")
 . d OUT("Comparisons: "_$$XVAL("cedcs",vals))
 . s nopri=0
 if $$XVAL("cedps",vals)'="" d  ;
 . d OUT($$XVAL("cedps",vals))
 . s nopri=0
 d:nopri OUT("None")
 ;
 d HOUT(" Description: ")
 i $$XVAL("cectp",vals)'="" d  ;
 . d OUT("Limited Diagnostic CT examination was performed.")
 e  d  ;
 . d OUT("CT examination of the entire thorax was performed at"_$$XSUB("cectp",vals,dict)_" settings.")
 ;
 i $$XVAL("cectrst",vals)'="" d  ;
 . d OUT(" Images were obtained at "_$$XVAL("cectrst",vals)_" mm slice thickness.")
 . d OUT(" Multiplanar reconstructions were performed.")
 ;
 i newct d  ;
 . n nvadbo s nvadbo=1
 . n ii
 . f ii="ceoaa","ceaga","ceasa","ceala","ceapa","ceaaa","ceaka" d  ;
 . . i $$XVAL(ii,vals)="e" set nvadbo=0
 . ;
 . i nvadbo=1 d  ;
 . . d OUT("Upper abdominal images were not acquired on the current scan due to its limited nature.")
 ;
 ; lung nodules
 ;
 d HOUT("Lung nodules:")
 i $$XVAL("cennod",vals)="" d  ;
 . d OUT(para)
 . d OUT("No pulmonary nodules are seen."_para)
 e  i $$XVAL("ceanod",vals)="n" d  ;
 . d OUT(para)
 . d OUT("No pulmonary nodules are seen."_para)
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
 . f ij="pw","px","pr","pv" i ij=ik s specialcase=1
 . ;
 . ;# Example Sentence
 . ;# LUL Nodule 1 is non-calcified, non-solid, 6 mm x 6 mm (with 3 x 3) solid component), smooth edge, previously seen and unchanged. (Series 2, Image 65)
 . ;# [LOCATION] Nodule [N] is [CALCIFICATION], [SOLID], [L] mm x mm, [SMOOTH], [NEW].  (Series [Series], Image [ImageNum]).
 . ;
 . n spic s spic=""
 . i $$XVAL("cect"_ii_"sp",vals)="y" s spic="spiculated, "
 . ;
 . n calcification,calcstr
 . s calcification=$$XSUB("cecta",vals,dict,"cect"_ii_"ca")
 . i calcification="" s calcstr="is "_spic_$$XSUB("cectnt",vals,dict,"cect"_ii_"nt")_","
 . e  s calcstr="is "_calcification_", "_spic_$$XSUB("cectnt",vals,dict,"cect"_ii_"nt")_", "
 . ;
 . n scomp
 . s scomp=""
 . i $$XVAL("cect"_ii_"ssl",vals)'="" d  ;
 . . s scomp=" (solid component "_$$XVAL("cect"_ii_"ssl",vals)_" mm x "_$$XVAL("cect"_ii_"ssw",vals)_" mm)"
 . ;
 . s calcstr=calcstr_$$XVAL("cect"_ii_"sl",vals)_" mm x "_$$XVAL("cect"_ii_"sw",vals)_" mm "_scomp_", "
 . ;
 . n smooth
 . s smooth=$$XSUB("cectse",vals,dict,"cect"_ii_"se")
 . i smooth="" s calcstr=calcstr_"smooth edges, "
 . e  s calcstr=calcstr_smooth_" edges, "
 . ;
 . n skip s skip=0
 . ;# 3 cases: parenchymal, endobronchial, and both
 . ;
 . n en,nloc,endo,ll,loc
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
 . . . . s loc=$$XSUB("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . d OUT("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . d OUT(nloc_" "_endo_" "_ii_".")
 . . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i en="bi" d  ;
 . . . . s endo="Nodule"
 . . . . s loc=$$XSUB("cecten",vals,dict,"cect"_ii_"en")
 . . . . i specialcase=1 d  ;
 . . . . . d OUT("Previously seen "_endo_" "_ii_" in the "_loc)
 . . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XVAL("cect"_ii_"ch",vals)="n") d  ;
 . . . . . . d OUT(endo_" "_ii_" is seen in the "_loc_".")
 . . . . . e  d OUT(endo_" "_ii_" in the "_loc_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . . s skip=1
 . . . i skip=0 d  ; "default"
 . . . . s endo="Nodule"
 . . . . n X,Y s X=$$XVAL("cect"_ii_"en",vals)
 . . . . X ^%ZOSF("UPPERCASE")
 . . . . s nloc=Y
 . . . . i specialcase=1 d  ;
 . . . . . d OUT(nloc_" "_endo_" "_ii_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_", likely endobronchial.")
 . . . . e  d  ;
 . . . . . i ($$XVAL("cetex",vals)="b")&($$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" likely endobronchial.")
 . . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_" likely endobronchial.")
 . . . . s skip=1
 . . e  d  ;
 . . . s endo="Nodule"
 . . . s loc=$$XSUB("cectll",vals,dict,"cect"_ii_"ll")
 . . . n X,Y s X=$$XVAL("cect"_ii_"en",vals)
 . . . X ^%ZOSF("UPPERCASE")
 . . . s nloc=Y
 . . . i specialcase=1 d  ;
 . . . . d OUT(nloc_" "_endo_" "_ii_" previously seen with possible endobronchial component")
 . . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . e  d  ;
 . . . . i ($$XVAL("cetex",vals)="b")&($$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobronchial component")
 . . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" with possible endobrochial component "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . . s skip=1
 . i specialcase=1 d  ;
 . . i skip=0 d  ;
 . . . d OUT("Previously seen "_nloc_" "_endo_" "_ii_" ")
 . . . d OUT($$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . e  d  ;
 . . i skip=0 d  ;
 . . . ;# Special Handling for "newly seen" on baseline
 . . . i ($$XVAL("cetex",vals)="b")&($$XSUB("cectch",vals,dict,"cect"_ii_"ch")="n") d  ;
 . . . . d OUT(nloc_" "_endo_" "_ii_" "_calcstr)
 . . . e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_" ")
 . . . ;e  d OUT(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$XSUB("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . i $$XVAL("cect"_ii_"inl",vals)=$$XVAL("cect"_ii_"inh",vals) d  ;
 . . . d OUT("image"_$$XVAL("cect"_ii_"inh",vals)_". ")
 . . . ;d OUT("image "_$$XVAL("cect"_ii_"inh",vals)_".")
 . . e  d  ;
 . . . d OUT("images "_$$XVAL("cect"_ii_"inl",vals)-$$XVAL("cect"_ii_"inh",vals)_".")
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
 ;
 ; etc etc
 ;
 d OUT("</TABLE>")
 d OUT("<p><br></p><p><b>References:</b><br></p>")
 d OUT("<p>Recommendations for nodules and other findings are detailed in the I-ELCAP Protocol.<BR>")
 d OUT("A summary and the full I-ELCAP protocol can be viewed at: <a href=""http://ielcap.org/protocols"">http://ielcap.org/protocols</a></p>")
 d OUT("</TD></TR></TABLE></TD></TR></TABLE>")
 d OUT("</BODY></HTML>")
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
