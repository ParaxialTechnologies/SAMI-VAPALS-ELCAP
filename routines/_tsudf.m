%tsudf ;ven/toad-type string: documentation, find ;2018-03-18T16:37Z
 ;;1.8;Mash;
 ;
 ; %tsud introduces the public string datatype Find Library,
 ; whose code is implemented in the %tsf* routines.
 ; See %tsud for documentation introducing the String Library,
 ; including an intro to the String Find library.
 ; See %tsutf* for the unit tests for the Find Library.
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
 ;@last-updated: 2018-03-18T16:37Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@contents
 ;
 ;        setfind^%ts = set found substring (find & replace)
 ;             sf^%ts
 ;        setFind^%ts
 ;  code = %tsfs
 ;  tests = %tsutfs
 ;
 ;    findReplace^%ts
 ;  code = %tsfwr
 ;  tests = %tsutfwr
 ;
 ; findReplaceAll^%ts
 ;  code = %tsfwra
 ;  tests = %tsutfwra
 ;
 ;
 ;
 ;@section 1 Find Library notes
 ;
 ;
 ;
 ;@alphabet
 ;
 ; a = ?
 ; b = ?
 ; c = cut find [cf]
 ;   cl = cut left find [clf]
 ;   cr = cut right find [crf]
 ;   cm = cut mid find [cmf]
 ; d = ?
 ; e = ?
 ; f = ?
 ; g = get find? [gf]
 ;   gl = get left find [glf]
 ;   gr = get right find [grf]
 ;   gm = get mid find [gmf]
 ; h = ?
 ; i = ?
 ; j = ?
 ; k = ?
 ; l = ?
 ; m = mat find [mf]
 ;   ml = mat left find [mlf]
 ;   mr = mat right find [mrf]
 ;   mm = mat mid find [mmf]
 ; n = net find [nf]
 ;   nl = net left find [nlf]
 ;   nr = net right find [nrf]
 ;   nm = net mid find [nmf]
 ; o = ?
 ; p = put find [pf]
 ;   pl = put left find [plf]
 ;   pr = put right find [prf]
 ;   pm = put mid find [pmf]
 ; r = ?
 ; s = set find (findReplace) [sf]
 ;   sl = set left find [slf]
 ;   sr = set right find [srf]
 ;   sm = set mid find [smf]
 ; t = ?
 ; u = utilities
 ; v = ?
 ; w = wrappers [simplified ways of calling main calls]
 ;   wd = findDelete
 ;   wdb = findDeleteBetween
 ;   wr = findReplace
 ;   wra = findReplaceAll
 ; x = ?
 ; y = user extensions
 ; z = implementor extensions
 ;
 ;
 ;@to-do
 ;
 ; create cutMidFind [deleteBetween]
 ; bring over & write unit tests for:
 ;  $$produce^%ts
 ;  $$replace^%ts
 ; revise $$replace to accept multiple strings [JJOHCASE & DILF]
 ; revise $$produce to accept multiple strings
 ; write the rest of the methods
 ; add max length protection to $$produce
 ;
 ;
 ; compare typical namespacing schema
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
 ;
 ; on the shelf
 ;
 ; $$produce^%ts
 ;  code = %tsrp => %tsfs
 ;  tests = %tsutp => %tsutfs
 ;
 ; $$replace^%ts
 ;  code = %tsrr => %tsfs
 ;  tests = %tsutr => %tsutfs
 ;
 ; setfind's features will be expanded to include $$replace, so that
 ; $$replace can become just an alternate name of setfind. The same
 ; may be done with $$produce.
 ;
 ;
 ; The canonical names for the Find Library elements:
 ;
 ; $$getfind^%ts = get found substring
 ;   matfind^%ts = mat found substring
 ;   cutfind^%ts = cut found substring
 ;   putfind^%ts = put found substring
 ;   netfind^%ts = net found substring
 ;
 ; Their abbreviated names:
 ;
 ; $$gf^%ts
 ;   mf^%ts
 ;   cf^%ts
 ;   pf^%ts
 ;   nf^%ts
 ;
 ; Their full names (only different in capitalization):
 ;
 ; $$getFind^%ts
 ;   matFind^%ts
 ;   cutFind^%ts
 ;   putFind^%ts
 ;   netFind^%ts
 ;
 ; Plus industry-convention names, where appropriate:
 ;
 ; findReplace^%ts = setfind^%ts
 ; findDelete^%ts = cutfind^%ts
 ;
 ; In addition, there will be at least three new groups of find
 ; functions that are wrappers around the base suite:
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
 ;
 ;
eor ; end of routine %tsudf
