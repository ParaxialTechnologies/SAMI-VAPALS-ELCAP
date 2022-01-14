SAMISS ;ven/mcglk - VAPALS 'intake.xls' importer ; 2022-01-11t18:23z
 ;;18.0;SAMI;**16**;2020-01;Build 2
 ;18-x-16
 ;
 ;@license: see routine SAMIUL
 ;
 ;@section 0 primary development
 ;
 ;
 ;@routine-credits
 ;@dev-main George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@dev-add Ken McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
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
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.
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
 quit
 ;
YMDTOMDY(YMD) ; Convert "YYYY-MM-DD" to "MM/DD/YYYY"
 ; If YMD doesn't match the format, returns the string unchanged.
 new MDY set MDY=YMD
 if YMD?4N1"-"2N1"-"2N do
 . new YR set YR=$piece(YMD,"-")
 . new MO set MO=$piece(YMD,"-",2)
 . new DY set DY=$piece(YMD,"-",3)
 . set MDY=MO_"/"_DY_"/"_YR
 . quit
 ;
 quit MDY ; End of $$YMDTOMDY
 ;
 ;
FLDNUM(DROOT,FLDNAM) ; Returns the field number (IEN?) for a given field name.
 new FLDNUM set FLDNUM=""
 quit $order(@DROOT@("field","B",FLDNAM,""))
 ;
 ;
