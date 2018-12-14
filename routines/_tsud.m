%tsud ;ven/toad-type string: documentation ;2018-12-12T03:21Z
 ;;1.8;Mash;
 ;
 ; %tsud is the Mumps String Library's inroductory documentation.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; It contains no executable software.
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
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2012/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-12-12T03:21Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;
 ;
 ;@section 1 string datatype library alphabet
 ;
 ;
 ;
 ; a = ?
 ; b = ?
 ; c = case conversion [& character?]
 ; d = ?
 ; e = extract
 ;   el = left extract
 ;   er = right extract
 ;   em = mid extract
 ; f = find
 ;   fl = left find
 ;   fr = right find
 ;   fm = mid find
 ; f = format
 ; g = ?
 ; h = ?
 ; i = ?
 ; j = justify?
 ; k = ?
 ; l = ?
 ; m = merge
 ; n = ?
 ; o = ?
 ; p = piece
 ; p = pattern
 ; q = ?
 ; r = ?
 ; r = regular expression [x? p for pattern? m for match? f for find?]
 ; s = slice
 ; t = table
 ; u = utility
 ; v = validation
 ; w = walk
 ; x = ?
 ; y = mumps user (programmer) extensions
 ; z = mumps implementor extensions
 ; ? = masking
 ; ? = javascript string library (likewise other std string libraries)
 ;
 ; Case is a concept specific to some alphabets but not others, and
 ; not to any abjads, nor to ideographic or logographic systems,
 ; generally speaking. But it is so important to our alphabets that
 ; we have to leave top-level alphabet room for these functions, which
 ; are called more than any other string functions. It applies to
 ; letters, and includes more cases than Mumps or Unicode supports
 ; (such as small-caps case). It also applies to numbers, though
 ; Mumps & Unicode don't support that either, and even to punctuation.
 ; The Mumps $transform function is important to this library.
 ;
 ; Extract is a Mumps concept that conceives of a string as partitioned
 ; into individual characters. An extract identifies a substring within
 ; a string based on start & end position. Mash generalizes this to 
 ; also include substrings based on start or end position & length. If a
 ; method conceives of strings in terms of characters & substrings in
 ; terms of character positions, then it belongs in the string-extract
 ; library. The Mumps $extract & $find & $length functions, _ operator,
 ; & set $extract command are important to the Extract Library. See also
 ; Slice & Table, & contrast with Find.
 ;
 ; Find conceives of a string as made up of substrings whose values
 ; matter but positions matter only secondarily or not at all; that is,
 ; they can be found and changed. A found substring is called a find, as
 ; in "What a find!" These methods never return character position. Finds
 ; can be replaced (set) or removed (cut) or so on, once or repeatedly,
 ; from part or all of the string. The Mumps [ operator & $transform
 ; function & the Extract Library is important to the Find Library.
 ;
 ; Format is a Mash-wide concept that values can have different
 ; representations, depending on the context. In the case of strings,
 ; Mumps represents them as values w/in Mumps symbol tables and as
 ; string literals w/in Mumps text; indirection operations often
 ; require converting back & forth between these two formats. Likewise,
 ; unix string literals are another common format Mumps software must
 ; be able to convert to and from, as are html string literals, and so
 ; on. This library provides these conversion methods. Although it
 ; (currently) occupies the same alphabet letter with Find, its methods
 ; are named differently, more like the Merge Library. Perhaps
 ; eventualy it should be moved into the Validation Library, which
 ; should be renamed the Value Library, or to a new Representation
 ; Library along with Merge.
 ;
 ; Merge is to structure what Format is to values; the components of a
 ; string may be characters, slices, columns, pieces, & so on, & Mumps
 ; software often needs to convert them from one representation to
 ; another - or to or from arrays or individual named variables. All of
 ; these fan-in & fan-out methods belong in this library.
 ;
 ; Piece is a Mumps concept that conceives of a string as partitioned
 ; into substrings separated by a defined delimiter; these methods all
 ; need to know the value of that delimiter, so the string's pieces can
 ; be counted & identified by their count number. Pieces are analogous
 ; to words & delimiters to spaces (though human-language word parsing
 ; is much more complicated than the Piece Library can handle well.)
 ; The Mumps $piece & $length functions, set $piece command, & _
 ; operator are important to the Piece Library.
 ;
 ; Pattern is a Mumps concept of an abstract representation of the
 ; syntax of a string, used to perform sophisticated string validation
 ; & extraction that other languages accomplish with regular expressions.
 ; The Mumps ? operator is important to the Pattern Library, which has
 ; been extended to include the many pattern-match extensions approved
 ; by the mdc. If the Merge & Format libraries end up moved to a new
 ; Representation Library, Pattern may be moved to a new Match Library.
 ;
 ; Regular Expression is most other languages' equivalent to Mumps
 ; pattern matching. It may join Pattern as part of a new Match Library.
 ;
 ; Slice conceives of a string as made up of some number of substrings
 ; all of which have the same length; these methods all need to know
 ; the slice length, which Extract & Piece & Table can also do but
 ; Find cannot. Slices of 255 characters (to respect 1995 Mumps portable
 ; string length) or 80 or 132 (to respect standard terminal row widths)
 ; or other such slice sizes help to illustrate the value of this
 ; library. Since the slice-length is fixed, slices can be counted &
 ; identified by their count number. The Mumps $extract & $length
 ; functions & [ & _ operators & Extract Library are important to the
 ; Slice library. Slice is a generalization of extract; an extract is
 ; just a group of slices, each of which is 1 character long. See also
 ; Extract & Table.
 ;
 ; Table conceives of a string as made up of some number of fields
 ; arranged into columns, possibly padded (with spaces) in the process;
 ; that is, a string is a row of a table. The difference between slices
 ; & column fields is that slices are all the same length, but each
 ; column can be a different length. These methods all need access to a
 ; column definition that defines each column's length. Like slices,
 ; columns can be counted and identified by their count number. The Mumps
 ; $extract & $length functions & _ operator & the Extract & Justify
 ; libraries are important to the Table Library. The Extract & Slice
 ; libraries are neutral about whether a string is made up of discrete
 ; fields, so they neither require nor rule out the use of padding
 ; operations when inserting or removing substrings; Piece's use of
 ; delimiters strongly suggests the string is made up of fields, but 
 ; thanks to the delimiters no padding is required to insert or remove
 ; those fields; but except in rare cases of fixed-length fields, Table
 ; conceives of columns as fixed-length containers for potentially
 ; variable-length fields, so the Justify Library methods are important
 ; to Table for padding a field to create a column & the Find Library's
 ; Trim method is important to retrieving the field from within the column
 ; by trimming its padding (if any) back off.
 ;
 ; Utility is a Mash concept that includes concepts related not to the
 ; structure of a routine but to its execution & lifecycle, such as errors,
 ; logging, testing, version control, and so on. Every Mash module
 ; includes a utility library.
 ;
 ; Validation is the broader concept of string syntax checking, including
 ; potentially not just the string's patter but also its length & other
 ; characteristics. It is related to subtyping, allowing for more
 ; restrictions to be placed upon a string's contents & for a string to
 ; be tested against those restrictions. For example, the Mumps subscript
 ; type disallows control characters, & the Mumps namevalue type must
 ; adhere to the syntactic requirements of a Mumps name. The Validation
 ; Library is the gateway to all such string checking that goes beyond
 ; pattern matching & regular expressions without yet rising to the
 ; level of named data types. This may be generalized to a Value Library
 ; & fold in the current Format Library.
 ;
 ; Walking is a Mash concept of traversal, which applies to most of its
 ; libraries, in which the primary data structure(s) of its library can
 ; be enumerated and traversed, with operations of some kind performed
 ; on each element in the prescribed order. Walkers are the foundational
 ; components of Mash's more sophisticated extensible frameworks. Strings
 ; may be traversed as characters, finds, pieces, slices, or table
 ; columns, & future such component types may be developed.
 ;
 ; Mumps User (Programmer) Extensions is an MDC concept that every
 ; standard library must include room for local Mumps programming
 ; organizations (which the MDC refers to as Mumps users) to extend
 ; that library with their own innovations. For example, if VA wishes to
 ; add their own VA-specific string methods to Mash, they belong in the
 ; %tsy namespace. Y is the MDC standard prefix for such user extensions,
 ; so %tsy will be the interface routine for any such user-defined
 ; library of string methods, & the code for such methods will be located
 ; w/in %tsy routines.
 ;
 ; Mumps Implementor Extensions is an MDC concept that every
 ; standard library must include room for Mumps implementors to extend
 ; that library with their own innovations. Z is the MDC standard
 ; prefix for such implementor extensions, so %tsz will be the interface
 ; routine for any such implementor-defined library of string methods, &
 ; the code for such methods will be located w/in the %tsz routines.
 ;
 ; Mask is a computer-science concept in which a string may be
 ; accompanied by an abstract version of itself containing characters
 ; that map position by position back to the original string. A mask
 ; may be used to assign truth values to each character, or to hold
 ; case-independent (all upper or all lower, for example) copies of the
 ; same characters, to facilitate case-insensitive find & replace, or
 ; to record pattern codes for each character, or so on, to aid in
 ; complex string analysis & computations. We do not yet know where
 ; in the Mash String Alphabet the Mask functions belong
 ;
 ;
 ;
 ;@section 2 string datatype library vocabulary
 ;
 ;
 ;
 ; Because the String Library is large & growing, creating many points
 ; of contractual rigidity between this library and the rest of the
 ; Mumps system, it is vital to name these methods in ways that leave
 ; plenty of room for future growth. The use of stereotyped method
 ; names that follow predictable patterns overall and patterns within
 ; each sublibrary is encouraged for all Mash libraries, since that
 ; leaves available to future method developers all other possible
 ; method names.
 ;
 ; Likewise, because many of these are fundamental methods likely to
 ; be used often & to be combined into single-line complex expressions,
 ; short names are preferred, so long as clarity is not sacrificed, &
 ; where long names are necessary for clarity, equivalent shorter names
 ; will also be made available. Where conventional string libraries
 ; exist in other languages that are well known or at least likely to be
 ; used often by bilingual Mumps developers, additional method names
 ; will be added to match those standard string-library names. Given the
 ; lack of naming discipline in most such string libraries, this will
 ; come at the cost of future extensibility of the Mash string library,
 ; so it must be done with discretion. The canonical name for each
 ; method will be eight characters or less, with shorter, longer, &
 ; conventional synonyms available for ease of use.
 ;
 ; Consistent with the Mumps language & Mash library patterns, no
 ; function may produce a side effect other than calculating &
 ; returning a value. Procedures will be used for all other methods, so
 ; changes to the Mumps system need not be searched for within Mumps
 ; expressions, only within commands & procedure calls.
 ;
 ; To simplify the structure of this library & make locating desired
 ; functionality more intuitive, a consistent set of string concepts
 ; has been developed, which may be combined to identify methods.
 ; For example, a string is composed of components, which may take
 ; the form of foreground (a substring to be found) & background
 ; (the uninteresting matrix within which the substring exists) or
 ; similarly as interesting pieces & uninteresting delimiters or
 ; interesting fields & uninteresting column padding or as equally
 ; interesting characters or slices. A string may be thought of as
 ; easily assembleable or disassembleable into these components, &
 ; the components may be searched for, located, identified, changed,
 ; & so on.
 ;
 ; If those components are the nouns, the verbs are the operations,
 ; which where possible follow a standard pattern of syntax regardless
 ; of the component being operated upon, such as:
 ;
 ; get: copy values of component from string
 ; set: change values of component in string (or create new ones)
 ; mat: change values of component to background values
 ; cut: remove component from string
 ; put: insert new component into string
 ; net: remove component(s) from string and assign to variable
 ; cnt: count component(s) (string length in component(s))
 ; bld: build some or all of a string from scratch
 ; len: length of component(s) (component length in characters)
 ;
 ; So, for example, getslice will get us the value of the identified
 ; slice of a string, getcol will get us the value of the identified
 ; column, getpiece the value of the piece, and so on. Where get &
 ; mat generally manipulate the values of existing components, cut &
 ; put manipulate the number of such components, set can do either, &
 ; net combines get & cut for convenience of a certain kind of
 ; parsing.
 ;
 ; For methods that do not fit this pattern, intuitive names will be
 ; sought out that fit & extend the suite of methods. Where possible,
 ; new patterns will be developed to continue to make it easy to learn
 ; where to look for any given method.
 ;
 ;
 ;
 ;@section 3 string datatype method-naming patterns
 ;
 ;
 ;
 ; 3.1. The canonical names for the Case-conversion Library elements
 ; will consist of two or three letters to identify the case followed by
 ; the word "case":
 ;
 ; $$upcase^%ts = uppercase
 ; $$lowcase^%ts = lowercase
 ; $$capcase^%ts = capitalized case (capitalize 1st letter of each)
 ; $$invcase^%ts = inverse case (uppers to lowers & lowers to uppers)
 ; $$sencase^%ts = sentence-case (1st letter)
 ;
 ; Their abbreviated forms end in c:
 ;
 ; $$uc^%ts
 ; $$lc^%ts
 ; $$cc^%ts
 ; $$ic^%ts
 ; $$sc^%ts
 ;
 ; Their full names are these:
 ;
 ;    $$upperCase^%ts
 ;    $$lowerCase^%ts
 ;  $$capitalCase^%ts
 ;  $$inverseCase^%ts
 ; $$sentenceCase^%ts
 ;
 ; The two primitive methods for case conversion (one returns the
 ; lowercase alphabet, the other the uppercase) use a parallel naming
 ; pattern based on "alpha" instead of "case":
 ;
 ; $$upalpha^%ts
 ; $$lowalpha^%ts
 ;
 ; Their abbreviated forms, which we do not expect to use often, end in
 ; ac:
 ;
 ; $$uac^%ts
 ; $$lac^%ts
 ;
 ; Their full names are there:
 ;
 ; $$upperAlpha^%ts
 ; $$lowerAlpha^%ts
 ;
 ; Their old names, which we will keep until all calls to them are
 ; replaced, are these:
 ;
 ; $$ALPHABET^%ts
 ; $$alphabet^%ts
 ;
 ;
 ; 3.2. The canonical names for the Extract Library elements:
 ;
 ; $$getex^%ts = get extract
 ;   setex^%ts = set extract
 ;   matex^%ts = mat extract
 ;   cutex^%ts = cut extract
 ;   putex^%ts = put extract
 ;   netex^%ts = net extract
 ;  findex^%ts = find extract
 ;
 ; Their abbreviated names:
 ;
 ; $$ge^%ts
 ;   se^%ts
 ;   me^%ts
 ;   ce^%ts
 ;   pe^%ts
 ;   ne^%ts
 ;   fe^%ts
 ;
 ; Their full names:
 ;
 ; $$getExtract^%ts
 ;   setExtract^%ts
 ;   matExtract^%ts
 ;   cutExtract^%ts
 ;   putExtract^%ts
 ;   netExtract^%ts
 ;  findExtract^%ts
 ;
 ; Plus industry-convention names, where appropriate:
 ;
 ;  find^%ts = findex^%ts
 ; place^%ts = setex^%ts
 ;
 ; In addition, there will be at least three new groups of extract
 ; functions that are wrappers around the above suite:
 ;
 ; left extracts (1st n characters):
 ;
 ; $$getlex^%ts
 ;   setlex^%ts
 ;   matlex^%ts
 ;   cutlex^%ts
 ;   putlex^%ts
 ;   netlex^%ts
 ;
 ; $$gle^%ts
 ;   sle^%ts
 ;   mle^%ts
 ;   cle^%ts
 ;   ple^%ts
 ;   nle^%ts
 ;
 ; $$getLeftExtract^%ts
 ;   setLeftExtract^%ts
 ;   matLeftExtract^%ts
 ;   cutLeftExtract^%ts
 ;   putLeftExtract^%ts
 ;   netLeftExtract^%ts
 ;
 ; right extracts (last n characters):
 ;
 ; $$getrex^%ts
 ;   setrex^%ts
 ;   matrex^%ts
 ;   cutrex^%ts
 ;   putrex^%ts
 ;   netrex^%ts
 ;
 ; $$gre^%ts
 ;   sre^%ts
 ;   mre^%ts
 ;   cre^%ts
 ;   pre^%ts
 ;   nre^%ts
 ;
 ; $$getRightExtract^%ts
 ;   setRightExtract^%ts
 ;   matRightExtract^%ts
 ;   cutRightExtract^%ts
 ;   putRightExtract^%ts
 ;   netRightExtract^%ts
 ;
 ; mid extracts (n characters starting at position p):
 ;
 ; $$getmex^%ts
 ;   setmex^%ts
 ;   matmex^%ts
 ;   cutmex^%ts
 ;   putmex^%ts
 ;   netmex^%ts
 ;
 ; $$gme^%ts
 ;   sme^%ts
 ;   mme^%ts
 ;   cme^%ts
 ;   pme^%ts
 ;   nme^%ts
 ;
 ; $$getMidExtract^%ts
 ;   setMidExtract^%ts
 ;   matMidExtract^%ts
 ;   cutMidExtract^%ts
 ;   putMidExtract^%ts
 ;   netMidExtract^%ts
 ;
 ; Industry convention names:
 ;
 ;  $$left^%ts = $$getlex
 ; $$right^%ts = $$getrex
 ;   $$mid^%ts = $$getmex
 ;
 ;
 ; 3.3. The canonical names for the Find Library elements:
 ;
 ; $$getfind^%ts = get found substring
 ;   setfind^%ts = set found substring
 ;   matfind^%ts = mat found substring
 ;   cutfind^%ts = cut found substring
 ;   putfind^%ts = put found substring
 ;   netfind^%ts = net found substring
 ;
 ; Their abbreviated names:
 ;
 ; $$gf^%ts
 ;   sf^%ts
 ;   mf^%ts
 ;   cf^%ts
 ;   pf^%ts
 ;   nf^%ts
 ;
 ; Their full names (only different in capitalization):
 ;
 ; $$getFind^%ts
 ;   setFind^%ts
 ;   matFind^%ts
 ;   cutFind^%ts
 ;   putFind^%ts
 ;   netFind^%ts
 ;
 ; Plus industry-convention names, where appropriate:
 ;
 ;     replace^%ts = setfind^%ts
 ; findReplace^%ts = setfind^%ts
 ;  findDelete^%ts = cutfind^%ts
 ;
 ; In addition, there will be at least three new groups of find
 ; functions that are wrappers around the above suite:
 ;
 ; left finds (everything to the left of a found substring):
 ;
 ; $$getlfind^%ts
 ;   setlfind^%ts
 ;   matlfind^%ts
 ;   cutlfind^%ts
 ;   putlfind^%ts
 ;   netlfind^%ts
 ;
 ; $$glf^%ts
 ;   slf^%ts
 ;   mlf^%ts
 ;   clf^%ts
 ;   plf^%ts
 ;   nlf^%ts
 ;
 ; $$getLeftFind^%ts
 ;   setLeftFind^%ts
 ;   matLeftFind^%ts
 ;   cutLeftFind^%ts
 ;   putLeftFind^%ts
 ;   netLeftFind^%ts
 ;
 ; right finds (everything to the right of a found substring):
 ;
 ; $$getrfind^%ts
 ;   setrfind^%ts
 ;   matrfind^%ts
 ;   cutrfind^%ts
 ;   putrfind^%ts
 ;   netrfind^%ts
 ;
 ; $$grf^%ts
 ;   srf^%ts
 ;   mrf^%ts
 ;   crf^%ts
 ;   prf^%ts
 ;   nrf^%ts
 ;
 ; $$getRightFind^%ts
 ;   setRightFind^%ts
 ;   matRightFind^%ts
 ;   cutRightFind^%ts
 ;   putRightFind^%ts
 ;   netRightFind^%ts
 ;
 ; mid finds (everything between two found substrings):
 ;
 ; $$getmfind^%ts
 ;   setmfind^%ts
 ;   matmfind^%ts
 ;   cutmfind^%ts
 ;   putmfind^%ts
 ;   netmfind^%ts
 ;
 ; $$gmf^%ts
 ;   smf^%ts
 ;   mmf^%ts
 ;   cmf^%ts
 ;   pmf^%ts
 ;   nmf^%ts
 ;
 ; $$getMidFind^%ts
 ;   setMidFind^%ts
 ;   matMidFind^%ts
 ;   cutMidFind^%ts
 ;   putMidFind^%ts
 ;   netMidFind^%ts
 ;
 ; We also two functions that have only conventional names, not
 ; systematic ones.
 ;
 ;   $$produce^%ts = repeat find & replace substrings
 ;   $$replace^%ts = find & replace substrings
 ;
 ; setfind's features will be expanded to include $$replace, so that
 ; $$replace can become just an alternate name of findrep. The same
 ; may be done with $$produce.
 ;
 ;
 ; 3.4. For the string-format conversions, again we need both short
 ; & long names. For the short names, we adopt the convention of
 ; identifying the format in question with a secondary alphabet:
 ;
 ; s = Mumps string value (aka "normal" string)
 ; l = Mumps string literal
 ; u = Unix string literal
 ; h = html string literal
 ;
 ; then use the t as a delimiter meaning to:
 ;
 ; $$stl^%ts = Mumps string value => Mumps string literal
 ; $$stu^%ts = Mumps string value => Unix string literal
 ; $$sth^%ts = Mumps string value => HTML string literal
 ; $$lts^%ts = Mumps string literal => Mumps string value
 ; $$uts^%ts = Unix string literal => Mumps string value
 ; $$hts^%ts = HTML string literal => Mumps string value
 ;
 ; The longer, clearer names prepend the word "form" for format:
 ;
 ; $$formstl^%ts
 ; $$formstu^%ts
 ; $$formsth^%ts
 ; $$formlts^%ts
 ; $$formuts^%ts
 ; $$formhts^%ts
 ;
 ; These names need to be standardized.
 ;
 ;
 ; 3.5. String justification is perhaps the second-most used suite of
 ; methods:
 ;
 ; $$rj^%ts = right justify
 ; $$lj^%ts = left justify
 ; $$cj^%ts = center justify
 ;
 ; and for the longer, clearer names:
 ;
 ; $$rjustify^%ts
 ; $$ljustify^%ts
 ; $$cjustify^%ts
 ;
 ; $$$repeat & $$trim need to live here too, because they are used for
 ; the same purposes as the justify functions, to read & write reports
 ; & tables:
 ;
 ; $$repeat^%ts = repeat a character
 ; $$trim^%ts = trim character from end(s) of string
 ;
 ;
 ; 3.6. Merging has its own subalphabet of structural formats:
 ;
 ; a = array
 ; p = pieces
 ; s = slices
 ; t = table
 ; v = variables
 ;
 ; The abbreviations are named on the Merge X=Y metaphor. Some of these
 ; change structures rather than just calculate values, others just
 ; calculate a value, so some are functions & others are procedures.
 ; Most of the combos are not yet written, but these are done or in
 ; progress:
 ;
 ;   aep^%ts = array <= pieces
 ; $$pea^%ts = pieces <= array
 ;   vep^%ts = variables <= pieces
 ; $$pev^%ts = pieces <= variables
 ;   ves^%ts = variables <= slices [unfinished]
 ; $$sev^%ts = slices <= variables [unfinished]
 ;
 ; The longer, clearer names prepend "merge":
 ;
 ;   mergeaep^%ts
 ; $$mergepea^%ts
 ;   mergevep^%ts
 ; $$mergepev^%ts
 ;   mergeves^%ts
 ; $$mergesev^%ts
 ;
 ;
 ; 3.7. The Piece Library does not yet exist, but its core methods will
 ; follow the component-method naming schema for abbreviations:
 ;
 ; $$gp^%ts = get piece, copy value of delimited substring
 ;   sp^%ts = set piece, change (or create) value of delimited substring
 ;   mp^%ts = mat piece, change value of delimited substring to spaces
 ;   cp^%ts = cut piece, remove delimited substring
 ;   pp^%ts = put piece, insert new delimited substring
 ;   np^%ts = net piece, remove delimited substring & assign to variable
 ;
 ; and longer, clearer names:
 ;
 ; $$getpiece^%ts
 ;   setpiece^%ts
 ;   matpiece^%ts
 ;   cutpiece^%ts
 ;   putpiece^%ts
 ;   netpiece^%ts
 ;
 ;
 ; 3.8. The Pattern library will be called often, so we go back to
 ; two-letter abbreviations. Currently, they start with p, but that's
 ; not a sustainable pattern; it should probably be changed to follow
 ; the component pattern using m or pm as its suffix. There's only one
 ; so far:
 ;
 ;      $$pm^%ts = get pattern mask
 ; $$patmask^%ts
 ;
 ; 3.9. The Slice library follows the component-method naming schema:
 ;
 ; $$gs^%ts = get slice(s) of string
 ;   ss^%ts = set slice(s) of string
 ;   ms^%ts = mat-out slice(s) in string
 ;   cs^%ts = cut slice(s) from string
 ;   ps^%ts = put new slice(s) into string
 ;
 ; and
 ;
 ; $$getslice^%ts
 ;   setslice^%ts
 ;   matslice^%ts
 ;   cutslice^%ts
 ;   putslice^%ts
 ;
 ;
 ; 3.9. The Table Library is also named according to the component-
 ; method schema, where the component is a column:
 ;
 ; $$hc^%ts = build header row of columns from table definition
 ; $$rc^%ts = build row of columns from table definition
 ;   sc^%ts = set column into table row
 ; $$lc^%ts = length of column
 ; $$jc^%ts = justify a field to create a column
 ;
 ; $$hdrcolumn^%ts
 ; $$rowcolumn^%ts
 ;   setcolumn^%ts
 ; $$lencolumn^%ts
 ; $$juscolumn^%ts
 ;
 ; There are a lot more methods planned for tables, but their names
 ; have not yet fully been baked as ideal extensions of this suite.
 ;
 ;
 ; 3.10. The Validation Library is not yet named coherently & so far
 ; includes but a single function:
 ;
 ;       $$vg^%ts = validate graphic string
 ; $$vgraphic^%ts
 ;
 ; And then there are these two functions that probably belong in the
 ; Validation Library
 ;
 ;      $$only^%ts = only keep character(s) in string
 ;     $$strip^%ts = strip character(s) from string
 ;
 ;
 ; 3.11. The map of these apis with the code that implements them
 ; can be found in routine ^%ts.
 ;
 ;
 ;
 ;@section 4 string datatype library contents & to-do
 ;
 ;
 ;
 ; On 2018-02-22 I reset the contents of the String library to only
 ; include methods with 90% or better coverage by unit tests.
 ;
 ;@module-contents
 ; %ts: mumps string library apis
 ; %tsc: string-case tools
 ;[%tse: string-extract tools]
 ;  %tsef: find position of substring
 ;  $tses: set extract, change value of positional substring
 ;[%tsf: string-find tools]
 ;  %tsfs: setfind, find & replace substring
 ;[%tsj: string-justify tools]
 ;  $tsjt: trim character from end(s) of string
 ;[%tsu: utilities for the string datatype library]
 ;  %tsud: documentation
 ;   %tsudf: find notes
 ;  %tsul: primary development log
 ;  %tsut: nunit (unit tests & code coverage for string methods)
 ;   %tsutef: unit tests for find^%ts
 ;   $tsutes: unit tests for setextract^%ts
 ;   %tsutfs: unit tests for findrep^%ts
 ;   %tsutjt: unit tests for $$trim^%ts
 ;   %tsutvs: unit tests for $$strip^%ts
 ;[%tsv: string-validation tools]
 ;  %tsvs: strip character(s) from string
 ;
 ;@to-do
 ; bring over methods & create unit tests for them
 ; %tse: get extract, set extract, cut extract, put extract
 ;   $$left
 ;   $$right
 ;   $$mid
 ; %tsp: get piece, set piece, cut piece, put piece
 ; %tspm: pattern-match extensions
 ;   get pattern
 ;   get pattern mask
 ;   pattern-match string extraction
 ;   pattern negation
 ;   pattern alternation
 ;   character-set-driven pattern codes
 ; %tsre?: regular expressions
 ; %tsw: string walkers
 ; %ts?: masking functions
 ; Javascript methods:
 ;   http://www.w3schools.com/js/js_string_methods.asp
 ; make negative work from end backward
 ;
 ;@module-contents [on shelf]
 ; %ts: mumps string library apis [larger shelved version]
 ; %tsf: string-find tools
 ;  %tsfp: produce, repeat find & replace substrings, fold into setfind
 ;  %tsfs: replace, find & replace substrings, fold into %tsfs, setfind
 ; %tsf: string-format tools
 ;  %tsfhs: format html string as normal string
 ;  %tsfls: format string literal as normal string
 ;  %tsfsh: format string as html string
 ;  %tsfsl: format string as string literal
 ;  %tsfsu: format string as unix string
 ;  %tsfus: format unix string as normal string
 ; %tsj: string-justify tools
 ; %tsm: string-merge tools
 ;  %tsmap: merge array = pieces
 ;  %tsmpa: merge pieces = array
 ;  %tsmpv: merge pieces = variables
 ;  %tsmsv: merge slices = variables
 ;  %tsmvp: merge variables = pieces
 ;  %tsmvs: merge variables = slices
 ; %tsp: string-piece tools
 ; %tspm: string-pattern-match tools
 ; %tss: string-slice tools
 ;  %tssc: cut slice(s) from string
 ;  %tssg: get slice(s) of string
 ;  %tssm: mat-out slice(s) in string
 ;  %tssp: put new slices into string
 ;  %tsss: set slice(s) of string
 ; %tst: string-table tools
 ;  %tsthc: build header row of columns from table definition
 ;  %tstjc: justify a field to create a column
 ;  %tstlc: length of column
 ;  %tstrc: build row of columns from table definition
 ;  %tstsc: set column into table row
 ; %tsv: string-validation tools
 ;  %tsvo: only keep character(s) in string
 ; %tsu: utilities for the string datatype library
 ;  %tsum: meters (timers for string methods)
 ;
 ;
 ;
eor ; end of routine %tsud
