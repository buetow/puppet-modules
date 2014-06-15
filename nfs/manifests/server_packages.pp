class nfs::server_packages (
  $ensure = installed
){
  if $operatingsystem != 'FreeBSD' {
    package { 'nfs-kernel-server':
      ensure => $ensure
    }
  }
}
