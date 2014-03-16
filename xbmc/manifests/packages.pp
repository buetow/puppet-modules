class xbmc::packages (
  $ensure = installed
) {

  package { 'xbmc':
    ensure => $ensure
  }

  package { 'xbmc-standalone':
    ensure => installed
  }
}

