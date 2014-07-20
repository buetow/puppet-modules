class lxc::packages {
  package { 'lxc':
    ensure => installed
  }

  package { 'libvirt-bin':
    ensure => installed
  }

  package { 'debootstrap':
    ensure => installed
  }

  # For creating tap devices
  package { 'uml-utilities':
    ensure => installed
  }

  # For creating a network bridge
  package { 'bridge-utils':
    ensure => installed
  }
}
