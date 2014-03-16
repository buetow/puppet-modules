define ejabberd::register (
  $vhost,
  $pass
) {
  exec { "${name}_exec":
    command => "/usr/sbin/ejabberdctl register ${name} ${vhost} ${pass}",
    unless  => "/usr/sbin/ejabberdctl check-account ${name} ${vhost}",
  }
}
