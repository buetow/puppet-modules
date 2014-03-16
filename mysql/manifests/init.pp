class mysql (
  $ensure = present,
  $mysqlpassword,
  $mysqld_key_buffer = '8M',
  $mysqld_max_allowed_packet = '16M',
  $mysqld_thread_cache_size = '1',
  $mysqld_query_cache_limit = '0M',
  $mysqld_query_cache_size = '0M',
) {

  package { 'mysql-server':
    ensure => $ensure,
  }

  file { '/etc/mysql/my.cnf':
    ensure  => $ensure,
    content => template('mysql/my.cnf.erb'),
  }

  if $ensure == present {
    service { 'mysql':
      ensure  => running,
      enable  => true,

      require   => [Package['mysql-server'],File['/etc/mysql/my.cnf']],
      subscribe => [Package['mysql-server'],File['/etc/mysql/my.cnf']],
    }
  }

  exec { "/usr/bin/mysqladmin password ${mysqlpassword}":
    onlyif  => '/usr/bin/mysql -u root',

    require => Service['mysql']
  }
}
