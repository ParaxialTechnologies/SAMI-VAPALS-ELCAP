SAMIPAT ;ven/gpl - init subroutines ;2021-07-01T21:13Z
 ;;18.0;SAMI;**12**;2020-01;
 ;;1.18.0.12-t2+i12
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
 ;@primary-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2021, toad, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-07-01T21:13Z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t2+i12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@additional-dev Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@additional-dev George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2021-07-01 ven/mcglk&toad 1.18.0.12-t2+i12
 ;  SAMIPAT new routine, new POS1812 post-install for patch 12.
 ;
 ;@contents
 ; POS1812 kids post-install for sami 1.18.0.12-t2+i12
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
POS1812 ; kids post-install for sami 1.18.0.12-t2+i12
 ;
 do ADDSVC^SAMIPARM ; install get params web service
 ;
 ; in honor of Tchaikovsky's overture: boom
 ;
 quit  ; end of POS1812
 ;
 ;
 ;
EOR ; end of routine SAMIPAT
