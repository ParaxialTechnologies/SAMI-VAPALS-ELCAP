SAMIADT ;ven/arc/lgc - Handler for HL7 ADTs ;Oct 17, 2019@16:19
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
 quit  ; No entry from top
 ;
 ;
TESTERR ; Test entry point
 do ^ZTER;
 ;
 quit ; End of entry point TESTERR
 ;
 ;
EN ; Primary entry point
 ;
 kill ^TMP("SAMI","ADT")
 ;
 new segtype set segtype=""
 new segment set segment=""
 ;
 for  xecute HLNEXT quit:$get(HLNODE)=""  do
 . set segtype=$extract(HLNODE,1,3)
 . set segment=$extract(HLNODE,5,$length(HLNODE))
 . if (segtype="MSH")!(segtype="PID") do @segtype@(segment)
 ;
 quit  ; End entry point EN
 ;
 ;
PARSESEG(segment,segmentfields,graphfields) ;
 ;
 new separators
 set separators("field")="^"
 set separators("component")="~"
 set separators("field repetition")="|"
 set separators("sub-component")="&"
 set separators("escape")="\"
 ;
 set graphfields("active duty")=""
 set graphfields("address1")=""
 set graphfields("address2")=""
 set graphfields("address3")=""
 set graphfields("age")="" ; We get DOB
 set graphfields("city")=""
 set graphfields("county")=""
 set graphfields("dfn")=""
 set graphfields("gender")="" ; M^MALE - we only get M (in sex)
 set graphfields("icn")=""
 set graphfields("last5")="" ; We get name and SSN
 set graphfields("marital status")=""
 set graphfields("phone")=""
 set graphfields("saminame")=""
 set graphfields("sbdob")=""
 set graphfields("sensitive patient")=""
 set graphfields("sex")="" ; M
 set graphfields("sinamef")=""
 set graphfields("sinamel")=""
 set graphfields("ssn")=""
 set graphfields("state")=""
 set graphfields("zip")=""
 ;
 new node,subnode,field,component
 set node=0
 set field="",component=""
 for  set node=$order(segmentfields(node)) quit:'node  do
 . if $data(segmentfields(node))=11 do
 . . set subnode=0
 . . for  set subnode=$order(segmentfields(node,subnode)) quit:'subnode  do
 . . . if $get(segmentfields(node,subnode))'="" do
 . . . . set graphfields(segmentfields(node,subnode))=$piece($piece(segment,separators("field"),node),separators("component"),subnode)
 . . . . if graphfields(segmentfields(node,subnode))="""""""""" set graphfields(segmentfields(node,subnode))=""
 . else  do
 . . if $get(segmentfields(node))'="" do
 . . . set graphfields(segmentfields(node))=$piece(segment,separators("field"),node)
 . . . if graphfields(segmentfields(node))="""""""""" set graphfields(segmentfields(node))=""
 ;
 ; Handle special cases
 new countyien,county,ERR
 if graphfields("sbdob")'="" set graphfields("age")=$$age^%th($$HL7TFM^XLFDT(graphfields("sbdob")))
 if graphfields("county")'="" do
 . set countyien=$$FIND1^DIC(5.13,,"B",graphfields("county"),,,"ERR")
 . if '$data(ERR)&(countyien'=0) set county=$$GET1^DIQ(5.13,countyien,1,,,"ERR")
 . if '$data(ERR)&(county'="") set graphfields("county")=county
 set graphfields("dfn")=+graphfields("dfn")
 set graphfields("last5")=$extract(graphfields("sinamel"),1)_$extract(graphfields("ssn"),6,9)
 set graphfields("saminame")=graphfields("sinamel")_","_graphfields("sinamef")
 if graphfields("sex")="F" set graphfields("gender")="F^FEMALE"
 if graphfields("sex")="M" set graphfields("gender")="M^MALE"
 ;
 quit  ; End entry point PARSESEG
 ;
 ;
MSH(segment) ;
 ;
 ; set ^TMP("SAMI","ADT","MSH")=segment
 do:'($get(%ut)) ACK^SAMIHL7
 ;
 quit  ; End entry point MSH
 ;
 ;
PID(segment) ;
 ;
 new segmentfields
 set segmentfields(1)="address1"
 set segmentfields(2)="icn"
 set segmentfields(3)="dfn"
 set segmentfields(5)=""
 set segmentfields(5,1)="sinamel"
 set segmentfields(5,2)="sinamef"
 set segmentfields(7)="sbdob"
 set segmentfields(8)="sex" ; Use this for sex and expand for gender
 set segmentfields(11)=""
 set segmentfields(11,1)="address1"
 set segmentfields(11,3)="city"
 set segmentfields(11,4)="state"
 set segmentfields(11,5)="zip"
 set segmentfields(12)="county"
 set segmentfields(13)="phone"
 set segmentfields(19)="ssn"
 ;
 new graphfields
 do PARSESEG(segment,.segmentfields,.graphfields)
 ;
 ; merge ^TMP("SAMI","ADT","PID")=graphfields
 do UPDTPTL^SAMIHL7(.graphfields)
 ;
 quit  ; End of entry point PID
 ;
 ;
EOR ; End of routine SAMIADT
