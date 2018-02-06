import sys
from jinja2 import Environment, FileSystemLoader, Template
from collections import OrderedDict

reload(sys)
sys.setdefaultencoding('utf-8')

env = Environment()
env.loader = FileSystemLoader('.')

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
            ("8", "Unemployed") #TODO: can we write a function to extract from background-dd-map.csv?
        ])
    ))
