class uptimed::packages (
  $ensure,
){

  # No CentOS packages available, compile manually
  # and install to /usr/local/sbin/uptimed
  if $operatingsystem != 'CentOS' {
    package { 'uptimed':
      ensure   => $ensure,
    }
  }
}
