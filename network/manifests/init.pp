class network (
  $template,
  $ipv4_address,
  $ipv4_broadcast,
  $ipv4_netmask,
  $ipv4_gateway,
  $ipv4_gateway_route,
  $ipv6_address,
  $ipv6_netmask,
  $ipv6_gateway,
  $ensure = present,
) {
  file { '/etc/network/interfaces':
    ensure  => $ensure,
    content => template("network/interfaces.${template}.erb")
  }
}
