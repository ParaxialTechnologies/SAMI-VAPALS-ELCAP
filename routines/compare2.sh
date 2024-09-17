#!/bin/sh

for FILE in *.m; do
    diff -u "$FILE" "/home/osehra/run/routines/${FILE##*/}"
    echo $FILE
done | less

