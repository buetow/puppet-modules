define zfs::pool (
  $ensure = present,
  $filesystem = '',
){
  Exec {
    path => '/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin'
  }

  case $ensure {
    present: {
      exec { "${name}_pool_create":
        command => "zfs create ${name}",
        unless  => "zfs list ${name}"
      }
      exec { "zfs set mountpoint=${filesystem} ${name}":
        unless => "zfs get mountpoint ${name} | grep -q ' ${filesystem} '",

        require => Exec["${name}_pool_create"],
      }
    }
    absent: {
      exec { "zfs destroy ${name}":
        onlyif => "zfs list ${name}"
      }
    }
  }
}
