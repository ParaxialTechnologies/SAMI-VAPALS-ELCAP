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
 . kill fda
 . set fda($$formVarFn(),"?+1,"_formien_",",.01)=fmap(%w1,"fieldName")
 . set fda($$formVarFn(),"?+1,"_formien_",",.02)=$get(fmap(%w1,"fieldTitle"))
 . set fda($$formVarFn(),"?+1,"_formien_",",.5)=$get(fmap(%w1,"mClass#"))
 . set fda($$formVarFn(),"?+1,"_formien_",",1)=$get(fmap(%w1,"mProp#"))
 . set fda($$formVarFn(),"?+1,"_formien_",",2)=$get(fmap(%w1,"mPropType"))
 . zwr fda
 . d updie(.fda)
 . ;
 . do initFmap(form)
 . ;
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
initFmap(form) ; initializes the form-map graph for form
 ;
 new fglb set fglb=$$formGlb()
 new formien set formien=$order(@fglb@("B",form,""))
 if formien="" do  quit  ;
 . write !,"Error initializing form-map for form: ",form
 new mapglb set mapglb=$$setroot^%wd("form-map")
 new fmapglb set fmapglb=$name(@mapglb@("graph",form))
 if $data(@fmapglb) kill @fmapglb
 ;b
 do fmx^%sfv2g(fmapglb,$$formFn,formien)
 ;
 ; sample fieldmap graph entry
 ;
 ;^%wd(17.040801,7,"graph","sbform","VARIABLE",148,"DATA_TYPE")="D"
 ;^%wd(17.040801,7,"graph","sbform","VARIABLE",148,"FILEMAN_FIELD")=34.1
 ;^%wd(17.040801,7,"graph","sbform","VARIABLE",148,"FILEMAN_FILE")="SAMI BACKGROUND"
 ;^%wd(17.040801,7,"graph","sbform","VARIABLE",148,"TITLE")="Date informed consent signed"
 ;^%wd(17.040801,7,"graph","sbform","VARIABLE",148,"VARIABLE")="sbdoc"
 ;
 ; index the graph
 new %wi s %wi=0
 for  set %wi=$order(@fmapglb@("VARIABLE",%wi)) quit:+%wi=0  do  ;
 . new %wvar set %wvar=$get(@fmapglb@("VARIABLE",%wi,"VARIABLE"))
 . quit:%wvar=""
 . set @fmapglb@("VARIABLE","B",%wvar,%wi)=""
 . new %wfield set %wfield=$get(@fmapglb@("VARIABLE",%wi,"FILEMAN_FIELD"))
 . quit:%wfield=""
 . set @fmapglb@("VARIABLE","FIELD",%wfield,%wvar,%wi)=""
 q
 ;
getFmapGlb(form) ; get the location of the fieldmap for the form
 new mapglb set mapglb=$$setroot^%wd("form-map")
 new fmapglb set fmapglb=$name(@mapglb@("graph",form,"VARIABLE"))
 ;
 q fmapglb
 ;
getFieldSpec(form,field,fmapglb) ; extrinsic returns the format specification
 ; for field in form. fmapglb is optional but will speed up the lookup
 ;
 if $get(fmapglb)="" s fmapglb=$$getFmapGlb(form)
 ;
 new %wien s %wien=$o(@fmapglb@("B",field,""))
 ;
 if %wien="" do  quit  ;
 . ;write !,"Error field map not found"
 . ;d ^ZTER
 ;
 quit $get(@fmapglb@(%wien,"DATA_TYPE"))
 ;
getFieldMap(array,form,field,fmapglb) ; array is passed by name and returns the file map
 ; for the field in the form
 ; fmapglb is passed by name and is optional, but will speed up processing
 ;
 if $get(fmapglb)="" s fmapglb=$$getFmapGlb(form)
 ;
 if $g(field)="" q  ;
 new %wien s %wien=$o(@fmapglb@("B",field,""))
 ;
 if %wien="" do  quit  ;
 . ;write !,"Error field map not found"
 . ;d ^ZTER
 ;
 merge @array=@fmapglb@(%wien)
 ;
 quit
 ;
 
 
