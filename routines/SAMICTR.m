SAMICTR ;ven/gpl - ielcap: forms ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
wsReport(return,filter) ; web service which returns an html cteval report
 ;
 s debug=0
 i $g(filter("debug"))=1 s debug=1
 ;
 ;s rtn=$na(^TMP("SAMICTR",$J))
 s rtn="return"
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
 i $g(@dict@("pet"))="" d init2graph^SAMICTD2 ; initialize the dictionary first time
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
 n nt,sectionheader,dummy,cac,tex,para,legout,lang,lanread
 ;
 s nt=1
 s sectionheader=1
 s dummy="******"
 s cac=""
 s tex=0
 s para="<p>"
 s legout=0
 s qheader=1
 ;
 s lang=""
 s langread=0
 ;
 s auth("perm")="a"
 s auth("inst")=$g(filter("auth"))
 ;
 s newct=0
 i $$xval("ceoppa",vals)'="" s newct=1
 ;
 s registryForm=0
 i $$xval("ceaf",vals)'="" s registryForm=1
 ;
 d out("<HTML><HEAD>")
 d out("<TITLE>CT Evaluation Report</TITLE>")
 d out("<link rel='stylesheet' href='/css/report.css'>")
 d out("</HEAD>")
 d out("<BODY BGCOLOR=""#ffffff"" TEXT=""#000000"">")
 d out("<TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640""><TR><TD>")
 d out("<FONT SIZE=""+2""><CENTER>")
 d out("<B>CT Evaluation Report</B>")
 d out("</CENTER></FONT>")
 d out("</TD></TR><TR><TD>")
 d out("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 d out("</TD></TR>")
 ;
 d out("<!-- patient information -->")
 d out("<TR><TD><TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640"">")
 ;
 ;# Queens specific header
 if qheader d  ;
 . d out("<TR><TD WIDTH=""85""><B>Exam Date: </B></TD><TD>")
 . d out($$xval("cedos",vals))
 . d out("</TD></TR>")
 . ;
 . d out("<TR><TD><B>Type:</B></TD><TD>")
 . d out($$xsub("cetex",vals,dict)_" "_$$xsub("cectp",vals,dict))
 . d out("</TD></TR>")
 . ;
 . d out("<TR><TD><B>Study ID:</B></TD><TD>")
 . d out(si)
 . d out("</TD></TR>")
 . ;
 . ;   set svc [exec vcrc -c12 -n $si]
 . d out("<TR><TD><B>SVC:</B></TD><TD>")
 . ;d out(svc)
 . d out("</TD></TR>")
 ;
 i $$xval("sidob",vals)>0 d  ;
 . d out("<TD><B>Date of Birth:</B></TD><TD>")
 . d out($$xval("sidob",vals))
 . d out("</TD></TR>")
 e  d  ;
 . d out("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 d out("</TABLE>")
 d out("</TD></TR><TR><TD>")
 d out("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 d out("</TD></TR>")
 d out("<!-- report -->")
 d out("<TR><TD>")
 d out("<FONT SIZE=""+2""><B>")
 d out("Report:")
 d out("</B></FONT>")
 d out("</TD></TR><TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 ;
 i $$xval("ceclin",vals)'="" d  ;
 . d hout("Clinical Information: ")
 . d out($$xval("ceclin",vals))
 ;
 n nopri s nopri=1
 d hout("Comparison CT Scans: ")
 if $$xval("cedcs",vals)'="" d  ;
 . d out($$xsub("cetex",vals,dict)_". ")
 . d out("Comparisons: "_$$xval("cedcs",vals))
 . s nopri=0
 if $$xval("cedps",vals)'="" d  ;
 . d out($$xval("cedps",vals))
 . s nopri=0
 d:nopri out("None")
 ;
 d hout(" Description: ")
 i $$xval("cectp",vals)'="" d  ;
 . d out("Limited Diagnostic CT examination was performed.")
 e  d  ;
 . d out("CT examination of the entire thorax was performed at"_$$xsub("cectp",vals,dict)_" settings.")
 ;
 i $$xval("cectrst",vals)'="" d  ;
 . d out(" Images were obtained at "_$$xval("cectrst",vals)_" mm slice thickness.")
 . d out(" Multiplanar reconstructions were performed.")
 ;
 i newct d  ;
 . n nvadbo s nvadbo=1
 . n ii
 . f ii="ceoaa","ceaga","ceasa","ceala","ceapa","ceaaa","ceaka" d  ;
 . . i $$xval(ii,vals)="e" set nvabdo=0
 . ;
 . i nvadbo=1 d  ;
 . . d out("Upper abdominal images were not acquired on the current scan due to its limited nature.")
 ;
 ; lung nodules
 ;
 d hout("Lung nodules:")
 i $$xval("cennod",vals)="" d  ;
 . d out(para)
 . d out("No pulmonary nodules are seen."_para)
 e  i $$xval("ceanod",vals)="n" d  ;
 . d out(para)
 . d out("No pulmonary nodules are seen."_para)
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
 . i calcification="" s calcstr="is "_spic_$$xsub("cectnt",vals,dict,"cect"_ii_"nt")_","
 . e  s calcstr="is "_calcification_", "_spic_$$xsub("cectnt",vals,dict,"cect"_ii_"nt")_", "
 . ;
 . n scomp
 . s scomp=""
 . i $$xval("cect"_ii_"ssl",vals)'="" d  ;
 . . s scomp=" (solid component "_$$xval("cect"_ii_"ssl",vals)_" mm x "_$$xval("cect"_ii_"ssw",vals)_" mm)"
 . ;
 . s calcstr=calcstr_$$xval("cect"_ii_"sl",vals)_" mm x "_$$xval("cect"_ii_"sw",vals)_" mm "_scomp_", "
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
 . . . ;e  d out(nloc_" "_endo_" "_ii_" "_calcstr_" "_$$xsub("cectch",vals,dict,"cect"_ii_"ch")_".")
 . . i $$xval("cect"_ii_"inl",vals)=$$xval("cect"_ii_"inh",vals) d  ;
 . . . d out("image"_$$xval("cect"_ii_"inh",vals)_". ")
 . . . ;d out("image "_$$xval("cect"_ii_"inh",vals)_".")
 . . e  d  ;
 . . . d out("images "_$$xval("cect"_ii_"inl",vals)-$$xval("cect"_ii_"inh",vals)_".")
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
 ;
 ; etc etc
 ;
 d out("</TABLE>")
 d out("<p><br></p><p><b>References:</b><br></p>")
 d out("<p>Recommendations for nodules and other findings are detailed in the I-ELCAP Protocol.<BR>")
 d out("A summary and the full I-ELCAP protocol can be viewed at: <a href=""http://ielcap.org/protocols"">http://ielcap.org/protocols</a></p>")
 d out("</TD></TR></TABLE></TD></TR></TABLE>")
 d out("</BODY></HTML>")
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
 
