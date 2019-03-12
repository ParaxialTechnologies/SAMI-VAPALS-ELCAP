SAMIFF ;ven/lgc,arc - Build a graph of form fields ; 2019-03-12T01:32Z
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev:
 ;  Larry "poo" Carlson (lgc)
 ;   
 ;  Alexis Carlson (arc)
 ;   alexis@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;   Add label comments
 ;
 ; @section 1 code
 ;
 quit ; No entry from top
 ;
 ;
PRSTSV(path,filename,graphname) ; Parse TSV file and build graph
 ; @input
 ;  path = full path, eg. - "/home/osehra/lib/silver/va-pals/form-fields/"
 ;  filename = name of TSV file, eg. - "intake-form-fields.tsv"
 ;  graphname = name of graph to build
 ;
 quit:($get(path)="")!($get(filename)="")!($get(graphname)="")
 ;
 do purgegraph^%wd(graphname)
 do addgraph^%wd(graphname)
 new root set root=$$setroot^%wd(graphname)
 ;
 new fieldnum set fieldnum=0
 new inputnum set inputnum=0
 new question,name,type,required,placeholder,values,labels
 ;
 do OPEN^%ZISH("FILE",path,filename,"R")
 ;
 for  use IO read LINE quit:$$STATUS^%ZISH  do
 . if fieldnum>0 do; Skip TSV file column headers
 . . set question=$piece(LINE,$CHAR(9),1)
 . . set name=$piece(LINE,$CHAR(9),2)
 . . set type=$piece(LINE,$CHAR(9),3)
 . . set required=$piece(LINE,$CHAR(9),4)
 . . set placeholder=$piece(LINE,$CHAR(9),5)
 . . set values=$piece(LINE,$CHAR(9),6)
 . . set labels=$piece(LINE,$CHAR(9),7)
 . . ;
 . . for inputnum=1:1 quit:inputnum>$length(values,";")  do
 . . . set @root@("field",fieldnum,"input",inputnum,"QUESTION")=question
 . . . set @root@("field",fieldnum,"input",inputnum,"NAME")=name
 . . . set @root@("field",fieldnum,"input",inputnum,"TYPE")=type
 . . . set @root@("field",fieldnum,"input",inputnum,"REQUIRED")=required
 . . . set @root@("field",fieldnum,"input",inputnum,"PLACEHOLDER")=placeholder
 . . . set @root@("field",fieldnum,"input",inputnum,"VALUE")=$piece(values,";",inputnum)
 . . . set @root@("field",fieldnum,"input",inputnum,"LABEL")=$piece(labels,";",inputnum)
 . . set @root@("field","B",name,fieldnum)=""
 . set fieldnum=fieldnum+1
 . set value="",label=""
 do CLOSE^%ZISH
 ;
 quit
 ;
 ;
