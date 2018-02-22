%tsutrt ;ven/mcglk&toad-type string: test $$trim ;2018-02-22T19:46Z
 ;;1.8;Mash;
 ;
 ; %tsutrt implements eleven unit tests for api $$trim^%ts.
 ; See %tsrt for the code for $$trim^%ts.
 ; See %tsut for the whole unit-test library.
 ; See %tsud for documentation introducing the String library,
 ; including an intro to the String Replace library.
 ; See %tsul for the module's primary-development log.
 ; See %ts for the module's ppis & apis.
 ; %tsutrt contains no public entry points.
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
 ;@primary-dev: Ken McGlothlen (mcglk)
 ; mcglk@vistaexpertise.net
 ;@additional-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2016/2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-22T19:46Z
 ;@application: Mumps Advanced Shell (Mash)
 ;@module: Type String - %ts
 ;@version: 1.8T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@contents
 ; [all unit tests]
 ;
 ;
 ;
 ;@section 1 unit tests for $$trim^%ts
 ;
 ;
 ;
 ;@called-by
 ; M-Unit
 ;  EN^%ut (called by ^%tsut)
 ;  COVERAGE^%ut (called by cover^%tsut)
 ;@calls
 ; CHKEQ^%ut
 ; $$trim^%ts
 ;
 ;
 ;
trim01 ; @TEST $$trim^%ts(%s): trim spaces from both ends
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new result set result="May the hair on your toes never fall out!"
 do CHKEQ^%ut($$trim^%ts(%s),result)
 ;
 quit  ; end of trim01
 ;
 ;
 ;
trim02 ; @TEST $$trim^%ts(%s,"LR"): trim spaces from both ends
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %e set %e="LR"
 new result set result="May the hair on your toes never fall out!"
 do CHKEQ^%ut($$trim^%ts(%s,%e),result)
 ;
 quit  ; end of trim02
 ;
 ;
 ;
trim03 ; @TEST $$trim^%ts(%s,"LR"," "): trim spaces from both ends
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %e set %e="LR"
 new %c set %c=" "
 new result set result="May the hair on your toes never fall out!"
 do CHKEQ^%ut($$trim^%ts(%s,%e,%c),result)
 ;
 quit  ; end of trim03
 ;
 ;
 ;
trim04 ; @TEST $$trim^%ts(%s,"L"): trim spaces from beginning
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %e set %e="L"
 new result set result="May the hair on your toes never fall out!     "
 do CHKEQ^%ut($$trim^%ts(%s,%e),result)
 ;
 quit  ; end of trim04
 ;
 ;
 ;
trim05 ; @TEST $$trim^%ts(%s,"L"," "): trim spaces from beginning
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %e set %e="L"
 new %c set %c=" "
 new result set result="May the hair on your toes never fall out!     "
 do CHKEQ^%ut($$trim^%ts(%s,%e,%c),result)
 ;
 quit  ; end of trim05
 ;
 ;
 ;
trim06 ; @TEST $$trim^%ts(%s,"R"): trim spaces from end
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %e set %e="R"
 new result set result="     May the hair on your toes never fall out!"
 do CHKEQ^%ut($$trim^%ts(%s,%e),result)
 ;
 quit  ; end of trim06
 ;
 ;
 ;
trim07 ; @TEST $$trim^%ts(%s,"R"," "): trim spaces from end
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %e set %e="R"
 new %c set %c=" "
 new result set result="     May the hair on your toes never fall out!"
 do CHKEQ^%ut($$trim^%ts(%s,%e,%c),result)
 ;
 quit  ; end of trim07
 ;
 ;
 ;
trim08 ; @TEST $$trim^%ts(%s,"ZQ"," "): no-op
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %e set %e="ZQ"
 new %c set %c=" "
 new result set result=%s
 do CHKEQ^%ut($$trim^%ts(%s,%e,%c),result)
 ;
 quit  ; end of trim08
 ;
 ;
 ;
trim09 ; @TEST $$trim^%ts(%s,"LR","*"): something other than a space
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="*****May the hair on your toes never fall out!*****"
 new %e set %e="LR"
 new %c set %c="*"
 new result set result="May the hair on your toes never fall out!"
 do CHKEQ^%ut($$trim^%ts(%s,%e,%c),result)
 ;
 quit  ; end of trim09
 ;
 ;
 ;
trim10 ; @TEST $$trim^%ts(%s,," "): missing second argument
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="     May the hair on your toes never fall out!     "
 new %c set %c=" "
 new result set result="May the hair on your toes never fall out!"
 do CHKEQ^%ut($$trim^%ts(%s,,%c),result)
 ;
 quit  ; end of trim10
 ;
 ;
 ;
trim11 ; @TEST $$trim^%ts(%s,," "): trim to nothing
 ;
 ;ven/mcglk&toad;test;procedure;clean?;silent?;sac
 ;
 new %s set %s="                                    "
 new %c set %c=" "
 new result set result=""
 do CHKEQ^%ut($$trim^%ts(%s,,%c),result)
 do CHKEQ^%ut($$trim^%ts(%s,"L",%c),result)
 do CHKEQ^%ut($$trim^%ts(%s,"R",%c),result)
 do CHKEQ^%ut($$trim^%ts(%s,"LR",%c),result)
 ;
 quit  ; end of trim11
 ;
 ;
 ;
eor ; end of routine %tsutrt
