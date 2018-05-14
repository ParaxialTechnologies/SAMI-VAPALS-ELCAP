KBAIOS5	;gpl - OS5 code utilities ; 2/24/18 8:23pm
	;;1.0;OS5;;oct 19, 2017;Build 12
	;
	; Authored by George P. Lilly 2018
	;
	q
	;
csv2os5 ; converts CDC procedures spreadsheet to OS5 graph
 ; seeGraph is assumed and is used to locate and read in the csv file
 ; the csv file is called PHVS_ProcedureBySite_CDC_V5.csv
 ; the resulting graph is called OS5procedureCodes
 ; the graph is cleared before conversion
 ; the incoming csv file is stored in graph CDCproceduresCSV
 ; it is cleared at the beginning and purged at the end 
 ;
 n csvfn s csvfn="PHVS_ProcedureBySite_CDC_V5.csv"
 d purgegraph^%wd("CDCproceduresCSV")
 d csv2graph^%wd(csvfn,"CDCproceduresCSV")
 ;
 n root s root=$$setroot^%wd("CDCproceduresCSV")
 n groot s groot=$na(@root@("graph",csvfn))
 n col m col=@groot@("order")
 ;
 n os5root
 s os5root=$$setroot^%wd("OS5procedureCodes")
 k @os5root ; clear the graph
 s os5root=$na(@os5root@("os5codes"))
 ;
 n cnt s cnt=0
 n zi s zi=0
 f  s zi=$o(@groot@(zi)) q:+zi=0  d  ;
 . s cnt=cnt+1
 . s @os5root@(cnt,"map2code")=$g(@groot@(zi,"Concept_Code"))
 . s @os5root@(cnt,"map2codeSystem")=$g(@groot@(zi,"Code_System_Code"))
 . s @os5root@(cnt,"map2codeSystemVersion")=$g(@groot@(zi,"Code_System_Version"))
 . s @os5root@(cnt,"name")=$g(@groot@(zi,"Preferred_Concept_Name"))
 . n altcode,os5code,site
 . s altcode=$g(@groot@(zi,"Preferred_Alternate_Code"))
 . q:altcode=""
 . s os5code=$p(altcode,"-",2)
 . s site=$p(altcode,"-",1)
 . s @os5root@(cnt,"code")=os5code
 . s @os5root@(cnt,"site")=site
 q
 ;
wsOS5(rtn,filter) ; web service for OS5 codes
 ;
 n format s format=$g(filter("format"))
 i format="" s format="intro"
 ;
 n root s root=$$setroot^%wd("OS5procedureCodes")
 q:root=""
 ;
 i format="intro" d  ;
 . s rtn="use format=json"
 ;
 i format="json" d  ;
 . d ENCODE^VPRJSON(root,"rtn")
 . s HTTPRSP("mime")="application/json"
 q
 ; 
