class icinga::packages (
  $ensure,
){
  package { 'icinga-core':
    ensure => $ensure
  }

  package { 'icinga-cgi':
    ensure => $ensure,

    require => Package['icinga-core'],
  }
}
