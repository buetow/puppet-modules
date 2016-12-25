define bhyve::generic::create (
  $ensure,
  $mountpoint,
  $bhyve_config = {},
) {
  # Keys with preceeding _ are not added to bhyve.conf
  $bhyve_config_default = {
    '_install_iso' => 'ubuntu-16.04.1-server-amd64.iso'
  }

  $config = merge($bhyve_config_default, $bhyve_config)

  if $ensure == present {
    $install_iso = $config['_install_iso']
    $iso = "/bhyve/${install_iso}"

    file { "${mountpoint}/grub.map":
      ensure  => present,
      mode    => '0644',
      content => template('bhyve/grub.map.erb'),
    }
    file { "${mountpoint}/install.sh":
      ensure  => present,
      mode    => '0755',
      content => template('bhyve/install.sh.erb'),
    }
    file { "${mountpoint}/start.sh":
      ensure  => present,
      mode    => '0755',
      content => template('bhyve/start.sh.erb'),
    }
    file { "${mountpoint}/destroy.sh":
      ensure  => present,
      mode    => '0755',
      content => template('bhyve/destroy.sh.erb'),
    }
  }
}
