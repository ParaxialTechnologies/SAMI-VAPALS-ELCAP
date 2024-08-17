SAMICAS4 ;ven/gpl - case review cont ;2024-08-17t00:18z
 ;;18.0;SAMI;**17**;2024-08;
 ;;18-17
 ;
 ; SAMICAS4 contains ppis and other subroutines to support processing
 ; of the VAPALS-IELCAP case review page.
 ;
 ; See routine SAMICUL for development history
 ;
 quit  ; no entry from top
 ;
CLINSUM(sid) ; extrinsic returns a one line clinical summary
 ;
 ; The clinical information will include the information as follows:
 ; Age xx; [Asymptomatic for lung cancer]; Current Smoker; xx Pack Years
 ; Age xx; [Asymptomatic for lung cancer]; Former Smoker; xx Pack Years; Quit xx years ago
 ; If there is no background form - we should include a place-holder so the radiologist will know the information needs to be added
 ; If a followup form exists, the latest one is used instead of the background
 ;
 new clinstr ; the one line result
 set clinstr="[CHECK BACKGROUND - AGE/SMOKING HISTORY]" ; default if we fail
 ;
 n root,gn,ien,dob,age,fufail,smoker
 s smoker=""
 s root=$$setroot^%wd("vapals-patients")
 s ien=$o(@root@("sid",sid,""))
 q:ien="" clinstr
 s dob=@root@(ien,"dob")
 s age=$$AGE^SAMICAS4(dob)
 s fufail=1 ; default no followup forms found
 s gn=$na(@root@("graph",sid))
 ;
 ; this is where we will look for followup forms
 ;
 if fufail do  ; if no followup forms were found, use the background form
 . n sbform
 . s sbform=$o(@gn@("sbform")) ; key to form
 . n sbvars s sbvars=$na(@gn@(sbform))
 . i @sbvars@("sbsru")="n" d  ; never smoker
 . . s smoker="n"
 . . s clinstr=""
 . . s $p(clinstr,";",3)=" Never Smoker"
 . i @sbvars@("sbsru")="y" d  ; smoker
 . . i @sbvars@("sbshsa")="y" s smoker="c" ; current smoker
 . . i @sbvars@("sbshsa")="n" s smoker="f" ; former smoker
 . . i smoker="c" d  ; current smoker
 . . . s clinstr=""
 . . . s $p(clinstr,";",3)=" Current Smoker"
 . . i smoker="f" d  ; current smoker
 . . . s clinstr=""
 . . . s $p(clinstr,";",3)=" Former Smoker"
 . . . n sbsdlcd,sbsdlcm,sbsdlcy
 . . . s sbsdlcd=$g(@sbvars@("sbsdlcd"))
 . . . s sbsdlcm=$g(@sbvars@("sbsdlcm"))
 . . . s sbsdlcy=$g(@sbvars@("sbsdlcy"))
 . . . n sbopqy s sbopqy=$$YRSAGO(sbsdlcm,sbsdlcd,sbsdlcy)
 . . . s:sbopqy $p(clinstr,";",5)=" Quit "_sbopqy_" years ago"
 . . i clinstr[";" d  ;
 . . . n pkyrs s pkyrs=$g(@sbvars@("sbntpy"))
 . . . i +pkyrs>0 s $p(clinstr,";",4)=" "_pkyrs_" Pack Years"
 . i clinstr[";" d  ; 
 . . n aflc s aflc=" Asymptomatic for lung cancer"
 . . i $g(@sbvars@("sblcs"))="n" s $p(clinstr,";",2)=aflc
 . ;
 . ; carry over the Clinical information text from the background form
 . n savtxt s savtxt=$g(@sbvars@("sbopci"))
 . i savtxt'="" s clinstr=clinstr_$CHAR(13)_savtxt
 ;
 s $p(clinstr,";",1)="Age: "_age
 ;
 Q clinstr
 ;
AGE(dob) ; extrinsic derives the age from the dob
 i dob["-" s dob=$e(dob,6,7)_"/"_$e(dob,9,10)_"/"_$e(dob,1,4)
 i dob'["/" s dob=$e(dob,5,6)_"/"_$e(dob,7,8)_"/"_$e(dob,1,4)
 new X set X=dob
 new Y
 do ^%DT
 ;
 new age s age=$$age^%th(Y)
 ;
 quit age
 ;
YRSAGO(mo,da,yr) ; extrinsic which returns how many years ago was a date
 ;
 n dtdt,umo,uda,diff
 s:'mo mo=1
 s:'da da=1
 s dtdt=mo_"/"_da_"/"_yr
 n X,Y
 s X=dtdt
 d ^%DT
 ;w !,Y
 S diff=$$FMDIFF^XLFDT($$NOW^XLFDT,Y,1)/365
 S diff=$p(diff,".")
 Q diff
 ;