class jail::debian_kfreebsd (
  $ensure = present,
) {
  # Utils for Debian GNU/kFreeBSD Jais
  package { 'debootstrap':
    ensure => $ensure,
  }
}

