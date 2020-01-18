SAMINOT2 ;ven/gpl - followup form notes ; 5/7/19 4:48pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; no entry from top
 ;
EXISTCE(SID,FORM) ; extrinsic returns "true" or "false"
 ; if a Chart Eligibility Note exists
 n root s root=$$setroot^%wd("vapals-patients")
 n gvals s gvals=$na(@root@("graph",SID,FORM))
 ;i $g(@root@("graph",SID,FORM,"sicechrt"))="y" q "true"
 i $g(@gvals@("pre-note-complete"))="true" q "true"
 q "false"
 ;
EXISTPRE(SID,FORM) ; extrinsic returns "true" or "false"
 ; if a Pre-enrollment Note exists
 n root s root=$$setroot^%wd("vapals-patients")
 n gvals s gvals=$na(@root@("graph",SID,FORM))
 ;i $g(@root@("graph",SID,FORM,"sipedisc"))="y" q "true"
 i $g(@gvals@("pre-note-complete"))="true" i $g(@gvals@("siperslt"))="y" q "true"
 q "false"
 ;
EXISTINT(SID,FORM) ; extrinsic returns "true" or "false"
 ; if an Intake Note exists
 n root s root=$$setroot^%wd("vapals-patients")
 i $g(@root@("graph",SID,FORM,"sistatus"))="y" q "true"
 q "false"
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
 k ^SAMIUL("NOTE")
 m ^SAMIUL("NOTE","vals")=@vals
 m ^SAMIUL("NOTE","filter")=filter
 ;
 n didnote s didnote=0
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
 d OUT("Veteran Communication Note")
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
MKEL(sid,form,vals,filter) ;
 n cnt s cnt=0
 ;n dest s dest=$na(@vals@("eligibility-note"))
 n dest s dest=$$MKNT(vals,"Eligibility Note","eligibility",.filter)
 k @dest
 d OUT("Lung Screening Program Chart Eligibility Note")
 d OUT("")
 d ELNOTE(vals,dest,cnt)
 q
 ;
MKPRE(sid,form,vals,filter) ;
 n cnt s cnt=0
 ;n dest s dest=$na(@vals@("pre-note"))
 n dest s dest=$$MKNT(vals,"Pre-enrollment Discussion Note","prenote",.filter)
 k @dest
 i $g(@vals@("chart-eligibility-complete"))'="true" d  ;
 . d OUT("Lung Screening Program Chart Eligibility and Pre-enrollment Discussion Note")
 . d OUT("")
 . d ELNOTE(vals,dest,cnt)
 i $g(@vals@("chart-eligibility-complete"))="true" d  ;
 . d OUT("Lung Screening Program Pre-enrollment Discussion Note")
 . d OUT("")
 d PRENOTE(vals,dest,cnt)
 q
 ;
MKIN(sid,form,vals,filter) ;
 n cnt s cnt=0
 ;n dest s dest=$na(@vals@("intake-note"))
 n dest s dest=$$MKNT(vals,"Intake Note","intake",.filter)
 k @dest
 d OUT("Lung Screening Program Intake Note")
 d OUT("")
 i $g(@vals@("chart-eligibility-complete"))'="true" d  ;
 . d ELNOTE(vals,dest,cnt)
 i $g(@vals@("pre-note-complete"))'="true" d  ;
 . d PRENOTE(vals,dest,cnt)
 d INNOTE(vals,dest,cnt)
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
ELNOTE(vals,dest,cnt) ; eligibility NOTE TEXT
 D OUT("")
 D OUT("Date of chart review: "_$$XVAL("sidc",vals))
 D OUT("The participant was identified as a potential lung screening candidate by: "_$$XVAL("siceiden",vals))
 if $$XVAL("siceiden",vals)="referral" d  ;
 . D OUT("Date of Referral: "_$$XVAL("sicerfdt",vals))
 . n spec s spec=""
 . s:$$XVAL("sicerfpc",vals)="y" spec=spec_" Primary Care"
 . s:$$XVAL("sicerfwh",vals)="y" spec=spec_" Women's Health"
 . s:$$XVAL("sicerfge",vals)="y" spec=spec_" Geriatrics"
 . s:$$XVAL("sicerfpu",vals)="y" spec=spec_" Pulmonology"
 . s:$$XVAL("sicerfon",vals)="y" spec=spec_" Oncology"
 . s:$$XVAL("sicerfsc",vals)="y" spec=spec_" Smoking Cessation"
 . s:$$XVAL("sicerfot",vals)="y" spec=spec_" "_$$XVAL("sicerfoo",vals)
 . D OUT("Specialty of referring provider: "_spec)
 n elig
 s elig=$$XVAL("sicechrt",vals)
 D OUT("The participant is eligible based on chart review: "_$s(elig="y":"Yes",1:"no"))
 D OUT("")
 s @vals@("chart-eligibility-complete")="true"
 q
 ;
