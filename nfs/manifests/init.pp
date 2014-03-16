class nfs (
  $isserver
) {

  if $isserver {
    class { 'nfs::server_packages':
    }

    class { 'nfs::server_files':
      require => Class['nfs::server_packages'],
    }

    service { 'nfs-kernel-server':
      ensure => running,

      require   => Class['nfs::server_files'],
      subscribe => Class['nfs::server_files'],
    }
  }
}
