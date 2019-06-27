#!/bin/bash
source /home/osehra/etc/env
export SHELL=/bin/false
export gtm_nocenable=true
exec $gtm_dist/mumps -run ^ZU
