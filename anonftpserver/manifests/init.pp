class anonftpserver (
  $ensure = present
){

  case $ensure {
    present: {
      $ensure_directory = directory
      $ensure_service = running
    }
    absent: {
      $ensure_directory = absent
      $ensure_service = stopped
    }
    default: {
      $ensure_directory = directory
      $ensure_service = running
    }
  }

  package { 'proftpd-basic':
    ensure => $ensure,
  }

  file { "${name}_proftpd.conf":
    ensure => $ensure,
    source => 'puppet:///modules/anonftpserver/proftpd.conf',
    path   => '/etc/proftpd/proftpd.conf',
    owner  => root,
    group  => root,
    mode   => '0644',

    require => Package['proftpd-basic'],
  }

  file { '/home/ftp':
    ensure => $ensure_directory,
    force  => true,
    owner  => ftp,
    group  => nogroup,
    mode   => '0755',
  }

  file { '/home/ftp/welcome.msg':
    ensure => absent,

    require => Package['proftpd-basic'],
  }

  service { "${name}_proftpd":
    ensure    => $ensure_service,
    name      => 'proftpd',
    enable    => true,
    hasstatus => true,

    require   => [File["${name}_proftpd.conf"],Package['proftpd-basic']],
    subscribe => File["${name}_proftpd.conf"],
  }
}
