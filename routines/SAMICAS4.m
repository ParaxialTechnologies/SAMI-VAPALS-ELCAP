SAMICAS4 ;ven/gpl - case review cont ;2021-10-26t19:39z
 ;;18.0;SAMI;**3,9,11,12,15**;2020-01;Build 11
 ;;18-15
 ;
 ; SAMICAS4 contains ppis and other subroutines to support processing
 ; of the VAPALS-IELCAP case review page.
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
 . . s $p(clinstr,";",3)="Never Smoker"
 . i @sbvars@("sbsru")="y" d  ; smoker
 . . i @sbvars@("sbshsa")="y" s smoker="c" ; current smoker
 . . i @sbvars@("sbshsa")="n" s smoker="f" ; former smoker
 . . i smoker="c" d  ; current smoker
 . . . s clinstr=""
 . . . s $p(clinstr,";",3)="Current Smoker"
 . . i smoker="f" d  ; current smoker
 . . . s clinstr=""
 . . . s $p(clinstr,";",3)="Former Smoker"
 ;
 s $p(clinstr,";",1)="Age: "_age
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