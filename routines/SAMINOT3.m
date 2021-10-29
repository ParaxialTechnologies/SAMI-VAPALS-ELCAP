SAMINOT3 ;ven/gpl - CTeval report plain text ; 2021-10-29t23:36z
 ;;18.0;SAMI;**15**;
 ;;18-15
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; no entry from top
 ;
WSNOTE(return,filter) ; web service which returns a text note
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
 ;
 n vals
 m vals=@root@("graph",si,samikey)
 ;
 n notebase
 d WSREPORT^SAMICTT0(.notebase,.filter)
 s note="notebase"
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
 q
 ;
NOTE(filter) ; extrnisic which creates a note
 ; returns 1 if successful, 0 if not
 ;
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
 n vetstxt s vetstxt="veteran"
 n vetstxt2 s vetstxt2="Veteran"
 i $g(filter("veteransAffairsSite"))="false" d  ;
 . set vetstxt="participant"
 . set vetstxt2="Participant"
 set filter("vetstxt")=vetstxt
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
 . d MKLCS(si,samikey,vals,.filter) ;
 . s didnote=1
 ;
 ;i $g(@vals@("samistatus"))="complete" d  ;
 ;. q:$$HASVCNT(vals)
 ;. d MKVC(si,samikey,vals,.filter) ;
 ;. s didnote=1
 ;
 q didnote
 ;
HASINNT(vals) ; extrinsic returns 1 if intake note is present
 ; else returns 0
 n zzi,zzrtn s (zzi,zzrtn)=0
 q:'$d(@vals)
 f  s zzi=$o(@vals@("notes",zzi)) q:+zzi=0  d  ;
 . i $g(@vals@("notes",zzi,"name"))["Intake" s zzrtn=1
 q zzrtn
 ;
HASVCNT(vals) ; extrinsic returns 1 if communication note is present
 ; else returns 0
 n zzi,zzrtn s (zzi,zzrtn)=0
 q:'$d(@vals)
 f  s zzi=$o(@vals@("notes",zzi)) q:+zzi=0  d  ;
 . i $g(@vals@("notes",zzi,"name"))["Communication" s zzrtn=1
 q zzrtn
 ;
HASLCSNT(vals) ; extrinsic returns 1 if communication note is present
 ; else returns 0
 n zzi,zzrtn s (zzi,zzrtn)=0
 q:'$d(@vals)
 f  s zzi=$o(@vals@("notes",zzi)) q:+zzi=0  d  ;
 . i $g(@vals@("notes",zzi,"name"))["Lung" s zzrtn=1
 q zzrtn
 ;
MKVC(sid,form,vals,filter) ;
 n cnt s cnt=0
 ;n dest s dest=$na(@vals@("communication-note"))
 n dest s dest=$$MKNT(vals,"Communication Note","communication",.filter)
 k @dest
 d OUT(vetstxt_" Communication Note")
 d OUT("")
 d VCNOTE(vals,dest,cnt)
 q
 ;
MKLCS(sid,form,vals,filter) ;
 n cnt s cnt=0
 ;n dest s dest=$na(@vals@("lcs-note"))
 n dest s dest=$$MKNT(vals,"Lung Cancer Screening Note","lcs",.filter)
 k @dest
 d OUT("Lung Screening and Surveillance Follow up Note")
 d OUT("")
 d LCSNOTE(vals,dest,cnt)
 q
 ;
MKNT(vals,title,ntype,filter) ; extrinsic makes a note date=now returns 
 ; global addr. filter must be passed by reference
 n ntdt s ntdt=$$NTDTTM($$NOW^XLFDT)
 n ntptr
 s ntptr=$$MKNTLOC(vals,title,ntdt,$g(ntype),.filter)
 q ntptr
 ;
MKNTLOC(vals,title,ndate,ntype,filter) ; extrinsic returns the 
 ;location for the note
 n nien
 s nien=$o(@vals@("notes",""),-1)+1
 s filter("nien")=nien
 n nloc s nloc=$na(@vals@("notes",nien))
 s @nloc@("name")=title_" "_$g(ndate)
 s @nloc@("date")=$g(ndate)
 s @nloc@("type")=$g(ntype)
 q $na(@nloc@("text"))
 ;
NTDTTM(ZFMDT) ; extrinsic returns the date and time in Note format
 ; ZFMDT is the fileman date/time to translate
 q $$FMTE^XLFDT(ZFMDT,"5")
 ;
NTLOCN(sid,form,nien) ; extrinsic returns the location of the Nth note
 n root s root=$$setroot^%wd("vapals-patients")
 q $na(@root@("graph",sid,form,"notes",nien))
 ;
NTLAST(sid,form,ntype) ; extrinsic returns the location of the latest note
 ; of the type ntype
 q
 ;
NTLIST(nlist,sid,form) ; returns the note list in nlist, passed by ref
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
 q
 ;
TLST ;
 S SID="XXX00677"
 S FORM="siform-2019-04-23"
 D NTLIST("G",SID,FORM)
 ;ZWR G
 Q
 ;
VCNOTE(vals,dest,cnt) ; Veteran Communication Note
 ;d OUT("")
 d OUT(vetstxt2_" was contacted via:")
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
 q
 ;
SSTATUS(vals)  ;
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
 ;i $$XVAL("siscf",vals)'="" s cnt=cnt+1 s tryary(cnt)="Telephone cessation counseling hotline (e.g., 1-855-QUIT-VET, 1-800-QUIT-NOW)"
 i $$XVAL("siscf",vals)'="" s cnt=cnt+1 s tryary(cnt)="Telephone cessation counseling hotline"
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
 . s cess="Interested in VA tobacco cessation medication. Encouraged "_vetstxt
 . s cess2="to talk to provider or pharmacist about which medication option is best for you."
 i cess'="" d  ;
 . d OUT("Tobacco cessation provided:")
 . d OUT(sp1_cess)
 . i cess2'="" d OUT(sp1_cess2)
 q
 ;
LCSNOTE(vals,dest,cnt) ; Lung Screening Note
 ;d OUT("")
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
 q
 ;
OUT(ln) ;
 s cnt=cnt+1
 n lnn
 ;s debug=1
 s lnn=$o(@dest@(" "),-1)+1
 s @dest@(lnn)=ln
 ;i $g(debug)=1 d  ;
 ;. i ln["<" q  ; no markup
 ;. n zs s zs=$STACK
 ;. n zp s zp=$STACK(zs-2,"PLACE")
 ;. s @dest@(lnn)=zp_":"_ln
 q
 ;
XVAL(var,vals) ; extrinsic returns the patient value for var
 ; vals is passed by name
 n zr
 s zr=$g(@vals@(var))
 ;i zr="" s zr="["_var_"]"
 q zr
 ;
PREVCT(SID,FORM) ; extrinic returns the form key to the CT Eval form
 ; previous to FORM. If FORM is null, the latest CT Eval form key is returned
 ; FORM sensitivity is tbd.. always returns latest CTEval
 n gn s gn=$$setroot^%wd("vapals-patients")
 n prev s prev=$o(@gn@("graph",SID,"ceform-30"),-1)
 q prev
 ;
CTINFO(ARY,SID,FORM) ; returns extracts from latest CT Eval form
 ; ARY passed by name
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
 q
 ; 
IMPRESS(ARY,SID) ; impressions from CTEval report
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
 q
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
