define apache (
  $ip6address,
  $ip4address,
  $testuser = 'test',
  $createtestuser = 'yes',
  $varwww = '',
  $has_suexec = false,
  $has_suphp = false,
  $has_rewrite = false,
  $has_ssl = false,
  $start_servers = '1',

  # Prefork stuff
  $use_prefork = true,
  $min_spare_servers = '1',
  $max_spare_servers = '2',
  $max_clients = '100',
  $max_requests_per_child = '1000',
) {

  if $varwww == '' {
    $myvarwww = $::hostname

  } else {
    $myvarwww = $varwww
  }

  package { 'apache2':
    ensure => present,
  }

  # Can be extended to use other apache mpm
  if $use_prefork {
    package { 'apache2-mpm-prefork':
      ensure => present,
    }
    file { '/etc/apache2/conf.d/my-prefork.conf':
      ensure  => present,
      content => template('apache/prefork.conf.erb'),
      mode    => '0644',
      owner   => root,
      group   => root,

      require => Package['apache2-mpm-prefork'],
    }
  } else {
    file { '/etc/apache2/conf.d/my-prefork.conf':
      ensure  => absent,
    }
  }

  apache::conf { "${name}_conf":
    ip4address  => $ip4address,
    ip6address  => $ip6address,
    has_suexec  => $has_suexec,
    has_suphp   => $has_suphp,
    has_rewrite => $has_rewrite,
    has_ssl     => $has_ssl,

    require => Package['apache2'],
  }

  file { '/var/www/':
    source  => "puppet:///modules/apache/${myvarwww}",
    recurse => true,

    require => Package['apache2'],
  }

  file { '/var/www/favicon.ico':
    ensure => present,
    source => 'puppet:///modules/apache/favicon.ico',

    require => File['/var/www/'],
  }

  if $createtestuser == 'yes' {
    conf_user::create { "${name}_user":
      user_name               => $testuser,
      has_public_html         => true,
      has_public_html_testing => true,
    }
  }
}

