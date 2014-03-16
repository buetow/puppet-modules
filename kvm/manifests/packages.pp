class kvm::packages (
  $ensure = present
){
  package { 'libvirt-bin':
    ensure => $ensure
  }

  package { 'qemu-kvm':
    ensure => $ensure
  }

  package { 'virt-manager':
    ensure => $ensure
  }
}
