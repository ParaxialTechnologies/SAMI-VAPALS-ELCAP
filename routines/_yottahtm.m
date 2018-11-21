%yottahtm ;ven/gpl-yottadb extension: graphstore ;2018-02-07T19:33Z
 ;;1.8;Mash;
 ;
 ; %yottahtm implements the Yottadb Extension Library's toppage
 ; ppi. This may eventually migrate to another Mash namespace,
 ; tbd. In the meantime, it will be added to a new %yotta ppi
 ; library.
 ; It is currently untested & in progress.
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
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-07T19:33Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Yottadb Extension - %yotta
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@module-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017, gpl
 ;@funding: 2017, ven
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
 ; 2017-02-27 ven/gpl %*1.8t01 %yottahtm: create routine to hold
 ; the yottadb toppage method.
 ;
 ; 2017-09-16 ven/gpl %*1.8t01 %yottahtm: update
 ;
 ; 2017-09-12 ven/gpl %*1.8t01 %yottahtm: update
 ;
 ; 2017-09-18 ven/gpl %*1.8t01 %yottahtm: update
 ;
 ; 2018-02-07 ven/toad %*1.8t04 %yottahtm: passim add white space &
 ; hdr comments & do-dot quits, tag w/Apache license & attribution
 ; & to-do to shift namespace later, break up a few long lines.
 ;
 ;@to-do
 ; %yotta: create entry points in ppi/api style
 ; r/all local calls w/calls through ^%yotta
 ; change branches from %yotta
 ; renamespace elsewhere, research best choice
 ;
 ;@contents
 ; toppage: build the starting page of hashtag counts
 ;
 ;
 ;
 ;@section 1 code to implement ppis & apis
 ;
 ;
 ;
toppage(rtn,filter) ; build the starting page of hashtag counts
 ;
 new kbaii,gtop,gbot,table,groot,zcnt
 do htmltb2^%yottaweb(.gtop,.gbot,"#see query engine")
 set rtn=$name(^tmp("kbaiwsai",$job))
 kill @rtn
 merge @rtn=gtop
 set groot=$name(@$$setroot^%yottagr@("graph"))
 set table("title")="tags by count"
 set table("header",1)="tag"
 set table("header",2)="tag count"
 set kbaii="" set zcnt=0
 new k2
 for  set kbaii=$order(@groot@("tagbycount",kbaii),-1) quit:kbaii=""  do  ;
 . set k2=""
 . for  set k2=$order(@groot@("tagbycount",kbaii,k2)) quit:k2=""  do  ;
 . . new ztag
 . . set ztag=k2
 . . set zcnt=zcnt+1
 . . if zcnt>2000 quit  ; max rows
 . . set table(zcnt,1)="<a href=""see/tag:"_ztag_""">"_"#"_ztag_"</a>"
 . . set table(zcnt,2)=kbaii
 . . quit
 . quit
 do genhtml^%yottautl(rtn,"table")
 kill @rtn@(0)
 set HTTPRSP("mime")="text/html"
 set @rtn@($order(@rtn@(""),-1)+1)=gbot
 ;
 quit  ; end of toppage
 ;
 ;
 ;
eor ; end of routine %yottahtm
