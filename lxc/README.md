# Linux Containers

This module handle some LXC operations via puppet. This has been only tested on a Unitix GNU/Linux Wheezy 64 box.

# Example

## Installing LXC

```puppet
class { 'lxc': }
```

## Create an LXC tonainer

```puppet
lxc::container { 'mamat-lxcfoo.server.lan':
  os_image                         => 'lxc-rootfs-debian-wheezy-7.1-x86_64.tar.bz2',
  os_flavor                        => 'debian',
  root_pw                          => 'foobar',
  lxc_container_params             => {
    'lxc.network.(1).type'         => 'veth',
    'lxc.network.(2).link'         => 'br0',
    'lxc.network.(3).flags'        => 'up',
    'lxc.network.(4).ipv4'         => '192.168.53.102/24',
    'lxc.network.(5).ipv4.gateway' => '192.168.53.1',
  },

  autostart => true,
  ensure    => present,
  require   => Class['lxc'],
}
```
