#!/usr/bin/env bash

#Check for Jinja2 installation
if [ -z `pip freeze|grep Jinja2` ]; then
    echo "Installing Jijna2..."
    pip install Jinja2
fi

#Check for Node.js installation
command -v npm >/dev/null 2>&1 || {
    >&2 echo "ERROR: Go install Node.js. It's required for generating documentation using jsdoc";
    >&2 echo "ERROR: https://docs.npmjs.com/getting-started/installing-node";
    exit 1;
}

#Check for HTMLTidy installation
command -v tidy >/dev/null 2>&1 || {
    >&2 echo "ERROR: Please install HTMLTidy version 5.6 or greater.";
    >&2 echo "ERROR: http://binaries.html-tidy.org/";
    exit 1;
}

#Verify version of HTMLTidy (for HTML5)
TIDY_VER=`tidy --version`
if [[ $TIDY_VER != *" 5.6."* ]]; then
   >&2 echo "ERROR: HTMLTidy detected, but is not 5.6.*: ${TIDY_VER}"
   exit 1;
fi

#Check for JSDOC Installation
command -v jsdoc >/dev/null 2>&1 || { npm install -g jsdoc; }


# Compile forms
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
python "${DIR}/compile-forms.py"

# Pass each HTML file through HTMLTidy
for i in ${DIR}/../www/*.html; do
    if [[ $i = *"-form"* ]]; then
        echo "Ignoring non-enhanced file ${i}"
    else
        echo "*** TIDYING ${i} ***"
        tidy -config "${DIR}/htmltidy.conf" "${i}"
    fi
done

# Build Code documentation
DOCS="${DIR}/doc"
rm -rf "${DOCS}"
jsdoc ${DIR}/../www/*.js --readme ${DIR}/../src/README.md -d "${DOCS}"