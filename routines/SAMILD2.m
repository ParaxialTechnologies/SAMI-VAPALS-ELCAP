SEP() ; extrinsic returns the separator character used
 Q $CHAR(9)
 ;
LOAD ;
 N SITE
 s SITE=$$PICSITE^SAMIMOV()
 Q:SITE="^"
 N FN,GN
 ;S DIR="/tmp/"
  ; prompt for the directory
 N SAMIDIR
 D GETDIR^SAMIFDM(.SAMIDIR)
 Q:SAMIDIR=""
 ;
 do
 . N DIR,X,Y,DA,DIRUT,DTOUT,DUOUT,DIROUT
 . S DIR(0)="F^0:1024"
 . S DIR("A")="Enter filename to load."
 . S DIR("B")="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 . D ^DIR
 . W !
 . if '$data(DIRUT) set FN=Y
 quit:'$data(FN)
 ;
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.csv"
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 S GN=$NA(^TMP("SAMICSV",$J,1))
 K @GN
 N OK
 S OK=$$FTG^%ZISH(SAMIDIR,FN,GN,3)
 D  ;
 . ;
 . ; Normalize overflow nodes (and hope for the best that we don't go over 32k)
 . new i,j set (i,j)=""
 . for  set i=$order(^TMP("SAMICSV",$J,i)) quit:'i  for  set j=$order(^TMP("SAMICSV",$J,i,"OVF",j)) quit:'j  do
 .. set ^TMP("SAMICSV",$J,i)=^TMP("SAMICSV",$J,i)_^TMP("SAMICSV",$J,i,"OVF",j)  ;
 K ^gpl("CSV")
 M ^gpl("CSV")=^TMP("SAMICSV",$J)
 D TOGRAPH(SITE) ; clear the load graph and read first line to key
 D UNWRAP(SITE) ; parse all records into the graph
 D IMPORT(SITE) ; do conversions where necessary and create SAMI patient
 Q
 ;
TOGRAPH(SITE) ;
 N GN S GN=$NA(^TMP("SAMICSV",$J))
 d purgegraph^%wd(SITE_"-INTAKE")
 n root s root=$$setroot^%wd(SITE_"-INTAKE")
 n keyrow,done s (keyrow,done)=0
 f  s keyrow=$o(@GN@(keyrow)) q:keyrow=0  q:done  d  ;
 . ; searching for the row with the field names
 . i $l(@GN@(keyrow),$$SEP)<5 q  ; it will have at least 5 fields
 . n tmprow s tmprow=$g(@GN@(keyrow))
 . i $e(tmprow,1,9)["record_id" s done=1 q  ;
 . i $e(tmprow,1,8)["saminame" s done=1 q  ;
 s keyrow=keyrow-1
 w !,"keyrow is ",keyrow," ROW="_@GN@(keyrow)
 i keyrow=0 d  q  ;
 . w !,"error reading tsv file, no key row found"
 n zi,zl
 ; first row
 f zi=1:1:$l(@GN@(keyrow),$$SEP) d  ;
 . s zl=$p(@GN@(keyrow),$$SEP,zi)
 . s @root@("key",zi,zl)=""
 . s @root@("key","B",zl,zi)=""
 q
 ;
UNWRAP(SITE) ;
 n root s root=$$setroot^%wd(SITE_"-INTAKE")
 n proot s proot=$na(@root@("records"))
 n GN s GN=$NA(^TMP("SAMICSV",$J))
 n key s key=$na(@root@("key"))
 ; compute first data row
 n datarow,done s datarow=1 s done=0 ;can't be the first row
 f  s datarow=$o(@GN@(datarow)) q:done  q:+datarow=0  d  ;
 . i $e(@GN@(1),1,9)["record_id" s done=1 s datarow=1
 . i @GN@(datarow)["LAST,FIRST MIDDLE SUFFIX" s done=1 ;s datarow=datarow+1
 i datarow=0 d  q  ;
 . w !,"error, data row cannot be found"
 w !,"data row is ",datarow," ROW=",@GN@(datarow)
 n zi s zi=datarow-1
 s done=0
 f  s zi=$o(@GN@(zi)) q:+zi=0  q:done  d  ;
 . i $g(@GN@(zi))="" s done=1 q  ; quit on a null line
 . i $p(@GN@(zi),$$SEP,1)="" s done=1 q  ; quit if name is null
 . i $e(@GN@(zi),1,1)=$CHAR(9) s done=1 q  ; quit if first field is null
 . n zj
 . f zj=1:1:$l(@GN@(zi),$$SEP) d  ;
 . . n zl s zl=$o(@key@(zj,""))
 . . i zl="" s zl="piece"_zj
 . . n data s data=$p(@GN@(zi),$$SEP,zj)
 . . i data["""" s data=$tr(data,"""")
 . . s @proot@(zi,zl)=data
 q
 ;
IMPORT(SITE) ; import from csv stored in SITE-INTAKE graph
 N root,zi,croot,lroot,proot
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 s root=$$setroot^%wd(SITE_"-INTAKE")
 s croot=$na(@root@("records"))
 s zi=0
 f  s zi=$o(@croot@(zi)) q:+zi=0  d  ;
 . n onepat,ztbl
 . m onepat=@croot@(zi)
 . s onepat("siteid")=SITE
 . i '$d(onepat("saminame")) d  ;
 . . i $d(onepat("last_name")) d  ;
 . . . d RCAPHACK^SAMIZPH1("ztbl","onepat") ; this is a REDCAP record, convert
 . e  d  ;
 . . d CONVSS2^SAMISS("onepat") ; gpl plan B
 . . ;d SSCONV^SAMISS("onepat") ; Ken's conversion routine
 . i $g(onepat("saminame"))="" d  q  ; we must at least have a name
 . . w !,SITE," error, name missing. Record=",zi," ROW=",$g(@GN@(zi))
 . s onepat("site")=SITE
 . i $$DEDUP(.onepat) d  q  ; is this a duplicate? if so, set studyid
 . . w !,"error, duplicate patient. Skipping ",$g(onepat("saminame"))
 . . q
 . . n siform,sid
 . . s sid=$g(onepat("studyid"))
 . . i sid="" d  b  ;
 . . . w !,"error processing duplicate record "
 . . . d ^ZTER
 . . s siform=$o(@proot@("graph",sid,"si"))
 . . i siform="" d  b  ;
 . . . w !,"error finding siform for sid ",sid
 . . m @proot@("graph",sid,siform)=onepat
 . d CREATE(.onepat)
 Q
 ;
DEDUP(onepat) ; extrinsic which identifies a duplicate patient
 ; if found, returns 1. also sets onepat("studyid")
 n lroot,proot,dfn,lien,pien,sid
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 n inname s inname=$g(onepat("saminame"))
 w !,"inname=",inname
 i inname="" d  q 1 ;
 . w !,"error, inname is null"
 s lien=""
 n tlien s tlien=""
 f  s tlien=$o(@lroot@("name",inname,tlien)) q:tlien=""  d  ;
 . q:'$d(@lroot@(tlien))
 . q:$g(@lroot@(tlien,"siteid"))'=SITE
 . s lien=tlien
 q:lien="" 0
 w !,"lien=",lien
 i '$d(@lroot@("last5",$g(@lroot@(lien,"last5")))) d  q 0 ;
 . ;w !,"last5 not found"
 i '$d(onepat("dob")) s onepat("dob")=$g(onepat("sbdob"))
 ;zwr @lroot@(lien,*)
 ;n inlast5 s inlast5=$g(onepat("last5"))
 ;w !,"inlast5=",inlast5
 ;n last5 s last5=$o(@lroot@("last5",inlast5,""))
 ;w !,"last5=",last5
 ;q:last5="" 0
 ;q:last5'=lien 0
 s dfn=$g(@lroot@(lien,"dfn"))
 w !,"dfn=",dfn
 ;B
 q:dfn="" 0
 s pien=$o(@proot@("dfn",dfn,""))
 q:pien=""
 s sid=$g(@proot@(pien,"sisid"))
 i sid="" s sid=$g(@proot@(pien,"samistudyid"))
 w !,"sid=",sid
 q:sid="" 0
 s onepat("studyid")=sid
 s onepat("dfn")=dfn
 q 1
 ; 
CREATE(vars) ; create a patient record and an intake form from vars
 ;
 D REGISTER(.vars)
 D ENROLL(.vars)
 q
 ;
REGISTER(vars)
 N saminame
 s saminame=$g(vars("saminame"))
 i saminame="" s saminame=$g(vars("name"))
 i saminame="" d  ;
 . n nxtdfn s nxtdfn=$$nxtdfn^SAMIDCM1()
 . s saminame="DOE"_nxtdfn_",JOHN"
 . s vars("saminame")=saminame
 s vars("name")=saminame
 n varscpy m varscpy=vars
 N SAMIRTN
 D REG^SAMIHOM4(.SAMIRTN,.varscpy)
 m vars=varscpy
 ;s vars("dfn")=$$GETDFN(saminame)
 ;m varscpy=vars
 ;B
 q
 ;
ENROLL(vars) ; 
 n varscpy
 m varscpy=vars
 D WSNEWCAS^SAMIHOM3(.varscpy,.SAMIBDY,.SAMIRESULT)
 ;ZWR varscpy
 n sid,sikey
 s sid=$g(varscpy("studyid"))
 s sikey=$g(varscpy("form"))
 s sikey=$p(sikey,"vapals:",2)
 m vars=varscpy
 ;w !,"sid: ",sid," sikey: ",sikey
 n root s root=$$setroot^%wd("vapals-patients")
 q:sid=""
 q:sikey=""
 m @root@("graph",sid,sikey)=vars
 ;N NUM S NUM=$$GETNUM(saminame)
 ;D MKSIFORM^SAMIHOM3(NUM)
 Q
 ;
FIX() ; look for bad patient records and fix them
 ; doesn't delete unless DELETE=1 is set
 N lroot,zi,proot,pien
 s lroot=$$setroot^%wd("patient-lookup")
 s proot=$$setroot^%wd("vapals-patients")
 s zi=0
 f  s zi=$o(@lroot@(zi)) q:+zi=0  d  ;
 . n site,dfn,sid
 . s dfn=$g(@lroot@(zi,"dfn"))
 . if dfn="" d  q  ;
 . . w !,"bad lookup record, no dfn. lien=",zi
 . . q:'$g(DELETE)
 . . k @lroot@(zi)
 . s pien=$o(@proot@("dfn",dfn,""))
 . s site=$g(@lroot@(zi,"siteid"))
 . if site="" d  q  ;
 . . w !,"bad lookup record, no siteid. lien=",zi
 . . q:'$g(DELETE)
 . . k @lroot@(zi)
 . . k @lroot@("dfn",dfn)
 . . zwr @lroot@(zi,*)
 . q:pien=""
 . s sid=$g(@proot@(pien,"samistudyid"))
 . i sid'="" d
 . . i $e(sid,1,3)'[site d  ;
 . . . w !,"error, sid does not match site lien=",zi," site=",site," sid=",sid
 . . . q:'$g(DELETE)
 . . . k @lroot@(zi)
 . . . k @lroot@("dfn",dfn)
 . . . k @proot@(pien)
 . . . k @proot@("dfn",dfn)
 . . . k @proot@("graph",sid)
 q
 ;