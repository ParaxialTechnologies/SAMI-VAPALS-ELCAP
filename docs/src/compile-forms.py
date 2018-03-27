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

# background form
with open("../www/background.html", "wb") as fh:
    html = env.get_template('background.html.jinja2').render(
        title='Background Form',
        occupations=OrderedDict([
            ("-", "-"),
            ("1", "Higher executives"),
            ("2", "Business managers"),
            ("3", "Administrative Personnel"),
            ("4", "Clerical / Sales workers"),
            ("5", "Skilled manual Employees"),
            ("6", "Machine Operators"),
            ("7", "Unskilled Employees"),
            ("8", "Unemployed")
        ]))
    fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

with open("../www/intake.html", "wb") as fh:
    html = env.get_template('intake.html.jinja2').render(
        title='Intake Form'
    )
    fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

with open("../www/ctevaluation.html", "wb") as fh:
    html = env.get_template('ctevaluation.html.jinja2').render(
        title='CT Evaluation Form'
    )
    fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

with open("../www/home.html", "wb") as fh:
    html = env.get_template('home.html.jinja2').render(
        title="Home"
    )
    fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

with open("../www/casereview.html", "wb") as fh:
    html = env.get_template('casereview.html.jinja2').render(
        title="Case Review"
    )
    fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

with open("../www/newform.html", "wb") as fh:
    html = env.get_template('newform.html.jinja2').render(
        title="New Form"
    )
    fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

with open("../www/followup.html", "wb") as fh:
    html = env.get_template('followup.html.jinja2').render(
        title="Followup Form"
    )
    fh.write(BeautifulSoup(html, 'html5lib').prettify().encode('utf-8'))

elapsedMs = (datetime.datetime.now() - start).microseconds / 1000

print "Finished compiling HTML at " + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + " in " + str(
    elapsedMs) + "ms"
