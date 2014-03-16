define initd (
  $short_description,
  $start_runlevels = [2, 3, 4],
  $stop_runlevels = [0, 1, 5, 6],
  $start_order = '09',
  $stop_order = '01',
  $ensure = present,
  $description = $short_description,
  $provides = $name,
  $required_start = '',
  $required_stop = '',
  $should_start = '',
  $do_start = 'echo Not implemented;exit 1',
  $do_restart = 'do_stop;do_start',
  $do_reload = 'echo Not implemented;exit 1',
  $do_stop = 'echo Not implemented;exit 1',
  $do_status = 'echo Not implemented;exit 1',
) {

  $default_start = join($start_runlevels, ' ')
  $default_stop = join($stop_runlevels, ' ')

  File {
    owner => root,
    group => root,
  }

  file { "/etc/init.d/${provides}":
    ensure  => $ensure,
    content => template('initd/initd.erb'),
    mode    => '0755',
  }

  # Remove all existing init symlinks first, in order to be clean
  exec { "${name}_remove":
    command     => "/usr/sbin/update-rc.d -f ${provides} remove",
    refreshonly => true,
    subscribe   => File["/etc/init.d/${provides}"],
    require     => File["/etc/init.d/${provides}"],
  }

  # Only re-created wanted symlinks
  if $ensure == present {
    exec { "${name}_defaults":
      command     => "/usr/sbin/update-rc.d -f ${provides} defaults ${start_order} ${stop_order}",
      refreshonly => true,
      subscribe   => [File["/etc/init.d/${provides}"],Exec["${name}_remove"]],
      require     => [File["/etc/init.d/${provides}"],Exec["${name}_remove"]],
    }
  }
}
