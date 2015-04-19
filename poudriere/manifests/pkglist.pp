define poudriere::pkglist (
  $ensure = present,
  $mybulk_helper_manage = true,
  $pkglist = [],
  $dest_dir = '/usr/local/etc/poudriere.d/myconf',
) {
  file { "${dest_dir}/${name}-pkglist":
    ensure  => $ensure,
    content => template("poudriere/pkglist.erb"),
  }
  if $mybulk_helper_manage {
    file { "${dest_dir}/${name}-bulk.sh":
      ensure  => $ensure,
      source  => "puppet:///modules/poudriere/myconf/${name}-bulk.sh",
    }
  }
}
