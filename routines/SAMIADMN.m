SAMIADMN ; VEN/ARC - IELCAP: Admin tools ;2018-05-03T22:35Z
 ;;1.0;SAMI;;
 ;
 ; Primary development:
 ;
 ; Author: Alexis Carlson (ARC)
 ; Primary development organization: Vista Expertise Network (VEN)
 ;
 ; 2018-05-03 VEN/ARC:
 ; Create entry point to clear M Web Server files cache
 ;
 ;
 quit ; No entry from top
 ;
 ;
ClrWeb ; Clear the M Web Server files cache
 ;VEN/ARC;test;procedure;dirty;silent;non-sac
 ;
 d purgegraph^%wd("html-cache")
 d purgegraph^%wd("seeGraph")
 d build^%yottagr
 ;
 quit  ; end of CLRWEB
 ;
 ;
EOR ; End of routine SAMIADMN
