SAMIPI ;ven/arc/lgc - Patient lookup graph import & export utils ;Jan 14, 2020@14:16
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
 ;
 ; @section 1 code
 ;
 ;
FIX ;
 kill ^%wd(17.040801,67,"name")
 kill ^%wd(17.040801,67,"saminame")
 kill ^%wd(17.040801,67,"sinamel")
 kill ^%wd(17.040801,67,"sinamef")
 ;
 NEW PT SET PT=0
 FOR  SET PT=$ORDER(^%wd(17.040801,67,PT)) QUIT:'PT  DO
 . NEW SAMINAME,SINAMEF,SINAMEL
 . ;
 . SET SAMINAME=^%wd(17.040801,67,PT,"saminame")
 . ;
 . SET SINAMEL=$P(SAMINAME,",",1)
 . set SINAMEF=$P(SAMINAME,",",2)
 . SET SINAMEL=$$TRIM^XLFSTR(SINAMEL,"LR")
 . set SINAMEF=$$TRIM^XLFSTR(SINAMEF,"LR")
 . SET SAMINAME=SINAMEL_","_SINAMEF
 . ;
 . set ^%wd(17.040801,67,PT,"saminame")=SAMINAME
 . SET ^%wd(17.040801,67,PT,"sinamel")=SINAMEL
 . SET ^%wd(17.040801,67,PT,"sinamef")=SINAMEF
 . ;
 . SET ^%wd(17.040801,67,"name",SAMINAME,PT)=""
 . set ^%wd(17.040801,67,"name",$$UP^XLFSTR(SAMINAME),PT)=""
 . SET ^%wd(17.040801,67,"sinamel",SINAMEL,PT)=""
 . SET ^%wd(17.040801,67,"sinamef",SINAMEF,PT)=""
 ;
 QUIT
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
 set fields("icn")=""
 set fields("dob")=""
 set fields("last5")=""
 set fields("marital status")=""
 set fields("phone")=""
 set fields("saminame")=""
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
 new fields
 set fields("active duty")=""
 set fields("address1")=""
 set fields("address2")=""
 set fields("address3")=""
 set fields("age")=""
 set fields("city")=""
 set fields("county")=""
 set fields("dfn")=""
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
 new line set line=""
 new errmsg set errmsg=""
 new filepatient set filepatient=0
 ;
 for  use IO read line:1 quit:$$STATUS^%ZISH  do  quit:$length(errmsg)
 . do  quit:'(errmsg="")
 . . set errmsg=$S(POP:"file missing",'(line[$CHAR(9)):"file not TAB delimited",1:"")
 . if filepatient>0 do  ; Skip TSV file headers
 . . new PATIENT
 . . new field set field=""
 . . new fieldnum set fieldnum=0
 . . ;
 . . for  set field=$order(fields(field)),fieldnum=fieldnum+1 quit:(field="")  do
 . . . new datum set datum=$piece(line,$CHAR(9),fieldnum)
 . . . set PATIENT(field)=datum
 . . do UPDTPTL^SAMIHL7(.PATIENT)
 . set filepatient=filepatient+1
 ;
 do CLOSE^%ZISH
 ;
 write:$length(errmsg) !,!,"*** ",errmsg," ***",!,!
 ;
 quit  ; End of entry point IMPRTPTS
 ;
 ;
EOR ; End of routine SAMIPI
