import datetime
import sys
from bs4 import BeautifulSoup
from collections import OrderedDict
from jinja2 import Environment, FileSystemLoader

reload(sys)
sys.setdefaultencoding('utf-8')

env = Environment()
env.loader = FileSystemLoader('.')

# TODO: can we write a function to extract from *-dd-map.csv?

start = datetime.datetime.now()

# Version should be replaced by Mumps processor to use the actual version number (i.e. SAMI 18.0T04). The "SNAPSHOT"
# text refers to a non-KIDS distribution, such as when the code is built and deployed manually from source control.
version = datetime.datetime.now().strftime('SNAPSHOT %Y.%m.%d')

forms = {
    "background": "Background Form",
    "intake": "Intake Form",
    "ctevaluation": "CT Evaluation Form",
    "ctevaluation-elcap": "CT Evaluation Form",
    "home": "Home",
    "casereview": "Case Review",
    "newform": "New Form",
    "followup": "Followup Form",
    "biopsy": "Biopsy Form",
    "pet": "PET Evaluation Form",
    "intervention": "Intervention and Surgical Treatment Form",
    "editreport": "",
    "report": ""
}

for form, title in forms.items():
    with open("../www/" + form + ".html", "wb") as fh:
        html = env.get_template(form + ".html.jinja2").render(
            path="",
            version=version,
            title=title,
            formPage=form,
            formMethod="post")
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

    with open("../mockups/" + form + ".html", "wb") as fh:
        html = env.get_template(form + ".html.jinja2").render(
            path="../www/",
            mockup="true",
            version=version,
            title=title,
            formPage=form,
            formMethod="get")
        fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

elapsedMs = (datetime.datetime.now() - start).microseconds / 1000

print "Finished compiling HTML at " + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + " in " + str(
    elapsedMs) + "ms"
