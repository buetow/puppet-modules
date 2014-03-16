class sysstat (
  $generate_html = false,
  $html_dir = '/var/sysstathtml'
) {

  if $generate_html {
    $ensure_html = absent

  } else {
    $ensure_html = present
  }

  package { 'sysstat':
    ensure => installed
  }

  class { 'sysstat::files':
    require => Package['sysstat'],
  }

  service { 'sysstat':
    ensure => running,
    enable => true,

    require   => Class['sysstat::files'],
    subscribe => Class['sysstat::files'],
  }

  class { 'sysstat::html':
    ensure   => $ensure_html,
    html_dir => $html_dir,
  }
}

