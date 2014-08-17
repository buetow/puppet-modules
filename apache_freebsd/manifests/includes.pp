define apache_freebsd::includes (
  $includes_dir,
  $includes_properties,
  $document_root,
) {
  $include_properties = $includes_properties[$name]
  $ensure = $include_properties['ensure']

  file { "${includes_dir}/$name.conf":
    ensure  => $ensure,
    content => template("apache_freebsd/includes/${name}.conf.erb"),
  }
}
