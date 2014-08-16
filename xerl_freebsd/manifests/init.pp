class xerl_freebsd (
  $ensure = present,
  $user = 'www',
  $document_root = '/usr/local/www/apache24/data',
  $giturl = 'git://git.buetow.org/xerl',
) {
  $xerl_root = "${document_root}/xerl"
  $cache_root = '/var/cache/xerl'
  $hosts_base = '/var/run/xerl'
  $hosts_root = "${hosts_base}/hosts"

  case $ensure {
    present: { 
      $ensure_directory = directory
      file { $document_root:
        ensure  => directory,
        owner   => $user,
        group   => $user,
      }
    }
    absent: { 
      $ensure_directory = absent
      file { $xerl_root:
        ensure  => absent,
        purge   => true,
      }
    }
  }

  file { [$cache_root, $hosts_base]:
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

    file { "${xerl_root}/xerl-${::fqdn}.conf":
      ensure  => file,
      content => template('xerl_freebsd/xerl.conf.erb'),
      owner   => $user,
      group   => $user,
      mode    => '0400',

      require => Class['xerl_freebsd::checkout']
    }
  }

  cron { 'xerl_hosts_pull':
    ensure  => $ensure,
    hour    => '*',
    minute  => '23',
    user    => $user,
    command => "/bin/test -d ${xerl_hosts} && cd ${xerl_hosts} && /usr/local/bin/git pull >/tmp/pull.out 2>/tmp/pull.err"
  }

  cron { 'xerl_clean_cache':
    ensure  => $ensure,
    hour    => '*',
    minute  => '24',
    user    => $user,
    command => "/bin/test -d ${cache_root} && /bin/rm -Rf ${cache_root}/* >/dev/null 2>/dev/null",
  }
}

