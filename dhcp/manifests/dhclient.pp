class dhcp::dhclient (
  $config_file = "dhclient.${hostname}.conf",
  $ensure = present
) {
  File { 
    owner => 'root', 
    group => $root_group,
  }

  file { '/etc/dhcp/dhclient.conf':
    ensure => $ensure,
    source => "puppet:///files/dhcp/${config_file}",
  }
}
