KBAITLEX	; GPL - terminology server utilities ; 2/24/18 4:39am
	;;0.1;TERM;nopatch;noreleasedate;Build 10
	;
	; Authored by George P. Lilly 2018
	;
	Q
wsSctTerm(rtn,filter) ; web service to look up a Snomed term in the Lexicon
 ;
 I '$D(DT) N DIQUIET S DIQUIET=1 D DT^DICRW
 S DUZ=1
 m ^gpl("lex","filter")=filter
 n term s term=$g(filter("term"))
 q:term=""
 n codesys s codesys="SCT"
 n dt s dt=$$NOW^XLFDT
 n ok
 s ^gpl("lex","term")=term
 s ^gpl("lex","codesys")=codesys
 s ^gpl("lex","dt")=dt
 s ok=$$TAX^LEX10CS(term,codesys,dt,"LEXTAX",0)
 s ^gpl("lex","ok")=ok
 i +ok=-1 d  q  ;
 . s rtn(1)=ok
 n l1 s l1=$na(^TMP("LEXTAX",$J))
 n lsys s lsys=$o(@l1@(0)) ; code systems ien
 n lextax s lextax=$na(@l1@(lsys))
 n rslt
 n cnt s cnt=0
 n zi s zi=""
 f  s zi=$o(@lextax@(zi)) q:zi=""  d  ;
 . n r1
 . s r1=$g(@lextax@(zi,1,0))
 . q:r1=""
 . s cnt=cnt+1
 . s rslt("result",cnt,"code")=$p(r1,"^",1)
 . s rslt("result",cnt,"text")=$p(r1,"^",2)
 . n d1 s d1=$g(@lextax@(zi,1))
 . n date s date=""
 . i d1'="" s date=$p(d1,"^",1)
 . s rslt("result",cnt,"date")=$$FMTE^XLFDT(date)
 . s rslt("result",cnt,"codeSystem")="SCT"
 ;
 m ^gpl("lex","rslt")=rslt
 n format s format=$g(filter("format"))
 i format="" s format="html"
 ;
 i format="json" d  ;
 . S HTTPRSP("mime")="application/json"
 . d ENCODE^VPRJSON("rslt","rtn")
 ;
 i format="html" d  ;
 . s rtn=$na(^TMP("KBAIOUT",$J))
 . k @rtn
 . S HTTPRSP("mime")="text/html"
 . n tbl,gtop,gbot
 . d HTMLTB2^KBAIWEB(.gtop,.gbot,"Snomed Codes for term "_term)
 . m @rtn=gtop
 . s tbl("HEADER",1)="Code"
 . s tbl("HEADER",2)="Text"
 . s tbl("HEADER",3)="Code System"
 . s tbl("HEADER",4)="Code System Date"
 . s tbl("TITLE")="Results for search term "_term
 . n zi s zi=""
 . f  s zi=$o(rslt("result",zi)) q:zi=""  d  ;
 . . s tbl(zi,1)=$g(rslt("result",zi,"code"))
 . . s tbl(zi,2)=$g(rslt("result",zi,"text"))
 . . s tbl(zi,3)=$g(rslt("result",zi,"codeSystem"))
 . . s tbl(zi,4)=$g(rslt("result",zi,"date"))
 . d GENHTML2^KBAIUTIL(rtn,"tbl")
 . S @rtn@($O(@rtn@(""),-1)+1)=gbot
 . k @rtn@(0)
 m ^gpl("lex","rtn")=rtn
 ;
 q
 ;
 
