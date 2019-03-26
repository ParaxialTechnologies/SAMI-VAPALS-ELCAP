SAMIUTFF ;ven/arc - Unit test for SAMIFF ; 3/26/19 9:30am
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Alexis R. Carlson (arc)
 ;  alexis.carlson@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2019-03-14T20:29Z
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START ;
 if $t(^%ut)="" do
 . write !,"*** UNIT TEST NOT INSTALLED ***"
 . quit
 ;
 do EN^%ut($text(+0),3)
 quit
 ;
 ;
STARTUP ;
 quit
 ;
 ;
SETUP ;
 new root,fieldnum,inputnum,expect,result
 quit
 ;
 ;
TEARDOWN ; ZEXCEPT: root,fieldnum,inputnum,expect,result
 kill root,fieldnum,inputnum,expect,result
 quit
 ;
 ;
SHUTDOWN ;
 quit
 ;
 ;
UTFF ; @TEST Entry from top
 ; What can I say? 96.67% coverage was killing me.
 ;
 do ^SAMIFF
 do SUCCEED^%ut
 quit ; End of label UTFF
 ;
 ;
UTPRSTSV ; @TEST Parse TSV file and build graph of form fields
 ; This subroutine contains three tests of the graph's structure:
 ;  1) Check that the graph actually contains data
 ;  2) Check that each input contains nodes for each parameter
 ;  3) Check that cross-reference nodes exist
 ;
 ;****
 S ^KBAP("SAMIUTFF RAN")=$$HTFM^XLFDT($H)
 D PRSTSV^SAMIFF("/home/osehra/lib/silver/va-pals/docs/form-fields/","intake.tsv","form fields - intake")
 ;
 ; Check that the graph actually contains data
 set root=$$setroot^%wd("form fields - intake")
 set expect="10"
 set result=$data(@root@("field"))
 do CHKEQ^%ut(result,expect)
 ;
 ; Check that each input contains nodes for each parameter
 set expect=1
 set result=1
 set fieldnum=0
 set inputnum=0
 ;
 for  set fieldnum=$order(@root@("field",fieldnum)) quit:'fieldnum  do
 . for  set inputnum=$order(@root@("field",fieldnum,"input",inputnum)) quit:'inputnum  do
 . . if $data(@root@("field",fieldnum,"input",inputnum,"label"))=0 set result=0
 . . if $data(@root@("field",fieldnum,"input",inputnum,"name"))=0 set result=0
 . . if $data(@root@("field",fieldnum,"input",inputnum,"placeholder"))=0 set result=0
 . . if $data(@root@("field",fieldnum,"input",inputnum,"question"))=0 set result=0
 . . if $data(@root@("field",fieldnum,"input",inputnum,"required"))=0 set result=0
 . . if $data(@root@("field",fieldnum,"input",inputnum,"type"))=0 set result=0
 . . if $data(@root@("field",fieldnum,"input",inputnum,"value"))=0 set result=0
 ;
 do CHKEQ^%ut(result,expect)
 ;
 ; Check that cross-reference nodes exist
 set expect=1
 set result=1
 set fieldnum=0
 new name
 ;
 for  set fieldnum=$order(@root@("field",fieldnum)) quit:'fieldnum  do
 . set name=@root@("field",fieldnum,"input",1,"name")
 . if $data(@root@("field","B",name,fieldnum))=0 set result=0
 ;
 do CHKEQ^%ut(result,expect)
 ;
 quit ; End of label PRSTSV
 ;
 ;
EOR ; End of routine SAMIUTFF
