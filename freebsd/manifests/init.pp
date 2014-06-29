class freebsd (
){
  Package {
    provider => pkgng
  }

  file { '/etc/rc.conf.d':
    ensure => directory,
    owner  => root,
    group  => wheel,
  }
}
