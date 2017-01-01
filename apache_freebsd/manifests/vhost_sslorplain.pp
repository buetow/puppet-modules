define apache_freebsd::vhost_sslorplain (
  $ensure,
  $ip4address,
  $ip6address,
  $ext,
  $vhost,
  $document_root,
  $includes,
  $redirect,
  $redirect_plain,
  $destination,
  $apache_log_dir,
  $ssl_opts = {},
  $extra_opts = {},
  $alias_from = '',
  $alias_to = [],
) {

  if $redirect == '' {
    $use_rewrite = false

  } else {
    $use_rewrite = true
    $rewrites = ["^/(.*) ${redirect}\$1 [L,R=301]"]
  }

  file { "${destination}/${vhost}-${ext}.conf":
    ensure  => $ensure,
    content => template('apache_freebsd/vhost.erb'),
    owner   => root,
    group   => $root_group,
  }
}
