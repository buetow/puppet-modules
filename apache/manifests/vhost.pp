define apache::vhost (
  $ip4address = '',
  $ip6address = '',
  $user = '',
  $use_plain = yes,
  $use_ssl = no,
  $destination = '/var/www',
  $includes = [],
  $redirect = '',
  $redirect_plain = 'no',
  $ensure = present
) {

  $vhost = $name

  if $ensure == present {
    $ensure_directory = directory
  } else {
    $ensure_directory = absent
  }

  if $destination == '/var/www' {
    if $user != '' {
      $document_root = "/home/${user}/public_html/$vhost"

      file { "/home/${user}/public_html/$vhost":
        ensure => $ensure_directory,
        force  => true,
        owner  => $user,
        group  => $user,
        mode   => '0755',
      }
    } else {
      $document_root = $destination
    }
  } else {
    $document_root = $destination
  }

  if $use_plain == 'yes' {
    apache::vhost_sslorplain { "${name}_plain":
      ensure         => $ensure,
      ext            => 'plain',
      user           => $user,
      vhost          => $vhost,
      document_root  => $document_root,
      includes       => $includes,
      redirect       => $redirect,
      redirect_plain => $redirect_plain,
      ip4address     => $ip4address,
      ip6address     => $ip6address,
    }
  }

  if $use_ssl == 'yes' {
    apache::vhost_sslorplain { "${name}_ssl":
      ensure         => $ensure,
      ext            => 'ssl',
      user           => $user,
      vhost          => $vhost,
      document_root  => $document_root,
      includes       => $includes,
      redirect       => $redirect,
      redirect_plain => $redirect_plain,
      ip4address     => $ip4address,
      ip6address     => $ip6address,
    }

    apache::ssl_cert { $vhost:
    }
  }
}
