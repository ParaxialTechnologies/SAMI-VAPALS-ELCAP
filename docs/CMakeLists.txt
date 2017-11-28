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
  ch-aj-talk-2017-07-18
  elcap-forms
  login-page-mini-presentation
  sec-1-sc-training-2013-updated
  va-pals-form-design-bible
  www
  )

