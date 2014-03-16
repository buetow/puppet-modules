define apache::suexec {
  apache::module { 'userdir':
    default_conf => no,
    custom_conf  => 'userdir',
  }

  apache::module { 'cgi':
    default_conf => no,
    custom_conf  => 'cgi',
  }

  package { 'libapache2-mod-fastcgi':
    ensure => present,
  }

  package { 'libfcgi-perl':
    ensure => present,
  }

  apache::module { 'fastcgi':
    default_conf => no,
    custom_conf  => 'fastcgi',

    require => [Package['libapache2-mod-fastcgi'],Package['libfcgi-perl']],
  }

  package { 'apache2-suexec-custom':
    ensure => present,
  }

  apache::module { 'suexec':
    default_conf => no,

    require => Package['apache2-suexec-custom'],
  }

  file { '/etc/apache2/suexec/www-data':
    ensure => present,
    source => 'puppet:///modules/apache/suexec/www-data',
    owner  => root,
    group  => root,

    require => Package['apache2-suexec-custom'],
  }
}

