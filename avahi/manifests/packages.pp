class avahi::packages (
  $ensure = installed
)
{
  package { 'avahi-daemon':
    ensure => $ensure
  }

  package { 'avahi-discover':
    ensure => $ensure
  }

  package { 'libnss-mdns':
    ensure => $ensure
  }
}

