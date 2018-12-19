%tsumc ;ven/toad - type string: ^%tsc meter ;2018-12-19T20:36Z
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
 ;@last-updated: 2018-12-19T20:36Z
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
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;timer;procedure;clean;silent;mdc;NO tests
 ;@signature
 ; do case^%tsumc
 ;@called-by: none
 ;@calls
 ; setup
 ; record
 ; report
 ; upalpha^%ts
 ; lowalpha^%ts
 ; upcase^%ts
 ; lowcase^%ts
 ; capcase^%ts
 ; invcase^%ts
 ; sencase^%ts
 ;@input: none
 ;@output: report to screen
 ;
 ; The Mumps String Case Library ppis branch to simple top-down
 ; subroutines, so each need only be timed once.
 ;
 ;@stanza 2 general initialization
 ;
 new %tsumsg
 do system^%ums
 ;
 ;@stanza 3 upalpha^%ts timer
 ;
 set timer=" ;@timing a. upalpha^%ts timer"
 new string,t0,t1
 do setup^%ums(.%tsumsg)
 for count=1:1:count do
 . set t0=$zut set string=$$upalpha^%ts set t1=$zut
 . do record^%ums(.%tsumsg,t0,t1)
 . quit
 do report^%ums(.%tsumsg)
 ;
 ;@stanza 4 lowalpha^%ts timer
 ;
 set timer=" ;@timing b. lowalpha^%ts timer"
 kill string,t0,t1
 do setup^%ums(.%tsumsg)
 for count=1:1:count do
 . set t0=$zut set string=$$lowalpha^%ts set t1=$zut
 . do record^%ums(.%tsumsg,t0,t1)
 . quit
 do report^%ums(.%tsumsg)
 ;
 ;@stanza 5 upcase^%ts timer
 ;
 set timer=" ;@timing c. upcase^%ts timer"
 kill string,t0,t1
 do setup^%ums(.%tsumsg)
 for count=1:1:count do
 . set string="Snow falls on the trees."
 . set t0=$zut set string=$$upcase^%ts(string) set t1=$zut
 . do record^%ums(.%tsumsg,t0,t1)
 . quit
 do report^%ums(.%tsumsg)
 ;
 ;@stanza 6 lowcase^%ts timer
 ;
 set timer=" ;@timing d. lowcase^%ts timer"
 kill string,t0,t1
 do setup^%ums(.%tsumsg)
 for count=1:1:count do
 . set string="SNOW FALLS ON THE TREES."
 . set t0=$zut set string=$$lowcase^%ts(string) set t1=$zut
 . do record^%ums(.%tsumsg,t0,t1)
 . quit
 do report^%ums(.%tsumsg)
 ;
 ;@stanza 7 capcase^%ts timer
 ;
 set timer=" ;@timing e. capcase^%ts timer"
 kill string,t0,t1
 do setup^%ums(.%tsumsg)
 for count=1:1:count do
 . set string="snow falls on the trees."
 . set t0=$zut set string=$$capcase^%ts(string) set t1=$zut
 . do record^%ums(.%tsumsg,t0,t1)
 . quit
 do report^%ums(.%tsumsg)
 ;
 ;@stanza 8 invcase^%ts timer
 ;
 set timer=" ;@timing f. invcase^%ts timer"
 kill string,t0,t1
 do setup^%ums(.%tsumsg)
 for count=1:1:count do
 . set string="sNOW fALLS oN tHE tREES."
 . set t0=$zut set string=$$invcase^%ts(string) set t1=$zut
 . do record^%ums(.%tsumsg,t0,t1)
 . quit
 do report^%ums(.%tsumsg)
 ;
 ;@stanza 9 sencase^%ts timer
 ;
 set timer=" ;@timing g. sencase^%ts timer"
 kill string,t0,t1
 do setup^%ums(.%tsumsg)
 for count=1:1:count do
 . set string="snow falls on the trees."
 . set t0=$zut set string=$$sencase^%ts(string) set t1=$zut
 . do record^%ums(.%tsumsg,t0,t1)
 . quit
 do report^%ums(.%tsumsg)
 ;
 quit  ; end of timer case^%tsumc
 ;
 ;
 ;
 ;@section 2 main statistical subroutines
 ;
 ;
 ;
setup ; set up timing pass
 ;
 ;
 set count=10000
 set max=0
 kill median
 set min=999999999
 kill mode
 set total=0
 ;
 quit  ; end of setup
 ;
 ;
 ;
record ; calculate & record statistics
 ;
 new time set time=t1-t0
 set total=total+time
 set:time<min min=time
 set:time>max max=time
 set mode(time)=$get(mode(time))+1
 set:mode(time)>$get(mode) mode=mode(time)_U_time
 ;
 quit  ; end of record
 ;
 ;
 ;
report ; calculate & report timing statistics
 ;
 new mean set mean="mean:"_$fnumber(total/count,",")
 new time set time=""
 new cnt set cnt=0
 ;
 for  do  quit:time=""
 . set time=$order(mode(time))
 . quit:time=""
 . new occ set occ=mode(time)
 . new add
 . for add=1:1:occ do
 . . set cnt=cnt+1
 . . set median(cnt)=time
 . . quit
 . quit
 ;
 new med1 set med1=median(count\2)
 new med2 set med2=median(count\2+1)
 set median="median:"_$fnumber(med1+med2/2,",")
 set mode="mode:"_$fnumber($piece(mode,U,2),",")
 set count="count:"_$fnumber(count,",")
 set total="total:"_$fnumber(total,",")
 set min="min:"_$fnumber(min,",")
 set max="max:"_$fnumber(max,",")
 ;
 write !!,timer
 new stats set stats=count_","_total_","_min_","_max_","_mean_","_median_","_mode
 new stat
 for stat="count","total","min","max","mean","median","mode" do
 . write !," ; ",@stat
 . quit
 ;
 quit  ; end of report
 ;
 ;
 ;
eor ; end of routine %tsumc