PRENOTE(vals,dest,cnt) ;
 ;
 i $g(@vals@("sipedisc"))'="y" q  ; no prelim discussion
 D OUT("")
 ;d OUT("A pre-enrollment discussion was held.")
 ;[If Yes is selected then add the following 5 lines]
 D OUT("The program attempted to reach the Veteran to discuss lung screening.")
 D OUT("Date of pre-enrollment discussion: "_$$XVAL("sipedc",vals))
 n via s via=""
 s:$$XVAL("sipecnip",vals)="1" via=via_" In person"
 s:$$XVAL("sipecnte",vals)="1" via=via_" Telephone"
 s:$$XVAL("sipecnth",vals)="1" via=via_" TeleHealth"
 s:$$XVAL("sipecnml",vals)="1" via=via_" Mailed Letter"
 s:$$XVAL("sipecnpp",vals)="1" via=via_" Message in patient portal"
 s:$$XVAL("sipecnvd",vals)="1" via=via_" Video-on-Demand (VOD)"
 s:$$XVAL("sipecnot",vals)="1" via=via_" "_$$XVAL("sipecnoo",vals)
 D OUT("The lung screening program reached the potential candidate or was contacted via:"_via)
 D OUT("The pre-enrollment discussion with the participant resulted in: "_$$SUBRSLT($$XVAL("siperslt",vals)))
 D OUT("Comments: "_$$XVAL("sipecmnt",vals))
 ;
 s @vals@("pre-note-complete")="true"
 q
 ;
SUBRSLT(XVAL) ; translation of discussion result
 q:XVAL="y" "Participant is interested in discussing lung screening. The program will proceed with enrollment process."
 q:XVAL="u" "Participant is unsure of lung screening. Ok to contact in the future."
 q:XVAL="nn" "Participant is not interested in discussing lung screening at this time. Ok to contact in the future."
 q:XVAL="nf" "Participant is not interested in discussing lung screening in the future."
 q:XVAL="na" "Unable to reach participant at this time"
 q ""
 ;
VCNOTE(vals,dest,cnt) ; Veteran Communication Note
 ;d OUT("")
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
 q
 ;
LCSNOTE(vals,dest,cnt) ; Lung Screening Note
 ;d OUT("")
 d OUT("Veteran was contacted via:")
 n sp1 s sp1="    "
 d:$$XVAL("fucmctip",vals) OUT(sp1_"In person")
 d:$$XVAL("fucmctte",vals) OUT(sp1_"Telephone")
 d:$$XVAL("fucmctth",vals) OUT(sp1_"TeleHealth")
 d:$$XVAL("fucmctml",vals) OUT(sp1_"Mailed Letter")
 d:$$XVAL("fucmctpp",vals) OUT(sp1_"Message in patient portal")
 d:$$XVAL("fucmctvd",vals) OUT(sp1_"Video-on-demand (VOD)")
 d:$$XVAL("fucmctot",vals) OUT(sp1_"Other: "_$$XVAL("fucmctoo",vals))
 d OUT("")
 ;
 d:$$XVAL("fucmctde",vals)'=""
 . d OUT("Communication details:")
 . d OUT(sp1_$$XVAL("fucmctde",vals))
 q
 ;
