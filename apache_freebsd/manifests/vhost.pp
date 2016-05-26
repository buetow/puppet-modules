define apache_freebsd::vhost (
  $ensure = present,
  $document_root,
  $ensur = present,
  $ip4address = '',
  $ip6address = '',
  $use_plain = true,
  $use_ssl = false,
  $includes = [],
  $redirect = '',
  $redirect_plain = false,
  $ssl_opts = {
    'ssl_cipher_suite'            => 'DHE:ECDHE:HIGH:!EXP:!LOW:!MD5:!RC4:!aNULL:!eNULL',
    'ssl_certificate_file'        => '/usr/local/etc/ssl-certs/ssl.crt',
    'ssl_key_file'                => '/usr/local/etc/ssl-certs/ssl.key',
    'ssl_ca_certificate_file'     => '/usr/local/etc/ssl-certs/ca.pem',
    #'ssl_certificate_chain_file' => '/usr/local/etc/ssl-certs/chain.pem',
  },
  $extra_opts = {},
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
      extra_opts     => $extra_opts,
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
      ssl_opts       => $ssl_opts,
      extra_opts     => $extra_opts,
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
}
