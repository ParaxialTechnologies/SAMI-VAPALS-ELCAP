%wful ;ven/toad-web form: development log ;2018-03-07T17:34Z
 ;;1.8;Mash;
 ;
 ; %wful is the Web Form Library's primary-development log.
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
 ;@copyright: 2017/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-03-07T17:34Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Web Form - %wf
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@module-credits
 ;@primary-dev: George P. Lilly (gpl)
 ; gpl@vistaexpertise.net
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017, gpl
 ;@funding: 2017, ven
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
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
 ; 2017-02-27/09-18 ven/gpl %*1.7t03 %yottaq: original routine developed
 ;
 ; 2017-09-25 ven/gpl %*1.7t03 %yottaq: split lines containing >1
 ; <input> tag to aid parsing; replace quotes with &quot; to aid
 ; parsing; in wsGetForm.
 ;
 ; 2017-10-02 ven/gpl %*1.7t03 %wfhform: renamespace under %wf and move
 ; all subroutines related to wsGetForm & wsPostForm to this new
 ; routine; all other subroutines went elsewhere, including under %wd;
 ; begin spelling out mumps language elements; remove dead code; new
 ; subroutines initforms & initform1.
 ;
 ; 2017-10-04 ven/gpl %*1.7t03 %wfhform: r/initforms & initform1
 ; w/validate, dateValid, textValid, numValid.
 ;
 ; 2017-10-07 ven/gpl %*1.7t03 %wfhform: in wsGetForm r/postform w/form
 ; action, r/.5 w/.001 in <input> split, insert new validation block,
 ; insert debugging line after validation; new insError; in wsPostForm
 ; add validation block; in validate & dateValid add mew msg param.
 ;
 ; 2017-10-24 ven/gpl %*1.7t03 %wfhform: in wsGetForm r/id, handle
 ; temporary values, call $$replaceSrc to fix css & js href values, call
 ; debugFld as needed; add debugFld, replaceSrc, replaceAll; in replaceHref
 ; add conds sami2.js, jquery-3.2.1.min.js, jquery-ui.min.js; in insError
 ; expand to append error inserts to more than just </input>; in setVals
 ; clear old graph before merging new one in.
 ;
 ; 2017-10-30 ven/gpl %*1.7t03 %wfhform: in wsGetForm add param post to
 ; support posting w/o retrieving; in wsPostForm use new param, after
 ; validation block add filing into Fileman & returning the record.
 ;
 ; 2017-10-31 ven/gpl %*1.7t03 %wfhform: in wsGetForm comment out fixing
 ; css & js values, reformat if date; add dateFormat.
 ;
 ; 2017-11-15 ven/gpl %*1.7t03 %wfhform: in wsGetForm preserve graph
 ; variables not saved in fileman, remove error section, support new debug
 ; flags for form, support 2nd error method; add redactErr, redactErr2,
 ; testRedactErr2, putErrMsg2, delText; in dateFormat be more flexible;
 ; move replaceSrc & replaceHref to end; in wsPostForm use new status
 ; param in call to fileForm^%wffiler; in validate make default type free
 ; text to support weeding out bad characters.
 ;
 ; 2017-12-20 ven/gpl %*1.7t03 %wfhform: in wsGetForm add special handling
 ; for sbform2, chg default form handling to call $$getTemplate, add temp
 ; hack for elcap forms (gpl), introduce use of form label in form action,
 ; restore fixes of css & js values, skip table lines, improve handling of
 ; option selected, stop adding crlf; add formLabel, getTemplate;
 ; in putErrMsg2 don't insert errors if nowhere to put them, refine
 ; insError; in unvalue & value handle missing value=; in wsPostForm don't
 ; quit on error for sbform2; in replaceSrc skip inserting see service if
 ; href is javascript.
 ;
 ; 2018-01-03 ven/gpl %*1.8t04 %wfhform: in wsGetForm call SAMISUBS^SAMIFRM
 ; & replace line, comment out post action; in wsPostForm only return fm
 ; record & set status if sbform.
 ;
 ; 2018-01-17 ven/gpl %*1.8t04 %wfhform: in wsGetForm use filter("fvalue")
 ; if present to set sid, combine handling of sbform & sbform2, comment
 ; out temp elcap forms hack, overhaul processing of action, struggle w/
 ; checkboxes & radio buttons; in getTemplate comment out special handling
 ; of sbform & sbform2; in uncheck & check wrestle with radio buttons &
 ; checkboxes; in wsPostForm generalize handling of sbforms; in replaceSrc
 ; handle quotes.
 ;
 ; 2018-01-22 ven/toad %1.8t04 %wful: create development-log routine.
 ;  %wf: passim hdr comments, mash style, rearrange subroutines.
 ;  %wfhform: passim hdr comments, spell out mumps language elements,
 ; add do-dot quits, white space, rearrange subroutines.
 ;
 ; 2018-01-31/02-03 ven/toad %1.8t04 %wful: hdr comments include project
 ; & partner-org & refine copyright.
 ;  %wf & %wfhform: hdr comments refine credits, add to-do; finish laying
 ; out sections & rearranging subroutines.
 ;
 ; 2018-02-04 ven/gpl %1.8t04 %wfhform: in wsGetForm work on customScan
 ; logic, add special handling for form sbform3, protect vs undef val in
 ; two places; in replace protect vs undef ln; in getVals ensure if
 ; graph undef for this patient return 0 node.
 ;  %wf: in wsGetForm add optional param post; add ppi $$getTemplate^%wf,
 ; putErrMsg2^%wf, $$validate^%wf, $$dateValid^%wf, $$textValid^%wf,
 ; $$numValid^%wf, dateFormat^%wf; in replaceAll fix toad's dp typo.
 ;
 ; 2018-02-05 ven/toad %1.8t04 %wf: passim finish creating remaining ppis
 ; $$formLabel^%wf, redactErr^%wf, redactErr2^%wf, insError^%wf,
 ; debugFld^%wf, $$delText^%wf, & test testRedactErr2^%wfhform, adjust
 ; param passing to match %wfhform protections, remove my old ppi comments,
 ; spell out language elements, refine ppi comments, move replaceAll up
 ; to section 4.
 ;  %wfhform: refine ppi comments, spell out language elements, note calls
 ; from outside routine; move replaceAll up to section 4, add calls from
 ; outside routine.
 ;  %wffiler: apply hdr comments, white space, spell out language elements,
 ; r/getVals^%wfhform w/getVals^%wf, add do-dot quits.
 ;  %wffmap: apply hdr comments, white space, spell out language elements,
 ; add do-dot quits; in importfmap synch ppi comments.
 ;
 ; 2018-02-11 ven/toad %1.8t04 %wf & %wfhform: passim update calls &
 ; called-by tags & add ppi-called-by, standardize API, ppi, ws tags &
 ; comments, convert %wf's calls to %wfhform to gotos, convert %wfhform
 ; labels to receive gotos, repoint check & uncheck^%wf to %wfhradio
 ; then to %wfhinput, annotate wsGetForm & break into stanzas.
 ;  %wfhradio->%wfhinput: new routine fr/check & uncheck^%wfhform,
 ; rename to %wfhinput, refactor check & uncheck, make check only
 ; apply standard checked attribute.
 ;  %wf,%wfhinput,%wfhform: add & use $$type^%wf ppi, make it & check
 ; & uncheck read any case of INPUT or TYPE or CHECKED as per html
 ; standard but only write lowercase, as per html convention.
 ;
 ; 2018-02-13/03-01 ven/toad %1.8t04 %wf,%wfhfind,%wfhform,SAMIFRM,
 ; SAMICASE: move code for ppis $$delText^%wf,replace^%wf,replaceAll^%wf
 ; fr/%wfhform to/%whfhfind, repoint ppis to moved code, rename
 ; $$delText->deleteBetween (function->procedure), replace->findReplace,
 ; replaceAll->findReplaceAll, change all calls to ppis to match, add
 ; ppis find^%wf & replace^%wf to do case-insensitive find & replace,
 ; rename replace => place. move replace^%wf => setextract^%ts &
 ; replace^%wfhfind => setextract^%tses. find^%wf => find^%ts,
 ; find^%wfhfind => find^%tsef. findReplace^%wf => findReplace^%ts &
 ; repoint calls to it from %wfhform & %wfhinput. fold George's 02-27
 ; mod into my %wfhform; eliminate findReplaceAll^%wfhfind in favor of
 ; findReplace^%ts with A flag; remove findReplaceAll^%wf.
 ;
 ; 2018-02-27 ven/gpl 1.8t04 %wfhform: in getVals load prefill values
 ; by calling $$sid2num^SAMIHOME.
 ;
 ; 2018-03-05 ven/toad %1.8t04 %wfhinput: in uncheck,check,type use
 ; new calls, add examples, & be cautious about lowercase, rename
 ; module => Web form Library.
 ;  %wffiler: update headers & white space
 ;  %wffmap: update headers & white space
 ;  %wfhfind: update headers
 ;  %wfhform: update headers
 ;  %wfut: create core unit-test routine.
 ;  %wfuthi: create html input unit-test routine.
 ;
 ; 2018-03-07 ven/toad %1.8t04 %wfhform: in parseBody,weGetForm update
 ; called-by.
 ;
 ;@to-do
 ; use find & place in other three ppis
 ;
 ;@module-contents
 ; %wf: write form ppi & api library
 ; %wffiler: fileman-to-form interfaces
 ; %wffmap: fileman-to-form maps
 ; %wfhform: graph-to-form interfaces
 ; %wfhinput: process input tags, including radio & checkbox
 ; %wful: primary-development log
 ; %wfut: unit tests
 ; %wfuthi: unit tests for html input tags
 ;
 ;
 ;
eor ; end of routine %wful
