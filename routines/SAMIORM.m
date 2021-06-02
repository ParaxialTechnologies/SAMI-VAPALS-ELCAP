SAMIORM ;ven/arc/lgc - parse ORM to update  patient-lookup graph ;May 27, 2021@13:54
 ;;18.0;SAMI;;;Build 1
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
 ;
 ; @section 1 code
 ;
 ; SAMIORM parses out an incoming ORM message into the
 ;   fields array and then calls ORMHL7 to use the fields
 ;   array to update patient-lookup graph
 ;
EN ; ORM message parsed into patient-lookup graph
 ;
 kill ^KBAP("SAMIORM")
 set ^KBAP("SAMIORM","EN")=$$HTFM^XLFDT($H)_" TEST"
 ;
 ; Immediately return COMM ACK  ***** TMP TURNED OFF
 do ACK^SAMIHL7
 ;
 ;
BLDARR ; pull out message into samihl7 array
 ;
 new HLARR,cnt,samihl7,invdt,hl7cnt
 set invdt=(9999999.9999-$$HTFM^XLFDT($H))
 ;
 for  xecute HLNEXT quit:$get(HLNODE)=""  do
 . set cnt=$get(cnt)+1
 . set HLARR(cnt)=HLNODE
 . set samihl7(cnt)=HLNODE
 ;
 kill ^KBAP("SAMIORM","BLDARR")
 merge ^KBAP("SAMIORM","BLDARR","HLARR")=HLARR
 ;
 new INFS set INFS=$G(HL("FS"))
 new INCC set INCC=$E($G(HL("ECH")))
 ;
 new fields
 set fields("ORM",invdt,"msgid")=$get(HLREC("MID"))
 ;
 ;pull patient data from ORM message into fields array
PMSG do PARSEMSG(.HLARR,.fields) ; Pull patient data from ORM message
 ;
 merge ^KBAP("SAMIORM","samihl7")=samihl7
 merge ^KBAP("SAMIORM","fields")=fields
 ;
 ;  update patient-lookup graph using fields array
UPDTPTL do UPDTPTL^SAMIHL7(.fields)
 ;
 merge ^KBAP("SAMIORM","fields")=fields
 ;
 ; At this point the fields have been filed in the patient
 ;   with ptien into the patient lookup graph.
 ; I have the ptien in fields("ptien") and I have the HL7
 ;   message segments in samihl7
 ; Time to file the actual hl7 message into patient lookup
 ; NOTE: @rootpl@(ptien,"hl7 counter") was updated in UPDTPTL^SAMIHL7
 ;
 new ptien set ptien=$get(fields("ptien"))
 if 'ptien quit
 ;
 new rootpl,hl7cnt,cnt,seg
 set rootpl=$$setroot^%wd("patient-lookup")
 set hl7cnt=$get(@rootpl@(ptien,"hl7 counter"))
 set fields("ORM",hl7cnt,"msgid")=$get(HLREC("MID"))
 set cnt=0
 for  set cnt=$order(samihl7(cnt)) quit:'cnt  do
 . set seg=$extract(samihl7(cnt),1,3)
 . set @rootpl@(ptien,"hl7",hl7cnt,seg)=samihl7(cnt)
 ;
 quit  ; End entry point EN
 ;
 ;
PARSEMSG(HLARR,fields) ;
 set ^KBAP("SAMIORM","PARSEMSG","INFS")=$get(INFS)
 set ^KBAP("SAMIORM","PARSEMSG","INCC")=$get(INCC)
 ; Pull patient data from ORM message
 new cnt s cnt=0
 for  set cnt=$order(HLARR(cnt)) quit:'cnt  do
 . set segment=HLARR(cnt)
 . new SEG set SEG=$piece(HLARR(cnt),HL("FS"))
 . if SEG="PID" do PID(segment,.fields)
 . if SEG="PV1" do PV1(segment,.fields)
 . if SEG="ORC" do ORC(segment,.fields)
 . if SEG="OBR" do OBR(segment,.fields)
 ;
 merge ^KBAP("SAMIORM","fields")=fields
 quit
 ;
 ;
