import datetime
import os
import sys
from bs4 import BeautifulSoup
from jinja2 import Environment, FileSystemLoader

env = Environment()
env.loader = FileSystemLoader('.')

# TODO: can we write a function to extract from *-dd-map.csv?

# Version should be replaced by Mumps processor to use the actual version number (i.e. SAMI 18.0T04). The "SNAPSHOT"
# text refers to a non-KIDS distribution, such as when the code is built and deployed manually from source control.
version = datetime.datetime.now().strftime('%Y.%m.%d')
# version = datetime.datetime.now().strftime('%Y.%m.%d %H:%M:%S')

# map where key is the template file name and value is an object representing properties of the output
forms = [
    {"template": "about", "title": "About", "formPage": "about", "withNav": "false"},
    {"template": "background", "title": "Background Form", "formPage": "background", "withNav": "true"},
    {"template": "blank", "title": "", "formPage": "blank_no_nav", "withNav": "false"},
    {"template": "intake", "title": "Lung Screening Intake Form", "formPage": "intake", "withNav": "true"},
    {"template": "ctevaluation", "title": "CT Evaluation Form", "formPage": "ctevaluation", "withNav": "true"},
    {"template": "home", "title": "Home", "formPage": "home", "withNav": "true"},
    {"template": "casereview", "title": "Case Review", "formPage": "casereview", "withNav": "true"},
    {"template": "newform", "title": "New Form", "formPage": "newform", "withNav": "true"},
    {"template": "followup", "title": "Followup Form", "formPage": "followup", "withNav": "true"},
    {"template": "biopsy", "title": "Biopsy Form", "formPage": "biopsy", "withNav": "true"},
    {"template": "pet", "title": "PET Evaluation Form", "formPage": "pet", "withNav": "true"},
    {"template": "intervention", "title": "Intervention and Surgical Treatment Form", "formPage": "intervention",
     "withNav": "true"},
    {"template": "report", "title": "", "formPage": "report", "withNav": "true"},
    {"template": "table", "title": "", "formPage": "table", "withNav": "true"},
    {"template": "upload", "title": "Upload New Patients", "formPage": "upload", "withNav": "true"},
    {"template": "register", "title": "Register", "formPage": "register", "withNav": "true"},
    {"template": "editparticipant", "title": "Edit Participant", "formPage": "editparticipant", "withNav": "true"},
    {"template": "error", "title": "System Error", "formPage": "error", "withNav": "true"},
    {"template": "login", "title": "Login", "formPage": "login", "withNav": "false"},
    {"template": "login-demo", "title": "DEMO Login", "formPage": "login-demo", "withNav": "false"}
]

base = sys.argv[1]
site = sys.argv[2]
print("Building HTML. base='" + base + "', site='" + site + "'")
for form in forms:
    path = ("/" + base + "/" + site)
    wwwPath = "../www" + path
    os.makedirs(wwwPath, exist_ok=True)
    with open(wwwPath + "/" + form['formPage'] + ".html", "wb") as fh:
        html = env.get_template(form['template'] + ".html.jinja2").render(
            path="",
            version=version,
            title=form['title'],
            formPage=form['formPage'],
            formMethod="post",
            withNav=form['withNav'],
            base=base,
            site=site)
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

    mockupsPath = "../mockups" + path
    os.makedirs(mockupsPath, exist_ok=True)
    with open(mockupsPath + "/" + form['formPage'] + ".html", "wb") as fh:
        html = env.get_template(form['template'] + ".html.jinja2").render(
            path="../../../www/",
            mockup="true",
            version=version,
            title=form['title'],
            formPage=form['formPage'],
            formMethod="get",
            withNav=form['withNav'],
            base=base,
            site=site)
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))