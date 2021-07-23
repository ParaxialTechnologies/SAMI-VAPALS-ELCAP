SAMIOUL ;ven/toad - HL7 development log ;2021-06-08t19:27z
 ;;18.0;SAMI;**12**;2020-01;
 ;;1.18.0.12-t3+i12
 ;
 ; SAMIOUL is the development log for the SAMIHL7 & SAMIOR* routines,
 ; which support VAPALS-ELCAP HL7 processing.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, lgc, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-06-08t19:27z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t3+i12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@additional-dev Alexis R. Carlson (arc)
 ; arc@vistaexpertise.net
 ;@additional-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@module-credits
 ;@project VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding 2017/2021, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org Paraxial Technologies (par)
 ; http://paraxialtech.com/
 ;@partner-org Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2019-10-03/28 ven/lgc 1.18.0 d01fd10,ff6cea0,3670fb3,613e8ff
 ; ,82979cc
 ;  SAMIHL7: HL7 routines to populate & update patient-lookup graph,
 ; reorganize HL7 routines & work on unit tests, change how gender is
 ; handled, update unit test routines for dfn 1, further updates to
 ; SAMI unit tests.
 ;
 ; 2020-01-15 ven/lgc 1.18.0 0a2af96
 ;  SAMIHL7: bulk commit due to switch to cache, major overhaul:
 ; update capture of array structure; in UPDTPTL add UPDTPTL1,MATCHLOG
 ; & update indices; r/root w/rootpl; annotate; cut DELPTL & 2 lines,
 ; leaving rest of subroutine orphaned.
 ;
 ; 2020-01-16 ven/lgc 1.18.0 [no repo commit]
 ;  SAMIHL7: in MATCHLOG unbreak line MATCHLOG+13.
 ;
 ; 2020-02-04/12 ven/lgc 1.18.0.11+i11 ee53d8a
 ;  SAMIORM,SAMIORR ORM HL7 routines.
 ;
 ; 2020-07-24/28 ven/lgc 1.18.0.8/11+i8/i11 c08b051
 ;  SAMIHL7,SAMIORM,SAMIORU: update for ORU messaging.
 ;  SAMIHL7: in top update incoming fields array example; passim
 ; checkpoint into ^KBAP; in UPDTPTL1 add block to if new patient get
 ; next ptien to use & set dfn; in MATCHLOG r/MATCHLOG w/HL7MATCHLOG,
 ; if new patient load ORM msg data later, fix undef error, as didn't
 ; get dfn from va vista server (only ssn) do not try to set remotedfn
 ; field, build saminame index, call CAPTORM to save all ORM flds in
 ; patient-lookup; add CAPTORM; in ACK clear & set HLA("HLA").
 ;  SAMIORM: passim annotate, checkpoint into ^KBAP; in BLDAR get
 ; inverse date, put HL7 nodes in samihl7; in DEBUG save msg id; add
 ; PMSG; in PARSEMSG call PV1,ORC; in PID r/dfn w/ssn, get name flds,
 ; get last5; add tag ORMADDR; add PV1,ORC to handle those segments;
 ; in OBR reorg fields array; add CAMELCAS; update TEST.
 ;  SAMIORU: new routine?
 ;
 ; 2020-08-17/09-04 ven/lgc 1.18.0.11+i11 f3d7b38
 ;  SAMIORU: update to remove gtm mod: extensive chgs passim, incl add
 ; TESTALL,TESTOBXC; TESTOBX > TESTOBXV; PID2 > PID1; in DFN pull data
 ; from entry in patient-lookup graph; in HL7VARS if msg id returned,
 ; preface it with 1^; in ORMVARS don't confuse ORM msg id w/ORU msg
 ; id; etc.
 ;
 ; 2021-02-03 ven/gpl 1.18.0.8+i8 54a0c2e
 ;  SAMIORU: in EN chg line length limit (climit) to 81.
 ;
 ; 2021-03-12/13 ven/lgc 1.18.0.8+i8 6093b45
 ;  SAMIORU: larry's latest version of hl7 message building to
 ; preserve note formatting: in TESTALL cut dead code, chg patient &
 ; form, call EN&SAMIORU as function; in EN add debug code, cut climit
 ; lines & cache filter; in DFN add tag FINDORM; in OBX cut climit
 ; lines & dead code & BLDTXT.
 ;
 ; 2021-04-14/20 ven/gpl 1.18.0.11+i11 3a5756a,d7182d7
 ;  SAMIHL7: fix for duplicate patients fr/HL7, fix for updating 
 ; patient-lookup graph on receipt of 2nd order: in UPDTPTL1 uppercase
 ; names; in MATCHLOG prevent undef error.
 ;
 ; 2021-05-11 ven/lgc 1.18.0.11+i11 [no repo commit]
 ;  SAMIORM: in UPDTPTL stop updating hl7 counter node, because it was
 ; updated earlier, just set hl7cnt; in OBR set fields("siteid").
 ;
 ; 2021-05-20/21 ven/mcglk&toad 1.18.0.11+i11 43a4557,70fc6ba,129e96b
 ;  SAMIHL7: passim build hdr comments & dev log, lt refactor, bump
 ; version.
 ;
 ; 2021-05-27 ven/lgc 1.18.0.11+i11 2093bf0,a51e714
 ;  SAMIHL7,SAMIORM: new fixes for saving ORM & HL7 in patient-lookup
 ;  SAMIHL7: in section 1 update sample array; in MATCHLOG
 ; r/fields(field)'="" w/'(field=""); in CAPTORM annotate, r/invdt
 ; algo w/hl7cnt algo to align array structures of SAMIHL7 & SAMIORM,
 ; to use counters for subscripts instead of inverse dates.
 ;  SAMIORM: in BLDARR, new hl7cnt, cut tag DEBUG, move inits of INFS,
 ; INCC up to where DEBUG tag was; in PMSG fix KBaP typo, annotate,
 ; refactor block, get msgid; in PID get suffix.
 ;
 ; 2021-06-01/04 ven/mcglk&toad 1.18.0.11+i11 7dd9410c
 ;  SAMIHL7: update log, add SAMIORM,ORR,ORU to log.
 ;  SAMIORM,ORR,ORU: annotate, document hl7 call structure, refactor,
 ; bump version & dates.
 ;
 ; 2021-06-08 ven/toad 1.18.0.12-t1+i12 91baf32e,ba8c9192
 ;  SAMIORM: in BLDARR fix new cnt, bug introduced in 06-04 refactor,
 ; bump version; in PID uppercase patient name; cut CAMELCAS.
 ;  SAMIOUL < SAMIHL7: create routine from existing dev log.
 ;
 ;
 ;
 ;@contents
 ; SAMIHL7 HL7 utilities
 ; SAMIORM HL7 ORM > patient-lookup
 ; SAMIORR HL7 ORR enrollment response
 ; SAMIORU HL7 ORU enrollment response
 ; SAMIOUL HL7 development log
 ;
 ;
 ;
EOR ; end of routine SAMIOUL
