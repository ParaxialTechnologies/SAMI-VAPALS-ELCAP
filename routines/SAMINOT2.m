SAMINOT2 ;ven/gpl - followup form notes ;2021-07-01t17:21z
 ;;18.0;SAMI;**1,9,12**;2020-01;
 ;;1.18.0.12-t3+i12
 ;
 ; SAMINOT2 contains web services & other subroutines for producing
 ; the ELCAP Followup Form Notes.
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
 ;@documentation see SAMINUL
 ;@contents
 ; WSNOTE web service to return text note
 ; $$NOTE create note
 ; $$HASINNT is intake note present?
 ; $$HASVCNT is communication note present?
 ; $$HASLCSNT is lung cancer screening note present?
 ; MKVC make communication note
 ; MKLCS make lung cancer screening note
 ; $$MKNT make note w/date=now
 ; $$MKNTLOC make note
 ; $$NTDTTM convert date/time fr/fm to/note format
 ; $$NTLOCN location of nth note
 ; $$NTLAST location of latest note of a type
 ; NTLIST return note list
 ; TLST test NTLIST
 ; VCNOTE veteran communication note
 ; SSTATUS smoking status
 ; LCSNOTE lung cancer screening note
 ; OUT output new line to note
 ; $$XVAL value of form variable
 ; $$PREVCT key to previous ct eval form
 ; CTINFO extracts from latest ct eval form
 ; IMPRESS impressions from ct eval report
 ; $$XSUB dictionary value for variable
 ;
 ;
 ;
 ;@section 1 wsi WSNOTE & related subroutines
 ;
 ;
 ;
 ;@wsi WSNOTE^SAMINOT2, vapals-elcap followup note
