define icinga::object_service (
  $ensure = present,
  $objects_dir = '',
  $keys = {},
) {

  $icinga_type = 'service'

  $default_keys = {
    'name'     => $name,
    'register' => '1',
  }

  icinga::object { "${icinga_type}_${name}":
    ensure      => $ensure,
    icinga_type => $icinga_type,
    objects_dir => $objects_dir,
    keys        => merge($default_keys, $keys)
  }
}

