SAMIVSTA ;;ven/lgc - M2M Broker to build TIU for VA-PALS ; 3/7/19 9:57am
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ;
SV2VISTA(filter) ;
 goto SV2VISTA^SAMIVST1
 quit
 ;
TASKIT ;
 goto TASKIT^SAMIVST1
 quit
 ;
NEWTIU ;
 goto NEWTIU^SAMIVST1
 quit
 ;
NEWTXT ;
 goto NEWTXT^SAMIVST1
 quit
 ;
ENCNTR ;
 goto ENCNTR^SAMIVST1
 quit
 ;
BLDTIU(tiuien,dfn,title,user,clinien) ;
 goto BLDTIU^SAMIVST1
 quit
 ;
SETTEXT(tiuien,dest) ;
 goto SETTEXT^SAMIVST1
 quit
 ;
BLDENCTR(tiuien,SAMIUHFA) ;
 goto BLDENCTR^SAMIVST1
 quit
 ;
ADDSGNRS(filter) ;
 goto ADDSGNRS^SAMIVST1
 quit
 ;
ADDSIGN ;
 goto ADDSIGN^SAMIVST1
 quit
 ;
TIUADND(tiuien,userduz) ;
 goto TIUADND^SAMIVST2
 quit
 ;
VISTSTR(tiuien) ;
 goto VISTSTR^SAMIVST2
 quit
 ;
PTINFO(dfn) ;
 goto PTINFO^SAMIVST2
 quit
 ;
PTSSN(dfn) ;
 goto PTSSN^SAMIVST2
 quit
 ;
SIGNTIU(tiuda) ;
 goto SIGNTIU^SAMIVST2
 quit
 ;
DELTIU(tiuien) ;
 goto DELTIU^SAMIVST2
 quit
 ;
URBRUR(zipcode) ;
 goto URBRUR^SAMIVST2
 quit
 ;
RACE(icn) ;
 goto RACE^SAMIVST2
 quit
 ;
KASAVE(provider,tiuien) ;
 goto KASAVE^SAMIVST1
 quit
 ;
VIT(dfn,sdate,edate) ;
 goto VIT^SAMIVST3
 quit
 ;
VPR(dfn) ;
 goto VPR^SAMIVST3
 quit
 ;
ALLPTS ;
 goto ALLPTS^SAMIVST4
 quit
 ;
ALLPTS1(SAMISS) ;
 goto ALLPTS1^SAMIVST4
 quit
 ;
MKGPH ;
 goto MKGPH^SAMIVST4
 quit
 ;
RMDRS() ;
 goto RMDRS^SAMIVST4
 quit
 ;
PRVDRS() ;
 goto PRVDRS^SAMIVST4
 quit
 ;
CLINICS() ;
 goto CLINICS^SAMIVST4
 quit
 ;
HLTHFCT() ;
 goto HLTHFCT^SAMIVST4
 quit
 ;
CLRGRPS(name) ;
 goto CLRGRPS^SAMIVST4
 quit
 ;
RADPROCD(StationNumber) ;
 goto RADPROCD^SAMIVST5
 quit
 ;
ACTEXAMS() ;
 goto ACTEXAMS^SAMIVST5
 quit
 ;
RADSTAFF() ;
 goto RADSTAFF^SAMIVST5
 quit
 ;
RADRESDT() ;
 goto RADRESDT^SAMIVST5
 quit
 ;
RADTECHS() ;
 goto RADTECHS^SAMIVST5
 quit
 ;
RADMODS() ;
 goto RADMODS^SAMIVST5
 quit
 ;
RADDXCDS() ;
 goto RADDXCDS^SAMIVST5
 quit
 ;
 ;
EOR ; End of routine SAMIVSTA
