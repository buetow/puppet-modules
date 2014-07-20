define zfs::create (
  $ensure = present,
  $filesystem = '',
  $noop = false,
){
  Exec {
    path => '/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin'
  }

  if !$noop {
    case $ensure {
      present: {
        exec { "${name}_create":
          command => "zfs create ${name}",
          unless  => "zfs list ${name}"
        }
        exec { "zfs set mountpoint=${filesystem} ${name}":
          unless => "zfs get mountpoint ${name} | grep -q ' ${filesystem} '",

          require => Exec["${name}_create"],
        }
      }
      absent: {
        exec { "zfs destroy -r ${name}":
          onlyif => "zfs list ${name}"
        }
      }
    }
  }
}
