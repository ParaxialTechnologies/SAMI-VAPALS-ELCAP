SAMIUTVR ; ven/lgc,arc - UNIT TESTS for SAMIVST5 ; 3/18/19 9:40am
 ;;1.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ;@routine-credits
 ;@primary development organization: Vista Expertise Network
 ;@primary-dev: Larry G. Carlson (lgc)
 ;@primary-dev: Alexis R. Carlson (arc)
 ;@additional-dev: Linda M. R. Yaw (lmry)
 ;@copyright:
 ;@license: see routine SAMIUL
 ;
 ;@last-updated: 2019-02-28
 ;@application: VA-PALS
 ;@version: 1.0
 ;
 ;@sac-exemption
 ; sac 2.2.8 Vendor specific subroutines may not be called directly
 ;  except by Kernel, Mailman, & VA Fileman.
 ; sac 2.3.3.2 No VistA package may use the following intrinsic
 ;  (system) variables unless they are accessed using Kernel or VA
 ;  FileMan supported references: $D[EVICE], $I[O], $K[EY],
 ;  $P[RINCIPAL], $ROLES, $ST[ACK], $SY[STEM], $Z*.
 ;  (Exemptions: Kernel & VA Fileman)
 ; sac 2.9.1: Application software must use documented Kernel
 ;  supported references to perform all platform specific functions.
 ;  (Exemptions: Kernel & VA Fileman)
 ;
START if $text(^%ut)="" write !,"*** UNIT TEST NOT INSTALLED ***" quit
 do EN^%ut($text(+0),2)
 quit
 ;
 ;
 ; ============== UNIT TESTS ======================
 ; NOTE: Unit tests will pull data using the local
 ;       client VistA files rather than risk degrading
 ;       large datasets in use.  NEVERTHELESS, it is
 ;       recommended that UNIT TESTS be run when
 ;       VA-PALS is not in use as some Graphstore globals
 ;       are temporarily moved while testing is running.
 ;
UTRAPCD ; @TEST - Pulling Radiology Procedures through the broker
 ;  RADPROCD(StationNumber)
 kill ^KBAP("UNIT TEST RA PROCEDURES")
 ;
 new root set root=$$setroot^%wd("radiology procedures")
 ;
 merge ^KBAP("UNIT TEST RA PROCEDURES")=@root
 new KBAPPRCD,utsuccess set utsuccess=0
 set KBAPPRCD=$$RADPROCD^SAMIVSTA(6100)
 if '$get(KBAPPRCD) do  quit
 . merge @root=^KBAP("UNIT TEST RA PROCEDURES")
 . kill ^KBAP("UNIT TEST RA PROCEDURES")
 . do FAIL^%ut("No radiology procedures pulled through broker")
 new ien,ien71G,cptG,nameG,entryV
 for ien=1:1:$get(KBAPPRCD) do  quit:$get(utsuccess)
 . set ien71G=@root@(ien,"ien71")
 . if '$data(^RAMIS(71,ien71G,0)) set utsuccess=1 quit
 . set nameG=@root@(ien,"name")
 . set cptG=@root@(ien,"CPT")
 . set entryV=$get(^RAMIS(71,ien71G,0))
 . if '($piece(entryV,"^")=nameG) set utsuccess=1 quit
 . if '($piece(entryV,"^",9)=cptG) set utsuccess=1 quit
 do CLRGRPS^SAMIVSTA("radiology procedures")
 merge @root=^KBAP("UNIT TEST RA PROCEDURES")
 kill ^KBAP("UNIT TEST RA PROCEDURES")
 do CHKEQ^%ut(utsuccess,0,"Testing pulling rad procedures through broker FAILED!")
 quit
 ;
UTRAEXMS ; @TEST - Pulling Radiology Acive Exams through the broker
 ;  ACTEXAMS
 quit
 ;
