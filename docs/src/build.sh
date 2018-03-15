#!/usr/bin/env bash

echo "Checking dependencies..."
#Check for Jinja2 installation
if [ -z `pip freeze|grep Jinja2` ]; then
    echo "Installing Jijna2..."
    pip install Jinja2
fi

if [ -z `pip freeze|grep beautifulsoup4` ]; then
    echo "Installing BeautifulSoup..."
    pip install beautifulsoup4
fi

if [ -z `pip freeze|grep html5lib` ]; then
    echo "Installing html5lib parser..."
    pip install html5lib
fi


#Check for Node.js installation (needed to install jsdoc)
command -v npm >/dev/null 2>&1 || {
    >&2 echo "ERROR: Go install Node.js. It's required for generating documentation using jsdoc";
    >&2 echo "ERROR: https://docs.npmjs.com/getting-started/installing-node";
    exit 1;
}

#Check for JSDOC Installation
command -v jsdoc >/dev/null 2>&1 || { npm install -g jsdoc; }


# Compile forms
echo "Compiling forms..."
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
python "${DIR}/compile-forms.py"

# Build Code documentation
DOCS="${DIR}/doc"
rm -rf "${DOCS}"
jsdoc ${DIR}/../www/*.js --readme ${DIR}/../src/README.md -d "${DOCS}"