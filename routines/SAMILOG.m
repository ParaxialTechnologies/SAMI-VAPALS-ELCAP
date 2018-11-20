SAMILOG ;ven/lgc - APIs to toggle password identification ; 11/19/18 9:17am
 ;;18.0;SAMI;;
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
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
 ;
 ; @section 1 code
 ;
 ; ^%W(17.6001,"B","GET","vapals","wsHOME^SAMIHOM3",20)
 ;   ^%W(17.6001,20,0) = GET                 (.01)
 ;   ^%W(17.6001,20,1) = vapals              (1) F
 ;   ^%W(17.6001,20,2) = wsHOME^SAMIHOM3     (2) F
 ;   ^%W(17.6001,20,"AUTH") = 1              (11)S
 ; ^%W(17.6001,"B","POST","vapals","wsVAPALS^SAMIHOM3",22)
 ;   ^%W(17.6001,22,0) = POST                (.01)
 ;   ^%W(17.6001,22,1) = vapals              (1) F
 ;   ^%W(17.6001,22,2) = wsVAPALS^SAMIHOM3   (2) F
 ;   ^%W(17.6001,22,"AUTH") = 1              (11)S
 ;
SetPswdIdOnOff ;
 N ienget,ienpost,DIR,X,Y,%,DTOUT,DUOUT
 s ienget=$o(^%W(17.6001,"B","GET","vapals","wsHOME^SAMIHOM3",0))
 s ienpost=$o(^%W(17.6001,"B","POST","vapals","wsVAPALS^SAMIHOM3",0))
 I $G(^%W(17.6001,ienget,"AUTH")) D
 . W !,"VAPALS password ID is presently ON",!
 . W !," would you like to turn *** OFF *** VAPALS password ID."
 . s Y=0
 E  d
 . W !,"VAPALS password ID is presently OFF",!
 . W !," would you like to turn *** ON *** VAPALS password ID."
 . s Y=1
 ;
 W !
 S %=2 D YN^DICN i '(%=1) q
 q:$d(DTOUT)  q:$d(DUOUT)
 i Y=1 d ToggleOn W !,"VAPALS password ID is now turned ON",!,! q
 i Y=0 d ToggleOff W !,"VAPALS password ID is now turned OFF",!,! q
 q
 ;
 ; Toggle password identification OFF
ToggleOff n dierr,fda,ienget,ienpost,iens
 s ienget=$o(^%W(17.6001,"B","GET","vapals","wsHOME^SAMIHOM3",0))
 s ienpost=$o(^%W(17.6001,"B","POST","vapals","wsVAPALS^SAMIHOM3",0))
 q:'ienget  q:'ienpost
 s iens=ienget_","
 s FDA(3,17.6001,iens,11)=0
 D UPDATE^DIE("","FDA(3)")
 ;
 s iens=ienpost_","
 s FDA(3,17.6001,iens,11)=0
 D UPDATE^DIE("","FDA(3)")
 q
 ;
 ; Toggle password identification ON
ToggleOn n dierr,fda,ienget,ienpost,iens
 s ienget=$o(^%W(17.6001,"B","GET","vapals","wsHOME^SAMIHOM3",0))
 s ienpost=$o(^%W(17.6001,"B","POST","vapals","wsVAPALS^SAMIHOM3",0))
 q:'ienget  q:'ienpost
 s iens=ienget_","
 s FDA(3,17.6001,iens,11)=1
 D UPDATE^DIE("","FDA(3)")
 ;
 s iens=ienpost_","
 s FDA(3,17.6001,iens,11)=1
 D UPDATE^DIE("","FDA(3)")
 q
 ;
EOR ;End of routine SAMILOG
