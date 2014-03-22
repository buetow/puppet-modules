class ejabberd::files (
  $ensure = present
  $cert_name = 'jabber.buetow.org.pem',
  $cert_location = 'puppet:///files/ejabberd/certs/jabber.buetow.org.pem',
){
  file { '/etc/ejabberd/ejabberd.cfg':
    ensure => $ensure,
    source => 'puppet:///modules/ejabberd/ejabberd.cfg',
    owner  => 'ejabberd',
    group  => 'ejabberd',
    mode   => '0600',
  }

  file { "/etc/ejabberd/${cert_name}",
    ensure => $ensure,
    source => $cert_location,
    owner  => 'root',
    group  => 'ejabberd',
    mode   => '0640',
  }
}
