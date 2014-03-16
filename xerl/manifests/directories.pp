class xerl::directories (
  $user = 'xerl',
  $hostsroot = '/home/xerl/hosts',
  $cacheroot = '/home/xerl/cache',
  $githostsurl = 'git://git.buetow.org/xerl',
  $githostsbranch = 'hosts'
) {

  class { 'xerl::hosts':
    user           => $user,
    hostsroot      => $hostsroot,
    githostsurl    => $githostsurl,
    githostsbranch => $githostsbranch,
  }

  file { $cacheroot:
    ensure  => directory,
    recurse => false,
    purge   => false,
    owner   => $user,
    group   => $user,
  }
}

