#!/usr/bin/env bash

# This is a utility script used by a developer to continuously watch and compile the Jinja templates into HTML.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# Initial setup and build
${DIR}/build.sh

# Install the when-changed program if not available
command -v when-changed >/dev/null 2>&1 || { sudo pip install https://github.com/joh/when-changed/archive/master.zip; }

#automatically build files when changed.


echo "Watching ${DIR}..."
when-changed -vrs "${DIR}/" "${DIR}/build.sh"