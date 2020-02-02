SAMICTRT ;ven/gpl - CTReport Test Routine ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ; This routine is for testing only and should not be distributed
 ;
 quit  ; no entry from top
 ;
wsReport(testout,filter) ; web service
 n vapals ; first do vapals report
 d WSREPORT^SAMICTR0(.vapals,.filter)
 n fglb,fglb1,fn,dir
 s fglb=$na(^TMP("SAMITEST",$J))
 k @fglb
 s fglb1=$na(@fglb@(1))
 s fn=$$filename(.filter)
 s dir=$$whereIs("/ctvapals")
 m @fglb=vapals
 d GTF^%ZISH(fglb1,3,dir,"vapals_"_fn_".html")
 ;
 d makeData(fn,.filter) ; data for elcap report generator
 l +ctreport:2 e  d  q  ; need to make go.sh
 d makeGo(fn,.filter)
 zsy "bash /home/osehra/www/ctcontrol/go.sh"
 l -ctreport  ; all done with go.sh
 ;
 d makeFrame(.testout,fn,.filter)
 q
 ;
filename(filter) ; extrinsic returns the filename for output
 n root s root=$$setroot^%wd("vapals-patients")
 n sid
 s sid=$g(filter("studyid"))
 i sid="" s sid="XXX00102"
 n pien s pien=$$SID2NUM^SAMIHOM3(sid)
 n fname,lname
 s fname=@root@(pien,"sinamef")
 s lname=@root@(pien,"sinamel")
 q lname_"_"_fname
 ;
makeGo(fn,filter) ; creates a bash script to run the elcap report
 n fglb,fglb1,dir,destdir
 s fglb=$na(^TMP("SAMITEST",$J))
 k @fglb
 s fglb1=$na(@fglb@(1))
 s destdir=$$whereIs("/ctelcap")
 n fname,lname,sid
 s fname=$p(fn,"_",2)
 s lname=$p(fn,"_",1)
 s sid=$g(filter("studyid"))
 i sid="" s sid="XXX00102"
 ;script run command redacted
 s dir="/home/osehra/www/ctcontrol/"
 d GTF^%ZISH(fglb1,3,dir,"go.sh") 
 q
 ;
makeFrame(out,fn,filter) ; creates an html file with a frame in /ctcompare
 n fglb,fglb1,dir
 s fglb=$na(^TMP("SAMITEST",$J))
 k @fglb
 s fglb1=$na(@fglb@(1))
 s dir=$$whereIs("/ctcompare")
 s @fglb@(1)="<html><head></head>"
 s @fglb@(2)=" <frameset cols=""50,50"">"
 s @fglb@(3)="    <frame src=""/resources/ctelcap/elcap_"_fn_".html"" name=""ELCAP"">"
 s @fglb@(4)="   <frame src=""/resources/ctvapals/vapals_"_fn_".html"" name=""VAPALS"">"
 s @fglb@(5)="   </frameset></html>"
 d GTF^%ZISH(fglb1,3,dir,fn_".html")
 ;
 s out=fglb
 q
 ;
makeData(fn,filter) ; creates an elcap compatible data file
 n sid,form
 s sid=$g(filter("studyid"))
 q:sid=""
 s form=$g(filter("form"))
 q:form=""
 n fglb s fglb=$na(^TMP("SAMITEST",$J))
 n fglb1 s fglb1=$na(@fglb@(1))
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 q:root=""
 ;
 n cnt s cnt=0
 n groot s groot=$na(@root@("graph",sid,form))
 n zi s zi=""
 f  s zi=$o(@groot@(zi)) q:zi=""  d  ;
 . q:zi[" "
 . s cnt=cnt+1
 . n ln
 . s ln=zi_"="_$g(@groot@(zi))
 . s @fglb@(cnt)=ln
 n dir s dir=$$whereIs("/ctdata")
 d GTF^%ZISH(fglb1,3,dir,fn_".txt")
 k @fglb
 q
 ;
testdata ;
 s filter("studyid")="XXX00102"
 s filter("form")="ceform-2018-10-09"
 s pgraph=$na(^%wd(17.040801,15,102))
 s name=@pgraph@("sinamel")_"-"_@pgraph@("sinamef")
 d makeData(name,.filter)
 q
 ;
whereIs(dirname) ; extrinsic which returns a directory path
 n root s root=$$setroot^%wd("seeGraph")
 q:root=""
 n dien,dir
 s dien=$o(@root@("graph","ops",dirname,"distdir",""))
 i $o(@root@("graph",dien,"type",""))'="directory" q  ;
 s dir=$o(@root@("graph",dien,"localdir",""))
 i dir'="" s dir=dir_"/"
 q dir
 ;
