adoc_to_html(
  *.adoc
  )

copy_binaries(
  *.html
  sami*[0-9].zip
)

do_subdir(
  t[0-9]
  )
