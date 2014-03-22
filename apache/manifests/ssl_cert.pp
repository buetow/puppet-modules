define apache::ssl_cert (
  cert_location = 'puppet:///files/apache/certs'
) {
  file { "/etc/apache2/certs/${name}.crt":
    ensure => present,
    source => "${cert_location}/${name}.crt",
    owner  => root,
    group  => root,
    mode   => '0400',
  }

  file { "/etc/apache2/certs/${name}.key":
    ensure => present,
    source => "${cert_location}/${name}.key",
    owner  => root,
    group  => root,
    mode   => '0400',
  }
}

