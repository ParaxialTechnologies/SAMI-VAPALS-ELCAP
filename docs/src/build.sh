#!/usr/bin/env bash

bases=(lungrads elcap)
sites=(default sinai)

python3 -m venv .venv
source .venv/bin/activate

#echo "Checking dependencies..."
#pips=`pip3 freeze`

#function pip_install {
#    printf "%20s: " "$1"
#    if [[ ${pips} == *"$1"* ]]; then
#        printf "OK\n";
#    else
#        printf "Not Installed\n"
#        echo "Installing $1..."
#        pip3 install $1 --ignore-installed six
#    fi
#}
#
#pip_install "Jinja2"
#pip_install "beautifulsoup4"
#pip_install "html5lib"

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
start=`date +%s`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for b in "${bases[@]}"
do
   for s in "${sites[@]}"
   do
      python3 "${DIR}/compile-forms.py" $b $s
   done
done

end=`date +%s`
runtime=$( echo "$end - $start" | bc -l )
echo "Finished compiling HTML at `date '+%Y-%m-%d %H:%M:%S'` in ${runtime} seconds"

# Javascript documentation
DOCS="${DIR}/doc"
rm -rf "${DOCS}"
jsdoc ${DIR}/../www/*.js --readme ${DIR}/../src/README.md -d "${DOCS}"

# Build Code documentation
#redirect stderr to stdout and stdout to /dev/null in order to get only stderr on your terminal.
python3 "${DIR}/tsv-dd-to-html.py" 2>&1 > /dev/null
