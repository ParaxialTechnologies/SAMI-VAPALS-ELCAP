SAMIORM ;ven/arc/lgc - parse ORM to update  patient-lookup graph ;Sep 07, 2021@13:14
 ;;18.0;SAMI;;;Build 1
 ;
 ; This is a test change by ARC
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
 ;
quit ; no entry from top
 ;
 ;
EN ; Primary entry point
 ;
 kill ^TMP("SAMI","ORM")
 ;
 ; Immediately return COMM ACK
 do ACK^SAMIHL7
 ;
 ;
BLDARR ; pull out message into array
 ;
 new HLARR,cnt
 for  xecute HLNEXT quit:$get(HLNODE)=""  do
 . set cnt=$get(cnt)+1
 . set HLARR(cnt)=HLNODE
 ;
 kill ^KBAP("SAMIORM","BLDARR")
 merge ^KBAP("SAMIORM","BLDARR","HLARR")=HLARR
 ;
DEBUG ;do ^ZTER
 ;
 new fields
 new INFS set INFS=$G(HL("FS"))
 new INCC set INCC=$E($G(HL("ECH")))
 do PARSEMSG(.HLARR,.fields)
 ;
 ; update patient-lookup graph
 do UPDTPTL^SAMIHL7(.fields)
 ;
 quit  ; End entry point EN
 ;
 ;
PARSEMSG(HLARR,fields) ; Pull patient data from ORM message
 new cnt s cnt=0
 for  set cnt=$order(HLARR(cnt)) quit:'cnt  do
 . set SEG=$piece(HLARR(cnt),HL("FS"))
 . if SEG="PID" do PID(HLARR(cnt),.fields) quit
 . if SEG="OBR" do OBR(HLARR(cnt),.fields) quit
 quit
 ;
 ;
PID(segment,fields) ;
 new name,famname,givname,midname,sufname,prename,degname
 set fields("icn")=$piece(segment,INFS,3)
 set fields("dfn")=$piece($piece(segment,INFS,4),INCC)
 ;
 ; name field 5.1=family,5.2=given,5.3=middle,5.4=suffix,5.5=prefix,5.6=degree
 set name=$piece(segment,INFS,6)
 set famname=$piece(name,INCC)
 set givname=$piece(name,INCC,2)
 set midname=$piece(name,INCC,3)
 set:midname="" midname="NMI"
 set sufname=$piece(name,INCC,4)
 set prename=$piece(name,INCC,5)
 set degname=$piece(name,INCC,6)
 set name=famname_","_givname_" "_midname_" "_sufname
 set name=$$TRIM^XLFSTR(name,"R"," ")
 set fields("saminame")=name
 set fields("sinamef")=givname
 set fields("sinamel")=famname
 ;
 set fields("sbdob")=$piece(segment,INFS,8)
 set fields("sex")=$piece(segment,INFS,9)
 set fields("address1")=$piece($piece(segment,INFS,12),INCC)
 set fields("city")=$piece($piece(segment,INFS,12),INCC,3)
 set fields("state")=$piece($piece(segment,INFS,12),INCC,4)
 set fields("zip")=$piece($piece(segment,INFS,12),INCC,5)
 set fields("phone")=$piece(segment,INFS,14)
 set fields("ssn")=$piece(segment,INFS,20)
 quit
 ;
OBR(segment,fields) ;
 set fields("order")=$piece($piece(segment,INFS,5),INCC)
 set fields("order2")=$piece($piece(segment,INFS,5),INCC,2)
 set fields("orddate")=$piece(segment,INFS,8)
 set fields("orddoc")=$piece(segment,INFS,17)
 set fields("ordserv")=$piece(segment,INFS,19)
 set fields("orddateB")=$piece(segment,INFS,23)
 quit
 ;
 ;
TEST ;
 K HLARR
 set HLARR(1)="MSH^~&|\^LSS-SVR^PHOENIX^VAPALS-ELCAP APP^VISTA HEALTH CARE^202002021234-0800^^ORM~O01^9339000006^P^2.4^^^AL^NE^"
 set HLARR(2)="PID^^50001000V910386^1~8~M10^^FOURTEEN~PATIENT~N^^19560708^M^^7^10834 DIXIN DR SOUTH~""""""""~SEATTLE~WA~98178^53033^(206)772-2059^^^""""""""^29^^444678924^^^^BostonMASSACHUSETTS"""
 set HLARR(3)="ORC^NW^^^^^^^^199104301000"
 set HLARR(4)="OBR^^^^7089898.8453-1~040391-66~L^^^199104301200^""""^""""^^^^^""""^^3232~HL7Doctor~One^^MEDICINE^^^^199104301000"
 set HLARR(5)="OBX^^CE^P~PROCEDURE~L^^100~CHEST PA & LAT~L"
 set HLARR(6)="OBX^^TX^M~MODIFIERS~L^^RIGHT, PORTABLE"
 set HLARR(7)="OBX^^TX^H~HISTORY~L^^None"
 set HLARR(8)="OBX^^TX^A~ALLERGIES~L^^BEE STINGS"
 quit
 ;
EOR ; End of routine SAMIORM
