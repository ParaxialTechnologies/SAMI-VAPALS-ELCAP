%h ;ven/toad-host: supported references ;2017-05-25T16:28Z
 ;;1.7;Mash;;May 25, 2017;
 ;;1.7T02;Mash;;2017-05-25;
 ;(c) 2016/2017, Vista Expertise Network, all rights reserved
 ;(l) licensed under VEN Partner License (file license-venpl-1p0.pdf)
 ;($) ven & ehs
 ;
 ; This Mumps Advanced Shell (mash) routine contains all publicly
 ; supported MASH Host application programmer interfaces. The MASH
 ; Host module provides portable access to the platform-specific
 ; capabilities of the underlying host operating system.
 ;
 ;
 ; primary development:
 ;
 ; primary developer: Frederick D. S. Marshall (toad)
 ; primary development organization: Vista Expertise Network (ven)
 ; cofunding organization: Electronic Health Solutions (ehs)
 ;
 ; additional developer: Linda M. R. Yaw (lmry)
 ;
 ; 2016-01-06 ven/toad %*0.6 %f: create routine w/ osrunix & our.
 ;
 ; 2016-05-24 ven/toad %*1.5 %f: bump version to 1.5; remove osrunix;
 ; rename our -> run; create $$odate.
 ;
 ; 2016-12-21 ven/toad %*1.5 %f: orun^%f support passing results by
 ; reference, update comments.
 ;
 ; 2016-12-22/24 ven/toad %*1.7D01 %h: bump version to 1.7D01;
 ; renamespace under %h for host, since all APIs so far are about the
 ; host operating system instead of files, corresponding changes to
 ; %foux, change calls to branches to code, move orun^%foux to run^%hr
 ; & odate^%foux to date^%hd, apply new @API standard; add %hrlog param
 ; to run.
 ;
 ; 2017-04-27 ven/lmry %*1.7T02 %h: bump version to 1.7T02; stdize hdr
 ; lines.
 ;
 ; 2017-05-25 ven/toad %*1.7T02 %h: update dates & chg history.
 ;
 ;
 ; contents
 ;
 ;
 quit  ; no entry from top
 ;
 ;
 ; @API run^%h, Run Operating System Command
run(execute,results,%hrlog) goto run^%hr
 ;
 ;
 ; @API date^%h, Run Operating System Command
date() goto date^%hd
 ;
 ;
eor ; end of %h
