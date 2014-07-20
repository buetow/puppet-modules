define lxc::flavor (
  $os_flavor,
  $ensure,
  $extip = '',
  $debian_use_puppet = true,
) {
  File { owner => 'root', group => 'root' }

  $rootfs = "/var/lib/lxc/${name}/rootfs"
  $guest_fqdn = $name
  $guest_fqdn_array = split($guest_fqdn, '\.')
  $guest_hostname = $guest_fqdn_array[0]

  if $ensure == present {
    file { "${rootfs}/etc/lxc_master":
      ensure  => $ensure,
      content => "${::fqdn}\n",
    }

    if $extip != '' {
      file { "${rootfs}/etc/lxc_extip":
        ensure  => $ensure,
        content => "${extip}\n",
      }
    }

    case $os_flavor {
      'debian' :{
        file { "${rootfs}/etc/hostname":
          ensure  => $ensure,
          content => "${guest_hostname}\n",
          replace => no,
        }

        file { "${rootfs}/etc/resolv.conf":
          ensure  => $ensure,
          content => template("lxc/flavors/${os_flavor}/resolv.conf.erb"),
          replace => no,
        }

        lxc::chrootexec { 'apt-get install openssh-server -y':
          lxc_name    => $name,
          refreshonly => true,
          require     => File["${rootfs}/etc/resolv.conf"],
        }

        if $debian_use_puppet {
          # Not implemented
        }
      }

      'suse81' :{
        file { "${rootfs}/etc/HOSTNAME":
          ensure  => $ensure,
          content => "${guest_fqdn}\n",
          replace => no,
        }

        file { "${rootfs}/etc/resolv.conf":
          ensure  => $ensure,
          content => template("lxc/flavors/${os_flavor}/resolv.conf.erb"),
          replace => no,
        }
      }

      default:{
        warning("No such OS flavor ${os_flavor}, I am not post-configuring the container")
      }
    }
  }
}
