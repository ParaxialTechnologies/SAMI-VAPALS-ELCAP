adoc_to_html(
  *.adoc
  )

copy_binaries(
  *.html
)

do_subdir(
  18-[0-9][0-9]
  18-[89]
  docs
  )