INNOTE(vals,dest,cnt) ;
 ;
 ;Lung Screening Program Intake Note
 ;
 ;Date of intake discussion contact:       [Date]
 ;How did you learn about the Lung Screening Program?:  [Selection]
 ;Primary address verified:                 [Yes/No]
 ;Rural status:                                        [Urban/Rural/Unknown]
 ;Preferred address and contact number:
 ;     [Address 1]
 ;           [Address 2]
 ;              [Address]
 ;
 ;Ever smoked?:            [Ever Smoked Text]
 ;Smoking Status:          [Never Smoked/Past/Current/Willing to Quit]
 ;CIGs per day:               [Input Number]
 ;PPD:                              [Computed Number]
 ;# of years:                    [Input Number]
 ;Pack Years:                   [Computed Number]
 ;
 ;[If a Quit Date is entered add the following line]
 ;Quit smoking on:         [Date]
 ;
 ;[If Smoking Cessation education text is entered add the following line]
 ;Smoking cessation education provided: [Show Input Text]
 ;
 ;[If a Lung Cancer Dx date is entered show the following 1 to 2 lines]
 ;Prior lung cancer diagnosis date: [Date]
 ;[If a location not in the VA is specified show the next line]
 ;Location where prior lung cancer diagnosis was made: [Location Text]
 ;
 ;[If Any Prior CT Date is entered show the following 1 to 2 lines]
 ;Prior CT:                   [Date]
 ;[If a location not in the VA is specified show the next line]
 ;Location where prior lung cancer diagnosis was made: [Location Text]
 ;
 ;Shared Decision Making:
 ;
 d OUT(" ")
 d OUT("   "_"Date of intake discussion contact: "_$$XVAL("sidc",vals))
 n learn s learn=""
 s:$$XVAL("silnip",vals) learn=learn_" In person"
 s:$$XVAL("silnph",vals) learn=learn_" Telephone"
 s:$$XVAL("silnth",vals) learn=learn_" TeleHealth"
 s:$$XVAL("silnml",vals) learn=learn_" Mailed letter"
 s:$$XVAL("silnpp",vals) learn=learn_" Message in patient portal"
 s:$$XVAL("silnvd",vals) learn=learn_" Video-on-Demand (VOD)"
 s:$$XVAL("silnot",vals) learn=learn_" "_$$XVAL("silnoo",vals)
 d OUT("   "_"How did you learn about the Lung Screening Program?: "_learn)
 n verified s verified=""
 s:$$XVAL("sipav",vals)="y" verified="Yes"
 s:$$XVAL("sipav",vals)="n" verified="No"
 d OUT("   "_"Primary address verified: "_verified)
 n rural s rural=""
 s:$$XVAL("sirs",vals)="r" rural="rural"
 s:$$XVAL("sirs",vals)="u" rural="urban"
 d OUT("   "_""_"Rural status: "_rural)
 d OUT("   "_"Preferred address and contact number: ")
 n pa s pa=""
 i $$XVAL("sipsa",vals)'="" d  ;
 . d OUT("      "_$$XVAL("sipsa",vals))
 . n csz s csz=""
 . s:$$XVAL("sipc",vals)'="" csz=$$XVAL("sipc",vals)
 . s:$$XVAL("sips",vals)'="" csz=csz_", "_$$XVAL("sips",vals)
 . s:$$XVAL("sipz",vals)'="" csz=csz_" "_$$XVAL("sipz",vals)
 . d OUT("      "_csz)
 d:$$XVAL("sippn",vals)'="" OUT("      "_$$XVAL("sippn",vals))
 d OUT("   "_"Ever smoked?: ")
 d OUT("      "_$$XVAL("sies",vals))
 n sstatus s sstatus=""
 s:$$XVAL("siesm",vals)="n" sstatus=sstatus_" Never smoked"
 s:$$XVAL("siesm",vals)="p" sstatus=sstatus_" Past"
 s:$$XVAL("siesm",vals)="c" sstatus=sstatus_" Current"
 s:$$XVAL("siesq",vals)=1 sstatus=sstatus_" Willing to quit"
 d OUT("   Smoking Status: "_sstatus)
 d OUT("   "_"CIGs per day: ")
 d OUT("      "_$$XVAL("sicpd",vals))
 d OUT("   "_"PPD: ")
 d OUT("      "_$$XVAL("sippd",vals))
 d OUT("   "_"# of years: ")
 d OUT("      "_$$XVAL("sisny",vals))
 d OUT("   "_"PPY: ")
 d OUT("      "_$$XVAL("sippy",vals))
 d OUT("")
 i $$XVAL("siq",vals)'="" d  ;
 . d OUT("Quit smoking on: "_$$XVAL("siq",vals))
 . d OUT("")
 i $$XVAL("sicep",vals)'="" d  ;
 . d OUT("Smoking cessation education provided:")
 . d OUT("    "_$$XVAL("sicep",vals))
 i $$XVAL("sicadx",vals)'="" d
 . d OUT("Prior lung cancer diagnosis date: "_$$XVAL("sicadx",vals))
 . i $$XVAL("sicadxl",vals)'="" d  ;
 . . d OUT("Location where prior lung cancer diagnosis was made:")
 . . d OUT("    "_$$XVAL("sicadxl",vals))
 i $$XVAL("siptct",vals)'="" d
 . d OUT("Prior CT: "_$$XVAL("siptct",vals))
 . i $$XVAL("siptctl",vals)'="" d  ;
 . . d OUT("Location where prior CT was made:")
 . . d OUT("    "_$$XVAL("siptctl",vals))
 d OUT(" ")
 d OUT("Shared Decision Making: ")
 d OUT(" ")
 d OUT("Veteran of age and exposure to cigarette smoke as described above, and without a ")
 d OUT("current diagnosis or obvious symptoms suggestive of lung cancer, has been educated ")
 d OUT("today about the estimated risk for lung cancer, the possibility of a cure or life ")
 d OUT("prolonging if an early lung cancer were to be found during screening, the possibility of ")
 d OUT("imaging abnormalities not being lung cancer, the possibility of complications from ")
 d OUT("additional diagnostic procedures, and the approximate amount of radiation exposure ")
 d OUT("associated with each screening procedure. In addition, the veteran has been educated ")
 d OUT("today about the importance of avoiding exposure to cigarette smoke, available tobacco ")
 d OUT("cessation programs and available lung screening services at this VA facility. Education ")
 d OUT("material was provided to the veteran.")
 ;d OUT(" ")
 ;d OUT("Veteran of age and exposure to cigarette smoke as described above, and without")
 ;d OUT("a current diagnosis or obvious symptoms suggestive of lung cancer, has been")
 ;d OUT("educated today about the estimated risk for lung cancer, the possibility of")
 ;d OUT("cure or life prolonging if an early lung cancer were to be found during")
 ;d OUT("screening, the possibility of imaging abnormalities not being lung cancer, the")
 ;d OUT("possibility of complications from additional diagnostic procedures, and the")
 ;d OUT("approximate amount of radiation exposure associated with each screening")
 ;d OUT("procedure.  In addition, the veteran has been educated today about the")
 ;d OUT("importance of adhering to annual lung screening, the possible impact of other")
 ;d OUT("medical conditions on the overall health status, the importance of avoiding")
 ;d OUT("exposure to cigarette smoke, available tobacco cessation programs and")
 ;d OUT("available lung screening services at the Phoenix VA.  Education material was")
 ;d OUT("provided to the veteran.  Based on this information, the veteran has opted")
 ;d OUT("for: ")
 d OUT(" ")
 n ldct s ldct=""
 s:$$XVAL("sildct",vals)="n" ldct="No"
 s:$$XVAL("sildct",vals)="l" ldct="No"
 s:$$XVAL("sildct",vals)="y" ldct="Yes"
 d OUT("The veteran has decided to enroll in the Lung Screening Program: "_ldct)
 i $$XVAL("sildct",vals)="l" d  ;
 . d OUT("The veteran has indicated it is okay to contact in the future to discuss enrolling in the Lung Screening Program.")
 i ldct="Yes" d  ;
 . d OUT("LDCT ordered: "_ldct)
 . d OUT("    "_"Veteran enrolled in the LSS program. Results and coordination of care ")
 . d OUT("    "_"will be made by the LSS team.  ")
 . i $$XVAL("siclin",vals)'="" d  ;
 . d OUT("Clinical Indications for Initial Screening CT:")
 . d OUT("    "_$$XVAL("siclin",vals))
 ;
 ;The veteran has decided to enroll in the Lung Screening Program: [Yes/No]
 ;
 ;[If Not enroll at this time but okay to contact in the future, add the following line]
 ;The veteran has indicated it is okay to contact in the future to discuss enrolling in the Lung Screening Program.
 ;
 ;[If Yes is answered for enrollment add the following two lines]
 ;LDCT ordered:                Yes
 ;Veteran enrolled in the Lung Screening Program. Results and coordination of care will be made by the Lung Screening Program team.
 ;
 ;[If Clinical Indication text is provided add them to the note]
 ;Clinical Indications:          [Show Input Text]
 ;
 ;
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
 ;
