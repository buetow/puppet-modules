class sshserver::packages (
  $ensure,
) {
  # Is already in FreeBSD base system
  if $operatingsystem != 'FreeBSD' {
    package { 'openssh-server':
      ensure => $ensure,
    }
  }
}
