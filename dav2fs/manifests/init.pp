class dav2fs (
  $ensure = present,
  $names  = [],
  $configs = {},
  $secrets = {},
){

  if $ensure == present {
    package { 'davfs2':
      ensure => installed,
    }
  }

  file { '/etc/davfs2/secrets':
    ensure  => $ensure,
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    content => template('dav2fs/secrets.erb'),

    require => Package['davfs2'],
  }

  dav2fs::mount { $names:
    configs => $configs,
  }
}
