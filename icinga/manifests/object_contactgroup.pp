define icinga::object_contactgroup (
  $ensure = present,
  $objects_dir = '',
  $keys = {},
) {

  $icinga_type = 'contactgroup'

  $default_keys = {
    'contactgroup_name' => $name,
    'alias'             => $name,
    'members'           => 'root',
  }

  icinga::object { "${icinga_type}_${name}":
    ensure      => $ensure,
    icinga_type => $icinga_type,
    objects_dir => $objects_dir,
    keys        => merge($default_keys, $keys)
  }
}

