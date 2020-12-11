SAMIJS1 ;ven/gpl - json archive routine ; 1/22/19 1:24pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ;
EN
 n site,dfn,pat
 s site=$$PICSITE^SAMIMOV()
 q:site="^"
 d PICPAT^SAMIMOV(.pat,site)
 w "   ",$g(pat("name"))
 s dfn=$g(pat("dfn"))
 w !,"dfn=",dfn
 d mkarch(dfn)
 d outarch(dfn)
 q
 ;
dfn2lien(dfn) ; extrinsic return the lookup ien of patient dfn
 n lroot,lien
 s lroot=$$setroot^%wd("patient-lookup")
 s lien=$o(@lroot@("dfn",dfn,""))
 q lien
 ;
dfn2pien(dfn) ; extrinsic return the patient graph ien of patient dfn
 n proot,pien
 s proot=$$setroot^%wd("vapals-patients")
 s pien=$o(@proot@("dfn",dfn,""))
 q pien
 ;
getaien(dfn) ; returns the ien for patient dfn in vapals-archive
 ; is laygo
 n aroot s aroot=$$setroot^%wd("vapals-archive")
 n aien
 s aien=$o(@aroot@(" "),-1)+1
 q aien
 ;
mkarch(dfn) ; create an archive record for patient dfn
 n lroot,proot,aroot
 n lien,pien,aien
 s lroot=$$setroot^%wd("patient-lookup")
 w !,"patient-lookup: ",lroot
 s proot=$$setroot^%wd("vapals-patients")
 w !,"vapals-patients: ",proot
 s aroot=$$setroot^%wd("vapals-archive")
 w !,"vapals-archive: ",aroot
 ;
 s lien=$$dfn2lien(dfn)
 w !,"lien=",lien
 s pien=$$dfn2pien(dfn)
 w !,"pien=",pien
 ;
 i lien="" d  q  ;
 . w !,"error, lookup ien not found for patient dfn=",dfn
 ;
 s aien=$$getaien(dfn)
 w !,"aien=",aien
 ;
 m @aroot@(aien,"patient","lookup")=@lroot@(lien)
 s @aroot@("dfn",dfn,aien)=""
 ;
 n sid s sid=""
 d:pien'=""
 . m @aroot@(aien,"patient","demos")=@proot@(pien)
 . s sid=$g(@proot@(pien,"studyid"))
 . q:sid=""
 . m @aroot@(aien,"patient","graph")=@proot@("graph",sid)
 ;
 q
 ;
outarch(dfn) ; write out an archive record to an external file
 n aroot s aroot=$$setroot^%wd("vapals-archive")
 n aien s aien=$o(@aroot@("dfn",dfn,""),-1)
 q:aien=""
 ;
 n tmpout s tmpout=$na(^TMP("VAPALS-ARCH",$J))
 k @tmpout
 n arec s arec=$na(@aroot@(aien))
 d encode^%webjson(arec,tmpout)
 ;
 n adir,fname
 s adir="/home/osehra/www/archive"
 s fname="vapals-"_dfn_"-"_DT_".json"
 i $$GTF^%ZISH($NA(@tmpout@(1)),3,adir,fname) d  ;
 . w !,"file "_fname_" written to "_adir
 ;
 q
 ;
  