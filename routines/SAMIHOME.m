SAMIHOME ;ven/gpl - ielcap forms ;Sep 18,2017@18:01
 ;;18.0;SAM;;
 ;
 ; Routine SAMIFRM contains subroutines for managing the ELCAP forms,
 ; including initialization and enhancements to the SAMI FORM FILE (311.11)
 ;
 ; Primary Development History
 ;
 ; @primary-dev: George P. Lilly (gpl)
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;   http://vistaexpertise.net
 ; @copyright: 2017, Vista Expertise Network (ven), all rights reserved
 ; @license: Apache 2.0
 ;   https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @last-updated: 2017-09-19T11:01Z
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
 ; 2017-09-19 ven/gpl v18.0t01 SAMIFRM: initialize the SAMI FORM file from elcap-patient graphs,
 ; using mash tools and graphs (%yottaq,^%wd)
 ;
 ;
 ; contents
 ;
 ;
 ;
 ;
 Q
 ;
wsHOME(rtn,filter) ; web service entry point for the SAMI home page
 ; no parameters required
 ;
 d devhome(.rtn,.filter) ; temporary home page for development
 q
 ;
devhome(rtn,filter) ; temporary home page for development
 ;
 n gtop,gbot
 d htmltb2^%yottaweb(.gtop,.gbot,"SAMI Test Patients")
 ;
 n html,ary,hpat
 d patlist("hpat")
 q:'$d(hpat)
 ;
 s ary("title")="SAMI Test Patients on this system"
 s ary("header",1)="StudyId"
 s ary("header",2)="Name"
 ;
 n cnt s cnt=0
 n zi s zi=""
 f  s zi=$o(hpat(zi)) q:zi=""  d  ;
 . s cnt=cnt+1
 . n url s url="<a href=""/cform.cgi?studyId="_zi_""">"_zi_"</a>"
 . s ary(cnt,1)=url
 . s ary(cnt,2)=""
 ;
 d genhtml^%yottautl("html","ary")
 ;
 d addary^%yottautl("rtn","gtop")
 d addary^%yottautl("rtn","html")
 s rtn($o(rtn(""),-1)+1)=gbot
 k rtn(0)
 ;
 s HTTPRSP("mime")="text/html"
 q
 ;
patlist(ary) ; returns a list of patients in ary, passed by name
 ;
 n groot s groot=$$setroot^%wd("elcap-patients")
 ;
 k @ary
 n zi s zi=""
 f  s zi=$o(@groot@("graph",zi)) q:zi=""  d  ;
 . s @ary@(zi)=""
 q
 ;
