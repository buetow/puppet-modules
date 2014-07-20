jail
===

## Description

An humble puppet module to manage dav2fs. Has been tested on Debian GNU/Linux only. 

=======

Usage
-----

Example:

    class { 'dav2fs':
      ensure   => present,
      names    => [ 'mediacenter', 'foo' ],
      configs  => {
        'sd2dav'      => {
          'mountbase' => '/mnt',
          'atboot'    => false,
          'ensure'    => present,
          'options'   => 'noauto,user',
          'device'    => 'https://foo.example.com',
        },
        'mediacenter' => {
          'mountbase' => '/mnt',
          'atboot'    => false,
          'ensure'    => absent,
          'options'   => 'noauto,user',
          'device'    => 'https://sd2dav.1und1.de',
        },
      },
      secrets  => {
        'sd2dav' => {
          'user' => 'foo@example.com',
          'pass' => 'foobarbaz123!',
        },
      },
    }

:-)


