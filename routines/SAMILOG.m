SAMILOG ;ven/lgc - APIs to toggle password identification ;Jan 10, 2020@12:15
 ;;18.0;SAMI;;
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
 ; @additional-dev: Linda M. R. Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: see routine SAMIUL
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
 ;
STONOFF ;
 new ienget,ienpost,DIR,X,Y,%,DTOUT,DUOUT,ONOFF
 new root s root=$na(^%web(17.6001))
 set ienget=$order(@root@("B","GET","vapals","WSHOME^SAMIHOM3",0))
 set ienpost=$order(@root@("B","POST","vapals","WSVAPALS^SAMIHOM3",0))
 if $get(@root@(ienget,"AUTH")) do
 . write !,"VAPALS password ID is presently ON",!
 . write !," would you like to turn *** OFF *** VAPALS password ID."
 . set ONOFF="ON"
 else  do
 . write !,"VAPALS password ID is presently OFF",!
 . write !," would you like to turn *** ON *** VAPALS password ID."
 . set ONOFF="OFF"
 ;
 write !
 ; check if running unit test on this routine
 if $data(%ut) goto STONOFF1
 ;
 set %=2 do YN^DICN quit:$data(DTOUT)  quit:$data(DUOUT)  quit:%=2
 ;
STONOFF1 if ONOFF="OFF" do TOGON write !,"VAPALS password ID is now turned ON",!,! quit
 if ONOFF="ON" do TOGOFF write !,"VAPALS password ID is now turned OFF",!,!
 quit
 ;
 ; Toggle password identification OFF
TOGOFF new DIERR,FDA,ienget,ienpost,IENS,root
 n root s root=$na(^%web(17.6001))
 set ienget=$order(@root@("B","GET","vapals","WSHOME^SAMIHOM3",0))
 set ienpost=$order(@root@("B","POST","vapals","WSVAPALS^SAMIHOM3",0))
 quit:'ienget  quit:'ienpost
 set IENS=ienget_","
 set FDA(3,17.6001,IENS,11)=0
 do UPDATE^DIE("","FDA(3)")
 set IENS=ienpost_","
 set FDA(3,17.6001,IENS,11)=0
 do UPDATE^DIE("","FDA(3)")
 ;
 quit
 ;
 ; Toggle password identification ON
TOGON new DIERR,FDA,ienget,ienpost,IENS
 n root s root=$na(^%web(17.6001))
 set ienget=$order(@root@("B","GET","vapals","WSHOME^SAMIHOM3",0))
 set ienpost=$order(@root@("B","POST","vapals","WSVAPALS^SAMIHOM3",0))
 quit:'ienget  quit:'ienpost
 set IENS=ienget_","
 set FDA(3,17.6001,IENS,11)=1
 do UPDATE^DIE("","FDA(3)")
 set IENS=ienpost_","
 set FDA(3,17.6001,IENS,11)=1
 do UPDATE^DIE("","FDA(3)")
 ;
 quit
 ;
 ;
MEOFF ;
 D EN^XPAR("SYS","SAMI ALLOW MANUAL ENTRY",1,0)
 new onoff set onoff=$$GET^XPAR("SYS","SAMI ALLOW MANUAL ENTRY",,"Q")
 if 'onoff w !,"*** VAPALS MANUAL ENTRY NOW NOT ALLOWED ***",!
 quit
 ;
MEON D EN^XPAR("SYS","SAMI ALLOW MANUAL ENTRY",1,1)
 new onoff set onoff=$$GET^XPAR("SYS","SAMI ALLOW MANUAL ENTRY",,"Q")
 if onoff w !,"*** VAPALS MANUAL ENTRY NOW ALLOWED ***",!
 quit
 ;
 ;
EOR ;End of routine SAMILOG
