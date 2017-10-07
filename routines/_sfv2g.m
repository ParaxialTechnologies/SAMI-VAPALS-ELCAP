%sfv2g	;ven/gpl - mash conversion utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
fmrec(file,ien) ; extrinsic which returns the json version of the fmx return
 n %g,%gj
 d fmx("%g",file,ien)
 d ENCODE^VPRJSON("%g","%gj")
 q %gj
 ;
fmx(rtn,file,ien,camel) ; return an array of a fileman record for external 
 ; use in rtn, which is passed by name. 
 ;
 k @rtn
 n trec,filenm
 d GETS^DIQ(file,ien_",","**","ENR","trec")
 s filenm=$o(^DD(file,0,"NM",""))
 s filenm=$tr(filenm," ","_")
 ;zwr trec
 i $g(debug)=1 b
 n % s %=$q(trec(""))
 f  d  q:%=""  ;
 . n fnum,fname,iens,field,val
 . s fnum=$qs(%,1)
 . i $d(^DD(fnum,0,"NM")) d  ;
 . . s fname=$o(^DD(fnum,0,"NM",""))
 . . s fname=$tr(fname," ","_")
 . e  s fname=fnum
 . s iens=$qs(%,2)
 . s field=$qs(%,3)
 . s field=$tr(field," ","_")
 . s val=@%
 . i fnum=file d  ; not a subfile
 . . s @rtn@(fname,ien,field)=val
 . . s @rtn@(fname,"ien")=$p(iens,",",1)
 . e  d  ;
 . . n i2 s i2=$o(@rtn@(fname,""),-1)+1
 . . s @rtn@(fname,$p(iens,","),field)=val
 . . ;s @rtn@(fname,i2,field)=val
 . . ;s @rtn@(fname,i2,"iens")=iens
 . w:$g(debug)=1 !,%,"=",@%
 . s %=$q(@%)
 q
 ;example
 ;g("bsts_concept","codeset")=36
 ;g("bsts_concept","concept_id")=370206005
 ;g("bsts_concept","counter")=75
 ;g("bsts_concept","dts_id")=370206
 ;g("bsts_concept","fully_specified_name")="asthma limits walking on the flat (finding)"
 ;g("bsts_concept","last_modified")="may 11, 2015"
 ;g("bsts_concept","out_of_date")="no"
 ;g("bsts_concept","partial_entry")="non-patial (full entry)"
 ;g("bsts_concept","revision_in")="mar 01, 2012"
 ;g("bsts_concept","revision_out")="jan 01, 2050"
 ;g("bsts_concept","version")=20140901
 ;g("bsts_concept","ien")="75"
 ;g("is_a_relationship",1,"is_a_relationship")=2
 ;g("subsets",1,"subsets")="ehr ipl asthma dxs"
 ;g("subsets",2,"subsets")="srch cardiology"
 ;g("subsets",3,"subsets")="ihs problem list"
 ;
