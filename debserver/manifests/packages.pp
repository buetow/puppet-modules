class debserver::packages (
  $ensure = installed
){
  package { 'reprepro':
    ensure => $ensure
  }
}
