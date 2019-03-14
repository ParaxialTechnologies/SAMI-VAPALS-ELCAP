SAMIVST2 ;;ven/lgc - M2Broker calls for VA-PALS - PT INFO ; 3/13/19 7:38pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ;
 ;@rpi - TIU CREATE ADDENDUM RECORD
 ;@called-by
 ;@calls
 ;  $$HTFM^XLFDT
 ;  M2M^SAMIM2M
 ;@input
 ;   tiuaien   = variable by reference for new TIU
 ;               addendum IEN into 8925
 ;   tiuien    = IEN of note in 8925 to which we
 ;               wish to add an addendum
 ;   userduz   = DUZ [IEN into file 200] of the user
 ;               building the addendum
 ;@output
 ;  if called as extrinsic
 ;   0 = unsuccessful in adding addendum
 ;   n = ien of new addendum in 8925
 ;@tests
 ;   UTADDND^SAMIUTVA
 ; Build a tiu addendum
TIUADND ;
 ;
 if '$get(tiuien) quit:$Q 0  quit
 if '$get(userduz) quit:$Q 0  quit
 ;
 new cntxt,rmprc,console,cntnopen,SAMIARR,SAMIXD
 set (console,cntnopen)=0
 set cntxt="OR CPRS GUI CHART"
 set rmprc="TIU CREATE ADDENDUM RECORD"
 ;
 kill SAMIARR
 set SAMIARR(1)=tiuien
 ;
 new SAMIPOO
 set SAMIPOO(1202)=userduz
 set SAMIPOO(1301)=$$HTFM^XLFDT($horolog) ; REFERENCE DATE
 set SAMIARR(2)="@SAMIPOO"
 ;
 new noasf set noasf=1 ; Do not commit
 set SAMIARR(8)=noasf
 ;
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntnopen,.SAMIARR)
 ;
 if (+$get(SAMIXD)>0) quit:$Q +$get(SAMIXD)
 quit:$Q 0  quit
 ;
 ;
 ;@rpi - ORWPCE NOTEVSTR
 ;@called-by
 ;@calls
 ;  M2M^SAMIM2M
 ;@input
 ;   tiuien = IEN of TIU note in 8925
 ;@output
 ;   0 = failed to obtain VSTR for TIU
 ;   else VSTR string
 ;@tests
 ;  UTVSTR^SAMIUTVA
 ;  UTENCTR^SAMIUTVA
VISTSTR ;
 if '$get(tiuien) quit 0
 new cntxt,rmprc,console,cntnopen,SAMIARR,SAMIXD,X,Y
 set (console,cntnopen)=0
 set cntxt="OR CPRS GUI CHART"
 set rmprc="ORWPCE NOTEVSTR"
 set SAMIARR(1)=tiuien
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntnopen,.SAMIARR)
 set:'$g(SAMIXD) SAMIXD=0
 quit SAMIXD
 ;
 ;
 ;@rpi - SCMC PATIENT INFO
 ;@called-by
 ;   PTINFO^KBAIPTIN
 ;   SAMIHOM3
 ;@calls
 ;  M2M^SAMIM2M
 ;  $$setroot^%wd
 ;  $$FMTHL7^XLFDT
 ;  $$URBRUR^SAMIVSTA
 ;@input
 ;   DFN   = IEN of patient into file 2
 ;@output
 ;   Sets additional nodes in patient's Graphstore
 ;   If called as extrinsic
 ;      0   = unable to identify patient
 ;      1^dfn = lookup of patient successful
 ;      2^dfn = and update of Graphstore successful
 ;@tests
 ;  UTPTINF^SAMIUTVA
 ; Pull patient information from the server and
 ;   push into the 'patient-lookup' Graphstore
