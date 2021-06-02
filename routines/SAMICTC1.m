SAMICTC1 ;ven/gpl - ceform copy ;2021-05-25T15:44Z
 ;;18.0;SAMI;**11**;2020-01;Build 21
 ;;1.18.0.11+i11
 ;
 ; SAMICTC1 & 2 selectively copy fields from a patient's most recent
 ; existing CT Evaluation Form to a brand new form when it is created.
 ; They support the Create Form feature of the Case Review Page.
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@license: see routine SAMIUL
 ;@documentation see SAMICTUL
 ;@contents
 ; CTCOPY copy ct eval form selectively
 ; GENCTCPY generates copy routine from graph
 ;
 ;
 ;
 ;@section 1 wsi WSREPORT & related subroutines
 ;
 ;
 ;
 ;@ppi CTCOPY^SAMICTC1
CTCOPY(FROM,TO,key) ; copy ct eval form selectively
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac
 ;@called-by
 ; MKCEFORM^SAMICAS3
 ; MKPTFORM^SAMICAS3
 ; MKBXFORM^SAMICAS3
 ;@calls
 ; CTCOPY2^SAMICTC2
 ;@input
 ; FROM = existing source form array root
 ; TO = new target form array root
 ; key = form key, e.g. ceform-2021-05-25
 ;@output
 ; @TO: selected fields copied f/source form t/target form
 ;
 ;
 ;@stanza 2 copy is it new fields
 ;
 if $get(key)="" set key="ce"
 ;
 if key'["ce" do  ; all forms except ct eval form
 . set @TO@("cect1ch")=$get(@FROM@("cect1ch"))
 . set @TO@("cect2ch")=$get(@FROM@("cect2ch"))
 . set @TO@("cect3ch")=$get(@FROM@("cect3ch"))
 . set @TO@("cect4ch")=$get(@FROM@("cect4ch"))
 . set @TO@("cect5ch")=$get(@FROM@("cect5ch"))
 . set @TO@("cect6ch")=$get(@FROM@("cect6ch"))
 . set @TO@("cect7ch")=$get(@FROM@("cect7ch"))
 . set @TO@("cect8ch")=$get(@FROM@("cect8ch"))
 . set @TO@("cect9ch")=$get(@FROM@("cect9ch"))
 . quit
 ;
 else  do  ;
 . new cei,isnew,savals
 . set savals("pw")="" ; Prev seen, resolved
 . set savals("px")="" ; Prev seen, not a nodule 
 . set savals("pr")="" ; Prev seen, resected
 . set savals("pk")="" ; Not in outside report
 . set savals("pv")="" ; Not included in scan
 . for cei=1:1:9 do  ;
 . . set isnew=$get(@FROM@("cect"_cei_"ch"))
 . . q:isnew=""
 . . if $data(savals(isnew)) set @TO@("cect"_cei_"ch")=isnew
 . . quit
 . quit
 ;
 ;
 ;@stanza 3 copy most fields
 ;
 ; the following is generated from a graph - see GENCTCOPY below
 set @TO@("ceanod")=$get(@FROM@("ceanod")) ; 
 set @TO@("cennod")=$get(@FROM@("cennod")) ; 
 ;
 set @TO@("cect1en")=$get(@FROM@("cect1en")) ; Endobronchial
 set @TO@("cect2en")=$get(@FROM@("cect2en")) ; Endobronchial
 set @TO@("cect3en")=$get(@FROM@("cect3en")) ; Endobronchial
 set @TO@("cect4en")=$get(@FROM@("cect4en")) ; Endobronchial
 set @TO@("cect5en")=$get(@FROM@("cect5en")) ; Endobronchial
 set @TO@("cect6en")=$get(@FROM@("cect6en")) ; Endobronchial
 set @TO@("cect7en")=$get(@FROM@("cect7en")) ; Endobronchial
 set @TO@("cect8en")=$get(@FROM@("cect8en")) ; Endobronchial
 set @TO@("cect9en")=$get(@FROM@("cect9en")) ; Endobronchial
 set @TO@("cect10en")=$get(@FROM@("cect10en")) ; Endobronchial
 ;
 set @TO@("cect1ll")=$get(@FROM@("cect1ll")) ; Most likely location
 set @TO@("cect2ll")=$get(@FROM@("cect2ll")) ; Most likely location
 set @TO@("cect3ll")=$get(@FROM@("cect3ll")) ; Most likely location
 set @TO@("cect4ll")=$get(@FROM@("cect4ll")) ; Most likely location
 set @TO@("cect5ll")=$get(@FROM@("cect5ll")) ; Most likely location
 set @TO@("cect6ll")=$get(@FROM@("cect6ll")) ; Most likely location
 set @TO@("cect7ll")=$get(@FROM@("cect7ll")) ; Most likely location
 set @TO@("cect8ll")=$get(@FROM@("cect8ll")) ; Most likely location
 set @TO@("cect9ll")=$get(@FROM@("cect9ll")) ; Most likely location
 set @TO@("cect10ll")=$get(@FROM@("cect10ll")) ; Most likely location
 ;
 set @TO@("cect1sn")=$get(@FROM@("cect1sn")) ; CT Series Number
 set @TO@("cect2sn")=$get(@FROM@("cect2sn")) ; CT Series Number
 set @TO@("cect3sn")=$get(@FROM@("cect3sn")) ; CT Series Number
 set @TO@("cect4sn")=$get(@FROM@("cect4sn")) ; CT Series Number
 set @TO@("cect5sn")=$get(@FROM@("cect5sn")) ; CT Series Number
 set @TO@("cect6sn")=$get(@FROM@("cect6sn")) ; CT Series Number
 set @TO@("cect7sn")=$get(@FROM@("cect7sn")) ; CT Series Number
 set @TO@("cect8sn")=$get(@FROM@("cect8sn")) ; CT Series Number
 set @TO@("cect9sn")=$get(@FROM@("cect9sn")) ; CT Series Number
 set @TO@("cect10sn")=$get(@FROM@("cect10sn")) ; CT Series Number
 ;
 set @TO@("cect1inl")=$get(@FROM@("cect1inl")) ; CT Image Number (Low
 set @TO@("cect1inh")=$get(@FROM@("cect1inh")) ; CT Image Number (Hig
 set @TO@("cect2inl")=$get(@FROM@("cect2inl")) ; CT Image Number (Low
 set @TO@("cect2inh")=$get(@FROM@("cect2inh")) ; CT Image Number (Hig
 set @TO@("cect3inl")=$get(@FROM@("cect3inl")) ; CT Image Number (Low
 set @TO@("cect3inh")=$get(@FROM@("cect3inh")) ; CT Image Number (Hig
 set @TO@("cect4inl")=$get(@FROM@("cect4inl")) ; CT Image Number (Low
 set @TO@("cect4inh")=$get(@FROM@("cect4inh")) ; CT Image Number (Hig
 set @TO@("cect5inl")=$get(@FROM@("cect5inl")) ; CT Image Number (Low
 set @TO@("cect5inh")=$get(@FROM@("cect5inh")) ; CT Image Number (Hig
 set @TO@("cect6inl")=$get(@FROM@("cect6inl")) ; CT Image Number (Low
 set @TO@("cect6inh")=$get(@FROM@("cect6inh")) ; CT Image Number (Hig
 set @TO@("cect7inl")=$get(@FROM@("cect7inl")) ; CT Image Number (Low
 set @TO@("cect7inh")=$get(@FROM@("cect7inh")) ; CT Image Number (Hig
 set @TO@("cect8inl")=$get(@FROM@("cect8inl")) ; CT Image Number (Low
 set @TO@("cect8inh")=$get(@FROM@("cect8inh")) ; CT Image Number (Hig
 set @TO@("cect9inl")=$get(@FROM@("cect9inl")) ; CT Image Number (Low
 set @TO@("cect9inh")=$get(@FROM@("cect9inh")) ; CT Image Number (Hig
 set @TO@("cect10inl")=$get(@FROM@("cect10inl")) ; CT Image Number (Low
 set @TO@("cect10inh")=$get(@FROM@("cect10inh")) ; CT Image Number (Hig
 ;
 set @TO@("cect1st")=$get(@FROM@("cect1st")) ; Nodule status
 set @TO@("cect2st")=$get(@FROM@("cect2st")) ; Nodule status
 set @TO@("cect3st")=$get(@FROM@("cect3st")) ; Nodule status
 set @TO@("cect4st")=$get(@FROM@("cect4st")) ; Nodule status
 set @TO@("cect5st")=$get(@FROM@("cect5st")) ; Nodule status
 set @TO@("cect6st")=$get(@FROM@("cect6st")) ; Nodule status
 set @TO@("cect7st")=$get(@FROM@("cect7st")) ; Nodule status
 set @TO@("cect8st")=$get(@FROM@("cect8st")) ; Nodule status
 set @TO@("cect9st")=$get(@FROM@("cect9st")) ; Nodule status
 set @TO@("cect10st")=$get(@FROM@("cect10st")) ; Nodule status
 ;
 set @TO@("cect1nt")=$get(@FROM@("cect1nt")) ; Nodule Consistency
 set @TO@("cect2nt")=$get(@FROM@("cect2nt")) ; Nodule Consistency
 set @TO@("cect3nt")=$get(@FROM@("cect3nt")) ; Nodule Consistency
 set @TO@("cect4nt")=$get(@FROM@("cect4nt")) ; Nodule Consistency
 set @TO@("cect5nt")=$get(@FROM@("cect5nt")) ; Nodule Consistency
 set @TO@("cect6nt")=$get(@FROM@("cect6nt")) ; Nodule Consistency
 set @TO@("cect7nt")=$get(@FROM@("cect7nt")) ; Nodule Consistency
 set @TO@("cect8nt")=$get(@FROM@("cect8nt")) ; Nodule Consistency
 set @TO@("cect9nt")=$get(@FROM@("cect9nt")) ; Nodule Consistency
 set @TO@("cect10nt")=$get(@FROM@("cect10nt")) ; Nodule Consistency
 ;
 set @TO@("cect1sl")=$get(@FROM@("cect1sl")) ; Length (mm)
 set @TO@("cect2sl")=$get(@FROM@("cect2sl")) ; Length (mm)
 set @TO@("cect3sl")=$get(@FROM@("cect3sl")) ; Length (mm)
 set @TO@("cect4sl")=$get(@FROM@("cect4sl")) ; Length (mm)
 set @TO@("cect5sl")=$get(@FROM@("cect5sl")) ; Length (mm)
 set @TO@("cect6sl")=$get(@FROM@("cect6sl")) ; Length (mm)
 set @TO@("cect7sl")=$get(@FROM@("cect7sl")) ; Length (mm)
 set @TO@("cect8sl")=$get(@FROM@("cect8sl")) ; Length (mm)
 set @TO@("cect9sl")=$get(@FROM@("cect9sl")) ; Length (mm)
 set @TO@("cect10sl")=$get(@FROM@("cect10sl")) ; Length (mm)
 ;
 set @TO@("cect1sw")=$get(@FROM@("cect1sw")) ; Maximum Width
 set @TO@("cect2sw")=$get(@FROM@("cect2sw")) ; Maximum Width
 set @TO@("cect3sw")=$get(@FROM@("cect3sw")) ; Maximum Width
 set @TO@("cect4sw")=$get(@FROM@("cect4sw")) ; Maximum Width
 set @TO@("cect5sw")=$get(@FROM@("cect5sw")) ; Maximum Width
 set @TO@("cect6sw")=$get(@FROM@("cect6sw")) ; Maximum Width
 set @TO@("cect7sw")=$get(@FROM@("cect7sw")) ; Maximum Width
 set @TO@("cect8sw")=$get(@FROM@("cect8sw")) ; Maximum Width
 set @TO@("cect9sw")=$get(@FROM@("cect9sw")) ; Maximum Width
 set @TO@("cect10sw")=$get(@FROM@("cect10sw")) ; Maximum Width
 ;
 set @TO@("cect1sh")=$get(@FROM@("cect1sh")) ; Height
 set @TO@("cect2sh")=$get(@FROM@("cect2sh")) ; Height
 set @TO@("cect3sh")=$get(@FROM@("cect3sh")) ; Height
 set @TO@("cect4sh")=$get(@FROM@("cect4sh")) ; Height
 set @TO@("cect5sh")=$get(@FROM@("cect5sh")) ; Height
 set @TO@("cect6sh")=$get(@FROM@("cect6sh")) ; Height
 set @TO@("cect7sh")=$get(@FROM@("cect7sh")) ; Height
 set @TO@("cect8sh")=$get(@FROM@("cect8sh")) ; Height
 set @TO@("cect9sh")=$get(@FROM@("cect9sh")) ; Height
 set @TO@("cect10sh")=$get(@FROM@("cect10sh")) ; Height
 ;
 set @TO@("cect1sv")=$get(@FROM@("cect1sv")) ; Volume
 set @TO@("cect2sv")=$get(@FROM@("cect2sv")) ; Volume
 set @TO@("cect3sv")=$get(@FROM@("cect3sv")) ; Volume
 set @TO@("cect4sv")=$get(@FROM@("cect4sv")) ; Volume
 set @TO@("cect5sv")=$get(@FROM@("cect5sv")) ; Volume
 set @TO@("cect6sv")=$get(@FROM@("cect6sv")) ; Volume
 set @TO@("cect7sv")=$get(@FROM@("cect7sv")) ; Volume
 set @TO@("cect8sv")=$get(@FROM@("cect8sv")) ; Volume
 set @TO@("cect9sv")=$get(@FROM@("cect9sv")) ; Volume
 set @TO@("cect10sv")=$get(@FROM@("cect10sv")) ; Volume
 ;
 set @TO@("cect1ssl")=$get(@FROM@("cect1ssl")) ; Solid Comp. Length
 set @TO@("cect1ssw")=$get(@FROM@("cect1ssw")) ; Solid Comp. Width
 set @TO@("cect2ssl")=$get(@FROM@("cect2ssl")) ; Solid Comp. Length
 set @TO@("cect2ssw")=$get(@FROM@("cect2ssw")) ; Solid Comp. Width
 set @TO@("cect3ssl")=$get(@FROM@("cect3ssl")) ; Solid Comp. Length
 set @TO@("cect3ssw")=$get(@FROM@("cect3ssw")) ; Solid Comp. Width
 set @TO@("cect4ssl")=$get(@FROM@("cect4ssl")) ; Solid Comp. Length
 set @TO@("cect4ssw")=$get(@FROM@("cect4ssw")) ; Solid Comp. Width
 set @TO@("cect5ssl")=$get(@FROM@("cect5ssl")) ; Solid Comp. Length
 set @TO@("cect5ssw")=$get(@FROM@("cect5ssw")) ; Solid Comp. Width
 set @TO@("cect6ssl")=$get(@FROM@("cect6ssl")) ; Solid Comp. Length
 set @TO@("cect6ssw")=$get(@FROM@("cect6ssw")) ; Solid Comp. Width
 set @TO@("cect7ssl")=$get(@FROM@("cect7ssl")) ; Solid Comp. Length
 set @TO@("cect7ssw")=$get(@FROM@("cect7ssw")) ; Solid Comp. Width
 set @TO@("cect8ssl")=$get(@FROM@("cect8ssl")) ; Solid Comp. Length
 set @TO@("cect8ssw")=$get(@FROM@("cect8ssw")) ; Solid Comp. Width
 set @TO@("cect9ssl")=$get(@FROM@("cect9ssl")) ; Solid Comp. Length
 set @TO@("cect9ssw")=$get(@FROM@("cect9ssw")) ; Solid Comp. Width
 set @TO@("cect10ssl")=$get(@FROM@("cect10ssl")) ; Solid Comp. Length
 set @TO@("cect10ssw")=$get(@FROM@("cect10ssw")) ; Solid Comp. Width
 ;
 set @TO@("cect1se")=$get(@FROM@("cect1se")) ; n
 set @TO@("cect1se")=$get(@FROM@("cect1se")) ;                 No
 set @TO@("cect2se")=$get(@FROM@("cect2se")) ; n
 set @TO@("cect2se")=$get(@FROM@("cect2se")) ;                 No
 set @TO@("cect3se")=$get(@FROM@("cect3se")) ; n
 set @TO@("cect3se")=$get(@FROM@("cect3se")) ;                 No
 set @TO@("cect4se")=$get(@FROM@("cect4se")) ; n
 set @TO@("cect4se")=$get(@FROM@("cect4se")) ;                 No
 set @TO@("cect5se")=$get(@FROM@("cect5se")) ; n
 set @TO@("cect5se")=$get(@FROM@("cect5se")) ;                 No
 set @TO@("cect6se")=$get(@FROM@("cect6se")) ; n
 set @TO@("cect6se")=$get(@FROM@("cect6se")) ;                 No
 set @TO@("cect7se")=$get(@FROM@("cect7se")) ; n
 set @TO@("cect7se")=$get(@FROM@("cect7se")) ;                 No
 set @TO@("cect8se")=$get(@FROM@("cect8se")) ; n
 set @TO@("cect8se")=$get(@FROM@("cect8se")) ;                 No
 set @TO@("cect9se")=$get(@FROM@("cect9se")) ; n
 set @TO@("cect9se")=$get(@FROM@("cect9se")) ;                 No
 set @TO@("cect10se")=$get(@FROM@("cect10se")) ; n
 set @TO@("cect10se")=$get(@FROM@("cect10se")) ;                 No
 ;
 set @TO@("cectin")=$get(@FROM@("cectin")) ; 1
 set @TO@("cectin")=$get(@FROM@("cectin")) ; 2
 ;
 set @TO@("cect1sp")=$get(@FROM@("cect1sp")) ; n
 set @TO@("cect1sp")=$get(@FROM@("cect1sp")) ;                 No
 set @TO@("cect2sp")=$get(@FROM@("cect2sp")) ; n
 set @TO@("cect2sp")=$get(@FROM@("cect2sp")) ;                 No
 set @TO@("cect3sp")=$get(@FROM@("cect3sp")) ; n
 set @TO@("cect3sp")=$get(@FROM@("cect3sp")) ;                 No
 set @TO@("cect4sp")=$get(@FROM@("cect4sp")) ; n
 set @TO@("cect4sp")=$get(@FROM@("cect4sp")) ;                 No
 set @TO@("cect5sp")=$get(@FROM@("cect5sp")) ; n
 set @TO@("cect5sp")=$get(@FROM@("cect5sp")) ;                 No
 set @TO@("cect6sp")=$get(@FROM@("cect6sp")) ; n
 set @TO@("cect6sp")=$get(@FROM@("cect6sp")) ;                 No
 set @TO@("cect7sp")=$get(@FROM@("cect7sp")) ; n
 set @TO@("cect7sp")=$get(@FROM@("cect7sp")) ;                 No
 set @TO@("cect8sp")=$get(@FROM@("cect8sp")) ; n
 set @TO@("cect8sp")=$get(@FROM@("cect8sp")) ;                 No
 set @TO@("cect9sp")=$get(@FROM@("cect9sp")) ; n
 set @TO@("cect9sp")=$get(@FROM@("cect9sp")) ;                 No
 set @TO@("cect10sp")=$get(@FROM@("cect10sp")) ; n
 set @TO@("cect10sp")=$get(@FROM@("cect10sp")) ;                 No
 ;
 set @TO@("cect1pld")=$get(@FROM@("cect1pld")) ; Distance
 set @TO@("cect2pld")=$get(@FROM@("cect2pld")) ; Distance
 set @TO@("cect3pld")=$get(@FROM@("cect3pld")) ; Distance
 set @TO@("cect4pld")=$get(@FROM@("cect4pld")) ; Distance
 set @TO@("cect5pld")=$get(@FROM@("cect5pld")) ; Distance
 set @TO@("cect6pld")=$get(@FROM@("cect6pld")) ; Distance
 set @TO@("cect7pld")=$get(@FROM@("cect7pld")) ; Distance
 set @TO@("cect8pld")=$get(@FROM@("cect8pld")) ; Distance
 set @TO@("cect9pld")=$get(@FROM@("cect9pld")) ; Distance
 set @TO@("cect10pld")=$get(@FROM@("cect10pld")) ; Distance
 ;
 set @TO@("cect1co")=$get(@FROM@("cect1co")) ; Comment
 set @TO@("cect2co")=$get(@FROM@("cect2co")) ; Comment
 set @TO@("cect3co")=$get(@FROM@("cect3co")) ; Comment
 set @TO@("cect4co")=$get(@FROM@("cect4co")) ; Comment
 set @TO@("cect5co")=$get(@FROM@("cect5co")) ; Comment
 set @TO@("cect6co")=$get(@FROM@("cect6co")) ; Comment
 set @TO@("cect7co")=$get(@FROM@("cect7co")) ; Comment
 set @TO@("cect8co")=$get(@FROM@("cect8co")) ; Comment
 set @TO@("cect9co")=$get(@FROM@("cect9co")) ; Comment
 set @TO@("cect10co")=$get(@FROM@("cect10co")) ; Comment
 ;
 set @TO@("cect1pd")=$get(@FROM@("cect1pd")) ; Pathologic diagnosis
 set @TO@("cect2pd")=$get(@FROM@("cect2pd")) ; Pathologic diagnosis
 set @TO@("cect3pd")=$get(@FROM@("cect3pd")) ; Pathologic diagnosis
 set @TO@("cect4pd")=$get(@FROM@("cect4pd")) ; Pathologic diagnosis
 set @TO@("cect5pd")=$get(@FROM@("cect5pd")) ; Pathologic diagnosis
 set @TO@("cect6pd")=$get(@FROM@("cect6pd")) ; Pathologic diagnosis
 set @TO@("cect7pd")=$get(@FROM@("cect7pd")) ; Pathologic diagnosis
 set @TO@("cect8pd")=$get(@FROM@("cect8pd")) ; Pathologic diagnosis
 set @TO@("cect9pd")=$get(@FROM@("cect9pd")) ; Pathologic diagnosis
 set @TO@("cect10pd")=$get(@FROM@("cect10pd")) ; Pathologic diagnosis
 ;
 set @TO@("cectancn")=$get(@FROM@("cectancn")) ; 1
 set @TO@("cectacn")=$get(@FROM@("cectacn")) ; 1
 ;
 set @TO@("ceem")=$get(@FROM@("ceem")) ; nv
 set @TO@("ceem")=$get(@FROM@("ceem")) ; no
 ;
 set @TO@("ceoca")=$get(@FROM@("ceoca")) ; n
 set @TO@("ceoca")=$get(@FROM@("ceoca")) ; y
 ;
 set @TO@("ceccv")=$get(@FROM@("ceccv")) ; e
 set @TO@("cecclm")=$get(@FROM@("cecclm")) ;               Left m
 set @TO@("ceccld")=$get(@FROM@("ceccld")) ;               LAD
 set @TO@("cecccf")=$get(@FROM@("cecccf")) ;               Circum
 set @TO@("ceccrc")=$get(@FROM@("ceccrc")) ;               RCA
 ;
 set @TO@("pa")=$get(@FROM@("pa")) ; n
 set @TO@("pa")=$get(@FROM@("pa")) ;            No
 ;
 ;
 ;@stanza 4 continue copy in 2nd routine
 ;
 do CTCOPY2^SAMICTC2(FROM,TO)
 ;
 ;
 ;@stanza 5 termination
 ;
 quit  ; end of ppi CTCOPY^SAMICTC1
 ;
 ;
 ;
 ;@dmi GENCTCOPY^SAMICTC1
GENCTCPY ; generate copy routine from graph
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;clean;silent;sac
 ;@called-by SAMI developer from direct mode
 ;@calls
 ; $$setroot^%wd
 ;@input
 ; ceform-fields graph
 ;@output
 ; writes compiled code to current device
 ;
 ;
 ;@stanza 2 compile code to copy most fields
 ;
 new root set root=$$setroot^%wd("ceform-fields")
 new fldf set fldf=$name(@root@("field"))
 ;
 write !,"generating copy from ",fldf
 ;
 new zi set zi=0
 for  do  quit:'zi
 . set zi=$order(@fldf@(zi))
 . quit:'zi
 . ;
 . quit:$get(@fldf@(zi,"copy"))'=1  ; only want copy fields
 . ;
 . new name,label
 . set name=$get(@fldf@(zi,"name"))
 . set label=$get(@fldf@(zi,"label"))
 . set label=$extract(label,1,20)
 . quit:name=""
 . ;
 . write !," set @TO@("""_name_""")=$get(@FROM@("""_name_""")) ; "_label
 . quit
 ;
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of dmi GENCTCOPY^SAMICTC1
 ;
 ;
 ;
EOR ; end of routine SAMICTC1
