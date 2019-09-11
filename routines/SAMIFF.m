SAMIFF ;ven/arc/lgc - Patient graph import & export utils ; 2019-07-31T16:56Z
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
 ; @last-updated: 2019-07-31T16:56Z
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
 . . . use $P write !,"Field: ",name
 . . . use $P write !,?4,"Values: ",$length(values,";")
 . . . use $P write !,?4,"Labels: ",$length(labels,";"),!
 . set fieldnum=fieldnum+1
 do CLOSE^%ZISH
 write:$l(errmsg) !,!,"*** ",errmsg," ***",!,!
 ;
 quit  ; End of label PRSTSV
 ;
 ;
UPDTLKUP ; Update the patient-lookup graph with data from the patient file
 new dfn set dfn=0
 for  set dfn=$order(^DPT(dfn)) quit:'dfn  do
 . write !,dfn,!
 . do PTINFO^SAMIVSTA(dfn)
 . do PTSSN^SAMIVSTA(dfn)
 ;
 quit
 ;
 ;
EXPRTPTS(path,file) ; Export the patient-lookup graph as a TSV file
 quit:($get(path)="")!($get(file)="")
 ;
 new fields
 set fields("active duty")=""
 set fields("address1")=""
 set fields("address2")=""
 set fields("address3")=""
 set fields("age")=""
 set fields("city")=""
 set fields("county")=""
 set fields("dfn")=""
 set fields("gender")=""
 set fields("icn")=""
 set fields("last5")=""
 set fields("marital status")=""
 set fields("phone")=""
 set fields("saminame")=""
 set fields("sbdob")=""
 set fields("sensitive patient")=""
 set fields("sex")=""
 set fields("sinamef")=""
 set fields("sinamel")=""
 set fields("ssn")=""
 set fields("state")=""
 set fields("zip")=""
 ;
 do OPEN^%ZISH("FILE",path,file,"W")
 ;
 ; Create file headers
 new line set line=""
 new count set count=0
 new field set field=""
 for  set field=$order(fields(field)),count=count+1 quit:field=""  do
 . if count>1  set line=line_$CHAR(9)
 . set line=line_field
 use IO write line,!
 ;
 ; Add patients to file
 new root set root=$$setroot^%wd("patient-lookup")
 ;
 new patient set patient=0
 for  set patient=$order(@root@(patient)) quit:'patient  do
 . set line=""
 . set count=0
 . set field=""
 . for  set field=$order(fields(field)),count=count+1 quit:(field="")  do
 . . if count>1  set line=line_$CHAR(9)
 . . set line=line_@root@(patient,field)
 . use IO write line,!
 ;
 do CLOSE^%ZISH
 ;
 quit  ; End of label EXPRTPTS
 ;
 ;
IMPRTPTS(path,file) ; Populate the patient-lookup graph based on a TSV file
 quit:($get(path)="")!($get(file)="")
 ;
 do purgegraph^%wd("patient-lookup")
 do addgraph^%wd("patient-lookup")
 new root set root=$$setroot^%wd("patient-lookup")
 ;
 new fields
 set fields("active duty")=""
 set fields("address1")=""
 set fields("address2")=""
 set fields("address3")=""
 set fields("age")=""
 set fields("city")=""
 set fields("county")=""
 set fields("dfn")=""
 set fields("gender")=""
 set fields("icn")=""
 set fields("last5")=""
 set fields("marital status")=""
 set fields("phone")=""
 set fields("saminame")=""
 set fields("sbdob")=""
 set fields("sensitive patient")=""
 set fields("sex")=""
 set fields("sinamef")=""
 set fields("sinamel")=""
 set fields("ssn")=""
 set fields("state")=""
 set fields("zip")=""
 ;
 do OPEN^%ZISH("FILE",path,file,"R")
 ;
 new patient set patient=0
 new errmsg set errmsg=""
 new line set line=""
 ;
 for  use IO read line:1 quit:$$STATUS^%ZISH  do  quit:$length(errmsg)
 . do  quit:'(errmsg="")
 . . set errmsg=$S(POP:"file missing",'(line[$CHAR(9)):"file not TAB delimited",1:"")
 . if patient>0  do ; Skip TSV file headers
 . . new field set field=""
 . . new fieldnum set fieldnum=0
 . . ;
 . . for  set field=$order(fields(field)),fieldnum=fieldnum+1 quit:(field="")  do
 . . . new datum set datum=$piece(line,$CHAR(9),fieldnum)
 . . . set @root@(patient,field)=datum
 . . . ; Set cross-references
 . . . if $get(datum)'=""  do
 . . . . if field="dfn" set @root@("dfn",datum,patient)=""
 . . . . if field="icn" set @root@("icn",datum)=patient
 . . . . if field="last5" set @root@("last5",datum,patient)=""
 . . . . if field="saminame"  do
 . . . . . set @root@("saminame",datum,patient)=""
 . . . . . set @root@("name",datum,patient)=""
 . . . . . set @root@("name",$$UP^XLFSTR(datum),patient)=""
 . . . . if field="sinamef" set @root@("sinamef",datum,patient)=""
 . . . . if field="sinamel" set @root@("sinamel",datum,patient)=""
 . . . . if field="ssn",$get(datum) set @root@("ssn",datum)=patient
 . set patient=patient+1
 ;
 do CLOSE^%ZISH
 ;
 set @root@("Date Last Updated")=$$HTE^XLFDT($horolog)
 ;
 write:$length(errmsg) !,!,"*** ",errmsg," ***",!,!
 ;
 quit  ; End of label IMPRTPTS
 ;
 ;
EOR ; End of routine SAMIFF
