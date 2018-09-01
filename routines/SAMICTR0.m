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
 n nt,sectionheader,dummy,cac,tex,para,legout
 ;; n lang,lanread
 ;
 s nt=1
 s sectionheader=1
 ;;s dummy="******"
 s cac=""
 s cacrec=""
 ;;s tex=0
 s para="<p>"
 ;;s legout=0
 s qheader=0
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
 ; generate header
 ;
 d out("<TR><TD WIDTH=\""180\""><B>Patient Name:</B></TD><TD WIDTH=\""365\"">")
 d out($$xval("sinamel",vals)_", "_$$xval("sinamef",vals))
 d out("</TD>")
 ;
 d out("<TD WIDTH=\""120\""><B>Study ID:</B></TD><TD WIDTH=\""75\"">")
 d out($$xval("sisid",vals))
 d out("</TD>")
 ;
 d out("<TR><TD><B>Type of Examination:</B></TD><TD>")
 d out($$xsub("cetex",vals,dict)_" "_$$xsub("cectp",vals,dict))
 d out("</TD>")
 d out("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 d out("<TR><TD><B>Examination Date:</B></TD><TD>")
 d out($$xval("cedos",vals))
 ;
 i $$xval("sidob",vals)'=-1 d  ;
 . d out("<TD><B>Date of Birth:</B></TD><TD>")
 . d out($$xval("sidob",vals))
 e  d out("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 i $$xval("sidob",vals)>0 d  ;
 . d out("<TD><B>Date of Birth:</B></TD><TD>")
 . d out($$xval("sidob",vals))
 . d out("</TD></TR>")
 e  d  ;
 . d out("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 ;# End of Header
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
 ;
 ; see if there are any nodules using the cectXch fields
 ;
 n ij,hasnodules s hasnodules=0
 f ij=1:1:10 i ($$xval("cect"_ij_"ch",vals)'="")&($$xval("cect"_ij_"ch",vals)'="-") s hasnodules=1
 ;
 i hasnodules=0 d  ;
 . d out(para)
 . d out("No pulmonary nodules are seen."_para)
 ;
 ;i $$xval("cennod",vals)="" d  ;
 ;. d out(para)
 ;. d out("No pulmonary nodules are seen."_para)
 ;e  i $$xval("ceanod",vals)="n" d  ;
 ;. d out(para)
 ;. d out("No pulmonary nodules are seen."_para)
 ;
 d nodules^SAMICTR1(rtn,.vals,.dict)
 ;
 d otherlung^SAMICTR2(rtn,.vals,.dict)
 ;
 d heart^SAMICTR3(rtn,.vals,.dict)
 ;
 d neck^SAMICTR4(rtn,.vals,.dict)
 ;
 d breast^SAMICTR5(rtn,.vals,.dict)
 ;
 d pleural^SAMICTR6(rtn,.vals,.dict)
 ;
 d paricardial^SAMICTR7(rtn,.vals,.dict)
 ;
 d abdominal^SAMICTR8(rtn,.vals,.dict)
 ;
 d impression^SAMICTR9(rtn,.vals,.dict)
 ;
 d recommend^SAMICTRA(rtn,.vals,.dict)
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
getFilter(filter,sid) ; fill in the filter for Ct Eval for sid
 s filter("studyid")=sid
 n items,zform
 d getItems^SAMICAS2("items",sid)
 s zform=$o(items("ceform"))
 s filter("form")=zform
 zwr filter
 q
T1(grtn,debug) ; 
 n filter
 ;n sid s sid="XXX00333"
 n sid s sid="XXX00484"
 d getFilter(.filter,sid)
 i $g(debug)=1 s filter("debug")=1
 d wsReport^SAMICTR0(.grtn,.filter)
 q
 ;
