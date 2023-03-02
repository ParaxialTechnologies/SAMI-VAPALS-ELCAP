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
- Find the graph number by: http://vendev6.vistaplex.org:9080/gtree/%25wd(17.040801,%22B%22), find dcm-intake
- View entire graph http://vendev6.vistaplex.org:9080/gtree/%25wd(17.040801,576)
- This nasty little URL will delete all but the first entry in the dcm-intake graph... clearing out the graph for new
  demos http://vendev6.vistaplex.org:9080/dcmreset

## Mumps/Backend troubleshooting & support

### Reset a password

    mumps -dir
    SET DUZ=1
    D ^XUP
    EVE
    1 (Systems Manager)
    U (User manager)
    E (Edit an existing user)
    1
    MAN (To edit SYSTEM MANAGER account)
    cursor to Access code or Verify code, enter Y and enter
    Enter new one (this is temporary)
    Move cursor to COMMAND area, hit S for save
    E to exit
    Enter, Enter, Enter
    Y
    DO ^ZU
    Login with access code (e.g. SUPER6)
    Password (new password)
    Prompts you to change password.

### Update site with HTML and M code

    cd ~/lib/silver/a-sami...
    git pull
    cd routines
    bash ./compare.sh (see diff of git repo and actual)
    cp SAMI*.m ~/run/routines/
    run post install (get command from Linda)
    mumps -dir 
    SET DUZ=1
    DO CLRWEB^SAMIADMN

### Copy a graph file

You may want to make backups of graphs for restoring at a later time. Here's how:
    
    m ^webbak(667)=^%wd(17.040801,667)
    then to restore, just reverse it.
    m ^%wd(17.040801,667)=^webbak(667)

Kill the copy via:

    K ^webbak

### Turn on matching report

    d SETPARM^SAMIPARM("Non VA","matchingReportEnabled","true")

###Clear error trap:

    k ^%webhttp("log")

### Create a new SITE

Find an unused institution

    SET DUZ=1
    DO ^XUP
    enter "SAMI" (select main menu #4)
    SI for Site and User Menu
    SE (Site edit)
    Enter a ? or some characters to filter.
    Pick one that is closely starting with the same letters as the site being added. e.g. BRAINERD CBOC for Brazil
    
Activate the site

    DO Q^DI (fileman)
    E (for edit)
    enter "SAMI SITE"
    enter "Y" (add as new site)
    enter as site abbreviaion (e.g. BRA)
    enter <Y> for active
    enter <N> for "Non VA"
    skip the PARM <enter>
    
Create user

    D ^XUP
    EVE
    select #1 (Systems Manager Menu)
    Us (user managment)
    Gra (Grant user by profile)
    Template person can be "MAN" (System manager)
    <enter>
    Y for yes
    skip terminiation
    for name enter <BRAZIL,USER>
    Y for new person
    give a fake ssn
    enter Y to clone person class
    Hit up-arrow to exit from "enter new person"
    hit enter lots of times to get out.
    U for user management
    E for edit user
    enter BRA to select new user
    go to Division, type the site name (few chars)
    If it doesn't show after save, enter ? to see it.
    Change verify code too.
    Go to command and enter SAVE, then exit

Set user password to never expire
    
    VAPALS YottaDB> D Q^DI
    VA FileMan 22.2

    Select OPTION: ENTER OR EDIT FILE ENTRIES

    Input to what File: NEW PERSON//          (87 entries)
    EDIT WHICH FIELD: ALL// 7.2  VERIFY CODE never expires
    THEN EDIT FIELD:
     
    Select NEW PERSON NAME: `1  USER,ONE     DBA       
    VERIFY CODE never expires: ?
    Only persons with the proper key can set this field.
    Choose from:
    1        Yes
    VERIFY CODE never expires: 1  Yes
    
Change pwd

    DO ^ZU
    Login with access/verify and change password as directed

### Add/Modify a SYSTEM parameter
System parameters are loaded into the SYS namespace and used when no site is enabled (e.g. a logon screen)

    D SETPARM^SAMIPARM("SYS","logoIcon","syslogo.png")

### Add site params

Enter Fileman and create the new parameter

    S DUZ=1 
    VAPALS YottaDB>D Q^DI
    
    VA FileMan 22.2

    Select OPTION: ENTER OR EDIT FILE ENTRIES
    
    Input to what File: SAMI SITE             (13 entries)
    EDIT WHICH FIELD: ALL// PA
    1   PARAMETER DEFAULT  DEFAULT PARAMETERS
    2   PARMS    (multiple)
    CHOOSE 1-2: 2  PARMS  (multiple)
    EDIT WHICH PARMS SUB-FIELD: ALL//
    THEN EDIT FIELD:
    
    
    Select SAMI SITE: XXX  VISTA HEALTH CARE     XXX      6100  
    Select PARM: logoIcon
      Are you adding 'logoIcon' as a new PARMS (the 2ND for this SAMI SITE)? No// y
    es  (Yes)
    VALUE: xxx__logo_name_text.png
    Select PARM: siteLogo  
    PARM: siteLogo//
    VALUE: xxx__logo_name_text.png  Replace __ With _
    Replace
    xxx_logo_name_text.png
    Select PARM:

Hit enter several times to exit

Re-enter Fileman and update indexes

    VAPALS YottaDB>D Q^DI
    
    VA FileMan 22.2
    
    Select OPTION: UTILITY FUNCTIONS  
    Select UTILITY OPTION: RE-INDEX FILE
    
    Modify what File: SAMI SITE//             (13 entries)
    
    THERE ARE 4 INDICES WITHIN THIS FILE
    DO YOU WISH TO RE-CROSS-REFERENCE ONE PARTICULAR INDEX? No// YES  (Yes)
    
    What type of cross-reference (Traditional or New)? Traditional// NEW
    
              File: SAMI SITE (#311.12)
    Select Subfile: PARMS    (Subfile #311.121)
    
    Current Indexes on subfile #311.121:
    1510   'D' whole file index (resides on file #311.12)
    
    Which Index do you wish to re-cross-reference? 1510// 1510
    
    Do you want to delete the existing 'D' cross-reference? YES
    Do you want to re-build the 'D' cross reference? YES
      ...DONE!


##Resources
1. [OSEHRA Jira Project](https://issues.osehra.org/secure/RapidBoard.jspa?projectKey=VAP) - This project uses Jira to
   manage sprints and track defects. If you see something, say something!
2. [OSEHRA Project Page](https://www.osehra.org/groups/va-pals-open-source-project-group) - Keep track of our progress,
   read blog posts and subscribe to events.

George will provide a command to create a new parameter for SYS or a certain site. Also for default values? Needed for logo
