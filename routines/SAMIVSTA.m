SAMIVSTA ;;ven/lgc - M2M Broker to build TIU for VA-PALS ; 3/11/19 6:34pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ;
SV2VISTA(filter) ;
 goto SV2VISTA^SAMIVST1
 ;
TASKIT ;
 goto TASKIT^SAMIVST1
 ;
NEWTIU ;
 goto NEWTIU^SAMIVST1
 ;
NEWTXT ;
 goto NEWTXT^SAMIVST1
 ;
ENCNTR ;
 goto ENCNTR^SAMIVST1
 ;
BLDTIU(tiuien,dfn,title,user,clinien) ;
 goto BLDTIU^SAMIVST1
 ;
SETTEXT(tiuien,dest) ;
 goto SETTEXT^SAMIVST1
 ;
BLDENCTR(tiuien,SAMIUHFA) ;
 goto BLDENCTR^SAMIVST1
 ;
ADDSGNRS(filter) ;
 goto ADDSGNRS^SAMIVST1
 ;
ADDSIGN ;
 goto ADDSIGN^SAMIVST1
 ;
TIUADND(tiuien,userduz) ;
 goto TIUADND^SAMIVST2
 ;
VISTSTR(tiuien) ;
 goto VISTSTR^SAMIVST2
 ;
PTINFO(dfn) ;
 goto PTINFO^SAMIVST2
 ;
PTSSN(dfn) ;
 goto PTSSN^SAMIVST2
 ;
SIGNTIU(tiuda) ;
 goto SIGNTIU^SAMIVST2
 ;
DELTIU(tiuien) ;
 goto DELTIU^SAMIVST2
 ;
URBRUR(zipcode) ;
 goto URBRUR^SAMIVST2
 ;
RACE(icn) ;
 goto RACE^SAMIVST2
 ;
KASAVE(provider,tiuien) ;
 goto KASAVE^SAMIVST1
 ;
VIT(dfn,sdate,edate) ;
 goto VIT^SAMIVST3
 ;
VPR(dfn) ;
 goto VPR^SAMIVST3
 ;
ALLPTS ;
 goto ALLPTS^SAMIVST4
 ;
ALLPTS1(SAMISS) ;
 goto ALLPTS1^SAMIVST4
 ;
MKGPH ;
 goto MKGPH^SAMIVST4
 ;
RMDRS() ;
 goto RMDRS^SAMIVST4
 ;
PRVDRS() ;
 goto PRVDRS^SAMIVST4
 ;
CLINICS() ;
 goto CLINICS^SAMIVST4
 ;
HLTHFCT() ;
 goto HLTHFCT^SAMIVST4
 ;
CLRGRPS(name) ;
 goto CLRGRPS^SAMIVST4
 ;
RADPROCD(StationNumber) ;
 goto RADPROCD^SAMIVST5
 ;
ACTEXAMS() ;
 goto ACTEXAMS^SAMIVST5
 ;
RADSTAFF() ;
 goto RADSTAFF^SAMIVST5
 ;
RADRESDT() ;
 goto RADRESDT^SAMIVST5
 ;
RADTECHS() ;
 goto RADTECHS^SAMIVST5
 ;
RADMODS() ;
 goto RADMODS^SAMIVST5
 ;
RADDXCDS() ;
 goto RADDXCDS^SAMIVST5
 ;
 ;
EOR ; End of routine SAMIVSTA
