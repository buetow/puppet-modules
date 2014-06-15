class nfs (
  $isserver
) {
  if $isserver {
    class { 'nfs::server_packages':
    }

    class { 'nfs::server_files':
      require => Class['nfs::server_packages'],
    }

    if $operatingsystem == 'FreeBSD' {
      service { 'nfsd':
        ensure => running,
        enable => true,
    
        require   => Class['nfs::server_files'],
        subscribe => Class['nfs::server_files'],
      }
      service { 'mountd':
        ensure => running,
        enable => true,
    
        require   => Service['nfsd'],
        subscribe => Class['nfs::server_files'],
      }
    } else {
      service { 'nfs-kernel-server':
        ensure => running,
        enable => true,
    
        require   => Class['nfs::server_files'],
        subscribe => Class['nfs::server_files'],
      }
    }
  }
}
