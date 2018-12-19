%hr ;ven/toad-host: run command ;2017-05-25T16:48Z
 ;;1.7;Mash;;May 25, 2017;
 ;;1.7T02;Mash;;2017-05-25;
 ;(c) 2016/2017, Vista Expertise Network, all rights reserved
 ;(l) licensed under VEN Partner License (file license-venpl-1p0.pdf)
 ;($) ven & ehs
 ;
 ; This Mumps Advanced Shell (mash) routine implements MASH
 ; Host API run^%h, Run Operating System Command.
 ;
 ;
 ; primary development
 ;
 ; primary developer: Frederick D. S. Marshall (toad)
 ; primary development organization: Vista Expertise Network (ven)
 ; cofunding organization: Electronic Health Solutions (ehs)
 ;
 ; additional developer: David J. Whitten (djw)
 ; additional developer: R. Wally Fort (rwf)
 ; additional developer: R. Chris Richardson (rcr)
 ; additional developer: Zach A. Gonzales (zag)
 ; additional developer: K.S. Bhaskar (ksb)
 ; additional developer: Sam M. Habiel (smh)
 ; additional developer: Linda M. R. Yaw (lmry)
 ; original development organization: U.S. Department of Veterans
 ;   Affairs, prev. Veterans Administration, National Development
 ;   Office in San Francisco (vaisf)
 ; additional development organization: VA Puget Sound (vapug)
 ; additional development organization: VA Houston (vahou)
 ; additional development organization: WorldVistA (wv)
 ; additional development organization: Fidelity (gtm)
 ;
 ; 2001-09-03 vapug/toad ZOSVGUX: create routine from ZOSVGTM, which
 ; was created from ZOSVVXD.
 ;
 ; 2001-11-18 vapug/toad & vahou/djw ZOSVGUX: create $$RETURN to run
 ; unix command, collect its output in a temp file, read the temp file
 ; back in, delete it, & return its contents, all to support GETENV,
 ; as advised by K.S. Bhaskar
 ; [first VISTA Porting Party (VCM) at Rice University in Houston,
 ; Texas].
 ;
 ; 2002-01-28 vapug/toad & vahou/djw ZOSVGUX: in $$RETURN, calculate
 ; temp directory using new extrinsic $$TEMP, which uses a new ~/t
 ; directory, instead of $zdir.
 ; [2nd VISTA Community Meeting, at the Birmingham VA Field Office,
 ; Birmingham, Alabama].
 ;
 ; 2003-09-03 vaisf/rwf XU*8*275 ZOSVGUX: formally create routine
 ; as part of Kernel; in $$RETURN, add "RET" to temp file name; in
 ; $$TEMP, replace ~/t with /tmp.
 ;
 ; 2006-12-07 vaisf/rwf XU*8*425 ZOSVGUX: in $$RETURN, put 99 second
 ; timeout on read; in $$TEMP, if defined get temp directory from
 ; field Primary HFS Directory (320) in file Kernel System Parameters
 ; (8989.3).
 ;
 ; 2011-10-10 ven/rcr XVCMND: create routine; use pipe instead of
 ; temp file; $$SUBMIT^XVCMND replaces $$RETURN^ZOSVGUX.
 ;
 ; 2011-10-31 ven/rcr XVCMND: add subroutines SSUBMIT, WRITELN,
 ; WRITETX, READLN, READTXT, OPENP, CLOSENP.
 ;
 ; 2011-11-15 ven/rcr XVCMND: add subroutine SBIG.
 ;
 ; 2012-03-06 kbaz/zag & ven/toad XVOU: create routine from XVCMND
 ; version 2011-10/10; refactor to MASH standards; rename $$SUBMIT
 ; -> RUN; third parameter (pipe name) eliminated.
 ;
 ; 2012-03-15 kbaz/zag & ven/toad ZOSVGUX: $$RETURN has the potential
 ; to change the current device, which might cause serious problems for
 ; jobs that have more than one device open when they call $$RETURN.
 ; For example, it is possible that calling GETENV^%ZOSV from within
 ; an RPC Broker job could seriously mess up the execution of the
 ; remote procedure by switching the current device from the null
 ; device to the TCP channel, causing garbage to be dumped on the
 ; line to the client and unpredictable client behavior to result.
 ; We are trying out a fix in which we record the current device
 ; before opening the temporary file and then using that device
 ; afterward to see if it stops an error that has been occurring
 ; in the auditing the activity of remote procedure TIU TEMPLATE
 ; GETTEXT.
 ;
 ; 2012-03-26 kbaz/zag & ven/toad ZOSVGUX: even fixed, $$RETURN is
 ; expensive, since it generates a temporary file to hold
 ; results, reopens it, reads its data back in, and deletes the
 ; file. GETENV calls it, and GETENV is called every time a new
 ; task submanager is started. We are experimenting with how to
 ; drive down the resource costs of running tasks and how to
 ; improve its response time. To that end, we are converting GETENV
 ; to abandon the use of $$RETURN and instead call RUN^XVOU, which
 ; uses GT.M's new pipes feature, which should be faster and more
 ; efficient. for now, change GETENV to call RUN^XVOU.
 ;
 ; 2012-07-30 ven/toad ZOSVGUX: finish filling in history to date.
 ;
 ; 2014-03-06 gtm/ksb ZOSVGUX: reset back to XU*8*499; $$RETURN replace
 ; use of file with pipe, including specifying shell.
 ;
 ; 2015-12-31 ven/toad %fou: create routine from XVOU. refactor
 ; to use %a* & %d* variables.
 ;
 ; 2016-01-05 ven/toad %fou: finish refactoring; use %g* & %io*;
 ; fill in primary development history.
 ;
 ; 2016-01-06 ven/toad %foux: create routine from %fou; rename
 ; %ion -> %iobn; add SAC to to-do list.
 ;
 ; 2016-02-02 ven/toad %foux: at Sam's reminder, add to to-do list to
 ; specify shell when opening a pipe, to avoid some degenerate cases
 ;
 ; 2016-05-24 ven/toad %foux: switch to more readable variable names,
 ; bring version number to 1.5, create orun^%f, update to-do list,
 ; create $$date to support $$horolog^%th.
 ;
 ; 2016-12-14/15 ven/toad ZOSVGUXH: create routine to store history &
 ; update to present, incl osehra work.
 ;
 ; 2016-12-19 ven/smh ZOSVGUX: RETURN add 1 second timeout to read.
 ;
 ; 2016-12-21 ven/toad %foux: run update history, specify shell when
 ; opening a pipe, to avoid some degenerate cases, one-second timeout
 ; on read.
 ;
 ; 2016-12-22/24 ven/toad %hr: renamespace under Mash Host, adjust
 ; comments, branch from API in %h, move date to date^%hd, add hidden
 ; test parameter to log steps and results.
 ;
 ; 2017-04-27 ven/lmry %*1.7T02 %hr: bump version to 1.7T02; stdize hdr
 ; lines.
 ;
 ; 2017-05-25 ven/toad %*1.7T02 %hr: update dates & chg history.
 ;
 ;
 ; contents
 ;
 quit  ; no entry from top
 ; run: code for run^%h: API Run Operating System Command
 ;
 ;
 ; to do
 ;
 ; gradually migrate all SAC violations out to %io* & %f*
 ; come up with a system of naming platform-specific subroutines
 ; come up with a system of compiling proper version for platform
 ; support cache on unix
 ; support mv1 on unix
 ;
 ;
 ;
