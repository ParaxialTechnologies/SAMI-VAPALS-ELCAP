for file in *.m; do diff "$file" "/home/osehra/run/routines/${file##*/}"; done | less
