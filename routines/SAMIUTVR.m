SAMIUTVR ; ven/lgc,arc - UNIT TESTS for SAMIVSTR ; 12/18/18 4:15pm
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
 K ^KBAP("UNIT TEST RA PROCEDURES")
 n root s root=$$setroot^%wd("radiology procedures")
 m ^KBAP("UNIT TEST RA PROCEDURES")=@root
 N KBAPPRCD,utsuccess S utsuccess=0
 S KBAPPRCD=$$RADPROCD^SAMIVSTR(6100)
 I '$G(KBAPPRCD) D  Q
 . M @root=^KBAP("UNIT TEST RA PROCEDURES")
 . K ^KBAP("UNIT TEST RA PROCEDURES")
 . D FAIL^%ut("No radiology procedures pulled through broker")
 n ien,ien71G,cptG,nameG,entryV
 f ien=1:1:$G(KBAPPRCD) D  Q:$G(utsuccess)
 . s ien71G=@root@(ien,"ien71")
 . I '$D(^RAMIS(71,ien71G,0)) S utsuccess=1 Q
 . s nameG=@root@(ien,"name")
 . s cptG=@root@(ien,"CPT")
 . s entryV=$G(^RAMIS(71,ien71G,0))
 . I '($P(entryV,"^")=nameG) S utsuccess=1 Q
 . I '($P(entryV,"^",9)=cptG) S utsuccess=1 Q
 D CLRGRPHS^SAMIVSTR("radiology procedures")
 m @root=^KBAP("UNIT TEST RA PROCEDURES")
 K ^KBAP("UNIT TEST RA PROCEDURES")
 D CHKEQ^%ut(utsuccess,0,"Testing pulling rad procedures through broker FAILED!")
 Q
 ;
UTRAEXMS ; @TEST - Pulling Radiology Acive Exams through the broker
 ;  ACTEXAMS
 Q
UTRASTAF ; @TEST - Pulling all active radiology staff
 ;  RADSTAFF
 K ^KBAP("UNIT TEST RAD STAFF")
 n root s root=$$setroot^%wd("radiology staff")
 m ^KBAP("UNIT TEST RAD STAFF")=@root
 N KBAPSTAF,utsuccess S utsuccess=0
 S KBAPSTAF=$$RADSTAFF^SAMIVSTR
 I '$G(KBAPSTAF) D  Q
 . M @root=^KBAP("UNIT TEST RAD STAFF")
 . K ^KBAP("UNIT TEST RAD STAFF")
 . D FAIL^%ut("No radiology staff found.")
 n ien,duzG,nameG
 f ien=1:1:$G(KBAPSTAF) D  Q:$G(utsuccess)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,utsuccess=1
 . F  S cnt=$O(^VA(200,duzG,"RAC",cnt)) Q:'cnt  D
 ..  I ^VA(200,duzG,"RAC",cnt,0)="S" S utsuccess=0
 . Q:utsuccess
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^VA(200,duzG,0)),"^"))) D  Q
 .. S utsuccess=1
 D CLRGRPHS^SAMIVSTR("radiology staff")
 m @root=^KBAP("UNIT TEST RAD STAFF")
 K ^KBAP("UNIT TEST RAD STAFF")
 D CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology Staff through broker FAILED!")
 Q
 ;
UTRARES ; @TEST - Pulling all active radiology residents
 ;  RADRESDT
 K ^KBAP("UNIT TEST RAD RESIDENTS")
 n root s root=$$setroot^%wd("radiology residents")
 m ^KBAP("UNIT TEST RAD RESIDENTS")=@root
 N KBAPRES,utsuccess S utsuccess=0
 S KBAPRES=$$RADRESDT^SAMIVSTR
 I '$G(KBAPRES) D  Q
 . M @root=^KBAP("UNIT TEST RAD RESIDENTS")
 . K ^KBAP("UNIT TEST RAD RESIDENTS")
 . D FAIL^%ut("No radiology residents found.")
 n ien,duzG,nameG
 f ien=1:1:$G(KBAPRES) D  Q:$G(utsuccess)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,utsuccess=1
 . F  S cnt=$O(^VA(200,duzG,"RAC",cnt)) Q:'cnt  D
 ..  I ^VA(200,duzG,"RAC",cnt,0)="R" S utsuccess=0
 . Q:utsuccess
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^VA(200,duzG,0)),"^"))) D  Q
 .. S utsuccess=1
 D CLRGRPHS^SAMIVSTR("radiology residents")
 m @root=^KBAP("UNIT TEST RAD RESIDENTS")
 K ^KBAP("UNIT TEST RAD RESIDENTS")
 D CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology residents through broker FAILED!")
 Q
 ;
