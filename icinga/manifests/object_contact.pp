define icinga::object_contact (
  $ensure = present,
  $objects_dir = '',
  $keys = {},
) {

  $icinga_type = 'contact'

  $default_keys = {
    'contact_name'                  => $name,
    'alias'                         => $name,
    'service_notification_period'   => '24x7',
    'host_notification_period'      => '24x7',
    'service_notification_options'  => 'w,u,c,r',
    'host_notification_options'     => 'd,r',
    'service_notification_commands' => 'notify-service-by-email',
    'host_notification_commands'    => 'notify-host-by-email',
    'email'                         => 'root@localhost',
  }

  icinga::object { "${icinga_type}_${name}":
    ensure      => $ensure,
    icinga_type => $icinga_type,
    objects_dir => $objects_dir,
    keys        => merge($default_keys, $keys)
  }
}

