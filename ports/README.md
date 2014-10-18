ports
=====

## Description

An humble puppet module to manage the FreeBSD ports tree using ZFS and portsnap.

=======

Usage
-----

Example:

    class { 'ports':
      ensure     => present,
      mountpoint => '/ports',
      symlink    => '/usr/ports',
      use_zfs    => true,
      zpool      => zroot,
    }

This ensures that a ZFS mountpoint /ports exists in tank zroot. And that there is a symlink from /usr/ports pointing to it.

It also initially fetches the ports tree via 'portsnap fetch' and does a initial 'portsnap extract'. 

If all of this is successfull, it creates a daily cron job to run 'portsnap cron && portsnap update'.

