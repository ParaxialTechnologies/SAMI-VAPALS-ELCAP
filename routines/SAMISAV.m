SAMISAV ;ven/gpl - SAMI save routines ; 2/14/19 12:10pm
 ;;18.0;SAM;;;Build 11
 ;
 ;@license: see routine SAMIUL
 ; 
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
SAVFILTR(sid,form,vars) ; extrinsic which returns the form key to use
 ; for saving. It will relocate the graph for the form if required based
 ; on dates entered on the form.
 ; 
 ; processing for multi-tenancy
 ;   if siteid is not provided, but studyid is provided
 ;   look up and set siteid
 ;
 if '$d(vars("siteid")) d  ;
 . if $g(sid)="" q
 . n sym s sym=$e(sid,1,3) ; first 3 chars in studyid
 . i $$SITENM2^SAMISITE(sym)=-1 q
 . s vars("siteid")=sym
 . s vars("site")=sym
 ;
 n useform s useform=form ; by default, the form is unchanged
 n root s root=$$setroot^%wd("vapals-patients")
 n type s type=$p(form,"-",1)
 ;
 if type="ceform" d  ; ct evaluation form
 . m ^SAMIUL("samisav","vals")=vars
 . n formdate s formdate=$g(vars("cedos")) ; date of the CT scan from the form
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICASE(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICASE(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="ceform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIUL("samisav")
 . . s ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m ^SAMIUL("samisav","vals")=vars
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto
 if type="fuform" d  ; followup form
 . m ^SAMIUL("samisav","vals")=vars
 . n formdate s formdate=$g(vars("sidof")) ; date of the CT scan from the form
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICASE(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICASE(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="fuform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIUL("samisav")
 . . s ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m ^SAMIUL("samisav","vals")=vars
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto
 if type="siform" d  ; intake form
 . s vars("samifirsttime")="false"
 . d COMLOG(.sid,.form,.vars) ; add to the communication log
 . n formdate s formdate=$g(vars("sidc")) ; date of the CT scan from the form
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICASE(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICASE(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="siform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIUL("samisav")
 . . s ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto
 if type="bxform" d  ; intake form
 . n formdate s formdate=$g(vars("bxdos")) ; date of the biopsy from the form
 . i formdate="" s formdate=$g(vars("rbmed")) ; date of mediastinoscopy
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICASE(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICASE(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="bxform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIUL("samisav")
 . . s ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto
 if type="itform" d  ; intervention form
 . n formdate s formdate=$g(vars("rbsud")) ; treatment date
 . i formdate="" s formdate=$g(vars("rbdos")) ; date of first intervention
 . i formdate="" s formdate=$g(vars("rbdmr")) ; date of latest intervention
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICASE(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICASE(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="itform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIUL("samisav")
 . . s ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto
 if type="ptform" d  ; intervention form
 . n formdate s formdate=$g(vars("ptdos")) ; treatment date
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICASE(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICASE(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="ptform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIUL("samisav")
 . . s ^SAMIUL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIUL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIUL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto
 q useform
 ;
COMLOG(sid,form,vars) ; add to the communications log
 n root s root=$$setroot^%wd("vapals-patients")
 m vars("comlog")=@root@("graph",sid,form,"comlog")
 n COMLOGRT
 s COMLOGRT=$na(@root@("graph",sid,form,"comlog"))
 i $g(vars("sipcrn"))'="" d  ; a new comm log entry is available
 . d LOGIT^SAMICLOG(COMLOGRT,vars("sipcrn"))
 . s vars("sipcrn")=""
 q
 ;
