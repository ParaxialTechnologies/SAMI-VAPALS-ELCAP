#!/usr/bin/env python3
#
# This is intended to be run in the VAPALS-ELCAP project's docs/www directory.
# 
# Presently, we have an issue in some routine somewhere which is truncating
# lines at 255 characters, which is not at all HTML-compliant. But the
# HTML-compilation script, which takes Jinja2 files and converts them to HTML,
# uses Beautiful Soup to do the formatting---and that wants to write tags all
# on one line, and some of our tags with long attributes exceed 255
# characters. There's no way to tell Beautiful Soup not to do this.
# 
# The routine has also been deemed Too Complicated to Find and Fix Right
# Now---hence, the Regrettable Kludge, where offending lines were manually
# edited to fit within the 255-character limit every time the compilation
# script was run.
#
# The Regrettable Bodge makes that easier. It reads through each .html file
# looking for lines > 255 characters. If it finds one, it rewrites the file
# with the offending lines reformatted.
#
# This is a fragile script. It assumes that the offending lines will be tags
# alone on a line. If not, this will bork without rewriting the file, but will
# display the offending line as it dies. It also assumes that no attributes
# will be excessively long (it doesn't check for this; it just plows ahead),
# but that seems a relatively safe bet.

import pathlib
import re

#------------------------------------------------------------------------------

filelist = [x for x in pathlib.Path(".").iterdir() if x.suffix == ".html"]

hbar = "-" * 79

for path in filelist:
    newcontents = ""
    rewrite = False
    with path.open() as f:
        for line in f.readlines():
            if len(line) < 255:
                newcontents += line
                continue
            if not rewrite:
                print(f"*** Problem in {path}:\n{line}", end="")
            rewrite = True
            # Right now, long lines are expected to be tags.
            if not re.search(r"^\s*<\w+\s+", line):
                raise f"Long line doesn't start with tag:\n {line}"
            # Grab the prefix (the whitespace at the beginning and the tag
            # itself, and squirrel away the rest of the line. Then make a
            # prefix of spaces the same length as the whitespace plus the tag.
            m = re.search(r"^(\s*<\w+\s+)(.*)$", line)
            prefix = m.group(1)
            rest = m.group(2)
            sprefix = ' ' * len(prefix)
            # Find all the attribute names.
            elements = re.findall(r"""(?:["']\s+)?([a-z0-9-_]+=)""", rest)
            # Divvy up the string by splitting on the attribute names.
            # Drop the first one, because it's garbage.
            bits = re.split(r"""(?:["']\s+)?[a-z0-9-_]+=""", rest)
            bits = bits[1:]
            # Grab the quotes marks.
            quotes = [bit[0] for bit in bits]
            # Integrate all the fribbles.
            bits = [f"{e}{b}{q}" for e,b,q in zip(elements,bits,quotes)]
            # Handle first thing specially.
            bit = bits[0]
            insert = f"{prefix}{bit}\n"
            bits = bits[1:]
            # Now all the rest.
            for bit in bits:
                insert += f"{sprefix}{bit}\n"
            newcontents += insert
            # And better show the results.
            print(hbar)
            print(insert, end="")
            print(hbar)
    if rewrite:
        newcontents += "\n"
        with path.open("w") as f:
            print(f"Overwriting {path} with reformatted text ... ", end="")
            f.write(newcontents)
            print("done.")
