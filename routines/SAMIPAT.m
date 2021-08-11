SAMIPAT ;ven/toad - init subroutines ;2021-08-11t21:03z
 ;;18.0;SAMI;**12**;2020-01;
 ;;18.12
 ;
 ; Routine SAMIPAT contains VAPALS-ELCAP initialization subroutines
 ; to use as KIDS pre- & post-installs & environment checks.
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
 ;@dev-main Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-org-main Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2021, toad, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-update 2021-08-11t21:03z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2021-07-01 ven/mcglk&toad 18.12-t2 cbf7e46b
 ;  SAMIPAT new routine, new POS1812 post-install for patch 12.
 ;
 ; 2021-07-22/23 ven/toad 18.12
 ;  SAMIPAT add PRE1812 pre-install.
 ;
 ; 2021-08-11 ven/mcglk&toad 18.12
 ;  SAMIPAT rip out PRE1812.
 ;
 ;@contents
 ; POS1812 kids post-install for sami 18.12
 ;
 ;
 ;
 ;@section 1 subroutines for SAMI 18.12
 ;
 ;
 ;
 ;@kids-post POST1812^SAMIPAT
POS1812 ; kids post-install for sami 18.12
 ;
 do ADDSVC^SAMIPARM ; install get params web service
 ;
 ; in honor of Tchaikovsky's overture: boom
 ;
 quit  ; end of kids-post POS1812^SAMIPAT
 ;
 ;
 ;
 ;@section 2 subroutines for future versions...
 ;
 ;
 ;
EOR ; end of routine SAMIPAT
