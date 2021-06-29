SAMITTW ;ven/gpl - text processing utilities ; 5/7/19 4:48pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; no entry from top
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
