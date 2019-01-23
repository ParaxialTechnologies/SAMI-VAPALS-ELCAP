SAMICTR3 ;ven/gpl - ielcap: forms ; 1/23/19 1:42pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 quit  ; no entry from top
 ;
EMPHYS(rtn,vals,dict)  ; repgen4,repgen5
 ;
 ;# Emphysema
 ;
 if $$XVAL("ceemv",vals)'="e" d  ;
 . D HOUT("Emphysema:")
 . D OUT($$XSUB("ceem",vals,dict)_para)
 ; if { 0 != [ string compare e [xval ceemv] ] } {
 ;   hputs "Emphysema:"
 ;   puts "[xsub ceem ceem].${para}"
 ; }
 ;
 D HOUT("Pleura:")
 ; hputs "Pleura:"
 N pe s pe=0
 ; set pe 0
 ; # Pleural Effusion
 ;
 if $$XVAL("cepev",vals)'="" d  ;
 . if $$XVAL("ceper",vals)'="no" d  ;
 . . if $$XVAL("cepel",vals)'="no" d  ;
 . . . if $$XVAL("cepel",vals)=$$XVAL("ceper",vals) d  ;
 . . . . d OUT("Bilateral "_$$XSUB("cepe",vals,dict,"cepel")_" pleural effusions."_para)
 . . . else  d  ;
 . . . . d OUT("Bilateral pleural effusions ; "_$$XSUB("cepe",vals,dict,"cepel")_" on left,")
 . . . . d OUT(" and "_$$XSUB("cepe",vals,dict,"ceper")_" on right."_para)
 . . . . s pe=1
 . . else  d  ;
 . . . d OUT("On right "_$$XSUB("cepe",vals,dict,"cepr")_" pleural effusion")
 . . . d OUT(" and on left "_$$XSUB("cepe",vals,dict,"cepel")_" pleural effusion."_para)
 . . . s pe=1
 . else  d  ;
 . . d OUT("On right "_$$XSUB("cepe",vals,dict,"cepr")_" pleural effusion")
 . . d OUT(" and on left "_$$XSUB("cepe",vals,dict,"cepel")_" pleural effusion."_para)
 . . s pe=1
 ;
 ;  if { 0 != [ string compare e [xval cepev] ] } {
 ;    if { 0 != [ string compare no [xval ceper] ] } {
 ;      if { 0 != [ string compare no [xval cepel] ] } {
 ;        if { [string compare [xval cepel] [xval ceper]] == 0 } {
 ;          puts "[tr "Bilateral"] [xsub cepe cepel] [tr "pleural effusions"].$ ;{para}"
 ;        } else {
 ;          puts "[tr "Bilateral pleural effusions "]; [xsub cepe cepel] [tr "o ;n left"], "
 ;          puts "[tr "and"] [xsub cepe ceper] [tr "on right"].${para}"
 ;        }
 ;        set pe 1
 ;      } else {
 ;        puts "[tr "On right "] [xsub cepe ceper] [tr "pleural effusion"]"
 ;        puts "[tr "and"] [tr "on left "] [xsub cepe cepel] [tr "pleural effus ;ion"].${para}"
 ;        set pe 1
 ;      }
 ;    } else {
 ;      if { 0 != [ string compare no [xval cepel] ] } {
 ;        puts "[tr "On right "] [xsub cepe ceper] [tr "pleural effusion"]"
 ;        puts "[tr "and"] [tr "on left "] [xsub cepe cepel] [tr "pleural effus ;ion"].${para}"
 ;        set pe 1
 ;      }
 ;    }
 ;  }
 if pe=0 d  ;
 . d OUT("No pleural effusions."_para)
 ;  if { $pe == 0 } {
 ;    puts "[tr "No pleural effusions"].${para}"
 ;  }
 ;
 n yespp s yespp=0
 ;
 if $$XVAL("cebatr",vals)="y" d  ;
 . d OUT("Rounded atelectasis in the ")
 . d OUT($$LOBESTR^SAMICTR2("cebatrl1^cebatrl2^cebatrl3^cebatrl4^cebatrl5",0)_".<br>")
 . s yespp=1
 ;  if { 0 == [ string compare y [xval cebatr] ] } {
 ;    puts "[tr "Rounded atelectasis in the"]"
 ;    puts "[lobestr [list cebatrl1 cebatrl2 cebatrl3 cebatrl4 cebatrl5] 0]"
 ;    #puts "[sidestr {Rounded atelectasis} cebatrrt cebatrlt]"
 ;    set yespp 1
 ;   ; ; ; ; ; ; ; ; ; ; ; ;}
 ;
 if $$XVAL("cept",vals)="y" d  ;
 . s yespp=1
 . s numl=0
 . set str="Pleural thickening/plaques in the "
 . if $$XVAL("ceptrt",vals)="r" d  ;
 . . s str=str_"right"
 . . s numl=numl+1
 . if $$XVAL("ceptlt",vals)="l" d  ;
 . . i numl>0 d  ;
 . . . s str=str_" and"
 . . s str=str_" left"
 . . s numl=numl+1
 . ;if numl>1 d  ;
 . ;. s str=str_" lungs."
 . ;else  d  ;
 . ;. s str=str_" lung."
 . s str=str_"."
 . if numl=0 set str="Pleural thickening/plaques."
 . d OUT(str_"<br>")
 ;
 ;
 ;  if { 0 == [ string compare y [xval cept] ] } {
 ;    set yespp 1
 ;    set numl 0
 ;    set str "[tr "Pleural thickening/plaques in the"] "
 ;    if { 0 == [ string compare r [xval ceptrt] ] } {
 ;      append str [tr "right"]
 ;      incr numl
 ;    }
 ;    if { 0 == [ string compare l [xval ceptlt] ] } {
 ;      if { $numl > 0 } {
 ;        append str " [tr "and"] "
 ;      }
 ;      append str [tr "left"]
 ;      incr numl
 ;    }
 ;    #if { $numl > 1 } {
 ;    #  append str " [tr "lungs"]."
 ;    #} else {
 ;    #  append str " [tr "lung"]."
 ;    #}
 ;    append str "."
 ;    if { $numl == 0 } {
 ;      set str "[tr "Pleural thickening/plaques"]."
 ;    }
 ;    puts "$str${cr}"
 ;   ; ; ; ; ; ; ;}
 ;
 if $$XVAL("cepu",vals)="y" d  ;
 . s yespp=1
 . if $l($$XVAL("cepus",vals))'=0 d  ;
 . . d OUT("Pleural rumor: "_$$XVAL("cepus",vals))
 . e  d OUT("Pleural tumor.")
 . d OUT("<br>")
 ;
 ;  if { 0 == [ string compare y [xval cepu] ] } {
 ;    set yespp 1
 ;    if { [string length [string trim [xval cepus]]] != 0 } {
 ;      puts "[tr "Pleural tumor"]: [xval cepus]"
 ;    } else {
 ;      puts "[tr "Pleural tumor"]."
 ;    }
 ;    puts "${cr}"
 ;   ; ; ; ; ; ; ;}
 ;
 i yespp=0 d OUT(para)
 ;
 ;  if { $yespp == 0 } {
 ;    #puts "${para}[tr "No other abnormalities in the lung parenchyma or pleur ;a"].${para}"
 ;    puts "${para}"
 ;  }
 ;
 i newct=1 d  ;
 . if $$XVAL("ceoppab",vals)'="" d OUT($$XVAL("ceoppab",vals)_"."_para)
 . else  d
 . . if yespp=1 d OUT(para)
 ;
 ;  if { $newct == 1 } {
 ;
 ;    if { 0 != [ string length [xval ceoppab] ] } {
 ;      # puts "Additional Comments on Parenchymal or Pleural Abnormalities:"
 ;    if { [string compare [xval ceoppab] $dummy] != 0 } {
 ;       puts "[xval ceoppab].${para}"
 ;    }
 ;    } else {
 ;      if { $yespp == 1 } {
 ;      puts "${para}"
 ;    }
 ;    ; ;}
 ;
 ;   ;}
 ;
 d HOUT("Coronary Artery Calcifications:")
 ;# Coronary Calcification
 n vcac,cac,cacrec
 s (cac,cacrec)=""
 if $$XVAL("ceccv",vals)'="e" d  ;
 . set vcac=$$XVAL("cecccac",vals)
 . if vcac'="" d  ;
 . . s cacrec=""
 . . s cac="The Visual Coronary Artery Calcium (CAC) Score is "_vcac_". "
 . . s cacval=vcac
 . . i cacval>3 s cacrec=$g(@dict@("CAC_recommendation"))_para
 ;
 ;hputs "Coronary Artery Calcifications:"
 ;
 ;# Coronary Calcification
 ;if { 0 != [ string compare e [xval ceccv] ] } {
 ;   set vcac "[xval cecccac]"
 ;   if { [string compare $dummy $vcac] != 0 } {
 ;      set cacrec ""
 ;      if { [string length $vcac] != 0 } {
 ;         set cac "[tr "The Visual Coronary Artery Calcium (CAC) Score is"] ${ ;vcac}. "
 ;         scan $vcac {%d} cacval
 ;         if { $cacval > 3 } {
 ;            set cacrec "${CAC_recommendation}${para}"
 ;         }
 ;      }
 ;    }
 ;
 n samicac s samicac=0
 i $$XVAL("cecclm",vals)'="no" s samicac=1
 i $$XVAL("ceccld",vals)'="no" s samicac=1
 i $$XVAL("cecclf",vals)'="no" s samicac=1
 i $$XVAL("ceccrc",vals)'="no" s samicac=1
 ;
 i samicac=1 d  ;
 . d OUT($$XSUB("cecc",vals,dict,"cecclm")_" in left main,")
 . d OUT($$XSUB("cecc",vals,dict,"ceccld")_" in left anterior descending,")
 . d OUT($$XSUB("cecc",vals,dict,"cecclf")_" in circumflex, and")
 . d OUT($$XSUB("cecc",vals,dict,"ceccrc")_" in right coronary. "_cac_para)
 ;
 ;
 ;if { 0 != [expr [string compare no [xval cecclm]] || [string compare no [xval ; ceccld]] || [string compare no [xval cecccf]] || [string compare no [xval ce ;ccrc]]] } {
 ;  #puts "[tr "Coronary calcifications are seen as follows"]: \
 ;
 ;  puts "[xsub cecc cecclm] [tr "in left main"],"
 ;  puts "[xsub cecc ceccld] [tr "in left anterior descending"],"
 ;  puts "[xsub cecc cecccf] [tr "in circumflex"], [tr "and"]"
 ;  puts "[xsub cecc ceccrc] [tr "in right coronary"]. ${cac} ${para}"
 ;} else {
 ;  #puts "[tr "No coronary calcifications are seen"]. ${cac} ${para}"
 ;  puts "None. ${cac} ${para}"
 ;  } ; ; ;
 ;}
 if $$XVAL("cecca",vals)'="-" d  ;
 . d HOUT("Aortic Calcifications: ")
 . d OUT($$XSUB("cecc",vals,dict,"cecca"))
 ;
 ;if { 0 != [string length [xval cecca]] } {
 ;   if { [string compare $dummy [xval cecca]] != 0 } {
 ;      hputs "Aortic Calcifications:"
 ;      puts "[xsub cecc cecca]."
 ;    }
 ;}
 d HOUT("Cardiac Findings:")
 ;
 ;hputs "Cardiac Findings:"
 ;
 ;# Pericardial Effusion
 if $$XVAL("ceprevm",vals)'="-" d  ;
 . if $$XVAL("ceprevm",vals)'="no" d  ;
 . . if $$XVAL("ceprevm",vals)'="" d
 . . . d OUT("A "_$$XSUB("ceprevm",vals,dict,"ceprevm")_" pericardial effusion"_"."_para)
 . . . s pe=1
 . . else  d OUT("No pericardial effusion."_para)
 ;
 ;# Pericardial Effusion
 ;if { 0 != [ string compare e [xval ceprev] ] } {
 ;   if { 0 != [string compare no [xval ceprevm]] } {
 ;      if { [string compare $dummy [xval ceprevm]] != 0 } {
 ;      puts "[tr "A"] [xsub ceprevm ceprevm] [tr "pericardial effusion"].${par ;a}"
 ;      set pe 1
 ;      }
 ;   } else {
 ;      puts "[tr "No pericardial effusion"].${para}"
 ;   }
 ;}
 ;
 ;;# Pulmonary and Aortic Diameter
 i $$XVAL("cepaw",vals)'="" d  ;
 . d OUT("Widest main pulmonary artery diameter is "_$$XVAL("cepaw",vals)_" mm. ")
 . if $$XVAL("ceaow",vals)'="" d  ;
 . . d OUT("Widest ascending aortic diameter at the same level is "_$$XVAL("ceaow",vals)_" mm. ")
 . . if $$XVAL("cepar",vals)'="" d  ;
 . . . d OUT("The ratio is "_$$XVAL("cepar",vals)_".")
 ;
 ;# Pulmonary and Aortic Diameter
 ;if { 0 != [ string compare $dummy [xval cepaw] ] } {
 ;    puts "[tr "Widest main pulmonary artery diameter is"] [xval cepaw] mm."
 ;  if { 0 != [ string compare $dummy [xval ceaow] ] } {
 ;       puts -nonewline "[tr "Widest ascending aortic diameter at the same lev ;el is"] [xval ceaow] mm."
 ;     if { 0 != [ string compare $dummy [xval cepar] ] } {
 ;        puts -nonewline " [tr "The ratio is"] [xval cepar]."
 ;     }
 ;     puts "${para}"
 ;    } ;
 ;}
 ;
 ; #"Additional Comments on Cardiac Abnormalities:"
 if $$XVAL("cecommca",vals)'="" d  ;
 . d OUT($$XVAL("cecommca",vals)_"."_para)
 ;
 ;    if { 0 != [ string length [xval cecommca] ] } {
 ;      # puts "Additional Comments on Cardiac Abnormalities:"
 ;    if { [string compare $dummy [xval cecommca]] != 0 } {
 ;      puts "[xval cecommca].${para}"
 ;    }
 ;    }
 ;
 d HOUT("Mediastinum:")
 n yesmm s yesmm=0
 n abn
 i $$XVAL("ceoma",vals)="y"&$$XVAL("ceata",vals)="y" d  ;
 . s yeamm=1
 . s abn="ceatc^ceaty^ceatm"
 ;hputs "Mediastinum:"
 ;
 ;   set yesmm 0
 ;   # Neck and Mediastinal Abnormalities
 ;   if { 0 == [ string compare y [xval ceoma] ] } {
 ;   if { 0 == [ string compare y [xval ceata] ] } {
 ;      set yesmm 1
 ;      set abn [ccmstr [list ceatc ceaty ceatm]]
 ;      if { [string length $abn] == 0 } {
 ;         puts -nonewline "[tr "Noted in the thyroid"] "
 ;      } else {
 ;         puts -nonewline "$abn [tr "thyroid"]. "
 ;      }
 ;      puts "[xval ceatos]${cr}"
 ;   }
 ;   if { 0 == [ string compare y [xval ceaya] ] } {
 ;      set yesmm 1
 ;      set abn [ccmstr [list ceayc ceayy ceaym]]
 ;      if { [string length $abn] == 0 } {
 ;         puts -nonewline "[tr "Noted in the thymus"]. "
 ;      } else {
 ;         puts -nonewline "$abn [tr "thymus"]. "
 ;      }
 ;      puts "[xval ceayos]${cr}"
 ;   }
 ;   #puts "<BR>"
 ;    ;}
 ;
 ;   # Non-calcified lymph nodes
 ;   set lnlist [list "cemlnl1"  "cemlnl2r"  "cemlnl2l" "cemlnl3" "cemlnl4r" \
 ;                    "cemlnl4l" "cemlnl5"   "cemlnl6"  "cemlnl7" "cemlnl8" \
 ;                    "cemlnl9"  "cemlnl10r" "cemlnl10l"]
 ;   set lnlistt [list "high mediastinal"  "right upper paratracheal" "left upp ;er paratracheal"  "prevascular/retrotracheal" "right lower paratracheal" "lef ;t lower paratracheal" "sub-aortic (A-P window)" "para-aortic" "subcarinal" "p ;ara-esophageal" "pulmonary ligament" "right hilar" "left hilar" ]
 ;
 ;   if { 0 == [ string compare y [xval cemln] ] } {
 ;      set yesmm 1
 ;      set llist {}
 ;      foreach item $lnlist {
 ;         if { [string compare $dummy [xval $item]] != 0 } {
 ;      if { [string length [xval $item]] > 1 } {
 ;         lappend llist [tr [lsearch $lnlist $item]]
 ;      }
 ;   }
 ;      }
 ;      set lnum [llength $llist]
 ;      if { $lnum == 0 } {
 ;         puts "[tr "Enlarged or growing lymph nodes are noted"]. "
 ;      } else {
 ;   set slnum $lnum
 ;         puts "[tr "Enlarged or growing lymph nodes in the"] "
 ;   foreach item $llist {
 ;      puts -nonewline "[lindex $lnlistt $item]"
 ;      if { $lnum > 2 } {
 ;         puts ", "
 ;      }
 ;      if { $lnum == 2 } {
 ;         puts " [tr "and"] "
 ;      }
 ;      incr lnum -1
 ;   }
 ;    if { $slnum > 1 } {
 ;       puts " [tr "locations"]."
 ;          } else {
 ;       puts " [tr "location"]."
 ;          }
 ;      }
 ;   } ;
 ;
 ;   if { 0 == [ string compare y [xval cemlncab] ] } {
 ;      set yesmm 1
 ;      puts "[tr "Calcified lymph nodes present"].${cr}"
 ;   }
 ;
 ;   if { 0 == [ string compare y [xval ceagaln] ] } {
 ;      set yesmm 1
 ;      puts " [tr "Enlarged or growing axillary lymph nodes without central fa ;t are seen"]."
 ;      puts "[xval ceagalns]${cr}"
 ;   }
 ;
 ;   if { 0 == [ string compare y [xval cemva] ] } {
 ;      set yesmm 1
 ;      if { 0 == [ string compare a [xval cemvaa] ] } {
 ;         puts "[tr "Other vascular abnormalities are seen in the aorta"]."
 ;      }
 ;      if { 0 == [ string compare w [xval cemvap] ] } {
 ;         puts "[tr "Other vascular abnormalities are seen in the pulmonary se ;ries"]."
 ;      }
 ;      puts "[xval cemvaos]${cr}"
 ;   }
 ;   #puts "${para}"
 ;
 ;   # Esophageal
 ;  if { 0 == [ string compare y [xval cemeln] ] } {
 ;    set yesmm 1
 ;    set elist {}
 ;    set numl 0
 ;    if { 0 == [ string compare a [xval cemelna] ] } {
 ;      lappend elist [tr "Air-fluid level"]
 ;      incr numl
 ;    }
 ;    if { 0 == [ string compare w [xval cemelnw] ] } {
 ;      lappend elist [tr "Wall thickening"]
 ;      incr numl
 ;    }
 ;    if { 0 == [ string compare m [xval cemelnm] ] } {
 ;      lappend elist [tr "A mass"]
 ;      incr numl
 ;    }
 ;    if { $numl == 0 } {
 ;      puts "[tr "Esophageal abnormality noted"]."
 ;    } else {
 ;      puts -nonewline "[lindex $elist 0]"
 ;      if { $numl == 1 } {
 ;        puts -nonewline " is "
 ;      } else {
 ;        if { $numl == 2 } {
 ;          puts -nonewline " [tr "and"] "
 ;        } else {
 ;          puts -nonewline ", "
 ;        }
 ;        puts -nonewline "[string tolower [lindex $elist 1]]"
 ;        if { $numl == 3 } {
 ;          puts -nonewline ", [tr "and"] [lindex $elist 2]"
 ;        }
 ;        puts -nonewline " are "
 ;      }
 ;      puts "[tr "seen in the esophagus"]."
 ;    }
 ;    puts "[xval cemelnos]"
 ;    puts "${para}"
 ;   ; ; ;}
 ;
 ;  if { 0 == [ string compare y [xval cehhn] ] } {
 ;    set yesmm 1
 ;    if { [string length [string trim [xval cehhnos]]] != 0 } {
 ;      puts "[tr "Hiatal hernia"]: [xval cehhnos]."
 ;    } else {
 ;      puts "[tr "Hiatal hernia"]."
 ;    }
 ;    puts "${para}"
 ;  }
 ;
 ;  if { 0 == [ string compare y [xval ceomm] ] } {
 ;    set yesmm 1
 ;    set tval [xval ceommos]
 ;    if { [string compare $tval $dummy] == 0 } {
 ;      set tval ""
 ;    }
 ;    set abn [ccmstr [list ceamc ceamy ceamm]]
 ;    if { [string length $abn] == 0 } {
 ;      puts -nonewline "[tr "Abnormality noted in the mediastinum"]. "
 ;    } else {
 ;      puts -nonewline "$abn mediastinum. "
 ;    }
 ;    puts "$tval${cr}"
 ;  }
 ;
 ;  if { $yesmm == 0 } {
 ;    #puts "${para}[tr "No abnormalities are seen in the neck or mediastinum"] ;.${cr}"
 ;    puts "No abnormalities.${para}"
 ;   ; ;}
 ;
 ;  if { $newct == 1 } {
 ;    if { 0 != [ string length [xval ceotabnm] ] } {
 ;      # puts "Additional Comments on Neck and Mediastinal Abnormalities:"
 ;      puts "[xval ceotabnm].${para}"
 ;    }
 ;  }
 ;  puts "</p>"
 ;;
 ;
 q
 ;
 ;
