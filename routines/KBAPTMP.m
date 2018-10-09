KBAPTMP ; ; 10/9/18 12:00pm
 ;;
 ;
BLDKBAP ;
 K ^KBAP("LABARR")
 S F60IEN=0
BNAME F  S F60IEN=$O(^LAB(60,F60IEN)) Q:'F60IEN  D
 . S F60NAME=$$UP^XLFSTR($P($G(^LAB(60,F60IEN,0)),"^"))
 .; D GETLCM(F60IEN,F60NAME)
 .; D GETLOD(F60IEN,F60NAME)
 . D GET953(F60IEN,F60NAME)
 S F60IEN=0
BSYN F  S F60IEN=$O(^LAB(60,F60IEN)) Q:'F60IEN  D
 . S F60SYN=""
 . F  S F60SYN=$O(^LAB(60,F60IEN,5,"B",F60SYN)) Q:($TR(F60SYN," ")="")  D
 ..; D GETLCM(F60IEN,F60SYN)
 ..; D GETLOD(F60IEN,F60SYN)
 .. D GET953(F60IEN,F60SYN)
 Q
 ;
 ; Find entries in 95.3 that match for this test in file 60
 ;Entry
 ;   F60IEN   = IEN of lab test in file 60
 ;   F60NAME  = name of lab test in file 60
 ;Return
 ;   ^KBAP("LABARR",F60IEN,"95.3",ACCAREA,SITESP,$P(LODLNC,"-"),LODLNC,F60NAME,LODGIEN,PRPRTY)=EXMPUNTS
 ;S NODE=$NA(^LAB(95.3,"E","GLUCOS")) F  S NODE=$Q(@NODE) I $TR($E($P(NODE,",",3),1,7),"""")["GLUCOS"
GET953(F60IEN,F60NAME) ;
 ; Find potential matches in 95.3
 N SF60NAME,SF60L,DONE
 S DONE=0
 S SF60NAME=$E(F60NAME,1,$L(F60NAME)-1)
 S SF60L=$L(SF60NAME)
 S NODE=$NA(^LAB(95.3,"E",SF60NAME)),SNODE=$P($NA(^LAB(95.3,"E")),")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D  Q:DONE
 . I '($E($P($TR(NODE,""""),",",3),1,SF60L)[SF60NAME) D  Q
 .. S DONE=1
 . N LabLoincIEN,LabLoinc0node,LabAccArea64061ien,LabAccessionArea
 . N LabLoincFull,LabLoincShortName,LabLoincCmptIEN
 . N LabLoincCmptName,LabElectronicCodesIEN,SYSTEM
 . N Units
 . S LabLoincIEN=$QS(NODE,4)
 . Q:'$G(LabLoincIEN)
 .; Quit if CLASSTYPE is not LABORATORY
 . Q:($G(^LAB(95.3,LabLoincIEN,3))>2)
 .; Quit if STATUS is not DEL, TRIAL, or DISCOURAGED
 . Q:'($P($G(^LAB(95.3,LabLoincIEN,4)),"^")="")
 . S LabLoinc0node=$G(^LAB(95.3,LabLoincIEN,0))
 . S LabAccArea64061ien=$P(LabLoinc0node,"^",11)
 . S LabAccessionArea=$P($G(^LAB(64.061,LabAccArea64061ien,0)),"^")
 . S LabLoincFull=LabLoincIEN_"-"_$P(^LAB(95.3,LabLoincIEN,0),"^",15)
 . S LabLoincShortName=$G(^LAB(95.3,LabLoincIEN,81))
 .; Get Lab LOINC Component [95.31] entry
 . S LabLoincCmptIEN=$P(LabLoinc0node,"^",2)
 . S LabLoincCmptName=$G(^LAB(95.31,LabLoincCmptIEN,0))
 .; Get SYSTEM or entry into LAB ELECTRONICS CODES [64.061] file
 . S LabElectronicCodesIEN=$P(LabLoinc0node,"^",8)
 . Q:'$G(LabElectronicCodesIEN)
 . S SYSTEM=$G(^LAB(64.061,LabElectronicCodesIEN,0))
 . S LabElectronicCodesIEN=$P(LabLoinc0node,"^",14)
 . S Units="unk"
 . S:($G(LabElectronicCodesIEN)>0) Units=$P($G(^LAB(64.061,LabElectronicCodesIEN,0)),"^")
 .;
 .; If LabLoincCmptName or LabLoincShortName match, go on
 . I ((LabLoincCmptName=F60NAME)!($E(LabLoincShortName,1,$L(F60NAME))=F60NAME)) D
 .. W !,"LabLoincCmptName=",LabLoincCmptName
 .. W !,"LabAccessionArea=",LabAccessionArea
 .. W !,"LabLoincIEN= ",LabLoincIEN
 .. W !,"LabLoincShortName= ",LabLoincShortName
 .. W !,"FULL LOINC= ",LabLoincFull
 .. W !,"NODE=",NODE
 .. W !,"IEN INTO LAB(64.061)=",LabElectronicCodesIEN
 .. W !," SYSTEM=",SYSTEM
 .. W !,"SITE/SPECIMEN=",$P(SYSTEM,"^")
 .. W !,"Units=",Units
 .. W !,"LOINC ABB=",$P(SYSTEM,"^",2)
 .. W !,"LAB ABB=",$P(SYSTEM,"^",3)
 .. S:$L($P(SYSTEM,"^",3)) LABABB($P(SYSTEM,"^",3))=""
 .. W !,"TYPE 'S=SPECIMEN'=",$P(SYSTEM,"^",7)
 .. W !," ZERO NODE 95.3=",LabLoinc0node,!,!
 ..;
 .. S ^KBAP("LABARR",F60IEN,"95.3",LabAccessionArea,$P(SYSTEM,"^"),LabLoincIEN,LabLoincFull,F60NAME,LabLoincIEN)=Units
 Q
 ;
NEWTIU ; TEST BUILDING TIU AND ENTERING TEXT
 K filter
 S filter("DUZ")=71
 S filter("studyid")="XXX00812"
 S filter("clinicien")=7
 s filter("form")="siform-2018-05-18"
 s tiutitlepn=$$GET^XPAR("SYS","SAMI NOTE TITLE PRINT NAME",,"Q")
 s tiutitleien=$O(^TIU(8925.1,"D",tiutitlepn,0))
 s provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 s clinien=$$GET^XPAR("SYS","SAMI DEFAULT CLINIC IEN",,"Q")
 s root=$$setroot^%wd("vapals-patients")
 s samikey=$g(filter("form"))
 s si=$g(filter("studyid"))
 s vals=$na(@root@("graph",si,samikey))
 s ptdfn=@vals@("dfn")
 s dest=$na(@vals@("note"))
 s tiuien=+$$BLDTIU^SAMIVSTA(ptdfn,tiutitleien,provduz,clinien)
 Q:'tiuien tiuien
 Q $$SETTEXT^SAMIVSTA(tiuien,dest)
 ;
 ; Format of data in Loinc.cvs from loinc.org
 ;1 LOINC_NUM
 ;2 COMPONENT
 ;3 PROPERTY
 ;4 TIME_ASPCT
 ;5 SYSTEM
 ;6 SCALE_TYP
 ;7 METHOD_TYP
 ;8 CLASS
 ;9 VersionLastChanged
 ;10 CHNG_TYPE
 ;11 DefinitionDescription
 ;12 STATUS
 ;13 CONSUMER_NAME
 ;14 CLASSTYPE
 ;15 FORMULA
 ;16 SPECIES
 ;17 EXMPL_ANSWERS
 ;18 SURVEY_QUEST_TEXT
 ;19 SURVEY_QUEST_SRC
 ;20 UNITSREQUIRED
 ;21 SUBMITTED_UNITS
 ;22 RELATEDNAMES2
 ;23 SHORTNAME
 ;24 ORDER_OBS
 ;25 CDISC_COMMON_TESTS
 ;26 HL7_FIELD_SUBFIELD_ID
 ;27 EXTERNAL_COPYRIGHT_NOTICE
 ;28 EXAMPLE_UNITS
 ;29 LONG_COMMON_NAME
 ;30 UnitsAndRange
 ;31 DOCUMENT_SECTION
 ;32 EXAMPLE_UCUM_UNITS
 ;33 EXAMPLE_SI_UCUM_UNITS
 ;34 STATUS_REASON
 ;35 STATUS_TEXT
 ;36 CHANGE_REASON_PUBLIC
 ;37 COMMON_TEST_RANK
 ;38 COMMON_ORDER_RANK
 ;39 COMMON_SI_TEST_RANK
 ;40 HL7_ATTACHMENT_STRUCTURE
 ;41 EXTERNAL_COPYRIGHT_LINK
 ;42 PanelType
 ;43 AskAtOrderEntry
 ;44 AssociatedObservations
 ;45 VersionFirstReleased
 ;46 ValidHL7AttachmentRequest
 ;
EN D OPEN^ZISHGTM(1,"/home/osehra/tmp/","Loinc.csv","R")
 N ISACT,STR,LIMIT,CNT,CMPNT,PRPRTY,SYSTM,CLASS
 N SHRTNM
 S (CNT,LIMIT)=0,STR=""
 K LOINCA
 U IO
 F  R X#1 D  Q:LIMIT>87800
 . S STR=STR_X
 . I X[$C(13) D
 .. S STR=$TR(STR,"""")
 .. S CNT=CNT+1
 .. S LOINC=$P(STR,",",1)
 .. S CMPNT=$P(STR,",",2)
 .. S PRPRTY=$P(STR,",",3)
 .. S SYSTM=$P(STR,",",5)
 .. S CLASS=$P(STR,",",8)
 .. S DESC=$P(STR,",",11)
 .. S ISACT=$P(STR,",",12)
 .. S EXMPUNTS=$P(STR,",",28)
 .. S STR=""
 .. S SHRTNM=$P(STR,",",23)
 .. I ISACT["ACTIVE" D
 ... S LOINCA(CNT)=LOINC_"^"_CMPNT_"^"_PRPRTY_"^"_SYSTM_"^"_CLASS_"^"_SHRTNM_"^"_ISACT_"^"_EXMPUNTS_"^"_DESC_"^"
 .. S LIMIT=LIMIT+1
 ;
 ;D ^ZTER
 D CLOSE^ZISHGTM(1)
 Q
 ;
BLDGS(LOINCA) ;
 n root,gien,NODE,SNODE,STR,name,loinc
 d purgegraph^%wd("loinc org data")
 s root=$$setroot^%wd("loinc org data")
 s gien=0
 S NODE=$NA(LOINCA),SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . S STR=@NODE
 . s loinc=$P(STR,"^")
 . s name=$P(STR,"^",2)
 . s gien=gien+1
 . S @root@(gien,"loinc")=$P(STR,"^")
 . S @root@(gien,"test name")=name
 . S @root@(gien,"property")=$P(STR,"^",3)
 . S @root@(gien,"site/specimen")=$P(STR,"^",4)
 . S @root@(gien,"accession area")=$P(STR,"^",5)
 . S @root@(gien,"example units")=$P(STR,"^",8)
 . S @root@(gien,"description")=$P(STR,"^",9)
 . S:'(name="") @root@("name",$$UP^XLFSTR(name),gien)=""
 . S:'(loinc="") @root@("loinc",loinc,gien)=""
 ;
 Q
 ;
ALLLAB(NMMTCH,SITESPEC,ACCAREA) ;
 S NMMTCH=+$G(NMMTCH)
 S SITESPEC=$G(SITESPEC)
 S ACCAREA=$G(ACCAREA)
 N CNT S CNT=0
 F  S CNT=$O(^LAB(60,CNT)) Q:'CNT  D
 . S NAME=$P(^LAB(60,CNT,0),"^")
 . D FNDENT(.XDATA,.LOINCA,NAME,SITESPEC,ACCAREA,NMMTCH)
 . I $D(XDATA) D
 ..  W !!,"**************** ",NAME
 ..  N NODE,SNODE S NODE=$NA(XDATA),SNODE=$P(NODE,"(")
 ..  F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 ...  W !,NODE,"=",@NODE
 .. W !,!
 Q
 ;
 ; Array of entries in LOINCA array
FNDENT(XDATA,LOINCA,NAME,SITESPEC,ACCAREA,NMMTCH) ;
 K XDATA
 Q:'$D(LOINCA)  Q:'$L(NAME)
 S ACCAREA=$G(ACCAREA)
 S NMMTCH=+$G(NMMTCH)
 S NAME=$$UP^XLFSTR(NAME)
 S SITESPEC=$$UP^XLFSTR(SITESPEC)
 S ACCAREA=$$UP^XLFSTR(ACCAREA)
 N CNT S CNT=0
 F  S CNT=$O(LOINCA(CNT)) Q:'CNT  D
 . I NMMTCH,'($$UP^XLFSTR($P(LOINCA(CNT),"^",2))=NAME) Q
 . Q:'($$UP^XLFSTR($P(LOINCA(CNT),"^",2))[NAME)
 . Q:'($$UP^XLFSTR($P(LOINCA(CNT),"^",4))[SITESPEC)
 . Q:'($$UP^XLFSTR($P(LOINCA(CNT),"^",5))[ACCAREA)
 . S XDATA=$G(XDATA)+1
 . S XDATA(XDATA)=LOINCA(CNT)
 Q
 ;
 ; get loinc code and test name from loinc-code-map
 ;  and find that loinc code in loinc org data
MTCHLNC ;
 N rootlcm,rootlod,lcmtest,lodtest,lcmien,F60IEN
 N CNT,lcmlnc,lcmgien,lodgien,EXMPUNTS
 N F60NAME,LCMGIEN,LCMLNC,LODGIEN,ACCAREA,SITESP
 s rootlod=$$setroot^%wd("loinc org data")
 s rootlcm=$$setroot^%wd("loinc-code-map")
 ; run down each entry in loinc-code-map
 ;  pull test name,loinc,lcmien,f60ien
 ;  AND PULL synonyms (e.g. ERYTHROCYTES for RBC)
 K ^KBAP("LABARR")
 S F60IEN=0
 F  S F60IEN=$O(^LAB(60,F60IEN)) Q:'F60IEN  D
 . S F60NAME=$$UP^XLFSTR($P($G(^LAB(60,F60IEN,0)),"^"))
 . D GETLCM(F60NAME)
 . D GETLOD(F60NAME)
 . D GETLCM("MYELOCYTES")
 . D GETLOD("MYELOCYTES")
 Q
 ;
GETLCM(F60NAME) 
 ; Data from "loinc-code-map"
 S LCMGIEN=$O(@rootlcm@("graph","map","pos","NAME",F60NAME,0))
 Q:'LCMGIEN
 S LCMLNC=$G(@rootlcm@("graph","map",LCMGIEN,"LOINC"))
 Q:'$L(LCMLNC)
 ; Data from "loinc org data" for this loinc entry
 S LODGIEN=$O(@rootlod@("loinc",LCMLNC,0))
 Q:'LODGIEN
 S ACCAREA=$G(@rootlod@(LODGIEN,"accession area"))
 S SITESP=$G(@rootlod@(LODGIEN,"site/specimen"))
 S EXMPUNTS=$G(@rootlod@(LODGIEN,"example units"))
 Q:'$L(ACCAREA)  Q:'$L(SITESP)
 S ^KBAP("LABARR",F60IEN,"lnc",ACCAREA,SITESP,$P(LCMLNC,"-"),LCMLNC,F60NAME,LODGIEN)=EXMPUNTS
 Q
 ;
 ; Now go down all the names in rootlod
 ;
GETLOD(F60NAME) ;
 S F60NAME=$$UP^XLFSTR($P($G(^LAB(60,F60IEN,0)),"^"))
 S LODGIEN=0
 F  S LODGIEN=$O(@rootlod@("name",F60NAME,LODGIEN)) Q:'LODGIEN  D
 . S ACCAREA=$G(@rootlod@(LODGIEN,"accession area"))
 . S SITESP=$G(@rootlod@(LODGIEN,"site/specimen"))
 . S EXMPUNTS=$G(@rootlod@(LODGIEN,"example units"))
 . S LODLNC=$G(@rootlod@(LODGIEN,"loinc"))
 . Q:'$L(ACCAREA)  Q:'$L(SITESP)  Q:'$L(LODLNC)
 .; Limit entries to those with certain accession areas
 . Q:"^CHEM^SERO^UA^DRUG/TOX^MICRO^"'[ACCAREA
 . S ^KBAP("LABARR",F60IEN,"lod",ACCAREA,SITESP,$P(LODLNC,"-"),LODLNC,F60NAME,LODGIEN)=EXMPUNTS
 Q
 ;
 ; Run down ^KBAP("LABARR") and get
 ;   lab60ien
 ;   get accession area
 ;   site/specimen
 ;      find 61 IEN for that site specimen
 ;   get loinc code (first piece of "-"
 ;   if this lab does not have this accession area
 ;      update lab with new accession area
 ;   update lab test with
 ;      new? site specimen
 ;      loinc
 ;
 ; Parse out REQ from HF call
 ; e.g. 
 ;REQ(583)="647059^LCS YEARS SMOKED999001^LCS-ENROLLED36^LEGAL COMPLICATIONS"
 ; take each ^piece
 ;   is it all numeric ?
 ;     yes - save it as first piece of IEN;text string
 ;     no - pull all numerics from the end of the string
 ;          save text piece as text for IEN;text string
 ;          
BLDPOO N CNT S CNT=0
 F  S CNT=$O(REQ(CNT)) Q:'CNT  D
 . N NBRF S NBRF=$P(REQ(CNT),"^")
 . N J F J=1:1:$L(REQ(CNT),"^") D
 .. S ANSTR=$P(REQ(CNT),"^",J)
 .. D SPLTAFN(.ANSTR,.STR,.NBR)
 .. I $L(STR)=0,NBR S NBRF=NBR Q
 .. I NBRF,$L(STR) D
 .. S POO(0)=$G(POO(0))+1
 .. S POO(POO(0))=NBRF_"^"_STR
 .. S NBRF=NBR
 Q
SPLTAFN(ANSTR,STR,NBR) ; Split alpha from terminal numeric
 K STR,NBR S (STR,NBR)=""
 N I,DONE S DONE=0
 F I=$L(ANSTR):-1:1 D  Q:DONE
 . I $E(ANSTR,I)?1N S NBR=$E(ANSTR,I,I)_$G(NBR)
 . I $E(ANSTR,I)?1A S STR=$E(ANSTR,1,$L(ANSTR)-$L(NBR)),DONE=1
 Q
 ;
 ; Find accession areas and site specimens
ACCSS ;
 N NODE,SNODE
 S NODE=$NA(^KBAP("LABARR")),SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . N ACCAREA,SITESPEC
 . S ACCAREA=$QS(NODE,4)
 . S SITESPEC=$QS(NODE,5)
 . S POOACC(ACCAREA)=$G(POOACC(ACCAREA))+1
 . S POOSS(SITESPEC)=$G(POOSS(SITESPEC))+1
 Q
 ;CHEM,COAG,DRUG/TOX,HEM/BC,MICRO,CYTO,PATH,PULM,SERO,UA
 ;"Amniotic fluid"
 ;"Anus"
 ;"BLD/TISS"
 ;"BLD/URINE"
EOR ; End of routine KBAPTMP
