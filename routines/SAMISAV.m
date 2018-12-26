SAMISAV ;ven/gpl - SAMI save routines ; 12/11/18 9:10am
 ;;18.0;SAM;;
 ;
 ; 
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
SAVFILTR(sid,form,vars) ; extrinsic which returns the form key to use
 ; for saving. It will relocate the graph for the form if required based
 ; on dates entered on the form.
 ; 
 n useform s useform=form ; by default, the form is unchanged
 n root s root=$$setroot^%wd("vapals-patients")
 n type s type=$p(form,"-",1)
 ;
 if type="ceform" d  ; ct evaluation form
 . m ^SAMIGPL("samisav","vals")=vars
 . n formdate s formdate=$g(vars("cedos")) ; date of the CT scan from the form
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICAS2(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICAS2(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="ceform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIGPL("samisav")
 . . s ^SAMIGPL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIGPL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIGPL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m ^SAMIGPL("samisav","vals")=vars
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto 
 if type="siform" d  ; intake form
 . s vars("samifirsttime")="false"
 . n formdate s formdate=$g(vars("sidc")) ; date of the CT scan from the form
 . q:formdate=""
 . n fdate s fdate=$$KEY2FM^SAMICAS2(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$KEY2FM^SAMICAS2(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="siform-"_$$KEYDATE^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^SAMIGPL("samisav")
 . . s ^SAMIGPL("samisav","current")=form_"^"_fmcurrent
 . . s ^SAMIGPL("samisav","incoming")=formdate_"^"_fdate
 . . s ^SAMIGPL("samisav","conclusion")="graph must be moved to: "_moveto
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto 
 q useform
 ;
