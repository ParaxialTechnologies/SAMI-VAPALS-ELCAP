%hd ;ven/toad-host: date ;2017-05-25T16:39Z
 ;;1.7;Mash;;May 25, 2017;
 ;;1.7T02;Mash;;2017-05-25;
 ;(c) 2016/2017, Vista Expertise Network, all rights reserved
 ;(l) licensed under VEN Partner License (file license-venpl-1p0.pdf)
 ;($) ven & ehs
 ;
 ; This Mumps Advanced Shell (mash) routine implements MASH
 ; Host API date^%h, now with nanosecond precision.
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
 ; 2016-05-24 ven/toad %*1.5 %foux: bump version to 1.5; create $$date
 ; to support $$horolog^%th.
 ;
 ; 2016-12-22 ven/toad %*1.7D01 %hd: bump version to 1.7D01; date
 ; renamespace under Mash Host, move to separate routine, branch from
 ; API in %h.
 ;
 ; 2017-04-27 ven/lmry %*1.7T02 %hd: bump version to 1.7T02; stdize hdr
 ; lines.
 ;
 ; 2017-05-25 ven/toad %*1.7T02 %hd: update dates & chg history.
 ;
 ;
 ; contents
 ;
 quit  ; no entry from top
 ; date = $$date^%h, API Now with Nanosecond Precision
 ;
 ;
 ; to do
 ;
 ; move unix date command to a table look it up
 ; gradually migrate all SAC violations out to %io* & %f*
 ; come up with a system of naming platform-specific subroutines
 ; come up with a system of compiling proper version for platform
 ; support cache on unix
 ; support mv1 on unix
 ; consider namespace reorg within Mash
 ;
 ;
 ;
date() ; code for API $$date^%h, Now with Nanosecond Precision
 ;ven/toad;private;function;clean;silent;SAC VIOLATION:
 ;   1. date command = print system date and time
 ; unit tests: none
 ; signature:
 ;   $$date^%h
 ; branches from:
 ;   $$date^%h
 ; calls:
 ;   $$run^%h = run unix command, return output
 ;   unix date --rfc-3339='ns'
 ; input: none
 ; output = unix now, nanosecond precision
 ;
 ; set command to get system date and time to nanosecond precision
 new %hdate set %hdate="date --rfc-3339='ns'" ; 
 new %hnow do run^%h(%hdate,"%hnow") ; convert $horolog to iso
 set %hnow=%hnow(1) ; shift result to top node
 ;
 quit %hnow ; return unix now, nanosecond precision ; end of $$date^%h
 ;
 ;
eor ; end of %hd
