SAMIUALL ;ven/lmry/arc - Unit test overall coverage ;2018-11-05T20:01Z
 ;;18.0;SAMI;;
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2018-10-31T1854Z
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START ; Run the coverage tests
 new I,NAMESPAC,RUNCODE,XCLUDE
 ;
 ; Set the namespace for the routines that are being tested.
 set NAMESPAC="SAMI*"
 ;
 ; Add the routines here in the preferred order; this enables us to easily
 ; rearrange these in whatever order we like.
 set I=0
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
 set I=I+1,RUNCODE(I)="^SAMIUTR5"
 set I=I+1,RUNCODE(I)="^SAMIUTR6"
 set I=I+1,RUNCODE(I)="^SAMIUTR7"
 set I=I+1,RUNCODE(I)="^SAMIUTR8"
 set I=I+1,RUNCODE(I)="^SAMIUTR9"
 set I=I+1,RUNCODE(I)="^SAMIUTRA"
 set I=I+1,RUNCODE(I)="^SAMIUTRX"
 set I=I+1,RUNCODE(I)="^SAMIUTF2"
 set I=I+1,RUNCODE(I)="^SAMIUTPT"
 set I=I+1,RUNCODE(I)="^SAMIUTUR"
 set I=I+1,RUNCODE(I)="^SAMIUTNI"
 set I=I+1,RUNCODE(I)="^SAMIUTC2"
 set I=I+1,RUNCODE(I)="^SAMIUTVA"
 set I=I+1,RUNCODE(I)="^SAMIUTVS"
 ;
 ; Note that routine references may be specified in one of the following ways:
 ;   * MODULE         : Calls EN^%ut with the name as an argument.
 ;   * ^MODULE        : Calls the entry point of the module.
 ;   * ROUTINE^MODULE : Calls a specific routine in the module.
 ;
 ; We generally prefer the middle form.
 ;
 ; Exclude the unit-test routines
 set I=0
 set I=I+1,XCLUDE(I)="SAMIUALL"
 set I=I+1,XCLUDE(I)="SAMIUTST"
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
 set I=I+1,XCLUDE(I)="SAMIUTR5"
 set I=I+1,XCLUDE(I)="SAMIUTR6"
 set I=I+1,XCLUDE(I)="SAMIUTR7"
 set I=I+1,XCLUDE(I)="SAMIUTR8"
 set I=I+1,XCLUDE(I)="SAMIUTR9"
 set I=I+1,XCLUDE(I)="SAMIUTRA"
 set I=I+1,XCLUDE(I)="SAMIUTRX"
 set I=I+1,XCLUDE(I)="SAMIUTF2"
 set I=I+1,XCLUDE(I)="SAMIUTPT"
 set I=I+1,XCLUDE(I)="SAMIUTUR"
 set I=I+1,XCLUDE(I)="SAMIUTNI"
 set I=I+1,XCLUDE(I)="SAMIUTC2"
 set I=I+1,XCLUDE(I)="SAMIUTVA"
 set I=I+1,XCLUDE(I)="SAMIUTVS"
 ; These are low priority routines without complete unit tests
 set I=I+1,XCLUDE(I)="SAMID"
 set I=I+1,XCLUDE(I)="SAMIDOUT"
 set I=I+1,XCLUDE(I)="SAMIDSSN"
 set I=I+1,XCLUDE(I)="SAMIVSTR"
 ; These are incomplete unit tests for low priority routines
 set I=I+1,XCLUDE(I)="SAMIUTDS"
 set I=I+1,XCLUDE(I)="SAMIUTID"
 set I=I+1,XCLUDE(I)="SAMIUTOT"
 set I=I+1,XCLUDE(I)="SAMIUTVR"
 ; These are deprecated routines
 ; set I=I+1,XCLUDE(I)="ROUTINE"
 ;
 ; Add the XCLUDE values to the TMP variable that tracks this coverage test.
 ;
 merge ^TMP("SAMI",$JOB,"XCLUDE")=XCLUDE
 ;
 do COVERAGE^%ut(NAMESPAC,.RUNCODE,.XCLUDE,2)
 ;
 quit  ; end of START
 ;
 ;
EOR ; End of routine SAMIUALL
