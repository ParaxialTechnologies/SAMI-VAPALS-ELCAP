import datetime

from bs4 import BeautifulSoup
from jinja2 import Environment, FileSystemLoader

env = Environment()
env.loader = FileSystemLoader('.')

# TODO: can we write a function to extract from *-dd-map.csv?

start = datetime.datetime.now()

# Version should be replaced by Mumps processor to use the actual version number (i.e. SAMI 18.0T04). The "SNAPSHOT"
# text refers to a non-KIDS distribution, such as when the code is built and deployed manually from source control.
version = datetime.datetime.now().strftime('%Y.%m.%d')
# version = datetime.datetime.now().strftime('%Y.%m.%d %H:%M:%S')

# map where key is the template file name and value is an object representing properties of the output
forms = [
    {"template": "background", "title": "Background Form", "output": "background", "withNav": "true"},
    {"template": "blank", "title": "", "output": "blank_no_nav", "withNav": "false"},
    {"template": "intake", "title": "Lung Screening Intake Form", "output": "intake", "withNav": "true"},
    {"template": "ctevaluation", "title": "CT Evaluation Form", "output": "ctevaluation", "withNav": "true"},
    {"template": "ctevaluation", "title": "CT Evaluation Form", "output": "ctevaluation-elcap", "withNav": "true"},
    {"template": "home", "title": "Home", "output": "home", "withNav": "true"},
    {"template": "casereview", "title": "Case Review", "output": "casereview", "withNav": "true"},
    {"template": "newform", "title": "New Form", "output": "newform", "withNav": "true"},
    {"template": "followup", "title": "Followup Form", "output": "followup", "withNav": "true"},
    {"template": "biopsy", "title": "Biopsy Form", "output": "biopsy", "withNav": "true"},
    {"template": "pet", "title": "PET Evaluation Form", "output": "pet", "withNav": "true"},
    {"template": "intervention", "title": "Intervention and Surgical Treatment Form", "output": "intervention",
     "withNav": "true"},
    {"template": "report", "title": "", "output": "report", "withNav": "true"},
    {"template": "table", "title": "", "output": "table", "withNav": "true"},
    {"template": "upload", "title": "Upload New Patients", "output": "upload", "withNav": "true"},
    {"template": "register", "title": "Register", "output": "register", "withNav": "true"},
    {"template": "editparticipant", "title": "Edit Participant", "output": "editparticipant", "withNav": "true"},
    {"template": "error", "title": "System Error", "output": "error", "withNav": "true"},
    {"template": "login", "title": "Login", "output": "login", "withNav": "false"},
    {"template": "login-demo", "title": "DEMO Login", "output": "login-demo", "withNav": "false"}
]

for form in forms:
    with open("../www/" + form['output'] + ".html", "wb") as fh:
        html = env.get_template(form['template'] + ".html.jinja2").render(
            path="",
            version=version,
            title=form['title'],
            formPage=form['output'],
            formMethod="post",
            withNav=form['withNav'])
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

    with open("../mockups/" + form['output'] + ".html", "wb") as fh:
        html = env.get_template(form['template'] + ".html.jinja2").render(
            path="../www/",
            mockup="true",
            version=version,
            title=form['title'],
            formPage=form['output'],
            formMethod="get",
            withNav=form['withNav'])
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

elapsedMs = (datetime.datetime.now() - start).microseconds / 1000

print
"Finished compiling HTML at " + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + " in " + str(
    elapsedMs) + "ms"
