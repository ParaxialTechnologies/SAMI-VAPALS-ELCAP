SAMIPTLK ;ven/gpl - SAMI patient lookup routines ;Dec 17, 2019@09:44
 ;;18.0;SAMI;;;Build 11
 ;
 ;@license: see routine SAMIUL
 ;
 ; Authored by George P. Lilly 2018
 ;
 Q
WSPTLOOK(rtn,filter) ; patient lookup - calls HMPPTRPC
 ;
 n search s search=$g(filter("search"))
 n rslt
 d SELECT^HMPPTRPC(.rslt,"NAME",search)
 i $d(rslt) d  ;
 . D ENCODE^VPRJSON("rslt","rtn")
 q
 ;
WSPTLKUP(rtn,filter) ; patient lookup from patient-lookup cache
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
 i $l(search)=5 i +$e(search,2,5)>0 d  q  ; using last5
 . n gn2 s gn2=$na(@root@("last5"))
 . n ii s ii=""
 . f  s ii=$o(@gn2@(search,ii)) q:ii=""  q:cnt=limit  d  ;
 . . i $g(@root@(ii,"siteid"))'=site q
 . . s cnt=cnt+1
 . . s rslt(cnt,ii)=""
 . i cnt>0 d  ;
 . . d BUILDRTN(.rtn,.rslt,$g(filter("format")))
 ; 
 n have s have=""
 n q1 s q1=$na(@gn@(p1))
 n q1x s q1x=$e(q1,1,$l(q1)-2) ; removes the ")
 n qx s qx=q1
 f  s qx=$q(@qx) q:$p(qx,q1x,2)=""  q:cnt=limit  d  ;
 . n exit s exit=0
 . i p2'="" d  ;
 . . i p2'=$e($p(qx,",",5),1,$l(p2)) s exit=1
 . q:exit
 . n qx2 s qx2=+$p(qx,",",6)
 . i $g(@root@(qx2,"siteid"))'=site q  ;
 . i $d(have(qx2)) q  ; already go this one
 . s cnt=cnt+1
 . s have(qx2)=""
 . s rslt(cnt,qx2)="" ; the ien
 . ;w !,qx," ien=",$o(rslt(cnt,""))
 i cnt>0 d BUILDRTN(.rtn,.rslt,$g(filter("format")))
 q
 ;
BUILDRTN(rtn,ary,format) ; build the return json unless format=array
 ; then return a mumps array
 ;
 ;d ^ZTER
 n root s root=$$setroot^%wd("patient-lookup")
 n groot s groot=$$setroot^%wd("vapals-patients")
 n zi s zi=""
 n r1 s r1=""
 f  s zi=$o(ary(zi)) q:zi=""  d  ;
 . n rx s rx=$o(ary(zi,""))
 . s r1("result",zi,"name")=$g(@root@(rx,"saminame"))
 . s r1("result",zi,"dfn")=$g(@root@(rx,"dfn"))
 . s r1("result",zi,"last5")=$g(@root@(rx,"last5"))
 . s r1("result",zi,"gender")=$g(@root@(rx,"gender"))
 . s r1("result",zi,"dob")=$g(@root@(rx,"sbdob"))
 . s r1("result",zi,"vapals")=0
 . n dfn s dfn=$g(@root@(rx,"dfn"))
 . i $o(@groot@("dfn",dfn,""))'="" d  ;
 . . s r1("result",zi,"vapals")=1
 . . s r1("result",zi,"studyid")=$g(@groot@(dfn,"samistudyid"))
 ;.;
 ;.; ven/lgc 2019-12-17 missing forms
 ;.;
 ;. i '($data(@groot@("graph",@groot@(dfn,"samistudyid")))) d  ;
 ;. . s r1("result",zi,"vapals")=0
 ;
 ;q:'$d(r1)
 i format="array" m rtn=r1 q  ; return a mumps array
 d ENCODE^VPRJSON("r1","rtn")
 q
 ;
