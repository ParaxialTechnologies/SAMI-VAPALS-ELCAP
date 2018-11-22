SAMIIFF ;ven/arc - Unit test for SAMISRC2 ; 2018-11-21T22:00Z
 ;;18.0;SAMI;;
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;   Add label comments
 ;
 ; @section 1 code
 ;
QUIT ; No entry from top
 ;
 ;
BLDGRPH ; Build a graph of the intake form fields
 ; Comments
 ;
 DO purgegraph^%wd("siform-fields")
 DO addgraph^%wd("siform-fields")
 ;
 NEW ROOT SET ROOT=$$setroot^%wd("siform-fields")
 ;
 SET @ROOT@("field",1,"label")=""
 SET @ROOT@("field",1,"name")="viewport"
 SET @ROOT@("field",2,"label")="Eligible based on chart? - Yes"
 SET @ROOT@("field",2,"name")="sipechrt"
 SET @ROOT@("field",2,"value")="y"
 SET @ROOT@("field",3,"label")="Eligible based on chart? - No"
 SET @ROOT@("field",3,"name")="sipechrt"
 SET @ROOT@("field",3,"value")="n"
 SET @ROOT@("field",4,"label")="Eligible based on discussion with patient? - Yes"
 SET @ROOT@("field",4,"name")="sipedisc"
 SET @ROOT@("field",4,"value")="y"
 SET @ROOT@("field",5,"label")="Eligible based on discussion with patient? - No"
 SET @ROOT@("field",5,"name")="sipedisc"
 SET @ROOT@("field",5,"value")="n"
 SET @ROOT@("field",6,"label")="Medical History - lung cancer"
 SET @ROOT@("field",6,"name")="siremhlc"
 SET @ROOT@("field",7,"label")="Medical History - health status"
 SET @ROOT@("field",7,"name")="siremhhs"
 SET @ROOT@("field",8,"label")="Medical History - other"
 SET @ROOT@("field",8,"name")="siremhot"
 SET @ROOT@("field",9,"label")="Medical History - other - specify"
 SET @ROOT@("field",9,"name")="sireemhoo"
 SET @ROOT@("field",10,"label")="Receiving Care Elsewhere - followed in pulmonary clinic"
 SET @ROOT@("field",10,"name")="sirecepc"
 SET @ROOT@("field",11,"label")="Receiving Care Elsewhere - followed in nodule clinic"
 SET @ROOT@("field",11,"name")="sirecenc"
 SET @ROOT@("field",12,"label")="Receiving Care Elsewhere - followed in Hematology-Oncology"
 SET @ROOT@("field",12,"name")="sireceho"
 SET @ROOT@("field",13,"label")="Receiving Care Elsewhere - private care"
 SET @ROOT@("field",13,"name")="sirecepc"
 SET @ROOT@("field",14,"label")="Receiving Care Elsewhere - other"
 SET @ROOT@("field",14,"name")="sireceot"
 SET @ROOT@("field",15,"label")="Receiving Care Elsewhere - other - specify"
 SET @ROOT@("field",15,"name")="sireceoo"
 SET @ROOT@("field",16,"label")="Smoking History - quit date greater than 15 years"
 SET @ROOT@("field",16,"name")="sireshqd"
 SET @ROOT@("field",17,"label")="Smoking History - less than 30 pack years"
 SET @ROOT@("field",17,"name")="sireshpy"
 SET @ROOT@("field",18,"label")="Smoking History - non-cigarette Use (e.g. pipe, smokeless, vape, cannabis)"
 SET @ROOT@("field",18,"name")="sireshnc"
 SET @ROOT@("field",19,"label")="Smoking History - other"
 SET @ROOT@("field",19,"name")="sireshot"
 SET @ROOT@("field",20,"label")="Smoking History - other - specify"
 SET @ROOT@("field",20,"name")="sireshoo"
 SET @ROOT@("field",21,"label")="Unable To Contact - left voice message"
 SET @ROOT@("field",21,"name")="sireucvm"
 SET @ROOT@("field",22,"label")="Unable To Contact - bad phone number"
 SET @ROOT@("field",22,"name")="sireucbp"
 SET @ROOT@("field",23,"label")="Unable To Contact - other"
 SET @ROOT@("field",23,"name")="sireucot"
 SET @ROOT@("field",24,"label")="Unable To Contact - other - specify"
 SET @ROOT@("field",24,"name")="sireucoo"
 SET @ROOT@("field",25,"label")="Date of contact"
 SET @ROOT@("field",25,"name")="sidc"
 SET @ROOT@("field",26,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - Phone"
 SET @ROOT@("field",26,"name")="silnph"
 SET @ROOT@("field",27,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - Letter sent"
 SET @ROOT@("field",27,"name")="silnls"
 SET @ROOT@("field",28,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - Pulmonary"
 SET @ROOT@("field",28,"name")="silnpu"
 SET @ROOT@("field",29,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - PCP"
 SET @ROOT@("field",29,"name")="silnpc"
 SET @ROOT@("field",30,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - Oncology"
 SET @ROOT@("field",30,"name")="silnpn"
 SET @ROOT@("field",31,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - Smoking cessation program"
 SET @ROOT@("field",31,"name")="silnpp"
 SET @ROOT@("field",32,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - Other"
 SET @ROOT@("field",32,"name")="silnpo"
 SET @ROOT@("field",33,"label")="How did you learn about the Lung Screening and Surveillance (LSS) program? - Other - Specify"
 SET @ROOT@("field",33,"name")="silnpos"
 SET @ROOT@("field",34,"label")="Primary address verified - Yes"
 SET @ROOT@("field",34,"name")="sipav"
 SET @ROOT@("field",34,"value")="y"
 SET @ROOT@("field",35,"label")="Primary address verified - No"
 SET @ROOT@("field",35,"name")="sipav"
 SET @ROOT@("field",35,"value")="n"
 SET @ROOT@("field",36,"label")="Preferred address"
 SET @ROOT@("field",36,"name")="sipsa"
 SET @ROOT@("field",37,"label")="Apt #"
 SET @ROOT@("field",37,"name")="sipan"
 SET @ROOT@("field",38,"label")="County"
 SET @ROOT@("field",38,"name")="sipcn"
 SET @ROOT@("field",39,"label")="City"
 SET @ROOT@("field",39,"name")="sipc"
 SET @ROOT@("field",40,"label")="State"
 SET @ROOT@("field",40,"name")="sips"
 SET @ROOT@("field",41,"label")="Zip"
 SET @ROOT@("field",41,"name")="sipz"
 SET @ROOT@("field",42,"label")="Country"
 SET @ROOT@("field",42,"name")="sipcr"
 SET @ROOT@("field",43,"label")="Phone number"
 SET @ROOT@("field",43,"name")="sippn"
 SET @ROOT@("field",44,"label")="Rural status - Urban"
 SET @ROOT@("field",44,"name")="sirs"
 SET @ROOT@("field",44,"value")="u"
 SET @ROOT@("field",45,"label")="Rural status - Rural"
 SET @ROOT@("field",45,"name")="sirs"
 SET @ROOT@("field",45,"value")="r"
 SET @ROOT@("field",46,"label")="Rural status - Unknown"
 SET @ROOT@("field",46,"name")="sirs"
 SET @ROOT@("field",46,"value")="n"
 SET @ROOT@("field",47,"label")="Have you ever smoked"
 SET @ROOT@("field",47,"name")="sies"
 SET @ROOT@("field",48,"label")="Have you ever smoked - Never smoked"
 SET @ROOT@("field",48,"name")="siesn"
 SET @ROOT@("field",49,"label")="Have you ever smoked - Past"
 SET @ROOT@("field",49,"name")="siesp"
 SET @ROOT@("field",50,"label")="Have you ever smoked - Current"
 SET @ROOT@("field",50,"name")="siesc"
 SET @ROOT@("field",51,"label")="Have you ever smoked - Willing to quit"
 SET @ROOT@("field",51,"name")="siesq"
 SET @ROOT@("field",52,"label")="How many cigarettes did you smoke per day?"
 SET @ROOT@("field",52,"name")="sicpd"
 SET @ROOT@("field",53,"label")="# of years"
 SET @ROOT@("field",53,"name")="sisny"
 SET @ROOT@("field",54,"label")="Quit (smoking)"
 SET @ROOT@("field",54,"name")="siq"
 SET @ROOT@("field",55,"label")="Smoking cessation education provided"
 SET @ROOT@("field",55,"name")="sicep"
 SET @ROOT@("field",56,"label")="Lung CA Dx (if applicable)"
 SET @ROOT@("field",56,"name")="sicadx"
 SET @ROOT@("field",57,"label")="Lung CA Dx (if applicable) - Location if not in VA"
 SET @ROOT@("field",57,"name")="sicadxl"
 SET @ROOT@("field",58,"label")="Prior LDCT"
 SET @ROOT@("field",58,"name")="sipldct"
 SET @ROOT@("field",59,"label")="Prior LDCT - Location if not in VA"
 SET @ROOT@("field",59,"name")="sipldctl"
 SET @ROOT@("field",60,"label")="Informed Decision Making discussion complete"
 SET @ROOT@("field",60,"name")="siidmdc"
 SET @ROOT@("field",61,"label")="Based on this information, the Veteran has opted to - Not enroll"
 SET @ROOT@("field",61,"name")="sildct"
 SET @ROOT@("field",61,"value")="n"
 SET @ROOT@("field",62,"label")="Based on this information, the Veteran has opted to - Not enroll at this time, okay to contact in the future"
 SET @ROOT@("field",62,"name")="sildct"
 SET @ROOT@("field",62,"value")="l"
 SET @ROOT@("field",63,"label")="Based on this information, the Veteran has opted to - Enroll in the Lung Screening and Surveillance (LSS) program and have an LDCT ordered. Coordination of care will be made by the LSS team"
 SET @ROOT@("field",63,"name")="sildct"
 SET @ROOT@("field",63,"value")="y"
 SET @ROOT@("field",64,"label")="Clinical Indications for Initial Screening CT"
 SET @ROOT@("field",64,"name")="siclin"
 SET @ROOT@("field",65,"label")="Enrollment - Active"
 SET @ROOT@("field",65,"name")="sistatus"
 SET @ROOT@("field",66,"label")="Enrollment - Not active"
 SET @ROOT@("field",66,"name")="sistatus"
 SET @ROOT@("field",67,"label")="Reason for change"
 SET @ROOT@("field",67,"name")="sistachg"
 SET @ROOT@("field",68,"label")="Reason for change - Explanation"
 SET @ROOT@("field",68,"name")="sistreas"
 ;
 QUIT ; End of BLDGRPH
 ;
 ;
EOR ; End of routine SAMIIFF
