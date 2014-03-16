define apache::vhost_sslorplain (
  $ip4address,
  $ip6address,
  $ext,
  $user,
  $vhost,
  $document_root,
  $includes,
  $redirect,
  $redirect_plain,
  $ensure
) {

  $suexec_user = $user
  $suexec_group = $user

  if $suexec_user == '' {
    $myuser = 'www-data'

  } else {
    $myuser = $suexec_user
  }

  if $redirect == '' {
    $use_rewrite = 'no'

  } else {
    $use_rewrite = 'yes'
    $rewrites = ["^/(.*)  ${redirect}\$1 [L,R=301]"]
  }

  $path_available = "/etc/apache2/sites-available/${vhost}-${ext}"
  $path_enabled = "/etc/apache2/sites-enabled/${vhost}-${ext}"

  file { $path_available:
    ensure  => $ensure,
    content => template('apache/vhost.erb'),
    owner   => root,
    group   => root,
  }

  if $ensure == present {
    $ensurelink = link
  } else {
    $ensurelink = $ensure
  }

  file { $path_enabled:
    ensure => $ensurelink,
    target => $path_available,

    require => File[$path_available]
  }
}


