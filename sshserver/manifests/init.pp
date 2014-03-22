class sshserver (
  $ssh_port = '2',
  $ensure = present,
  $allow_users = 'admin pb git deb ircbouncer',
) {
  package { 'openssh-server':
    ensure => $ensure,
  }

  file { "${name}_sshd_config":
    ensure  => $ensure,
    content => template('sshserver/sshd_config.erb'),
    path    => '/etc/ssh/sshd_config',
    owner   => root,
    group   => root,
    mode    => '0644',

    require => Package['openssh-server'],
  }

  service { "${name}_ssh":
    ensure    => running,
    name      => 'ssh',
    enable    => true,
    hasstatus => true,

    require   => [File["${name}_sshd_config"],Package['openssh-server']],
    subscribe => File["${name}_sshd_config"],
  }
}
