define lxc::container (
  # Can overwrite lxc_default_cintainer_params
  $lxc_container_params = {},
  # Ensures that the LXC auto starts at host system boot
  $autostart = true,
  # Specifies the os_image to install (the very first time)
  $os_image,
  # Depending on this some extra configurations are made
  $os_flavor,
  # Specifies the location to fetch the image from
  $os_image_base_fetch_uri = 'http://images.example.com/deployables',
  # Sets the root password of the container
  $root_pw = '',
  # Ensures the container to be present or purged
  $ensure = present,
  # Use the same puppet as the LXC master server
  $debian_use_puppet = true,
) {
  File { owner => 'root', group => 'root' }

  $rootfs = "/var/lib/lxc/${name}/rootfs"

  if $ensure == present {
    $lxc_default_container_params = {
      ## Container
      'lxc.utsname' => $name,
      'lxc.rootfs'  => $rootfs,
      'lxc.arch'    => 'x86_64',
      'lxc.tty'     => 6,
      'lxc.pts'     => 1024,

      ## Capabilities
      # Add a counter (0) (1) (2) for the case there are several entries
      'lxc.cap.(0).drop' => 'mac_admin',
      'lxc.cap.(1).drop' => 'mac_override',
      'lxc.cap.(2).drop' => 'sys_admin',
      'lxc.cap.(3).drop' => 'sys_module',

      ## Devices
      # Deny all devices
      'lxc.cgroup.devices.(00).deny' => 'a',
      # Allow to mknod all devices (but not using them)
      'lxc.cgroup.devices.(01).allow' => 'c *:* m',
      'lxc.cgroup.devices.(02).allow' => 'b *:* m',
      # /dev/console
      'lxc.cgroup.devices.(03).allow' => 'c 5:1 rwm',
      # /dev/fuse
      'lxc.cgroup.devices.(04).allow' => 'c 10:229 rwm',
      # /dev/null
      'lxc.cgroup.devices.(05).allow' => 'c 1:3 rwm',
      # /dev/ptmx
      'lxc.cgroup.devices.(06).allow' => 'c 5:2 rwm',
      # /dev/pts/*
      'lxc.cgroup.devices.(07).allow' => 'c 136:* rwm',
      # /dev/random
      'lxc.cgroup.devices.(08).allow' => 'c 1:8 rwm',
      # /dev/rtc
      'lxc.cgroup.devices.(09).allow' => 'c 254:0 rwm',
      # /dev/tty
      'lxc.cgroup.devices.(10).allow' => 'c 5:0 rwm',
      # /dev/urandom
      'lxc.cgroup.devices.(11).allow' => 'c 1:9 rwm',
      # /dev/zero
      'lxc.cgroup.devices.(12).allow' => 'c 1:5 rwm',

      ## Filesystem
      'lxc.mount.(0).entry' => "proc ${rootfs}/proc proc nodev,noexec,nosuid 0 0",
      'lxc.mount.(1).entry' => "sysfs ${rootfs}/sys sysfs defaults,ro 0 0",

      ## Limits
      # 'lxc.cgroup.cpuset.cpus'                 => 0,
      # 'lxc.cgroup.memory.limit_in_bytes'       => '1024MB',
      # 'lxc.cgroup.memory.memsw.limit_in_bytes' => '1536MB',
      }

      $lxc_config = merge($lxc_default_container_params,$lxc_container_params)

      file { "/var/lib/lxc/${name}":
        ensure => directory,
        mode   => '0755',
        force  => true,
      }

      file { "/var/lib/lxc/${name}/config":
        ensure  => present,
        mode    => '0644',
        content => template('lxc/config.erb'),
      }

      $os_image_url = "${os_image_base_fetch_uri}/${os_image}"
      exec { "${name}_fetch_os_image":
        command => "/bin/sh -c '/usr/bin/curl ${os_image_url} | /bin/tar -C /var/lib/lxc/${name}/ -xjpf -'",
        unless  => "/usr/bin/test -d ${rootfs}",

        require => File["/var/lib/lxc/${name}"],
      }

      if $root_pw != '' {
        exec { "/usr/sbin/chroot ${rootfs} /bin/bash -c 'chpasswd <<< \'root:${root_pw}\''":
          refreshonly => true,
          subscribe   => Exec["${name}_fetch_os_image"],
          require     => Exec["${name}_fetch_os_image"],
        }
      }

      lxc::flavor { $name:
        ensure                          => $ensure,
        os_flavor                       => $os_flavor,
        debian_use_puppet               => $debian_use_puppet,

        subscribe => Exec["${name}_fetch_os_image"],
        require   => Exec["${name}_fetch_os_image"],
      }

      # Linux Container Boot Autostart
      if $autostart {
        file { "/etc/lxc/auto/${name}":
          ensure => present,
          target => "/var/lib/lxc/${name}/config",
        }
        # Also autostart container right after creation
        exec { "/usr/bin/lxc-start -n ${name} -d":
          onlyif => "/usr/bin/lxc-info -n ${name} | /bin/grep STOPPED",

          require => Lxc::Flavor[$name],
        }

      } else {
        file { "/etc/lxc/auto/${name}":
          ensure => absent,
          target => "/var/lib/lxc/${name}/config",
        }
      }

    } else {
      file { "/etc/lxc/auto/${name}":
        ensure => absent
      }
      # Stop container before deleting it
      exec { "/usr/bin/lxc-stop -n ${name}":
        onlyif => "/usr/bin/lxc-info -n ${name} | /bin/grep RUNNING",
      }
      # Delete the container
      exec { "${name}_purge":
        command => "/bin/rm -Rf /var/lib/lxc/${name}",
        onlyif  => "/usr/bin/test -d /var/lib/lxc/${name}/",

        require => Exec["/usr/bin/lxc-stop -n ${name}"],
      }
    }
}
