SAMINOT1 ;ven/gpl - ielcap: forms ; 5/7/19 4:48pm
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
 ;
 ; set up patient values
 ;
 n vals
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
 i $g(@vals@("samistatus"))="chart-eligibility" d  ;
 . d MKEL(si,samikey,vals,.filter) ;
 . s didnote=1
 ;
 i $g(@vals@("samistatus"))="pre-enrollment-discussion" d  ;
 . d MKPRE(si,samikey,vals,.filter) ;
 . s didnote=1
 ;
 i $g(@vals@("samistatus"))="complete" d  ;
 . q:$$HASINNT(vals)
 . d MKIN(si,samikey,vals,.filter) ;
 . s didnote=1
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
 n sdm s sdm=""
 s sdm=sdm_"Veteran of age and exposure to cigarette smoke as described above, and without a "
 s sdm=sdm_"current diagnosis or obvious symptoms suggestive of lung cancer, has been educated "
 s sdm=sdm_"today about the estimated risk for lung cancer, the possibility of a cure or life "
 s sdm=sdm_"prolonging if an early lung cancer were to be found during screening, the possibility of "
 s sdm=sdm_"imaging abnormalities not being lung cancer, the possibility of complications from "
 s sdm=sdm_"additional diagnostic procedures, and the approximate amount of radiation exposure "
 s sdm=sdm_"associated with each screening procedure. In addition, the veteran has been educated "
 s sdm=sdm_"today about the importance of avoiding exposure to cigarette smoke, available tobacco "
 s sdm=sdm_"cessation programs and available lung screening services at this VA facility. Education "
 s sdm=sdm_"material was provided to the veteran."
 s sdm=sdm_"Veteran of age and exposure to cigarette smoke as described above, and without a "
 s sdm=sdm_"current diagnosis or obvious symptoms suggestive of lung cancer, has been educated "
 s sdm=sdm_"today about the estimated risk for lung cancer, the possibility of a cure or life "
 s sdm=sdm_"prolonging if an early lung cancer were to be found during screening, the possibility of "
 s sdm=sdm_"imaging abnormalities not being lung cancer, the possibility of complications from "
 s sdm=sdm_"additional diagnostic procedures, and the approximate amount of radiation exposure "
 s sdm=sdm_"associated with each screening procedure. In addition, the veteran has been educated "
 s sdm=sdm_"today about the importance of avoiding exposure to cigarette smoke, available tobacco "
 s sdm=sdm_"cessation programs and available lung screening services at this VA facility. Education "
 s sdm=sdm_"material was provided to the veteran."
 d OUT(sdm)
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
