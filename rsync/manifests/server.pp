class rsync::server {
  $rsyncd_user = 'root'
  $rsyncd_group = 'root'
  $use_chroot = 'no'

  include rsync::client

  file { '/etc/default/rsync':
    ensure => present,
    source => 'puppet:///modules/rsync/etc.defaults.rsync',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',

    require => Class['rsync::client'],
    notify  => Service['rsync'],
  }

  file { '/usr/local/bin/create_rsync_parent_directories.sh':
    ensure => present,
    source => 'puppet:///modules/rsync/create_rsync_parent_directories.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',

    require => Class['rsync::client'],
  }

  file { '/etc/rsyncd.d/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',

    notify => [
      Exec['Compile rsyncd.conf'],
    ],
  }

  file { '/etc/rsyncd.d/000-rsyncd.conf':
    ensure  => present,
    content => template('rsync/etc.rsyncd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',

    require => [
      Class['rsync::client'],
      File['/etc/rsyncd.d'],
      File['/usr/local/bin/create_rsync_parent_directories.sh'],
    ],
    notify => [
      Exec['Compile rsyncd.conf'],
    ],
  }

  exec { 'Compile rsyncd.conf':
    command => '/bin/cat /etc/rsyncd.d/000-rsyncd.conf /etc/rsyncd.d/*.fragment 2>/dev/null > /etc/rsyncd.conf',
  }

  service { 'rsync':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
