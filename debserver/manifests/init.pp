class debserver (
  $debroot = '/var/www/deb',
){

  class { 'conf_user::deb':
  }

  class { 'debserver::packages':
    require => Class['conf_user::deb'],
  }

  class { 'debserver::files':
    debroot => $debroot,

    require => Class['conf_user::deb'],
  }
}
