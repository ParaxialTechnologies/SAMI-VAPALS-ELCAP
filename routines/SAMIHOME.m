SAMIHOME ;ven/gpl - ielcap: forms ;2018-02-08T20:13Z
 ;;18.0;SAM;;
 ;
 ; Routine SAMIHOME contains subroutines for implementing the ELCAP Home
 ; Page.
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
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-08T20:13Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
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
 ; 2018-01-13 ven/gpl v18.0t04 SAMIHOME: create routine from SAMIFRM to
 ; implement ELCAP Home Page.
 ;
 ; 2018-02-05 ven/toad v18.0t04 SAMIHOME: update license & attribution &
 ; hdr comments, add white space & do-dot quits, spell out language
 ; elements.
 ;
 ;@contents
 ; wsHOME: web service entry point for the SAMI home page
 ; devhome: temporary home page for development
 ; patlist: returns a list of patients in ary, passed by name
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
wsHOME(rtn,filter) ; web service entry point for the SAMI home page
 ;
 ; no parameters required
 ;
 do devhome(.rtn,.filter) ; temporary home page for development
 ;
 quit  ; end of wsHOME
 ;
 ;
 ;
devhome(rtn,filter) ; temporary home page for development
 ;
 new gtop,gbot
 do htmltb2^%yottaweb(.gtop,.gbot,"SAMI Test Patients")
 ;
 new html,ary,hpat
 do patlist("hpat")
 quit:'$data(hpat)
 ;
 set ary("title")="SAMI Test Patients on this system"
 set ary("header",1)="StudyId"
 set ary("header",2)="Name"
 ;
 new cnt set cnt=0
 new zi set zi=""
 for  set zi=$order(hpat(zi)) quit:zi=""  do  ;
 . set cnt=cnt+1
 . new url set url="<a href=""/cform.cgi?studyId="_zi_""">"_zi_"</a>"
 . set ary(cnt,1)=url
 . set ary(cnt,2)=""
 . quit
 ;
 do genhtml^%yottautl("html","ary")
 ;
 do addary^%yottautl("rtn","gtop")
 do addary^%yottautl("rtn","html")
 set rtn($order(rtn(""),-1)+1)=gbot
 kill rtn(0)
 ;
 set HTTPRSP("mime")="text/html"
 ;
 quit  ; end of devhome
 ;
 ;
 ;
patlist(ary) ; returns a list of patients in ary, passed by name
 ;
 new groot set groot=$$setroot^%wd("elcap-patients")
 ;
 kill @ary
 new zi set zi=""
 for  set zi=$order(@groot@("graph",zi)) quit:zi=""  do  ;
 . set @ary@(zi)=""
 . quit
 ;
 quit  ; end of patlist
 ;
 ;
 ;
EOR ; end of routine SAMIHOME
