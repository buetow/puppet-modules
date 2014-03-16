class xerl::cron (
  $ensure = present,
  $cacheroot = '/home/xerl/cache',
  $hostsroot = '/home/xerl/hosts',
  $user= 'xerl'
) {

  opt::local_cronjob { 'xerl_chown_logs':
    ensure  => $ensure,
    minute  => '0',
    atboot  => true,
    user    => 'root',
    command => '/bin/chown xerl /opt/local/var/log/cron.xerl::cron*',
  }

  opt::local_cronjob { 'xerl_hosts_pull':
    ensure  => $ensure,
    minute  => '23',
    atboot  => false,
    user    => $user,
    command => "/usr/bin/test -d ${hostsroot} && cd ${hostsroot} && /opt/bin/git/git.silent pull"
  }

  opt::local_cronjob { 'xerl_clean_cache':
    ensure  => $ensure,
    minute  => '24',
    atboot  => false,
    user    => $user,
    command => "/usr/bin/test -d ${cacheroot} && /bin/rm -Rf ${cacheroot}/*"
  }
}
