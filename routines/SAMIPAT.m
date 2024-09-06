SAMIPAT ;ven/toad - post subroutines; 2024-08-30t03:30z
 ;;18.0;SAMI;**12,14,15,17**;2020-01-17;Build 8
 ;mdc-e1;SAMIPAT-20240822-E2tdr5N;SAMI-18-17-b8
 ;mdc-v7;B17344032;SAMI*18.0*17 SEQ #17
 ;
 ; Routine SAMIPAT contains ScreeningPlus initialization subroutines
 ; to use as KIDS pre- & post-installs & environment checks.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;
 ;@routine-credits
 ;
 ;@dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@dev-org Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2024, toad, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@update 2024-08-30t03:30z
 ;@app-suite Screening Applications Management - SAM
 ;@app ScreeningPlus (SAM-IELCAP) - SAMI
 ;@module Inits (patching) - SAMIPA
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@release 18-17
 ;@edition-date 2020-01-17
 ;@patches **12,14,15,17**
 ;
 ;@dev-add George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-add Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@dev-add Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
 ;
 ;@module-credits
 ;
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
 ;@project I-ELCAP AIRS Automated Image Reading System
 ; https://www.ielcap-airs.org
 ;@funding 2024, Mt. Sinai Hospital (msh)
 ;@partner-org par
 ;
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ;
 ; 2021-07-01 ven/mcglk&toad 18-12-t2 cbf7e46b
 ;  SAMIPAT new routine, new POS1812.
 ;
 ; 2021-07-22/23 ven/toad 18-12 
 ;  SAMIPAT add PRE1812 pre-install.
 ;
 ; 2021-08-11 ven/mcglk&toad 18-12  b16cd38f
 ;  SAMIPAT rip out PRE1812.
 ;
 ; 2021-09-08 ven/lmry 18-14 2af1f2e7
 ;  SAMIPAT update.
 ;
 ; 2021-10-28 ven/lmry 18-15 0b585061
 ;  SAMIPAT create STANDARD sub w/post-install commands used for
 ; almost all patches; chg POS1814 to use STANDARD, add POS1815.
 ;
 ; 2021-10-29 ven/lmry 18-15 6e9594e8
 ;  SAMIPAT remove space before STANDARD.
 ;
 ; 2021-11-14 ven/lmry 18-15-t2 3a30fe59
 ;  SAMIPAT update.
 ;
 ; 2021-11-18 ven/lmry 18-15 4d71eef7
 ;  SAMIPAT fix for XINDEX.
 ;
 ; 2021-12-07 ven/lmry 18-15 75a19c5c
 ;  SAMIPAT update.
 ;
 ; 2022-04-04 ven/lmry 18-17-t1 258bc926
 ;  SAMIPAT add POS1817.
 ;
 ; 2022-04-27 ven/lmry 18-17-t2 03b87fe
 ;  SAMIPAT update.
 ;
 ; 2022-12-13 ven/lmry 18-17-t3 1ebd6e6
 ;  SAMIPAT update.
 ;
 ; 2022-12-28 ven/lmry 18-17-t4 956e2716
 ;  SAMIPAT update.
 ;
 ; 2024-08-12 ven/lmry 18-17-b5 eea98cd
 ;  SAMIPAT add POS1818.
 ;
 ; 2024-08-16 ven/lmry 18-17-b6  a1a28de  d0224d9
 ;  SAMIPAT update POS1817.
 ;
 ; 2024-08-22 ven/toad 18-17-b6
 ;  SAMIPAT update history, version-control lines, hdr comments.
 ;
 ; 2024-08-30 ven/lmry 18-17-b6
 ;  SAMIPAT updated path for SAMIDIR under STANDARD, change update date,
 ;   also changed routine description to post routines instead of init
 ;   routines.
 ;  
 ;
 ;@contents
 ;
 ; STANDARD usual post-install commands
 ; POS1812 kids post-install for SAMI-18-12
 ; POS1814 kids post-install for SAMI-18-14
 ; POS1815 kids post-install for SAMI-18-15
 ; POS1817 kids post-install for SAMI-18-17
 ; POS1818 kids post-install for SAMI-18-18
 ;
 ;
 ;
 ;
 ;@section 1 subroutine for most patches
 ;
 ;
 ;
 ;
STANDARD ; usual post-install commands
 ;
 set SAMIDIR="/home/osehra/lib/silver/a-sami-vapals-elcap--vv-paraxtech-github/docs/form-fields/"
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
 ;
 ;@section 2 subroutines for SAMI-18-12
 ;
 ;
 ;
 ;
 ;@kids-post POST1812^SAMIPAT
 ;
POS1812 ; kids post-install for SAMI-18-12
 ;
 do ADDSVC^SAMIPARM ; install get params web service
 ;
 ; in honor of Tchaikovsky's overture: boom
 ;
 quit  ; end of kids-post POS1812^SAMIPAT
 ;
 ;
 ;
 ;
 ;@section 3 subroutines for SAMI-18-14
 ;
 ;
 ;
 ;
 ;@kids-post POST1814^SAMIPAT
 ;
POS1814 ; kids post-install for SAMI-18-14
 ;
 do STANDARD
 ;
 quit  ; end of kids-post POS1814^SAMIPAT
 ;
 ;
 ;
 ;
 ;@section 4 subroutines for SAMI-18-15
 ;
 ;
 ;
 ;
 ;@kids-post POST1815^SAMIPAT
 ;
POS1815 ; kids post-install for SAMI-18-15
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
 ;
 ;
 ;@section 5 subroutines for SAMI-18-17
 ;
 ;
 ;
 ;
 ;@kids-post POST1817^SAMIPAT
 ;
POS1817 ; kids post-install for SAMI-18-17
 ;
 do STANDARD
 do SETPARM^SAMIPARM("SYS","samiSystemVersion","sami-18-17-b6")
 ;
 quit  ; end of kids-post POS1817^SAMIPAT
 ;
 ;
 ;
 ;
 ;@section 6 subroutines for SAMI-18-18
 ;
 ;
 ;
 ;
 ;@kids-post POST1818^SAMIPAT
 ;
POS1818 ; kids post-install for SAMI-18-18
 ;
 do STANDARD
 do SETPARM^SAMIPARM("SYS","samiSystemVersion","sami-18-18-b1")
 ;
 quit  ; end of kids-post POS1818^SAMIPAT
 ;
 ;
 ;
 ;
 ;@section X subroutines for future versions...
 ;
 ;
 ;
EOR ; end of routine SAMIPAT
