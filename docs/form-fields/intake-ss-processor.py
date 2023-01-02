#!/usr/bin/env python3
#------------------------------------------------------------------------------
# This is a very quick and dirty script to take the intake import spreadsheet
# (which must be exported as a TSV file) and parse it out into an import format
# that VAPALS can take in. It really should be rewritten as a proper program at
# some point.
# ---Ken (mcglk@vistaexpertise.net 2022-01-03)
#
# Version 0.7.
#------------------------------------------------------------------------------

# import argparse
import csv
import itertools
import os
import pprint
import re
import sys

# We need a pretty printer for debugging. We'll remove it later.

pp = pprint.PrettyPrinter(indent=2, sort_dicts=False)

# Let's get the field data from the intake data dictionary. We're going to grab
# all the lines in the file first, screen out any whitespace-only lines, and
# then set up a CSV reader on it, and grab the fieldnames and the data
# separately.

datadict = {}

with open("intake.tsv", newline="") as datadictfile:
    rawlines = datadictfile.readlines()
rawlines = [line for line in rawlines if not line.isspace()]
reader = csv.reader(rawlines, delimiter="\t")
fields,*rawdata = reader
        
# Now that we have the fieldnames, lowercase them and remove any spaces.

fieldnames = [field.lower().replace(" ","") for field in fields]

# So there they are, in order. Now we're going to go through all the rest of
# the lines, zipping the fieldnames and the corresponding information for each
# field into a dictionary, and store it in datadict by the fieldname (after
# possibly splitting up the labels and values into lists).

for item in rawdata:
    itemdict = {
        fieldname: thing
          for fieldname,thing
          in itertools.zip_longest(fieldnames, item, fillvalue="")
    }
    name = itemdict["name"]
    del itemdict["name"]
    if ";" in itemdict["labels"]:
        itemdict["labels"] = itemdict["labels"].split(";")
        itemdict["values"] = itemdict["values"].split(";")
        itemdict["answers"] = {
            k: v
              for k,v
                in itertools.zip_longest(
                    itemdict["labels"], itemdict["values"], fillvalue=""
                )
        }
    datadict[name] = itemdict
datadict["sbdob"] = { "type": "text" }

# Now that that's out of the way, we're gonna go through each file on the
# command-line (in a very ugly quick-and-dirty way), and read all the lines,
# discarding blank ones, do any necessary data transformations, then rewrite
# data accordingly.

files = sys.argv[1:]

for fn in files:
    data = []
    with open(fn, newline="") as importfile:
        rawlines = importfile.readlines()
    rawlines = [line for line in rawlines if not line.isspace()]
    reader = csv.reader(rawlines, delimiter="\t")
    nope,fieldnames,nope,nope,nope,*rawdata = reader
    for item in rawdata:
        itemdict = {
            fieldname: thing
              for fieldname,thing
              in itertools.zip_longest(fieldnames, item, fillvalue="")
        }
        for k in itemdict:
            if k not in datadict:
                continue
            if k == "saminame":
                itemdict[k] = f"{itemdict[k]}-test01"
                continue
            if "answers" in datadict[k]:
                # That means we got a human-friendly answer we need to convert
                # to a value.
                sanswer = itemdict[k]
                ranswer = datadict[k]["answers"]
                if sanswer == "":
                    continue
                if sanswer in ranswer:
                    itemdict[k] = ranswer[sanswer]
                    continue
                sanswer = re.sub("\s+\(.*$", "", sanswer)
                if sanswer in ranswer:
                    itemdict[k] = ranswer[sanswer]
                    continue
                print(f"""
Could not find '{k}' -> '{sanswer}'
  for patient '{itemdict["saminame"]}'
(answers = {datadict[k]["answers"]})
                """.strip())
                continue
            if datadict[k]["type"] == "checkbox":
                if itemdict[k] != "":
                    itemdict[k] = datadict[k]["values"]
                continue
            m = re.search(r"^(\d{4})-(\d{2})-(\d{2})$", itemdict[k])
            if m:
                yr,mo,dy = m.groups()
                itemdict[k] = f"{mo}/{dy}/{yr}"
                continue
        data.append(itemdict)
    ofn = f"{os.path.splitext(fn)[0]}-import.tsv"
    with open(ofn, "w", newline="") as importfile:
        writer = csv.writer(
            importfile, delimiter="\t", quotechar='"',
            quoting=csv.QUOTE_MINIMAL
        )
        writer.writerow(fieldnames)
        for row in data:
            writer.writerow([row[k] for k in fieldnames])
    print(f"Wrote {ofn}.")
