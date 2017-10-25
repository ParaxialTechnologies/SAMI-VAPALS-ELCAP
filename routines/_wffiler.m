%wffiler	;ven/gpl - mash forms utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
 ; All the public entry points for forms are in %wf
 ;
fileForm(ary,form,sid) ; ary is the input data, which has been validated
 ; ary is passed by name
 ; form is the form identifier which must be found in the form mapping file
 ; id should be the key of the targeted fileman file, for example studyid for
 ; the SAMI background file.
 ;
 ;  We must make a choice whether to process the file looking for fields for
 ;  which we have data or to process the data first, then looking for the 
 ;  fileman fields to update. We have chosen the latter so that forms can be
 ;  made which cover only a portion of the fields in a file, and will process
 ;  more quickly than with the former approach.  gpl
 ;
 ;
 new %wi set %wi=""
 zwr @ary
 ;for  s %wi
 new map
 ;do getFieldMap^%wf("map",form,fieldname)
 quit
 ;
testFiler ; test driver for the filer
 n vals
 d getVals^%wfhform("vals","sbform","XXXX02")
 d fileForm("vals","sbform","XXXX02")
 q
 ;
var2field(form,var) ; extrinsic returns the fileman file and field number for the var in form form
 ; format file^field
 new fld
 q fld
 ;
field2var(form,file,field) ; extrinsic returns the var in form form for the fileman field in file file
 new root set root=$$setroot^%wd("form-map")
 new groot set groot=$name(@root@("graph",form,"VARIABLE","FIELD"))
 new return set return=""
 if $data(@groot@(field)) set return=$order(@groot@(field,"")) 
 quit return
 ;
retrieve(ary,form,file,sid) ; retrieve all form variables from the fileman file for form and studyid (sid)
 ; ary is passed by name
 new tary
 new ien set ien=$order(^SAMI(file,"B",sid,""))
 if ien="" quit
 d GETS^DIQ(file,ien_",","**",,"tary")
 new tary2 set tary2=$name(tary(file,ien_","))
 new %wi set %wi=""
 for  set %wi=$order(@tary2@(%wi)) quit:%wi=""  do  ;
 . new var
 . set var=$$field2var(form,file,%wi)
 . ;w !,"var= ",var," field= ",%wi
 . if var'="" set @ary@(var)=@tary2@(%wi)
 quit
 ;
