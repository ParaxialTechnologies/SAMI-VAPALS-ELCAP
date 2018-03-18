%tsul ;ven/toad-type string: development log ;2018-03-18T14:30Z
 ;;1.8;Mash;
 ;
 ; %tsul is the Mumps String Library's primary-development log.
 ; See %tsud for documentation introducing the library.
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
 ;@last-updated: 2018-03-18T14:30Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@module-credits
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@original-dev: Ed de Moel (edm)
 ;@additional-dev: Richard Walters (rw)
 ;@additional-dev: Alfons Puig (ap)
 ;@additional-dev: Jon Diamond (jd)
 ;@additional-dev: Arthur B. Smith (abs)
 ;@additional-dev: David J. Marcus (djm)
 ;@additional-dev: David J. Whitten (djw)
 ;@additional-dev: Alan Frank (af)
 ;@additional-dev: Victor Grishkan (vg)
 ;@additional-dev: R. Wally Fort (rwf)
 ;@additional-dev: Zach Gonzales (kbaz/zag)
 ;@additional-dev: Ed de Moel (edm)
 ;@additional-dev: Ken McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@additional-dev: Linda M. R. Yaw (lmry)
 ; lmry@vistaexpertise.net
 ;
 ;@original-dev-org: Mumps Development Committee (mdc)
 ;@additional-dev-org: U.S. Department of Veterans Affairs
 ; prev. Veterans Administration
 ; National Development Office in San Francisco (vaisf)
 ;@additional-dev-org: VA Puget Sound Health Care System (vapug) 
 ; [many more, fill in later]
 ;
 ;@project-credits
 ;@project: Mumps Development Committee (mdc)
 ;@project: eHealth Exchange Prefetch (ehex)
 ;@project: Electronic Health Management Platform (ehmp)
 ;@project: Taskman Version 9 (tm9)
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (va-pals)
 ; http://va-pals.org/
 ;
 ;@funding: 1987/1998, many many mdc organizations & individuals
 ;@funding: 1994/2006, vaisf
 ;@funding: 2002, vapug
 ;@funding: 2012/2018, toad
 ;@funding: 2012/2018, ven
 ;@funding: 2016/2017, Electronic Health Solutions (ehs)
 ; http://ehs.com.jo
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log
 ; 1987-11/1995-10 mdc/edm: create PRODUCE Library Function & REPLACE
 ; Library Function to add to standard code library $%PRODUCE^STRING &
 ; $%REPLACE^STRING, proposals based on separate initial proposals by
 ; Richard Walters (mdc) and Alfons Puig (mdcc-e), include sample code
 ; for implementing these functions, approved by mdc, final extension
 ; documents x11/95-11 & x11/95-112.
 ;
 ; 1988-12/1998-06 mdc/djm&djw: create Data Record Functions to add to
 ; standard language $DPIECE & $DEXTRACT intrinsic functions, approved
 ; by mdc, final extension document x11/sc13/tg3/98-4.
 ;
 ; 1992/1996-02 mdc/af&djw&jd&vg: create Pattern Negation to upgrade
 ; standard language pattern-language operator, approved by mdc, final
 ; extension document x11/96-9.
 ;
 ; 1992/1997-01 mdc/af&djw&jd&vg: create Pattern Ranges to upgrade
 ; standard language pattern-language operator, approved by mdc, final
 ; extension document x11/97-3.
 ;
 ; 1993-07/1998-08 mdc/abs: create Pattern Match String Extraction to
 ; extend mumps patter-match operator, approved by mdc, final extension
 ; document x11/98-27.
 ;
 ; 1994-11-04 vaisf/rwf XU*8.0 XLFSTR: create routine. $$UP, $$LOW,
 ; $$STRIP, $$REPEAT, $$INVERT, $$REPLACE, $$RJ, $$LJ, $$CJ, $$QUOTE.
 ;
 ; ca. 1995 vaisf/toad DILF: create $$HTML to convert ^ and & in
 ; strings for use in HTML; create $$TRANSL8 to implement
 ; $%REPLACE to support $$HTML.
 ;
 ; 1996-03/1998-07 mdc/jd: create Miscellaneous Character Functions to
 ; formalize extending mumps standard to add to standard code library
 ; $%UPPER^STRING, $%LOWER^STRING, & $%PATCODE^STRING, approved by mdc,
 ; final extension document x11/98-21.
 ;
 ; 1999-02-23 vaisf/rwf XU*8*112 XLFSTR: add $$TRIM(x[,"[L][R]"]) to trim
 ; spaces from left, right, or both of string.
 ;
 ; 1999-06-17 vaisf/rwf XU*8*120 XLFSTR: add third param to $$TRIM to
 ; trim character other than space.
 ;
 ; 2002-03-13/14 vapug/toad ARJT*8*2 XLFSTR2: create routine. $$SEN,
 ; $$CAP, FIELDX.
 ;
 ; 2005-12-28 vaisf/rwf XU*8*400 XLFSTR: add $$SENTENCE & $$TITLE.
 ; based on design by sea/toad.
 ;
 ; 2006-12-19 vaisf/rwf XU*8*437 XLFSTR: add $$SPLIT. Fix bug in
 ; $$TRIM to trim spaces from " " properly.
 ;
 ; 2009-08-01/31 kbaz/zag v1.0 JJOHCASE: create routine as part of
 ; Paideia training, incl multiple string case-conversion & translation
 ; subroutines.
 ;
 ; 2012-04-24 kbaz/zag & ven/toad XVDSTR: create routine with FIELDX.
 ; add $$ESCAPE to convert strings for use with the unix enviroment to
 ; escape special characters.
 ;
 ; 2012-06-07 kbaz/zag & ven/toad XVDSTR: add ";" to the list of
 ; characters to escape.
 ;
 ; 2012-06-08 kbaz/zag & ven/toad %*0.1 XVDSTR: add "|" to the list of
 ; characters to escape.
 ;
 ; 2013-08-23 ven/toad XU*8.0*local XLFSTR2: add $$VALID, change
 ; history, header, EOR.
 ;
 ; 2015-06-05 ven/toad %*1.0 %sm: create routine. pta.
 ;
 ; 2015-11-12/13 ven/toad %*0.5 %s: fix version at 0.5; create routine
 ; w/ functions from XLFSTR, XLFSTR2, XVDSTR, & %sm. lowercase labels.
 ; delete fieldx; keep pta. upgrade & refactor $$title; remove $$cap.
 ; refactor $$sentence; remove $$sen. refactor $$up, $$low, $$strip,
 ; $$repeat. rename $$up -> $$uc, $$low -> $$lc, wrap w/ $$upcase,
 ; $$lowcase, rename $$sentence -> $$sc, $$title -> $$cc, wrap w/
 ; $$sencase, $$capcase. wrap pta w/ mergepta. convert $$split to
 ; procedure. rename split -> ptv, wrap w/ mergeptv.
 ;
 ; 2015-12-18/22 ven/toad %*0.5 %s: add missing string-merge tools to
 ; to-do list; finish building contents section; add to-do items from
 ; routine JJOHCASE; add it & produce & replace to history; delete
 ; $$quote & add to to-do list; rename $$escape -> $$unix; add $$HTML
 ; from routine DILF to to-do list; create $$alphabet & $$ALPHABET &
 ; use them; create $$ic & $$invcase from INVERT^JJOHCASE. Fix calls to
 ; $$lc & $$uc in $$sc & $$cc; comment %%uc, %%lc, $$ic, $$sc, $$cc;
 ; refactor $$rj, $$rjustify, $$lj, $$ljustify, $$cj, $$cjustify; create
 ; padtrunc, ctv, mergectv.
 ;
 ; 2016-01-31/02-09 ven/toad %*0.6 %ts: bump version to 0.6; create
 ; from %s; renamespace from %a* to %g*; add column-merge subroutines
 ; to to-do list; loosen namespaces of local variables, keep w/in %,
 ; focus on readability & brevity; refine comments; refactor & add
 ; defaults & max lengths to padtrunc, $$rj, $$lj, $$cj, $$repeat,
 ; $$strip; refactor $$trim; rewrite $$replace based on mdc/edm's
 ; $%replace^string proposal x11/1995-112, add isf/rwf's first few
 ; lines, split %spec into %find & %replace to support top-level
 ; params, define $$replace using examples in comments; temporarily
 ; fold in TRANSL8* subroutines for reference; create $$produce based
 ; on mdc/edm's $%produce^string proposal x11/1995-111, add rwf's 1st
 ; few lines from $$replace, split spec into %find & %replace, add
 ; support for top-level params; refactor $$unix -> $$stu; bring back &
 ; refactor rwf's $$QUOTE as $$stl; create $$sth from $$HTML^DILF,
 ; refactor, change encoded characters to the five standard ones -
 ; "&<>' - of modern html and xml; also create $$hts from $$HTML^DILF;
 ; create $$lts to convert a string literal back to a normal string
 ; (we've written this before in Fileman, though examples currently
 ; escape me); make $$stu only allow a single character (not a
 ; substring) to be used to escape; create $$uts to undo $$stu;
 ; refactor $$valid; add new to $$pta, more comments in pta, ptv, ctv;
 ; overhaul ptv and ctv; write $$atp; invert order of target and source
 ; in merge params to match merge command, rename from sourceTtarget to
 ; targetEsource, e.g., vec, edit call to $$ctv in $$cj to $$vec;
 ; overhaul aep; write $$pev; rename chunks to slices; write $$sev,
 ; $$mergesev, $$getslice, $$gs, add primitive operations (get, set,
 ; cut, put for extracts, pieces, slices, columns) to to-do list, add
 ; to to-do list negative positional params, distinguish slice length
 ; from string length in slices; $$uc -> $$u, $$lc -> $$l, $$ic -> $$i,
 ; $$sc -> $$s, $$cc -> $$c; write setslice, ss; add matslice &
 ; netslice to to-do list; write $$ms, $$matslice, cs, cutslice, ps,
 ; putslice. in $$s, $$l, $$i, $$s, $$c, padtrunc, $$rj, $$lj, $$cj,
 ; $$repeat, $$strip, $$trim, $$replace, $$TRANSL81, $$TRANSL8,
 ; $$TRNSL8S, $$produce, $$stu, $$uts, $$sth, $$hts, $$stl, $$lts,
 ; $$valid, $$gs, $$getslice, ss, setslice, ms, matslice, ps, putslice,
 ; aep, $$pea, $$mergepea, vep, $$pev, ves.
 ;
 ; 2016-03-01 ven/toad %*1.5 %ts: bump version to 1.5; upgrade comments
 ; to providing testing examples & list missing apis.
 ;
 ; 2016-03-11 ven/toad %*1.5 %ts,%tslice,%tslog: in contents, map out
 ; names of routines to break %ts content into. Add header
 ; introduction. Move bodies of string-slice subroutines to new routine
 ; %tslice. Move primary-development history to routine %tslog.
 ;
 ; 2016-03-11 ven/mcglk&toad %*1.5 %tsu: created routine to hold unit
 ; tests for MASH's string-type library, starting with $$trim &
 ; $$strip.
 ;
 ; 2016-04-04/05 ven/toad %*1.5 %ts,%tscol,%tslice: created routine %tscol to
 ; hold string-column subroutines; fix bug with set $extract in $$stl;
 ; fix bug with call to $$repeat^%ts in ms^%tslice; fix examples in
 ; $$stl^%ts.
 ;
 ; 2016-12-23/24 ven/toad %*1.7D01 %ts,%tsc,%tse,%tsf,%tsfhs,%tsfls,%tsfsh,
 ; %tsfsl,%tsfsu,%tsfus,%tsj,%tsm,%tsmap,%tsmpa,%tsmpv,%tsmsv,%tsmvp,
 ; %tsmvs,%tslice,%tsr,%tsrp,%tsrr,%tss,%tssc,%tssg,%tssm,%tssp,%tsss,
 ; %tst,%tsthc,%tstjc,%tstlc,%tstrc,%tstsc,%tsv: 
 ; design more methodical routine organization based on string
 ; alphabet, break up big string-library routines into small routines;
 ; replace %tscol with %tst* routines; apply new @API standard; fix
 ; breakup bugs in $$trim^%ts & throughout %tsc.
 ;
 ; 2017-04-27 ven/lmry %*1.7T02 %ts*: bump version to 1.7T02; stdize
 ; hdr lines.
 ;
 ; 2017-04-27 ven/lmry %*1.7T02 %tsfhs,tsfsh: update $$replace w/
 ; $$replace^%tsrr.
 ;
 ; 2017-04-27 ven/lmry %*1.7T02 %tsj: update ves w/ mergeves^%tsmvs.
 ;
 ; 2017-04-27 ven/lmry %*1.7T02 %tssp: update ss w/ setslice^%tsss.
 ;
 ; 2017-05-25 ven/toad %*1.7T02 %ts*: update dates & chg history.
 ;
 ; 2017-08-31 ven/toad %*1.7T03 %ts,%tsp: bump version to 1.7T03; add
 ; patmask^%ts & pm^%ts & patmask^%tspm; move $$strip & $$trim from
 ; %tse to %tsrs & %tsrt, update to using @tags, add examples to
 ; $$strip; reorder apis in %ts alphabetically; add $$only^%ts &
 ; only^%tsro; create %tsurs & %tsurt to hold unit tests for $$strip &
 ; $$trim^%ts, change %tsu into a unit-test shell routine, & add
 ; cover^%tsu to run code-coverage.
 ;
 ; 2018-02-21/03-04 ven/toad %*1.8T04 %tsul,%tsud: rename %tslog =>
 ; %tsul; create %tsud; bump version to 1.8T04; update to more modern
 ; mash style; expand history to include rest of mdc string library &
 ; function extensions; move to-do to %tsul; list Javascript string
 ; methods. Reset String library to only include methods that have
 ; unit tests. Move to-do & module-contents to %tsud.
 ;  %tsudr: move %tsr => %tsudr, update style, cut redundant, add to
 ; notes.
 ;  %tsrt: update style, clearer variable names, protect vs. undef
 ; string, stanza notation.
 ;  %ts: reset w/no apis, restore $$trim,$$strip, case-conversion
 ; apis. add setextract,se,place,find.
 ;  %tsut: rename %tsu => %tsut, update style, chg cover^%tsut to use
 ; new unit-test routine, add cover## tests for no-entry-at-top quits,
 ; exclude cover^%tsut from coverage.
 ;  %tsurt: rename %tsurt => %tsutrt, update style.
 ;  $tsrs: update style, clearer variable names, stanza notation.
 ;  %tsutrs: rename %tsurs => %tsutrs, update style.
 ;  %tsc: update style, clearer variable names, stanza notation.
 ;  %tses: move fr/place^%wfhfind & finish to be code for
 ; setextract^%ts.
 ;  %tsef: move fr/find^%wfhfind & finish to be code for find^%ts.
 ;  %tsrf: create from findReplace^%wfhfind, merge findReplaceAll
 ; features into findReplace.
 ;  %tsutrf: create w/unit tests for %tsrf.
 ;
 ; 2018-02-22 ven/lmry %*1.8T04 %tsutc: start %tsutc, wrote 32 unit 
 ; tests for string-case functions. Added to %tsut XTROU list for M-unit
 ; testing. One test fails for sencase06, but it's because I used a
 ; proper noun (France) which was de-capitalized in the process. This
 ; may be desired behavior but I'm going to check with toad to make
 ; sure.
 ;
 ; 2018-02-23 ven/lmry %*1.8T04 %tsutc, %tsut, %tses: change sencase06
 ; to not use a proper noun since the expected behavior is for all non
 ; first letter words should be lowercased. Added cover09 to %tsut for
 ; %tsc. Broke %tsutc into sections, updated subroutine header lines in
 ; %tsc. Update contents listing and fix a few non-significant typos in
 ; %tsut. Fixed type, added to to-do list in %tses.
 ;
 ; 2018-02-24/03-03 ven/lmry %*1.8T04 %tsutes, %tses: Build unit tests in
 ; %tsutes to cover %tses. Correct errors in %tses examples found while
 ; testing new unit tests. Jennifer Hackett helped significantly in 
 ; reformatting examples into unit tests.
 ;
 ; 2018-03-04 ven/lmry %*1.8T04 %tsut, %tsutef: Add no-entry-from-top
 ; tests for %tses & %tsef. Convert examples in %tsef into unit tests.
 ;
 ; 2018-03-05 ven/toad %*1.8T04 %tsud: document reorg of string methods.
 ;  %tsudr => %tsudf: document new Find Library.
 ;  %tsrs => %tsvs, %tsutrs => %tsutvs
 ;  %tsrf => %tsfs, %tsutrf => %tsutfs
 ;  %tsrt => %tsjt, %tsutrt => %tsutjt
 ;  %ts: repoint to moved code, refine apis.
 ;
 ; 2018-03-08 ven/lmry %*1.8T04 %tsutef, %tsutes, %tsutc: Fuss with tests,
 ; add tests for synonyms.
 ;
 ; 2018-03-09/10 ven/lmry %*1.8T04 %tsutfs: Add a synoym test. %tsutes: fix
 ; test.
 ;
 ; 2018-03-12 ven/lmry %*1.8T04 %tsutes: Fuss w/tests, add some
 ; descriptions. Add tests to increase coverage. %tsutef: add unit test
 ; for uppercase flag coverage=100%.
 ;
 ; 2018-03-14/15 ven/lmry %*1.8T04 %tsut: Exclude unit test routines from
 ; reports, make clarifications in comments.
 ;
 ; 2018-03-18 ven/toad %*1.8t04 %tsudf: map out new plan for findReplace
 ; findReplaceAll, & deleteBetween.
 ;  %tsfwr: create new routine with code for findReplace^%ts.
 ;  %tsfwra: create new routine with code for findReplaceAll^%ts.
 ;  %ts: repoint findReplace^%ts to findReplace^%tswr, create
 ; findReplaceAll^%ts.
 ;
 ; 
 ;
eor ; end of routine %tsul
