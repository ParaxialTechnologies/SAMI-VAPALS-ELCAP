SAMIDSSN ;ven/toad - dd: ssn in sami intake ; 1/22/19 1:28pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; Routine SAMIDSSN contains code that supports the data dictionary
 ; of field Social Security Number (.09) in file SAMI Intake (311.101).
 ; CURRENTLY UNTESTED & IN PROGRESS
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017-2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-06T00:02Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T04 (fourth development version)
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@original-dev: ALB/JDS
 ;@original-dev: ALB/LBD
 ;
 ;@module-credits
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log
 ; 2017-08-16 ven/toad v18.0t01 SAMIDD1: create from routine DGRPDD1
 ; for input transform for field Social Security Number (.09) in file
 ; SAMI Intake (311.101); copy over ssn-related subroutines & apply
 ; mdc pattern-language style for sustainability.
 ;
 ; 2017-08-17 ven/toad v18.0t01 SAMIDSSN: rename routine, finish
 ; replacing PSEU with $$PSEUDO, rename SSN => SSNIN & repurpose as the
 ; code to implement ddi SSNIN^SAMIDD.
 ;
 ; 2018-01-03 ven/toad v18.0t04 SAMIDSSN: shift ddi to SSNIN^SAMID,
 ; section & stanza terminology; passim.
 ;
 ; 2018-02-05 ven/toad v18.0t04 SAMIDSSN: upgrade license & attribution.
 ;
 ;@to-do
 ; annotate fully & split routine if needed
 ; develop examples, tests, mini-meter calls, and timers
 ;
 ;@contents
 ; SSNIN: code for ddi SSNIN^SAMID, input xform for .09 in 311.101
 ; PSEU: generate pseudo-ssn
 ; $$HASH: hash letter to digit
 ; $$FINDFREE = find next free pseudo-ssn to avoid duplicates
 ;
 ;
 ;
 ;@section 1 SSN input-transform ddi code & subroutines
 ;
 ;
 ;