START ;
 K ^KBAP("KBAPDD")
 s path="/home/osehra/lib/silver/va-pals/docs/www/"
 S filename="ctevaluation.html"
 d OPEN^%ZISH("FILE",path,filename,"R")
 n optval s optval=""
 n linecnt s linecnt=0
 F  U IO R LINE Q:$$STATUS^%ZISH  D
 . s linecnt=$g(linecnt)+1
 . I LINE["<option value=" D
 .. s optval=$tr($p($P(LINE,"option value=",2),">"),"""")
 .. s ^KBAP("KBAPDD",linecnt)=LINE
 . I LINE["id=" D
 .. n inputval,title,type,id
 .. s (inputval,title,type,it)=""
 .. s id=$P($P(LINE,"id=",2)," ")
 .. I LINE["input value" D
 ... s inputval=$P($P(LINE,"input value=",2),"class")
 .. I LINE["title=" D
 ... s title=$P($P(LINE,"title=",2),"type=")
 .. I LINE["type=" D
 ... S title=$P($P(LINE,"title=",2),"/")
 .. U $P W !,!,linecnt," id=",id
 .. i inputval]"" W !,?5,"input value=",inputval
 .. i title]"" W !,?5,"title=",title
 .. i type]"" W !,?5,"type=",type
 . I '(optval=""),(LINE'["<") D  Q
 .. U $P W !,linecnt,?5,"option value:",optval,"   Disp: ",LINE
 .. s optval=""
 . I LINE'["<" U $P W !,linecnt,?5,"Displayed:",LINE
 D CLOSE^%ZISH
 Q
 ;
 ; "bxform-2018-10-21"
 ; "ceform-2019-02-25"
 ; "fuform-2018-10-21"
 ; "ptform-2018-10-21"
 ; "sbform-2018-10-21"
 ; "itform-2018-10-21"
 ;
BLDFILE(formkey) ;
 q:$g(formkey)=""
 n filename s filename=$p(formkey,"-")_"-fields"
 n name,root,rootvp,node,snode
 s root=$$setroot^%wd(filename)
 k @root
 s @root@(0)=filename
 s rootvp=$$setroot^%wd("vapals-patients")
 s node=$na(@rootvp@("graph","XXX00001",formkey))
 s snode=$p(node,")"),cnt=0
 f  s node=$q(@node) q:node'[snode  d
 . s name=$qs(node,6),cnt=cnt+1
 . s @root@("field",cnt,"name")=name
 . s @root@("field",name)=cnt
 q
 ;
BLDCEF ;
 n name,label,value,line,root
 s root=$$setroot^%wd("ceform-fields")
 k @root
 s @root@(0)="ceform-fields"
 n linecnt s linecnt=0
 F  S linecnt=$o(^KBAP("CEF","KBAPDD",linecnt)) q:'linecnt  d
 . q:(linecnt<4)
 . s line=^KBAP("CEF","KBAPDD",linecnt)
 . q:($TR(line," ")="")
 .; if this line defines a new variable save the name
 .;   and build an index entry
 . i $l($$TRIM^XLFSTR($p(line,"^"),"LR"," ")) d
 .. s name=$$TRIM^XLFSTR($p(line,"^"),"LR"," ")
 .. s @root@("field",$g(name))=(linecnt-1)
 .;
 . s label=$$TRIM^XLFSTR($p(line,"^",2),"LR"," ")
 . s value=$$TRIM^XLFSTR($p(line,"^",3),"LR"," ")
 . s @root@("field",(linecnt-3),"name")=$g(name)
 . s @root@("field",(linecnt-3),"label")=$g(label)
 . s @root@("field",(linecnt-3),"value")=$g(value)
 q
 ;
 ; Use text file in tmp to build ^KBAP file
 ;e.g. filename="BGFORM.txt"
BLDKBAP(filename) ;
 q:$g(filename)=""
 n linecnt s linecnt=0
 K ^KBAP(filename,"KBAPDD")
 s path="/home/osehra/tmp/"
 d OPEN^%ZISH("FILE",path,filename,"R")
 F  U IO R LINE Q:$$STATUS^%ZISH  D
 . s linecnt=$g(linecnt)+1
 . U $P W !,!,linecnt
 . S ^KBAP($p(filename,"."),"KBAPDD",linecnt)=LINE
 D CLOSE^%ZISH
 Q
 ;
 ;
 ; use KBAP file to build graphstore file
 ;kbapname  = name of KBAP global array
 ;gname     = name of graphstore to build
 ;    e.g. D PRSDOMF^KBAPDD("BGFORM","background-form-variables")
 ;         D PRSDOMF^KBAPDD("INTVFORM","intervention-form-variables")
 ;         D PRSDOMF^KBAPDD("FUFORM","followup-form-variables")
 ;         D PRSDOMF^KBAPDD("CEFORM","CTevaluation-form-variables")
PRSDOMF(kbapname,gname) ; Parse a file
 q:$g(kbapname)=""
 q:$g(gname)=""
 s rootg=$$setroot^%wd(gname)
 k @rootg
 s @rootg@(0)=gname
 n name,type,values,labels,required
 n linecnt,gcnt s (linecnt,gcnt)=0
 n rootk s rootk=$na(^KBAP(kbapname,"KBAPDD"))
 f  s linecnt=$o(@rootk@(linecnt)) q:'linecnt  d
 . s name=$p(@rootk@(linecnt),$C(9),1)
 . s type=$p(@rootk@(linecnt),$C(9),2)
 . s values=$p(@rootk@(linecnt),$C(9),3)
 . s labels=$p(@rootk@(linecnt),$C(9),4)
 . s required=$p(@rootk@(linecnt),$C(9),5)
 .;
 . w !,"name=",name
 . w !,"type=",type
 . w !,"values=",values
 . w !,"labels=",labels
 . w !,"required=",required,!
 . D BLDGSENT(name,type,values,labels,required,rootg,.gcnt)
 q
 ;
BLDGSENT(name,type,values,labels,required,rootg,gcnt) ;
 q:$g(name)=""
 i values'["," d  q
 . s gcnt=gcnt+1
 . s @rootg@(gcnt,"name")=name
 . s @rootg@(gcnt,"type")=type
 . s @rootg@(gcnt,"value")=values
 . s @rootg@(gcnt,"label")=labels
 . s @rootg@(gcnt,"required")=required
 ;
 n value,label,vcnt
 s vcnt=$L(values,",")
 f i=1:1:vcnt d
 . s value=$p(values,",",i) q:value=""
 . s gcnt=gcnt+1
 . s label=$p(labels,",",i)
 . s @rootg@(gcnt,"name")=name
 . s @rootg@(gcnt,"type")=type
 . s @rootg@(gcnt,"value")=value
 . s @rootg@(gcnt,"label")=label
 . s @rootg@(gcnt,"required")=required
 q
 ;
EOR ; End of routine KBAPDD
