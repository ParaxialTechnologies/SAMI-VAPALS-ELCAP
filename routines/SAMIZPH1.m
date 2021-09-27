SAMIZPH1 ;ven/gpl - VAPALS PATIENT IMPORT FOR PHILIDELPHIA ; 2021-09-27t20:30z
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
SEP() ; extrinsic returns the separator character used
 Q $CHAR(9)
 ;
EN ;
 N SITE
 s SITE=$$PICSITE^SAMIMOV()
 Q:SITE="^"
 N FN,GN
 ;S DIR="/tmp/"
  ; prompt for the directory
 N SAMIDIR
 D GETDIR^SAMIFDM(.SAMIDIR)
 Q:SAMIDIR=""
 ;
 do
 . N DIR,X,Y,DA,DIRUT,DTOUT,DUOUT,DIROUT
 . S DIR(0)="F^0:1024"
 . S DIR("A")="Enter filename to load."
 . S DIR("B")="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 . D ^DIR
 . W !
 . if '$data(DIRUT) set FN=Y
 quit:'$data(FN)
 ;
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.csv"
 ;S FN="LCSV2_DATA_2021-06-29_REDCAP.tsv"
 S GN=$NA(^TMP("SAMICSV",$J,1))
 K @GN
 N OK
 S OK=$$FTG^%ZISH(SAMIDIR,FN,GN,3)
 D  ;
 . ;
 . ; Normalize overflow nodes (and hope for the best that we don't go over 32k)
 . new i,j set (i,j)=""
 . for  set i=$order(^TMP("SAMICSV",$J,i)) quit:'i  for  set j=$order(^TMP("SAMICSV",$J,i,"OVF",j)) quit:'j  do
 .. set ^TMP("SAMICSV",$J,i)=^TMP("SAMICSV",$J,i)_^TMP("SAMICSV",$J,i,"OVF",j)  ;
 K ^gpl("CSV")
 M ^gpl("CSV")=^TMP("SAMICSV",$J)
 D TOGRAPH(SITE)
 D REDCAP(SITE)
 D IMPORT(SITE)
 Q
 ;
TOGRAPH(SITE) ;
 N GN S GN=$NA(^TMP("SAMICSV",$J))
 d purgegraph^%wd(SITE_"-INTAKE")
 n root s root=$$setroot^%wd(SITE_"-INTAKE")
 n zi,zl
 ; first row
 f zi=1:1:$l(@GN@(1),$$SEP) d  ;
 . s zl=$p(@GN@(1),$$SEP,zi)
 . s @root@("key",zi,zl)=""
 . s @root@("key","B",zl,zi)=""
 q
 ;
REDCAP(SITE) ;
 n root s root=$$setroot^%wd(SITE_"-INTAKE")
 n proot s proot=$na(@root@("REDCAP"))
 n GN s GN=$NA(^TMP("SAMICSV",$J))
 n key s key=$na(@root@("key"))
 n zi s zi=1
 f  s zi=$o(@GN@(zi)) q:+zi=0  d  ;
 . n zj
 . f zj=1:1:$l(@GN@(zi),$$SEP) d  ;
 . . n zl s zl=$o(@key@(zj,""))
 . . i zl="" s zl="piece"_zj
 . . s @proot@(zi,zl)=$p(@GN@(zi),$$SEP,zj)
 q
 ;
IMPORT(SITE) ; import from csv stored in SITE-INTAKE graph
 N root,zi,proot
 s root=$$setroot^%wd(SITE_"-INTAKE")
 s proot=$na(@root@("REDCAP"))
 s zi=""
 f  s zi=$o(@proot@(zi)) q:zi=""  d  ;
 . n onepat,ztbl
 . m onepat=@proot@(zi)
 . d RCAPHACK("ztbl","onepat")
 . s onepat("site")=SITE
 . d CREATE(.onepat)
 Q
 ;
T1() ;
 ;
 n vars
 n saminame
 s saminame="GPL34567,TEST76543"
 s vars("name")=saminame
 S vars("ssn")="999990027"
 s vars("dob")="1952-01-12"
 s vars("gender")="M"
 s vars("site")="XXX"
 d CREATE(.vars)
 q
 ;
CREATE(vars) ; create a patient record and an intake form from vars
 ;
 n varscpy m varscpy=vars
 N SAMIRTN
 D REG^SAMIHOM4(.SAMIRTN,.varscpy)
 N saminame
 s saminame=$g(vars("saminame"))
 i saminame="" b
 s vars("name")=saminame
 s vars("dfn")=$$GETDFN(saminame)
 m varscpy=vars
 D WSNEWCAS^SAMIHOM3(.varscpy,.SAMIBDY,.SAMIRESULT)
 ;ZWR varscpy
 n sid,sikey
 s sid=$g(varscpy("studyid"))
 s sikey=$g(varscpy("form"))
 s sikey=$p(sikey,"vapals:",2)
 w !,"sid: ",sid," sikey: ",sikey
 n root s root=$$setroot^%wd("vapals-patients")
 q:sid=""
 q:sikey=""
 m @root@("graph",sid,sikey)=vars
 ;N NUM S NUM=$$GETNUM(saminame)
 ;D MKSIFORM^SAMIHOM3(NUM)
 Q
 ;
GETNUM(SAMINAME) ; extrinsic returns the ien in vapals-patients for 
 ; name of SAMINAME
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 n lien s lien=$o(@lroot@("name",SAMINAME,""))
 n dfn s dfn=$g(@lroot@(lien,"dfn"))
 n num s num=$o(@proot@("dfn",dfn,""))
 q num
 ;
GETDFN(SAMINAME) ; extrinsic returns the ien in vapals-patients for 
 ; name of SAMINAME
 n lroot s lroot=$$setroot^%wd("patient-lookup")
 n lien s lien=$o(@lroot@("name",SAMINAME,""))
 n dfn s dfn=$g(@lroot@(lien,"dfn"))
 q dfn
 ;
PROCTBL(ARY,TBL) ; process an array (ARY) using a mapping table (TBL)
 ; both passed by name
 ;
 n samiv s samiv=""
 f  s samiv=$o(@TBL@(samiv)) q:samiv=""  d  ;
 . W !,samiv
 . n otherv
 . s otherv=$o(@TBL@(samiv,""))
 . w !,"otherv: "_otherv
 . ;if $g(@ARY@(samiv))'="" q  ;
 . if otherv="" s @ARY@(samiv)=$G(@TBL@(samiv)) q  ;
 . n proc
 . s proc=$g(@TBL@(samiv,otherv))
 . i $e(proc,1,2)="$$" d  q  ;
 . . ; call an extrinsic
 . . n X s X="S @ARY@("""_samiv_""")="_proc_"(ARY)"
 . . B
 . . X @X
 . i $e(proc,1,1)="$" d  q  ;
 . . ; execute a line of code ie $select or $tr
 . . n X s X="S @ARY@("""_samiv_""")="_proc
 . . W !,"proc: ",X
 . . X @X
 . set @ARY@(samiv)=@ARY@(otherv) ; simple assignment
 ;
 Q
 ;
CALC5(SARY) ; extrinsic returns last5
 n lname,ssn
 s lname=@SARY@("last_name")
 s ssn=@SARY@("ssn")
 if $l(ssn)<4 s ssn=$e("0000",1,4-$l(ssn))_ssn
 Q $e(lname,1,1)_ssn
 ;
CALCNAME(SARY) ; extrinsic returns lastname,firstname from array
 Q $g(@SARY@("last_name"))_","_$g(@SARY@("first_name"))
 ;
CALCSSN(SARY) ; extrinsic returns false but correctly formatted ssn
 n ssn s ssn=$g(@SARY@("ssn"))
 i $l(ssn)<9 d  ;
 . i $l(ssn)=4 s ssn=99999_ssn q
 . s ssn=99999_$e("0000",1,4-$l(ssn))_ssn
 Q ssn
 ;
RCAPTBL(PARY) ; initialize the redcap mapping table
 ;chart-eligibility-complete true
 S @PARY@("chart-eligibility-complete")="true"
 ;dfn 9000098
 ;dob 1952-1-12
 S @PARY@("dob","dob")=""
 ;form siform-2021-09-21
 ;gender M^MALE
 S @PARY@("gender","gender")="$S(gender=2:""F"",1:""M"")"
 ;last5 G0027
 S @PARY@("last5","ssn")="$$CALC5"
 ;notes 
 ;samicreatedate 2021-09-21
 S @PARY@("samicreatedate","sdm_visit_date")=""
 ;samifirsttime false
 S @PARY@("samifirsttime")="false"
 ;saminame GPL34567,TEST76543
 S @PARY@("saminame","last_name")="$$CALCNAME"
 ;saminum 9000098
 ;samiroute postform
 ;samistatus complete
 ;samistudyid XXX9000098
 ;sbdob 1/12/1952
 S @PARY@("sbdob","dob")=""
 ;sex M
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
 n elig s elig=$g(@HACK@("elig_enroll"))
 S @HACK@("sicechrt")=$s(elig=0:"n",1:"y")
 ;sicectap 08/27/2018
 S @PARY@("sicectap","base_order_date")=""
 ;siceiden outreach
 S @PARY@("siceiden")="outreach"
 ;sicemhhs 
 ;sicemhlc 
 ;sicemhoo 
 ;sicemhot 
 ;sicep declined smoking cessation
 S @PARY@("sicep","smoking_cessation_not")=""
 ;sicerfdt 
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
 ;sicpd 40
 S @PARY@("sicpd","smoking_per_day")=""
 ;sidc 09/21/2021
 S @PARY@("sidc","sdm_visit_date")=""
 ;sidob 1/12/1952
 S @PARY@("sidob","dob")=""
 ;sies 
 ;siesm p
 S @PARY@("siesm")="p"
 ;siesq 
 ;siidmdc 1
 S @PARY@("siidmdc")=1
 ;sildct y
 S @PARY@("sildct")="y"
 ;silnip 
 ;silnml 
 ;silnot 
 ;silnph 1
 S @PARY@("silnph")=1
 ;silnpp 
 ;silnth 
 ;silnvd 
 ;sinamef TEST76543
 S @PARY@("sinamef","first_name")=""
 ;sinamel GPL34567
 S @PARY@("sinamel","last_name")=""
 ;sipan 
 ;sipav n
 S @PARY@("sipav")="n"
 ;sipc 
 ;sipcn 
 ;sipcr USA
 S @PARY@("sipcr")="USA"
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
 ;sipedisc n
 S @PARY@("sipedisc")="n"
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
 ;sisid XXX9000098
 ;sisny 59.0
 S @PARY@("sisny","smoked_years")=""
 ;sissn 999-99-0027
 S @PARY@("sissn","ssn")="$$CALCSSN"
 ;sistatus active
 S @PARY@("sistatus")="active"
 ;site XXX
 ;siteid XXX
 ;ssn 999990027
 S @PARY@("ssn","ssn")="$$CALCSSN"
 ;studyid XXX9000098
 Q
 ;
RCAPHACK(PARY,HACK) ; initialize the redcap mapping table
 ;chart-eligibility-complete true
 ; this hack version accepts a redcap data array in HACK, passed by name
 ; and hard codes the results of the mapping rules in that same array
 ; for use while we are trying to get the mapper to work.
 ;
 S @PARY@("chart-eligibility-complete")="true"
 S @HACK@("chart-eligibility-complete")="true"
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
T2() ;
 N RCAPARY,ZTBL
 D RCAPTBL("ZTBL")
 D RCAPTST("RCAPARY")
 ;
 D PROCTBL("RCAPARY","ZTBL")
 ZWR RCAPARY
 Q
 ;
T3() ; HACK VERSION 
 N RCAPARY,ZTBL
 D RCAPTST("RCAPARY")
 D RCAPHACK("ZTBL","RCAPARY")
 ZWR RCAPARY
 S RCAPARY("site")="XXX"
 D CREATE(.RCAPARY)
 Q
 ;
RCAPTST(RARY) ; initialize a Redcap test array
 ;|--REDCAP 
 S @RARY@("age")=70.1
 S @RARY@("airway_disease___1")=1
 S @RARY@("airway_disease___2")=1
 S @RARY@("airway_disease___3")=0
 S @RARY@("base_completion_date")="8/27/2018"
 S @RARY@("base_order_date")="8/27/2018"
 S @RARY@("base_schedule")=""
 S @RARY@("bmi")=38.7
 S @RARY@("cancer_hx")=1
 S @RARY@("cancer_type")=""
 S @RARY@("consult")="8/3/2018"
 S @RARY@("dob")="6/15/1948"
 S @RARY@("educ_level")=""
 S @RARY@("elig_enroll")=1
 S @RARY@("environ_exp___1")=0
 S @RARY@("environ_exp___2")=0
 S @RARY@("environ_exp___3")=0
 S @RARY@("environ_exp___4")=0
 S @RARY@("ethnicity")=2
 S @RARY@("failed_enroll")=""
 S @RARY@("failed_other")=""
 S @RARY@("fam_hx")=1
 S @RARY@("first_name")="Mac5"
 S @RARY@("gender")=1
 S @RARY@("height")=69
 S @RARY@("imported_age")=70
 S @RARY@("last_name")="McDonald"
 S @RARY@("ldct_no_show_base")=""
 S @RARY@("oth_enviorn_exp")=""
 S @RARY@("other_referral_type")=""
 S @RARY@("pack_years")=100
 S @RARY@("patient_notes")="2s-pcp notified"
 S @RARY@("pt_age")=72.1
 S @RARY@("pt_pcp")="Keenan"
 S @RARY@("quit_smoking")=""
 S @RARY@("record_id")=1
 S @RARY@("referral_type")=""
 S @RARY@("rural")=0
 S @RARY@("sdm___1")=1
 S @RARY@("sdm___2")=0
 S @RARY@("sdm___3")=0
 S @RARY@("sdm_visit_date")="8/27/2018"
 S @RARY@("smoked_years")=59
 S @RARY@("smoking_cessation_not")="Declined smoking cessation support"
 S @RARY@("smoking_history")=1
 S @RARY@("smoking_per_day")=40
 S @RARY@("ssn")=4958
 S @RARY@("tobacco_cessation_referral")=2
 S @RARY@("weight")=262
 S @RARY@("year_quit")=""
 q
 ;