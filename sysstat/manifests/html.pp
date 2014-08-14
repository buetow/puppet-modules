class sysstat::html (
  $html_dir,
  $ensure,
  $user_name = 'sysstathtml',
) {

  if $ensure == present {
    s_user::create { 'sysstathtml_create':
      user_name => $user_name,
      shell     => '/bin/bash',
    }

    file { $html_dir:
      ensure => directory,
      mode   => '0755',
      owner  => $user_name,
    }

  } else {
    file { $html_dir:
      ensure => absent,
    }

    user { $user_name:
      ensure => purged,
    }
  }
}

