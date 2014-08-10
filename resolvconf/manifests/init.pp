class resolvconf (
  $search,
  $nameservers = [],
) {
  file { '/etc/resolv.conf':
    ensure  => file,
    owner   => root,
    group   => $root_group,
    content => template('resolvconf/resolv.conf.erb'),
  }
}


