define bhyve::generic::create (
  $ensure,
  $mountpoint,
  $bhyve_config = {},
) {
  # Keys with preceeding _ are not added to bhyve.conf
  $bhyve_config_default = {
    '_iso_base_path' => '/bhyve',
    '_install_iso' => 'ubuntu-16.04.1-server-amd64.iso',
    '_grub_ram' => '1024M',
    '_ram' => '2048M',
    '_net_dev' => 'tap0',
  }

  $config = merge($bhyve_config_default, $bhyve_config)

  if $ensure == present {
    $ram = $config['_ram']
    $grub_ram = $config['_grub_ram']
    $net_dev = $config['_net_dev']

    $install_iso = $config['_install_iso']
    $iso_base_path = $config['_iso_base_path']
    $iso = "${iso_base_path}/${install_iso}"

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
