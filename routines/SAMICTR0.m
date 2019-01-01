SAMICTR0 ;ven/gpl - ielcap: forms ; 12/28/18 12:37pm
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
WSREPORT(return,filter) ; web service which returns an html cteval report
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
 i $g(@dict@("pet"))="" d INIT2GPH^SAMICTD2 ; initialize the dictionary first time
 n si
 s si=$g(filter("studyid"))
 i si="" d  ;
 . s si="XXX00102"
 q:si=""
 n samikey
 s samikey=$g(filter("form"))
 i samikey="" d  ;
 . s samikey="ceform-2018-10-09"
 n root s root=$$setroot^%wd("vapals-patients")
 i $g(filter("studyid"))="" s root=$$setroot^%wd("vapals-patients")
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
 n cacrec s cacrec=""
 ;;s tex=0
 s para="<p>"
 ;;s legout=0
 n qheader s qheader=0
 ;
 n lang s lang=""
 n langread s langread=0
 ;
 n auth s auth("perm")="a"
 s auth("inst")=$g(filter("auth"))
 ;
 n newct s newct=0
 i $$XVAL("ceoppa",vals)'="" s newct=1
 ;
 n registryForm s registryForm=0
 i $$XVAL("ceaf",vals)'="" s registryForm=1
 ;
 d OUT("<HTML>")
 d OUT("<HEAD>")
 d OUT("<!-- Calling TR: CT Evaluation Report -->")
 d OUT("<TITLE>CT Evaluation Report</TITLE>")
 d OUT("<link rel='stylesheet' href='/css/report.css'>")
 d OUT("</HEAD>")
 d OUT("<BODY BGCOLOR=""#ffffff"" TEXT=""#000000"">")
 ;d OUT("<TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640""><TR><TD>")
 d OUT("<FONT SIZE=""+2""><CENTER>")
 d OUT("<!-- Calling TR: CT Evaluation Report -->")
 d OUT("<B>CT Evaluation Report</B>")
 d OUT("</CENTER></FONT>")
 d OUT("</TD></TR><TR><TD>")
 d OUT("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 d OUT("</TD></TR>")
 ;
 d OUT("<!-- patient information -->")
 d OUT("<TR><TD><TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640"">")
 ;
 ; generate header
 ;
 d OUT("<TR><TD WIDTH=""180""><B>Patient Name:</B></TD><TD WIDTH=""365"">")
 d OUT($$XVAL("sinamel",vals)_", "_$$XVAL("sinamef",vals))
 d OUT("</TD>")
 ;
 d OUT("<TD WIDTH=""120""><B>Study ID:</B></TD><TD WIDTH=""75"">")
 d OUT($$XVAL("sisid",vals))
 d OUT("</TD>")
 ;
 d OUT("<TR><TD><B>Type of Examination:</B></TD><TD>")
 d OUT($$XSUB("cetex",vals,dict)_" "_$$XSUB("cectp",vals,dict))
 d OUT("</TD>")
 d OUT("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 d OUT("<TR><TD><B>Examination Date:</B></TD><TD>")
 d OUT($$XVAL("cedos",vals))
 ;
 ;i $$XVAL("sidob",vals)'=-1 d  ;
 ;. d OUT("<TD><B>Date of Birth:</B></TD><TD>")
 ;. d OUT($$XVAL("sidob",vals))
 ;e  d OUT("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 i $$XVAL("sidob",vals)>0 d  ;
 . d OUT("<TD><B>Date of Birth:</B></TD><TD>")
 . d OUT($$XVAL("sidob",vals))
 . d OUT("</TD></TR>")
 e  d  ;
 . d OUT("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 ;# End of Header
 ;
 d OUT("</TABLE>")
 ;d OUT("</TD></TR><TR><TD>")
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
 ;
 ; see if there are any nodules using the cectXch fields
 ;
 n ij,hasnodules s hasnodules=0
 f ij=1:1:10 i ($$XVAL("cect"_ij_"ch",vals)'="")&($$XVAL("cect"_ij_"ch",vals)'="-") s hasnodules=1
 ;
 i hasnodules=0 d  ;
 . d OUT(para)
 . d OUT("No pulmonary nodules are seen."_para)
 ;
 ;i $$XVAL("cennod",vals)="" d  ;
 ;. d OUT(para)
 ;. d OUT("No pulmonary nodules are seen."_para)
 ;e  i $$XVAL("ceanod",vals)="n" d  ;
 ;. d OUT(para)
 ;. d OUT("No pulmonary nodules are seen."_para)
 ;
 d NODULES^SAMICTR1(rtn,.vals,.dict)
 ;
 d OTHRLUNG^SAMICTR2(rtn,.vals,.dict)
 ;
 d IMPRSN^SAMICTR9(rtn,.vals,.dict)
 ;
 d RCMND^SAMICTRA(rtn,.vals,.dict)
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
GETFILTR(filter,sid) ; fill in the filter for Ct Eval for sid
 s filter("studyid")=sid
 n items,zform
 d GETITEMS^SAMICAS2("items",sid)
 s zform=$o(items("ceform"))
 s filter("form")=zform
 ;zwr filter
 q
T1(grtn,debug) ; 
 n filter
 ;n sid s sid="XXX00333"
 n sid s sid="XXX00484"
 d GETFILTR(.filter,sid)
 i $g(debug)=1 s filter("debug")=1
 d WSREPORT^SAMICTR0(.grtn,.filter)
 q
 ;
