define apache::ssl_cert {
  file { "/etc/apache2/certs/${name}.crt":
    ensure => present,
    source => "puppet:///modules/apache/certs/${name}.crt",
    owner  => root,
    group  => root,
    mode   => '0400',
  }

  file { "/etc/apache2/certs/${name}.key":
    ensure => present,
    source => "puppet:///modules/apache/certs/${name}.key",
    owner  => root,
    group  => root,
    mode   => '0400',
  }
}

