SAMIFDM ;ven/gpl - elcap: form dmi code ; 5/8/19 1:47pm
 ;;18.0;SAMI;;
 ;
 ; Routine SAMIFDM contains subroutines for processing the ELCAP forms,
 ; specifically code to implement SAMIFORM's direct-mode interfaces.
 ; SAMIFDM contains no public entry points (see SAMIFORM).
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
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2019, gpl, all rights reserved
 ;@license: [see SAMIUL]
 ;
 ;@last-updated: 2019-01-17T16:30Z
 ;@application: Screening Applications Management (SAM)
 ;@module: VAPALS-ELCAP (SAMI)
 ;@version: 18.0T04 (fourth development version)
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@module-credits [see SAMIFUL]
 ;
 ;@contents
 ; INIT: code for dmi INIT^SAMIFORM
 ;  initilize all available forms
 ; INIT1: init 1 form from array
 ;
 ; REGISTER: code for dmi REGISTER^SAMIFORM
 ;  register elcap forms in form mapping file
 ;
 ; IMPORT: code for dmi IMPORT^SAMIFORM
 ;  import json-data directory into elcap-patient graph
 ; GETDIR: prompt user for directory
 ; PRSFLNM: parse filename extracting studyid & form
 ; GETFN: prompt user for filename
 ;
 ;
 ;
 ;@section 1 code for dmi INIT^SAMIFORM
 ;
 ;
 ;
 ;@dmi-code INIT^SAMIFORM
INIT ; initilize form file from elcap-patient graphs
 ;
 ;@signature
 ; do INIT^SAMIFORM
 ;@branches-from
 ; INIT^SAMIFORM
 ;@called-by: none (dmi)
 ;@calls
 ; $$setroot^%wd
 ; getVals^%wf
 ; INIT1
 ;@input
 ; patient's graph in graphstore vapals-patients
 ;@output (for each form)
 ; form-creation report written to current device
 ; form's record in file SAMI Form Mapping (311.11) updated
 ;@tests
 ; UTINITF^SAMIUTF2: initilize form file from elcap-patient graphs
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 quit:root=""
 new groot set groot=$name(@root@("graph")) ; i am groot
 new patient set patient=$order(@groot@(""),-1) ; use last patient in graph
 quit:patient=""
 ;
 ; for each form patient has:
 ;
 new form set form=""
 for  set form=$order(@groot@(patient,form)) quit:form=""  do
 . new SAMIARRAY
 . do getVals^%wf("SAMIARRAY",form,patient) ; get array of fields & values
 . write !,"using patient: ",patient
 . do INIT1(form,"SAMIARRAY") ; initialize form & its fields
 . quit
 ;
 quit  ; end of dmi INIT^SAMIFORM
 ;
 ;
 ;
INIT1(form,ary) ; initialize one form
 ;
 ;@called-by
 ; INIT
 ;@calls
 ; UPDATE^DIE
 ; CLEAN^DILF
 ;@input
 ; form = form name
 ; ary = name of array containing form field names
 ; @ary@(field name) = value
 ;@output
 ; form-creation report written to current device
 ; form's record in file SAMI Form Mapping (311.11) updated
 ;@tests
 ; UTINITF^SAMIUTF2: initilize form file from elcap-patient graphs
 ; UTINITF1^SAMIUTF2: initialize one form named form from ary passed by name
 ;  (placeholder, not needed)
 ;
 ; INIT1 creates or updates the record in file SAMI Form Mapping (311.11)
 ; describing the form and its variables.
 ;
 write !,form ; display form name
 ;zwrite @ary ; display getVals array (form fields & values)
 new fn set fn=311.11 ; file SAMI Form Mapping
 new sfn set sfn=311.11001 ; subfile Variable
 new fmroot set fmroot=$name(^SAMI(311.11)) ; data-global root
 ;
 write !,"creating form ",form
 new SAMIFDA set SAMIFDA(fn,"?+1,",.01)=form ; field Form
 new SAMIERR ; updater error array
 do UPDATE^DIE("","SAMIFDA","","SAMIERR") ; create/update record
 if $data(SAMIERR) do  quit  ; report updater problems
 . write !,"error creating form record ",form,!
 .; zwrite SAMIERR ; show fileman dbs error array
 . quit
 ;
 new %ien set %ien=$order(@fmroot@("B",form,"")) ; get form ien
 if %ien="" do  quit  ; report if can't find form's ien
 . write !,"error locating form record ",form
 . quit
 ;
 kill SAMIFDA ; start new filer data array
 new vcnt set vcnt=0 ; count variables, to use as subfile iens
 new %j set %j=""
 for  set %j=$order(@ary@(%j)) quit:%j=""  do  ; traverse variable names
 . set vcnt=vcnt+1 ; next subfile ien
 . set SAMIFDA(sfn,"?+"_vcnt_","_%ien_",",.01)=%j ; field Variable
 . quit
 ;
 do CLEAN^DILF ; clear dbs error/help/message arrays
 ;
 write !,"creating variables for form ",%ien
 do UPDATE^DIE("","SAMIFDA","","SAMIERR") ; create/update subfile
 if $data(SAMIERR) do  quit  ; report updater problems
 . write !,"error creating variable record ",%j,!
 .; zwrite SAMIERR ; show fileman dbs error array
 . quit
 ;
 quit  ; end of INIT1
 ;
 ;
 ;
 ;@section 2 code for dmi REGISTER^SAMIFORM
 ;
 ;
 ;
 ;@dmi REGISTER^SAMIFORM
