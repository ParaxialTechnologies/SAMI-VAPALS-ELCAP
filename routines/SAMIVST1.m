SAMIVST1 ;;ven/lgc - M2Broker calls for VA-PALS - New TIU ;Jan 16, 2020@08:47
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; not from top
 ;
 ;@called-by
 ;  SV2VISTA^SAMIVSTA
 ;@calls
 ;  TASKIT^SAMIVST1
 ;@input
 ;  filter("studyid")  = VA-PALS study ID e.g. XXX00812
 ;  filter("form")    = "siform-" + date e.g. siform-2018-05-18
 ;@output
 ;  if successful sets tiuien in @vals@("tiuien") node 
 ;   in Graphstore
 ;  if called as extrinsic function, returns tiu ien
 ;@tests
 ;  UTTASK^SAMIUTVA
SV2VISTA ;
 if '$Q do  quit
 . new ZTSAVE,ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTSK,X,Y
 . set ZTDESC="SAMIVSTA BUILDING NEW TIU NOTE"
 . set ZTDTH=$H
 . set ZTIO=""
 . set ZTSAVE("filter(")=""
 . set ZTRTN="TASKIT^SAMIVST1"
 . do ^%ZTLOAD
 ;
 ;
 ;@called-by
 ;  SV2VISTA^SAMIVSTA
 ;@calls
 ;  $$GET^XPAR
 ;  $$setroot^%wd
 ;@input
 ;@output
 ;@tests
 ; UTTASK^SAMIUTVA
 ;Setup all variables into Graphstore
