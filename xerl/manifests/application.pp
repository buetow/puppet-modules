class xerl::application (
  $user = 'xerl',
  $xerlroot = '/home/xerl/public_html/xerl',
  $hostroot = '/home/xerl/hosts/',
  $statsroot = '/home/xerl/stats/',
  $cacheroot = '/home/xerl/cache/',
  $giturl = 'git://git.buetow.org/xerl'
) {

  exec { "/bin/su - ${user} /bin/sh -c 'git clone ${giturl} ${xerlroot}'":
    unless => "/usr/bin/test -d ${xerlroot}",

    alias => 'checkout_xerl',
  }

  file { "${xerlroot}/xerl-${::fqdn}.conf":
    ensure  => present,
    content => template('xerl/xerl.conf.erb'),
    owner   => $user,
    group   => $user,
    mode    => '0400',

    require => Exec['checkout_xerl']
  }
}

