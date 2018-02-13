%wfhinput ;ven/gpl-write form: html input tag ;2018-02-11T15:12Z
 ;;1.8;Mash;
 ;
 ; %wfhradio implements the Write Form Library's html radio button
 ; & checkbox ppis.
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development: see routine %wful
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-11T15:12Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Write Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;
 ;@to-do
 ; write unit tests
 ;
 ;@contents
 ; uncheck: code for ppi uncheck^%wf, uncheck radio button or checkbox
 ; check: code for ppi check^%wf, check radio button or checkbox
 ;
 ;
 ;
 ;@section 1 radio/checkbox manipulation
 ;
 ;
 ;
uncheck ; code for ppi uncheck^%wf, uncheck radio button or checkbox
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do uncheck^%wf(.ln)
 ;@branches-from
 ; uncheck^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; replace^%wf
 ;@throughput
 ;.ln =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; removes 'check="checked"' from ln, passed by reference
 ;
 ;@stanza 2 uncheck box or button
 ;
 if ln["checked=" do  ;
 . do replace^%wf(.ln,"checked=""checked""","")
 . if ln["checked=checked" do replace^%wf(.ln,"checked=checked","")
 . quit
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of uncheck^%wf
 ;
 ;
 ;
check ; code for ppi check^%wf, check radio button or checkbox
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; do check^%wf(.line,type)
 ;@branches-from
 ; check^%wf
 ;@ppi-called-by
 ; wsGetForm^%wf
 ;@called-by: none
 ;@calls
 ; replace^%wf
 ;@input
 ; type = 
 ;@throughput
 ;.line = 
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; for radio buttons & checkbox
 ;
 ;@stanza 2 check box or button
 ;
 new ln set ln=line
 if line["type=""" do replace^%wf(.line,"type="""_type_"""","type="""_type_"""  checked=""checked""")
 else  do replace^%wf(.line,"type="_type,"type="_type_"  checked=""checked""")
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of check^%wf
 ;
 ;
 ;
eor ; end of routine %wfhinput