TASKIT new samikey,vals,root,dest,provduz,ptdfn,tiutitlepn
 new tiutitleien,tiuien,X,Y,SAMIXD
 new clinien,si
 set tiuien=0
 ;
 ;
 set provduz=$get(filter("DUZ"))
 if 'provduz do
 . set provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 if '$get(provduz) quit:$Q 0  quit
 ;
 set clinien=$get(filter("clinicien"))
 if 'clinien do
 . set clinien=$$GET^XPAR("SYS","SAMI DEFAULT CLINIC IEN",,"Q")
 if '$get(clinien) quit:$Q 0  quit
 ;
 set tiutitlepn=$$GET^XPAR("SYS","SAMI NOTE TITLE PRINT NAME",,"Q")
 set tiutitleien=$order(^TIU(8925.1,"D",tiutitlepn,0))
 if '$get(tiutitleien) quit:$Q 0  quit
 ;
 set si=$get(filter("studyid")) ; e.g."XXX00001"
 if '$length($get(si)) quit:$Q 0  quit
 ;
 set root=$$setroot^%wd("vapals-patients")
 ; e.g. root = ^%wd(17.040801,23)
 ;
 set samikey=$get(filter("form"))
 if (samikey'["siform") quit:$Q 0  quit
 i '($length(samikey,"-")=4) quit:$Q 0  quit
 ; e.g. samikey="siform-2018-11-13"
 ;
 set vals=$name(@root@("graph",si,samikey))
 ; e.g. vals="^%wd(17.040801,23,""graph"",""XXX00001"",""siform-2018-11-13"")"
 ;
 set ptdfn=@vals@("dfn")
 if '$get(ptdfn) quit:$Q 0  quit
 ;
 set dest=$name(@vals@("notes"))
 ; e.g. dest="^%wd(17.040801,23,""graph"",""XXX00333"",""siform-2018-11-13"",""notes"")"
 ;
 ;
 ;@called-by
 ;  Falls into from TASKIT^SAMIVST1
 ;@calls
 ;  BLDTIU^SAMIVST1
 ;@input
 ;@output
 ;   tiuien = 0 : Building new tiu stubb failed
 ;   tiuien = n : IEN into file #8925 for new note stubb
 ;@tests
 ; Build the new tiu stubb.
NEWTIU d BLDTIU^SAMIVSTA(.tiuien,ptdfn,tiutitleien,provduz,clinien)
 ;
 merge ^KBAP("SAMIVST1","NEWTIU","tiuien")=tiuien
 if 'tiuien quit:$Q 0  quit
 ; For unit testing. Save new tiuien
 if $data(%ut) set ^TMP("UNIT TEST","UTTASK^SAMIUTVA")=tiuien
 ;
 ;
 ;@called-by
 ;  Falls into through TASKIT/NEWTIU
 ;@calls
 ;  SETTEXT^SAMIVST1
 ;@input
 ;@output
 ;@tests
 ; Set text in the note
NEWTXT d SETTEXT^SAMIVSTA(.tiuien,dest)
 set:(tiuien>0) @vals@("tiuien")=tiuien
 if '$get(tiuien) quit:$Q 0  quit
 ; 
 ;
 ;@called-by
 ;  ENCNTR^SAMIVSTA
 ;@calls
 ;  VISTSTR^SAMIVSTA
 ;  BLDENCTR^SAMIVSTA
 ;  $$KSAVE^SAMIVSTA
 ;@input
 ;   tiuien
 ;@output
 ;@tests
 ;   UTTASK^SAMIUTVA
 ; Update the encounter
ENCNTR new VSTR set VSTR=$$VISTSTR^SAMIVSTA(tiuien)
 quit:'($length(VSTR,";")=3) tiuien
 ; Time to build the HF array for the next call
 new SAMIHFARR
 set SAMIHFARR(1)="HDR^0^^"_VSTR
 set SAMIHFARR(2)="VST^DT^"_$P(VSTR,";",2)
 set SAMIHFARR(3)="VST^PT^"_ptdfn
 set SAMIHFARR(4)="VST^HL^"_$P(VSTR,";")
 set SAMIHFARR(5)="VST^VC^"_$P(VSTR,";",3)
 set SAMIHFARR(6)="PRV^"_provduz_"^^^"_$P($G(^VA(200,provduz,0)),"^")_"^1"
 set SAMIHFARR(7)="POV+^F17.210^COUNSELING AND SCREENING^Nicotine dependence, cigarettes, uncomplicated^1^^0^^^1"
 set SAMIHFARR(8)="COM^1^@"
 set SAMIHFARR(9)="HF+^999001^LUNG SCREENING HF^LCS-ENROLLED^@^^^^^2^"
 set SAMIHFARR(10)="COM^2^@"
 set SAMIHFARR(11)="CPT+^99203^NEW PATIENT^Intermediate Exam  26-35 Min^1^71^^^0^3^"
 set SAMIHFARR(12)="COM^3^@"
 do BLDENCTR^SAMIVSTA(.tiuien,.SAMIHFARR)
 if $get(tiuien),$get(provduz) do
 . new ASave set ASave=$$KASAVE^SAMIVSTA(provduz,tiuien)
 if $get(tiuien) quit:$Q 0  quit
 quit:$Q 0  quit
 ;
 ;
 ;@rpi - TIU CREATE RECORD
 ;@called-by
 ;  ENCNTR^SAMIVSTA
 ;@calls
 ;  $$HTFM^XLFDT($H)
 ;  M2M^SAMIM2M
 ;@input
 ;   tiuien  : variable by reference for tiuien
 ;   dfn     : IEN into PATIENT [#2] file
 ;   title   : TIU title IEN into TIU DOCUMENT DEFINITION [#8925.1]
 ;   user    : DUZ of user generating TIU document
 ;   clinien : IEN of clinic in HOSPITAL LOCATION [#44]
 ;@output
 ;   ien of new TIU note. 0=failure
 ;@tests
 ;   UTBLDTIU^SAMIUTVA
 ; Build a TIU and VISIT stubb
BLDTIU ;
 new cntxt,rmprc,console,cntopen,SAMIARR,SAMIXD
 kill tiuien set tiuien=0
 quit:'$get(dfn)
 quit:'$get(title)
 quit:'$get(user)
 quit:'$get(clinien)
 new vdt set vdt=$$HTFM^XLFDT($horolog) ; Visit date
 new vstr set vstr=clinien_";"_vdt_";A"
 new suppress set suppress=1
 new noasf set noasf=1
 set cntxt="OR CPRS GUI CHART"
 set rmprc="TIU CREATE RECORD"
 set (console,cntopen)=0
 ;
 set SAMIARR(1)=dfn
 set SAMIARR(2)=title
 set SAMIARR(3)=""
 set SAMIARR(4)=""
 set SAMIARR(5)=""
 ;
 new SAMIPOO
 set SAMIPOO(1202)=user
 set SAMIPOO(1301)=$$HTFM^XLFDT($H) ; REFERENCE DATE
 set SAMIPOO(1205)=clinien
 set SAMIPOO(1701)=""
 set SAMIARR(6)="@SAMIPOO"
 ;
 set SAMIARR(7)=vstr
 set SAMIARR(8)=suppress
 ;
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntopen,.SAMIARR)
 set tiuien=+$get(SAMIXD)
 merge ^KBAP("SAMIVST1","DEBUG3","SAMIXD")=SAMIXD
 quit
 ;
 ;
 ;@rpi - TIU SET DOCUMENT TEXT
 ;@called-by
 ;  $$SETTEXT^SAMIVSTA
 ;@calls
 ;  M2M^SAMIM2M
 ;@input
 ;   tiuien   = IEN of tiu note stubb in file #8925 by reference
 ;   dest     = indirection pointer to tiu note text
 ;                in the "VA-PALS patients" graph store
 ;@output
 ;   tiuien  = 0 if filing failed, the TIU IEN if successful
 ;@tests
 ;  UTSTEXT^SAMIUTVA
 ;Set text in existing tiu note stubb
SETTEXT ;
 kill ^KBAP("SAMIVST1","at SETTEXT")
 merge ^KBAP("SAMIVST1","at SETTEXT","tiuien")=tiuien
 merge ^KBAP("SAMIVST1","at SETTEX","dest")=dest
 ;
 set tiuien=+$get(tiuien)
 quit:'$get(tiuien)
 quit:'$data(dest)
 new snode set snode=$piece(dest,")")
 ;
 new cntxt,rmprc,console,cntnopen,SAMIARR,SAMIXD
 set cntxt="OR CPRS GUI CHART"
 set rmprc="TIU SET DOCUMENT TEXT"
 set (console,cntnopen)=0
 new suppress set suppress=0
 ;
 set SAMIARR(1)=tiuien
 ;
 new SAMIPOO,cnt,node,snode
 set SAMIPOO("HDR")="1^1"
 set node=dest,snode=$P(node,")")
 for  set node=$query(@node) quit:node'[snode  do
 . set cnt=$get(cnt)+1
 . set SAMIPOO("TEXT",cnt,0)=@node
 set SAMIARR(2)="@SAMIPOO"
 ;
 set SAMIARR(3)=suppress
 ;
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntnopen,.SAMIARR)
 ;
 ;@called-by
 ;  ENCNTR^SAMIVSTA
 ;@calls
 ;@input
 ;@output
 ;@tests
STXT1 set tiuien=+$get(SAMIXD)
 quit
 ;
 ;
 ;@rpi - ORWPCE SAVE
 ;@called-by
 ;  $$BLDENCTR^SAMIVSTA
 ;@calls
 ;  $$VISTSTR^SAMIVSTA
 ;@input
 ;   tiuien  = IEN of note in 8925
 ;   SAMIUHFA = array by reference of Health Factors e.g.
 ;@output
 ;   tiuien  = 0 failed to file encounter
 ;           = IEN of note in 8925 if successful
 ;@tests
 ;  UTENCTR^SAMIUTVA
 ; Add encounter information to a tiu note
BLDENCTR ;
 ;
 if '$get(tiuien) quit:$Q 0  quit
 if '$d(SAMIUHFA) quit:$Q 0  quit
 new VSTR set VSTR=$$VISTSTR^SAMIVSTA(tiuien)
 if '($length(VSTR,";")=3) quit:$Q 0  quit
 ;
 new suppress set suppress=0
 new cntxt,rmprc,console,cntnopen,SAMIARR
 set cntxt="OR CPRS GUI CHART"
 set rmprc="ORWPCE SAVE"
 set (console,cntnopen)=0
 ;
 ;@called-by
 ;@calls
 ;@input
 ;@output
 ;@tests
HFARRAY kill SAMIARR
 set SAMIARR(1)="@SAMIUHFA"
 ;
 ;@called-by
 ;@calls
 ;@input
 ;@output
 ;@tests
SPRS set SAMIARR(2)=suppress
 ;
 ;@called-by
 ;@calls
 ;  M2M^SAMIM2M
 ;@input
 ;@output
 ;@tests
ENCTR3 set SAMIARR(3)=VSTR
 ;
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntnopen,.SAMIARR)
 quit:$Q tiuien  quit
 ;
 ;
 ;
 ;@rpi - TIU UPDATE ADDITIONAL SIGNERS
 ;@called-by
 ;@calls
 ;  $$setroot^%wd
 ;@input
 ;@output
 ;@tests
 ; Additional Signers
 ; Enter
 ;  filter("studyid")  = VA-PALS study ID e.g. XXX00812
 ;  filter("form"))    = "siform-" + date e.g. siform-2018-05-18
 ;  filter("add signers")) = array of additional signers
 ;          e.g. filter("add signers",1)="72[^King,Matt]"
 ;          e.g. filter("add signers",2)="64[^Smith,Mary]"
 ; Exit
 ;  if successful sets tiuien in @vals@("add signers") node
 ;   in Graphstore
 ;  if called as extrinsic
 ;     0  = adding signer(s) failed
 ;     1  = adding signer(s) successful
