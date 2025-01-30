adoc_to_html(
  *.adoc
  )

copy_binaries(
  *.html
)

do_subdir(
  18-[0-9][0-9]
  18-[89]
  18-17-pho-1
  docs
  )
