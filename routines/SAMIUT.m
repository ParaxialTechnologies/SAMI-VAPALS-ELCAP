SAMIUT ;ven/arc/lmry - Unit test overall coverage ; 2/6/19 1:48pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev:
 ;  Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ;  Linda Yaw (lmry)
 ;  linda.yaw@vistaexpertise.net
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
 if $T(^%ut)="" do
 . write !,"*** UNIT TEST NOT INSTALLED ***"
 . quit
 ;
 do EN^%ut($text(+0),3)
 ;
 quit  ; End of call from top
 ;
 ;
XTROU ; Unit tests for SAMI*.m
 ;;SAMIUTFF
 ;;SAMIUTLG
 ;;SAMIUTM2
 ;;SAMIUTH3
 ;;SAMIUTS2
 ;;SAMIUTAD
 ;;SAMIUTC1
 ;;SAMIUTD2
 ;;SAMIUTCR
 ;;SAMIUTR0
 ;;SAMIUTR1
 ;;SAMIUTR2
 ;;SAMIUTR3
 ;;SAMIUTR4
 ;;SAMIUTR9
 ;;SAMIUTRA
 ;;SAMIUTRX
 ;;SAMIUTF2
 ;;SAMIUTPT
 ;;SAMIUTUR
 ;;SAMIUTNI
 ;;SAMIUTC2
 ;;SAMIUTVA
 ;;SAMIUTVB
 ;;SAMIUTVS
 ;;SAMIUTRU
 ;;SAMIUTSV
 ;
 quit  ; End of XTROU
 ;
 ;
COVERAGE ; Coverage tests for SAMI*.m
 new I,NAMESPAC,RUNCODE,XCLUDE
 ;
 ; Set the namespace for the routines that are being tested.
 set NAMESPAC="SAMI*"
 ;
 ; Add the routines here in the preferred order; this enables us to easily
 ; rearrange these in whatever order we like.
 set I=0
 ; set I=I+1,RUNCODE(I)="SAMID"
 ; set I=I+1,RUNCODE(I)="SAMIDOUT"
 ; set I=I+1,RUNCODE(I)="SAMIDSSN"
 set I=I=1,RUNCODE(I)="^SAMIUTFF"
 set I=I+1,RUNCODE(I)="^SAMIUTLG"
 set I=I+1,RUNCODE(I)="^SAMIUTM2"
 set I=I+1,RUNCODE(I)="^SAMIUTH3"
 set I=I+1,RUNCODE(I)="^SAMIUTS2"
 set I=I+1,RUNCODE(I)="^SAMIUTAD"
 set I=I+1,RUNCODE(I)="^SAMIUTC1"
 set I=I+1,RUNCODE(I)="^SAMIUTD2"
 set I=I+1,RUNCODE(I)="^SAMIUTCR"
 set I=I+1,RUNCODE(I)="^SAMIUTR0"
 set I=I+1,RUNCODE(I)="^SAMIUTR1"
 set I=I+1,RUNCODE(I)="^SAMIUTR2"
 set I=I+1,RUNCODE(I)="^SAMIUTR3"
 set I=I+1,RUNCODE(I)="^SAMIUTR4"
 set I=I+1,RUNCODE(I)="^SAMIUTR9"
 set I=I+1,RUNCODE(I)="^SAMIUTRA"
 set I=I+1,RUNCODE(I)="^SAMIUTRX"
 set I=I+1,RUNCODE(I)="^SAMIUTF2"
 set I=I+1,RUNCODE(I)="^SAMIUTPT"
 set I=I+1,RUNCODE(I)="^SAMIUTUR"
 set I=I+1,RUNCODE(I)="^SAMIUTNI"
 set I=I+1,RUNCODE(I)="^SAMIUTC2"
 set I=I+1,RUNCODE(I)="^SAMIUTVA"
 set I=I+1,RUNCODE(I)="^SAMIUTVB"
 set I=I+1,RUNCODE(I)="^SAMIUTVS"
 set I=I+1,RUNCODE(I)="^SAMIUTRU"
 set I=I+1,RUNCODE(I)="^SAMIUTSV"
 ;
 ; Note that routine references may be specified in one of the following ways:
 ;   * MODULE         : Calls EN^%ut with the name as an argument.
 ;   * ^MODULE        : Calls the entry point of the module.
 ;   * ROUTINE^MODULE : Calls a specific routine in the module.
 ;
 ; We generally prefer the middle form.
 ;
 set I=0
 ; Excude routines with incomplete unit tests
 set I=I+1,XCLUDE(I)="SAMID"
 set I=I+1,XCLUDE(I)="SAMIUTID"
 ;
 set I=I+1,XCLUDE(I)="SAMIDSSN"
 set I=I+1,XCLUDE(I)="SAMIUTDS"
 ;
 set I=I+1,XCLUDE(I)="SAMIDOUT"
 set I=I+1,XCLUDE(I)="SAMIUTOT"
 ; Exclude checksum utility & overall coverage routine
 set I=I+1,XCLUDE(I)="SAMIUCOV"
 set I=I+1,XCLUDE(I)="SAMIUTST"
 ; Exclude radiology routine & unit test not in use
 set I=I+1,XCLUDE(I)="SAMIVSTR"
 set I=I+1,XCLUDE(I)="SAMIUTVR"
 ; Exclude the unit-test routines
 set I=I+1,XCLUDE(I)="SAMIUT"
 set I=I+1,XCLUDE(I)="SAMIUTFF"
 set I=I+1,XCLUDE(I)="SAMIUTLG"
 set I=I+1,XCLUDE(I)="SAMIUTM2"
 set I=I+1,XCLUDE(I)="SAMIUTH3"
 set I=I+1,XCLUDE(I)="SAMIUTS2"
 set I=I+1,XCLUDE(I)="SAMIUTAD"
 set I=I+1,XCLUDE(I)="SAMIUTC1"
 set I=I+1,XCLUDE(I)="SAMIUTD2"
 set I=I+1,XCLUDE(I)="SAMIUTCR"
 set I=I+1,XCLUDE(I)="SAMIUTR0"
 set I=I+1,XCLUDE(I)="SAMIUTR1"
 set I=I+1,XCLUDE(I)="SAMIUTR2"
 set I=I+1,XCLUDE(I)="SAMIUTR3"
 set I=I+1,XCLUDE(I)="SAMIUTR4"
 set I=I+1,XCLUDE(I)="SAMIUTR9"
 set I=I+1,XCLUDE(I)="SAMIUTRA"
 set I=I+1,XCLUDE(I)="SAMIUTRX"
 set I=I+1,XCLUDE(I)="SAMIUTF2"
 set I=I+1,XCLUDE(I)="SAMIUTPT"
 set I=I+1,XCLUDE(I)="SAMIUTUR"
 set I=I+1,XCLUDE(I)="SAMIUTNI"
 set I=I+1,XCLUDE(I)="SAMIUTC2"
 set I=I+1,XCLUDE(I)="SAMIUTVA"
 set I=I+1,XCLUDE(I)="SAMIUTVB"
 set I=I+1,XCLUDE(I)="SAMIUTVS"
 set I=I+1,XCLUDE(I)="SAMIUTRU"
 set I=I+1,XCLUDE(I)="SAMIUTSV"
 ;
 ; Add the XCLUDE values to the TMP variable that tracks this coverage test.
 merge ^TMP("SAMI",$JOB,"XCLUDE")=XCLUDE
 ;
 do COVERAGE^%ut(NAMESPAC,.RUNCODE,.XCLUDE,2)
 ;
 quit  ; end of COVERAGE
 ;
 ;
EOR ; End of routine SAMIUT
