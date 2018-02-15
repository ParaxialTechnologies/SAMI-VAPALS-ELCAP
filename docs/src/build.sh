#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pip install Jinja2

python ./build.py#Check for Node.js installation
command -v npm >/dev/null 2>&1 || {
    >&2 echo "ERROR: Go install Node.js. It's required for generating documentation using jsdoc";
    >&2 echo "ERROR: https://docs.npmjs.com/getting-started/installing-node";
    exit 1;
}

#Install JSDOC if necessary
command -v jsdoc >/dev/null 2>&1 || { npm install -g jsdoc; }

# Build Code documentation
DOCS="${DIR}/doc"
rm -rf "${DOCS}"
jsdoc ${DIR}/../www/*.js --readme ${DIR}/../src/README.md -d "${DOCS}"