SSNIN ; code for ddi SSNIN^SAMID, input xform for .09 in 311.101
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;procedure;clean;silent;0% tests;sac
 ;@signature:
 ; do SSNIN^SAMID(.X,SAMIUPDATE)
 ;@branches-from:
 ; SSNIN^SAMID
 ;@calls:
 ; $$PSEUDO: generate pseudo-ssn
 ;@throughput:
 ; X = in as proposed external value for field Social Security Number
 ;   (.09) in file SAMI Intake (311.101)
 ;  out as validated internal value for field
 ;   undefined if X was not a valid external value for field
 ;@input:
 ;]ZTQUEUED = [optional] set if taskman is running this code
 ;]SAMIZNV = [optional] controls handling of X = pseudo ssn
 ;  either way, will recalculate to see what pseudo ssn should be
 ;  if not defined, SSN will reject pseudo if it doesn't match
 ;  if defined, SSN will update the pseudo ssn to new value
 ;]DIUTIL = [optional] defined if running Fileman Utility Options
 ;  if running VERIFY FIELDS, won't reject ssn for being in use
 ;^SAMI(311.101,"SSN") = index of assigned ssns
 ;^SAMI(311.101,#,0) = sami intake record for an assigned ssn
 ;@examples: [tbd]
 ;@tests: [tbd]
 ;
 ;@stanza 2 strip punctuation
 ;
 if X'?.AN do  ; if we have punctuation, probably dashes
 . new POS
 . for POS=1:1:$length(X) do:$extract(X,POS)?1P
 . . set $extract(X,POS)="" ; strip the punctuation
 . . ; this pulls next character to current position
 . . set POS=POS-1 ; so back up to check next character
 . . quit
 . quit
 ;
 ;@stanza 3 handle pseudo-ssn
 ;
 if X="P"!(X="p") do  quit  ; if asked to generate a PSEUDO ssn
 . set X=$$PSEUDO(X) ; replace P/p w/pseudo ssn
 . write:'$data(ZTQUEUED) "  ",X
 . quit
 ;
 if X["P",'$data(SAMIZNV) do  quit  ; if fixed pseudo ssn
 . new PSEUDO set PSEUDO=$$PSEUDO(X) ; what's the right pseudo ssn?
 . quit:X=PSEUDO  ; we're fine if X is the right pseudo ssn
 . kill X ; otherwise, reject it
 . write *7,"  Invalid pseudo SSN."
 . write !,"Type 'P' for the valid one"
 . quit
 ;
 if X["P",$data(SAMIZNV) do  quit  ; if variable pseudo ssn
 . new PSEUDO set PSEUDO=$$PSEUDO(X) ; what's the right pseudo ssn?
 . quit:X=L  ; we're fine if X is the right pseudo ssn
 . set X=L ; otherwise, change X to the right pseudo ssn
 . quit:$data(ZTQUEUED)
 . write !!,$char(7)
 . write "Pseudo SSN adjusted to match edited name value ==> ",X
 . write !
 . quit
 ;
 ;@stanza 4 reject invalid syntax
 ;
 if X'?9N do  quit  ; at this point, it better be 9 digits
 . kill X
 . quit
 ;
 ;@stanza 5 prevent duplicate ssn
 ;
 if $get(DIUTIL)'="VERIFY FIELDS" do  quit:'$data(X)
 . new RECORD set RECORD=$order(^SAMI(311.101,"SSN",X,0))
 . if RECORD>0,$data(^SAMI(311.101,RECORD,0)) do
 . . kill X
 . . write $char(7),"  Already used by patient '",$piece(^(0),U),"'."
 . . quit
 . quit
 ;
 ;@stanza 6 reject ssn special invalid cases
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
 ;@stanza 7 note ssn special valid cases
 ;
 if $data(X) do
 . new FIRST3 set FIRST3=$extract(X,1,3)
 . if FIRST3>699,FIRST3<729 do
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
 ;@stanza 8 termination
 ;
 quit  ; end of SSNIN^SAMID
 ;
 ;
 ;
PSEUDO ; generate pseudo-ssn
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;function;clean;silent;0% tests;sac
 ;@called-by:
 ; SSNIN
 ;@calls:
 ; CON: 
 ; $$FINDFREE = find next free pseudo-ssn to avoid duplicates
 ;@input:
 ; DA = record number
 ;]SAMIX = [optional] name to make a pseudo ssn for
 ;]SAMIDS(.08) = [optional] dob to make a pseudo ssn for
 ;^SAMI(311.101,DA,0) = sami intake header node
 ;^SAMI(311.101,"SSN") = index of assigned ssns
 ;@output:
 ; L = new pseudo ssn for this sami intake record
 ;@examples: [tbd]
 ;@tests: [tbd]
 ;
 ;@stanza 2 calculate preferred hash
 ;
 new NAME,DOB
 if $data(DPTIDS(.03)),$data(DPTX) do
 . set NAME=SAMIX
 . set DOB=SAMIDS(.08)
 . quit
 else  do
 . new HEADER set HEADER=^SAMI(311.101,DA,0)
 . set NAME=$piece(HEADER,U)
 . set DOB=$piece(HEADER,U,3)
 . quit
 ;
 ; DG*5.3*621
 set:DOB="" DOB=2000000
 ;
 ; hash last, middle, and first initials
 new INIT3 set INIT3=$$HASH($extract($piece(NAME,",",2))) ; last
 new INIT2 set INIT2=$$HASH($extract($piece(NAME," ",2))) ; middle
 new INIT1 set INIT1=$$HASH($extract(NAME)) ; first
 ;
 ; pseudo ssn = hash initials, then mmdd, then yy, then P
 new PSEUDO
 set PSEUDO=INIT3_INIT2_INIT1_$extract(DOB,4,7)_$extract(DOB,2,3)_"P"
 ;
 ;@stanza 3 find free hash if necessary
 ;
 if $data(^SAMI(311.101,"SSN",PSEUDO)) do
 . set PSEUDO=$$FINDFREE(PSEUDO)
 . quit
 ;
 ;@stanza 4 termination
 ;
 quit PSEUDO ; return PSEUDO ssn ; end of $$PSEUDO
 ;
 ;
 ;
HASH(CHAR) ; hash letter to digit
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;function;clean;silent;0% tests;sac
 ;@called-by:
 ; $$PSEUDO: generate pseudo-ssn
 ;@input:
 ; char = letter, initial of first, middle, or last name
 ;@output = digit from 0 to 9
 ;@examples: [tbd]
 ;@tests: [tbd]
 ;
 ;@stanza 2 hash letter to digit
 ;
 ; hash a letter to a digit from 1 to 9
 new DIGIT set DIGIT=$ascii(CHAR)-65\3+1
 ;
 ; if char was the empty string, digit will be negative; change to 0
 set:DIGIT<0 DIGIT=0
 ;
 ;@stanza 3 termination
 ;
 quit DIGIT ; return hash ; end of $$HASH
 ;
 ;
 ;
FINDFREE(PSSN) ; find next free pseudo-ssn to avoid duplicates
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;function;clean;silent;0% tests;sac
 ;@called-by:
 ; $$PSEUDO: generate pseudo-ssn
 ;@input:
 ; PSSN = original pseudo-ssn that was already assigned
 ;^SAMI(311.101,"SSN") = index of assigned ssns
 ;@output = new pseudo-ssn that has not yet been assigned
 ;@examples: [tbd]
 ;@tests: [tbd]
 ;
 ; patch DG*5.3*866 no duplicate pseudo ssns
 ;
 ;@stanza 2 use ssn index to find next free pseudo-ssn
 ;
 for  set PSSN=PSSN+1_"P" quit:'$data(^SAMI(311.101,"SSN",PSSN))
 ;
 ;@stanza 3 termination
 ;
 quit PSSN ; return pseudo-ssn ; end of $$FINDFREE
 ;
 ;
 ;
EOR ; end of routine 
