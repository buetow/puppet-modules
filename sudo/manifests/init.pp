class sudo {
  package { 'sudo':
    ensure => latest,
  }

  file { '/etc/sudoers.d/my-admin':
    ensure => present,
    source => 'puppet:///modules/sudo/sudoers.d/my-admin',
    mode   => '0440',
    owner  => root,
    group  => root,

    require => Package['sudo'],
  }
}

