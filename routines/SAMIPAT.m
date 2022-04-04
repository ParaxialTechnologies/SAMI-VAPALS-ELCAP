SAMIPAT ;ven/toad - init subroutines ;2022-04-04t23:15z
 ;;18.0;SAMI;**12,14,15,17**;2020-01;
 ;;18-17
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
 ;@last-update 2022-04-04t23:15z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18.14
 ;@release-date 2020-01
 ;@patch-list **12,14,15**
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
 ; 2021-10-28 ven/lmry 18-15  0b585061
 ;  SAMIPAT create a STANDARD subroutine with post-install commands that are
 ;  used for almost all patches. Change POS1814 to use that routine and add
 ;  POS1815.
 ;
 ; 2021-10-29 ven/lmry 18-15  6e9594e8
 ;  SAMIPAT remove a space before STANDARD
 ;
 ; 2021-11-14 ven/lmry 18-15  3a30fe59
 ;  SAMIPAT  Add commands for 18-15-t2.
 ;
 ; 2021-11-18 ven/lmry  18-15  4d71eef7
 ;  SAMIPAT  Fix for XINDEX
 ;
 ; 2021-12-07 ven/lmry 18-15   75a19c5c
 ;  SAMIPAT  Update for final 18-15 patch
 ;
 ; 2022-04-04 ven/lmry 18-17
 ;  SAMIPAT  Update for 18-17-t1 patch
 ;
 ;
 ;@contents
 ; STANDARD usual post-install commands
 ; POS1812 kids post-install for sami 18.12
 ; POS1814 kids post-install for sami 18.14
 ; POS1815 kids post-install for sami 18.15
 ; POS1817 kids post-install for sami 18.17
 ;
 ;
 ;
 ;@section 1 subroutine for most patches
 ;
STANDARD ; usual post-install commands
 set SAMIDIR="/home/osehra/lib/silver/a-sami-vapals-elcap--vo-osehra-github/docs/form-fields/"
 ;do PRSTSV^SAMIFF(SAMIDIR,"background.tsv","form fields - background")
 ;do PRSTSV^SAMIFF(SAMIDIR,"biopsy.tsv","form fields - biopsy")
 ;do PRSTSV^SAMIFF(SAMIDIR,"ct-evaluation.tsv","form fields - ct evaluation")
 ;do PRSTSV^SAMIFF(SAMIDIR,"follow-up.tsv","form fields - follow up")
 ;do PRSTSV^SAMIFF(SAMIDIR,"intake.tsv","form fields - intake")
 ;do PRSTSV^SAMIFF(SAMIDIR,"intervention.tsv","form fields - intervention")
 ;do PRSTSV^SAMIFF(SAMIDIR,"pet-evaluation.tsv","form fields - pet evaluation")
 ;do PRSTSV^SAMIFF(SAMIDIR,"register.tsv","form fields - register")
 do DODD^SAMIADMN(SAMIDIR) ; to import tsv files to generate DD graphs
 do CLRWEB^SAMIADMN ; Clear the M Web Server files cache
 do INIT2GPH^SAMICTD2 ; initialize CTEVAL dictionary into graph cteval-dict
 ;
 ;
 ;
 ;@section 2 subroutines for SAMI 18.12
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
 ;@section 3 subroutines for SAMI 18.14
 ;
 ;@kids-post POST1814^SAMIPAT
POS1814 ; kids post-install for sami 18.14
 ;
 do STANDARD
 ;
 quit  ; end of kids-post POS1814^SAMIPAT
 ;
 ;
 ;
 ;@section 4 subroutines for SAMI 18.15
 ;
 ;@kids-post POST1815^SAMIPAT
POS1815 ; kids post-install for sami 18.15
 ;
 do STANDARD
 do SETPARM^SAMIPARM("SYS","samiSystemVersion","sami-18-15")
 do deleteService^%webutils("GET","vapals")
 do addService^%webutils("GET","vapals","GETHOME^SAMIHOM3")
 do SETMAP^SAMIPARM("vapals:about","about.html")
 ;
 quit  ; end of kids-post POS1815^SAMIPAT
 ;
 ;
 ;@section 5 subroutines for SAMI 18.17
 ;
 ;@kids-post POST1817^SAMIPAT
POS1817 ; kids post-install for sami 18.17
 ;
 do STANDARD
 do SETPARM^SAMIPARM("SYS","samiSystemVersion","sami-18-17-t1")
 ;
 quit  ; end of kids-post POS1817^SAMIPAT
 ;
 ;
 ;@section X subroutines for future versions...
 ;
 ;
 ;
EOR ; end of routine SAMIPAT
