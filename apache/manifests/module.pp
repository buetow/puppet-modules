define apache::module (
  $load = 'yes',
  $default_conf = 'yes',
  $custom_conf = ''
) {

  if $load == 'yes' {
    $load_ensure = link

  } else {
    $load_ensure = absent
  }

  file { "/etc/apache2/mods-enabled/${name}.load":
    ensure => $load_ensure,
    target => "../mods-available/${name}.load",

    notify => Exec["${name}_reload_apache"],
  }

  if $default_conf == 'yes' {
    $default_conf_ensure = link

  } else {
    $default_conf_ensure = absent
  }

  file { "/etc/apache2/mods-enabled/${name}.conf":
    ensure => $default_conf_ensure,
    target => "../mods-available/${name}.conf",
    notify => Exec["${name}_reload_apache"],
  }

  if $custom_conf != '' {
    file { "/etc/apache2/conf.d/my-${custom_conf}":
      ensure => present,
      source => "puppet:///modules/apache/my-${custom_conf}",
      owner  => root,
      group  => root,
      notify => Exec["${name}_reload_apache"],
    }
  }

  exec { "${name}_reload_apache":
    command     => '/etc/init.d/apache2 reload',
    refreshonly => true,
  }
}