UTRATECH ; @TEST - Pulling all active radiology technologists
 ;  RADTECHS
 K ^KBAP("UNIT TEST RAD TECHS")
 n root s root=$$setroot^%wd("radiology technologists")
 m ^KBAP("UNIT TEST RAD TECHS")=@root
 N KBAPTECH,utsuccess S utsuccess=0
 S KBAPTECH=$$RADTECHS^SAMIVSTR
 I '$G(KBAPTECH) D  Q
 . M @root=^KBAP("UNIT TEST RAD TECHS")
 . K ^KBAP("UNIT TEST RAD TECHS")
 . D FAIL^%ut("No radiology technologists found.")
 n ien,duzG,nameG
 f ien=1:1:$G(KBAPTECH) D  Q:$G(utsuccess)
 . s duzG=@root@(ien,"duz")
 . s nameG=@root@(ien,"name")
 . n cnt s cnt=0,utsuccess=1
 . F  S cnt=$O(^VA(200,duzG,"RAC",cnt)) Q:'cnt  D
 ..  I ^VA(200,duzG,"RAC",cnt,0)="T" S utsuccess=0
 . Q:utsuccess
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^VA(200,duzG,0)),"^"))) D  Q
 .. S utsuccess=1
 D CLRGRPHS^SAMIVSTR("radiology technologists")
 m @root=^KBAP("UNIT TEST RAD TECHS")
 K ^KBAP("UNIT TEST RAD TECHS")
 D CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology technologists through broker FAILED!")
 Q
 ;
UTRAMOD ; @TEST - Pulling all radiology diagnosis modifiers
 ;  RADMODS
 K ^KBAP("UNIT TEST RAD MODS")
 n root s root=$$setroot^%wd("radiology modifiers")
 m ^KBAP("UNIT TEST RAD MODS")=@root
 N KBAPMODS,utsuccess S utsuccess=0
 S KBAPMODS=$$RADMODS^SAMIVSTR
 I '$G(KBAPMODS) D  Q
 . M @root=^KBAP("UNIT TEST RAD MODS")
 . K ^KBAP("UNIT TEST RAD MODS")
 . D FAIL^%ut("No radiology diagnosis modifiers found.")
 n ien,ien712G,ien792G,nameG,TypeOfImagingG,ienV,TypeOfImagingV
 f ien=1:1:$G(KBAPMODS) D  Q:$G(utsuccess)
 . s ien712G=@root@(ien,"ien71.2")
 . s nameG=@root@(ien,"name")
 . s ien792G=@root@(ien,"ien79.2")
 . s TypeOfImagingG=@root@(ien,"type of imaging")
 .;  check this entry in 71.2 has an ien79.2 image type
 . n cnt s cnt=0,utsuccess=1
 . F  S cnt=$O(^RAMIS(71.2,ien712G,1,cnt)) Q:'cnt  D
 ..  I $G(^RAMIS(71.2,ien712G,1,cnt,0))=ien792G S utsuccess=0
 . Q:utsuccess
 . I '($$UP^XLFSTR(nameG))=($$UP^XLFSTR($P($G(^RAMIS(71.2,ien712G,0)),"^"))) D  Q
 .. S utsuccess=1
 D CLRGRPHS^SAMIVSTR("radiology modifiers")
 m @root=^KBAP("UNIT TEST RAD MODS")
 K ^KBAP("UNIT TEST RAD MODS")
 D CHKEQ^%ut(utsuccess,0,"Testing pulling Radiology Dx Modifiers through broker FAILED!")
 Q
 ;
UTRADXCD ; @TEST - Pull all radiology diagnostic codes
 ;  RADDXCDS
 K ^KBAP("UNIT TEST RA DX CODES")
 n root s root=$$setroot^%wd("radiology diagnostic codes")
 m ^KBAP("UNIT TEST RA DX CODES")=@root
 N KBAPCODS,utsuccess S utsuccess=0
 S KBAPCODS=$$RADDXCDS^SAMIVSTR
 I '$G(KBAPCODS) D  Q
 . M @root=^KBAP("UNIT TEST RA DX CODES") K ^KBAP("UNIT TEST RA DX CODES")
 . D FAIL^%ut("No radiology dx codes pulled through broker")
 n ien,ien783G,nameG,nameV
 f ien=1:1:$G(KBAPCODS) D  Q:$G(utsuccess)
 . s ien783G=@root@(ien,"ien78.3")
 . I '$D(^RA(78.3,ien783G,0)) S utsuccess=1 Q
 . s nameG=@root@(ien,"name")
 . s nameV=$P($G(^RA(78.3,ien783G,0)),"^")
 . I '(nameG=nameV) S utsuccess=1 Q
 D CLRGRPHS^SAMIVSTR("radiology diagnostic codes")
 m @root=^KBAP("UNIT TEST RA DX CODES")
 K ^KBAP("UNIT TEST RA DX CODES")
 D CHKEQ^%ut(utsuccess,0,"Testing pulling rad dx codes through broker FAILED!")
 Q
 ;
UTCLRG ; @TEST - Clear a Graphstore of entries
 n root s root=$$setroot^%wd("radiology diagnostic codes")
 K ^KBAP("UNIT TEST CLRGRPH") M ^KBAP("UNIT TEST CLRGRPH")=@root
 n cnt s cnt=$O(@root@("A"),-1)
 I 'cnt D  Q
 . D FAIL^%ut("No 'radiology diagnostic codes' entry")
 s cnt=$$CLRGRPHS^SAMIVSTR("radiology diagnostic codes"),cnt=$O(@root@("A"),-1)
 M @root=^KBAP("UNIT TEST CLRGRPH") K ^KBAP("UNIT TEST CLRGRPH")
 D CHKEQ^%ut(cnt,0,"Clear Graphstore FAILED!")
 Q
 ;
EOR ; End of routine SAMIUTVR
