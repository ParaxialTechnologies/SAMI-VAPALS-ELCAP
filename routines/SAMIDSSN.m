SAMIDSSN ;ven/toad - ielcap dd ssn in sami intake ;Aug 17,2017@14:42
 ;;18.0;SAM;;
 ;
 ; Routine SAMIDSSN contains subroutines that support the data
 ; dictionary of field Social Security Number (.09) in file SAMI Intake
 ; (311.101).
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
 ; @last-updated: 2017-08-17T14:43Z
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
 ; @original-dev: ALB/JDS
 ; @original-dev: ALB/LBD
 ;
 ; 2017-08-16 ven/toad v18.0t01 SAMIDD1: create from routine DGRPDD1
 ; for input transform for field Social Security Number (.09) in file
 ; SAMI Intake (311.101); copy over ssn-related subroutines & apply
 ; mdc pattern-language style for sustainability.
 ;
 ; 2017-08-17 ven/toad v18.0t01 SAMIDSSN: rename routine, finish
 ; replacing PSEU with $$PSEUDO, rename SSN => SSNIN & repurpose as the
 ; code to implement ddi SSNIN^SAMIDD.
 ;
 ;
 ; contents
 ;
 ; SSNIN: input transform for field Social Security Number (.09)
 ; PSEU: generate pseudo-ssn
 ; $$HASH: hash letter to digit
 ; $$FINDFREE = find next free pseudo-ssn to avoid duplicates
 ;
 ;
 ;
