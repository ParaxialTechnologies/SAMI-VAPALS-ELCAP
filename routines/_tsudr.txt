%tsudr ;ven/toad-type string: documentation, replace ;2018-02-22T18:14Z
 ;;1.8;Mash;
 ;
 ; %tsud introduces the public string datatype Replace library,
 ; whose code is implemented in the %tsr* routines.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; It contains no executable software.
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
 ;@copyright: 2012/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-22T18:14Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 ;@section 1 Replace library notes
 ;
 ;
 ;
 ;@to-do
 ;
 ; bring over & write unit tests for:
 ;   $$strip^%ts
 ;   $$trim^%ts
 ;   $$place^%ts
 ;   $$find^%ts
 ;   $$only^%ts
 ;   $$produce^%ts
 ;   $$replace^%ts
 ;   $$repeat^%ts
 ; develop schema for long & short names, keep above as mnemonic names
 ; revise $$replace to accept multiple strings
 ; revise $$produce to accept multiple strings
 ; multi-string case conversions & $$replace [JJOHCASE & DILF]
 ; tie max string length in $$repeat to standard and/or implementation
 ; add max length protection to $$produce
 ;
 ;
 ;
eor ; end of routine %tsudr
