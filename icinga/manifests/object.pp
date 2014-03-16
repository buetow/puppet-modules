define icinga::object (
  $ensure,
  $icinga_type,
  $objects_dir = '',
  $keys = {},
) {

  if $objects_dir == '' {
    $my_objects_dir = '/etc/icinga/puppet-objects'
  } else {
    $my_objects_dir = $objects_dir
  }

  file { "${my_objects_dir}/${name}.cfg":
    ensure  => $ensure,
    content => template('icinga/object.cfg.erb'),

    notify => Service['icinga'],
  }
}
