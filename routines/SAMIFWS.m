SAMIFWS ;ven/gpl - elcap: form debugging web services ; 4/22/19 12:25pm
 ;;18.0;SAMI;;
 ;
 ; Routine SAMIFWS contains debugging subroutines that implement web
 ; services not needed in production but useful when troubleshooting.
 ; These form-specific web services for accessing the intake, background,
 ; and ct evaluation forms have been replaced in production by web
 ; service POST vapals, which handles all forms and reports now in the
 ; production application.
 ;
 ; When debugging problems with the forms it can be very useful to call
 ; them directly, bypassing the rest of the POST vapals logic. At such
 ; times, just recreate the record in file Web Service URl Handler for
 ; the form you want to call directly, use that to debug the form, and
 ; then when the problem has been resolved delete the record again.
 ;
 ; SAMIFWS contains no public entry points (see SAMIFORM).
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
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2019-01-08T20:59Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - VAPALS-ELCAP (SAMI)
 ;@version: 18.0T04 (fourth development version)
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev: Larry G. Carlson (lgc)
 ; lgc@vistaexpertise.net
 ;
 ;@module-credits [see SAMIFUL]
 ;
 ;@contents
 ; 
 ;
 ;@to-do
 ; add dmis to create & delete each form's debugging web service
 ;
 ;
 ;
 ;@section 1 code for web service interfaces
 ;
 ;
 ;
 ;@debug old wsi GET background
WSSBFORM ; background form access
 ;
 ;@signature
 ; do WSSBFORM^SAMIFORM(.SAMIRTN,.SAMIFILTER)
 ;@branches-from
 ; WSSBFORM^SAMIFORM
 ;@ppi-called-by: none [only when debugging]
 ;@called-by: none
 ;@calls
 ; $$GENSTDID^SAMIHOM3
 ; GETITEMS^SAMICAS2
 ; wsGetForm^%wf
 ;@thruput
 ;.SAMIRTN = name of root containing returned html (the prepared form)
 ;.SAMIFILTER = work-parameters array
 ; SAMIFILTER("debug") = 1 to debug some fields, 2 to debug more fields
 ; SAMIFILTER("errormessagestyle") = 2 (default) = use current error msg style
 ; SAMIFILTER("form") = form id (e.g., "vapals:sbform")
 ; SAMIFILTER("key") = graph key for saved form (e.g., "sbform-2019-07-01")
 ; SAMIFILTER("studyid") = patient study id (e.g., "XXX00045")
 ; SAMIFILTER("fvalue") = deprecated
 ;@tests
 ; UTWSSBF^SAMIUTF: background form access
 ;
 ; This was the old GET background web service, before ws POST vapals
 ; took over all form get and post functions. It is kept as a debugging
 ; tool.
 ;
 ; To recreate this web service for debugging, edit file Web Service URL
 ; Handler (17.6001) to create a new record with the following field
 ; values:
 ;
 ; field HTTP Verb (.01): GET
 ; field URI (1): background
 ; field Execution Endpoint (2): WSSBFORM^SAMIFORM
 ;
 ; When finished debugging, delete the record from the file.
 ;
 new sid set sid=$get(SAMIFILTER("studyid"))
 set:sid="" sid=$get(SAMIFILTER("sid"))
 set:sid>0 sid=$$GENSTDID^SAMIHOM3(sid)
 ; if sid="" set sid="XXX0001"
 ;
 ;new items do GETITEMS^SAMICAS2("items",sid)
 ; write !,"sid=",sid,!
 ; zwrite items
 ; break
 ;
 new key set key=$order(items("sbfor"))
 set SAMIFILTER("key")=key
 set SAMIFILTER("form")="vapals:sbform"
 do wsGetForm^%wf(.SAMIRTN,.SAMIFILTER)
 ;
 quit  ; end of WSSBFORM^SAMIFORM
 ;
 ;
 ;
 ;@debug old wsi GET intake
