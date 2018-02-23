adoc_to_html(
  *.adoc
  )

copy_binaries(
  sacc-2008.pdf
  *.png
  *.jpg
)

do_subdir(
  blogposts
  bmsf-proposal-2017
  elcap-forms
  slideshow
  va-pals-form-design-bible
  www
  )

