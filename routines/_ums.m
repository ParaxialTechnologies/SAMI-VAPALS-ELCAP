%ums ;ven/toad - m-meter: statistical tools ;2018-12-19T20:45Z
 ;;1.8;Mash;
 ;
 ; %ums implements statistical tools for the Mash M-Meter on GT.M
 ; on Unix operating systems. This toolkit does most of the work
 ; of any meter written to time performance of an opus.
 ; See %umud for documentation introducing the String library.
 ; See %umul for the module's primary-development log.
 ; See %um for the module's ppis & apis.
 ; It contains one direct-mode interface for running timers
 ; & reporting performance.
 ; %ums contains no public entry points.
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
 ;@copyright: 2016/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-12-19T20:45Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: M-Meter - %um
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;@routine-log
 ;
 ; 2018-12-14/19 ven/toad %*1.8t04 %ums: create routine as general
 ; timer toolkit, based on routine %tsumc & XUSCNTUM.
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
system ; report system profile
 ;
 write !!!
 ;
 do
 . new horo set horo=$zhorolog
 . new days set days=$piece(horo,",")
 . new seconds set seconds=$piece(horo,",",2)
 . new offset set offset=$piece(horo,",",4)
 . ;
 . set seconds=seconds+offset
 . set:seconds<0 days=days-1,seconds=seconds+86400
 . set:seconds>86400 days=days+1,seconds=seconds-86400
 . set horo=days_","_seconds
 . new fileman set fileman=$$HTFM^XLFDT(horo)
 . ;
 . new date set date=$piece(fileman,".")
 . new datelen set datelen=$length(date)
 . new year set year=$extract(date,1,datelen-4)+1700
 . new month set month=$extract(date,datelen-3,datelen-2)
 . new day set day=$extract(date,datelen-1,datelen)
 . set date=year_"-"_month_"-"_day
 . ;
 . new time set time=$piece(fileman,".",2)_"000000"
 . new hour set hour=$extract(time,1,2)
 . new minute set minute=$extract(time,3,4)
 . new second set second=$extract(time,5,6)
 . set time=hour_":"_minute_":"_second_"Z"
 . ;
 . new isodate set isodate=date_"T"_time
 . ; 2018-12-19T19:11:47Z
 . ;
 . write !," ;@timing-date: ",isodate
 . quit
 ;
 do
 . new Y do GETENV^%ZOSV
 . new uci set uci=$piece(Y,"^")
 . new volume set volume=$piece(Y,"^",2)
 . new system set system=$piece(Y,"^",3)_" ("_uci_","_volume_")"
 . ; avicenna (dev,jvvsam-18.0-vep)
 . ;
 . write !," ;@timing-system: ",system
 . quit
 ;
 do
 . new %umsinfo
 . do run^%h("cat /proc/cpuinfo",.%umsinfo)
 . ;
 . new line5 set line5=%umsinfo(5)
 . new cpu set cpu=$piece(line5,": ",2)
 . ; Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz (dual core)
 . ;
 . write !," ;@cpu: ",cpu
 . quit
 ;
 do
 . new %umsinfo
 . do run^%h("free",.%umsinfo)
 . ;
 . new line2 set line2=%umsinfo(2)
 . set $extract(line2,1,4)=""
 . set line2=$$trim^%ts(line2,"L")
 . new ram set ram=line2\1000000_" GB" ; 4GB
 . ;
 . write !," ;@ram: ",ram
 . quit
 ;
 do
 . new %umsinfo
 . do run^%h("lsb_release -a",.%umsinfo)
 . ;
 . new desc set desc=$piece(%umsinfo(3),":"_$char(9),2)
 . new codename set codename=$piece(%umsinfo(5),":"_$char(9),2)
 . new os set os="Linux "_desc_" ("_codename_")"
 . ; Linux Ubuntu 16.04.4 LTS (xenial)
 . ;
 . write !," ;@os: ",os
 . quit
 ;
 do
 . new mumps set mumps=$zyrelease_" ("_$zversion_")"
 . write !," ;@mumps: ",mumps
 . quit
 ;
 write !," ;"
 write !," ; timing performed with all other Vista jobs shut down."
 write !," ; 10,000 iterations were done and the duration of the call averaged."
 write !," ;  values are in microseconds"
 ;
 quit  ; end of system
 ;
 ;
 ;
 ;@section 2 main statistical subroutines
 ;
 ;
 ;
setup(%umsg) ; set up timing pass
 ;
 ;
 set %umsg("count")=10000
 set %umsg("max")=0
 kill %umsg("median")
 set %umsg("min")=999999999
 kill %umsg("mode")
 set %umsg("total")=0
 ;
 quit  ; end of setup
 ;
 ;
 ;
record(%umsg,%umt0,%umt1) ; calculate & record statistics
 ;
 set %umt0=$get(%umt0)
 quit:$get(%umt0)'=+$get(%umt0)
 ;
 set %umt1=$get(%umt1)
 quit:$get(%umt1)'=+$get(%umt1)
 ;
 new time set time=%umt1-%umt0
 set %umsg("total")=%umsg("total")+time
 set:time<%umsg("min") %umsg("min")=time
 set:time>%umsg("max") %umsg("max")=time
 set %umsg("mode",time)=$get(%umsg("mode",time))+1
 set:%umsg("mode",time)>$get(%umsg("mode")) %umsg("mode")=%umsg("mode",time)_U_time
 ;
 quit  ; end of record
 ;
 ;
 ;
report(%umsg) ; calculate & report timing statistics
 ;
 set %umsg("mean")=%umsg(total)/%umsg(count)
 new mean set mean="mean:"_$fnumber(%umsg("mean"),",")
 new time set time=""
 new cnt set cnt=0
 ;
 for  do  quit:time=""
 . set time=$order(%umsg("mode",time))
 . quit:time=""
 . new occ set occ=%umsg("mode",time)
 . new add
 . for add=1:1:occ do
 . . set cnt=cnt+1
 . . set %umsg("median",cnt)=time
 . . quit
 . quit
 ;
 new med1 set med1=%umsg("median",count)\2
 new med2 set med2=%umsg("median",count)\2+1
 set %umsg("median")=med1+med2/2
 new median set median="median:"_$fnumber(%umsg("median"),",")
 ;
 new mode set mode="mode:"_$fnumber($piece(%umsg("mode"),U,2),",")
 new count set count="count:"_$fnumber(%umsg("count"),",")
 new total set total="total:"_$fnumber(%umsg("total"),",")
 new min set min="min:"_$fnumber(%umsg("min"),",")
 new max set max="max:"_$fnumber(%umsg("max"),",")
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
eor ; end of routine %ums
