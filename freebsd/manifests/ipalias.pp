define freebsd::ipalias (
  $ensure = present,
  $ip = $name,
  $netmask = '255.255.255.0',
  $alias = 'alias0',
  $interface,
) {

  case $ensure {
    up: { $ensure_file = present }
    present: { $ensure_file = present }
    absent: { $ensure_file = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  $up_args = "${ip} netmask ${netmask} alias"
  $dn_args = "${ip} netmask ${netmask} -alias"

  freebsd::rc_config { "ifconfig_${interface}_${alias}":
    ensure => $ensure_file,
    value  => "'${up_args}'",
  }

  if $ensure == up {
    exec { "/sbin/ifconfig ${interface} ${up_args}":
      unless => "/sbin/ifconfig ${interface} | /usr/bin/grep '${ipaddress} netmask'",
    }
  }

  if $ensure == absent {
    exec { "/sbin/ifconfig ${interface} ${dn_args}":
      onlyif => "/sbin/ifconfig ${interface} | /usr/bin/grep '${ipaddress} netmask'",
    }
  }
}