run ; code for run^%h: API Run Operating System Command
 ;ven/toad;private;procedure;clean;silent;SAC VIOLATIONS:
 ;   1. open command = to acquire pipe & run command
 ;   2. gt.m open shell parameter = which unix shell to use
 ;   2. gt.m open command parameter = command to execute
 ;   3. gt.m open readonly parameter = limit device to input
 ;   4. gt.m open pipe mnemonic space = for pipe device
 ;   5. use command = to switch to pipe & back
 ;   6. close command = to release pipe
 ;   7. gt.m $zeof function = to detect end of pipe
 ; unit tests: none
 ; signature:
 ;   do run^%h(execute,[.]results)
 ; branches from:
 ;   run^%h
 ; calls: none
 ; input:
 ;   execute = unix command to execute
 ;   results = array to return results, pass by name [optional]
 ;        defaults to ^%u("%fo",$job) if results=""
 ;        defaults to .results if results undefined
 ; output:
 ;  .results(#) = #th line of command output [optional]
 ;      or
 ;  .results = command output [if only one line]
 ;      or
 ;  @results@(#) = #th line of command output [if pass by name]
 ; throughput:
 ;  .%hrlog [testing] = timing & results, if 1
 ;
 ; run host operating-system command, return output
 ;
 ; a. start timing
 set %hrlog(0)=$zut
 ;
 ; 1. id & clear results array
 if $data(results)[0 do  ; if pass by reference (results undefined)
 . kill results ; clear output array
 . set results="" ; set pass-by-reference flag
 . quit
 else  do  ; if pass by name
 . if results=""  ; if name is empty
 . . set results=$name(^%u("%hr",$job)) ; use default array
 . . quit
 . kill @results ; clear output array
 . quit
 set %hrlog(1)=$zut
 ;
 ; 2. id pipe
 new current set current=$io ; remember current device
 new pipe set pipe="%hr"_$job ; pipe name (unique to job)
 set %hrlog(2)=$zut
 ;
 ; 3. open pipe & run command
 ; pipe command results, specify shell to avoid degenerate cases
 open pipe:(shell="/bin/sh":command=execute:readonly)::"pipe"
 set %hrlog(3)=$zut
 ;
 ; 4. use pipe
 use pipe ; use pipe to read command output
 set %hrlog(4)=$zut
 ;
 ; 5. read command results in from pipe
 new linenum ; output line #
 for linenum=1:1 do  quit:$zeof  ; read until end of pipe
 . new line ; buffer command output
 . read line:1 ; read next line of command output
 . quit:$length(line)<1  ; skip formfeed at end of command output
 . if results="" do  ; if pass by reference
 . . set results(linenum)=line ; build array of command output
 . . quit
 . else  do  ; if pass by name
 . . set @results@(linenum)=line ; build array of command output
 . . quit
 . quit
 set linenum=linenum-1 ; ends = # lines + 1
 set %hrlog(5)=$zut
 ;
 ; 6. handle one-line results
 if results="",linenum=1 do  ; if pass by reference, one line output
 . set results=results(1) ; set top node to result
 . kill results(1) ; and clear array
 . quit
 set %hrlog(6)=$zut
 ;
 ; 7. close pipe
 close pipe ; close pipe
 set %hrlog(7)=$zut
 ;
 ; 8. restore original device
 use current ; restore current device
 set %hrlog(8)=$zut
 ;
 quit  ; end of run^%h
 ;
 ;
eor ; end of %hr