PTINFO ;
 new cntxt,rmprc,console,cntnopen,SAMIARR,SAMIXD
 new X,rslt
 set rslt=0
 set cntxt="SCMC PCMMR APP PROXY MENU"
 set rmprc="SCMC PATIENT INFO"
 set console=0
 set cntnopen=0
 new ssn set ssn=""
 if '$get(dfn) quit:$Q rslt  quit
 set SAMIARR(1)=dfn
 ;
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntnopen,.SAMIARR)
 ; Update patient-lookup entry for this patient
 new root set root=$$setroot^%wd("patient-lookup")
 new name,node,gien
 if '(dfn=$p(SAMIXD,"^",1)) quit:$Q rslt  quit
 set rslt="1^"_dfn
 new node set node=$name(@root@("dfn",dfn))
 set node=$Q(@node)
 set gien=+$piece(node,",",5)
 if '$get(gien) quit:$Q rslt  quit
 set rslt="2^"_dfn
 set ssn=$piece(SAMIXD,"^",3)
 new dob set dob=$$FMTHL7^XLFDT($piece(SAMIXD,"^",4))
 set dob=$extract(dob,1,4)_"-"_$extract(dob,5,6)_"-"_$extract(dob,7,8)
 quit:'(dob=@root@(gien,"sbdob"))
 set @root@(gien,"ssn")=$piece(SAMIXD,"^",3)
 set:+$piece(SAMIXD,"^",3) @root@("ssn",$piece(SAMIXD,"^",3))=gien
 set @root@(gien,"icn")=$piece(SAMIXD,"^",18)
 set:+$piece(SAMIXD,"^",18) @root@("icn",$piece(SAMIXD,"^",18))=gien
 ; Pull state abbreviation
 new dic5ien if $length($piece(SAMIXD,"^",13)) set dic5ien=$order(^DIC(5,"B",$piece(SAMIXD,"^",13),0))
 new StateABB set StateABB=$piece($get(^DIC(5,+$get(dic5ien),0)),"^",2)
 set @root@(gien,"age")=$piece(SAMIXD,"^",5)
 set @root@(gien,"sex")=$piece(SAMIXD,"^",6)
 set @root@(gien,"marital status")=$piece(SAMIXD,"^",7)
 set @root@(gien,"active duty")=$piece(SAMIXD,"^",8)
 set @root@(gien,"address1")=$piece(SAMIXD,"^",9)
 set @root@(gien,"address2")=$piece(SAMIXD,"^",10)
 set @root@(gien,"address3")=$piece(SAMIXD,"^",11)
 set @root@(gien,"city")=$piece(SAMIXD,"^",12)
 set @root@(gien,"state")=$get(StateABB)
 set @root@(gien,"zip")=$piece(SAMIXD,"^",14)
 set @root@(gien,"county")=$piece(SAMIXD,"^",15)
 set @root@(gien,"phone")=$piece(SAMIXD,"^",16)
 set @root@(gien,"sensitive patient")=$piece(SAMIXD,"^",17)
 ; Get rural or urban and push into both the
 ;   "patient-lookup" and "vapals-patients" Graphstores
 if $piece(SAMIXD,"^",14) do
 . new UrbanRural set UrbanRural=$$URBRUR^SAMIVSTA($piece(SAMIXD,"^",14))
 . set @root@(gien,"samiru")=UrbanRural
 . set root=$$setroot^%wd("vapals-patients")
 . set gien=$order(@root@("dfn",dfn,0))
 . set:gien @root@(gien,"samiru")=UrbanRural
 ;
 ; Get race and push into both the
 ;   "patient-lookup" and "vapals-patients" Graphstores
 if $piece(SAMIXD,"^",18) do
 . new race set race=$$RACE^SAMIVSTA($piece(SAMIXD,"^",18))
 . set root=$$setroot^%wd("patient-lookup")
 . set node=$name(@root@("dfn",dfn))
 . set node=$Q(@node)
 . set gien=+$piece(node,",",5)
 . set @root@(gien,"race")=race
 . set root=$$setroot^%wd("vapals-patients")
 . set gien=$order(@root@("dfn",dfn,0))
 . set:gien @root@(gien,"race")=race
 quit:$Q rslt  quit
 ;
 ;
 ;
 ;@rpi - ORWPT ID INFO
 ;@called-by
 ;@calls
 ;  M2M^SAMIM2M
 ;@input
 ;   DFN   = IEN of patient into file 2
 ;@output
 ;   Sets additional nodes in patient's Graphstore
 ;   If called as extrinsic
 ;      0   = unable to identify patient
 ;      1^SSN = lookup of patient successful
 ;      2^SSN = and update of Graphstore successful
 ;@tests
 ;  UTSSN^SAMIUTVA
 ; Pull patient SSN from the server and
 ;   push into the 'patient-lookup' Graphstore
PTSSN ;
 new cntxt,rmprc,console,cntnopen,SAMIARR,SAMIXD
 set cntxt="OR CPRS GUI CHART"
 set rmprc="ORWPT ID INFO"
 set (console,cntnopen)=0
 new ssn set ssn=0
 if '$get(dfn) quit:$Q ssn  quit
 set SAMIARR(1)=dfn
 kill SAMIXD
 do M2M^SAMIM2M(.SAMIXD,cntxt,rmprc,console,cntnopen,.SAMIARR)
 if '$get(SAMIXD) quit:$Q ssn  quit
 set ssn="1^"_$piece(SAMIXD,"^")
 ;
 ;@called-by
 ;@calls
 ;  $$setroot^%wd
 ;  $$FMTHL7^XLFDT
 ;@input
 ;@output
 ;@tests
