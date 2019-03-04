KBAPDD ;ven/lgc - Build DD from HTML ; 3/4/19 12:42pm
 ;;SAMI;;
 q
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
 K ^KBAP("CEF","KBAPDD")
 s path="/home/osehra/tmp/"
 S filename="cef_data.txt"
 d OPEN^%ZISH("FILE",path,filename,"R")
 n name,label,value,root
 s (gien,name,label,value)=""
 s root=$$setroot^%wd("ceform-fields")
 n linecnt s linecnt=0
 F  U IO R LINE Q:$$STATUS^%ZISH  D
 . s linecnt=$g(linecnt)+1
 . s name=$p(LINE,"^")
 . s label=$p(LINE,"^",2)
 . s value=$p(LINE,"^",3)
 . i $l(name) s gien=$g(@root@("field",name))
 . i gien d
 .. s @root@("field",gien,"label")=$g(label)
 .. s @root@("field",gien","value")=$g(value)
 . U $P W !,LINE
 D CLOSE^%ZISH
 Q
