SAMINOTI ;ven/gpl - ielcap: forms ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
wsNote(return,filter) ; web service which returns a text note
 ;
 s debug=0
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
 do getTemplate^SAMICAS2("temp","vapals:note")
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
note(filter) ; extrnisic which creates a note
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
 d out("Lung Screening and Surveillance (LSS) Outreach and Intake Encounter Note ")
 d out(" ")
 d out("   "_"Date of contact: "_$$xval("sidc",vals))
 n learn s learn=""
 s:$$xval("silnph",vals) learn=learn_" Phone"
 s:$$xval("silnls",vals) learn=learn_" Letter"
 s:$$xval("silnpu",vals) learn=learn_" Pulmonary"
 s:$$xval("silnpc",vals) learn=learn_" PCP"
 d out("   "_"How did you learn about LSS?: "_learn)
 n verified s verified=""
 s:$$xval("sipav",vals)="y" verified="Yes"
 s:$$xval("sipav",vals)="n" verified="No"
 d out("   "_"Primary address verified: "_verified)
 n rural s rural=""
 s:$$xval("sirs",vals)="r" rural="rural"
 s:$$xval("sirs",vals)="u" rural="urban"
 d out("   "_""_"Rural status: "_rural)
 d out("   "_"Preferred address and contact number: ")
 n pa s pa=""
 i $$xval("sipsa",vals)'="" d  ;
 . d out("      "_$$xval("sipsa",vals))
 . n csz s csz=""
 . s:$$xval("sipc",vals)'="" csz=$$xval("sipc",vals)
 . s:$$xval("sips",vals)'="" csz=csz_", "_$$xval("sips",vals)
 . s:$$xval("sipz",vals)'="" csz=csz_" "_$$xval("sipz",vals)
 . d out("      "_csz)
 d:$$xval("sippn",vals)'="" out("      "_$$xval("sippn",vals))
 d out("   "_"Ever smoked?: ")
 d out("      "_$$xval("sies",vals))
 n sstatus s sstatus=""
 s:$$xval("siesn",vals) sstatus=sstatus_" Never smoked"
 s:$$xval("siesp",vals) sstatus=sstatus_" Past"
 s:$$xval("siesc",vals) sstatus=sstatus_" Current"
 s:$$xval("siesq",vals) sstatus=sstatus_" Willing to quit"
 d out("    Smoking Status: "_sstatus)
 d out("   "_"CIGs per day: ")
 d out("      "_$$xval("sicpd",vals))
 d out("   "_"PPD: ")
 d out("      "_$$xval("sippd",vals))
 d out("   "_"# of years: ")
 d out("      "_$$xval("sisny",vals))
 d out("   "_"PPY: ")
 d out("      "_$$xval("sippy",vals))
 d out("   "_"Quit smoking on: "_$$xval("siq",vals))
 d out("   "_"Prior LDCT: ")
 n prior s prior=""
 s:$$xval("sicadx",vals)'="" prior=prior_$$xval("sicadx",vals)
 s:$$xval("sicadxl",vals)'="" prior=prior_" at "_$$xval("sicadxl",vals)
 d out("      "_prior)
 d out(" ")
 d out("Shared Decision Making: ")
 d out(" ")
 d out("Veteran of age and exposure to cigarette smoke as described above, and without")
 d out("a current diagnosis or obvious symptoms suggestive of lung cancer, has been")
 d out("educated today about the estimated risk for lung cancer, the possibility of")
 d out("cure or life prolonging if an early lung cancer were to be found during")
 d out("screening, the possibility of imaging abnormalities not being lung cancer, the")
 d out("possibility of complications from additional diagnostic procedures, and the")
 d out("approximate amount of radiation exposure associated with each screening")
 d out("procedure.  In addition, the Veteran has been educated today about the")
 d out("importance of adhering to annual lung screening, the possible impact of other")
 d out("medical conditions on the overall health status, the importance of avoiding")
 d out("exposure to cigarette smoke, available tobacco cessation programs and")
 d out("available lung screening services at the Phoenix VA.  Education material was")
 d out("provided to the veteran.  Based on this information, the Veteran has opted")
 d out("for: ")
 d out(" ")
 d out("LDCT ordered: ")
 n ldct s ldct=""
 s:$$xval("sildct",vals)="n" ldct=ldct_" No"
 s:$$xval("sildct",vals)="l" ldct=ldct_" Not at this time, okay to contact in the future"
 s:$$xval("sildct",vals)="y" ldct=ldct_" Yes"
 d out("    "_ldct)
 i $$xval("sildct",vals)="y" d  ;
 . d out("    "_"Veteran enrolled in the LSS program. Results and coordination of care ")
 . d out("    "_"will be made by the LSS team.  ")
 ;d out("    "_"Scheduled by the LSS Coordinator:  ")
 ;d out("    "_"Best time and day:  ")
 ;d out("    "_"Best contact number:  ")
 ;d out(" ")
 ;d out(" ")
 ; clinical indication text
 i $$xval("siclin",vals)'="" d  ; there is some text
 . d out("Clinical Indications for Initial Screening CT:")
 . d out(" "_$$xval("siclin",vals))
 ;
 q 1
 ;
out(ln)
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
xval(var,vals) ; extrinsic returns the patient value for var
 ; vals is passed by name
 n zr
 s zr=$g(@vals@(var))
 ;i zr="" s zr="["_var_"]"
 q zr
 ;
 ;
