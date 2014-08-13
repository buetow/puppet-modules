class znc_freebsd (
  $ensure = present,
  $config_dir = '/usr/local/etc/znc',
  $user = 'znc',
  $user_create = true,
  $znc_conf = 'puppet:///files/znc/znc.conf',
  $pem_manage = true,
  $znc_pem = 'puppet:///files/znc/znc.pem',
) {

  File {
    owner => $user,
    mode  => '0600',
  }

  package { 'znc':
    ensure => $ensure,
  }

  user { $user:
    noop   => !$user_create,
    ensure => present,
    home   => '/usr/home/znc',
  }

  file { $config_dir:
    ensure  => directory,
    recurse => true,
    force   => true,
    mode    => '0700',
  }

  freebsd::rc_enable { 'znc':
    ensure => $ensure,
  }

  if $ensure == present {
    file { "${config_dir}/configs":
      ensure => directory,
      mode   => '0700',

      require => File[$config_dir],
    }

    file { "${config_dir}/configs/znc.conf":
      ensure => present,
      mode   => '0600',
      source => $znc_conf,

      require => File["${config_dir}/configs"],
    }

    if $pem_manage {
      file { "${config_dir}/znc.pem":
        ensure => present,
        mode   => '0600',
        source => $znc_pem,

        require => File[$config_dir],
      }
    }
  }
}
