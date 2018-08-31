%wfhfields ;ven/gpl-web form: html form get & post ;2018-03-18T17:05Z
 ;;1.8;Mash;
 ;
 ; %wfhfields implements the Web Form Library's html form field graph processing
 ; services. It will be broken up into many routines & further annotated.
 ; See %wfut* for the unit tests for these methods.
 ; See %wfut for the whole unit-test library.
 ; See %wfud for documentation introducing the Web Form Lbrary,
 ; including an intro to the HTML Form Library.
 ; See %wful for the module's primary-development log.
 ; See %wf for the module's ppis & apis.
 ; %wfhform contains no public entry points.
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
form2fields(form,graph,fn) ; scans a form and builds a graph of the fields
 ; fn is optional and is used to specify a template file which is not in the form mapping file
 ;
 n zhtml,cnt,vals
 s vals="" ; no vals for this process
 s cnt=0
 if $get(fn)="" set fn=$$getTemplate^%wf(form)
 d getThis^%wd("zhtml",fn)
 i '$d(zhtml) d  q  ;
 . w !,"Error retrieving "_fn_" for form "_$g(form)
 ;
 n root,froot
 s root=$$setroot^%wd(graph)
 s froot=$na(@root@("field"))
 ;
 new name,value,selectnm
 set selectnm="" ; name of select variable, which spans options
 new %j set %j=""
 for  set %j=$order(zhtml(%j)) quit:%j=""  do  ;
 . new tln set tln=zhtml(%j)
 . set tln("low")=$$lowcase^%ts(tln) ; lowercase for checks
 . new customscan s customscan=""
 . ;
 . ;
 . if tln["submit" quit  ;
 . if tln["hidden" quit  ;
 . ;
 . ;@stanza 7 process field name or value
 . ;
 . set (name,value)=""
 . ;
 . if zhtml(%j)["name=" do  ;
 . . set name=$piece($piece(zhtml(%j),"name=""",2),"""")
 . . q:name=""
 . . q:name["+"
 . . q:$e(name,1)=" "
 . . q:$g(@froot@(cnt-1,"name"))=name
 . . write !,"found name ",name
 . . s cnt=cnt+1
 . . s @froot@(cnt,"name")=name
 . . n label
 . . s label=""
 . . i zhtml(%j)["title=" s label=$p($p(zhtml(%j),"title=""",2),"""")
 . . i zhtml(%j-1)["/label" s label=zhtml(%j-2)
 . . i zhtml(%j-2)["/label" s label=zhtml(%j-3)
 . . i label="" d  ;
 . . . i zhtml(%j-1)["<label" s label=zhtml(%j+1)
 . . . i zhtml(%j)["value=" s label=$p($p(zhtml(%j),"value=""",2),"""")
 . . s @froot@(cnt,"label")=label
 . . quit
 q
 . ;
 . if zhtml(%j)["value=" do  ;
 . . set value=$piece($piece(zhtml(%j),"value=""",2),"""")
 . . quit
 . ;
 . ;@stanza 9 process action
 . ;
 . if zhtml(%j)["action=" do  ;
 . . new sublbl set sublbl=$$formLabel^%wf(form)
 . . new dbg set dbg=$get(filter("debug"))
 . . if dbg'="" set dbg="&debug="_dbg
 . . ;
 . . quit
 . ;
 . ;@stanza 11 skip table declarations
 . ;
 . if tln["table" quit  ;
 . ;
 . ;@stanza 12 process input tags
 . ;
 . if zhtml(%j)["<input" do  ;
 . . ;
 . . ; handle long lines
 . . if $length(zhtml(%j),"<input")>2 do  ; got to split the lines
 . . . new zgt,zgn set zgt=zhtml(%j)
 . . . set zgn=$find(zgt,"<input",$find(zgt,"<input"))
 . . . set zhtml(%j+.001)=$extract(zgt,zgn-6,$length(zgt))
 . . . set zhtml(%j)=$extract(zgt,1,zgn-7)
 . . . set tln=zhtml(%j)
 . . . quit
 . . ;
 . . ; save field value
 . . quit:$get(name)=""
 . . new val set val=""
 . . if $data(vals(name)) set val=vals(name)
 . . ;
 . . ; process radio buttons & checkboxes
 . . new type set type=$$type^%wf(tln("low")) ; get input type
 . . if type="radio"!(type="checkbox") do  quit  ; treat the same
 . . . do uncheck^%wf(.tln)
 . . . if $get(val)=$get(value) do check^%wf(.tln,type)
 . . . if $get(filter("debug"))=2 do debugFld^%wf(.tln,form,name)
 . . . set zhtml(%j)=tln ; r/template line w/processed line
 . . . quit
 . . ;
 . . ; clear value, normalize quotes & dates, restore value
 . . do unvalue^%wf(.tln) ; clear input-field value
 . . ; set val=$$URLENC^VPRJRUT(val)
 . . ; replace with findReplaceAll call?:
 . . for  do findReplace^%ts(.val,"""","&quot;") quit:val'[""""  ; quotes
 . . do dateFormat^%wf(.val,form,name) ; ensure elcap date format
 . . do value^%wf(.tln,val) ; restore normalized value
 . . ;
 . . ; input-field validation
 . . new spec,errmsg set spec=$$getFieldSpec^%wffmap(form,name)
 . . set errmsg="Input invalid"
 . . if val]"" do  ;
 . . . if $$validate^%wf(val,spec,,.errmsg)<1 do  ;
 . . . . set errflag=1
 . . . . new errmethod set errmethod=2
 . . . . ; set errmethod=$get(filter("errormessagestyle"))
 . . . . ; if errmethod="" set errmethod=$get(errctrl("errorMessageStyle"))
 . . . . ; if errmethod="" set errmethod=1
 . . . . set errmethod=2
 . . . . if errmethod=2 do  ;
 . . . . . new tprevln,uln
 . . . . . set uln=(%j-1)
 . . . . . set tprevln=zhtml(uln)
 . . . . . if tprevln'["fielderror" set tprevln=zhtml(%j-2) set uln=%j-2
 . . . . . do putErrMsg2^%wf("zhtml",.tprevln,.errmsg,"errctrl")
 . . . . . set zhtml(uln)=tprevln
 . . . . . quit
 . . . . if errmethod=1 do insError^%wf(.tln,.errmsg)
 . . . . quit
 . . . quit
 . . ;
 . . ; [optionally debug & r/html template line w/processed line
 . . ; write !,tln,!,zhtml(%j),! break
 . . if $get(filter("debug"))>0 do debugFld^%wf(.tln,form,name)
 . . set zhtml(%j)=tln
 . . quit
 . ;
 . ;@stanza 13 process text areas
 . ;
 . if zhtml(%j)["<textarea" do  ;
 . . new val set val=""
 . . quit:$get(name)=""
 . . set val=$get(vals(name))
 . . ; set val=$get(vals(name))
 . . ; set val=$$URLENC^VPRJRUT(val)
 . . if val'="" do
 . . . do findReplace^%ts(.tln,"</textarea>",val_"</textarea>")
 . . . quit
 . . set zhtml(%j)=tln
 . . quit
 . ;
 . ;@stanza 14 process option selections
 . ;
 . if zhtml(%j)["<select" do  ;
 . . set selectnm=$get(name)
 . . quit
 . if zhtml(%j)["</select" do  ;
 . . set selectnm=""
 . . quit
 . if zhtml(%j)["<option" do  ;
 . . quit:selectnm=""
 . . set val=$get(vals(selectnm))
 . . do findReplace^%ts(.tln," selected","") ; unselect
 . . if $get(toad)="*****DEBUG*****",value="gd" break ; debug problem w/options
 . . if $g(val)=$get(value) do
 . . . do findReplace^%ts(.tln,"<option ","<option selected ")
 . . . quit
 . . if $get(filter("debug"))=2 do debugFld^%wf(.tln,form,name)
 . . set zhtml(%j)=tln
 . . quit
 . quit
 ;
 ;
 q
 ;
makeCeformGraph ; creates ceform-fields graph from vapals:ceform template
 d purgegraph^%wd("ceform-fields")
 d form2fields^%wfhfields("vapals:ceform","ceform-fields")
 d ceformGrouper^%wfhfields("ceform-fields")
 q
 ;
ceformGrouper(graph) ; fills in the group attribute for the cteval form
 ;
 n root,froot s root=$$setroot^%wd(graph)
 q:root=""
 s froot=$na(@root@("field"))
 n zi
 f  si=$o(@froot@(zi)) q:zi=""  d  ;
 . q
 q
 ;
wsCeformCopy(rtn,filter) ; web page for managing ceform copy flags
 ;
 n root,table,zi,gtop,gbot
 d HTMLTB2^KBAIWEB(.gtop,.gbot,"ceform fields and copy flags")
 m rtn=gtop
 s root=$$setroot^%wd("ceform-fields")
 n setter
 s setter=$g(filter("set"))
 i setter'="" d  ;
 . i setter[":" d  ;
 . . n zi,zj,ii
 . . s zi=$p(setter,":",1)
 . . s zj=$p(setter,":",2)
 . . f ii=zi:1:zj s @root@("field",ii,"copy")=1
 . e  s @root@("field",setter,"copy")=""
 s setter=$g(filter("unset"))
 i setter'="" d  ;
 . i setter[":" d  ;
 . . n zi,zj,ii
 . . s zi=$p(setter,":",1)
 . . s zj=$p(setter,":",2)
 . . f ii=zi:1:zj s @root@("field",ii,"copy")=""
 . e  s @root@("field",setter,"copy")=""
 n comment
 s comment=$g(filter("comment"))
 i comment'="" d  ;
 . n what,where
 . s where=$p(comment,";",1)
 . s what=$p(comment,";",2)
 . i where[":" d  ;
 . . n zi,zj,ii
 . . s zi=$p(where,":",1)
 . . s zj=$p(where,":",2)
 . . f ii=zi:1:zj s @root@("field",ii,"comment")=what
 . e  s @root@("field",where,"comment")=what
 n group
 s group=$g(filter("group"))
 i group'="" d  ;
 . n what,where
 . s where=$p(group,";",1)
 . s what=$p(group,";",2)
 . i where[":" d  ;
 . . n zi,zj,ii
 . . s zi=$p(where,":",1)
 . . s zj=$p(where,":",2)
 . . f ii=zi:1:zj s @root@("field",ii,"group")=what
 . e  s @root@("field",where,"group")=what
 n copy
 s copy=$g(filter("copy"))
 i copy'="" d  ;
 . n what,where
 . s where=$p(copy,";",1)
 . s what=$p(copy,";",2)
 . i where[":" d  ;
 . . n zi,zj,ii
 . . s zi=$p(where,":",1)
 . . s zj=$p(where,":",2)
 . . f ii=zi:1:zj s @root@("field",ii,"copy")=what
 . e  s @root@("field",where,"copy")=what
 s table("TITLE")="ceform fields and copy flags"
 s table("HEADER",1)="Number"
 s table("HEADER",2)="Group"
 s table("HEADER",3)="Name"
 s table("HEADER",4)="Copy"
 s table("HEADER",5)="Text"
 s table("HEADER",6)="Comment"
 S HTTPRSP("mime")="text/html"
 s zi=0
 f  s zi=$o(@root@("field",zi)) q:+zi=0  d  ;
 . s table(zi,1)=zi
 . s table(zi,2)=$g(@root@("field",zi,"group"))
 . s table(zi,3)=$g(@root@("field",zi,"name"))
 . s table(zi,4)=$g(@root@("field",zi,"copy"))
 . s table(zi,5)=$g(@root@("field",zi,"label"))
 . s table(zi,6)=$g(@root@("field",zi,"comment"))
 d GENHTML2^KBAIUTIL("rtn","table")
 S rtn($O(rtn(""),-1)+1)=gbot
 k rtn(0)
 q
 ;
