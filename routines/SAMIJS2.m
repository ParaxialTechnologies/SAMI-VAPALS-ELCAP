SAMIJS2 ;ven/gpl - json archive import ;2021-07-01t17:08z
 ;;18.0;SAMI;**12**;2020-01;
 ;;1.18.0.12-t3+i12
 ;
 ; Routine SAMIJS2 contains more subroutines for importing VAPALS-
 ; ELCAP JSON archives, which are used for import, export, & migration
 ; of SAMI data.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-07-01t17:08z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t3+i12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; see routine SAMIJS1 for dev log.
 ;
 ;@contents
 ; FILE load files from file system
 ; wsPostSAMI accept incoming SAMI record in VAPALS
 ; $$loaded is filename already loaded?
 ; 
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
FILE(directory) ; [Public] Load files from the file system; OPT: SAMI LOAD FILES
 ;
 if '$data(directory) do
 . N DIR,X,Y,DA,DIRUT,DTOUT,DUOUT,DIROUT
 . S DIR(0)="F^0:1024"
 . S DIR("A")="Enter directory from which to load Patients"
 . D ^DIR
 . W !
 . if '$data(DIRUT) set directory=Y
 quit:'$data(directory)
 ;
 ; Load files from directory
 new samifiles
 new samimask set samimask("*.json")=""
 new % set %=$$LIST^%ZISH(directory,$na(samimask),$na(samifiles))
 if '% write "Failed to read any files. Check directory.",! quit
 ;
 new file set file=""
 for  set file=$order(samifiles(file)) q:file=""  do
 . if file["Information" quit  ; We don't process information files yet...
 . ;
 . write "Loading ",file,"...",!
 . if $$loaded(file) d  q  ;
 .. w "already loaded, skipping "_file,!
 . ;
 . kill ^TMP("SAMIFILE",$J)
 . new % set %=$$FTG^%ZISH(directory,file,$name(^TMP("SAMIFILE",$J,1)),3)
 . i '% write "Failed to read the file. Please debug me.",! quit
 . ;
 . ; Normalize overflow nodes (and hope for the best that we don't go over 32k)
 . new i,j set (i,j)=""
 . for  set i=$order(^TMP("SAMIFILE",$J,i)) quit:'i  for  set j=$order(^TMP("SAMIFILE",$J,i,"OVF",j)) quit:'j  do
 .. set ^TMP("SAMIFILE",$J,i)=^TMP("SAMIFILE",$J,i)_^TMP("SAMIFILE",$J,i,"OVF",j)  ; ** NOT TESTED **
 . ;
 . ; Now load the file into Vapals
 . write "Ingesting ",file,"...",!
 . ;
 . do
 .. new samifiles,file,directory
 .. do KILL^XUSCLEAN ; VistA leaks like hell
 . ;
 . new root set root=$$setroot^%wd("vapals-intake")
 . new ien set ien=$order(@root@(" "),-1)+1
 . new gr set gr=$name(@root@(ien,"json"))
 . do decode^%webjson($na(^TMP("SAMIFILE",$J)),gr)
 . set @root@("file",file,ien)=""
 . new args,samijsonreturn
 . new % set %=$$wsPostSAMI(.args,,.samijsonreturn,ien) ; ignore % which always comes out at 1
 . ;
 . ; Get the status back from JSON
 . new samireturn,samijsonerror
 . do decode^%webjson($na(samijsonreturn),$na(samireturn),$na(samijsonerror))
 . if $data(samijsonerror) write "There is an error decoding the return. Debug me." quit
 . ;
 . q:'$d(samireturn)
 . if $get(samireturn("loadMessage"))["Duplicate" write "Patient Already Loaded",! quit
 . n errmsg s errmsg=$get(samireturn("loadMessage"))
 . if errmsg["Error" d  q  ;
 . . write errmsg,!
 . write " ",errmsg,!
 . ;
 . write " Loaded with following data: ",!
 . write "DFN: ",$g(samireturn("dfn")),?15,"STUDYID: ",$g(samireturn("sid")),?25," LIEN: ",$g(samireturn("ien")),?50,"Name: ",$g(samireturn("name")),!
 . write "--------------------------------------------------------------------------",!
 . ;b
 q
 ;
 ;
 ;
wsPostSAMI(args,body,return,ien) ; accept incoming SAMI record in VAPALS
 ;
 n rtn
 n lroot,proot,iroot
 s iroot=$$setroot^%wd("vapals-intake")
 s proot=$$setroot^%wd("vapals-patients")
 s lroot=$$setroot^%wd("patient-lookup")
 n lien,pien,grloaded,dfn,sid
 s (lien,pien,grloaded)=0
 i '$d(@iroot@(ien,"json","patient","lookup")) d  q  ;
 . s rtn("loadMessage")="Error, patient lookup missing"
 . d encode^%webjson("rtn","return","zerr")
 ; so, what is the dfn.. it is the number for this patient on this system
 ;s dfn=$g(@iroot@(ien,"json","patient","lookup","dfn"))
 ;i dfn="" d  q  ;
 ;. s rtn("loadMessage")="Error, dfn missing"
 ;. d encode^%webjson("rtn","return","zerr")
 ;n newdfn s newdfn=0
 ;i $d(@lroot@("dfn",dfn)) d  ; oops need a new dfn for this system
 ;. s dfn=$o(@lroot@("dfn"," "),-1)+1
 ;. s newdfn=1 ; remember to propogate the new dfn
 s dfn=$o(@lroot@("dfn"," "),-1)+1
 i $o(@proot@("dfn"," "),-1)+1>dfn s dfn=$o(@proot@("dfn"," "),-1)+1
 s rtn("dfn")=dfn
 i '$d(@lroot@(dfn)) s lien=dfn
 e  s lien=$o(@lroot@(" "),-1)+1
 s rtn("ien")=lien
 ;i newdfn=1 s @lroot@(lien,"dfn")=dfn
 n name s name=$g(@iroot@(ien,"json","patient","lookup","saminame"))
 i name="" d  q  ;
 . s rtn("loadMessage")="Error, name missing"
 . d encode^%webjson("rtn","return","zerr")
 s rtn("name")=name
 m @lroot@(lien)=@iroot@(ien,"json","patient","lookup")
 s @lroot@(lien,"dfn")=dfn
 d INDXPTLK^SAMIHOM4(lien)
 ;
 ; detect if enrolled
 ;
 i '$d(@iroot@(ien,"json","patient","demos")) d  q  ;
 . s rtn("loadMessage")="Load sucessful, not enrolled"
 . d encode^%webjson("rtn","return","zerr")
 ; 
 ; determine pien in vapals-patients
 ;
 ;i '$d(@proot@(dfn)) s pien=dfn
 ;e  s pien=$$NEXTNUM^SAMIHOM3()
 s pien=$$NEXTNUM^SAMIHOM3()
 m @proot@(pien)=@iroot@(ien,"json","patient","demos")
 s @proot@("dfn",dfn,pien)=""
 ;i newdfn s @proot@(pien,"dfn")=dfn
 s @proot@(pien,"dfn")=dfn
 ;
 ; determine studyid (sid)
 ;
 n sid s sid=$g(@proot@(pien,"samistudyid"))
 i sid="" d  q  ;
 . s rtn("loadMessage")="Error, studyid missing"
 . d encode^%webjson("rtn","return","zerr")
 i $d(@proot@("sid",sid)) d  q  ; opps we need a new sid for this system
 . s rtn("loadMessage")="Error, studyid is not unique"
 . d encode^%webjson("rtn","return","zerr")
 s rtn("sid")=sid
 s @proot@("sid",sid,pien)=""
 ;
 ; merge in all the forms
 ;
 m @proot@("graph",sid)=@iroot@(ien,"json","patient","graph")
 ;
 ; encode the successful return
 ;
 s rtn("loadMessage")="Load successful, enrolled"
 d encode^%webjson("rtn","return","zerr")
 q
 ;
 ;
 ;
loaded(filenm,graph) ;extrinsic returns 1 if the filename is already loaded
 ; in the graph default for graph is vapals-intake
 if $g(graph)="" s graph="vapals-intake"
 n tmproot s tmproot=$$setroot^%wd(graph)
 i $d(@tmproot@("file",filenm)) q 1
 q 0
 ;
 ;
 ;
EOR ; end of routine SAMIJS2
