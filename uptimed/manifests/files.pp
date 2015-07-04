class uptimed::files (
  $ensure,
) {
  File { 
    owner => root, 
    group => $root_group,
    mode => '0644',
  }

  if $operatingsystem == 'CentOS' {
    file { '/usr/lib/systemd/system/uptimed.service':
      source => "puppet:///modules/uptimed/${operatingsystem}/uptimed.service",
      ensure => present,
    }
    $prefix = '/usr/local'

  } else {
    $prefix = $default_prefix
  }

  file { "${prefix}/etc/uptimed.conf":
    ensure  => $ensure,
    content => template('uptimed/uptimed.conf.erb'),
  }
}
