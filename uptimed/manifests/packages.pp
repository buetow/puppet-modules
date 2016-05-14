class uptimed::packages (
  $ensure,
){

  # No CentOS packages available, compile manually
  # and install to /usr/local/sbin/uptimed
  if $operatingsystem != 'CentOS' {
    include pkgng
    package { 'uptimed':
      provider => pkgng,
      ensure   => $ensure,
    }
  }
}
