class xerl_freebsd::checkout (
  $user,
  $xerl_root,
  $hosts_root,
  $giturl,
) {

  Exec {
    path   => [ '/bin', '/usr/bin', '/usr/local/bin' ],
  }

  exec { "sudo -u ${user} sh -c 'git clone ${giturl} -b hosts ${hosts_root}'":
    unless => "test -d ${hosts_root}"
  }

  exec { "sudo -u ${user} sh -c 'git clone ${giturl} ${xerl_root}'":
    unless => "test -d ${xerl_root}",
  }
}
