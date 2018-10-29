SAMISAV ;ven/gpl - SAMI save routines ;2018-03-08T17:53Z
 ;;18.0;SAM;;
 ;
 ; 
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
saveFilter(sid,form,vars) ; extrinsic which returns the form key to use
 ; for saving. It will relocate the graph for the form if required based
 ; on dates entered on the form.
 ; 
 n useform s useform=form ; by default, the form is unchanged
 n root s root=$$setroot^%wd("vapals-patients")
 n type s type=$p(form,"-",1)
 ;
 if type="ceform" d  ; ct evaluation form
 . n formdate s formdate=$g(vars("cedos")) ; date of the CT scan from the form
 . q:formdate=""
 . n fdate s fdate=$$key2fm^SAMICAS2(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$key2fm^SAMICAS2(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="ceform-"_$$keyDate^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^gpl("samisav")
 . . s ^gpl("samisav","current")=form_"^"_fmcurrent
 . . s ^gpl("samisav","incoming")=formdate_"^"_fdate
 . . s ^gpl("samisav","conclusion")="graph must be moved to: "_moveto
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto 
 if type="siform" d  ; intake form
 . n formdate s formdate=$g(vars("sidc")) ; date of the CT scan from the form
 . q:formdate=""
 . n fdate s fdate=$$key2fm^SAMICAS2(formdate) ; convert to fileman date
 . q:fdate=""
 . q:fdate<0
 . n fmcurrent s fmcurrent=$$key2fm^SAMICAS2(form) ; current key in fm formate
 . if fdate'=fmcurrent d  ;
 . . n moveto s moveto="siform-"_$$keyDate^SAMIHOM3(fdate)
 . . ;w !,"old: ",fmcurrent," new: ",fdate," ... date must be changed
 . . k ^gpl("samisav")
 . . s ^gpl("samisav","current")=form_"^"_fmcurrent
 . . s ^gpl("samisav","incoming")=formdate_"^"_fdate
 . . s ^gpl("samisav","conclusion")="graph must be moved to: "_moveto
 . . m @root@("graph",sid,moveto)=@root@("graph",sid,form)
 . . k @root@("graph",sid,form)
 . . s useform=moveto 
 q useform
 ;
 
