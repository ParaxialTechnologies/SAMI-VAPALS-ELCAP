SAMICAS4 ;ven/gpl - case review cont ;2021-10-26t19:39z
 ;;18.0;SAMI;**3,9,11,12,15**;2020-01;Build 11
 ;;18-15
 ;
 ; SAMICAS4 contains ppis and other subroutines to support processing
 ; of the VAPALS-IELCAP case review page.
 ;
 quit  ; no entry from top
 ;
CLINSUM(sid) ; extrinsic returns a one line clinical summary
 ;
 ; The clinical information will include the information as follows:
 ; Age xx; [Asymptomatic for lung cancer]; Current Smoker; xx Pack Years
 ; Age xx; [Asymptomatic for lung cancer]; Former Smoker; xx Pack Years; Quit xx years ago
 ; If there is no background form - we should include a place-holder so the radiologist will know the information needs to be added
 ; If a followup form exists, the latest one is used instead of the background
 ;
 new clinstr ; the one line result
 set clinstr="[CHECK BACKGROUND - AGE/SMOKING HISTORY]" ; default if we fail
 ;
 Q clinstr
 ;
 
