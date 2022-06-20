adoc_to_html(
  *.adoc
  )

copy_binaries(
  sami*[0-9].zip
  *.png
  intake-test-data-tab-del.txt
  intake.xlsx
  )

do_subdir(
  )