UTRASTAF ; @TEST - Pulling all active radiology staff
 ;  RADSTAFF
 kill ^KBAP("UNIT TEST RAD STAFF")
 ;
 new root set root=$$setroot^%wd("radiology staff")
 ;
 merge ^KBAP("UNIT TEST RAD STAFF")=@root
 new KBAPSTAF,utsuccess set utsuccess=0
 set KBAPSTAF=$$RADSTAFF^SAMIVSTA
 if '$get(KBAPSTAF) do  quit
 . merge @root=^KBAP("UNIT TEST RAD STAFF")
 . kill ^KBAP("UNIT TEST RAD STAFF")
 . do FAIL^%ut("No radiology staff found.")
 new ien,duzG,nameG
 for ien=1:1:$get(KBAPSTAF) do  quit:$get(utsuccess)
 . set duzG=@root@(ien,"duz")
 . set nameG=@root@(ien,"name")
 . new cnt set cnt=0,utsuccess=1
 . for  set cnt=$order(^VA(200,duzG,"RAC",cnt)) quit:'cnt  do
 ..  if ^VA(200,duzG,"RAC",cnt,0)="S" set utsuccess=0
 . quit:utsuccess
 . if '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($piece($get(^VA(200,duzG,0)),"^"))) do  quit
 .. set utsuccess=1
 do CLRGRPS^SAMIVSTA("radiology staff")
 merge @root=^KBAP("UNIT TEST RAD STAFF")
 kill ^KBAP("UNIT TEST RAD STAFF")
 do CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology Staff through broker FAILED!")
 quit
 ;
UTRARES ; @TEST - Pulling all active radiology residents
 ;  RADRESDT
 kill ^KBAP("UNIT TEST RAD RESIDENTS")
 ;
 new root set root=$$setroot^%wd("radiology residents")
 ;
 merge ^KBAP("UNIT TEST RAD RESIDENTS")=@root
 new KBAPRES,utsuccess set utsuccess=0
 set KBAPRES=$$RADRESDT^SAMIVSTA
 if '$get(KBAPRES) do  quit
 . merge @root=^KBAP("UNIT TEST RAD RESIDENTS")
 . kill ^KBAP("UNIT TEST RAD RESIDENTS")
 . do FAIL^%ut("No radiology residents found.")
 new ien,duzG,nameG
 for ien=1:1:$get(KBAPRES) do  quit:$get(utsuccess)
 . set duzG=@root@(ien,"duz")
 . set nameG=@root@(ien,"name")
 . new cnt set cnt=0,utsuccess=1
 . for  set cnt=$order(^VA(200,duzG,"RAC",cnt)) quit:'cnt  do
 ..  if ^VA(200,duzG,"RAC",cnt,0)="R" set utsuccess=0
 . quit:utsuccess
 . if '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($piece($get(^VA(200,duzG,0)),"^"))) do  quit
 .. set utsuccess=1
 do CLRGRPS^SAMIVSTA("radiology residents")
 merge @root=^KBAP("UNIT TEST RAD RESIDENTS")
 kill ^KBAP("UNIT TEST RAD RESIDENTS")
 do CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology residents through broker FAILED!")
 quit
 ;
UTRATECH ; @TEST - Pulling all active radiology technologists
 ;  RADTECHS
 kill ^KBAP("UNIT TEST RAD TECHS")
 ;
 new root s root=$$setroot^%wd("radiology technologists")
 ;
 merge ^KBAP("UNIT TEST RAD TECHS")=@root
 new KBAPTECH,utsuccess set utsuccess=0
 set KBAPTECH=$$RADTECHS^SAMIVSTA
 if '$get(KBAPTECH) do  quit
 . merge @root=^KBAP("UNIT TEST RAD TECHS")
 . kill ^KBAP("UNIT TEST RAD TECHS")
 . do FAIL^%ut("No radiology technologists found.")
 new ien,duzG,nameG
 for ien=1:1:$get(KBAPTECH) do  quit:$get(utsuccess)
 . set duzG=@root@(ien,"duz")
 . set nameG=@root@(ien,"name")
 . new cnt set cnt=0,utsuccess=1
 . for  set cnt=$order(^VA(200,duzG,"RAC",cnt)) quit:'cnt  do
 ..  if ^VA(200,duzG,"RAC",cnt,0)="T" set utsuccess=0
 . quit:utsuccess
 . if '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($piece($get(^VA(200,duzG,0)),"^"))) do  quit
 .. set utsuccess=1
 do CLRGRPS^SAMIVSTA("radiology technologists")
 merge @root=^KBAP("UNIT TEST RAD TECHS")
 kill ^KBAP("UNIT TEST RAD TECHS")
 do CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology technologists through broker FAILED!")
 quit
 ;