REGISTER ; register elcap forms in form mapping file
 ;
 ;@signature
 ; do REGISTER^SAMIFORM
 ;@branches-from
 ; REGISTER^SAMIFORM
 ;@called-by: none (dmi)
 ;@calls
 ; UPDATE^DIE
 ;@input: none
 ;@output
 ; simple form-creation report written to current device
 ; 8 vapals-elcap records in file SAMI Form Mapping (311.11) updated
 ;@tests
 ; UTREGF^SAMIUTF2: register elcap forms in form mapping file
 ;
 ; create records for eight vapals-elcap forms in file
 ; SAMI Form Mapping (311.11); does not create variable names in
 ; subfile Variable, unlike INIT.
 ;
 new fn set fn=311.11 ; file SAMI Form Mapping
 new sfn set sfn=311.11001 ; subfile Variable
 new fmroot set fmroot=$name(^SAMI(311.11)) ; data-global root
 ;
 ; table of forms
 ;
 new ftbl
 set ftbl("bxform","Biopsy_Mediastinoscopy Form.html")=""
 set ftbl("ceform","CT Evaluation Form.html")=""
 set ftbl("sbform2","Background Form.html")=""
 set ftbl("fuform","Follow-up Form.html")=""
 set ftbl("siform","Intake Form.html")=""
 set ftbl("rbform","Intervention and Treatment Form.html")=""
 set ftbl("ptform","PET Evaluation Form.html")=""
 set ftbl("sintake","Schedule Contact.html")=""
 ;
 new zi set zi=""
 for  set zi=$order(ftbl(zi)) quit:zi=""  do  ;
 . write !,"creating form ",zi," named: ",$order(ftbl(zi,""))
 . new SAMIFDA set SAMIFDA(fn,"?+1,",.01)=zi ; field Form
 . set SAMIFDA(fn,"?+1,",2)=$order(ftbl(zi,"")) ; field HTML Template Name
 . new SAMIERR
 . do UPDATE^DIE("","SAMIFDA","","SAMIERR")
 . if $data(SAMIERR) do  quit  ; report updater error
 . . write !,"error creating form record ",zi,!
 . .; zwrite SAMIERR
 . . quit
 . ;
 . new %ien set %ien=$order(@fmroot@("B",zi,""))
 . if %ien="" do  quit  ; report if can't find form ien
 . . write !,"error locating form record ",zi
 . . quit
 . quit
 ;
 quit  ; end of dmi REGISTER^SAMIFORM
 ;
 ;
 ;
 ;@section 3 code for dmi IMPORT^SAMIFORM
 ;
 ;
 ;
 ;@dmi IMPORT^SAMIFORM
