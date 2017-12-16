SAMIFRM ;ven/gpl - ielcap forms ;Sep 18,2017@18:01
 ;;18.0;SAM;;
 ;
 ; Routine SAMIFRM contains subroutines for managing the ELCAP forms,
 ; including initialization and enhancements to the SAMI FORM FILE (311.11)
 ;
 ; Primary Development History
 ;
 ; @primary-dev: George P. Lilly (gpl)
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ; @copyright: 2017, Vista Expertise Network (ven), all rights reserved
 ; @license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2017-09-19T11:01Z
 ; @application: Screening Applications Management (SAM)
 ; @module: Screening Applications Management - IELCAP (SAMI)
 ; @suite-of-files: SAMI Forms (311.101-311.199)
 ; @version: 18.0T01 (first development version)
 ; @release-date: not yet released
 ; @patch-list: none yet
 ;
 ; @funding-org: 2017-2018,Bristol-Myers Squibb Foundation (bmsf)
 ;   https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;
 ; 2017-09-19 ven/gpl v18.0t01 SAMIFRM: initialize the SAMI FORM file from elcap-patient graphs,
 ; using mash tools and graphs (%yottaq,^%wd)
 ;
 ;
 ; contents
 ;
 ; INITFRMS: initial all available forms
 ; INITFRM: initialize one form from elcap-patient graph (field names only)
 ;
 ;
 ;
 Q
 ;
INITFRMS ; initilize form file from elcap-patient graphs
 ;
 n root s root=$$setroot^%yottaq("elcap-patients")
 q:root=""
 n groot s groot=$na(@root@("graph"))
 n patient s patient=$o(@groot@(""),-1) ; use the last patient in the graph
 q:patient=""
 n form s form=""
 f  s form=$o(@groot@(patient,form)) q:form=""  d  ; for each form the patient has
 . n array
 . d getVals^%yottaq("array",form,patient) ; get the array of fields and values
 . w !,"using patient: ",patient
 . d INIT1FRM(form,"array") ; initialize the form and the fields in the form
 q
 ;
INIT1FRM(form,ary) ; initialize one form named form from ary passed by name 
 w !,form
 zwr @ary
 n fn s fn=311.11 ; file number
 n sfn s sfn=311.11001 ; subfile number for variables
 n fmroot s fmroot=$na(^SAMI(311.11))
 n fda,%yerr
 s fda(fn,"?+1,",.01)=form
 w !,"creating form ",form
 d UPDATE^DIE("","fda","","%yerr")
 i $d(%yerr) d  q  ;
 . w !,"error creating form record ",id,!
 . zwr %yerr
 n %ien s %ien=$o(@fmroot@("B",form,""))
 i %ien="" d  q  ;
 . w !,"error locating form record ",form
 n %j s %j=""
 n vcnt s vcnt=0
 k fda
 f  s %j=$o(@ary@(%j)) q:%j=""  d  ;
 . s vcnt=vcnt+1
 . s fda(sfn,"?+"_vcnt_","_%ien_",",.01)=%j
 d CLEAN^DILF
 w !,"creating variables for form ",%ien
 d UPDATE^DIE("","fda","","%yerr")
 i $d(%yerr) d  q  ;
 . w !,"error creating variable record ",%j,!
 . zwr %yerr
 q
 ;
REGFORMS() ; register elcap forms in the form mapping file
 n fn s fn=311.11 ; file number
 n sfn s sfn=311.11001 ; subfile number for variables
 n fmroot s fmroot=$na(^SAMI(311.11))
 ;
 ; table of forms
 ;
 n ftbl
 s ftbl("bxform","Biopsy_Mediastinoscopy Form.html")=""
 s ftbl("ceform","CT Evaluation Form.html")=""
 s ftbl("sbform2","Background Form.html")=""
 s ftbl("fuform","Follow-up Form.html")=""
 s ftbl("siform","Intake Form.html")=""
 s ftbl("rbform","Intervention and Treatment Form.html")=""
 s ftbl("ptform","PET Evaluation Form.html")=""
 s ftbl("sintake","Schedule Contact.html")=""
 ;
 n zi s zi=""
 f  s zi=$o(ftbl(zi)) q:zi=""  d  ;
 . n fda,%yerr
 . s fda(fn,"?+1,",.01)=zi
 . s fda(fn,"?+1,",2)=$o(ftbl(zi,""))
 . w !,"creating form ",zi," named: ",$o(ftbl(zi,""))
 . d UPDATE^DIE("","fda","","%yerr")
 . i $d(%yerr) d  q  ;
 . . w !,"error creating form record ",id,!
 . . zwr %yerr
 . n %ien s %ien=$o(@fmroot@("B",form,""))
 . i %ien="" d  q  ;
 . . w !,"error locating form record ",form
 ;
 q
 ;
 
