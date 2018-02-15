#!/usr/bin/env bash

# This is a utility script used by a developer to continuously watch and compile the Jinja templates into HTML.


# Install the when-changed program if not available
command -v when-changed >/dev/null 2>&1 || { sudo pip install https://github.com/joh/when-changed/archive/master.zip; }

#automatically build files when changed.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Watching ${DIR}..."
when-changed -vrs "${DIR}/" "python ${DIR}/compile-forms.py"