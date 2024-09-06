SAMICAS4 ;ven/gpl - case review sub library; 2024-09-03t22:53z
 ;;18.0;SAMI;**17**;2020-01-17;Build 8
 ;mdc-e1;SAMICAS4-20240903-E3rMewp;SAMI-18-17-b8
 ;mdc-v7;B106133479;SAMI*18.0*17 SEQ #17
 ;
 ; SAMICAS4 contains subroutines to support processing of the
 ; ScreeningPlus case review page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@license see routine SAMIUL
 ;@documentation see SAMICUL
 ;
 ;@contents
 ;
 ;  1. clinical summary subroutines:
 ; $$CLINSUM one-line clinical summary
 ; $$AGE patient age
 ; $$YRSAGO how many years ago was a date
 ;
 ;  2. other supplementary subroutines:
 ; $$BASELNDT last previous baseline ct date
 ; $$KEY2DT date to put in prior scans field
 ; $$PRIORCMP dates of all scans before last comparison scan
 ; SORTFRMS sorts all forms for patient sid by date
 ;
 ;  3. unused supplementary subroutine:
 ; $$PREVNOD key of latest form including nodule grid
 ;
 ;
 ;
 ;
 ;@section 1 clinical summary subroutines
 ;
 ;
 ;
 ;
 ;@func-code $$CLINSUM^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac?;??% tests;port?
 ;@called-by
 ; MKCEFORM^SAMICAS4
 ;@calls
 ; $$setroot^%wd
 ; $$AGE^SAMICAS4
 ; $$YRSAGO^SAMICAS4
 ;@input
 ; sid
 ;@output = clinical summary
 ;@tests [tbd]
 ;
 ; The clinical information will include the information as follows:
 ;
 ; Age xx; [Asymptomatic for lung cancer]; Current Smoker; xx Pack Years
 ;
 ; Age xx; [Asymptomatic for lung cancer]; Former Smoker; xx Pack Years; Quit xx years ago
 ;
 ; If there is no background form - we should include a place-holder
 ; so the radiologist will know the information needs to be added. If
 ; a followup form exists, the latest one is used instead of the
 ; background.
 ;
 ;
