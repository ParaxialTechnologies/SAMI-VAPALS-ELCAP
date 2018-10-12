SYNLINIT ; ven/lgc - Initialize Lab in a new VistA instance ; 10/12/18 1:58pm
 ;;;1.0;;;AUG 6, 2018
 ;
 ;
 Q ; Not from top
 ;
 ;
EN ; Get institution
 N IEN4
 S IEN4=$$GETINST
 I '$G(IEN4) D  Q
 . W !,!,"*** You must select an institution to continue.",!,!
 W !,"Continue using institution "_$G(^DIC(4,IEN4,0))
 S %=2 D YN^DICN
 Q:'(%=1)
 ;
 ; Make sure each accession area has an Identity
 D SetAccessionIDs
 ;
 ; Read csv file and build LOINCA array
 ;D READCSV(fileloc)
 ;
 ; Build the LOINCA array
 ;N LOINCA S LOINCA="" D BLDGS(.LOINCA)
 ;
 ; Build ^KBAP("LABARR" global
 D BLDKBAP
 ;
 ; Build TMPARR for each test in file 60
 ; Run through TMPARR and update test
 ;   for accession area, institution
 ;   for site/specimen, LOINC, UNITS
 D UPDTLAB
 ; Make sure rollover running
 D SchedRollover
 ; Run rollover manually now
 W !,!," *** Running Lab Rollover manually now.",!
 D ^LROLOVER
 Q
 ;
GETINST() ;
 N DIC,CNT,IEN60,NAME,INST,LRAC
 S DIC("A")="Select an institution to assign to the lab tests : "
 S DIC="^DIC(4,",DIC(0)="QEAL" D ^DIC
 I (Y=-1) D  Q 0
 . W !,"*** Sorry.  Cannot continue ***"
 . W !,"*** An institution must be selected. ***"
 Q:'($L($G(Y),"^")=2) 0
 W !,!,"All tests will be accessioned into the "
 W !,Y
 W !,"Institution",!,!
 Q +$G(Y)
 ;
 ;
 ;
 ; Note:
 ; Format of data in Loinc.cvs from loinc.org - SEE BELOW
 ;
 ; Read Loinc.csv
 ; Enter
 ;    FILELOC  = location of file on system
 ; Return
 ;    LOINCA array - piece - description
 ;                   1       LOINC   [14106-9]
 ;                   2       Test name [Lymphocytes]
 ;                   3       Property [NCnc]
 ;                   4       Site/Specimen [CSF]
 ;                   5       Accession Area [HEM/BC]
 ;                   6       Short name
 ;                   7       Is Active [ACTIVE]
 ;                   8       Example units [10*3/uL]
 ;                   9       Description
READCSV(FILELOC) ;
 I $G(FILELOC)="" W !,"Call with file location",!,!  Q
 ;D OPEN^ZISHGTM(1,"/home/osehra/tmp/","Loinc.csv","R")
 D OPEN^ZISHGTM(1,FILELOC,"Loinc.csv","R")
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
 D CLOSE^ZISHGTM(1)
 Q
 ;
 ;
 ; Use the LOINCA array to build the
 ;   "loinc org data" Graphstore
 ; *** WARNING *** over 87,000 nodes may be
 ;   added to journal with purge of existing file
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
 ;
 ; Build ^KBAP("LABARR" file
 ;  e.g.
 ; KBAP("LABARR",143,"lnc","UA","Urine",5811,"5811-5","SPECIFIC GRAVITY",47921)
 ; ^KBAP("LABARR",143,"lod","CHEM","Amnio fld",14345,"14345-3","SPECIFIC GRAVITY,4215)
 ; ...
 ; ^KBAP("LABARR",143,"lod","CHEM","Urine",2965,"2965-2","SPECIFIC GRAVITY",19256)
 ; ...
 ;
 ; Build a global ^KBAP("LABARR") by running through all
 ;  names and synonyms in file 60 and finding entries
 ;  in the "loinc-code-map" and "loinc org data"
 ;  Graphstores.  The ^KBAP("LABARR") global should
 ;  be helpful in automating the updating of the
 ;  test entries in file 60 with accession area,
 ;  site/specimen, loinc, and, perhaps, unit information
 ; ^KBAP("LABARR",x1,x2,x3,x4,x5,x6,x7,x8)=units
 ;    subscript   Description
 ;    x1          IEN of test in file 60
 ;    x2          'inc' info from 'loinc-code-map'
 ;                'lod' info from 'loinc org data'
 ;                '95.3' info from LAB LOINC file
 ;                NOTE: to give preference to loinc-code-map data
 ;    x3          Accession Area
 ;    x4          Site/Specimen
 ;    x5          LOINC integer
 ;    x6          LOINC with checksum digit
 ;    x7          Test n
 ;    x8          'loinc org data' gien
BLDKBAP ;
 N rootlcm,rootlod,lcmtest,lodtest,lcmien,F60IEN
 N CNT,lcmlnc,lcmgien,lodgien,EXMPUNTS
 N F60NAME,LCMGIEN,LCMLNC,LODGIEN,ACCAREA,SITESP,F60SYN
 N PRPRTY
 s rootlod=$$setroot^%wd("loinc org data")
 s rootlcm=$$setroot^%wd("loinc-code-map")
 ;
 ; 1) run down each entry in file 60 pulling each test name
 ;    then look up this name in in 'loinc-code-map'
 ; 2) run down each entry in file 60 SYNONYMS on each test
 ;    then look up this name in 'loinc-code-map'
 ; With each step, build the ^KBAP("LABARR" global for use
 ;   later in building/editing lab tests in file 60
 ;   [UPDTLAB]
 ;
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
GETLCM(F60IEN,F60NAME) ; Data from "loinc-code-map"
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
 S PRPRTY=$G(@rootlod@(LODGIEN,"property"))
 S:PRPRTY="" PRPRTY="UNK"
 Q:'$L(ACCAREA)  Q:'$L(SITESP)
 S ^KBAP("LABARR",F60IEN,"lnc",ACCAREA,SITESP,$P(LCMLNC,"-"),LCMLNC,F60NAME,LODGIEN,PRPRTY)=EXMPUNTS
 Q
 ;
 ;
GETLOD(F60IEN,F60NAME) ; Data from "loinc org data"
 S LODGIEN=0
 F  S LODGIEN=$O(@rootlod@("name",F60NAME,LODGIEN)) Q:'LODGIEN  D
 . S ACCAREA=$G(@rootlod@(LODGIEN,"accession area"))
 . S SITESP=$G(@rootlod@(LODGIEN,"site/specimen"))
 . S EXMPUNTS=$G(@rootlod@(LODGIEN,"example units"))
 . S PRPRTY=$G(@rootlod@(LODGIEN,"property"))
 . S:PRPRTY="" PRPRTY="UNK"
 . S LODLNC=$G(@rootlod@(LODGIEN,"loinc"))
 . Q:'$L(ACCAREA)  Q:'$L(SITESP)  Q:'$L(LODLNC)
 .; Limit entries to those with certain accession areas
 . Q:"^CHEM^SERO^UA^DRUG/TOX^MICRO^HEM/BC"'[ACCAREA
 . S ^KBAP("LABARR",F60IEN,"lod ",ACCAREA,SITESP,$P(LODLNC,"-"),LODLNC,F60NAME,LODGIEN,PRPRTY)=EXMPUNTS
 Q
 ;
 ; Find entries in 95.3 that match for this test in file 60
 ;Entry
 ;   F60IEN   = IEN of lab test in file 60
 ;   F60NAME  = name of lab test in file 60
 ;Return
 ;   ^KBAP("LABARR",F60IEN,"95.3",ACCAREA,SITESP,$P(LODLNC,"-"),LODLNC,F60NAME,LODGIEN,PRPRTY)=EXMPUNTS
 ;
GET953(F60IEN,F60NAME) ; Data from LAB LOINC [95.3]
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
 . I ((LabLoincCmptName=F60NAME)!($E(LabLoincShortName,1,$L(F60NAME))=F60NAME)) D
 .. S ^KBAP("LABARR",F60IEN,"95.3",LabAccessionArea,$P(SYSTEM,"^"),LabLoincIEN,LabLoincFull,F60NAME,LabLoincIEN)=Units
 Q
 ;
UPDTLAB ;
 ; Run down ^KBAP("LABARR") and get
 ;   lab60ien
 N TMPARR,IEN60,IEN61,IEN68,ACCAREA,SPECIMEN,SPECIEN,TSTNAME
 N PRPRTY
 S IEN60=0
 F  S IEN60=$O(^LAB(60,IEN60)) Q:'IEN60  D
 . K TMPARR
 . M TMPARR(IEN60)=^KBAP("LABARR",IEN60)
 .; Now update this test with
 . D UPDTTST(.TMPARR)
 Q
 ;
 ; Use passed array to
 ;   Add a new ACCESSION area if one
 ;     doesn't exist
 ;   Update LOINC if site/specimen already exists
 ;   Add new site/specimen and LOINC
UPDTTST(TMPARR) ;
 ; Run down each entry in the array
 N NODE,SNODES,LOINC,TSTNAME,ACCAREA,PRPRTY,UNITS
 N SiteSpecimens
 N IEN60,IEN68,SPECIMEN,IEN61,AAEXIST,SPEXIST,LNCXIST
 S NODE=$NA(TMPARR),SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 .;  Get the VistA accession area [IEN68] that
 .;     corresponds to that in this array entry
 . W !,!,NODE
 . S IEN60=$QS(NODE,1) Q:'IEN60
 . S LOINC=$QS(NODE,5)
 . S TSTNAME=$QS(NODE,7)
 . S ACCAREA=$QS(NODE,3)
 . S PRPRTY=$QS(NODE,9)
 . S UNITS=@NODE
 . S IEN68=$$FDNAANMB(ACCAREA)
 . S SPECIMEN=$QS(NODE,4) ; e.g. Synv fld; Ser/Plas
 .; Remember SPECIMEN may represent a multiple
 .;  such as 70;71
 . S SiteSpecimens=$$FNDSSNBR(SPECIMEN)
 .;
 .; If we have an accession area and one or more site/specimens
 .;   update the test if necessary
 .;
 . I IEN68>0,SiteSpecimens>0 D
 ..;
 ..; Does the test alrady have this accession
 ..;   area under the selected institution?
 ..; If so just bail
 .. S AAEXIST=$$HAVEAA(IEN60,IEN4,IEN68)
 .. I '$G(AAEXIST) D
 ...; Assign the institution and accession area
 ...;  to this test
 ... S SUCCESS=$$ADDAA(IEN60,IEN4,IEN68)
 ..;
 ..; Does the test already have this specimen
 ..;  and the associated LOINC?
 .. N NumberSpecimens S NumberSpecimens=$L(SiteSpecimens,";")
 .. N I F I=1:1:NumberSpecimens S IEN61=$P(SiteSpecimens,";",I) D
 ... S SPEXIST=$D(^LAB(60,IEN60,1,IEN61))
 ... I SPEXIST S LNCXIST=$D(^LAB(60,IEN60,1,IEN61,95.3))
 ... I SPEXIST,LNCXIST Q
 ... S SUCCESS=$$ADDSLNC(IEN60,IEN61,LOINC,UNITS)
 Q
 ;
 ; Check if this test in file 60 already has assigned
 ;   the indicate institution and accession area
HAVEAA(IEN60,IEN4,IEN68) ;
 N I S (RSLT,I)=0
 F  S I=$O(^LAB(60,IEN60,8,I)) Q:'I  D
 . Q:'($P($G(^LAB(60,IEN60,8,I,0)),"^")=IEN4)
 . Q:'($P($G(^LAB(60,IEN60,8,I,0)),"^",2)=IEN68)
 . S RSLT=1
 Q RSLT
 ;
 ; Look up VistA accession area IEN into file 68
 ;   by accession area string found in Loinc.cst
FDNAANMB(ACCAREA) ;
 N ACC,IEN68
 S (IEN68,CNT)=0
 F  S CNT=CNT+1,ACC=$T(ACCAREA+CNT) Q:(ACC="")  D
 . I ACC[ACCAREA S IEN68=$P($T(ACCAREA+CNT),"^",2)
 Q IEN68
 ;
 ;
 ;
ACCAREA ;;
 ;;CHEM^11
 ;;COAG^3
 ;;DRUG/TOX^20
 ;;HEM/BC^10
 ;;MICRO^12
 ;;SERO^17
 ;;RIA^6
 ;;UA^7
 ;;GAS^9
 ;;PULM^6
 ;;PANEL.CHEM^11
 ;;PANEL.COAG^3
 ;;PANEL.HEM/BC^10
 ;;PANEL.MICRO^12
 ;;PANEL.DRUG/TOX^20
 ;;SPEC^11
 ;;ABXBACT^12
 ;;ALLERGY^11
 ;;CHAL^11
 ;;DRUGDOSE^20
 ;;IO_IN_SALTS+CALS^11
 ;;
 ;
 ; Look up VistA site specimen (topography) IEN into
 ;   file 61 by specimen string
FNDSSNBR(SPECIMEN) ;
 N SPEC,IEN61
 S (IEN61,CNT)=0
 F  S CNT=CNT+1,SPEC=$T(SITESPEC+CNT) Q:(SPEC="")  D
 . S SPEC=$P($P(SPEC,";;",2),"^")
 . I $$UP^XLFSTR(SPEC)=$$UP^XLFSTR(SPECIMEN) D
 .. S IEN61=$P($T(SITESPEC+CNT),"^",2)
 Q IEN61
 ;
SITESPEC ;;
 ;;Anal^8353
 ;;Amnio fld^6266
 ;;Bil fld^1006
 ;;Bld^70
 ;;Bld.dot^70
 ;;Bld/Urine^70;71
 ;;BldCo^70
 ;;Body fld^72
 ;;Bone mar^319
 ;;Bone marrow^319
 ;;Bone^322
 ;;Brain^151
 ;;Bronchial^3534
 ;;CSF^74
 ;;Cvx^83
 ;;Dentin^4835
 ;;Dial fld^76
 ;;Gast fld^5482
 ;;Genital^5528
 ;;Hair^201
 ;;Liver^56
 ;;Lymph node^213
 ;;Lymph node.FNA^213
 ;;Meconium^6271
 ;;Milk^1054
 ;;Nail^203
 ;;Ocular fld^7740
 ;;Pericard fld^91
 ;;Periton fld^76
 ;;Plas^73
 ;;Plr fld^77
 ;;Saliva^134
 ;;Semen^5864
 ;;Ser^72
 ;;Ser/Plas^72;73
 ;;Ser/Plas/Bld^72;73;70
 ;;Ser/Plas/Urine^72;73;71
 ;;Skin^315
 ;;Stool^138
 ;;Sweat^1047
 ;;Synv fld^78
 ;;Tear^7972
 ;;Tiss^8729
 ;;Tiss.FNA^8729
 ;;Unk sub^999
 ;;Urethra^75
 ;;Urine^71
 ;;Urine sed^71
 ;;Urine+Ser/Plas^72;73;71
 ;;Vag^237
 ;;Vitr fld^7740
 ;;
 ;
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
 ; Information available in  Loinc.cvs
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
 ;
 ;
 ; Add institution and accession area to lab test
 ; e.g. IEN60=174,IEN4=2957,IEN68=11
 ; If the insititution entry doesn't exist
 ;   enter it.  If the institution does exist
 ;   but not under the correct accession area
 ;   update this piece.
ADDAA(IEN60,IEN4,IEN68) ;
 N DIERR,FDA,FDAIEN
 S IENS="?+1,"_IEN60_","
 S FDAIEN(1)=IEN4
 S FDA(3,60.11,IENS,.01)=IEN4
 S FDA(3,60.11,IENS,1)=IEN68
 D UPDATE^DIE("","FDA(3)","FDAIEN")
 Q '$D(DIERR)
 ;
 ; Add site/specimen and LOINC to a test
 ; e.g. IEN60=174,IEN61=73,LOINC=3094
 ; If the site/specimen entry doesn't exist
 ;   enter it.  If the site/specimen does exist
 ;   but does not have LOINC, update LOINC
ADDSLNC(IEN60,IEN61,LOINC,UNITS) ;
 N DIERR,FDA,FDAIEN
 S IENS="?+1,"_IEN60_","
 S FDAIEN(1)=IEN61
 S FDA(3,60.01,IENS,.01)=IEN61
 I $G(LOINC) D
 . S FDA(3,60.01,IENS,95.3)=+$G(LOINC)
 I $L($G(UNITS)) D
 . S FDA(3,60.01,IENS,6)=UNITS
 D UPDATE^DIE("","FDA(3)","FDAIEN")
 Q '$D(DIERR)
 ;
 ;
 ; Make sure each accession area has a NUMERICAL IDENTIFIER
 ;  NOTE: Despite the name of the field suggesting a numerical
 ;        entry, the identifier may contain alpha characters.
 ;        However, if an identifier has not been previously
 ;        defined, we will set it to the IEN of the accession
 ;        area in file 68.
SetAccessionIDs ;
 N IEN68 S IEN68=0
 F  S IEN68=$O(^LRO(68,IEN68)) Q:'$G(IEN68)  D
 . Q:$L($G(^LRO(68,IEN68,.4)))
 . N DIERR,FDA,FDAIEN,IENS
 . S IENS=IEN68_","
 . S FDA(3,68,IENS,.4)=IEN68
 . D UPDATE^DIE("","FDA(3)")
 Q
 ;
 ; Schedule lab rollover task
SchedRollover ;
 N IEN19,IEN192,NODE1920,FDA,DIERR,FDAIEN,LROVDT
 ; See if already in 19.2 and scheduled correctly
 N IEN19 S IEN19=$O(^DIC(19,"B","LRTASK ROLLOVER",0))
 I '+$G(IEN19) D  Q
 . W !,!,"*** ERROR.  LRTASK ROLLOVER not in OPTION file.",!
 S LROVDT=$P($$FMADD^XLFDT($$HTFM^XLFDT($H),1),".")_"."_"0005"
 ;
 S FDA(3,19.2,"?+1,",.01)=IEN19
 S FDA(3,19.2,"?+1,",2)=LROVDT
 S FDA(3,19.2,"?+1,",6)="1D"
 D UPDATE^DIE("","FDA(3)")
 ;
 I '$D(DIERR) D  Q
 . W !,!," *** LRTASK ROLLOVER scheduled for ",LROVDT," Daily.",!
 W !,!," *** Tasking LRTASK ROLLOVER failed.  Schedule manually.",!
 Q
 ; ==================== Developer tools ================
 ;
 ; Build arrays of all accession areas and all 
 ;  site/specimens saved in ^KBAP("LABARR" global
FindAccAreaAndSiteSpec ;
 N NODE,SNODE
 S NODE=$NA(^KBAP("LABARR")),SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . S POOACC($QS(NODE,4))=$G(POOACC($QS(NODE,4)))+1
 . S POOSS($QS(NODE,5))=$G(POOSS($QS(NODE,5)))+1
 Q
 ;
ShowAccAreaSiteSpec(AccArea,SiteSpecimen) ;
 N NODE,SNODE,T60IEN,T60NAME
 S NODE=$NA(^KBAP("LABARR")),SNODE=$P(NODE,")")
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . I $L($G(AccArea))>0,$QS(NODE,4)=AccArea D
 .. W !,NODE,"=",@NODE
 .. S T60IEN=$QS(NODE,2),T60NAME=$P($G(^LAB(60,T60IEN,0)),"^")
 .. W !,T60IEN," ",T60NAME
 . I $L($G(SiteSpecimen))>0,$QS(NODE,5)=SiteSpecimen D
 .. W !,NODE,"=",@NODE
 .. S T60IEN=$QS(NODE,2),T60NAME=$P($G(^LAB(60,T60IEN,0)),"^")
 .. W !,T60IEN," ",T60NAME
 Q
DispTestWithLOINC ;
 N NODE,SNODE,DONE,TOT953
 S NODE=$NA(^LAB(60)),SNODE=$P(NODE,")")
 S DONE=0
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D  Q:DONE
 . I $QS(NODE,2)?.A S DONE=1 Q
 . I $QS(NODE,3)=0 W !,NODE,"=",@NODE
 . I $QS(NODE,5)["95.3" D
 .. W !," ----- ",NODE,"=",@NODE
 .. S TOT953=$G(TOT953)+1
 W !,"Total site/specimen entries with LOINC :",TOT953
 Q
 ;
EOR ;End of routine SYNLINIT
