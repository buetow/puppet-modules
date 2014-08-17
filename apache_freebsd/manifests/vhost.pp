define apache_freebsd::vhost (
  $document_root,
  $ensure = present,
  $ip4address = '',
  $ip6address = '',
  $use_plain = true,
  $use_ssl = false,
  $includes = [],
  $redirect = '',
  $redirect_plain = false,
  $destination = '/usr/local/etc/apache/vhosts.d',
  $apache_log_dir = '/var/log/apache/',
) {

  $vhost = $name

  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  if $use_plain {
    apache_freebsd::vhost_sslorplain { "${name}_plain":
      ensure         => $ensure,
      ext            => 'plain',
      vhost          => $vhost,
      document_root  => $document_root,
      includes       => $includes,
      redirect       => $redirect,
      redirect_plain => $redirect_plain,
      ip4address     => $ip4address,
      ip6address     => $ip6address,
      destination    => $destination,
      apache_log_dir => $apache_log_dir,
    }
  }

  if $use_ssl {
    apache_freebsd::vhost_sslorplain { "${name}_ssl":
      ensure         => $ensure,
      ext            => 'ssl',
      vhost          => $vhost,
      document_root  => $document_root,
      includes       => $includes,
      redirect       => $redirect,
      redirect_plain => $redirect_plain,
      ip4address     => $ip4address,
      ip6address     => $ip6address,
      destination    => $destination,
      apache_log_dir => $apache_log_dir,
    }

    apache::ssl_cert { $vhost:
    }
  }
}
