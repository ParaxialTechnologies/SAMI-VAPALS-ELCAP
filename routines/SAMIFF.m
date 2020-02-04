SAMIFF ;ven/arc/lgc - Import TSV file to define form fields ;Jan 17, 2020@12:29
 ;;18.0;SAMI;;
 ;
 quit  ; No entry from top
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev:
 ;   Alexis Carlson (arc)
 ;     alexis.carlson@vistaexpertise.net
 ;   Larry "poo" Carlson (lgc)
 ;     larry@fiscientific.com
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;   Add label comments
 ;
 ; @change-log
 ;   2019-03-22 ven/arc : Have PRSTSV report fields for which the number of
 ;     values does not match the number of labels
 ;   2019-07-31 arc/ven : Add entry points to expand and update what's in the
 ;     patient-lookup graph, export the patient-lookup graph for Phoenix, and
 ;     import a TSV to pre-populate the patient-lookup graph
 ;
 ; @section 1 code
 ;
 ;
PRSTSV(path,filename,graphname) ; Parse TSV file and build graph of form fields
 ; @input
 ;   path = full path, eg. - "/home/osehra/lib/silver/va-pals/form-fields/"
 ;   filename = name of TSV file, eg. - "intake-form-fields.tsv"
 ;   graphname = name of graph to build
 ;
 quit:($get(path)="")!($get(filename)="")!($get(graphname)="")
 ;
 do purgegraph^%wd(graphname)
 do addgraph^%wd(graphname)
 new root set root=$$setroot^%wd(graphname)
 ;
 new fieldnum set fieldnum=0
 new inputnum set inputnum=0
 new question,name,type,required,placeholder,values,labels,cnt
 new errmsg s errmsg=""
 ;
 do OPEN^%ZISH("FILE",path,filename,"R")
 new line
 s cnt=1
 ;
 for  use IO read line:1 quit:$$STATUS^%ZISH  do  q:$length(errmsg)
 . set cnt=cnt+1
 . do  q:'(errmsg="")
 . . set errmsg=$S(POP:"file missing",'(line[$CHAR(9)):"file not TAB delimited",1:"")
 . if fieldnum>0 do  ; Skip TSV file column headers
 . . set question=$piece(line,$CHAR(9),2)
 . . set name=$piece(line,$CHAR(9),3)
 . . set type=$piece(line,$CHAR(9),4)
 . . set required=$piece(line,$CHAR(9),5)
 . . set placeholder=$piece(line,$CHAR(9),6)
 . . set values=$piece(line,$CHAR(9),7)
 . . set labels=$piece(line,$CHAR(9),8)
 . . ; Check that the number of values matches the number of labels
 . . if $length(values,";")=$length(labels,";") do
 . . . for inputnum=1:1 quit:inputnum>$length(values,";")  do
 . . . . new value,label
 . . . . set @root@("field",fieldnum,"input",inputnum,"question")=question
 . . . . set @root@("field",fieldnum,"input",inputnum,"name")=name
 . . . . set @root@("field",fieldnum,"input",inputnum,"type")=type
 . . . . set @root@("field",fieldnum,"input",inputnum,"required")=required
 . . . . set @root@("field",fieldnum,"input",inputnum,"placeholder")=placeholder
 . . . . set value=$piece(values,";",inputnum)
 . . . . set @root@("field",fieldnum,"input",inputnum,"value")=value
 . . . . set label=$piece(labels,";",inputnum)
 . . . . set @root@("field",fieldnum,"input",inputnum,"label")=label
 . . . . i '($get(value)=""),'($get(label)="") set @root@("field","C",name,value,label)=""
 . . . set @root@("field","B",name,fieldnum)=""
 . . else  do
 . . . use $P write !,"Form: ",$piece(graphname," - ",2)
 . . . use $P write !,?4,"Field: ",name
 . . . use $P write !,?8,"Values: ",$length(values,";")
 . . . use $P write !,?8,"Labels: ",$length(labels,";"),!
 . set fieldnum=fieldnum+1
 do CLOSE^%ZISH
 write:$l(errmsg) !,!,"*** ",errmsg," ***",!,!
 write $J
 quit  ; End of entry point PRSTSV
 ;
 ;
EOR ; End of routine SAMIFF