WSSIFORM ; intake form access
 ;
 ;@signature
 ; do WSSIFORM^SAMIFORM(.SAMIRTN,.SAMIFILTER)
 ;@branches-from
 ; WSSIFORM^SAMIFORM
 ;@ppi-called-by: none [only when debugging]
 ;@called-by: none
 ;@calls
 ; $$GENSTDID^SAMIHOM3
 ; GETITEMS^SAMICAS2
 ; wsGetForm^%wf
 ;@thruput
 ;.SAMIRTN = name of root containing returned html (the prepared form)
 ;.SAMIFILTER = work-parameters array
 ; SAMIFILTER("debug") = 1 to debug some fields, 2 to debug more fields
 ; SAMIFILTER("errormessagestyle") = 2 (default) = use current error msg style
 ; SAMIFILTER("form") = form id (e.g., "vapals:siform")
 ; SAMIFILTER("key") = graph key for saved form (e.g., "siform-2019-07-01")
 ; SAMIFILTER("studyid") = patient study id (e.g., "XXX00045")
 ; SAMIFILTER("fvalue") = deprecated
 ;@tests
 ; UTWSIFM^SAMIUTF: intake form access
 ;
 ; This was the old GET intake web service, before ws POST vapals
 ; took over all form get and post functions. It is kept as a debugging
 ; tool.
 ;
 ; To recreate this web service for debugging, edit file Web Service URL
 ; Handler (17.6001) to create a new record with the following field
 ; values:
 ;
 ; field HTTP Verb (.01): GET
 ; field URI (1): intake
 ; field Execution Endpoint (2): WSSIFORM^SAMIFORM
 ;
 ; When finished debugging, delete the record from the file.
 ;
 new sid set sid=$get(SAMIFILTER("studyid"))
 set:sid="" sid=$get(SAMIFILTER("sid"))
 set:sid>0 sid=$$GENSTDID^SAMIHOM3(sid,.SAMIFILTER)
 ; if sid="" set sid="XXX0001"
 ;
 ;new items do GETITEMS^SAMICAS2("items",sid)
 ; write !,"sid=",sid,!
 ; zwrite items
 ; break
 ;
 new key set key=$order(items("sifor"))
 set SAMIFILTER("key")=key
 set SAMIFILTER("form")="vapals:siform"
 do wsGetForm^%wf(.SAMIRTN,.SAMIFILTER)
 ;
 quit  ; end of WSSIFORM^SAMIFORM
 ;
 ;
 ;
 ;@debug old wsi GET ctevaluation
WSCEFORM ; ctevaluation form access
 ;
 ;@signature
 ; do WSCEFORM^SAMIFORM(.SAMIRTN,.SAMIFILTER)
 ;@branches-from
 ; WSCEFORM^SAMIFORM
 ;@ppi-called-by: none [only when debugging]
 ;@called-by: none
 ;@calls
 ; $$GENSTDID^SAMIHOM3
 ; GETITEMS^SAMICAS2
 ; wsGetForm^%wf
 ;@thruput
 ;.SAMIRTN = name of root containing returned html (the prepared form)
 ;.SAMIFILTER = work-parameters array
 ; SAMIFILTER("debug") = 1 to debug some fields, 2 to debug more fields
 ; SAMIFILTER("errormessagestyle") = 2 (default) = use current error msg style
 ; SAMIFILTER("form") = form id (e.g., "vapals:ceform")
 ; SAMIFILTER("key") = graph key for saved form (e.g., "ceform-2019-07-01")
 ; SAMIFILTER("studyid") = patient study id (e.g., "XXX00045")
 ; SAMIFILTER("fvalue") = deprecated
 ;@tests
 ; UTCEFRM^SAMIUTF: ctevaluation form access
 ;
 ; This was the old GET ctevaluation web service, before ws POST vapals
 ; took over all form get and post functions. It is kept as a debugging
 ; tool.
 ;
 ; To recreate this web service for debugging, edit file Web Service URL
 ; Handler (17.6001) to create a new record with the following field
 ; values:
 ;
 ; field HTTP Verb (.01): GET
 ; field URI (1): ctevaluation
 ; field Execution Endpoint (2): WSCEFORM^SAMIFORM
 ;
 ; When finished debugging, delete the record from the file.
 ;
 new sid set sid=$get(SAMIFILTER("studyid"))
 set:sid="" sid=$get(SAMIFILTER("sid"))
 set:sid>0 sid=$$GENSTDID^SAMIHOM3(sid)
 ; if sid="" set sid="XXX0001"
 ;
 ;new items do GETITEMS^SAMICAS2("items",sid)
 ; write !,"sid=",sid,!
 ; zwrite items
 ; break
 ;
 new key set key=$order(items("cefor"))
 set SAMIFILTER("key")=key
 set SAMIFILTER("form")="vapals:ceform"
 do wsGetForm^%wf(.SAMIRTN,.SAMIFILTER)
 ;
 quit  ; end of WSCEFORM^SAMIFORM
 ;
 ;
 ;
EOR ; end of routine SAMIFWS
