define freebsd::ipalias (
  $ensure = present,
  $proto = 'inet',
  $ip = $name,
  $preflen = '/24',
  $alias = 'alias0',
  $interface,
) {

  case $ensure {
    up: { $ensure_file = present }
    present: { $ensure_file = present }
    absent: { $ensure_file = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  $up_args = "${proto} ${ip}/${preflen} alias"
  $dn_args = "${proto} ${ip} -alias"

  freebsd::rc_config { "ifconfig_${interface}_${alias}":
    ensure => $ensure_file,
    value  => "'${proto} ${ip}/${preflen}'",
  }

  $grepstr = "${proto} ${ip}"

  if $ensure == up {
    exec { "/sbin/ifconfig ${interface} ${up_args}":
      unless => "/sbin/ifconfig ${interface} | /usr/bin/grep '${grepstr}'",
    }
  }

  if $ensure == absent {
    exec { "/sbin/ifconfig ${interface} ${dn_args}":
      onlyif => "/sbin/ifconfig ${interface} | /usr/bin/grep '${grepstr}'",
    }
  }
}
