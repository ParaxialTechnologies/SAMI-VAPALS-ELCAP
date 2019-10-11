SAMIVHL ;SAMI/lgc/arc - HL7 TIU processing for VAPALS ;Oct 03, 2019@15:57
 ;;18.0;SAMI;
 ;
 quit  ; no entry from top
 ;
 ;
EN ;
 ;do ^ZTER
 ;
 ;
 ;---------- PREPARE FOR SENDING ACK/NAK --------------------------
 ;
 ; Move message from HL7 global to ^KBAP(
 ; 
 new nodecnt
 kill ^KBAP("SAMIVHL")
 ;
 ; Save every segment to the ^KBAP("SAMIVHL" global
 for  X HLNEXT Q:HLQUIT'>0  do  quit:HLNODE=""  do SVNODE
 ;
 ;Now run processing routine to put patient data
 ;   into VAPALS patient-lookup graph
 D RECTIU
 ;
 ; Don't (ACK)nowledge ACK messages (ien into file 771.2)
 I $G(HL("MTP"))=1 Q
 ;
 ; Send ACK message
ACK I $D(HLA("HLA")) S HLP("NAMESPACE")="HL" D
 . D GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"LM",1,.HLMTIENA,"",.HLP)
 ;
 Q
 ;
SVNODE new kbapcnt
 set ^KBAP("SAMIVHL",0)=$get(^KBAP("SAMIVHL",0))+1
 set kbapcnt=$get(^KBAP("SAMIVHL",0))
 set ^KBAP("SAMIVHL",kbapcnt)=HLNODE
 Q
 ;
RECTIU ; Parse contents of ^KBAP("SAMIVHL") into patient-lookup graph
 ; DEBUG - note for now we delete the existing patient-lookup graph
 ;
 ;D DELPTL^SAMIHL7
 new node,nodecnt,fieldstr,fields
 set fieldstr="",nodecnt=0
 for  set nodecnt=$order(^KBAP("SAMIVHL",nodecnt)) quit:'nodecnt  do
 . if ^KBAP("SAMIVHL",nodecnt)["MSH^~" quit
 . if ^KBAP("SAMIVHL",nodecnt)["active duty" do  quit
 .. set fieldstr=^KBAP("SAMIVHL",nodecnt)
 .; ok we have a node with patient data
 . s node=^KBAP("SAMIVHL",nodecnt)
 . do PARSE(node,fieldstr,.fields)
 . do UPDTPTL^SAMIHL7(.fields)
 quit
 ;
PARSE(node,fieldstr,fields) ;
 kill fields
 new nodecnt,fldcnt,ss
 for fldcnt=1:1:$length(fieldstr,"^") do
 . set ss=$piece(fieldstr,"^",fldcnt)
 . set nodecnt=$get(nodecnt)+1
 . set fields(ss)=$piece(node,"^",nodecnt)
 .; if we are at gender remember this is the one field
 .;  where the answer in our node is two consecutive 
 .;  pieces (e.g. M^MALE) so we bump just the nodecnt
 .;  an additional time
 . if ss="gender" do
 .. s nodecnt=$get(nodecnt)+1
 .. s fields(ss)=fields(ss)_"^"_$piece(node,"^",nodecnt)
 ;
 zwr fields
 write !
 quit
 ;
 ;
 ;
EOR ;End of routine SAMIVHL
