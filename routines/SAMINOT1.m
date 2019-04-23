SAMINOT1 ;ven/gpl - ielcap: forms ; 4/23/19 9:11am
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
 i $g(@gvals@("pre-note-complete"))="true" q "true"
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
 . D SAMISUB2^SAMIFORM(.line,samikey,si,.filter)
 . s temp(zi)=line
 . ;
 . s cnt=cnt+1
 . s tout(cnt)=temp(zi)
 . ;
 . i temp(zi)["report-text" d  ;
 . . i temp(zi)["#" q  ;
 . . n zj s zj=""
 . . n note
 . . n ntype s ntype=""
 . . s:$g(vals("samistatus"))="complete" ntype="intake-note"
 . . s:$g(vals("samistatus"))="chart-eligibility" ntype="eligibility-note"
 . . s:$g(vals("samistatus"))="pre-enrollment-discussion" ntype="pre-note"
 . . q:ntype=""
 . . s note=$na(@root@("graph",si,samikey,ntype))
 . . i '$d(@note) q
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
 k ^SAMIGPL("NOTE")
 m ^SAMIGPL("NOTE","vals")=@vals
 m ^SAMIGPL("NOTE","filter")=filter
 ;
 n didnote s didnote=0
 ;
 i $g(@vals@("samistatus"))="chart-eligibility" d  ;
 . d MKEL(si,samikey,vals) ;
 . s didnote=1
 ;
 i $g(@vals@("samistatus"))="pre-enrollment-discussion" d  ;
 . d MKPRE(si,samikey,vals) ;
 . s didnote=1
 ;
 i $g(@vals@("samistatus"))="complete" d  ;
 . d MKIN(si,samikey,vals) ;
 . s didnote=1
 ;
 q didnote
 ;
MKEL(sid,form,vals) ;
 n cnt s cnt=0
 n dest s dest=$na(@vals@("eligibility-note"))
 k @dest
 d OUT("Lung Screening Program Chart Eligibility Note")
 d OUT("")
 d ELNOTE(vals,dest,cnt)
 q
 ;
MKPRE(sid,form,vals) ;
 n cnt s cnt=0
 n dest s dest=$na(@vals@("pre-note"))
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
MKIN(sid,form,vals) ;
 n cnt s cnt=0
 n dest s dest=$na(@vals@("intake-note"))
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
 D OUT("The patient is eligible based on chart review: "_$s(elig="y":"Yes",1:"no"))
 D OUT("")
 s @vals@("chart-eligibility-complete")="true"
 q
 ;
PRENOTE(vals,dest,cnt) 
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
INNOTE(vals,dest,cnt) 
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
 ;	          [Address …]
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
 ;[If Any Prior Thorax CT Date is entered show the following 1 to 2 lines]
 ;Prior thorax CT:                   [Date]
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
 s:$$XVAL("siesn",vals) sstatus=sstatus_" Never smoked"
 s:$$XVAL("siesp",vals) sstatus=sstatus_" Past"
 s:$$XVAL("siesc",vals) sstatus=sstatus_" Current"
 s:$$XVAL("siesq",vals) sstatus=sstatus_" Willing to quit"
 d OUT("    Smoking Status: "_sstatus)
 d OUT("   "_"CIGs per day: ")
 d OUT("      "_$$XVAL("sicpd",vals))
 d OUT("   "_"PPD: ")
 d OUT("      "_$$XVAL("sippd",vals))
 d OUT("   "_"# of years: ")
 d OUT("      "_$$XVAL("sisny",vals))
 d OUT("   "_"PPY: ")
 d OUT("      "_$$XVAL("sippy",vals))
 d OUT("   "_"Quit smoking on: "_$$XVAL("siq",vals))
 d OUT("   "_"Prior LDCT: ")
 n prior s prior=""
 s:$$XVAL("sicadx",vals)'="" prior=prior_$$XVAL("sicadx",vals)
 s:$$XVAL("sicadxl",vals)'="" prior=prior_" at "_$$XVAL("sicadxl",vals)
 d OUT("      "_prior)
 d OUT(" ")
 d OUT("Shared Decision Making: ")
 d OUT(" ")
 d OUT("Veteran of age and exposure to cigarette smoke as described above, and without")
 d OUT("a current diagnosis or obvious symptoms suggestive of lung cancer, has been")
 d OUT("educated today about the estimated risk for lung cancer, the possibility of")
 d OUT("cure or life prolonging if an early lung cancer were to be found during")
 d OUT("screening, the possibility of imaging abnormalities not being lung cancer, the")
 d OUT("possibility of complications from additional diagnostic procedures, and the")
 d OUT("approximate amount of radiation exposure associated with each screening")
 d OUT("procedure.  In addition, the Veteran has been educated today about the")
 d OUT("importance of adhering to annual lung screening, the possible impact of other")
 d OUT("medical conditions on the overall health status, the importance of avoiding")
 d OUT("exposure to cigarette smoke, available tobacco cessation programs and")
 d OUT("available lung screening services at the Phoenix VA.  Education material was")
 d OUT("provided to the veteran.  Based on this information, the Veteran has opted")
 d OUT("for: ")
 d OUT(" ")
 d OUT("LDCT ordered: ")
 n ldct s ldct=""
 s:$$XVAL("sildct",vals)="n" ldct=ldct_" No"
 s:$$XVAL("sildct",vals)="l" ldct=ldct_" Not at this time, okay to contact in the future"
 s:$$XVAL("sildct",vals)="y" ldct=ldct_" Yes"
 d OUT("    "_ldct)
 i $$XVAL("sildct",vals)="y" d  ;
 . d OUT("    "_"Veteran enrolled in the LSS program. Results and coordination of care ")
 . d OUT("    "_"will be made by the LSS team.  ")
 ;
 ;The Veteran has decided to enroll in the Lung Screening Program: [Yes/No]
 ;
 ;[If “Not enroll at this time but okay to contact in the future” add the following line]
 ;The Veteran has indicated it is okay to contact in the future to discuss enrolling in the Lung Screening Program.
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
