SAMIUR2 ;ven/gpl - sami user reports ; 1/22/19 1:31pm
 ;;18.0;SAM;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; SAMIUR contains the routines to generate user reports
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
RPTTBL(RPT,TYPE) ; RPT is passed by reference and returns the 
 ; report definition table. TYPE is the report type to be returned
 ; This routine could use a file or a graph in the next version
 ;
 if TYPE="followup" d  q  ;
 . S RPT(1,"header")="F/U Date"
 . S RPT(1,"routine")="$$FUDATE^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")="SSN"
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 . S RPT(4,"header")="Baseline Date"
 . S RPT(4,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(5,"header")="Recommend"
 . S RPT(5,"routine")="$$RECOM^SAMIUR2"
 . S RPT(6,"header")="When"
 . S RPT(6,"routine")="$$WHEN^SAMIUR2"
 . S RPT(7,"header")="Last Exam"
 . S RPT(7,"routine")="$$LASTEXM^SAMIUR2"
 . S RPT(8,"header")="Status"
 . S RPT(8,"routine")="$$STATUS^SAMIUR2"
 . S RPT(9,"header")="Street Addr."
 . S RPT(9,"routine")="$$STREETAD^SAMIUR2"
 if TYPE="activity" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")="SSN"
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="Study Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Type"
 . S RPT(4,"routine")="$$STUDYTYP^SAMIUR2"
 . S RPT(5,"header")="CT Protocol"
 . S RPT(5,"routine")="$$CTPROT^SAMIUR2"
 . S RPT(6,"header")="Follow up"
 . S RPT(6,"routine")="$$RECOM^SAMIUR2"
 . S RPT(7,"header")="When"
 . S RPT(7,"routine")="$$WHEN^SAMIUR2"
 . S RPT(8,"header")="on Date"
 . S RPT(8,"routine")="$$FUDATE^SAMIUR2"
 if TYPE="enrollment" d  q  ;
 . S RPT(1,"header")="Name"
 . S RPT(1,"routine")="$$NAME^SAMIUR2"
 . S RPT(2,"header")="SSN"
 . S RPT(2,"routine")="$$SSN^SAMIUR2"
 . S RPT(3,"header")="Study Date"
 . S RPT(3,"routine")="$$STUDYDT^SAMIUR2"
 . S RPT(4,"header")="Gender"
 . S RPT(4,"routine")="$$GENDER^SAMIUR2"
 . S RPT(5,"header")="Race"
 . S RPT(5,"routine")="$$RACE^SAMIUR2"
 . S RPT(6,"header")="Ethnicity"
 . S RPT(6,"routine")="$$ETHNCTY^SAMIUR2"
 . S RPT(7,"header")="Age"
 . S RPT(7,"routine")="$$AGE^SAMIUR2"
 . S RPT(8,"header")="Smoking Status"
 . S RPT(8,"routine")="$$SMKSTAT^SAMIUR2"
 if TYPE="incomplete" d  q  ;
 . S RPT(1,"header")="Enrollment date"
 . S RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")="SSN"
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 . S RPT(4,"header")="Incomplete form"
 . S RPT(4,"routine")="$$IFORM^SAMIUR2"
 . S RPT(5,"header")="Incomplete form date"
 . S RPT(5,"routine")="$$IFORMDT^SAMIUR2"
 if TYPE="missingct" d  q  ;
 . S RPT(1,"header")="Enrollment date"
 . S RPT(1,"routine")="$$BLINEDT^SAMIUR2"
 . S RPT(2,"header")="Name"
 . S RPT(2,"routine")="$$NAME^SAMIUR2"
 . S RPT(3,"header")="SSN"
 . S RPT(3,"routine")="$$SSN^SAMIUR2"
 ;
 q
 ;
FUDATE(zdt,dfn,SAMIPATS) ; extrinsic returns followup date
 n fud
 s fud="fudate"
 q $g(SAMIPATS(zdt,dfn,"cefud"))
 ;
NAME(zdt,dfn,SAMIPATS) ; extrinsic returns the name including a hyperlink
 n nam
 s nam="Name"
 q $g(SAMIPATS(zdt,dfn,"nuhref"))
 ;
SSN(zdt,dfn,SAMIPATS) ; extrinsic returns SSN
 n ssn
 s ssn="ssn"
 q $g(SAMIPATS(zdt,dfn,"ssn"))
 ;
BLINEDT(zdt,dfn,SAMIPATS) ; extrinsic returns Baseline Date
 n bldt
 s bldt="baslinedate"
 q $g(SAMIPATS(zdt,dfn,"edate"))
 ;
RECOM(zdt,dfn,SAMIPATS) ; extrinsic returns Recommendation
 n recom
 s recom="recommendation"
 q recom
 ;
WHEN(zdt,dfn,SAMIPATS) ; extrinsic returns followup text ie. "in one year"
 n whn
 s whn="in one year"
 q whn
 ;
LASTEXM(zdt,dfn,SAMIPATS) ; extrinsic returns patient last exam
 n lexm
 s lexm="last exam date"
 q lexm
 ;
STATUS(zdt,dfn,SAMIPATS) ; extrinsic returns patient status
 n stat
 s stat="active"
 q stat
 ;
STREETAD(zdt,dfn,SAMIPATS) ; extrinsic returns patient street address
 n staddr
 s staddr="street address"
 q staddr
 ;
STUDYDT(zdt,dfn,SAMIPATS) ; extrinsic returns the lastest Study Date
 q "study date"
 ;
STUDYTYP(zdt,dfn,SAMIPATS) ; extrinsic returns the latest Study Type
 q "study type"
 ;
CTPROT(zdt,dfn,SAMIPATS) ; extrinsic returns the CT Protocol
 q "CT Protocol"
 ;
GENDER(zdt,dfn,SAMIPATS) ; extrinsic returns gender
 q "gender"
 ;
RACE(zdt,dfn,SAMIPATS) ; extrinsic returns race
 q "race"
 ;
ETHNCTY(zdt,dfn,SAMIPATS) ; extrinsic returns ethnicity
 q "ethnicity"
 ;
AGE(zdt,dfn,SAMIPATS) ; extrinsic returns age
 q "age"
 ;
SMKSTAT(zdt,dfn,SAMIPATS) ; extrinsic returns smoking status
 q "smoking status"
 ;
IFORM(zdt,dfn,SAMIPATS) ; extrinsic returns the name(s) of the incomplete forms
 q "incomplete forms"
 ;
IFORMDT(zdt,dfn,SAMIPATS) ; extrinsic returns incomplete form date
 q "iform date"
 ;
