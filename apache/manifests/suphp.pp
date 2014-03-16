define apache::suphp {
  package { 'libapache2-mod-suphp':
    ensure => present,
  }

  package { 'php5-cgi':
    ensure => present,
  }

  file { '/etc/suphp/suphp.conf':
    ensure => present,
    source => 'puppet:///modules/apache/suphp.conf',

    require => Package['libapache2-mod-suphp'],
  }

  apache::module { 'suphp':
    custom_conf => 'suphp',

    require => [Package['libapache2-mod-suphp'],Package['php5-cgi']],
  }
}

