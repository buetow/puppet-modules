define poudriere::pkglist (
  $ensure = present,
  $pkglist = [],
  $dest_dir = '/usr/local/etc/poudriere.d/myconf',
) {
  file { "${dest_dir}/${name}-pkglist":
    ensure  => $ensure,
    content => template("poudriere/pkglist.erb"),
  }
}