IMPORT ; import json-data directory into elcap-patient graph
 ;
 ;@signature
 ; do IMPORT^SAMIFORM
 ;@branches-from
 ; IMPORT^SAMIFORM
 ;@called-by: none (dmi)
 ;@calls
 ; GETDIR
 ; file2ary^%wd
 ; $$setroot^%wd
 ; DECODE^VPRJSON
 ; PRSFLNM
 ;@input
 ; all json data in selected directory
 ;@output
 ; graphstore updated with that data
 ;@tests
 ; UTLOADD^SAMIUTF2: import directory full of json data into elcap-patient graph
 ;
 ; CHANGE ven/lgc 20190328 - account for unit test
 ;    and change directory to repo
 ; prompt for directory if not Unit Test
 ;
 ; new SAMIDIR
 if '$data(%ut) do  quit:SAMIDIR=""  ; quit if user exited
 . set SAMIDIR="/home/osehra/www/sample-data-20171129/" ; default
 . ;
 . do GETDIR(.SAMIDIR) ; prompt user
 else
 set SAMIDIR="/home/osehra/lib/silver/va-pals/docs/unit-test-data/"
 ;
 ;
 ; collect list of all files in directory into SAMILIST
 ;
 ;new cmd set cmd="""ls "_SAMIDIR_" > /home/osehra/tmp/sample-list.txt"""
 new cmd set cmd="ls "_SAMIDIR_" > /home/osehra/tmp/sample-list.txt"
 ;zsystem @cmd ; ***** SAC: call run^%s instead *****
 new output do run^%h(cmd,.output)
 ;
 new SAMILIST
 do file2ary^%wd("SAMILIST","/home/osehra/tmp/","sample-list.txt")
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 new zi set zi=""
 for  set zi=$order(SAMILIST(zi)) quit:zi=""  do  ;
 . new filename set filename=$get(SAMILIST(zi))
 . quit:filename=""
 . ;
 . if $length(filename,"-")'=5 write !,"file "_filename_" rejected" quit  ;
 . if filename'[".json" write !,"file "_filename_" rejected" quit  ;
 . ;
 . new SAMIJSON ; json data loaded from file
 . do file2ary^%wd("SAMIJSON",SAMIDIR,filename)
 . ;
 . new SAMIARY ; graph built from json data
 . do DECODE^VPRJSON("SAMIJSON","SAMIARY")
 . quit:'$data(SAMIARY)
 . ;
 . new studyid,form ; get patient study id & form name
 . do PRSFLNM(filename,.studyid,.form)
 . ;
 . ; load graph into graphstore under patient & form
 . merge @root@("graph",studyid,form)=SAMIARY
 . quit
 ;
 quit  ; end of IMPORT
 ;
 ;
 ;
PRSFLNM(fn,zid,zform) ; parse filename extracting studyid & form
 ;
 ;@called-by
 ; IMPORT
 ;@calls: none
 ;@input
 ; fn = file name
 ;@output
 ; zid = patient study id
 ; zform = form id (form name & date)
 ;@tests
 ; UTPARSFN^SAMIUTF2: parse filename extracting studyid & form
 ;@examples
 ; do PRSFLNM("XXX0001-bxform-2004-02-01",.studyid,.form)
 ;  yields
 ;  studyid="XXX0001"
 ;  form="bxform-2004-02-01"
 ;
 ; patient study id
 set zid=$piece(fn,"-",1)
 ;
 ; form id
 new loc set loc=$find(fn,"-")
 set zform=$extract(fn,loc,$length(fn))
 set zform=$piece(zform,".",1)
 ;
 quit  ; end of PRSFLNM
 ;
 ;
 ;
GETDIR(SAMIDIR) ; prompt user for directory
 ;
 ;@called-by
 ; IMPORT
 ;@calls
 ; ^DIR
 ;@input
 ; user input on current device
 ; .SAMIDIR = default directory, default default = "/home/osehra/www/"
 ;@output = 1 if user entered a directory, else 0
 ; prompt on current device
 ; .SAMIDIR = directory entered, or "" if user exited
 ;@tests
 ; UTGETDIR^SAMIUTF2: prompt user for directory
 ;
 new DIR set DIR(0)="F^3:240" ; free text
 set DIR("A")="File Directory" ; prompt
 set:$get(SAMIDIR)="" SAMIDIR="/home/osehra/www/" ; default default
 set DIR("B")=SAMIDIR ; default
 set SAMIDIR="" ; assume failure
 new DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 ;
 do:'$data(%ut) ^DIR ; prompt user if live
 set:$data(%ut) Y="/home/osehra/www/sample-data-UnitTest/" ; if test
 ;
 set:"^"'[Y SAMIDIR=Y ; directory entered (except ^-escape or timeout)
 ;
 quit  ; end of GETDIR
 ;
 ;
 ;
GETFN(SAMIFN) ; prompt for file name
 ;
 ;@called-by
 ; [none yet, but will be called by IMPORT later]
 ;@calls
 ; ^DIR
 ;@input
 ; user input on current device
 ; .SAMIFN = default file name, default default = "outpatient-list.txt"
 ;@output = 1 if user entered a file name, else 0
 ; prompt on current device
 ; .SAMIFN = entered file name, or "" if user exited
 ;@tests
 ; UTGETFN^SAMIUTF2: prompt user for file name
 ;  (placeholder, not tested yet due to read)
 ;
 new DIR set DIR(0)="F^3:240" ; free text
 set DIR("A")="File Name" ; prompt
 set:$get(SAMIFN)="" SAMIFN="outpatient-list.txt" ; default default
 set DIR("B")=SAMIFN ; default
 set SAMIFN="" ; assume failure
 new DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 ;
 do:'$data(%ut) ^DIR ; prompt user
 set:$data(%ut) Y="sample-data-unit-test.txt" ; if test
 ;
 set:"^"'[Y SAMIFN=Y ; file name entered (except ^-escape or timeout)
 ;
 quit  ; end of GETFN
 ;
 ;
 ;
EOR ; end of routine SAMIFDM
