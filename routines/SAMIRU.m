SAMIRU ;ven/gpl - sami user reports ; 4/19/19 10:47am
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMIRU contains the routines to handle rural/urban status
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
 ; sirs = rural status r,u,n
 ; sipsa = preferred address
 ;
 ; $$URBRUR^SAMIVSTA(zipcode) returns r u
 ;
 ; NCHS Urban-Rural graph for zip code table
 ;
INDEX ; create the zip index in the zip graph
 n root
 s root=$$setroot^%wd("NCHS Urban-Rural")
 k @root@("zip")
 n zi s zi=0
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . n ruca30
 . s ruca30=$g(@root@(zi,"ruca30"))
 . q:ruca30=""
 . s zipcoden=$g(@root@(zi,"zipcoden"))
 . q:zipcoden=""
 . s @root@("zip",zipcoden)=ruca30
 q
 ;
WSGETRU(rtn,filter) ; web service to return counts for rural and urban
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 n rural,urban,unknown
 s (rural,urban,unknown)=0
 n zi s zi=0
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . n sid s sid=@root@(zi,"sisid")
 . q:sid=""
 . n gr s gr=$na(@root@("graph",sid))
 . n siform
 . s siform=$o(@gr@("siform-"))
 . q:siform=""
 . i $g(@gr@(siform,"sirs"))="u" s urban=urban+1
 . i $g(@gr@(siform,"sirs"))="r" s rural=rural+1
 . i $g(@gr@(siform,"sirs"))="n" s unknown=unknown+1
 n rslt
 s rslt("result","urban")=urban
 s rslt("result","rural")=rural
 s rslt("result","unknown")=unknown
 s rslt("result","site")="VA-PALS Test"
 d ENCODE^VPRJSON("rslt","rtn")
 q
 ;
WSZIPRU(rtn,filter) ;
 n zzip s zzip=$g(filter("zip"))
 n rslt,ru
 s ru=$$URBRUR^SAMIVSTA(zzip)
 if (ru'="u")&(ru'="r") s ru="n"
 s rslt("result")=ru
 d ENCODE^VPRJSON("rslt","rtn")
 q
 ;