SSNIN ; code for ddi SSNIN^SAMIDD, input xform for .09 in 311.101
 ;
 ;;{contract};procedure;clean;silent;portable;0% tests
 ;
 ; 1. invocation, binding, & branching
 ;
 ; @signature:
 ;   do SSNIN^SAMIDD(.X,SAMIUPDATE)
 ; @branches-from:
 ;   SSNIN^SAMIDD
 ; @calls:
 ;   $$PSEUDO: generate pseudo-ssn
 ; @throughput:
 ;   X = in as proposed external value for field Social Security Number
 ;          (.09) in file SAMI Intake (311.101)
 ;       out as validated internal value for field
 ;          undefined if X was not a valid external value for field
 ; @input:
 ;  ]ZTQUEUED = [optional] set if taskman is running this code
 ;  ]SAMIZNV = [optional] controls handling of X = pseudo ssn
 ;      either way, will recalculate to see what pseudo ssn should be
 ;      if not defined, SSN will reject pseudo if it doesn't match
 ;      if defined, SSN will update the pseudo ssn to new value
 ;  ]DIUTIL = [optional] defined if running Fileman Utility Options
 ;      if running VERIFY FIELDS, won't reject ssn for being in use
 ;  ^SAMI(311.101,"SSN") = index of assigned ssns
 ;  ^SAMI(311.101,#,0) = sami intake record for an assigned ssn
 ;
 if X'?.AN do  ; if we have punctuation, probably dashes
 . new pos
 . for pos=1:1:$length(X) do:$extract(X,pos)?1P
 . . set $extract(X,pos)="" ; strip the punctuation
 . . ; this pulls next character to current position
 . . set pos=pos-1 ; so back up to check next character
 . . quit
 . quit
 ;
 if X="P"!(X="p") do  quit  ; if asked to generate a pseudo ssn
 . set X=$$PSEUDO(X) ; replace P/p w/pseudo ssn
 . write:'$data(ZTQUEUED) "  ",X
 . quit
 ;
 if X["P",'$data(SAMIZNV) do  quit  ; if fixed pseudo ssn
 . new pseudo set pseudo=$$PSEUDO(X) ; what's the right pseudo ssn?
 . quit:X=pseudo  ; we're fine if X is the right pseudo ssn
 . kill X ; otherwise, reject it
 . write *7,"  Invalid pseudo SSN."
 . write !,"Type 'P' for the valid one"
 . quit
 ;
 if X["P",$data(SAMIZNV) do  quit  ; if variable pseudo ssn
 . new pseudo set pseudo=$$PSEUDO(X) ; what's the right pseudo ssn?
 . quit:X=L  ; we're fine if X is the right pseudo ssn
 . set X=L ; otherwise, change X to the right pseudo ssn
 . quit:$data(ZTQUEUED)
 . write !!,$char(7)
 . write "Pseudo SSN adjusted to match edited name value ==> ",X
 . write !
 . quit
 ;
 if X'?9N do  quit  ; at this point, it better be 9 digits
 . kill X
 . quit
 ;
 if $get(DIUTIL)'="VERIFY FIELDS" do  quit:'$data(X)
 . new record set record=$order(^SAMI(311.101,"SSN",X,0))
 . if record>0,$data(^SAMI(311.101,record,0)) do
 . . kill X
 . . write $char(7),"  Already used by patient '",$piece(^(0),U),"'."
 . . quit
 . quit
 ;
 if $data(X),$extract(X)=9 do  quit
 . kill X
 . quit:$data(ZTQUEUED)
 . write !,$char(7),"  The SSN must not begin with 9."
 . quit
 ;
 if $data(X),$extract(X,1,3)="000",$extract(X,1,5)'="00000" do  quit
 . kill X
 . quit:$data(ZTQUEUED)
 . write !,$char(7),"   First three digits cannot be zeros."
 . quit
 ;
 if $data(X) do
 . new first3 set first3=$extract(X,1,3)
 . if first3>699,first3<729 do
 . . quit:$data(ZTQUEUED)
 . . write !!,$char(7),"      Note: This is a RR Retirement SSN."
 . . quit
 . quit
 ;
 if $data(X),$extract(X,1,5)="00000" do
 . quit:$data(ZTQUEUED)
 . write !!,$char(7),"      Note: This is a Test Patient SSN."
 . quit
 ;
 quit  ; end of SSN
 ;
 ;
 ;
PSEUDO ; generate pseudo-ssn
 ;
 ;;private;function;clean;silent;portable;0% tests
 ;
 ; @called-by:
 ;   SSNIN
 ; @calls:
 ;   CON: 
 ;   $$FINDFREE = find next free pseudo-ssn to avoid duplicates
 ; @input:
 ;   DA = record number
 ;  ]SAMIX = [optional] name to make a pseudo ssn for
 ;  ]SAMIDS(.08) = [optional] dob to make a pseudo ssn for
 ;  ^SAMI(311.101,DA,0) = sami intake header node
 ;  ^SAMI(311.101,"SSN") = index of assigned ssns
 ; @output:
 ;   L = new pseudo ssn for this sami intake record
 ;
 new name,dob
 if $data(DPTIDS(.03)),$data(DPTX) do
 . set name=SAMIX
 . set dob=SAMIDS(.08)
 . quit
 else  do
 . new header set header=^SAMI(311.101,DA,0)
 . set name=$piece(header,U)
 . set dob=$piece(header,U,3)
 . quit
 ;
 ; DG*5.3*621
 set:dob="" dob=2000000
 ;
 ; hash last, middle, and first initials
 new init3 set init3=$$HASH($extract($piece(name,",",2))) ; last
 new init2 set init2=$$HASH($extract($piece(name," ",2))) ; middle
 new init1 set init1=$$HASH($extract(name)) ; first
 ;
 ; pseudo ssn = hash initials, then mmdd, then yy, then P
 new pseudo
 set pseudo=init3_init2_init1_$extract(dob,4,7)_$extract(dob,2,3)_"P"
 ;
 if $data(^SAMI(311.101,"SSN",pseudo)) do
 . set pseudo=$$FINDFREE(pseudo)
 . quit
 ;
 quit pseudo ; return pseudo ssn ; end of $$PSEUDO
 ;
 ;
 ;
HASH(char) ; hash letter to digit
 ;
 ;;private;function;clean;silent;portable;0% tests
 ;
 ; @called-by:
 ;   $$PSEUDO: generate pseudo-ssn
 ; @input:
 ;   char = letter, initial of first, middle, or last name
 ; @output = digit from 0 to 9
 ;
 ; hash a letter to a digit from 1 to 9
 new digit set digit=$ascii(char)-65\3+1
 ;
 ; if char was the empty string, digit will be negative; change to 0
 set:digit<0 digit=0
 ;
 quit digit ; return hash ; end of $$HASH
 ;
 ;
 ;
FINDFREE(PSSN) ; find next free pseudo-ssn to avoid duplicates
 ;
 ;;private;function;clean;silent;portable;0% tests
 ;
 ; @called-by:
 ;   $$PSEUDO: generate pseudo-ssn
 ; @input:
 ;   PSSN = original pseudo-ssn that was already assigned
 ;   ^SAMI(311.101,"SSN") = index of assigned ssns
 ; @output = new pseudo-ssn that has not yet been assigned
 ;
 ; patch DG*5.3*866 no duplicate pseudo ssns
 ;
 for  set PSSN=PSSN+1_"P" quit:'$data(^SAMI(311.101,"SSN",PSSN))
 ;
 quit PSSN ; return pseudo-ssn ; end of $$FINDFREE
 ;
 ;
eor ; end of routine 
