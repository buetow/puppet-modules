class rsync::client {
  package {'rsync':
    ensure => installed
  }
}
