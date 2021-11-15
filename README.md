# VAPALS-ELCAP Management System

---------------------------------------------------

This is the main repository that supports the
the [VA-Partnership to increase Access to Lung Screening project](http://va-pals.org/). The original management system
was created and donated by Early Diagnosis and Treatment Research Foundation within the International Early Lung Cancer
Action Program (I-ELCAP), an international program of lung cancer screening.


## Repository Structure


* /docs - various documentation that helped the team build this project. Includes [data dictionaries](/docs/form-fields)
  , some presentations and even [blog posts](/docs/blogposts).
* /docs/src - source files used to generate the front-end web site. Use the *.sh scripts to build the website using
  the *.jinja2 template files. The /doc direcotry contains generated documentation from those source files.
* /docs/www - compliled resources from the sibling `src` directory. Also includes javascript, libraries, and other
  supporting files. Run any html file in /www/test to execute front-end unit tests.
* [/java/tests](java/tests/README.md) - includes integration tests that run against a designated server. Evaluates
  correct, expected behavior from both the front-end (Web pages) and back-end (VistA FileMan) aspects of this project.
* /kids - TODO
* /routines - All the Mumps routines necessary to run this application.

## Docker Images

Instructions for installing a docker instance of the VAPALS-ELCAP software is
available [here](https://hub.docker.com/r/osehra/va-pals/)

## Structured Report

- To retrieve an SR:http://vendev6.vistaplex.org:9080/dcmquery?studyid=XXX0023
- To send an SR POST to http://vendev6.vistaplex.org:9080/dcmin?siteid=XXX&returngraph=1
- View entire graph http://vendev6.vistaplex.org:9080/gtree/%25wd(17.040801,576)
- This nasty little URL will delete all but the first entry in the dcm-intake graph... clearing out the graph for new
  demos http://vendev6.vistaplex.org:9080/dcmreset

##Resources
1. [OSEHRA Jira Project](https://issues.osehra.org/secure/RapidBoard.jspa?projectKey=VAP) - This project uses Jira to
   manage sprints and track defects. If you see something, say something!
2. [OSEHRA Project Page](https://www.osehra.org/groups/va-pals-open-source-project-group) - Keep track of our progress,
   read blog posts and subscribe to events.
