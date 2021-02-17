#!/usr/bin/env python3

#==============================================================================
# tsv-dd-to-html is a very, exceedingly quick and dirty Python script that
# takes our tab-separated data dictionary files and puts them into a readable
# HTML format with some row-spanning stuff.
#
# ---Ken McGlothlen <mcglk@vistaexpertise.net>, 2020-10-23, v0.2
#==============================================================================

import re
import ntpath

#------------------------------------------------------------------------------
# First, we're going to set up some string variables for the HTML output. We'll
# be using inline CSS for this to keep things simple. Some of these have {}
# parameters built in for the .format() method.
#------------------------------------------------------------------------------
style = """
<style><!--
body {
    font-family: "Verdana", "Helvetica", sans-serif;
    font-size: 9pt;
    line-height: 12pt;
}
table.dd {
    border-collapse: collapse;
    border: 1px solid grey;
    max-width: 100%;
}
table.dd th, table.dd td {
    text-align: left;
    border: 1px solid grey;
    white-space: nowrap;
    padding: 2pt 5pt;
    vertical-align: top;
}
table.dd tr.hl th, table.dd tr.hl td {
    background-color: #e8e8e8;
}
table.dd td.fnum, table.dd th.fnum { text-align: right; }
table.dd td.ques, table.dd td.lbls { white-space: normal; }
    --></style>
""".strip()
#------------------------------------------------------------------------------
preamble = """
<!DOCTYPE html>
<html>
  <head>
    <title>{title} data dictionary</title>
    {style}
  </head>
  <body>
    <table class="dd">
      <tr class="hl">
        <th class="ques">{quesfieldtitle}</th>
        <th class="fnum">#</th>
        <th class="name">{namefieldtitle}</th>
        <th class="type">{typefieldtitle}</th>
        <th class="requ">{requfieldtitle}</th>
        <th class="plac">{placfieldtitle}</th>
        <th class="vals">{valsfieldtitle}</th>
        <th class="lbls">{lblsfieldtitle}</th>
      </tr>
""".strip() + "\n"
#------------------------------------------------------------------------------
qfvrecordline = """
      <tr{highlight}>
        <td class="ques"{qrowspan}>{ques}</td>
        <td class="fnum"{rowspan}>{fnum}</td>
        <td class="name"{rowspan}>{name}</td>
        <td class="type"{rowspan}>{type}</td>
        <td class="requ"{rowspan}>{requ}</td>
        <td class="plac"{rowspan}>{plac}</td>
        <td class="vals">{vals}</td>
        <td class="lbls">{lbls}</td>
      </tr>
""".lstrip("\n").rstrip() + "\n"
#------------------------------------------------------------------------------
fvrecordline = """
      <tr{highlight}>
        <td class="fnum"{rowspan}>{fnum}</td>
        <td class="name"{rowspan}>{name}</td>
        <td class="type"{rowspan}>{type}</td>
        <td class="requ"{rowspan}>{requ}</td>
        <td class="plac"{rowspan}>{plac}</td>
        <td class="vals">{vals}</td>
        <td class="lbls">{lbls}</td>
      </tr>
""".lstrip("\n").rstrip() + "\n"
#------------------------------------------------------------------------------
vrecordline = """
      <tr{highlight}>
        <td class="vals">{vals}</td>
        <td class="lbls">{lbls}</td>
      </tr>
""".lstrip("\n").rstrip() + "\n"
#------------------------------------------------------------------------------
postamble = """
    </table>
  </body>
</html>
""".lstrip("\n").rstrip() + "\n"
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# loaddata() takes a list (previously a string split up on tabs from the data
# file) and creates a dictionary record for it. Unfortunately for us, not all
# the columns are populated, so we have poke our way through it rather than be
# efficient.
#------------------------------------------------------------------------------
def loaddata(inputdata):
    cols = len(inputdata)
    result = {
        "fnum": 0,
        "ques": "",
        "name": "",
        "type": "",
        "requ": "",
        "plac": "",
        "vals": [""],
        "lbls": [""]
        }
    if cols < 1: return result
    result["fnum"] = [int(inputdata[0]), 1]
    if cols < 2: return result
    result["ques"] = inputdata[1].strip('"')
    if cols < 3: return result
    result["name"] = inputdata[2].strip('"')
    if cols < 4: return result
    result["type"] = inputdata[3].strip('"')
    if cols < 5: return result
    result["requ"] = "" if inputdata[4].strip('"') == "0" else "Yes"
    if cols < 6: return result
    result["plac"] = inputdata[5].strip('"')
    if cols < 7: return result
    result["vals"] = re.split(r"\s*;\s*", inputdata[6].strip('"'))
    if cols < 8:
        length = len(result["vals"])
        result["fnum"][1] = length
        if length == 0:
            result["vals"] = [""]
            result["lbls"] = [""]
        elif length == 1:
            result["lbls"] = [""]
        else:
            raise Exception("Multiple values in '{0}', but no labels".format(
                inputdata
            ))
        return result
    result["lbls"] = re.split(r"\s*;\s*", inputdata[7].strip('"'))
    if len(result["vals"]) != len(result["lbls"]):
        raise Exception(
            "number of vals != number of lbls for field {0}!".format(
                result["fnum"]
            )
        )
    return result

