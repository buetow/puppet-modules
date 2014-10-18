jail
===

## Description

An humble puppet module to manage FreeBSD jails. Currently for FreeBSD and Debian GNU/kFreeBSD guests.

This module may depends on other puppet modules of this git repository (such as zfs and freebsd).

Depending on the jail's type there is additional stuff done with a newly created jail, such as bootstrapping etc.  Everything is done via the 'new style' jail configuration file jail.conf.

Currently there are only the jail types 'debian_kfreebsd' and 'freebsd' implemented. Other types might be implemented after I (or you) need them. But it's possible just to prepare jails (creating the configs and the correct mountpoints) by specifying no type (internal type noop).

=======

Usage
-----

Example:

    include jail::debian_kfreebsd
    include jail::freebsd

    class { 'jail':
      ensure              => present,
      use_zfs             => true,
      zpool               => zroot,
      mountpoint          => '/jail',
      jails_config              => {
        kfreebsd                => {
          '_ensure'             => present,
          '_type'               => 'debian_kfreebsd',
          # Ensure these additional directories exists inside the jail
          '_ensure_directories' => [ '/opt', '/opt/bin' ], 
          # Ensure these additional zfs mountpoints exist
          '_ensure_zfs'         => [ '/space' ], 
          'host.hostname'       => "'kfreebsd.fritz.box'",
          'exec.start'          => "'${jail::debian_kfreebsd::exec_start}'",
          'exec.stop'           => "'${jail::debian_kfreebsd::exec_stop}'",
          'ip4.addr'            => '192.168.178.200',
        },
        makemake          => {
          '_ensure'       => present,
          '_type'         => 'freebsd',
          '_mirror'       => 'ftp://ftp.de.freebsd.org',
          '_remote_path'  => 'FreeBSD/releases/amd64/10.0-RELEASE',
          '_dists'        => [ 'base.txz', 'doc.txz', 'games.txz', ],
          'exec.start'    => "'${jail::freebsd::exec_start}'",
          'exec.stop'     => "'${jail::freebsd::exec_stop}'",
          'host.hostname' => "'makemake.buetow.org'",
          'ip4.addr'      => '192.168.0.4',
          'ip6.addr'      => '2a01:4f8:a0:234e:f::4',
        },
        foo          => {
          '_ensure'       => absent,
          '_type'         => 'noop',
          'host.hostname' => "'foo.fritz.box'",
          'ip4.addr'      => '192.168.178.201',
        },
      }
    }

This ensures that a jail 'kfreebsd' and 'makemake' is present (inlcuding zfs mountpoint (every jail owns its own zfs mountpoint) and debootstrap) and that a jail 'foo' is absent (zfs mountpoint destroyed, all configs removed).

Afterwards all you have to do is:

    service jail start kfreebsd
    jexec kfreebsd bash

or for the other (FreeBSD) jail:

    service jail start makemake
    jexec makemake tcsh

:-)


