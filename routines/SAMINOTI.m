SAMINOTI ;ven/gpl - ielcap: forms ; 12/27/18 3:56pm
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
WSNOTE(return,filter) ; web service which returns a text note
 ;
 n debug s debug=0
 i $g(filter("debug"))=1 s debug=1
 ;
 k return
 n HTTPRSP s HTTPRSP("mime")="text/html"
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
 do GETTMPL^SAMICAS2("temp","vapals:note")
 quit:'$data(temp)
 ;
 n cnt s cnt=0
 n zi s zi=""
 ;
 f  s zi=$o(temp(zi)) q:zi=""  d  ;
 . ;
 . n line s line=temp(zi)
 . D SAMISUB2^SAMIFRM2(.line,samikey,si,.filter)
 . s temp(zi)=line
 . ;
 . s cnt=cnt+1
 . s tout(cnt)=temp(zi)
 . ;
 . i temp(zi)["report-text" d  ;
 . . i temp(zi)["#" q  ;
 . . n zj s zj=""
 . . n note s note=$na(@root@("graph",si,samikey,"note"))
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
 n cnt s cnt=0 ; line number
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
 n dest s dest=$na(@vals@("note"))
 k @dest
 ;
 ;
 d OUT("Lung Screening and Surveillance (LSS) Outreach and Intake Encounter Note ")
 d OUT(" ")
 d OUT("   "_"Date of contact: "_$$XVAL("sidc",vals))
 n learn s learn=""
 s:$$XVAL("silnph",vals) learn=learn_" Phone"
 s:$$XVAL("silnls",vals) learn=learn_" Letter"
 s:$$XVAL("silnpu",vals) learn=learn_" Pulmonary"
 s:$$XVAL("silnpc",vals) learn=learn_" PCP"
 d OUT("   "_"How did you learn about LSS?: "_learn)
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
 ;d OUT("    "_"Scheduled by the LSS Coordinator:  ")
 ;d OUT("    "_"Best time and day:  ")
 ;d OUT("    "_"Best contact number:  ")
 ;d OUT(" ")
 ;d OUT(" ")
 ; clinical indication text
 i $$XVAL("siclin",vals)'="" d  ; there is some text
 . d OUT("Clinical Indications for Initial Screening CT:")
 . d OUT(" "_$$XVAL("siclin",vals))
 ;
 q 1
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