PTSSN1 new root set root=$$setroot^%wd("patient-lookup")
 new name,node,gien
 set name=$piece(SAMIXD,"^",8)
 new node set node=$name(@root@("name",name))
 set node=$Q(@node)
 if ($piece(node,",",4)_","_$piece(node,",",5))[name set gien=+$piece(node,",",6)
 if '$get(gien) quit:$Q ssn  quit
 new dob set dob=$$FMTHL7^XLFDT($piece(SAMIXD,"^",2))
 set dob=$extract(dob,1,4)_"-"_$extract(dob,5,6)_"-"_$extract(dob,7,8)
 if '(dob=@root@(gien,"sbdob")) quit:$Q ssn  quit
 new last5 set last5=$extract(name)_$extract(SAMIXD,6,9)
 if '(last5=@root@(gien,"last5")) quit:$Q ssn  quit
 set @root@(gien,"ssn")=$piece(SAMIXD,"^")
 set @root@("ssn",$piece(SAMIXD,"^"))=gien
 set ssn="2^"_$piece(SAMIXD,"^")
 quit:$Q ssn  quit
 ;
 ;
 ;@API-code: $$SIGNTIU^SAMIVSTA
 ;@called-by
 ;@calls
 ;  $$GET^XPAR
 ;  $$GET1^DIQ
 ;  ES^TIURS
 ;@input
 ;   tiuien = ien of note in 8925
 ;@output
 ;   0 = failure, 1 = successful
 ;@tests
 ;  UTSIGN^SAMIUTVA
 ;  UTADDND^SAMIUTVA
 ; Sign a TIU note is ONLY FOR UNIT TESTING as it skips
 ;   over authorization processes.
SIGNTIU ;
 ; some code pulled from SIGN in TIUSRVP2
 new X,tiud0,tiud12,signer,cosigner
 new provduz,tiues
 set provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 set tiud0=$get(^TIU(8925,+tiuda,0)),tiud12=$get(^TIU(8925,+tiuda,12))
 set signer=$piece(tiud12,U,4),cosigner=$piece(tiud12,U,8)
 set tiues=1_U_$$GET1^DIQ(200,+DUZ,20.2)_U_$$GET1^DIQ(200,+DUZ,20.3)
 new status set status=$piece(^TIU(8925,tiuda,0),"^",5)
 quit:'(status=5) 0
 do ES^TIURS(tiuda,tiues)
 set status=$piece(^TIU(8925,tiuda,0),"^",5)
 quit (status=7)
 quit
 ;
 ;@API-code: $$DELTIU^SAMIVSTA
 ;@called-by
 ;@calls
 ;  $$VISTSTR^SAMIVSTA
 ;  DELETE^TIUSRVP
 ;  DELETE^ORWPCE
 ;@input
 ;   tiuien = ien of note in 8925
 ;@output
 ;   0 = failure, 1 = successful
 ;@tests
 ;  UTDELTIU^SAMIUTVA
 ;  SAMIUTH3
 ; Delete an unsigned tiu note
DELTIU ;
 new Y set Y=0
 quit:'$g(tiuien) 0
 new ptdfn set ptdfn=$piece($get(^TIU(8925,tiuien,0)),"^",2)
 quit:'$get(ptdfn) 0  quit:'$data(^DPT(ptdfn)) 0
 new vstr set vstr=$$VISTSTR^SAMIVSTA(tiuien)
 quit:'($length(vstr,";")=3) 0
 new SAMIPOO
 ; Delete the tiu note
 do DELETE^TIUSRVP(.SAMIPOO,tiuien)
 ; SAMIPOO successful if = 0
 quit:'($get(SAMIPOO)=0) 0
 do DELETE^ORWPCE(.SAMIPOO,vstr,ptdfn)
 quit:($get(Y)=-1) 0
 quit 1
 ;
 ;
 ;
 ;@API-code: $$UrbanRural^SAMIVSTA(zipcode)
 ;@called-by
 ;  SAMIRU
 ;  SAMIHOM3
 ;@calls
 ;  $$setroot^%wd
 ;  $$GET^XPAR
 ;@input
 ;  zip code
 ;@output
 ;   n = failure to find definition
 ;   r : 'rural' or u: 'urban' zip found in Graphstore
 ;@tests
 ;  UTURBR^SAMIUTVA
URBRUR ;
 if $get(zipcode)<501 quit "n"
 new root
 set root=$$setroot^%wd("NCHS Urban-Rural")
 quit:'$data(@root@("zip",+zipcode)) "n"
 new samiru,ruca30
 set ruca30=$$GET^XPAR("SYS","SAMI URBAN/RURAL INDEX VALUE",,"Q")
 set:'$get(ruca30) ruca30=1.1
 set samiru=@root@("zip",+zipcode)
 set samiru=$select(samiru>ruca30:"r",1:"u")
 quit samiru
 ;
 ;
 ;
 ;@API-code: $$RACE^SAMIVSTA(ICN)
 ;@called-by
 ;  PTINFO^SAMIVSTA
 ;@calls
 ;  $$setroot^%wd
 ;@input
 ;  icn
 ;@output
 ;   null = no race defined in file 2
 ;   race (e.g. ASIAN, WHITE)
 ;@tests
 ;  UTRACE^SAMIUTVA
RACE ; Return patient's race
 if '$get(icn) q ""
 new cntxt,rmprc,console,cntnopen,SAMIUARR,SAMIUXD,root,race
 set cntxt="SPN GENERAL USER RPC"
 set rmprc="SPN GET RACE"
 set (console,cntnopen)=0
 set SAMIUARR(1)=icn
 do M2M^SAMIM2M(.SAMIUXD,cntxt,rmprc,console,cntnopen,.SAMIUARR)
 s race=$p(SAMIUXD,"^")
 q race
 ;
 ;
 ;
EOR ; End of routine SAMIVST2
