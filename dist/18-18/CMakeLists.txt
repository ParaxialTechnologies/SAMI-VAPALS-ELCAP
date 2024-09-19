adoc_to_html(
  *.adoc
  )

copy_binaries(
  sami*[0-9].zip
  )

do_subdir(
  t[0-9]
  b[0-9]
  b[0-9][0-9]
  )
