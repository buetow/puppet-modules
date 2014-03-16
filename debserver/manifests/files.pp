class debserver::files (
  $debroot
) {

  File { owner => deb, group => deb, mode => 0644 }

  $aptroot = "${debroot}/apt"

  file { $debroot:
    ensure => directory,
    mode   => '0775',
  }

  file { $aptroot:
    ensure => directory,
    mode   => '0775',

    require => File[$debroot],
  }

  file { "${aptroot}/conf/":
    ensure => directory,
    mode   => '0775',

    require => File[$aptroot],
  }

  file { "${aptroot}/conf/distributions":
    ensure => present,
    source => 'puppet:///modules/debserver/distributions',

    require => File["${aptroot}/conf/"],
  }

  file { "${aptroot}/pubkey.gpg":
    ensure => present,
    source => 'puppet:///modules/conf_user/deb/pubkey.gpg',

    require => File[$aptroot],
  }
}