ADDSGNRS ;
 if '$data(filter("add signers")) quit:$Q 0  quit
 ;
 ; Setup all variables into Graphstore
 new si,root,vals,tiuien
 ;
 set si=$get(filter("studyid")) ; e.g."XXX00001"
 quit:'$length($get(si))
 ;
 set root=$$setroot^%wd("vapals-patients")
 ; e.g. root = ^%wd(17.040801,23)
 ;
 set samikey=$get(filter("form"))
 if (samikey'["siform") quit:$Q 0  quit
 if '($length(samikey,"-")=4) quit:$Q 0  quit
 ; e.g. samikey="ceform-2018-10-21"
 ;
 set vals=$name(@root@("graph",si,samikey))
 ; e.g. vals=^%wd(17.040801,23,"graph","XXX00001","siform-2018-11-13")
 ;
 set tiuien=@vals@("tiuien")
 if '$get(tiuien) quit:$Q 0  quit
 ;
 ;
 ;@called-by
 ;@calls
 ;  $$KASAVE^SAMIVSTA
 ;@input
 ;@output
 ;@tests
 ;  UTADDNS^SAMIUTVA
ADDSIGN new cntxt,rmprc,console,cntnopen,SAMIARR,SAMIXD
 set (console,cntnopen)=0
 set cntxt="OR CPRS GUI CHART"
 set rmprc="TIU UPDATE ADDITIONAL SIGNERS"
 ;
 kill SAMIARR
 set SAMIARR(1)=tiuien
 ;
 new SAMIPOO
 merge SAMIPOO=filter("add signers")
 set SAMIARR(2)="@SAMIPOO"
 ;
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntnopen,.SAMIARR)
 ;
 ; Clear ASAVE nodes
 if $data(SAMIPOO) do
 . new cnt,ASave set cnt=0
 . for  set cnt=$O(SAMIPOO(cnt)) quit:'cnt  do
 .. set ASave=$$KASAVE^SAMIVSTA($piece(SAMIPOO(cnt),"^"),tiuien)
 ;
 ; If not UNIT TEST update Graphstore
 if +$get(SAMIXD),'$get(%ut) do  quit:$Q 1
 . new cnt set cnt=0
 . for  set cnt=$O(SAMIPOO(cnt)) quit:'cnt  do
 ..  set @vals@("add signers",cnt)=SAMIPOO(cnt)
 ;
 ; if doing UNIT TEST update utsuccess
 if $get(%ut),$data(utsuccess) do
 . set utsuccess=($get(SAMIXD)>0)
 quit
 ;
 ;
 ;
 ;@API-code: $$KSAVE^SAMIVSTA
 ;@called-by
 ;@calls
 ;@input
 ;   tiuien   = ien of note in 8925
 ;   provider = duz of provider
 ;@output
 ;   0 = failure, 1 = successful
 ;@tests
 ;  UTKASAVE^SAMIUTVA
 ; Clear the "ASAVE" cross reference to prevent CPRS
 ;  call to prevent TIU WAS THIS SAVED? broker call 
 ;  returning error message
KASAVE ;
 quit:'$get(tiuien) 0
 quit:'$get(provider) 0
 quit:'$data(^TIU(8925,tiuien)) 0
 kill ^TIU(8925,"ASAVE",provider,tiuien)
 quit 1
 ;
EOR ; End of routine SAMIVST1