#------------------------------------------------------------------------------
# compact_questions() tries to solve one of our row-spanning problems. Some
# questions apply to more than one data field. The data dictionary repeats the
# question for each applicable data field, but this makes for a pretty
# cluttered output.
#
# So first, we're going to figure out how many values belong to each field, and
# append that to the field number information as (fieldnum, count). Then we'll
# count up successive identical questions and replacing each question with a
# tuple of either (total count of rows, question), or (0, ""). We'll use those
# values later on.
#------------------------------------------------------------------------------
def compact_questions(filedata):
    for d in filedata:
        filedata[d]["fnum"] = [d, len(filedata[d]["vals"])]
    # Start off with a null question and silly values.
    oldquestion = ""
    count = 0
    src = -1
    # For every data record, if the question has changed, make sure the count
    # goes into the question we were counting and restart the count for the new
    # question. If the question didn't change, replace it with (0, "") because
    # the text will be redundant.
    for d in filedata:
        if filedata[d]["ques"] != oldquestion:
            if src >= 0:
                filedata[src]["ques"] = [oldquestion, count]
                print("old question '{0}' written ({1})".format(
                    oldquestion, count
                ))
            count = filedata[d]["fnum"][1]
            src = d
            oldquestion = filedata[d]["ques"]
        else:
            count += filedata[d]["fnum"][1]
            filedata[d]["ques"] = ["", 0]
    if src >= 0:
        filedata[src]["ques"] = [oldquestion, count]
        print("old question '{0}' written ({1})".format(
            oldquestion, count
        ))

def path_leaf(path):
    head, tail = ntpath.split(path)
    return tail or ntpath.basename(head)

#------------------------------------------------------------------------------
# 
#------------------------------------------------------------------------------
def process_tsv(fn):
    ofn = "../dds/" + path_leaf(fn).replace(".tsv", ".html")
    print("Opening {0}".format(ofn))
    filedata = {}
    with open(fn) as f:
        headers = [x.capitalize()
                       for x in re.split(r"\t", f.readline().strip())]
        for line in f:
            line = line.strip()
            data = loaddata(re.split(r"\t", line))
            # print(data)
            key = data["fnum"][0]
            del data["fnum"]
            filedata[key] = data
        else:
            f.close()
        compact_questions(filedata)
    with open(ofn, "w") as f:
        f.write(preamble.format(
            title=fn,
            style=style,
            quesfieldtitle=headers[1],
            namefieldtitle=headers[2],
            typefieldtitle=headers[3],
            requfieldtitle=headers[4],
            placfieldtitle=headers[5],
            valsfieldtitle=headers[6],
            lblsfieldtitle=headers[7]
        ))
        highlightclass = " class=\"hl\""
        highlight = highlightclass
        state = "newq"
        qrows = 0
        frows = 0
        qrowspan = ""
        frowspan = ""
        for d in sorted(filedata):
            print("{0}: {1}".format(d, filedata[d]))
            rques = filedata[d]["ques"]
            rfnum = filedata[d]["fnum"]
            rname = filedata[d]["name"]
            rtype = filedata[d]["type"]
            rrequ = filedata[d]["requ"]
            rplac = filedata[d]["plac"]
            rvals = filedata[d]["vals"]
            rlbls = filedata[d]["lbls"]
            if rfnum[1] > 0:
                print("frows reset from {0} to {1}".format(frows, rfnum[1]))
                frows = rfnum[1]
                if frows > 1:
                    frowspan = " rowspan=\"{0}\"".format(frows)
                else:
                    frowspan = ""
                state = "newf"
            if rques[1] > 0:
                print("qrows reset from {0} to {1}".format(qrows, rques[1]))
                qrows = rques[1]
                highlight = highlightclass if highlight == "" else ""
                if qrows > 1:
                    qrowspan = " rowspan=\"{0}\"".format(qrows)
                else:
                    qrowspan = ""
                state = "newq"
            if state == "newq":
                result = qfvrecordline.format(
                    highlight=highlight,
                    qrowspan=qrowspan,
                    rowspan=frowspan,
                    ques=rques[0],
                    fnum=rfnum[0],
                    name=rname,
                    type=rtype,
                    requ=rrequ,
                    plac=rplac,
                    vals=rvals[0],
                    lbls=rlbls[0]
                )
                f.write(result)
                print(result)
            elif state == "newf":
                result = fvrecordline.format(
                    highlight=highlight,
                    qrowspan=qrowspan,
                    rowspan=frowspan,
                    fnum=rfnum[0],
                    name=rname,
                    type=rtype,
                    requ=rrequ,
                    plac=rplac,
                    vals=rvals[0],
                    lbls=rlbls[0]
                )
                f.write(result)
                print(result)
            else:
                raise Exception("unknown state {0}".format(state))
            if frows > 1:
                for i in list(range(1,frows)):
                    rvals = filedata[d]["vals"][i]
                    rlbls = filedata[d]["lbls"][i]
                    result = vrecordline.format(
                        highlight=highlight,
                        vals=rvals,
                        lbls=rlbls
                    )
                    f.write(result)
                    print(result)
        f.write(postamble)
        f.close()

files = [
    "../form-fields/background.tsv",
    "../form-fields/biopsy.tsv",
    "../form-fields/ct-evaluation.tsv",
    "../form-fields/follow-up.tsv",
    "../form-fields/intake.tsv",
    "../form-fields/intervention.tsv",
    "../form-fields/pet-evaluation.tsv",
    "../form-fields/register.tsv"
]

for f in files:
    process_tsv(f)