PID(segment,fields) ;
 ;
 set ^KBAP("SAMIORM","fields","PID","segment")=segment
 ;
 new name,fname,lname,mname,suffix
 set fields("icn")=""
 set fields("ssn")=$piece($piece(segment,INFS,4),INCC)
 ;
 set name=$piece(segment,INFS,6)
 set lname=$$CAMELCAS($piece(name,INCC,1))
 set fname=$$CAMELCAS($piece(name,INCC,2))
 set (mname,suffix)=""
 if $length($piece(segment,INFS,6),INCC)>2 do
 . set mname=$$CAMELCAS($piece($piece(segment,INFS,6),INCC,3))
 if $length($piece(segment,INFS,6),INCC)>3 do
 . set suffix=$$UP^XLFSTR($piece($piece(segment,INFS,6),INCC,4))
 ;
 if $length(mname) set fname=fname_" "_mname
 if $length(suffix) set lname=lname_" "_suffix
 set name=lname_","_fname
 set fields("saminame")=name
 set fields("sinamef")=fname
 set fields("sinamel")=lname
 ;
 if $length(fields("ssn")),$length(fields("saminame")) do
 . set fields("last5")=$$UP^XLFSTR($extract(fields("saminame")))_$extract(fields("ssn"),6,9)
 . set ^KBAP("SAMIORM","MadeLast5")=$get(fields("last5"))
 ;
 set fields("sbdob")=$piece(segment,INFS,8)
 set fields("sex")=$piece(segment,INFS,9)
 ;
ORMADDR set fields("ORM",invdt,"fulladdress")=$piece(segment,INFS,12)
 ;
 set fields("address1")=$piece($piece(segment,INFS,12),INCC)
 set fields("city")=$piece($piece(segment,INFS,12),INCC,3)
 set fields("state")=$piece($piece(segment,INFS,12),INCC,4)
 set fields("zip")=$piece($piece(segment,INFS,12),INCC,5)
 set fields("phone")=$piece(segment,INFS,14)
 ;set fields("ssn")=$piece(segment,INFS,20)
 quit
 ;
PV1(segment,fields) ;
 ;
 set ^KBAP("SAMIORM","fields","PIV","segment")=segment
 ;
 set fields("ORM",invdt,"patientclass")=$piece(segment,INFS,3)
 set fields("ORM",invdt,"assignedlocation")=$piece(segment,INFS,4)
 set fields("ORM",invdt,"providerien")=$piece($piece(segment,INFS,9),INCC)
 set fields("ORM",invdt,"providernm")=$tr($piece($piece(segment,INFS,9),INCC,2,4),"^",",")
 quit
 ;
ORC(segment,fields) ;
 ;
 set ^KBAP("SAMIORM","fields","ORC","segment")=segment
 ;
 set fields("ORM",invdt,"ordercontrol")=$piece(segment,INFS,2)
 set fields("ORM",invdt,"ordernumber")=$piece(segment,INFS,3)
 set fields("ORM",invdt,"orderstatus")=$piece(segment,INFS,6)
 set fields("ORM",invdt,"transactiondt")=$piece(segment,INFS,10)
 set fields("ORM",invdt,"ordereffectivedt")=$piece(segment,INFS,16)
 quit
 ;
OBR(segment,fields) ;
 ;
 set ^KBAP("SAMIORM","fields","OBR","segment")=segment
 ;
 set fields("ORM",invdt,"order")=$piece($piece(segment,INFS,5),INCC)
 ;
 set fields("ORM",invdt,"siteid")=$piece($piece($piece(segment,INFS,5),INCC),"_")
 set fields("siteid")=$piece($piece($piece(segment,INFS,5),INCC),"_")
 ;
 set fields("ORM",invdt,"order2")=$piece($piece(segment,INFS,5),INCC,2)
 quit
 ;
 ;
CAMELCAS(str) ;
 ;
 if $get(str)="" quit str
 set str=$$LOW^XLFSTR(str)
 set str=$$UP^XLFSTR($extract(str,1))_$extract(str,2,$length(str))
 quit str
 ;
TEST K HLARR
 set HLARR(1)="MSH|^~\&|MCAR-INST|VISTA|INST-MCAR|VAPALS|20200616135751-0700||ORM^O01|6442288610689|P|2.3|||||USA"
 set HLARR(2)="PID|1||000002341||ZZTEST^MACHO^^^^^L||19271106000000|M|||7726 W ORCHID ST^^PHOENIX^AZ^85017||||||||000002341|"
 set HLARR(3)="PV1||O|PHX-PULM RN LSS PHONE|||||244088^GARCIA^DANIEL^P"
 set HLARR(4)="ORC|NW|3200616135751|||NW||||20200616135751||||||20200616135751"
 set HLARR(5)="OBR||||PHO_LUNG^LUNG|"
 ;
 D HLENV^SAMIORU("MCAR ORM SERVER")
 set HLNEXT="D HLNEXT^HLCSUTL"
 set HLQUIT=0
 DO EN
 quit
 ;
EOR ; End of routine SAMIORM