UTRAMOD ; @TEST - Pulling all radiology diagnosis modifiers
 ;  RADMODS
 kill ^KBAP("UNIT TEST RAD MODS")
 ;
 new root set root=$$setroot^%wd("radiology modifiers")
 ;
 merge ^KBAP("UNIT TEST RAD MODS")=@root
 new KBAPMODS,utsuccess set utsuccess=0
 set KBAPMODS=$$RADMODS^SAMIVSTA
 if '$get(KBAPMODS) do  quit
 . merge @root=^KBAP("UNIT TEST RAD MODS")
 . kill ^KBAP("UNIT TEST RAD MODS")
 . do FAIL^%ut("No radiology diagnosis modifiers found.")
 new ien,ien712G,ien792G,nameG,TypeOfImagingG,ienV,TypeOfImagingV
 for ien=1:1:$get(KBAPMODS) do  quit:$get(utsuccess)
 . set ien712G=@root@(ien,"ien71.2")
 . set nameG=@root@(ien,"name")
 . set ien792G=@root@(ien,"ien79.2")
 . set TypeOfImagingG=@root@(ien,"type of imaging")
 .;  check this entry in 71.2 has an ien79.2 image type
 . new cnt set cnt=0,utsuccess=1
 . for  set cnt=$order(^RAMIS(71.2,ien712G,1,cnt)) quit:'cnt  do
 ..  if $get(^RAMIS(71.2,ien712G,1,cnt,0))=ien792G set utsuccess=0
 . quit:utsuccess
 . if '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($p($g(^RAMIS(71.2,ien712G,0)),"^"))) do  quit
 .. set utsuccess=1
 do CLRGRPS^SAMIVSTA("radiology modifiers")
 merge @root=^KBAP("UNIT TEST RAD MODS")
 kill ^KBAP("UNIT TEST RAD MODS")
 do CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology Dx Modifiers through broker FAILED!")
 quit
 ;
UTRADXCD ; @TEST - Pull all radiology diagnostic codes
 ;  RADDXCDS
 kill ^KBAP("UNIT TEST RA DX CODES")
 ;
 new root set root=$$setroot^%wd("radiology diagnostic codes")
 ;
 merge ^KBAP("UNIT TEST RA DX CODES")=@root
 new KBAPCODS,utsuccess set utsuccess=0
 set KBAPCODS=$$RADDXCDS^SAMIVSTA
 if '$get(KBAPCODS) do  quit
 . merge @root=^KBAP("UNIT TEST RA DX CODES") kill ^KBAP("UNIT TEST RA DX CODES")
 . do FAIL^%ut("No radiology dx codes pulled through broker")
 new ien,ien783G,nameG,nameV
 for ien=1:1:$get(KBAPCODS) do  quit:$get(utsuccess)
 . set ien783G=@root@(ien,"ien78.3")
 . if '$data(^RA(78.3,ien783G,0)) set utsuccess=1 quit
 . set nameG=@root@(ien,"name")
 . set nameV=$piece($get(^RA(78.3,ien783G,0)),"^")
 . if '(nameG=nameV) set utsuccess=1 quit
 do CLRGRPS^SAMIVSTA("radiology diagnostic codes")
 merge @root=^KBAP("UNIT TEST RA DX CODES")
 kill ^KBAP("UNIT TEST RA DX CODES")
 do CHKEQ^%ut(utsuccess,0,"Testing pulling rad dx codes through broker FAILED!")
 quit
 ;
UTCLRG ; @TEST - Clear a Graphstore of entries
 ;
 new root set root=$$setroot^%wd("radiology diagnostic codes")
 ;
 kill ^KBAP("UNIT TEST CLRGRPH") merge ^KBAP("UNIT TEST CLRGRPH")=@root
 new cnt set cnt=$order(@root@("A"),-1)
 if 'cnt do  quit
 . do FAIL^%ut("No 'radiology diagnostic codes' entry")
 set cnt=$$CLRGRPS^SAMIVSTA("radiology diagnostic codes"),cnt=$order(@root@("A"),-1)
 merge @root=^KBAP("UNIT TEST CLRGRPH") kill ^KBAP("UNIT TEST CLRGRPH")
 do CHKEQ^%ut(cnt,0,"Clear Graphstore FAILED!")
 quit
 ;
EOR ; End of routine SAMIUTVR
