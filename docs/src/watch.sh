#!/usr/bin/env bash

# Install the when-changed program if not available
command -v when-changed >/dev/null 2>&1 || { sudo pip install https://github.com/joh/when-changed/archive/master.zip; }

#automatically build files when changed.
echo "Watching `pwd`..."
when-changed -vrs . 'python ./build.py'