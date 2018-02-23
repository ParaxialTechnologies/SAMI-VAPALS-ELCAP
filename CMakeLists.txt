SET(mastimg "project-va-pals")
SET(mastcaption "va-pals")
SET(mastdesc "Project: VA-PALS")
SET(crumbtrail "VA-PALS – Projects – Staff – Vista Expertise Network")

adoc_to_html(
  index.adoc
  )

copy_binaries(
)

do_subdir(
  docs
#  elements
#  kids
  routines
  )
