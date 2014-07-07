jail
===

## Description

An humble puppet module to manage FreeBSD jails. Currently for Debian GNU/kFreeBSD only.

This module may depends on other puppet modules of this git repository (such as zfs and freebsd).

Depending on the jail's type there is additional stuff done with a newly created jail, such as bootstrapping etc.  Everything is done via the 'new style' jail configuration file jail.conf.

Currently there are only the jail type 'debian_kfreebsd' implemented. Other types might be implemented after I (or you) need them. But it's possible just to prepare jails (creating the configs and the correct mountpoints) by specifying no type (internal type noop).

=======

Usage
-----

Example:

    include jail::debian_kfreebsd

    class { 'jail':
      ensure              => present,
      use_zfs             => true,
      zfs_tank            => zroot,
      mountpoint          => '/jail',
      jails_config        => {
        kfreebsd          => {
          '_ensure'       => present,
          '_type'         => 'debian_kfreebsd',
          'host.hostname' => "'kfreebsd.fritz.box'",
          'exec.start'    => "'${jail::debian_kfreebsd::exec_start}'",
          'exec.stop'     => "'${jail::debian_kfreebsd::exec_stop}'",
          'ip4.addr'      => '192.168.178.200',
        },
        foo          => {
          '_ensure'       => absent,
          '_type'         => 'noop',
          'host.hostname' => "'foo.fritz.box'",
          'ip4.addr'      => '192.168.178.201',
        },
      }
    }

This ensures that a jail 'kfreebsd' is present (inlcuding zfs mountpoint (every jail owns its own zfs mountpoint) and debootstrap) and that a jail 'foo' is absent (zfs mountpoint destroyed, all configs removed).

Afterwards all you have to do is:

    service jail start kfreebsd
    jexec kfreebsd /bin/bash

:-)


