class kvm (
  $ensure = present
) {
  class { 'kvm::packages':
    ensure => $ensure
  }
}

