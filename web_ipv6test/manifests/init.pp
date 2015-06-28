class web_ipv6test (
  $ensure = present,
  $document_root = '/usr/local/www/apache24/data/ipv6',
){

  if $ensure == present {
    file { $document_root:
      ensure => directory
    }
    package { 'bind-tools': 
      ensure => installed,
    }
  } else {
    file { $document_root:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  }

  file { "${document_root}/index.pl":
    ensure  => $ensure,
    mode    => '0755',
    source  => 'puppet:///modules/web_ipv6test/index.pl',

    require => File[$document_root],
  }
}
