class debserver (
  $debroot = '/var/www/deb',
){

  class { 's_user::deb':
  }

  class { 'debserver::packages':
    require => Class['s_user::deb'],
  }

  class { 'debserver::files':
    debroot => $debroot,

    require => Class['s_user::deb'],
  }
}
