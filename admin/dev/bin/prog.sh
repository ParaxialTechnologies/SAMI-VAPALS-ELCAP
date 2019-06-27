#!/bin/bash
source /home/osehra/etc/env
export SHELL=/bin/bash
#These exist for compatibility reasons
alias gtm="$gtm_dist/mumps -dir"
alias GTM="$gtm_dist/mumps -dir"
alias gde="$gtm_dist/mumps -run GDE"
alias lke="$gtm_dist/mumps -run LKE"
alias dse="$gtm_dist/mumps -run DSE"
$gtm_dist/mumps -dir
