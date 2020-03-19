import datetime
import sys
from bs4 import BeautifulSoup
from jinja2 import Environment, FileSystemLoader

reload(sys)
sys.setdefaultencoding('utf-8')

env = Environment()
env.loader = FileSystemLoader('.')

# TODO: can we write a function to extract from *-dd-map.csv?

start = datetime.datetime.now()

# Version should be replaced by Mumps processor to use the actual version number (i.e. SAMI 18.0T04). The "SNAPSHOT"
# text refers to a non-KIDS distribution, such as when the code is built and deployed manually from source control.
version = datetime.datetime.now().strftime('%Y.%m.%d')
#version = datetime.datetime.now().strftime('%Y.%m.%d %H:%M:%S')

# map where key is the template file name and value is an object representing properties of the output
forms = [
    {"template": "background", "title": "Background Form", "output": "background"},
    {"template": "intake", "title": "Lung Screening and Surveillance Intake Form", "output": "intake"},
    {"template": "ctevaluation", "title": "CT Evaluation Form", "output": "ctevaluation"},
    {"template": "ctevaluation", "title": "CT Evaluation Form", "output": "ctevaluation-elcap"},
    {"template": "home", "title": "Home", "output": "home"},
    {"template": "casereview", "title": "Case Review", "output": "casereview"},
    {"template": "newform", "title": "New Form", "output": "newform"},
    {"template": "followup", "title": "Followup Form", "output": "followup"},
    {"template": "biopsy", "title": "Biopsy Form", "output": "biopsy"},
    {"template": "pet", "title": "PET Evaluation Form", "output": "pet"},
    {"template": "intervention", "title": "Intervention and Surgical Treatment Form", "output": "intervention"},
    {"template": "report", "title": "", "output": "report"},
    {"template": "toggler", "title": "", "output": "toggler"},
    {"template": "table", "title": "", "output": "table"},
    {"template": "upload", "title": "Upload New Patients", "output": "upload"},
    {"template": "register", "title": "Register", "output": "register"},
    {"template": "editparticipant", "title": "Edit Participant", "output": "editparticipant"},
    {"template": "error", "title": "System Error", "output": "error"}
]


# report template with data table in it with 2 columns for Name SSN. Name be a link to case review page.
# samroute:report
# 1. followup
# 2. activity
# 3. missingct
# 4. incomplete
# 5. outreach
# 6. enrollment

for form in forms:
    with open("../www/" + form['output'] + ".html", "wb") as fh:
        html = env.get_template(form['template'] + ".html.jinja2").render(
            path="",
            version=version,
            title=form['title'],
            formPage=form['output'],
            formMethod="post")
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

    with open("../mockups/" + form['output'] + ".html", "wb") as fh:
        html = env.get_template(form['template'] + ".html.jinja2").render(
            path="../www/",
            mockup="true",
            version=version,
            title=form['title'],
            formPage=form['output'],
            formMethod="get")
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

elapsedMs = (datetime.datetime.now() - start).microseconds / 1000

print "Finished compiling HTML at " + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + " in " + str(
    elapsedMs) + "ms"
