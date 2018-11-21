yottaq	;ven/gpl-yottadb extension: query ;2018-02-07T21:11Z
 ;;1.8;Mash;
 ;
 ; %yottaq implements the Yottadb Extension Library's query
 ; ppis & apis. This may eventually migrate to another Mash namespace,
 ; tbd. In the meantime, it will be added to a new %yotta ppi
 ; library.
 ; It is currently untested & in progress.
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
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-07T21:11Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Yottadb Extension - %yotta
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@module-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017, gpl
 ;@funding: 2017, ven
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log
 ; 2017-09-18 ven/gpl %*1.8t01 %yottaq: create routine to hold
 ; the yottadb query methods.
 ;
 ; 2017-09-25 ven/gpl %*1.8t01 %yottaq: update
 ;
 ; 2018-02-07 ven/toad %*1.8t04 %yottaq: passim add white space &
 ; hdr comments & do-dot quits, tag w/Apache license & attribution
 ; & to-do to shift namespace later, break up a few long lines.
 ;
 ;@to-do
 ; %yotta: create entry points in ppi/api style
 ; r/all local calls w/calls through ^%yotta
 ; change branches from %yotta
 ; renamespace elsewhere, research best choice
 ;
 ;@contents
 ; queryPred: returns a json/mumps array of tagged items
 ; importsami: import sami sample json
 ; impsami1:
 ; initforms: initialize sami forms
 ; initform1: initialize form from array
 ; $$tagyn = is item tagged w/tag?
 ; scanall:
 ;
 ;
 ;
 ;@section 1 code to implement ppis & apis
 ;
 ;
 ;
queryPred(rtn,pred) ; returns a json/mumps array of tagged items
 ;
 new graph set graph="seeGraph"
 kill @rtn
 new root set root=$$setroot^%wdgraph(graph)
 new groot set groot=$name(@root@("graph"))
 if '$data(@groot@("pos",pred)) quit
 new obj,x1,y1 set (obj,x1,y1)=""
 new cnt set cnt=0
 for  set obj=$order(@groot@("pos",pred,obj)) quit:obj=""  do  ;
 . for  set x1=$order(@groot@("pos",pred,obj,x1)) quit:x1=""  do  ;
 . . for  set y1=$order(@groot@("pos",pred,obj,x1,y1)) quit:y1=""  do  ;
 . . . set cnt=cnt+1
 . . . set @rtn@(cnt,obj,x1,y1)=""
 . . . quit
 . . quit
 . quit
 ;
 quit  ; end of queryPred
 ;
 ;
 ;
importsami ; import sami sample json
 ;
 new root set root=$$setroot^%wdgraph("elcapSampleJson")
 new ii,%i set %i=""
 set ii("ceform3","ceform-20142105.json")=""
 set ii("fuform","fuform-20142105.json")=""
 set ii("sbform","sbform-20130101.json")=""
 set ii("bxform","bxform-20132802.json")=""
 set ii("ceform","ceform-20130101.json")=""
 set ii("rbform","rbform-20130104.json")=""
 set ii("ceform2","ceform-20131510.json")=""
 set ii("ptform","ptform-20130802.json")=""
 set ii("siform","siform-20122408.json")=""
 for  set %i=$order(ii(%i)) quit:%i=""  do  ;
 . new %ii set %ii=$order(ii(%i,""))
 . do impsami1(root,%i,%ii)
 . quit
 ;
 quit  ; end of importsami
 ;
 ;
 ;
impsami1(root,id,fn) ;
 ;
 new vtmp
 do getThis^%wdgraph("vtmp",fn)
 new dest set dest=$name(@root@(id))
 new tmpdest
 do DECODE^VPRJSON("vtmp","tmpdest")
 merge @dest=tmpdest
 set @root@("B",id)=""
 ;
 quit  ; end of impsami1
 ;
 ;
 ;
initforms ; initialize sami forms
 ;
 new root set root=$$setroot("elcapSampleJson")
 new %i set %i=""
 for  set %i=$order(@root@(%i)) quit:%i=""  do  ;
 . if %i="B" quit
 . if %i=0 quit
 . new vars
 . merge vars=@root@(%i)
 . ; break
 . do initform1(%i,"vars")
 . quit
 ;
 quit  ; end of initforms
 ;
 ;
 ;
initform1(id,ary) ; initialize form from array
 ;
 ; initialize one form named id from ary passed by name
 ;
 new fn set fn=17.040201 ; file number
 new sfn set sfn=17.402011 ; subfile number for variables
 new fmroot set fmroot=$name(^%wf(17.040201))
 new fda,%yerr
 set fda(fn,"?+1,",.01)=id
 write !,"creating form ",id
 do UPDATE^DIE("","fda","","%yerr")
 if $data(%yerr) do  quit  ;
 . write !,"error creating form record ",id,!
 . zwrite %yerr
 . quit
 new %ien set %ien=$o(@fmroot@("B",id,""))
 if %ien="" do  quit  ;
 . write !,"error locating form record ",id
 . quit
 new %j set %j=""
 new vcnt set vcnt=0
 kill fda
 for  set %j=$order(@ary@(%j)) quit:%j=""  do  ;
 . set vcnt=vcnt+1
 . set fda(sfn,"?+"_vcnt_","_%ien_",",.01)=%j
 . quit
 do CLEAN^DILF
 write !,"creating variables for form ",%ien
 do UPDATE^DIE("","fda","","%yerr")
 if $data(%yerr) do  quit  ;
 . write !,"error creating variable record ",%j,!
 . zwrite %yerr
 . quit
 ;
 quit  ; end of initform1
 ;
 ;
 ;
tagyn(tag,ien1,ien2) ; is item tagged w/tag?
 ;
 ; extrinsic returns 1 if item is tagged w/tag
 ;
 new gn set gn=$name(^%wd(17.020801,1,"graph",ien1,ien2,"tag"))
 if $data(@gn@(tag)) quit 1
 ;
 quit 0 ; end of $$tagyn
 ;
 ;
 ;
scanall ;
 ;
 new gn set gn=$name(^%wd(17.020801,1,"graph","pos","id"))
 new zid,zi,zj
 set (zid,zi,zj)=""
 for  set zid=$order(@gn@(zid)) quit:zid=""  do  ;
 . if $reverse($piece($reverse(zid),"."))'="xml" quit  ; 
 . set zi=$order(@gn@(zid,""))
 . set zj=$order(@gn@(zid,zi,""))
 . quit:zj=""
 . quit:$$tagyn("scanned",zi,zj)
 . new contents
 . write !,"scanning ",zid
 . do scan^%yottagr(.contents,zid,zi,zj)
 . do addtag^%yottagr("scanned",zi,zj)
 . quit
 ;
 quit  ; end of scanall
 ;
 ;
 ;
eor ; end of routine %yottaq
