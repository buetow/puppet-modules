class sshserver (
  $ssh_port = '22',
  $ensure = present,
  $allow_users = 'admin',
  $permit_root_login = 'no',
  $password_authentication = 'no',
) {

  if $operatingsystem == 'Fedora' {
    notify { 'Fedora is not yet supported': 
    }
  } else {
    if $operatingsystem == 'FreeBSD' or $operatingsystem == 'CentOS' {
      $initname = 'sshd'
    } else {
      $initname = 'ssh'
    }

    class { 'sshserver::packages':
      ensure => $ensure
    }

    file { "${name}_sshd_config":
      ensure  => $ensure,
      content => template('sshserver/sshd_config.erb'),
      path    => '/etc/ssh/sshd_config',
      owner   => root,
      group   => $root_group,
      mode    => '0644',

      require => Class['sshserver::packages'],
    }

    service { "${name}_ssh":
      ensure    => running,
      name      => $initname,
      enable    => true,
      hasstatus => true,

      require   => [File["${name}_sshd_config"],Class['sshserver::packages']],
      subscribe => File["${name}_sshd_config"],
    }
  }
}
