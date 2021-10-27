SAMICTT0 ;ven/gpl - ctreport text main ;2021-05-21T20:47Z
 ;;18.0;SAMI;**4,10,11**;2020-01;Build 2
 ;;1.18.0.11+i11
 ;
 ; SAMICTT0 contains a web route & associated subroutines to produce
 ; the ELCAP CT Report in text format (route ctreport, format text).
 ; SAMICTT* routines serve web service interfaces WSVAPALS^SAMIHOM3
 ; (the main VAPALS-ELCAP post web service) & WSHOME^SAMIHOM3 (the
 ; VAPALS-ELCAP home-page service).
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
 ; WSREPORT web route: ctreport in text format
 ; OUT output a line of ct report
 ; OUTOLD old version of out
 ; HOUT output a ct report header line
 ; $$XVAL patient value for var
 ; $$XSUB dictionary value defined by var
 ; GETFILTR fill in the filter for Ct Eval for sid
 ; T1 test
 ;
 ;
 ;
 ;@section 1 wsi WSREPORT & related subroutines
 ;
 ;
 ;
 ;@wsr WSREPORT^SAMICTT0
WSREPORT(return,filter) ; web route: ctreport in text format
 ;
 ;@called-by
 ; WSNOTE^SAMINOT3
 ;  (called-by wsi WSVAPALS^SAMIHOM3)
 ;    (called by wsi WSHOME^SAMIHOM3)
 ;  (sibling to wri WSREPORT^SAMICTR0, keep in sync)
 ;@calls
 ; INIT2GPH^SAMICTD2
 ; $$setroot^%wd
 ; $$XVAL
 ; OUT
 ; $$XSUB
 ; HOUT
 ; NODULES^SAMICTT1
 ; OTHRLUNG^SAMICTT2
 ; EMPHYS^SAMICTT3
 ; BREAST^SAMICTT4
 ; IMPRSN^SAMICTT9
 ; RCMND^SAMICTTA
 ;
 s debug=0
 n outmode s outmode="go"
 n line s line=""
 i $g(filter("debug"))=1 s debug=1
 ;
 ;s rtn=$na(^TMP("SAMICTT",$J))
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
 i $g(@dict@("pet"))="" d INIT2GPH^SAMICTD2 ; init dictionary 1st time
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
 ;s para="<p>"
 ;s para=$char(13,10)
 s para=""
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
 ;d OUT("<HTML>")
 ;d OUT("<HEAD>")
 ;d OUT("<!-- Calling TR: CT Evaluation Report -->")
 ;d OUT("<TITLE>CT Evaluation Report</TITLE>")
 ;d OUT("<link rel='stylesheet' href='/css/report.css'>")
 ;d OUT("</HEAD>")
 ;d OUT("<BODY BGCOLOR=""#ffffff"" TEXT=""#000000"">")
 ;;d OUT("<TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640""><TR><TD>")
 ;d OUT("<FONT SIZE=""+2""><CENTER>")
 ;d OUT("<!-- Calling TR: CT Evaluation Report -->")
 ;d OUT("<B>CT Evaluation Report</B>")
 d OUT("CT Evaluation Report")
 ;d OUT("</CENTER></FONT>")
 ;d OUT("</TD></TR><TR><TD>")
 ;d OUT("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 ;d OUT("</TD></TR>")
 ;
 ;d OUT("<!-- patient information -->")
 ;d OUT("<TR><TD><TABLE border=""0"" cellspacing=""0"" cellpadding=""3"" WIDTH=""640"">")
 ;
 ; generate header
 ;
 d  ;
 . n pname
 . ;s pname=$$XVAL("sinamel",vals)_", "_$$XVAL("sinamef",vals)
 . s pname=$$XVAL("saminame",vals)
 . d OUT("Participant Name: "_pname)
 ;d OUT("<TR><TD WIDTH=""180""><B>Participant Name:</B></TD><TD WIDTH=""365"">")
 ;d OUT($$XVAL("sinamel",vals)_", "_$$XVAL("sinamef",vals))
 ;d OUT("</TD>")
 ;
 d  ;
 . n sid s sid=$$XVAL("sisid",vals)
 . d OUT("Study ID: "_sid)
 ;d OUT("<TD WIDTH=""120""><B>Study ID:</B></TD><TD WIDTH=""75"">")
 ;d OUT($$XVAL("sisid",vals))
 ;d OUT("</TD>")
 ;
 n etype
 s etype=""
 d  ;
 . s etype=$$XSUB("cetex",vals,dict)_" "_$$XSUB("cectp",vals,dict)
 . d OUT("Type of Examination: "_etype)
 ;d OUT("<TR><TD><B>Type of Examination:</B></TD><TD>")
 ;d OUT($$XSUB("cetex",vals,dict)_" "_$$XSUB("cectp",vals,dict))
 ;d OUT("</TD>")
 ;d OUT("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 d  ;
 . n edate s edate=$$XVAL("cedos",vals)
 . d OUT("Examination Date: "_edate)
 ;d OUT("<TR><TD><B>Examination Date:</B></TD><TD>")
 ;d OUT($$XVAL("cedos",vals))
 ;
 ;i $$XVAL("sidob",vals)'=-1 d  ;
 ;. d OUT("<TD><B>Date of Birth:</B></TD><TD>")
 ;. d OUT($$XVAL("sidob",vals))
 ;e  d OUT("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 d  ;
 . n dob s dob=$$XVAL("sidob",vals)
 . i dob>0 d OUT("Date of Birth: "_dob)
 . d OUT("")
 ;i $$XVAL("sidob",vals)>0 d  ;
 ;. d OUT("<TD><B>Date of Birth:</B></TD><TD>")
 ;. d OUT($$XVAL("sidob",vals))
 ;. d OUT("</TD></TR>")
 ;e  d  ;
 ;. d OUT("<TD> &nbsp; </TD><TD> &nbsp; </TD></TR>")
 ;
 ;# End of Header
 ;
 ;d OUT("</TABLE>")
 ;;d OUT("</TD></TR><TR><TD>")
 ;d OUT("<HR SIZE=""2"" WIDTH=""100%"" ALIGN=""center"" NOSHADE>")
 ;d OUT("</TD></TR>")
 ;d OUT("<!-- report -->")
 ;d OUT("<TR><TD>")
 ;d OUT("<FONT SIZE=""+2""><B>")
 ;d OUT("Report:")
 ;d OUT("</B></FONT>")
 ;d OUT("</TD></TR><TR><TD><TABLE><TR><TD WIDTH=20></TD><TD>")
 d OUT("Report:")
 ;
 s outmode="hold"
 s line=""
 i $$XVAL("ceclin",vals)'="" d  ;
 . d HOUT("Clinical Information: ")
 . d OUT($$XVAL("ceclin",vals))
 . s outmode="go" d OUT("")
 ;
 s outmode="hold"
 n nopri s nopri=1
 d HOUT("Comparison CT Scans: ")
 if $$XVAL("cedcs",vals)'="" d  ;
 . ;i etype["Baseline" q  ;
 . d OUT($$XSUB("cetex",vals,dict)_". ")
 . ;d OUT("Comparisons: "_$$XVAL("cedcs",vals))
 . d OUT("Comparisons: ")
 . s nopri=0
 if $$XVAL("cedps",vals)'="" d  ;
 . ;i etype["Baseline" q  ;
 . d OUT(" "_$$XVAL("cedps",vals))
 . s nopri=0
 d:nopri OUT("None")
 s outmode="go" d OUT("")
 ;
 s outmode="hold"
 d HOUT("Description: ")
 i $$XVAL("cectp",vals)="i" d  ;
 . d OUT("Limited Diagnostic CT examination was performed. ")
 e  d  ;
 . d OUT("CT examination of the entire thorax was performed at "_$$XSUB("cectp",vals,dict)_" settings. ")
 ;
 i $$XVAL("cectrst",vals)'="" d  ;
 . d OUT(" Images were obtained at "_$$XVAL("cectrst",vals)_" mm slice thickness. ")
 . d OUT(" Multiplanar reconstructions were performed. ")
 ;
 i newct d  ;
 . n nvadbo s nvadbo=1
 . n ii
 . f ii="ceoaa","ceaga","ceasa","ceala","ceapa","ceaaa","ceaka" d  ;
 . . i $$XVAL(ii,vals)="y" set nvadbo=0
 . ;
 . i nvadbo=1 d  ;
 . . d OUT("Upper abdominal images were not acquired on the current scan due to its limited nature. ")
 s outmode="go" d OUT("")
 ;
 ; lung nodules
 ;
 ;d OUT("")
 d HOUT("Lung Nodules:")
 ;d OUT("")
 ;
 ; see if there are any nodules using the cectXch fields
 ;
 n ij,hasnodules s hasnodules=0
 f ij=1:1:10 i ($$XVAL("cect"_ij_"ch",vals)'="")&($$XVAL("cect"_ij_"ch",vals)'="-") s hasnodules=1
 ;
 ; check for small nodule checkboxes
 i $$XVAL("cectancn",vals)=1 s hasnodules=1
 i $$XVAL("cectacn",vals)=1 s hasnodules=1
 ;
 i hasnodules=0 d  ;
 . d OUT(para)
 . d OUT("No pulmonary nodules are seen. "_para)
 ;
 ;i $$XVAL("cennod",vals)="" d  ;
 ;. d OUT(para)
 ;. d OUT("No pulmonary nodules are seen. "_para)
 ;e  i $$XVAL("ceanod",vals)="n" d  ;
 ;. d OUT(para)
 ;. d OUT("No pulmonary nodules are seen. "_para)
 ;
 d NODULES^SAMICTT1(rtn,.vals,.dict)
 ;
 d OTHRLUNG^SAMICTT2(rtn,.vals,.dict)
 ;
 d EMPHYS^SAMICTT3(rtn,.vals,.dict)
 ;
 d BREAST^SAMICTT4(rtn,.vals,.dict)
 ;
 d IMPRSN^SAMICTT9(rtn,.vals,.dict)
 ;
 d RCMND^SAMICTTA(rtn,.vals,.dict)
 ;
 ; etc etc
 ;
 d  ;
 . d OUT("References:")
 . d OUT("Recommendations for nodules and other findings are detailed in the I-ELCAP Protocol. ")
 . d OUT("A summary and the full I-ELCAP protocol can be viewed at: http://ielcap.org/protocols")
 ;d OUT("</TABLE>")
 ;d OUT("<p><br></p><p><b>References:</b><br></p>")
 ;d OUT("<p>Recommendations for nodules and other findings are detailed in the I-ELCAP Protocol.<BR>")
 ;d OUT("A summary and the full I-ELCAP protocol can be viewed at: <a href=""http://ielcap.org/protocols"">http://ielcap.org/protocols</a></p>")
 ;d OUT("</TD></TR></TABLE></TD></TR></TABLE>")
 ;s debug=1
 d:$g(debug)  ;
 . n zi s zi=""
 . f  s zi=$o(@vals@(zi)) q:zi=""  d  ;
 . . d OUT(zi_" "_$g(@vals@(zi)))
 ;d OUT("</BODY></HTML>")
 ;
 quit  ; end of wsr WSREPORT^SAMICTT0
 ;
 ;
 ;
OUT(ln) ; output a line of ct report
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
 ;
 quit  ; end of OUTOLD
 ;
 ;
 ;
HOUT(ln) ; output a ct report header line
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
 ;@input
 ; @vals is passed by name
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
 ; vals and dict are passed by name
 ; valdx is used for nodules ala cect2co with the nodule number included
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
GETFILTR(filter,sid) ; fill in the filter for Ct Eval for sid
 ;
 s filter("studyid")=sid
 n items,zform
 d GETITEMS^SAMICASE("items",sid)
 s zform=$o(items("ceform"))
 s filter("form")=zform
 ;zwr filter
 ;
 quit  ; end of GETFILTR
 ;
 ;
 ;
T1(grtn,debug) ; test
 ;
 n filter
 ;n sid s sid="XXX00333"
 ;n sid s sid="XXX00484"
 n sid s sid="XXX9000001"
 d GETFILTR(.filter,sid)
 i $g(debug)=1 s filter("debug")=1
 d WSNOTE^SAMINOT3(.grtn,.filter)
 ;d WSREPORT^SAMICTT0(.grtn,.filter)
 ;
 quit  ; end of T1
 ;
 ;
 ;
EOR ; end of routine SAMICTT0