CLINSUM(sid) ; extrinsic returns a one-line clinical summary
 ;
 ;@stanza 2 init main vars
 ;
 ; one-line clinical summary, set default in case we fail
 n clinstr s clinstr="[CHECK BACKGROUND - AGE/SMOKING HISTORY]"
 ;
 n smoker s smoker=""
 n root s root=$$setroot^%wd("vapals-patients")
 n ien s ien=$o(@root@("sid",sid,""))
 q:ien="" clinstr
 n dob s dob=@root@(ien,"dob")
 n age s age=$$AGE^SAMICAS4(dob)
 n fufail s fufail=1 ; default no followup forms found
 n gn s gn=$na(@root@("graph",sid))
 ;
 ;
 ;@stanza 3 look for followup forms
 ;
 ; this is where we will look for followup forms
 ;
 ;
 ;@stanza 4 if no followup forms were found, use background form
 ;
 i fufail do
 . n sbform s sbform=$o(@gn@("sbform")) ; key to form
 . n sbvars s sbvars=$na(@gn@(sbform))
 . ;
 . i $g(@sbvars@("sbsru"))="n" d  ; never smoker
 . . s smoker="n"
 . . s clinstr=""
 . . s $p(clinstr,";",3)=" Never Smoker"
 . . q
 . ;
 . i $g(@sbvars@("sbsru"))="y" d  ; smoker
 . . i @sbvars@("sbshsa")="y" s smoker="c" ; current smoker
 . . i @sbvars@("sbshsa")="n" s smoker="f" ; former smoker
 . . i smoker="c" d  ; current smoker
 . . . s clinstr=""
 . . . s $p(clinstr,";",3)=" Current Smoker"
 . . . q
 . . ;
 . . i smoker="f" d  ; current smoker
 . . . s clinstr=""
 . . . s $p(clinstr,";",3)=" Former Smoker"
 . . . n sbsdlcd,sbsdlcm,sbsdlcy
 . . . s sbsdlcd=$g(@sbvars@("sbsdlcd"))
 . . . s sbsdlcm=$g(@sbvars@("sbsdlcm"))
 . . . s sbsdlcy=$g(@sbvars@("sbsdlcy"))
 . . . n sbopqy s sbopqy=$$YRSAGO^SAMICAS4(sbsdlcm,sbsdlcd,sbsdlcy)
 . . . s:sbopqy $p(clinstr,";",5)=" Quit "_sbopqy_" years ago"
 . . . q
 . . ;
 . . i clinstr[";" d  ; pack years
 . . . n pkyrs s pkyrs=$g(@sbvars@("sbntpy"))
 . . . i +pkyrs>0 s $p(clinstr,";",4)=" "_pkyrs_" Pack Years"
 . . . q
 . . q
 . ;
 . i clinstr[";" d  ; asymptomatic
 . . n aflc s aflc=" Asymptomatic for lung cancer"
 . . i $g(@sbvars@("sblcs"))="n" s $p(clinstr,";",2)=aflc
 . . q
 . ;
 . ; carry over Clinical information text from background form
 . n savtxt s savtxt=$g(@sbvars@("sbopci"))
 . i savtxt'="" s clinstr=clinstr_$CHAR(13)_savtxt
 . q
 ;
 ;
 ;@stanza 5 append age to clinical info
 ;
 i clinstr[";" s $p(clinstr,";",1)="Age: "_age
 ;
 ;
 ;@stanza 6 termination
 ;
 quit clinstr ; end of $$CLINSUM^SAMICAS4
 ;
 ;
 ;
 ;
 ;@func-code $$AGE^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac?;??% tests;port?
 ;@called-by
 ; $$CLINSUM^SAMICAS4
 ;@calls
 ; ^%DT
 ; $$age^%th
 ;@input
 ; dob = date of birth
 ;@output = patient age
 ;@tests [tbd]
 ;
 ;
AGE(dob) ; patient age
 ;
 ;@stanza 2 compute it
 ;
 ; extrinsic derives age from dob
 ;
 i dob["-" s dob=$e(dob,6,7)_"/"_$e(dob,9,10)_"/"_$e(dob,1,4)
 i dob'["/" s dob=$e(dob,5,6)_"/"_$e(dob,7,8)_"/"_$e(dob,1,4)
 new X set X=dob
 new Y
 do ^%DT
 ;
 new age s age=$$age^%th(Y)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit age ; end of $$AGE^SAMICAS4
 ;
 ;
 ;
 ;
 ;@func-code $$YRSAGO^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac?;??% tests;port?
 ;@called-by
 ; $$CLINSUM^SAMICAS4
 ;@calls
 ; ^%DT
 ; $$FMDIFF^XLFDT
 ; $$NOW^XLFDT
 ;@input
 ; dob = date of birth
 ;@output = patient age
 ;@tests [tbd]
 ;
 ;
YRSAGO(mo,da,yr) ; how many years ago was a date
 ;
 ; extrinsic which returns how many years ago was a date
 ;
 ;@stanza 2 compute it
 ;
 n umo,uda
 s:'mo mo=1
 s:'da da=1
 n dtdt s dtdt=mo_"/"_da_"/"_yr
 n X s X=dtdt
 n Y
 d ^%DT
 ;w !,Y
 n diff s diff=$piece($$FMDIFF^XLFDT($$NOW^XLFDT,Y,1)/365,".")
 ;
 ;
 ;@stanza 3 termination
 ;
 quit diff ; end of $$YRSAGO^SAMICAS4
 ;
 ;
 ;
 ;
 ;@section 2 other supplementary subroutines
 ;
 ;
 ;
 ;
 ;@func-code $$BASELNDT^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;??% tests;port?
 ;@called-by
 ; MKCEFORM^SAMICAS3
 ; MKFUFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; SELECT^SAMIUR
 ;@calls
 ; $$setroot^%wd
 ; GETITEMS^SAMICASE
 ; $$KEY2DSPD^SAMICAS2
 ;@input
 ; sid = study id
 ;@output = last previous baseline ct date
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
BASELNDT(sid) ; last previous baseline ct date
 ;
 ;@stanza 2 calculate last previous baseline ct date
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 new groot set groot=$name(@root@("graph",sid))
 new items set items=""
 do GETITEMS^SAMICASE("items",sid)
 quit:'$data(items) ""
 ;
 new bdate set bdate=""
 new bkey set bkey=""
 new done set done=0
 for  set bkey=$order(items("type","vapals:ceform",bkey)) quit:bkey=""  do  ;
 . ; write !,bkey," ",$get(@groot@(bkey,"cetex"))
 . if $get(@groot@(bkey,"cetex"))="b" do  ;
 . . set done=1
 . . set bdate=$piece(bkey,"ceform-",2)
 . . quit
 . quit
 set bdate=$$KEY2DSPD^SAMICAS2(bdate)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit bdate ; end of $$BASELNDT^SAMICAS4
 ;
 ;
 ;
 ;
 ;@func-code $$KEY2DT^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;??% tests;port?
 ;@called-by
 ; $$PRIORCMP^SAMICAS3
 ;@calls
 ; $$KEY2FM^SAMICASE
 ; $$VAPALSDT^SAMICASE
 ;@input
 ; key = form key, e.g. ctform-2021-05-25
 ;@output = date to put in prior scans field
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
KEY2DT(key) ; date to put in prior scans field
 ;
 ;@stanza 2 calculate prior scans date
 ;
 new retstr2 set retstr2=""
 new fmdt set fmdt=$$KEY2FM^SAMICASE(tmpkey2)
 set retstr2=$$VAPALSDT^SAMICASE(fmdt)_","_retstr2
 ;
 ;
 ;@stanza 3 termination
 ;
 quit retstr2 ; end of $$KEY2DT^SAMICAS4
 ;
 ;
 ;
 ;
 ;@func-code $$PRIORCMP^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;??% tests;port?
 ;@called-by
 ; MKCEFORM^SAMICAS3
 ; MKITFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ;@calls
 ; SORTFRMS^SAMICAS4
 ; $$NOW^XLFDT
 ; $$KEY2DT^SAMICAS4
 ; $$VAPALSDT^SAMICASE [commented out]
 ;@input
 ; sid = study id
 ;@output = dates of all scans before last comparison scan
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
PRIORCMP(sid) ; dates of all scans before last comparison scan
 ;
 ;@stanza 2 calculate dates of all scans before last comparison scan
 ;
 new retstr set retstr=""
 new lastcmp set lastcmp=""
 new fary
 do SORTFRMS^SAMICAS4(.fary,sid)
 ;
 ;new tdt set tdt=$piece($$NOW^XLFDT,".",1)+1 ; start with today
 new tdt set tdt=$piece($$NOW^XLFDT,".",1) ; start with before today
 for  set tdt=$order(fary(tdt),-1) quit:tdt=""  do  ; 
 . ;
 . if lastcmp="" do  ; first find the last comparison scan
 . . new tmpkey set tmpkey=""
 . . for  set tmpkey=$order(fary(tdt,tmpkey)) quit:tmpkey=""  quit:lastcmp'=""  do  ; 
 . . . if tmpkey["ceform" set lastcmp=tmpkey
 . . . quit
 . . quit
 . ;
 . do  ;
 . . ; next add all previous scans to retstr
 . . new tmpkey2 set tmpkey2=""
 . . for  set tmpkey2=$order(fary(tdt,tmpkey2)) quit:tmpkey2=""  do  ; 
 . . . if tmpkey2["ceform" do  ; convert to external date
 . . . . set retstr=$$KEY2DT^SAMICAS4(tmpkey2)_retstr
 . . . . quit
 . . . quit
 . . quit
 . quit
 ;
 if $extract(retstr,$length(retstr))="," do
 . set retstr=$extract(retstr,1,$length(retstr)-1)
 . quit
 ;
 ;if retstr="" set retstr=$$VAPALSDT^SAMICASE($$NOW^XLFDT)
 ;
 ;
 ;@stanza 3 termination
 ;
 quit retstr ; end of $$PRIORCMP^SAMICAS4
 ;
 ;
 ;
 ;
 ;@proc-code SORTFRMS^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac;??% tests;port?
 ;@called-by
 ; $$PREVNOD^SAMICAS4
 ; $$LASTCMP^SAMICAS3
 ; $$PRIORCMP^SAMICAS4
 ;@calls
 ; $$setroot^%wd
 ; ^%DT
 ; ^%ZTER
 ;@input
 ; sid = study id
 ;@output
 ; .ARY: sorted array of all forms for patient by date
 ;  ARY(fmdate,key)=""
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
SORTFRMS(ARY,sid) ; sorts all forms for patient sid by date
 ;
 ;@stanza 2 sort patient's forms by date
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 quit:'$data(@root@("graph",sid))
 new froot set froot=$name(@root@("graph",sid))
 ;
 new zi set zi=""
 for  set zi=$order(@froot@(zi)) quit:zi=""  do  ;
 . new ftype set ftype=$piece(zi,"-",1)
 . new fdate set fdate=$piece(zi,ftype_"-",2)
 . new X,Y
 . set X=fdate
 . do ^%DT
 . if Y=-1 do ^%ZTER quit  ;
 . set ARY(Y,zi)=""
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of SORTFRMS^SAMICAS4
 ;
 ;
 ;
 ;
 ;@section 3 unused supplementary subroutine
 ;
 ;
 ;
 ;
 ;@func-code $$PREVNOD^SAMICAS4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;function;clean;silent;sac;??% tests;port?
 ;@called-by none [commented out in MKCEFORM,MKPTFORM,MKBXFORM]
 ;@calls
 ; SORTFRMS^SAMICAS4
 ;@input
 ; sid = study id
 ;@output = key of latest form incl nodule grid
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; used for nodule copy
 ;
 ;
PREVNOD(sid) ; key of latest form including nodule grid
 ;
 ;@stanza 2 calculate key of latest form incl nodule grid
 ;
 new retkey set retkey=""
 new fary
 do SORTFRMS^SAMICAS4(.fary,sid)
 ;
 new tdt set tdt=""
 for  set tdt=$order(fary(tdt),-1) quit:tdt=""  quit:retkey'=""  do  ; 
 . new tmpkey set tmpkey=""
 . for  set tmpkey=$order(fary(tdt,tmpkey)) quit:tmpkey=""  quit:retkey'=""  do  ; 
 . . if tmpkey["ceform" set retkey=tmpkey
 . . if tmpkey["ptform" set retkey=tmpkey
 . . if tmpkey["bxform" set retkey=tmpkey
 . . quit
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit retkey ; end of $$PREVNOD^SAMICAS4
 ;
 ;
 ;
 ;
EOR ; end of routine SAMICAS4
