class iodine (
  $isserver = false
) {

  File { owner => root, group => root }

  package { 'iodine':
    ensure => present
  }

  if $isserver {
    file { '/etc/default/iodine':
      ensure => present,
      owner  => root,
      mode   => '0400',
      source => 'puppet:///modules/iodine/server/default/iodine',
    }

    service { 'iodined':
      ensure => running,
      enable => true,

      require => File['/etc/default/iodine'],
    }
  } else {
    file { '/opt/local/bin/iodine':
      ensure => directory,
      mode   => '0755',
    }

    file { '/opt/local/bin/iodine/iodine.start':
      ensure => present,
      mode   => '0555',
      source => 'puppet:///modules/iodine/client/iodine.start',

      require => File['/opt/local/bin/iodine'],
    }
  }
}

