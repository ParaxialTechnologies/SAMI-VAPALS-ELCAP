%tsumc ;ven/toad - type string: ^%tsc meter ;2018-12-19T21:48Z
 ;;1.8;Mash;
 ;
 ; %tsumc implements meters for the Mash String Library on GT.M
 ; on Unix operating systems.
 ; See %tsud for documentation introducing the String library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; It contains one direct-mode interface for running timers
 ; & reporting performance.
 ; %tsumc contains no public entry points.
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
 ;@copyright: 2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-12-19T21:48Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;@routine-log
 ;
 ; 2018-12-14/19 ven/toad %*1.8t04 %tsumc: create routine as a
 ; timer for ^%tsc subroutines (based on routine XUSCNTUM); convert
 ; to use ^%ums calls.
 ;
 ;@timing-date: 2018-12-14
 ;@timing-system: avicenna (dev,jvvsam-18.0-vep)
 ;@cpu: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz (dual core)
 ;@ram: 4Gb
 ;@os: Linux Ubuntu 16.04.4 LTS (xenial)
 ;@mumps: GT.M V6.3-000A Linux x86_64
 ;
 ; timing performed with Taskman & all other Vista jobs shut down
 ; except for the timing job itself. 10,000 iterations were done
 ; and the duration of the call averaged. values are in microseconds
 ;
 ;
 ;
 ;@section 1 meter for string-case library
 ;
 ;
 ;
 ;@ppi-meter ^%tsc
case ; (string-case ppis)
 ;
 new %tsumsg
 do system^%ums
 ;
 do time^%ums(.%tsumsg,"upalpha^%tsumc")
 do time^%ums(.%tsumsg,"lowalpha^%tsumc")
 do time^%ums(.%tsumsg,"upcase^%tsumc")
 do time^%ums(.%tsumsg,"lowcase^%tsumc")
 do time^%ums(.%tsumsg,"capcase^%tsumc")
 do time^%ums(.%tsumsg,"invcase^%tsumc")
 do time^%ums(.%tsumsg,"sencase^%tsumc")
 ;
 quit  ; end of meter case^%tsumc
 ;
 ;
 ;
 ;@section 2 timers for string-case library
 ;
 ;
 ;
upalpha ;@timer a. upalpha^%ts
 new string
 set %umst1=$zut set string=$$upalpha^%ts set %umst2=$zut
 quit  ; end of upalpha
 ;
 ;
 ;
lowalpha ;@timer b. lowalpha^%ts
 new string
 set %umst1=$zut set string=$$lowalpha^%ts set %umst2=$zut
 quit  ; end of lowalpha
 ;
 ;
 ;
upcase ;@timer c. upcase^%ts
 new string set string="Snow falls on the trees."
 set %umst1=$zut set string=$$upcase^%ts(string) set %umst2=$zut
 quit  ; end of upcase
 ;
 ;
 ;
lowcase ;@timer d. lowcase^%ts
 new string set string="SNOW FALLS ON THE TREES."
 set %umst1=$zut set string=$$lowcase^%ts(string) set %umst2=$zut
 quit  ; end of lowcase
 ;
 ;
 ;
capcase ;@timer e. capcase^%ts
 new string set string="snow falls on the trees."
 set %umst1=$zut set string=$$capcase^%ts(string) set %umst2=$zut
 quit  ; end of capcase
 ;
 ;
 ;
invcase ;@timer f. invcase^%ts
 new string set string="sNOW fALLS oN tHE tREES."
 set %umst1=$zut set string=$$invcase^%ts(string) set %umst2=$zut
 quit  ; end of invcase
 ;
 ;
 ;
sencase ;@timer g. sencase^%ts
 new string set string="snow falls on the trees."
 set %umst1=$zut set string=$$sencase^%ts(string) set %umst2=$zut
 quit  ; end of sencase
 ;
 ;
 ;
eor ; end of routine %tsumc
