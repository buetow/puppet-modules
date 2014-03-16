define apache::conf (
  $ip4address,
  $ip6address,
  $has_suexec = false,
  $has_suphp = false,
  $has_rewrite = false,
  $has_ssl = false,
  $has_rss = true,
) {

  file { '/etc/apache2/conf.d/my-namevirtualhost':
    ensure  => present,
    content => "NameVirtualHost ${ip4address}:80\nNameVirtualHost ${ip4address}:443\nNameVirtualHost [${ip6address}]:80\nNameVirtualHost [${ip6address}]:443\n",
    owner   => root,
    group   => root,
  }

  file { '/etc/apache2/conf.d/my-serversignature':
    ensure  => present,
    content => 'ServerSignature Off',
    owner   => root,
    group   => root,
  }

  file { '/etc/apache2/conf.d/my-servertokens':
    ensure  => present,
    content => 'ServerTokens Minimal',
    owner   => root,
    group   => root,
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure => absent,
  }

  file { '/etc/apache2/apache2.conf':
    ensure => present,
    source => 'puppet:///modules/apache/apache2.conf',
    owner  => root,
    group  => root,
  }

  file { '/etc/apache2/httpd.conf':
    ensure => present,
    content => '',
    owner  => root,
    group  => root,
  }

  file { '/etc/apache2/conf.d/my-default':
    ensure => present,
    source => 'puppet:///modules/apache/my-default',
    owner  => root,
    group  => root,
  }

  file { '/etc/apache2/conf.d/my-nosvn':
    ensure => absent,
    owner  => root,
    group  => root,
  }

  file { '/etc/apache2/conf.d/security':
    ensure => absent,
  }

  if $has_rss {
    file { '/etc/apache2/conf.d/my-rss':
      ensure  => present,
      content => 'Alias /rss /var/www/rss\n',
    }
  }

  if $has_suexec {
    apache::suexec { "${name}_suexec":
    }
  }

  if $has_suphp {
    apache::suphp { "${name}_suphp":
    }
  }

  if $has_rewrite {
    apache::rewrite { "${name}_rewrite":
    }
  }

  if $has_ssl {
    apache::ssl { "${name}_ssl":
    }
  }
}

