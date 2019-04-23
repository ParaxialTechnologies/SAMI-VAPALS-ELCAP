SAMIFORM ;ven/gpl - ielcap: form library ; 4/23/19 10:08am
 ;;18.0;SAMI;;
 ;
 ; Routine SAMIFORM contains the vapals-elcap form library.
 ; SAMIFORM contains private program interfaces, direct-mode
 ; interfaces, and web-service interfaces.
 ; It contains no public entry points.
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
 ;@last-updated: 2019-01-08T19:58Z
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
 ; LOAD: ppi, process html line, e.g., load json data into graph
 ;
 ; $$GETLAST5 = ppi, last5 for patient sid
 ; FIXSRC: ppi, fix html src lines to use resources in see/
 ; FIXHREF: ppi, fix html href lines to use resources in see/
 ;
 ; $$GETNAME = ppi, name for patient sid
 ; $$GETSSN = ppi, ssn for patient sid
 ;
 ; INIT: dmi, initialize all available forms
 ; REGISTER: dmi, register elcap forms in form mapping file
 ; IMPORT: dmi, import json-data directory into elcap-patient graph
 ;
 ; WSSBFORM: wsi GET background, background form access
 ; WSSIFORM: wsi GET intake, intake form access
 ; WSCEFORM: wsi GET ctevaluation, ctevaluation form access
 ;
 ;
 ;
 ;@section 1 form-load & case-review private program interfaces
 ;
 ;
 ;
 ;@ppi LOAD^SAMIFORM, process html line, e.g., load json data into graph
LOAD(SAMILINE,form,sid,SAMIFILTER,SAMILNUM,SAMIHTML,SAMIVALS) goto LOAD^SAMIFLD
 ;
 ;
 ;
 ;@ppi $$GETLAST5^SAMIFORM, last5 for patient sid
GETLAST5(sid) goto GETLAST5^SAMIFLD
 ;
 ;
 ;
 ;@ppi FIXSRC^SAMIFORM, fix html src lines to use resources in see/
FIXSRC(SAMILINE) goto FIXSRC^SAMIFLD
 ;
 ;
 ;
 ;@ppi FIXHREF^SAMIFORM, fix html href lines to use resources in see/
FIXHREF(SAMILINE) goto FIXHREF^SAMIFLD
 ;
 ;
 ;
 ;@ppi-code $$GETNAME^SAMIFORM, name for patient sid
GETNAME(sid) goto GETNAME^SAMIFLD
 ;
 ;
 ;
 ;@ppi-code $$GETSSN^SAMIFORM, ssn for patient sid
GETSSN(sid) goto GETSSN^SAMIFLD
 ;
 ;
 ;
 ;@section 2 direct-mode interfaces
 ;
 ;
 ;
 ;@dmi INIT^SAMIFORM, initilize all available forms
INIT goto INIT^SAMIFDM
 ;
 ;
 ;
 ;@dmi REGISTER^SAMIFORM, register elcap forms in form mapping file
REGISTER goto REGISTER^SAMIFDM
 ;
 ;
 ;
 ;@dmi IMPORT^SAMIFORM, import json-data directory into elcap-patient graph
IMPORT goto IMPORT^SAMIFDM
 ;
 ;
 ;
 ;@section 3 web-service interfaces
 ;
 ;
 ;
 ;@debug old wsi GET background, background form access
WSSBFORM(SAMIRTN,SAMIFILTER) goto WSSBFORM^SAMIFWS
 ;
 ;
 ;
 ;@debug old wsi GET intake, intake form access
WSSIFORM(SAMIRTN,SAMIFILTER) goto WSSIFORM^SAMIFWS
 ;
 ;
 ;
 ;@debug old wsi GET ctevaluation, ctevaluation form access
WSCEFORM(SAMIRTN,SAMIFILTER) goto WSCEFORM^SAMIFWS
 ;
 ;
 ;
EOR ; end of routine SAMIFORM
