class uptimed::packages (
  $ensure,
){
  package { 'uptimed':
    ensure => $ensure,
  }
}
