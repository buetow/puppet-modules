define dav2fs::mount (
  $configs = {},
) {

  $default_config = {
    'ensure'    => present,
    'mountbase' => '/mnt',
    'atboot'    => false,
    'options'   => 'noauto,user',
    'device'    => 'https://davfs.example.com',
  }
  $this_config = $configs[$name]
  $config = merge($default_config, $this_config)

  $ensure = $config['ensure']
  $atboot = $config['atboot']
  $device = $config['device']
  $mountbase = $config['mountbase']
  $options = $config['options']

  if $ensure == present {
    $ensure_directory = directory
  } else {
    $ensure_directory = $ensure
  }


  file { "${mountbase}/${name}":
    ensure => $ensure_directory,
  }

  mount { "/mnt/${name}":
    ensure  => $ensure,
    device  => $device,
    fstype  => 'davfs',
    options => $options,
    atboot  => $atboot,

    require => File["${mountbase}/${name}"],
  }
}
