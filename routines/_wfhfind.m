%wfhfind ;ven/gpl-write form: html find/replace ;2018-03-01T21:32Z
 ;;1.8;Mash;
 ;
 ; %wfhfind implements the Write Form Library's html find & replace
 ; methods, for finding & then removing or replacing substrings in a
 ; line of html text.
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
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017/2018, gpl, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-01T21:32Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Write Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;
 ;@to-do: [tbd]
 ;
 ;@contents
 ; deleteBetween: code for ppi deleteBetween^%wf
 ;  find & delete text between 2 substrings
 ;
 ;
 ;@section 1 combination methods find+delete & find+replace
 ;
 ;
 ;
 ;@ppi-code deleteBetween^%wf
deleteBetween ; find & delete text between 2 substrings
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@signature
 ; deleteBetween^%wf(.line,begin,end,replace)
 ;@branches-from
 ; deleteBetween^%wf
 ;@ppi-called-by
 ; redactErr2^%wf
 ;@called-by: none
 ;@calls: none
 ;@throughput
 ;.line = line of html to change
 ;.line("low") = lowercase version of line for checks & searches
 ;@input
 ; before = substring preceding text to delete
 ; after = substring following text to delete
 ; replace = [optional] new text to replace deleted text
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; [description tbd]
 ; find before & after, delete text between them, optionally replace it,
 ; in line of html. Lowercase version of line is used to find matches, &
 ; it too is changed to keep it in synch with line.
 ;
 ;@stanza 2 find & delete/replace text
 ;
 quit:$get(line)=""  ; can't delete or replace in an empty line
 ;
 new to set to=$find(line("low"),after)-$length(after) ; 1st char after
 new from set from=$find(line("low"),before)-1 ; last char before
 new last set last=$length(line) ; last char in line
 ;
 set replace=$get(replace) ; get optional replacement value
 new haverep set haverep=replace]"" ; do we have one?
 ;
 set line=$extract(line,1,from)_replace_$extract(line,to,last)
 set line("low")=line ; *** NO ***
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of ppi deleteBetween^%wf
 ;
 ;
 ;
eor ; end of routine %wfhfind
