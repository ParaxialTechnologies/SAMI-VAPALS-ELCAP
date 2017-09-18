SAMIDOUT ;ven/toad - ielcap dd output ;Sep 18,2017@16:14
 ;;18.0;SAM;;
 ;
 ; Routine SAMIDOUT contains subroutines for outputing the data
 ; dictionary of SAMI fields to the va-pals repository in tab-delimited
 ; format
 ;
 ; Primary Development History
 ;
 ; @primary-dev: Frederick D. S. Marshall (toad)
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ; @copyright: 2017, Vista Expertise Network (ven), all rights reserved
 ; @license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2017-09-18T16:14Z
 ; @application: Screening Applications Management (SAM)
 ; @module: Screening Applications Management - IELCAP (SAMI)
 ; @suite-of-files: SAMI Forms (311.101-311.199)
 ; @version: 18.0T01 (first development version)
 ; @release-date: not yet released
 ; @patch-list: none yet
 ;
 ; @funding-org: 2017-2018,Bristol-Myers Squibb Foundation (bmsf)
 ;   https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;
 ; 2017-09-18 ven/toad v18.0t01 SAMIDOUT: create, building on Mash
 ; tools in %cp & %sfo
 ;
 ;
 ; contents
 ;
 ; ALL: tbw
 ; ONE: export SAMI dd
 ;
 ;
 ;
ONE(SAMIDD,SAMIPKG,SAMILOG) ; export SAMI dd
 ;
 ; 1. invocation, binding, & branching
 ;
 ;ven/toad;private;procedure;clean;silent;NOT portable;0% tests
 ; @signature:
 ;   do ONE^SAMIDOUT(SAMIDD)
 ; @calls:
 ;   mini^%u: performance mini-meter
 ;   properties^%sfo: build field table
 ; @input:
 ;   SAMIDD = dd# of file definition to output
 ;  .SAMIPKG = package#
 ;   SAMIPKG("PATH") = directory path to dd-output repository
 ; @output:
 ;   file path/name-dd-m.csv created/updated
 ;
 ; export is in quoted, tab-delimited format
 ;
 ; 2. generate dd-export array
 ;
 set:$get(SAMILOG)="" SAMILOG=0 ; default to no mini-meter
 do:SAMILOG mini^%u(2,.SAMILOG)
 ;
 new SAMIFLDS ; field table
 do properties^%sfo(.SAMIFLDS,SAMIDD) ; build table
 quit:'$data(SAMIFLDS(1)) ; done if no content returned
 kill SAMIFLDS("key") ; remove field index
 ;
 ; 3. calculate export-file name
 ;
 do:SAMILOG mini^%u(3,.SAMILOG)
 ;
 new SAMIATT ; file attributes array
 new SAMIMSG ; dba message array
 do FILE^DID(SAMIDD,,"NAME","SAMIATT","SAMIMSG") ; get file name
 quit:$get(DIERR)  ; done if dd file retriever fails
 new SAMIFILE set SAMIFILE=$get(SAMIATT("NAME")) ; file name
 quit:SAMIFILE=""  ; done if no file retrieved
 ;
 ; start with export-file name = fileman-file name
 new SAMINAME set SAMINAME=SAMIATT("NAME") ; fileman-file name
 ; clear package prefix from file name
 set:$extract(SAMINAME,1,5)="SAMI " $extract(SAMINAME,1,5)=""
 set SAMINAME=$$lowcase^%ts(SAMINAME) ; convert to lowercase
 set SAMINAME=$translate(SAMINAME," _/.","---") ; normalize punctuation
 set SAMINAME=SAMINAME_"-dd-m.csv" ; append std export-file suffix
 ;
 ; 4. set new dd-export file
 ;
 do:SAMILOG mini^%u(4,.SAMILOG)
 ;
 kill ^TMP("SAMIDOUT",$job) ; clear loading dock
 merge ^TMP("SAMIDOUT",$job)=SAMIFLDS ; copy table to loading dock
 new SAMIROOT set SAMIROOT=$name(^TMP("SAMIDOUT",$job,0)) ; dock root
 ;
 new SAMIPATH set SAMIPATH=$get(SAMIPKG("PATH")) ; path to repository
 quit:SAMIPATH=""  ; can't export w/o path
 set SAMIPATH=SAMIPATH_"elements/dd/" ; extend path to dd elements dir
 ;
 ; export dd
 new PSEUDO set PSEUDO=$$GTF^%ZISH(SAMIROOT,3,SAMIPATH,SAMINAME)
 kill ^TMP("SAMIDOUT",$job) ; clear loading dock
 ;
 ; 5. termination
 ;
 do:SAMILOG mini^%u(5,.SAMILOG)
 ;
 quit  ; end of ONE
 ;
 ;
eor ; end of routine SAMIDOUT
