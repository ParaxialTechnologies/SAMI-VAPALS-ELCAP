SAMIPTLK ;ven/gpl - patient lookup; 2024-09-10t02:12z
 ;;18.0;SAMI;**5,7,18**;2020-01-17;
 ;mdc-e1;SAMIPTLK-20240910-E3bjqxe;SAMI-18-18-b1
 ;mdc-v7;B50934240;SAMI*18.0*18 SEQ #18
 ;
 ; SAMIPTLK contains web services and subroutines to support the
 ; lookup of patients in ScreeningPlus.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;
 ;@routine-credits
 ;
 ;@dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2018/2024, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@update 2024-09-10t02:12z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-18
 ;@edition-date 2020-01-17
 ;@patches **5,7,18**
 ;
 ;@dev-add Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; linda.yaw@vistaexpertise.net
 ;@dev-add Larry G. Carlson (lgc)
 ; larry.g.carlson@gmail.com
 ;@dev-add Alexis R. Carlson (arc)
 ; whatisthehumanspirit@gmail.com
 ;
 ;@module-credits
 ;
 ;@project VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding 2017/2021, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org Paraxial Technologies (par)
 ; http://paraxialtech.com/
 ;@partner-org Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@project I-ELCAP AIRS Automated Image Reading System
 ; https://www.ielcap-airs.org
 ;@funding 2024, Mt. Sinai Hospital (msh)
 ;@partner-org par
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2020-01-16 ven/lgc 18-0 0a2af965
 ;  SAMIPTLK (F1Y8RNE B9242590 EJomiC)
 ; Bulk commit due to switch to Cache.
 ;
 ; 2020-04-11 ven/gpl 18-5 2f2c29c1
 ;  SAMIPTLK (F1jn7RT B10261104 EVRktE)
 ; the crux of multi-tenancy.
 ;
 ; 2020-04-11 ven/gpl 18-5 d895cd7a
 ;  SAMIPTLK (FCOM8k B10220412 E2+2jaV)
 ; turn off debugging call.
 ;
 ; 2020-08-24 ven/gpl 18-7 135e8fdf
 ;  SAMIPTLK (F1%FgrV B11168340 E3CdCfT)
 ; utility to change patient site.
 ;
 ; 2024-09-07 ven/gpl 18-18-b1 e6fdd47d
 ;  SAMIPTLK (F1Cgyfq B15734046 E2Q2QC2)
 ; mrn lookup + display working.
 ;
 ; 2024-09-10 ven/toad 18-18-b1
 ;  SAMIPTLK (F??? B50934240 E???)
 ; add hdr + subrtn hdr comments, log, bump version + dates.
 ;
 ;@to-do
 ;
 ; fill in log before 18-18, add details
 ;
 ;@contents
 ;
 ; WSPTLOOK patient lookup
 ; WSPTLKUP patient lookup from patient-lookup cache
 ; BUILDRTN build patient-lookup return value
 ;
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
 ;
 ;@ws-code WSPTLOOK
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ws;procedure;silent;clean?;sac?;tests?;port?
 ;@called-by [tbd]
 ;@calls
 ; SELECT^HMPPTRPC
 ; ENCODE^VPRJSON
 ;@input
 ; filter
 ;@output
 ; .rtn
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
WSPTLOOK(rtn,filter) ; patient lookup
 ;
 ;@stanza 2 lookup
 ;
 n search s search=$g(filter("search"))
 n rslt
 d SELECT^HMPPTRPC(.rslt,"NAME",search)
 i $d(rslt) d  ;
 . d ENCODE^VPRJSON("rslt","rtn")
 . q
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of ws WSPTLOOK
 ;
 ;
 ;
 ;
 ;@ws-code WSPTLKUP
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;ws;procedure;silent;clean?;sac?;tests?;port?
 ;@called-by [tbd]
 ;@calls
 ; $$setroot^%wd
 ; $$UPCASE^XLFMSMT
 ; BUILDRTN
 ;@input
 ; filter
 ;@output
 ; .rtn
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;
WSPTLKUP(rtn,filter) ; patient lookup from patient-lookup cache
 ;
 ;@stanza 2 setup
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 n search s search=$g(filter("search"))
 n limit s limit=$g(filter("limit"))
 n site s site=$g(filter("site"))
 ;m ^gpl("ptlkup")=filter ;
 q:site=""
 i limit="" s limit=1000
 s search=$$UPCASE^XLFMSMT(search)
 n rslt
 n cnt s cnt=0
 n gn s gn=$na(@root@("name"))
 n p1,p2
 s p1=$p(search,",",1)
 s p2=$p(search,",",2)
 ;
 ;
 ;@stanza 3 try bs5 lookup
 ;
 i $l(search)=5 i +$e(search,2,5)>0 d  ;q  ; using last5
 . n gn2 s gn2=$na(@root@("last5"))
 . n ii s ii=""
 . f  s ii=$o(@gn2@(search,ii)) q:ii=""  q:cnt=limit  d  ;
 . . i $g(@root@(ii,"siteid"))'=site q
 . . s cnt=cnt+1
 . . s rslt(cnt,ii)=""
 . . q
 . i cnt>0 d  ;
 . . d BUILDRTN(.rtn,.rslt,$g(filter("format")))
 . . q
 . q
 ;
 ;
 ;@stanza 4 try partial-match lookup
 ;
 n have s have=""
 n q1 s q1=$na(@gn@(p1))
 n q1x s q1x=$e(q1,1,$l(q1)-1) ; removes the )
 i $e(q1x,$l(q1x))="""" s $e(q1x,$l(q1x))=""
 n qx s qx=q1
 f  s qx=$q(@qx) q:$p(qx,q1x,2)=""  q:cnt=limit  d  ;
 . n exit s exit=0
 . i p2'="" d  ;
 . . i p2'=$e($p(qx,",",5),1,$l(p2)) s exit=1
 . . q
 . q:exit
 . n qx2 s qx2=+$p(qx,",",6)
 . i $g(@root@(qx2,"siteid"))'[site q  ;
 . i $d(have(qx2)) q  ; already got this one
 . s cnt=cnt+1
 . s have(qx2)=""
 . s rslt(cnt,qx2)="" ; the ien
 . ;w !,qx," ien=",$o(rslt(cnt,""))
 . q
 ;
 ;
 ;@stanza 5 try emrn lookup
 ;
 s gn3=$na(@root@("emrn"))
 s q1="e"_p1
 ;
 ;f  s q1=$o(@gn3@(q1)) q:$p(q1,"e"_p1,2)=""  q:cnt=limit  d  ;
 ;f  s q1=$o(@gn3@(q1)) q:q1'[("e"_p1)  q:cnt=limit  d  ;
 f  d:$d(@gn3@(q1))  s q1=$o(@gn3@(q1)) q:q1=""  q:$p(q1,"e"_p1)]""  q:cnt=limit  ;d  ;
 . n lien
 . s lien=$o(@gn3@(q1,"")) ; selection ien
 . ;W !,"q1= ",q1
 . i $g(@root@(lien,"siteid"))'[site q  ;
 . i $d(have(lien)) q  ; already got this one
 . s cnt=cnt+1
 . s have(lien)=""
 . s rslt(cnt,lien)="" ; the ien
 . ;w !,q1," ien=",$o(rslt(cnt,""))
 . q
 ;
 ;
 ;@stanza 6 build results return value
 ;
 i cnt>0 d BUILDRTN(.rtn,.rslt,$g(filter("format")))
 ;
 ;
 ;@stanza 7 termination
 ;
 quit  ; end of ws WSPTLKUP
 ;
 ;
 ;
 ;
 ;@proc BUILDRTN
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;silent;clean?;sac?;tests?;port?
 ;@called-by
 ; WSPTLKUP
 ;@calls
 ; ^ZTER (commented out)
 ; $$setroot^%wd
 ; $$GETUID^SAMIUID
 ; ENCODE^VPRJSON
 ;@input
 ; ary
 ; format
 ;@output
 ; .rtn
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; build return json unless format=array, then return a mumps array
 ;
 ;
BUILDRTN(rtn,ary,format) ; build patient-lookup return value
 ;
 ;
 ;@stanza 2 setup
 ;
 ;d ^ZTER
 n root s root=$$setroot^%wd("patient-lookup")
 n groot s groot=$$setroot^%wd("vapals-patients")
 n zi s zi=""
 n r1 s r1=""
 ;
 ;
 ;@stanza 3 main loop
 ;
 f  s zi=$o(ary(zi)) q:zi=""  d  ;
 . n rx s rx=$o(ary(zi,""))
 . s r1("result",zi,"name")=$g(@root@(rx,"saminame"))
 . s r1("result",zi,"dfn")=$g(@root@(rx,"dfn"))
 . s dfn=$g(@root@(rx,"dfn"))
 . ;s r1("result",zi,"last5")=$g(@root@(rx,"last5"))
 . s r1("result",zi,"last5")=$$GETUID^SAMIUID(dfn)
 . s r1("result",zi,"gender")=$g(@root@(rx,"gender"))
 . s r1("result",zi,"dob")=$g(@root@(rx,"sbdob"))
 . s r1("result",zi,"vapals")=0
 . n dfn s dfn=$g(@root@(rx,"dfn"))
 . i $o(@groot@("dfn",dfn,""))'="" d  ;
 . . s r1("result",zi,"vapals")=1
 . . s r1("result",zi,"studyid")=$g(@groot@(dfn,"samistudyid"))
 . . q
 . q
 ;
 ;.;
 ;.; ven/lgc 2019-12-17 missing forms
 ;.;
 ;. i '($data(@groot@("graph",@groot@(dfn,"samistudyid")))) d  ;
 ;. . s r1("result",zi,"vapals")=0
 ;
 ;q:'$d(r1)
 ;
 ;
 ;@stanza 4 build result structure
 ;
 i format="array" m rtn=r1 q  ; return a mumps array
 d ENCODE^VPRJSON("r1","rtn")
 ;
 ;
 ;@stanza 5 termination
 ;
 quit  ; end of BUILDRTN
 ;
 ;
 ;
EOR ; end of routine SAMIPTLK
