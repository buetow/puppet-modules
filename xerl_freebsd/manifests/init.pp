class xerl_freebsd (
  $ensure = present,
  $giturl = 'git://git.buetow.org/xerl',
  $apache_document_root,
) {
  $user = 'www'
  $apache_config_dir = '/usr/local/etc/apache'
  $cache_root = '/var/cache/xerl'
  $hosts_root = '/var/xerl'
  $xerl_root = "${apache_document_root}/xerl"

  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  file { [$cache_root, $hosts_root, $xerl_root]:
    ensure => $ensure_directory,
    purge  => true,
    owner  => $user,
    group  => $user,
  }

  if $ensure == present {
    class { 'xerl_freebsd::checkout':
      user       => $user,
      xerl_root  => $xerl_root,
      hosts_root => $hosts_root,
      giturl     => $giturl,

      require => File[$cache_root],
    }

    file { "${xerl_root}/master/xerl-${::fqdn}.conf":
      ensure  => file,
      content => template('xerl_freebsd/xerl.conf.erb'),
      owner   => $user,
      group   => $user,
      mode    => '0400',

      require => Class['xerl_freebsd::checkout']
    }

    package { [
      'p5-XML-SAX',
      'p5-IO-All-LWP',
    ]:
      ensure => present
    }
  }

  cron { 'xerl_hosts_pull':
    ensure  => $ensure,
    hour    => '*',
    minute  => '23',
    user    => $user,
    command => "/bin/test -d ${hosts_root}/hosts && cd ${hosts_root}/hosts && /usr/local/bin/git pull >/dev/null 2>/dev/null",
  }

  cron { 'xerl_master_pull':
    ensure  => $ensure,
    hour    => '*',
    minute  => '24',
    user    => $user,
    command => "/bin/test -d ${xerl_root}/master && cd ${xerl_root}/master && /usr/local/bin/git pull >/dev/null 2>/dev/null",
  }

  cron { 'xerl_clean_cache':
    ensure  => $ensure,
    hour    => '*',
    minute  => '25',
    user    => $user,
    command => "/bin/test -d ${cache_root} && /bin/rm -Rf ${cache_root}/* >/dev/null 2>/dev/null",
  }
}

