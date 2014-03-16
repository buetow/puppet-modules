class uptimed::packages (
  $ensure,
){

  case $ensure {
    present: { $package_ensure = installed }
    default: { $package_ensure = purged }
  }

  package { 'uptimed':
    ensure => $package_ensure,
  }
}
