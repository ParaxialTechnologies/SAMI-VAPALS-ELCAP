SAMIPAT ;ven/toad - init subroutines ;2021-09-08t23:19z
 ;;18.0;SAMI;**14**;2020-01;
 ;;18.14
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
 ;@last-update 2021-09-08t23:19z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.14
 ;@release-date 2020-01
 ;@patch-list **14**
 ;
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2021-07-01 ven/mcglk&toad 18.12-t2 cbf7e46b
 ;  SAMIPAT new routine, new POS1812 post-install for patch 12.
 ;
 ; 2021-07-22/23 ven/toad 18.12  
 ;  SAMIPAT add PRE1812 pre-install.
 ;
 ; 2021-08-11 ven/mcglk&toad 18.12  b16cd38f
 ;  SAMIPAT rip out PRE1812.
 ;
 ; 2021-09-08 ven/lmry 18.14  2af1f2e7
 ;  SAMIPAT add post-install for patch SAMI*1.18*14
 ;
 ;@contents
 ; POS1812 kids post-install for sami 18.12
 ; POS1814 kids post-install for sami 18.14
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
 ;@section 2 subroutines for SAMI 18.14
 ;
 ;
 ;
 ;@kids-post POST1814^SAMIPAT
POS1814 ; kids post-install for sami 18.14
 ;
 do DDDD^SAMIADMN ; to import tsv files to generate DD graphs
 do CLRWEB^SAMIADMN ; Clear the M Web Server files cache
 do INIT2GPH^SAMICTD2 ; initialize CTEVAL dictionary into graph cteval-dict
 ;
 quit  ; end of kids-post POS1814^SAMIPAT
 ;
 ;
 ;
 ;@section 3 subroutines for future versions...
 ;
 ;
 ;
EOR ; end of routine SAMIPAT
