%wffmap	;ven/gpl - mash forms utilities ; 9/24/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
 ; All the public entry points for forms are in %wf
 ;
formFn() ; form file number
 quit 311.11
 ;
formVarFn() ; variable subfile number
 quit 311.11001
 ;
formGlb() ; form global
 quit $name(^SAMI(311.11))
 ;
importfmap(csvname,form) ; import form mapping definitions from csv
 ; csvname is the name of the csv file
 ; form is the name of the form
 ;
 ; sample graph from the csv form mapping file
 ;^%wd(17.040801,7,"graph","sbform",365,"dataType")="RDATE"
 ;^%wd(17.040801,7,"graph","sbform",365,"fieldName")="sbdoc"
 ;^%wd(17.040801,7,"graph","sbform",365,"fieldTitle")="Date informed consent signed"
 ;^%wd(17.040801,7,"graph","sbform",365,"mClass#")=311.102
 ;^%wd(17.040801,7,"graph","sbform",365,"mDlimCheck")=""
 ;^%wd(17.040801,7,"graph","sbform",365,"mProp#")=34.1
 ;^%wd(17.040801,7,"graph","sbform",365,"mPropLoc")="10;10"
 ;^%wd(17.040801,7,"graph","sbform",365,"mPropName")="CONSENT DATE"
 ;^%wd(17.040801,7,"graph","sbform",365,"mPropType")="D"
 ;^%wd(17.040801,7,"graph","sbform",365,"sub#")=""
 ;
 do csv2graph^%wd(csvname,form)
 ;
 new groot set groot=$$rootOf^%wd("csvGraph")
 if '$data(@groot@(form)) do  quit  ;
 . write !,"csvGraph not found for form ",form
 new fmap
 merge fmap=@groot@(form)
 ;zwr fmap
 new formien s formien=$$formien(form) ; laygo form record number
 write:$get(%wform) !,"form: ",form," has ien: ",formien
 ;
 new %w1 s %w1=0
 for  set %w1=$order(fmap(%w1)) quit:+%w1=0  do  ; process each field
 . quit:$get(fmap(%w1,"fieldName"))=""  ; must have a field name
 . write !,"processing field ",fmap(%w1,"fieldName")
 quit
 ;
formien(form) ; extrinsic returns the record number of the form
 ; creates one if not found
 new %ien
 set %ien=$order(@$$formGlb()@("B",form,""))
 if %ien'="" quit %ien
 new fda
 set fda($$formFn,"?+1,",.01)=form
 do updie(.fda)
 set %ien=$order(@$$formGlb()@("B",form,""))
 quit %ien
 ;
updie(fda) ; update a fileman file
 new %yerr
 do UPDATE^DIE("","fda","","%yerr")
 if $data(%yerr) do  quit  ;
 . write !,"fileman error"
 . zwr %yerr
 . zwr fda
 . kill fda
 kill fda
 quit
 ;

