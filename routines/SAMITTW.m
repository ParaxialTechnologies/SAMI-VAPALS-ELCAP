SAMITTW ;ven/gpl - text-processing utilities ;2021-07-01t21:37z
 ;;18.0;SAMI;**12**;2020-01;
 ;;1.18.0.12-t3+i12
 ;
 ; Routine SAMITTW contains subroutines for formatting text fields for
 ; VAPALS-ELCAP forms.
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
 ;@copyright: 2021, gpl, all rights reserved
 ;@license see routine SAMIUL
 ;
 ;@last-updated 2021-07-01t21:37z
 ;@application Screening Applications Management (SAM)
 ;@module Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files SAMI Forms (311.101-311.199)
 ;@version 1.18.0.12-t3+i12
 ;@release-date 2020-01
 ;@patch-list **12**
 ;
 ;@additional-dev Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@additional-dev Kenneth W. McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;
 ;@routine-log repo github.com:VA-PALS-ELCAP/SAMI-VAPALS-ELCAP.git
 ; 2021-06-29 ven/gpl 1.18.0.12-t2+i12 a5bbd37a
 ;  SAMITTW format text box for intake & followup notes; new text-
 ; processing utils.
 ;
 ; 2021-07-01 ven/mcglk&toad 1.18.0.12-t2+i12 cbf7e46b,fa794d60
 ;  SAMITTW bump version & dates, add hdr comments & dev log.
 ;
 ;@contents
 ; $$PRNTABLE remove non-printable characters except CR
 ; $$CRWRAP wrap text line based on margin or embedded CRLF
 ;
 ;
 ;
 ;@section 1 subroutines
 ;
 ;
 ;
PRNTABLE(ln) ; Extrinsic which removes all non-printable character except CR
 n zi,zn,ln2
 s ln2=""
 f zi=1:1:$l(ln) d  ;
 . s zn=$ASCII($e(ln,zi))
 . q:zn>126
 . q:zn<13
 . q:((zn>13)&(zn<30))
 . s ln2=ln2_$CHAR(zn)
 ;
 q ln2
 ;
 ;
 ;
CRWRAP(ln,dest,cnt,margin) ; extrinsic which will wrap a text line into
 ; multiple lines based on margin, which defaults to 80, or imbedded CRLF
 ; or CR. ln and margin are passed by value. dest is passed by name and
 ; cnt is passed by reference and is updated.
 ; extrinsic returns 1 if output was added to dest
 ;
 i $l(ln)<10 q 0  ; skip short fields
 s ln=$$PRNTABLE^SAMITTW(ln)
 ;s ^gpl("ln",$o(^gpl("ln"," "),-1)+1)=ln
 i '$d(margin) s margin=80
 i ln[$CHAR(13) d  q 1
 . n cr s cr=$char(13)
 . n crn s crn=$l(ln,$char(13))
 . i $l(ln,$char(13,10))=crn s cr=$char(13,10)
 . n i
 . f i=1:1:crn d  ;
 . . n eln s eln=""
 . . i cr=$char(13) s eln(1)=$p(ln,$char(13),i)
 . . i cr=$char(13,10) s eln(1)=$p(ln,$char(13,10),i)
 . . ;s ^gpl("note",i)=eln(1)
 . . q:eln(1)=""
 . . i $l(eln(1))>margin d wrap^%tt("eln",margin,dest) q
 . . n lnn s lnn=$o(@dest@(" "),-1)+1
 . . s @dest@(lnn)=eln(1)
 . ;
 i $l(ln)>margin d  q 1 ;
 . n eln s eln(1)=ln
 . d wrap^%tt("eln",margin,dest)
 ;
 q 0
 ;
 ;
 ;
EOR ; end of routine SAMITTW
