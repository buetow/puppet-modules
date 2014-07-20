class lxc (
  # $backports_kernel_version = '3.9-0.bpo.1',
  $backports_kernel_version = '',

  # Auto reboots after grub-mkconfig (only once after initial install)
  $autoreboot = true,

  # Ensure LXC is running
  $ensure = running,

  $bridge_interface = 'eth0',
){
  include lxc::packages

  class { 'lxc::cgroup':
    autoreboot => $autoreboot
  }

  if $backports_kernel_version != '' {
    $backports_kernel = "linux-image-${backports_kernel_version}-amd64"

    exec { "${name}_install_backports_kernel":
      command => "/usr/bin/apt-get install -t ${::lsbdistcodename}-backports ${backports_kernel} -y",
      unless  => "/bin/grep -q  ${backports_kernel_version} /boot/grub/grub.cfg",

      require => [Class['lxc::cgroup'],Class['debian_apt::backports']],
    }
  }

  service { 'lxc':
    ensure => $ensure,

    require => [Class['lxc::cgroup'],Class['lxc::packages']],
  }

  if $bridge_interface != 'none' {
    if $bridge_interface == 'tap0' {
      file { '/etc/network/.interfaces.localbridge':
        content => template('lxc/interfaces.localbridge.erb'),
      }

      exec { "${name}_localbridge":
        command => '/bin/cat /etc/network/.interfaces.localbridge >> /etc/network/interfaces',
        unless  => '/bin/grep -q "## LXC" /etc/network/interfaces',
        require => File['/etc/network/.interfaces.localbridge'],
      }

      exec { '/sbin/ifup tap0':
        refreshonly => true,
        require     => Exec["${name}_localbridge"],
        subscribe   => Exec["${name}_localbridge"],
      }

      exec { '/sbin/ifup br0':
        refreshonly => true,
        require     => Exec['/sbin/ifup tap0'],
        subscribe   => Exec['/sbin/ifup tap0'],
      }
    } else {
      file { '/etc/network/.interfaces.bridge':
        content => template('lxc/interfaces.bridge.erb'),
      }
      exec { "${name}_bridge":
        command => '/bin/cat /etc/network/.interfaces.bridge >> /etc/network/interfaces',
        unless  => '/bin/grep -q "## LXC" /etc/network/interfaces',
        require => File['/etc/network/.interfaces.bridge'],
      }
      exec { '/sbin/ifup br0':
        refreshonly => true,
        require     => Exec["${name}_bridge"],
        subscribe   => Exec["${name}_bridge"],
      }
    }
  }
}
