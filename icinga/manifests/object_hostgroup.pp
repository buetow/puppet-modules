define icinga::object_hostgroup (
  $ensure = present,
  $objects_dir = '',
  $keys = {},
) {

  $icinga_type = 'hostgroup'

  $default_keys = {
    'hostgroup_name' => $name,
    'alias'          => $name,
    'members'        => 'localhost',
  }

  icinga::object { "${icinga_type}_${name}":
    ensure      => $ensure,
    icinga_type => $icinga_type,
    objects_dir => $objects_dir,
    keys        => merge($default_keys, $keys)
  }
}

