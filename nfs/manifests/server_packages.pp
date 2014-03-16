class nfs::server_packages (
  $ensure = installed
){
  package { 'nfs-kernel-server':
    ensure => $ensure
  }
}
