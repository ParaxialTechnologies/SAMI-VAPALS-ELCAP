SAMISS ;ven/gpl - VAPALS PATIENT IMPORT MAIN ROUTINE ; 2021-09-27t20:30z
 ;;18.0;SAMI;**16**;2020-01;Build 2
 ;18-x-16-t2
 ;
 ;@license: see routine SAMIUL
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@dev-main George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-org-main Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright 2017/2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-update 2021-09-27t20:30z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 18-14-16
 ;@release-date 2020-01
 ;@patch-list **16**
 ;
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
 ; 2021-09-20/23 ven/gpl sami-18-14-16-t1
 ; SAMIZPH1 develop method to import data from a REDCap data system used by
 ; the Philadelphia VA.
 ;
 ; 2021-09-27 ven/gpl sami-18-14-16-t1
 ; SAMIZPH1 fix bug where Cache was putting the TSV records in overflow
 ;
 ;
 Q
 ;
SSCONV(PARY,HACK,SS) ; converts the SS array, passed by name, to a 
 ; loadable array for the import form
 ;old RCAPHACK(PARY,HACK) ; initialize the redcap mapping table
 ;chart-eligibility-complete true
 ; this hack version accepts a redcap data array in HACK, passed by name
 ; and hard codes the results of the mapping rules in that same array
 ; for use while we are trying to get the mapper to work.
 ;
 S @PARY@("chart-eligibility-complete")="true"
 S @HACK@("chart-eligibility-complete")="true"
 S @SS@("chart-eligibility-complete")="true"
 ;dfn 9000098
 ;dob 1952-1-12
 S @PARY@("dob","dob")=""
 ;form siform-2021-09-21
 ;gender M^MALE
 S @PARY@("gender","gender")="$S(gender=2:""F^FEMALE"",1:""M^MALE"")"
 I $g(@HACK@("gender"))=2 s @HACK@("gender")="F"
 e  s @HACK@("gender")="M"
 ;last5 G0027
 S @PARY@("last5","ssn")="$$CALC5"
 S @HACK@("last5")=$$CALC5(HACK)
 ;notes 
 ;samicreatedate 2021-09-21
 S @PARY@("samicreatedate","sdm_visit_date")=""
 N formdate
 s formdate=$g(@HACK@("sdm_visit_date"))
 i formdate='"" s @HACK@("samicreatedate")=formdate
 ;samifirsttime false
 S @PARY@("samifirsttime")="false"
 S @HACK@("samifirsttime")="false"
 ;saminame GPL34567,TEST76543
 S @PARY@("saminame","last_name")="$$CALCNAME"
 S @HACK@("saminame")=$$CALCNAME(HACK)
 S @HACK@("name")=@HACK@("saminame")
 ;saminum 9000098
 ;samiroute postform
 ;samistatus complete
 ;samistudyid XXX9000098
 ;sbdob 1/12/1952
 S @PARY@("sbdob","dob")=""
 S @HACK@("sbdob")=@HACK@("dob")
 ;sex M
 S @HACK@("sex")=$g(@HACK@("gender"))
 ;I $g(@HACK@("gender"))=2 s @HACK@("sex")="F"
 ;e  s @HACK@("sex")="M"
 S @PARY@("sex","gender")="$S(gender=2:""F"",1:""M"")"
 ;sicadx 
 ;sicadxl 
 ;siceceho 
 ;sicecenc 
 ;siceceoo 
 ;siceceot 
 ;sicecepc 
 ;sicecepr 
 ;sicechrt y
 S @PARY@("sicechrt")="y"
 S @HACK@("sicechrt")="y"
 ;sicectap 08/27/2018
 S @PARY@("sicectap","base_order_date")=""
 S @HACK@("sicectap")=$g(@HACK@("base_order_date"))
 ;siceiden outreach
 S @PARY@("siceiden")="primary/self"
 S @HACK@("siceiden")="primary/self"
 ;sicemhhs 
 ;sicemhlc 
 ;sicemhoo 
 ;sicemhot 
 ;sicep declined smoking cessation
 S @PARY@("sicep","smoking_cessation_not")=""
 S @HACK@("sicep")=$G(@HACK@("smoking_cessation_not"))
 ;sicerfdt
 S @PARY@("sicerfdt","consult")=""
 S @HACK@("sicerfdt")=$G(@HACK@("consult"))
 ;sicerfge 
 ;sicerfon 
 ;sicerfoo 
 ;sicerfot 
 ;sicerfpc 
 ;sicerfpu 
 ;sicerfsc 
 ;sicerfwh 
 ;siceshnc 
 ;siceshoo 
 ;siceshot 
 ;siceshpy 
 ;siceshqd 
 ;siclin 2s-pcp notified
 S @PARY@("siclin","patient_notes")=""
 S @HACK@("siclin")=$g(@HACK@("patient_notes"))
 ;sicpd 40
 S @PARY@("sicpd","smoking_per_day")=""
 S @HACK@("sicpd")=$g(@HACK@("smoking_per_day"))
 ;sidc 09/21/2021
 S @PARY@("sidc","sdm_visit_date")=""
 s formdate=$g(@HACK@("sdm_visit_date"))
 i formdate'="" s @HACK@("sidc")=formdate
 ;sidob 1/12/1952
 S @PARY@("sidob","dob")=""
 s @HACK@("sidob")=$g(@HACK@("dob"))
 ;sies 
 ;siesm p
 S @PARY@("siesm","smoking_history")="$$HISTORY"
 n history s history=$g(@HACK@("smoking_history"))
 S @HACK@("siesm")=$s(history=2:"p",history=3:"n",1:"c")
 ;siesq 
 ;siidmdc 1
 S @PARY@("siidmdc")=1
 S @HACK@("siidmdc")=1
 ;sildct y
 S @PARY@("sildct")="y"
 S @HACK@("sildct")="y"
 ;silnip 
 ;silnml 
 ;silnot 
 ;silnph 1
 S @PARY@("silnph")=1
 S @HACK@("silnph")=1
 ;silnpp 
 ;silnth 
 ;silnvd 
 ;sinamef TEST76543
 S @PARY@("sinamef","first_name")=""
 S @HACK@("sinamef")=$G(@HACK@("first_name"))
 ;sinamel GPL34567
 S @PARY@("sinamel","last_name")=""
 S @HACK@("sinamel")=$G(@HACK@("last_name"))
 ;sipan 
 ;sipav n
 S @PARY@("sipav")="n"
 S @HACK@("sipav")="n"
 ;sipc 
 ;sipcn 
 ;sipcr USA
 S @PARY@("sipcr")="USA"
 S @HACK@("sipcr")="USA"
 ;sipcrn 
 ;sipecmnt 
 ;sipecnip 
 ;sipecnml 
 ;sipecnot 
 ;sipecnpp 
 ;sipecnte 
 ;sipecnth 
 ;sipecnvd 
 ;sipedc 09/21/2021
 S @PARY@("sipedc","sdm_visit_date")=""
 i formdate'="" s @HACK@("sipedc")=formdate
 ;sipedisc n
 S @PARY@("sipedisc")="n"
 S @HACK@("sipedisc")="n"
 ;sippd 2.00
 ;sippn 
 ;sippy 118.00
 ;sips 
 ;sipsa 
 ;siptct 
 ;siptctl 
 ;sipz 
 ;siq 01/01/2018
 S @PARY@("siq","year_quit")=""
 S @HACK@("siq")=$g(@HACK@("year_quit"))
 ;sirs r
 S @PARY@("sirs","rural")="$$RURAL"
 n rural s rural=$g(@HACK@("rural"))
 S @HACK@("sirs")=$s(rural=1:"r",rural=0:"u",1:"n")
 ;sisid XXX9000098
 ;sisny 59.0
 S @PARY@("sisny","smoked_years")=""
 S @HACK@("sisny")=$G(@HACK@("smoked_years"))
 ;sissn 999-99-0027
 S @PARY@("sissn","ssn")="$$CALCSSN"
 S @HACK@("sissn")=$$CALCSSN(HACK)
 ;sistatus active
 n noshow s noshow=$g(@HACK@("ldct_no_show_base"))
 S @PARY@("sistatus")="active"
 S @HACK@("sistatus")=$S(noshow'="":"inactive",1:"active")
 ;site XXX
 ;siteid XXX
 ;ssn 999990027
 S @PARY@("ssn","ssn")="$$CALCSSN"
 S @HACK@("ssn")=$$CALCSSN(HACK)
 ;studyid XXX9000098
 Q
 ;
