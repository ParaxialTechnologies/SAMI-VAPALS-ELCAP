SAMIUTVR ; ven/lgc,arc - UNIT TESTS for SAMIVSTR ; 1/7/19 7:02pm
 ;;1.0;SAMI;;
 ;
 ;@routine-credits
 ;@primary development organization: Vista Expertise Network
 ;@primary-dev: Larry G. Carlson (lgc)
 ;@primary-dev: Alexis R. Carlson (arc)
 ;@copyright:
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-09-26
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
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
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
 k ^KBAP("UNIT TEST RA PROCEDURES")
 ;
 ;n root s root=$$setroot^%wd("radiology procedures")
 n root s root=$$SETROOT^SAMIUTST("radiology procedures")
 ;
 m ^KBAP("UNIT TEST RA PROCEDURES")=@root
 n KBAPPRCD,utsuccess s utsuccess=0
 s KBAPPRCD=$$RADPROCD^SAMIVSTR(6100)
 i '$g(KBAPPRCD) d  q
 . m @root=^KBAP("UNIT TEST RA PROCEDURES")
 . k ^KBAP("UNIT TEST RA PROCEDURES")
 . d FAIL^%ut("No radiology procedures pulled through broker")
 n ien,ien71G,cptG,nameG,entryV
 f ien=1:1:$g(KBAPPRCD) d  q:$g(utsuccess)
 . s ien71G=@root@(ien,"ien71")
 . i '$d(^RAMIS(71,ien71G,0)) s utsuccess=1 q
 . s nameG=@root@(ien,"name")
 . s cptG=@root@(ien,"CPT")
 . s entryV=$g(^RAMIS(71,ien71G,0))
 . i '($p(entryV,"^")=nameG) s utsuccess=1 q
 . i '($p(entryV,"^",9)=cptG) s utsuccess=1 q
 d CLRGRPHS^SAMIVSTR("radiology procedures")
 m @root=^KBAP("UNIT TEST RA PROCEDURES")
 k ^KBAP("UNIT TEST RA PROCEDURES")
 d CHKEQ^%ut(utsuccess,0,"Testing pulling rad procedures through broker FAILED!")
 q
 ;
UTRAEXMS ; @TEST - Pulling Radiology Acive Exams through the broker
 ;  ACTEXAMS
 q
 ;
UTRASTAF ; @TEST - Pulling all active radiology staff
 ;  RADSTAFF
 k ^KBAP("UNIT TEST RAD STAFF")
 ;
 ;n root s root=$$setroot^%wd("radiology staff")
 n root s root=$$SETROOT^SAMIUTST("radiology staff")
 ;
 m ^KBAP("UNIT TEST RAD STAFF")=@root
 n KBAPSTAF,utsuccess s utsuccess=0
 s KBAPSTAF=$$RADSTAFF^SAMIVSTR
 i '$g(KBAPSTAF) d  q
 . m @root=^KBAP("UNIT TEST RAD STAFF")
 . k ^KBAP("UNIT TEST RAD STAFF")
 . d FAIL^%ut("No radiology staff found.")
 n ien,duzG,nameG
 f ien=1:1:$g(KBAPSTAF) d  q:$g(utsuccess)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,utsuccess=1
 . F  S cnt=$O(^VA(200,duzG,"RAC",cnt)) q:'cnt  d
 ..  I ^VA(200,duzG,"RAC",cnt,0)="S" s utsuccess=0
 . q:utsuccess
 . i '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($p($g(^VA(200,duzG,0)),"^"))) d  q
 .. s utsuccess=1
 d CLRGRPHS^SAMIVSTR("radiology staff")
 m @root=^KBAP("UNIT TEST RAD STAFF")
 k ^KBAP("UNIT TEST RAD STAFF")
 d CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology Staff through broker FAILED!")
 q
 ;
UTRARES ; @TEST - Pulling all active radiology residents
 ;  RADRESDT
 k ^KBAP("UNIT TEST RAD RESIDENTS")
 ;
 ;n root s root=$$setroot^%wd("radiology residents")
 n root s root=$$SETROOT^SAMIUTST("radiology residents")
 ;
 m ^KBAP("UNIT TEST RAD RESIDENTS")=@root
 n KBAPRES,utsuccess s utsuccess=0
 s KBAPRES=$$RADRESDT^SAMIVSTR
 i '$g(KBAPRES) d  q
 . m @root=^KBAP("UNIT TEST RAD RESIDENTS")
 . k ^KBAP("UNIT TEST RAD RESIDENTS")
 . d FAIL^%ut("No radiology residents found.")
 n ien,duzG,nameG
 f ien=1:1:$g(KBAPRES) d  q:$g(utsuccess)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,utsuccess=1
 . f  s cnt=$O(^VA(200,duzG,"RAC",cnt)) q:'cnt  d
 ..  I ^VA(200,duzG,"RAC",cnt,0)="R" s utsuccess=0
 . q:utsuccess
 . i '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($p($g(^VA(200,duzG,0)),"^"))) d  q
 .. s utsuccess=1
 d CLRGRPHS^SAMIVSTR("radiology residents")
 m @root=^KBAP("UNIT TEST RAD RESIDENTS")
 k ^KBAP("UNIT TEST RAD RESIDENTS")
 d CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology residents through broker FAILED!")
 q
 ;
