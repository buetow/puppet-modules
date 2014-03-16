class wordpress::files (
  $ensure = present,
){
  File { owner => root, group => root, ensure => $ensure }

  file { '/etc/apache2/conf.d/my-wordpress':
    content => template('wordpress/my-wordpress.erb'),
  }

  file { '/etc/wordpress/config-comp.buetow.org.php':
    content => template('wordpress/config-comp.buetow.org.php.erb'),
  }

  file { '/etc/wordpress/config-blog.buetow.org.php':
    content => template('wordpress/config-blog.buetow.org.php.erb'),
  }

  file { "/etc/wordpress/config-${::fqdn}.php":
    content => template('wordpress/config.php.erb'),
  }
}

