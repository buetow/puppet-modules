define icinga::object_timeperiod (
  $ensure = present,
  $objects_dir = '',
  $keys = {},
) {

  $icinga_type = 'timeperiod'

  $default_keys = {
    'timeperiod_name' => $name,
    'alias'           => $name,
  }

  icinga::object { "${icinga_type}_${name}":
    ensure      => $ensure,
    icinga_type => $icinga_type,
    objects_dir => $objects_dir,
    keys        => merge($default_keys, $keys)
  }
}