WSNOTE(return,filter) ; web service to return text note
 ;
 ;ven/gpl;web service;procedure;
 ;
 n debug s debug=0
 i $g(filter("debug"))=1 s debug=1
 ;
 k return
 s HTTPRSP("mime")="text/html"
 ;
 n si
 s si=$g(filter("studyid"))
 i si="" d  ;
 . s si="XXX00333"
 q:si=""
 ;
 n samikey
 s samikey=$g(filter("form"))
 n root s root=$$setroot^%wd("vapals-patients")
 i samikey="" d  ;
 . s samikey=$o(@root@("graph",si,"siform"))
 . ;w !,samikey
 . ;b
 ;
 n vals
 m vals=@root@("graph",si,samikey)
 ;
 n note,nien,ntype
 s ntype=""
 s note=""
 s nien=$g(filter("nien"))
 i nien="" d
 . s:$g(vals("samistatus"))="complete" ntype="intake"
 . s:$g(vals("samistatus"))="chart-eligibility" ntype="eligibility"
 . s:$g(vals("samistatus"))="pre-enrollment-discussion" ntype="pre-note"
 . q:ntype=""
 . ;d nien=$$NTTYPE add code to pull the latest note by type
 q:nien=""
 n notebase
 s notebase=$$NTLOCN(si,samikey,nien) ; global location for the note
 s note=$na(@notebase@("text"))
 i '$d(@note) q
 ;
 new temp,tout
 do GETTMPL^SAMICASE("temp","vapals:note")
 quit:'$data(temp)
 ;
 n cnt s cnt=0
 n zi s zi=""
 ;
 f  s zi=$o(temp(zi)) q:zi=""  d  ;
 . ;
 . n line s line=temp(zi)
 . D LOAD^SAMIFORM(.line,samikey,si,.filter,.vals)
 . s temp(zi)=line
 . ;
 . s cnt=cnt+1
 . s tout(cnt)=temp(zi)
 . ;
 . i temp(zi)["report-text" d  ;
 . . i temp(zi)["#" q  ;
 . . n zj s zj=""
 . . f  s zj=$o(@note@(zj)) q:zj=""  d  ;
 . . . s cnt=cnt+1
 . . . ;s tout(cnt)=@note@(zj)_"<br>"
 . . . s tout(cnt)=@note@(zj)_$char(13,10)
 m return=tout
 ;
 quit  ; end of wsi WSNOTE^SAMINOT2
 ;
 ;
 ;
NOTE(filter) ; extrnisic to create note
 ;
 ;ven/gpl;private;function;
 ;@output = 1 if successful, 0 if not
 ;
 k ^gpl("funote")
 m ^gpl("funote")=filter
 ;q 0  ; while we are developing
 ;
 ; set up patient values
 ;
 n vals
 ;
 n si
 s si=$g(filter("studyid"))
 q:si="" 0
 ;
 n samikey
 s samikey=$g(filter("form"))
 q:samikey="" 0
 n root s root=$$setroot^%wd("vapals-patients")
 ;
 s vals=$na(@root@("graph",si,samikey))
 ;
 i '$d(@vals) d  q 0 ;
 . ;w !,"error, patient values not found"
 ;zwr @vals@(*)
 ;
 k ^SAMIUL("NOTE")
 m ^SAMIUL("NOTE","vals")=@vals
 m ^SAMIUL("NOTE","filter")=filter
 ;
 n didnote s didnote=0
 ;
 i $d(@vals@("notes")) d  q didnote ;
 . s filter("errorMessage")="Note already exists for this form."
 ;
 i $g(@vals@("futype"))="other" d  ;
 . i $g(@vals@("samistatus"))'="complete" q  ;
 . ;q:$$HASVCNT(vals)
 . d MKVC(si,samikey,vals,.filter) ;
 . s didnote=1
 ;
 i $g(@vals@("futype"))="ct" d  ;
 . i $g(@vals@("samistatus"))'="complete" q  ;
 . ;q:$$HASLCSNT(vals)
 . n ctdt,ctkey
 . s ctdt=$$LASTCMP^SAMICAS3(si,.ctkey)
 . i ctdt=-1 d  q  ;
 . . s filter("errorMessage")="No CT Eval form exists, followup note not created."
 . d MKLCS(si,samikey,vals,.filter) ;
 . s didnote=1
 ;
 ;i $g(@vals@("samistatus"))="complete" d  ;
 ;. q:$$HASVCNT(vals)
 ;. d MKVC(si,samikey,vals,.filter) ;
 ;. s didnote=1
 ;
 quit didnote ; end of $$NOTE
 ;
 ;
 ;
HASINNT(vals) ; is intake note present?
 ;
 ;ven/gpl;private;function;
 ;@output = 1 if intake note is present, 0 if not
 ;
 n zzi,zzrtn s (zzi,zzrtn)=0
 q:'$d(@vals)
 f  s zzi=$o(@vals@("notes",zzi)) q:+zzi=0  d  ;
 . i $g(@vals@("notes",zzi,"name"))["Intake" s zzrtn=1
 ;
 quit zzrtn ; end of $$HASINNT
 ;
 ;
 ;
HASVCNT(vals) ; is communication note present?
 ;
 ;ven/gpl;private;function;
 ;@output = 1 if communication note is present, 0 if not
 ;
 n zzi,zzrtn s (zzi,zzrtn)=0
 q:'$d(@vals)
 f  s zzi=$o(@vals@("notes",zzi)) q:+zzi=0  d  ;
 . i $g(@vals@("notes",zzi,"name"))["Communication" s zzrtn=1
 ;
 quit zzrtn ; end of $$HASVCNT
 ;
 ;
 ;
HASLCSNT(vals) ; is lung cancer screening note present?
 ;
 ;ven/gpl;private;function;
 ;@output = 1 if communication note is present, 0 if not
 ;
 n zzi,zzrtn s (zzi,zzrtn)=0
 q:'$d(@vals)
 f  s zzi=$o(@vals@("notes",zzi)) q:+zzi=0  d  ;
 . i $g(@vals@("notes",zzi,"name"))["Lung" s zzrtn=1
 ;
 quit zzrtn ; end of $$HASLCSNT
 ;
 ;
 ;
MKVC(sid,form,vals,filter) ; make communication note
 ;
 ;ven/gpl;private;procedure;
 ;
 n cnt s cnt=0
 ;n dest s dest=$na(@vals@("communication-note"))
 n dest s dest=$$MKNT(vals,"Communication Note","communication",.filter)
 k @dest
 d OUT("Veteran Communication Note")
 d OUT("")
 d VCNOTE(vals,dest,cnt)
 ;
 quit  ; end of MKVC
 ;
 ;
 ;
MKLCS(sid,form,vals,filter) ; make lung cancer screening note
 ;
 ;ven/gpl;private;procedure;
 ;
 n cnt s cnt=0
 ;n dest s dest=$na(@vals@("lcs-note"))
 n dest s dest=$$MKNT(vals,"Lung Cancer Screening Note","lcs",.filter)
 k @dest
 d OUT("Lung Screening and Surveillance Follow up Note")
 d OUT("")
 d LCSNOTE(vals,dest,cnt)
 ;
 quit  ; end of MKLCS
 ;
 ;
 ;
MKNT(vals,title,ntype,filter) ; make note w/date=now
 ;
 ;ven/gpl;private;pseudo-function;
 ;@input
 ; .filter (passed by reference)
 ;@output = global address
 ;
 n ntdt s ntdt=$$NTDTTM($$NOW^XLFDT)
 n ntptr
 s ntptr=$$MKNTLOC(vals,title,ntdt,$g(ntype),.filter)
 ;
 quit ntptr ; end of $$MKNT
 ;
 ;
 ;
MKNTLOC(vals,title,ndate,ntype,filter) ; make note
 ;
 ;ven/gpl;private;pseudo-function;
 ;@output = note location (global address)
 ;
 n nien
 s nien=$o(@vals@("notes",""),-1)+1
 s filter("nien")=nien
 n nloc s nloc=$na(@vals@("notes",nien))
 s @nloc@("name")=title_" "_$g(ndate)
 s @nloc@("date")=$g(ndate)
 s @nloc@("type")=$g(ntype)
 ;
 quit $na(@nloc@("text"))
 ;
 ;
 ;
NTDTTM(ZFMDT) ; convert date/time fr/fm to/note format
 ;
 ;ven/gpl;private;function;
 ;@input
 ; ZFMDT = fileman date/time to translate
 ;@output = date/time in note format
 ;
 quit $$FMTE^XLFDT(ZFMDT,"5") ; end of $$NTDTTM
 ;
 ;
 ;
NTLOCN(sid,form,nien) ; location of nth note
 ;
 ;ven/gpl;private;function;
 ;@output = global location of Nth note
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 ;
 quit $na(@root@("graph",sid,form,"notes",nien)) ; end of $$NTLOCN
 ;
 ;
 ;
NTLAST(sid,form,ntype) ; location of latest note of a type
 ;
 ;ven/gpl;private;function;
 ;@input
 ; ntype = type of note
 ;@output = global location of latest note of type ntype
 ;
 ; not yet written
 ;
 quit  ; end of $$NTLAST
 ;
 ;
 ;
NTLIST(nlist,sid,form) ; return note list
 ;
 ;ven/gpl;private;procedure;
 ;@output
 ; .nlist = note list [pass by reference]
 ;
 n zn,root,gn
 s root=$$setroot^%wd("vapals-patients")
 s zn=0
 s gn=$na(@root@("graph",sid,form,"notes"))
 q:'$d(@gn)
 f  s zn=$o(@gn@(zn)) q:+zn=0  d  ;
 . s @nlist@(zn,"name")=@gn@(zn,"name")
 . s @nlist@(zn,"nien")=zn
 ;
 quit  ; end of NTLIST
 ;
 ;
 ;
TLST ; test NTLIST
 ;
 ;ven/gpl;test;procedure;
 ;
 set SID="XXX00677"
 set FORM="siform-2019-04-23"
 do NTLIST("G",SID,FORM)
 ;
 ; zwrite G
 ;
 quit  ; end of TLST
 ;
 ;
 ;
VCNOTE(vals,dest,cnt) ; veteran communication note
 ;
 ;ven/gpl;private;procedure;
 ;
 ; do OUT("")
 ;
 d OUT("Veteran was contacted via:")
 n sp1 s sp1="    "
 d:$$XVAL("fucmotip",vals) OUT(sp1_"In person")
 d:$$XVAL("fucmotte",vals) OUT(sp1_"Telephone")
 d:$$XVAL("fucmotth",vals) OUT(sp1_"TeleHealth")
 d:$$XVAL("fucmotml",vals) OUT(sp1_"Mailed Letter")
 d:$$XVAL("fucmotpp",vals) OUT(sp1_"Message in patient portal")
 d:$$XVAL("fucmotvd",vals) OUT(sp1_"Video-on-demand (VOD)")
 d:$$XVAL("fucmotot",vals) OUT(sp1_"Other: "_$$XVAL("fucmotoo",vals))
 d OUT("")
 ;
 d:$$XVAL("fucmotde",vals)'=""
 . d OUT("Communication details:")
 . d OUT(sp1_$$XVAL("fucmotde",vals))
 ;
 d SSTATUS(vals) ; insert smoking status section
 ;
 quit  ; end of VCNOTE
 ;
 ;
 ;
SSTATUS(vals) ; smoking status
 ;
 ;ven/gpl;private;procedure;
 ;
 n sstat s sstat=""
 i $$XVAL("sisa",vals)="y" d  ; 
 . s sstat="Current"
 . d OUT("Smoking status: "_sstat)
 . d OUT(sp1_"Current cigarette smoker (patient advised that active tobacco use")
 . d OUT(sp1_"increases risk of future lung cancer, heart disease and stroke,")
 . d OUT(sp1_"advised stability now does not guarantee will not develop future")
 . d OUT(sp1_"lung cancer or risks of premature death from tobacco related heart")
 . d OUT(sp1_"disease and stroke)")
 i $$XVAL("sisa",vals)="n" d  ;
 . s sstat="Former"
 . d OUT("Smoking status: "_sstat)
 . n qdate s qdate=""
 . s qdate=$$XVAL("siq",vals)
 . i qdate'="" d OUT(sp1_"Former cigarette smoker. Quit date: "_qdate)
 . e  d OUT(sp1_"Former cigarette smoker.")
 i $$XVAL("sisa",vals)="o" d  ;
 . s sstat="Never"
 . d OUT("Smoking status: "_sstat)
 . d OUT(sp1_"Never cigarette smoker")
 ;
 n cumary
 d CUMPY^SAMIUR2("cumary",sid,form)
 k ^gpl("funote","cumary")
 m ^gpl("funote","cumary")=cumary
 n cur s cur=$g(cumary("current"))
 n newcum s newcum=$g(cumary("rpt",cur,4)) ; new cumulative pack years
 ;
 i $$XVAL("sisa",vals)="y" d  ;  
 . d OUT("Smoking history (since last visit):")
 . d OUT(sp1_"Cigarettes/day: "_$$XVAL("sicpd",vals))
 . d OUT(sp1_"PPD: "_$$XVAL("sippd",vals))
 . d OUT(sp1_"Current cumulative pack years: "_newcum)
 i $$XVAL("sisa",vals)'="y" d  ;  
 . d OUT("Smoking History")
 n zi
 f zi=1:1:cur d  ;
 . d OUT(sp1_cumary("rpt",zi,1)_" "_cumary("rpt",zi,2))
 . d OUT(sp1_sp1_"Pack Years: "_cumary("rpt",zi,3))
 . d OUT(sp1_sp1_"Cumulative: "_cumary("rpt",zi,4))
 ;
 n tried s tried=$$XVAL("sittq",vals)
 n ptried s ptried=$s(tried="y":"Yes",tried="n":"No",tried="o":"Not applicable",1:"")
 i ptried'="" d OUT("Since your prior CT scan have you ever tried to quit smoking? "_ptried)
 ;
 n tryary,cnt
 s cnt=0
 i $$XVAL("sisca",vals)'="" s cnt=cnt+1 s tryary(cnt)="Have not tried to quit"
 i $$XVAL("siscb",vals)'="" s cnt=cnt+1 s tryary(cnt)="""Cold Turkey"" by completely stopping on your own with no other assistance"
 i $$XVAL("siscc",vals)'="" s cnt=cnt+1 s tryary(cnt)="Tapering or reducing number of cigarettes smoked per day"
 i $$XVAL("siscd",vals)'="" s cnt=cnt+1 s tryary(cnt)="Self-help material (e.g., brochure, cessation website)"
 i $$XVAL("sisce",vals)'="" s cnt=cnt+1 s tryary(cnt)="Individual consultation or cessation counseling"
 i $$XVAL("siscf",vals)'="" s cnt=cnt+1 s tryary(cnt)="Telephone cessation counseling hotline (e.g., 1-855-QUIT-VET, 1-800-QUIT-NOW)"
 i $$XVAL("siscg",vals)'="" s cnt=cnt+1 s tryary(cnt)="Peer support (e.g., Nicotine Anonymous)"
 i $$XVAL("sisch",vals)'="" s cnt=cnt+1 s tryary(cnt)="Nicotine replacement therapy (e.g., patch, gum, inhaler, nasal spray, lozenge)"
 i $$XVAL("sisci",vals)'="" s cnt=cnt+1 s tryary(cnt)="Zyban"
 i $$XVAL("siscj",vals)'="" s cnt=cnt+1 s tryary(cnt)="Hypnosis"
 i $$XVAL("sisck",vals)'="" s cnt=cnt+1 s tryary(cnt)="Acupuncture / acupressure"
 n tryot s tryot=""
 i $$XVAL("siscl",vals)'="" d  ;
 . s cnt=cnt+1 s tryary(cnt)="Other (specify)"
 . s tryot=$$XVAL("siscos",vals)
 ;
 i cnt>0 d  ;
 .  i ptried="" d OUT("Since your prior CT scan have you ever tried to quit smoking? ")
 . n zi s zi=""
 . f  s zi=$o(tryary(zi)) q:zi=""  d  ;
 . . d OUT(sp1_tryary(zi))
 . i tryot'="" d OUT(sp1_sp1_tryot)
 ;
 n cess,cess2 s cess="" s cess2=""
 i $$XVAL("siscmd",vals)="d" s cess="Declined"
 i $$XVAL("siscmd",vals)="a" s cess="Advised to quit smoking; VA resources provided"
 i $$XVAL("siscmd",vals)="i" d  ;
 . s cess="Interested in VA tobacco cessation medication. Encouraged Veteran"
 . s cess2="to talk to provider or pharmacist about which medication option is best for you."
 i cess'="" d  ;
 . d OUT("Tobacco cessation provided:")
 . d OUT(sp1_cess)
 . i cess2'="" d OUT(sp1_cess2)
 ;
 quit  ; end of SSTATUS
 ;
 ;
 ;
LCSNOTE(vals,dest,cnt) ; lung cancer screening note
 ;
 ;ven/gpl;private;procedure;
 ;
 ; do OUT("")
 ;
 n sp1 s sp1="    "
 d OUT("Initial LDCT/Baseline: "_$$XVAL("sidoe",vals))
 d OUT("Date of most recent CT/LDCT: "_$$XVAL("fulctdt",vals))
 d OUT(sp1_"Notification of Results: "_$$XVAL("sidof",vals))
 n addcmt s addcmt=$$XVAL("fucmctde",vals)
 i addcmt'="" d  ;
 . d OUT("Additional comments:")
 . d OUT(sp1_addcmt)
 n impress s impress=""
 n ctary
 d CTINFO("ctary",sid,form)
 s impress=$g(ctary("impression"))
 ; get impression from lastest CT Eval here
 d IMPRESS("ctary",sid)
 ;i impress'="" d  ;
 ;. d OUT("Impression:")
 ;. d OUT(sp1_impress)
 ; smoking status follows
 d SSTATUS(vals)
 ;d OUT("Veteran was contacted via:")
 ;n sp1 s sp1="    "
 ;d:$$XVAL("fucmctip",vals) OUT(sp1_"In person")
 ;d:$$XVAL("fucmctte",vals) OUT(sp1_"Telephone")
 ;d:$$XVAL("fucmctth",vals) OUT(sp1_"TeleHealth")
 ;d:$$XVAL("fucmctml",vals) OUT(sp1_"Mailed Letter")
 ;d:$$XVAL("fucmctpp",vals) OUT(sp1_"Message in patient portal")
 ;d:$$XVAL("fucmctvd",vals) OUT(sp1_"Video-on-demand (VOD)")
 ;d:$$XVAL("fucmctot",vals) OUT(sp1_"Other: "_$$XVAL("fucmctoo",vals))
 ;d OUT("")
 ;
 ;d:$$XVAL("fucmctde",vals)'=""
 ;. d OUT("Communication details:")
 ;. d OUT(sp1_$$XVAL("fucmctde",vals))
 n recom s recom=""
 ; get recommendations from CT eval form here
 s recom=$g(ctary("followup"))
 i recom'="" d  ;
 . d OUT("Recommendations:")
 . d OUT(sp1_recom)
 . i $g(ctary("followup2"))'="" d  ;
 . . d OUT(sp1_ctary("followup2"))
 . i $g(ctary("followup3"))'="" d  ;
 . . d OUT(sp1_ctary("followup3"))
 n ordered s ordered=$$XVAL("funewct",vals)
 i ordered'="" d  ;
 . s ordered=$s(ordered="y":"Yes",ordered="n":"No",1:"")
 . d OUT("CT/LDCT ordered: "_ordered)
 n pulmon s pulmon=$$XVAL("fucompul",vals)
 i pulmon'="" d  ;
 . s pulmon=$s(pulmon="y":"Yes",pulmon="n":"No",1:"")
 . d OUT("Communicated to Pulmonary: "_pulmon)
 ;
 quit  ; end of LCSNOTE
 ;
 ;
TOUT(sid) ;
 s root=$$setroot^%wd("vapals-patients")
 s groot=$na(@root@("graph",sid))
 s g=""
 f  s g=$o(@groot@(g)) q:g=""  d  ;
 . w !,g
 quit
 ;
OUT(ln) ; output new line to note
 ;
 ;ven/gpl;private;procedure;
 ;
 i $$CRWRAP^SAMITTW(ln,dest,.cnt,80) q  ;
 ;
 s cnt=cnt+1
 n lnn
 ;s debug=1
 s lnn=$o(@dest@(" "),-1)+1
 s @dest@(lnn)=ln
 ;
 ;i $g(debug)=1 d  ;
 ;. i ln["<" q  ; no markup
 ;. n zs s zs=$STACK
 ;. n zp s zp=$STACK(zs-2,"PLACE")
 ;. s @dest@(lnn)=zp_":"_ln
 ;
 quit  ; end of OUT
 ;
 ;
 ;
XVAL(var,vals) ; value of form variable
 ;
 ;ven/gpl;private;function;
 ;@input
 ; var = name of form variable
 ; vals = global root of form variable array
 ; @vals = form variable array [pass by name]
 ;@output = value of form variable
 ;
 new zr
 set zr=$get(@vals@(var))
 ;
 ; i zr="" s zr="["_var_"]"
 ;
 quit zr ; end of $$XVAL
 ;
 ;
 ;
PREVCT(SID,FORM) ; key to previous ct eval form
 ;
 ;ven/gpl;private;function;
 ;@input
 ; FORM = [not yet implemented, always treated as if FORM=""]
 ;@output = form key of CT Eval form previous to FORM
 ;
 ; $$PREVCT returns the form key to the CT Eval form previous to
 ; FORM. If FORM is null, the latest CT Eval form key is returned.
 ;
 new gn set gn=$$setroot^%wd("vapals-patients")
 new prev set prev=$order(@gn@("graph",SID,"ceform-30"),-1)
 ;
 quit prev ; end of $$PREVCT
 ;
 ;
 ;
CTINFO(ARY,SID,FORM) ; extracts from latest CT Eval form
 ;
 ;ven/gpl;private;procedure;
 ;@input
 ; ARY = name of output array
 ; SID
 ; FORM
 ;@output
 ; @ARY = extract from latest ct eval form [passed by name]
 ;
 n ctkey s ctkey=$$PREVCT(SID,$G(FORM))
 q:ctkey=""
 n root s root=$$setroot^%wd("vapals-patients")
 n ctroot s ctroot=$na(@root@("graph",SID,ctkey))
 ;
 s @ARY@("ctform")=ctkey
 s @ARY@("impression")=$g(@ctroot@("ceimre"))
 n futext
 s futext=$g(@ctroot@("cefuw"))
 n futbl
 s futbl("1y")="Annual repeat"
 s futbl("nw")="Now"
 s futbl("1m")="1 month"
 s futbl("3m")="3 months"
 s futbl("6m")="6 months"
 s futbl("os")="other"
 i futext'="" s futext=$g(futbl(futext))
 n fudate s fudate=$g(@ctroot@("cefud"))
 ; #Other followup
 n zfu,ofu,tofu,comma
 n vals s vals=ctroot
 s comma=0,tofu=""
 s ofu=""
 f zfu="cefuaf","cefucc","cefupe","cefufn","cefubr","cefupc","cefutb" d  ;
 . i $$XVAL(zfu,vals)="y" s ofu=ofu_zfu
 i $$XVAL("cefuo",vals)'="" s ofu=ofu_"cefuo"
 i ofu'="" d  ;
 . s tofu="Other followup: "
 . i ofu["cefuaf" s tofu=tofu_"Antibiotics" s comma=1
 . i ofu["cefucc" s tofu=tofu_$s(comma:", ",1:"")_"Diagnostic CT" s comma=1
 . i ofu["cefupe" s tofu=tofu_$s(comma:", ",1:"")_"PET" s comma=1
 . i ofu["cefufn" s tofu=tofu_$s(comma:", ",1:"")_"Percutaneous biopsy" s comma=1
 . i ofu["cefubr" s tofu=tofu_$s(comma:", ",1:"")_"Bronchoscopy" s comma=1
 . i ofu["cefupc" s tofu=tofu_$s(comma:", ",1:"")_"Pulmonary consultation" s comma=1
 . i ofu["cefutb" s tofu=tofu_$s(comma:", ",1:"")_"Refer to tumor board" s comma=1
 . i ofu["cefuo" s tofu=tofu_$s(comma:", ",1:"")_"Other:" s comma=1
 s @ARY@("followup")=futext_" "_fudate
 s @ARY@("followup2")=tofu
 s @ARY@("followup3")=$$XVAL("cefuoo",vals)
 ;
 quit  ; end of CTINFO
 ;
 ;
 ; 
IMPRESS(ARY,SID) ; impressions from ct eval report
 ;
 ;ven/gpl;private;procedure;
 ;@input
 ; ARY = name of output array
 ; SID
 ;@output
 ; @ARY = impressions from ct eval report [passed by name]
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 n ctkey s ctkey=$g(@ARY@("ctform"))
 n vals s vals=$na(@root@("graph",SID,ctkey))
 n dict s dict=$$setroot^%wd("cteval-dict")
 s dict=$na(@dict@("cteval-dict"))
 n para s para=""
 n sp1 s sp1="    "
 ; 
 d OUT("Impression:")
 d OUT(sp1_$$XSUB("ceimn",vals,dict)_para)
 ;
 ;# Report CAC Score and Extent of Emphysema
 s cacval=0
 d  ;if $$XVAL("ceccv",vals)'="e" d  ;
 . set vcac=$$XVAL("cecccac",vals)
 . if vcac'="" d  ;
 . . s cacrec=""
 . . s cac="The Visual Coronary Artery Calcium (CAC) Score is "_vcac_". "
 . . s cacval=vcac
 . . i cacval>3 s cacrec=$g(@dict@("CAC_recommendation"))_para
 ;
 i cacval>0 d  ;
 . d OUT(sp1_cac_" "_cacrec_" "_para)
 . d  ;if $$XVAL("ceemv",vals)="e" d  ;
 . . if $$XVAL("ceem",vals)'="no" d  ;
 . . . if $$XVAL("ceem",vals)="nv" q  ;
 . . . d OUT(sp1_"Emphysema: "_$$XSUB("ceem",vals,dict)_"."_para)
 ;
 i $$XVAL("ceclini",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("ceclin",vals)_"."_para)
 ;
 i $$XVAL("ceoppai",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("ceoppa",vals)_"."_para)
 ;
 i $$XVAL("ceoppabi",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("ceoppab",vals)_"."_para)
 ;
 i $$XVAL("cecommcai",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("cecommca",vals)_"."_para)
 ;
 i $$XVAL("ceotabnmi",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("ceotabnm",vals)_"."_para)
 ;
 i $$XVAL("ceobrci",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("ceobrc",vals)_"."_para)
 ;
 i $$XVAL("ceaoabbi",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("ceaoabb",vals)_"."_para)
 ;
 i $$XVAL("ceaoabi",vals)="y" d  ;
 . d OUT(sp1_$$XVAL("ceaoab",vals)_"."_para)
 ;
 ;# Impression Remarks
 i $$XVAL("ceimre",vals)'="" d  ;
 . d OUT(sp1_$$XVAL("ceimre",vals)_"."_para)
 ;
 quit  ; end of IMPRESS
 ;
 ;
 ;
XSUB(var,vals,dict,valdx) ; dictionary value for variable
 ;
 ;ven/gpl;private;function;
 ;@input
 ; var = name of dictionary value
 ; vals = name of variables array
 ; @vals = variables array [passed by name]
 ; dict = name of dictionary array
 ; @dict = dictionary array [passed by name]
 ; valdx = used for nodules ala cect2co with nodule # included
 ;@output = dictionary value for variable
 ;
 ; new dict set dict=$$setroot^%wd("cteval-dict")
 ;
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
EOR ; end of routine SAMINOT2
