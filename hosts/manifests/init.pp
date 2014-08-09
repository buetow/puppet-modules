class hosts (
  $entries = {
    '::1' => 'localhost localhost.my.domain',
    '127.0.0.1' => 'localhost localhost.my.domain',
  },
) {
  file { '/etc/hosts':
    ensure  => file,
    owner   => root,
    group   => $root_group,
    content => template('hosts/hosts.erb'),
  }
}


