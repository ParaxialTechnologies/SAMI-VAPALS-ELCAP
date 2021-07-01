SAMIJS1 ;ven/gpl - json archive export ;2021-07-01T16:58Z
 ;;18.0;SAMI;**8,12**;2020-01;Build 4
 ;;1.18.0.12-t2+i12
 ;
 ; Routine SAMIJS1 contains subroutines for exporting VAPALS-ELCAP
 ; JSON archives, which are used for import, export, & migration of
 ; SAMI data.
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
 ;@last-updated 2021-07-01T16:58Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t2+i12
 ;@release-date 2020-01
 ;@patch-list **8,12**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2020-12-11 ven/gpl 1.18.0.8+i8 0c73272b,92138cdb
 ;  SAMIJS1 initial data migration export, add DETAIL^SAMIJS1 for
 ; debugging.
 ;
 ; 2021-05-29 ven/gpl 1.18.0.12-t2+i12 0a3b184f
 ;  SAMIJS1,SAMIJS2 update data migration routines; new SAMIJS2.
 ;
 ; 2021-07-01 ven/mcglk&toad 1.18.0.12-t2+i12
 ;  SAMIJS1,SAMIJS2 bump version & dates, add hdr comments & dev log.
 ;
 ;@contents
 ; EN ???
 ; EXSITE ???
 ; $$dfn2lien lookup ien of patient dfn
 ; $$dfn2pien patient graph ien of patient dfn
 ; $$getaien ien for patient dfn in vapals-archive
 ; mkarch create archive record for patient dfn
 ; outarch write archive record to external file
 ; DETAIL display archive record for patient
 ; 
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
EN ;
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
 ;
 ;
EXSITE ;
 n site,dfn,pat
 s site=$$PICSITE^SAMIMOV()
 q:site="^"
 n lroot,proot,aroot
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 s aroot=$$setroot^%wd("vapals-archive")
 n dfn,lien s dfn=""
 f  s dfn=$o(@lroot@("dfn",dfn)) q:+dfn=0  d  ;
 . s lien=$o(@lroot@("dfn",dfn,""))
 . i $g(@lroot@(lien,"siteid"))'=site q  ;
 . d mkarch(dfn)
 . d outarch(dfn)
 q
 ;
 ;
 ;
dfn2lien(dfn) ; extrinsic return the lookup ien of patient dfn
 n lroot,lien
 s lroot=$$setroot^%wd("patient-lookup")
 s lien=$o(@lroot@("dfn",dfn,""))
 q lien
 ;
 ;
 ;
dfn2pien(dfn) ; extrinsic return the patient graph ien of patient dfn
 n proot,pien
 s proot=$$setroot^%wd("vapals-patients")
 s pien=$o(@proot@("dfn",dfn,""))
 q pien
 ;
 ;
 ;
getaien(dfn) ; returns the ien for patient dfn in vapals-archive
 ; is laygo
 n aroot s aroot=$$setroot^%wd("vapals-archive")
 n aien
 s aien=$o(@aroot@(" "),-1)+1
 q aien
 ;
 ;
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
 s aien=$o(@aroot@("dfn",dfn,""))
 i aien'="" d  ;
 . k @aroot@(aien)
 i aien="" s aien=$$getaien(dfn)
 w !,"aien=",aien
 ;
 m @aroot@(aien,"patient","lookup")=@lroot@(lien)
 s @aroot@("dfn",dfn,aien)=""
 ;
 n sid s sid=""
 d:pien'=""
 . m @aroot@(aien,"patient","demos")=@proot@(pien)
 . s sid=$g(@proot@(pien,"samistudyid"))
 . i sid="" s sid=$g(@proot@(pien,"sisid"))
 . q:sid=""
 . m @aroot@(aien,"patient","graph")=@proot@("graph",sid)
 ;
 q
 ;
 ;
 ;
outarch(dfn) ; write out an archive record to an external file
 n aroot s aroot=$$setroot^%wd("vapals-archive")
 n aien s aien=$o(@aroot@("dfn",dfn,""),-1)
 q:aien=""
 ;
 n sid s sid=$g(@aroot@(aien,"patient","demos","samistudyid"))
 n tmpout s tmpout=$na(^TMP("VAPALS-ARCH",$J))
 k @tmpout
 n arec s arec=$na(@aroot@(aien))
 d encode^%webjson(arec,tmpout)
 ;
 n adir,fname
 s adir="/home/osehra/www/archive"
 s fname="vapals-"_sid_"-"_dfn_"-"_DT_".json"
 i $$GTF^%ZISH($NA(@tmpout@(1)),3,adir,fname) d  ;
 . w !,"file "_fname_" written to "_adir
 ;
 q
 ;
 ;
 ;
DETAIL() ; displays the archive record for a patient
 ;
 n site,dfn,pat
 s site=$$PICSITE^SAMIMOV()
 q:site="^"
 d PICPAT^SAMIMOV(.pat,site)
 w "   ",$g(pat("name"))
 s dfn=$g(pat("dfn"))
 w !,"dfn=",dfn
 q:dfn=""
 n aroot ; archive root
 s aroot=$$setroot^%wd("vapals-archive")
 d mkarch(dfn)
 n aien
 s aien=$o(@aroot@("dfn",dfn,""))
 i aien="" d  q  ;
 . w !,"patient not found in archive"
 n groot
 s groot=$na(@aroot@(aien))
 n OUT s OUT=$na(^TMP("SAMIOUT",$J))
 k @OUT
 D GTREE^SYNVPR(groot,9,,,OUT)
 D BROWSE^DDBR(OUT,"N","Patient")
 k @OUT
 q
 ;
 ;
 ;
EOR ; end of routine SAMIJS1
