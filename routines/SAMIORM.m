SAMIORM ;ven/arc/lgc - parse ORM to update  patient-lookup graph ;Feb 04, 2020@14:26
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
 ;
 quit  ; No entry from top
 ;
 ;
TESTERR ; Test entry point
 ;
 quit  ; End of entry point TESTERR
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
 new name
 set fields("icn")=$piece(segment,INFS,3)
 set fields("dfn")=$piece($piece(segment,INFS,4),INCC)
 ;
 set name=$piece(segment,INFS,6)
 set name=$piece(name,INCC)_","_$piece(name,INCC,2)
 if $length($piece(segment,INFS,6),INCC)>2 do
 . set name=name_" "_$piece($piece(segment,INFS,6),INCC,3)
 set fields("saminame")=name
 set fields("sinamef")=$piece(name,",",2)
 set fields("sinamel")=$piece(name,",")
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
TEST K HLARR
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
