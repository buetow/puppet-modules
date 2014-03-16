class ejabberd::files (
  $ensure = present
){
  file { '/etc/ejabberd/ejabberd.cfg':
    ensure => $ensure,
    source => 'puppet:///modules/ejabberd/ejabberd.cfg',
    owner  => 'ejabberd',
    group  => 'ejabberd',
    mode   => '0600',
  }

  file { '/etc/ejabberd/jabber.buetow.org.pem':
    ensure => $ensure,
    source => 'puppet:///modules/ejabberd/jabber.buetow.org.pem',
    owner  => 'root',
    group  => 'ejabberd',
    mode   => '0640',
  }
}