UTRATECH ; @TEST - Pulling all active radiology technologists
 ;  RADTECHS
 k ^KBAP("UNIT TEST RAD TECHS")
 ;
 ;n root s root=$$setroot^%wd("radiology technologists")
 n root s root=$$SETROOT^SAMIUTST("radiology technologists")
 ;
 m ^KBAP("UNIT TEST RAD TECHS")=@root
 n KBAPTECH,utsuccess s utsuccess=0
 s KBAPTECH=$$RADTECHS^SAMIVSTR
 i '$g(KBAPTECH) d  q
 . m @root=^KBAP("UNIT TEST RAD TECHS")
 . k ^KBAP("UNIT TEST RAD TECHS")
 . d FAIL^%ut("No radiology technologists found.")
 n ien,duzG,nameG
 f ien=1:1:$g(KBAPTECH) d  q:$g(utsuccess)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,utsuccess=1
 . f  S cnt=$O(^VA(200,duzG,"RAC",cnt)) q:'cnt  d
 ..  i ^VA(200,duzG,"RAC",cnt,0)="T" s utsuccess=0
 . q:utsuccess
 . i '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($p($g(^VA(200,duzG,0)),"^"))) d  q
 .. s utsuccess=1
 d CLRGRPHS^SAMIVSTR("radiology technologists")
 m @root=^KBAP("UNIT TEST RAD TECHS")
 k ^KBAP("UNIT TEST RAD TECHS")
 d CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology technologists through broker FAILED!")
 q
 ;
UTRAMOD ; @TEST - Pulling all radiology diagnosis modifiers
 ;  RADMODS
 k ^KBAP("UNIT TEST RAD MODS")
 ;
 ;n root s root=$$setroot^%wd("radiology modifiers")
 n root s root=$$SETROOT^SAMIUTST("radiology modifiers")
 ;
 m ^KBAP("UNIT TEST RAD MODS")=@root
 n KBAPMODS,utsuccess s utsuccess=0
 S KBAPMODS=$$RADMODS^SAMIVSTR
 i '$g(KBAPMODS) d  q
 . m @root=^KBAP("UNIT TEST RAD MODS")
 . k ^KBAP("UNIT TEST RAD MODS")
 . d FAIL^%ut("No radiology diagnosis modifiers found.")
 n ien,ien712G,ien792G,nameG,TypeOfImagingG,ienV,TypeOfImagingV
 f ien=1:1:$g(KBAPMODS) d  q:$g(utsuccess)
 . s ien712G=@root@(ien,"ien71.2")
 . s nameG=@root@(ien,"name")
 . s ien792G=@root@(ien,"ien79.2")
 . s TypeOfImagingG=@root@(ien,"type of imaging")
 .;  check this entry in 71.2 has an ien79.2 image type
 . n cnt s cnt=0,utsuccess=1
 . f  S cnt=$O(^RAMIS(71.2,ien712G,1,cnt)) q:'cnt  d
 ..  i $g(^RAMIS(71.2,ien712G,1,cnt,0))=ien792G s utsuccess=0
 . q:utsuccess
 . i '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($p($g(^RAMIS(71.2,ien712G,0)),"^"))) d  q
 .. s utsuccess=1
 d CLRGRPHS^SAMIVSTR("radiology modifiers")
 m @root=^KBAP("UNIT TEST RAD MODS")
 k ^KBAP("UNIT TEST RAD MODS")
 d CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology Dx Modifiers through broker FAILED!")
 q
 ;
UTRADXCD ; @TEST - Pull all radiology diagnostic codes
 ;  RADDXCDS
 k ^KBAP("UNIT TEST RA DX CODES")
 ;
 ;n root s root=$$setroot^%wd("radiology diagnostic codes")
 n root s root=$$SETROOT^SAMIUTST("radiology diagnostic codes")
 ;
 m ^KBAP("UNIT TEST RA DX CODES")=@root
 n KBAPCODS,utsuccess s utsuccess=0
 s KBAPCODS=$$RADDXCDS^SAMIVSTR
 i '$g(KBAPCODS) d  q
 . m @root=^KBAP("UNIT TEST RA DX CODES") k ^KBAP("UNIT TEST RA DX CODES")
 . d FAIL^%ut("No radiology dx codes pulled through broker")
 n ien,ien783G,nameG,nameV
 f ien=1:1:$g(KBAPCODS) d  q:$g(utsuccess)
 . s ien783G=@root@(ien,"ien78.3")
 . i '$d(^RA(78.3,ien783G,0)) s utsuccess=1 q
 . s nameG=@root@(ien,"name")
 . s nameV=$p($g(^RA(78.3,ien783G,0)),"^")
 . i '(nameG=nameV) s utsuccess=1 q
 d CLRGRPHS^SAMIVSTR("radiology diagnostic codes")
 m @root=^KBAP("UNIT TEST RA DX CODES")
 k ^KBAP("UNIT TEST RA DX CODES")
 d CHKEQ^%ut(utsuccess,0,"Testing pulling rad dx codes through broker FAILED!")
 q
 ;
UTCLRG ; @TEST - Clear a Graphstore of entries
 ;
 ;n root s root=$$setroot^%wd("radiology diagnostic codes")
 n root s root=$$SETROOT^SAMIUTST("radiology diagnostic codes")
 ;
 k ^KBAP("UNIT TEST CLRGRPH") M ^KBAP("UNIT TEST CLRGRPH")=@root
 n cnt s cnt=$O(@root@("A"),-1)
 i 'cnt d  q
 . d FAIL^%ut("No 'radiology diagnostic codes' entry")
 s cnt=$$CLRGRPHS^SAMIVSTR("radiology diagnostic codes"),cnt=$O(@root@("A"),-1)
 m @root=^KBAP("UNIT TEST CLRGRPH") K ^KBAP("UNIT TEST CLRGRPH")
 d CHKEQ^%ut(cnt,0,"Clear Graphstore FAILED!")
 q
 ;
EOR ; End of routine SAMIUTVR