OUT(ln)  s cnt=cnt+1
 n lnn
 ;s debug=1
 s lnn=$o(@rtn@(" "),-1)+1
 s @rtn@(lnn)=ln
 i $g(debug)=1 d  ;
 . i ln["<" q  ; no markup
 . n zs s zs=$STACK
 . n zp s zp=$STACK(zs-2,"PLACE")
 . s @rtn@(lnn)=zp_":"_ln
 q
 ;
HOUT(ln)  d OUT("<p><span class='sectionhead'>"_ln_"</span>")
 q
 ;
XVAL(var,vals) ; extrinsic returns the patient value for var
 ; vals is passed by name
 n zr
 s zr=$g(@vals@(var))
 ;i zr="" s zr="["_var_"]"
 q zr
 ;
XSUB(var,vals,dict,valdx) ; extrinsic which returns the dictionary value defined by var
 ; vals and dict are passed by name
 ; valdx is used for nodules ala cect2co with the nodule number included
 ;n dict s dict=$$setroot^%wd("cteval-dict")
 n zr,zv,zdx
 s zdx=$g(valdx)
 i zdx="" s zdx=var
 s zv=$g(@vals@(zdx))
 ;i zv="" s zr="["_var_"]" q zr
 i zv="" s zr="" q zr
 s zr=$g(@dict@(var,zv))
 ;i zr="" s zr="["_var_","_zv_"]"
 q zr
 ;
