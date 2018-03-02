import datetime
import sys
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
    fh.write(env.get_template('background.html.jinja2').render(
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
        ])
    ))

# Intake form
with open("../www/intake.html", "wb") as fh:
    fh.write(env.get_template('intake.html.jinja2').render(
        title='Intake Form'
    ))

with open("../www/ctevaluation.html", "wb") as fh:
    fh.write(env.get_template('ctevaluation.html.jinja2').render(
        title='CT Evaluation Form'
    ))

with open("../www/home.html", "wb") as fh:
    fh.write(env.get_template('home.html.jinja2').render(
        title="Home"
    ))

with open("../www/casereview.html", "wb") as fh:
    fh.write(env.get_template('casereview.html.jinja2').render(
        title="Case Review"
    ))

with open("../www/newform.html", "wb") as fh:
    fh.write(env.get_template('newform.html.jinja2').render(
        title="New Form"
    ))

elapsedMs = (datetime.datetime.now() - start).microseconds / 1000

print "Finished compiling HTML at " + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + " in " + str(
    elapsedMs) + "ms"