SSCONV(SS) ; converts the SS array, passed by name, to a
 merge ^KBBSSS=@SS
 ; loadable array for the import form
 ; NOTES
 ; SSCONV is being used in three places.
 ; (a) try to put formulas to be executed later to give values: PARY (unfinished)
 ; (b) a shortcut containing the actual precomputed data: HACK (operational)
 ; (c) HACK was also used for RedCap.
 ; SS contains raw data from the spreadsheet, with the intent on
 ; replacing those values with what should be there. HACK is to be
 ; ignored, and PARY is non-operational.
 ; *Data dictionaries*
 ; new DROOT
 ; set DROOT=$$setroot^%wd("form fields - intake")
 ; -> $$FLDNUM(DROOT,"siceiden") -> IEN
 ; input fields
 ; saminame	LAST,FIRST MIDDLE SUFFIX
 ; ssn	000-00-0000
 ; sigi	Select
 ; sex	Select
 ; sbdob	yyyy-mm-dd
 ; siceiden	Select
 ; sicerfdt	yyyy-mm-dd
 ; sicerfpc	Select
 ; sicerfwh	Select
 ; sicerfge	Select
 ; sicerfpu	Select
 ; sicerfon	Select
 ; sicerfsc	Select
 ; sicerfot	Select
 ; sicerfoo	Describe
 ; sicechrt	Select
 ; sicemhlc	Select
 ; sicemhhs	Select
 ; sicemhot	Select
 ; sicemhoo	Describe
 ; sicecepc	Select
 ; sicecenc	Select
 ; siceceho	Select
 ; sicecepr	Select
 ; siceceot	Select
 ; siceceoo	Describe
 ; siceshqd	Select
 ; siceshpy	Select
 ; siceshnc	Select
 ; siceshot	Select
 ; siceshoo	Describe
 ; sipedisc	Select
 ; sipedc	yyyy-mm-dd
 ; sipecnip	Select
 ; sipecnte	Select
 ; sipecnth	Select
 ; sipecnml	Select
 ; sipecnpp	Select
 ; sipecnvd	Select
 ; sipecnot	Select
 ; sipecnoo	Describe
 ; siperslt	Select
 ; sipecmnt	Comment
 ; sidc	yyyy-mm-dd
 ; silnip	Select
 ; silnph	Select
 ; silnth	Select
 ; silnml	Select
 ; silnpp	Select
 ; silnvd	Select
 ; silnot	Select
 ; silnoo	Describe
 ; sipav	Select
 ; sipsa	Insert
 ; sipan	Insert
 ; sipcn	Insert
 ; sipc	Insert
 ; sips	Insert
 ; sipz	Insert
 ; sipcr	Insert
 ; sippn	+1 (000) 000-0000
 ; sirs	Select
 ; siesm	Select
 ; siesq	Select
 ; sies	Comment
 ; sicpd	Number
 ; sisny	Number
 ; siq	yyyy-mm-dd
 ; sicep	Describe
 ; sicadx	yyyy-mm-dd
 ; sicadxl	Describe
 ; siptct	yyyy-mm-dd
 ; siptctl	Describe
 ; siidmdc	Select
 ; sildct	Select
 ; siclin	Describe
 ; sipcrn	Describe
 ; sistatus	Select
 ; sicectap	yyyy-mm-dd
 ; sistachg	Select
 ; sidod	yyyy-mm-dd
 ; sistreas       Describe
 ;
 ; 
 ;old RCAPHACK(PARY,HACK) ; initialize the redcap mapping table
 ;chart-eligibility-complete true
 ; this hack version accepts a redcap data array in HACK, passed by name
 ; and hard codes the results of the mapping rules in that same array
 ; for use while we are trying to get the mapper to work.
 ;
 ; S @PARY@("chart-eligibility-complete")="true"
 ; S @HACK@("chart-eligibility-complete")="true"
 ; S @SS@("chart-eligibility-complete")="true"
 ; ;dfn 9000098
 ; ;dob 1952-1-12
 ; S @PARY@("dob","dob")=""
 ; ;form siform-2021-09-21
 ; ;gender M^MALE
 ; S @PARY@("gender","gender")="$S(gender=2:""F^FEMALE"",1:""M^MALE"")"
 ; I $g(@HACK@("gender"))=2 s @HACK@("gender")="F"
 ; e  s @HACK@("gender")="M"
 ; ;last5 G0027
 ; S @PARY@("last5","ssn")="$$CALC5"
 ; S @HACK@("last5")=$$CALC5(HACK)
 ; ;notes 
 ; ;samicreatedate 2021-09-21
 ; S @PARY@("samicreatedate","sdm_visit_date")=""
 ; N formdate
 ; s formdate=$g(@HACK@("sdm_visit_date"))
 ; i formdate='"" s @HACK@("samicreatedate")=formdate
 ; ;samifirsttime false
 ; S @PARY@("samifirsttime")="false"
 ; S @HACK@("samifirsttime")="false"
 ; ;saminame GPL34567,TEST76543
 ; S @PARY@("saminame","last_name")="$$CALCNAME"
 ; S @HACK@("saminame")=$$CALCNAME(HACK)
 ; S @HACK@("name")=@HACK@("saminame")
 ; ;saminum 9000098
 ; ;samiroute postform
 ; ;samistatus complete
 ; ;samistudyid XXX9000098
 ; ;sbdob 1/12/1952
 ; S @PARY@("sbdob","dob")=""
 ; S @HACK@("sbdob")=@HACK@("dob")
 ; ;sex M
 ; S @HACK@("sex")=$g(@HACK@("gender"))
 ; ;I $g(@HACK@("gender"))=2 s @HACK@("sex")="F"
 ; ;e  s @HACK@("sex")="M"
 ; S @PARY@("sex","gender")="$S(gender=2:""F"",1:""M"")"
 ; ;sicadx 
 ; ;sicadxl 
 ; ;siceceho 
 ; ;sicecenc 
 ; ;siceceoo 
 ; ;siceceot 
 ; ;sicecepc 
 ; ;sicecepr 
 ; ;sicechrt y
 ; S @PARY@("sicechrt")="y"
 ; S @HACK@("sicechrt")="y"
 ; ;sicectap 08/27/2018
 ; S @PARY@("sicectap","base_order_date")=""
 ; S @HACK@("sicectap")=$g(@HACK@("base_order_date"))
 ; ;siceiden outreach
 ; S @PARY@("siceiden")="primary/self"
 ; S @HACK@("siceiden")="primary/self"
 ; ;sicemhhs 
 ; ;sicemhlc 
 ; ;sicemhoo 
 ; ;sicemhot 
 ; ;sicep declined smoking cessation
 ; S @PARY@("sicep","smoking_cessation_not")=""
 ; S @HACK@("sicep")=$G(@HACK@("smoking_cessation_not"))
 ; ;sicerfdt
 ; S @PARY@("sicerfdt","consult")=""
 ; S @HACK@("sicerfdt")=$G(@HACK@("consult"))
 ; ;sicerfge 
 ; ;sicerfon 
 ; ;sicerfoo 
 ; ;sicerfot 
 ; ;sicerfpc 
 ; ;sicerfpu 
 ; ;sicerfsc 
 ; ;sicerfwh 
 ; ;siceshnc 
 ; ;siceshoo 
 ; ;siceshot 
 ; ;siceshpy 
 ; ;siceshqd 
 ; ;siclin 2s-pcp notified
 ; S @PARY@("siclin","patient_notes")=""
 ; S @HACK@("siclin")=$g(@HACK@("patient_notes"))
 ; ;sicpd 40
 ; S @PARY@("sicpd","smoking_per_day")=""
 ; S @HACK@("sicpd")=$g(@HACK@("smoking_per_day"))
 ; ;sidc 09/21/2021
 ; S @PARY@("sidc","sdm_visit_date")=""
 ; s formdate=$g(@HACK@("sdm_visit_date"))
 ; i formdate'="" s @HACK@("sidc")=formdate
 ; ;sidob 1/12/1952
 ; S @PARY@("sidob","dob")=""
 ; s @HACK@("sidob")=$g(@HACK@("dob"))
 ; ;sies 
 ; ;siesm p
 ; S @PARY@("siesm","smoking_history")="$$HISTORY"
 ; n history s history=$g(@HACK@("smoking_history"))
 ; S @HACK@("siesm")=$s(history=2:"p",history=3:"n",1:"c")
 ; ;siesq 
 ; ;siidmdc 1
 ; S @PARY@("siidmdc")=1
 ; S @HACK@("siidmdc")=1
 ; ;sildct y
 ; S @PARY@("sildct")="y"
 ; S @HACK@("sildct")="y"
 ; ;silnip 
 ; ;silnml 
 ; ;silnot 
 ; ;silnph 1
 ; S @PARY@("silnph")=1
 ; S @HACK@("silnph")=1
 ; ;silnpp 
 ; ;silnth 
 ; ;silnvd 
 ; ;sinamef TEST76543
 ; S @PARY@("sinamef","first_name")=""
 ; S @HACK@("sinamef")=$G(@HACK@("first_name"))
 ; ;sinamel GPL34567
 ; S @PARY@("sinamel","last_name")=""
 ; S @HACK@("sinamel")=$G(@HACK@("last_name"))
 ; ;sipan 
 ; ;sipav n
 ; S @PARY@("sipav")="n"
 ; S @HACK@("sipav")="n"
 ; ;sipc 
 ; ;sipcn 
 ; ;sipcr USA
 ; S @PARY@("sipcr")="USA"
 ; S @HACK@("sipcr")="USA"
 ; ;sipcrn 
 ; ;sipecmnt 
 ; ;sipecnip 
 ; ;sipecnml 
 ; ;sipecnot 
 ; ;sipecnpp 
 ; ;sipecnte 
 ; ;sipecnth 
 ; ;sipecnvd 
 ; ;sipedc 09/21/2021
 ; S @PARY@("sipedc","sdm_visit_date")=""
 ; i formdate'="" s @HACK@("sipedc")=formdate
 ; ;sipedisc n
 ; S @PARY@("sipedisc")="n"
 ; S @HACK@("sipedisc")="n"
 ; ;sippd 2.00
 ; ;sippn 
 ; ;sippy 118.00
 ; ;sips 
 ; ;sipsa 
 ; ;siptct 
 ; ;siptctl 
 ; ;sipz 
 ; ;siq 01/01/2018
 ; S @PARY@("siq","year_quit")=""
 ; S @HACK@("siq")=$g(@HACK@("year_quit"))
 ; ;sirs r
 ; S @PARY@("sirs","rural")="$$RURAL"
 ; n rural s rural=$g(@HACK@("rural"))
 ; S @HACK@("sirs")=$s(rural=1:"r",rural=0:"u",1:"n")
 ; ;sisid XXX9000098
 ; ;sisny 59.0
 ; S @PARY@("sisny","smoked_years")=""
 ; S @HACK@("sisny")=$G(@HACK@("smoked_years"))
 ; ;sissn 999-99-0027
 ; S @PARY@("sissn","ssn")="$$CALCSSN"
 ; S @HACK@("sissn")=$$CALCSSN(HACK)
 ; ;sistatus active
 ; n noshow s noshow=$g(@HACK@("ldct_no_show_base"))
 ; S @PARY@("sistatus")="active"
 ; S @HACK@("sistatus")=$S(noshow'="":"inactive",1:"active")
 ; ;site XXX
 ; ;siteid XXX
 ; ;ssn 999990027
 ; S @PARY@("ssn","ssn")="$$CALCSSN"
 ; S @HACK@("ssn")=$$CALCSSN(HACK)
 ; ;studyid XXX9000098
 Q
 ;
INPUTBL(ARY) ; generate a table for intake form intake from tsv
 n DROOT s DROOT=$$setroot^%wd("form fields - intake")
 n zi s zi=0
 f  s zi=$o(@DROOT@("field",zi)) q:+zi=0  d  ;
 . n var,label,value s (var,label,value)=""
 . n zj s zj=0
 . f  s zj=$o(@DROOT@("field",zi,"input",zj)) q:+zj=0  d  ;
 . . s var=$g(@DROOT@("field",zi,"input",zj,"name"))
 . . s label=$g(@DROOT@("field",zi,"input",zj,"label"))
 . . s label=$tr(label,$C(13))
 . . s value=$g(@DROOT@("field",zi,"input",zj,"value"))
 . . q:var=""
 . . q:label=""
 . . s @ARY@(var,label)=value
 ;zwr @ARY@(*)
 s zi=""
 s zj=""
 f  s zi=$o(@ARY@(zi)) q:zi=""  d  ;
 . f  s zj=$o(@ARY@(zi,zj)) q:zj=""  d  ;
 . . n ln
 . . s ln=" S G("""_zi_""","""_zj_""")="""_$g(@ARY@(zi,zj))_""""
 . . w !,ln
 ;
 q
 ;
INITG(G) ; this table was generated by the above routines and cleaned
 ; up by hand
 S G("sicadx","MM/DD/YYYY")=""
 S G("sicadxl","Location if not in VA")=""
 S G("siceceho","followed in hematology-oncology")="y"
 S G("sicecenc","followed in nodule clinic")="y"
 S G("siceceot","other")="y"
 S G("sicecepc","followed in pulmonary clinic")="y"
 S G("sicecepr","private care")="y"
 S G("sicechrt","No")="n"
 S G("sicechrt","Yes")="y"
 S G("sicectap","CT Appointment")=""
 S G("siceiden","Low-dose CT placed directly by clinician")="ldct"
 S G("siceiden","Lung screening program outreach")="outreach"
 S G("siceiden","Referral")="referral"
 S G("siceiden","Self-referred")="self"
 S G("sicemhhs","health status")="y"
 S G("sicemhlc","lung cancer")="y"
 S G("sicemhot","other")="y"
 S G("sicep","Smoking cessation education provided")=""
 S G("sicerfdt","Date of referral")=""
 S G("sicerfge","Geriatrics")="y"
 S G("sicerfon","Oncology")="y"
 S G("sicerfot","Other")="y"
 S G("sicerfpc","Primary Care")="y"
 S G("sicerfpu","Pulmonology")="y"
 S G("sicerfsc","Smoking Cessation")="y"
 S G("sicerfwh","Women's Health")="y"
 S G("siceshnc","non-cigarette use (e.g. pipe, smokeless, vape, cannabis)")="y"
 S G("siceshot","other")="y"
 S G("siceshpy","less than 30 pack years")="y"
 S G("siceshqd","quit date greater than 15 years")="y"
 S G("siclin","Clinical Indications for Initial Screening CT")=""
 S G("sicpd","How many cigarettes did you smoke per day?")=""
 S G("sidc","Date of contact")=""
 S G("sidod","Date of death")=""
 S G("sies","Comments")=""
 S G("siesm","Current")="c"
 S G("siesm","Never")="n"
 S G("siesm","Past")="p"
 S G("siesq","Yes")="1"
 S G("siidmdc","Discussion complete")="1"
 S G("siidmdc","Not applicable")="0"
 S G("sildct","Enroll in the Lung Screening program and have an LDCT ordered. Coordination of care will be made by the LSS team")="y"
 S G("sildct","Not enroll")="n"
 S G("sildct","Not enroll at this time -- okay to contact in the future")="l"
 S G("silnip","In person")="1"
 S G("silnml","Mailed letter")="1"
 S G("silnoo","Other contact method")=""
 S G("silnot","Other")="1"
 S G("silnph","Telephone")="1"
 S G("silnpp","Message in Patient Portal")="1"
 S G("silnth","TeleHealth")="1"
 S G("silnvd","Video-on-Demand (VOD)")="1"
 S G("sipan","Apt #")=""
 S G("sipav","No")="n"
 S G("sipav","Yes")="y"
 S G("sipc","City")=""
 S G("sipcn","County")=""
 S G("sipcr","Country")=""
 S G("sipcrn","Participant communication record")=""
 S G("sipecmnt","Comments")=""
 S G("sipecnip","In person")="1"
 S G("sipecnml","Mailed letter")="1"
 S G("sipecnoo","Other contact method")=""
 S G("sipecnot","Other")="1"
 S G("sipecnpp","Message in Patient Portal")="1"
 S G("sipecnte","Telephone")="1"
 S G("sipecnth","TeleHealth")="1"
 S G("sipecnvd","Video-on-Demand (VOD)")="1"
 S G("sipedc","Date of contact")=""
 S G("sipedisc","No")="n"
 S G("sipedisc","Yes")="y"
 S G("siperslt","Participant is interested in discussing lung screening. The program will proceed with enrollment process.")="y"
 S G("siperslt","Participant is not interested in discussing lung screening at this time. Ok to contact in the future.")="nn"
 S G("siperslt","Participant is not interested in discussing lung screening in the future.")="nf"
 S G("siperslt","Participant is unsure of lung screening. Ok to contact in the future.")="u"
 S G("siperslt","Unable to reach participant at this time.")="na"
 S G("sippn","Phone number")=""
 S G("sips","State")=""
 S G("sipsa","Preferred address")=""
 S G("siptct","MM/DD/YYYY")=""
 S G("siptctl","Location if not in VA")=""
 S G("sipz","Zip")=""
 S G("siq","Quit")=""
 S G("sirs","Rural")="r"
 S G("sirs","Unknown")="n"
 S G("sirs","Urban")="u"
 S G("sisny","# of years")=""
 S G("sistachg","-")=""
 S G("sistachg","Being followed elsewhere (get results)")="followed"
 S G("sistachg","Burden of cost")="cost"
 S G("sistachg","Concern about radiation")="radiation"
 S G("sistachg","Deceased")="deceased"
 S G("sistachg","Excluded (specify)")="excluded"
 S G("sistachg","Moved and unable to return")="moved"
 S G("sistachg","No insurance, can't have Dx CT")="insurance"
 S G("sistachg","No response to 3 calls + 3 letters")="noresponse"
 S G("sistachg","Other (specify)")="other"
 S G("sistachg","Physician advised against")="illadvised"
 S G("sistachg","Refused to continue")="refused"
 S G("sistachg","Study complete")="complete"
 S G("sistachg","Transferred to another institution (specify)")="transferred"
 S G("sistachg","Unable due to medical reason (specify)")="medical"
 S G("sistachg","Unable to contact")="nocontact"
 S G("sistachg","Unwilling due to personal reason (specify)")="unwilling"
 S G("sistatus","Active")="active"
 S G("sistatus","Not active")="inactive"
 S G("sistreas","Explanation")=""
 ;zwr G
 q
 ;
CONVSS2(SS) ;
 N G D INITG(.G)
 n zi s zi=""
 f  s zi=$o(@SS@(zi)) q:zi=""  d  ;
 . n val
 . s val=$g(@SS@(zi))
 . i $d(G(zi)) d  ;
 . . q:val=""
 . . n newval,found
 . . s newval=""
 . . s found=0
 . . i $d(G(zi,val)) d  ;
 . . . s newval=$g(G(zi,val))
 . . . s found=1
 . . i 'found d  ;
 . . . i val="Yes" d  q  ;
 . . . . s newval="y"
 . . . . s found=1
 . . . i $l(val,"-")=3 d  q  ;
 . . . . s newval=$$YMDTOMDY^SAMISS(val)
 . . . . s found=1
 . . . i val["(" d  ;
 . . . . n val2
 . . . . s val2=$p(val," (",1)
 . . . . i $d(G(zi,val2)) d  ;
 . . . . . s newval=$g(G(zi,val2))
 . . . . . s found=1
 . . . . q:found
 . . i found d  ;
 . . . w !,zi," ",val," changed to ",newval
 . . . s @SS@(zi)=newval
 . . e  d  ;
 . . . w !,"******** exception *********"
 . . . w "* ",zi," ",val," not found *"
 . . . ;w !,"*******************************"
 q
 ; 
eor ; end of SAMISS
