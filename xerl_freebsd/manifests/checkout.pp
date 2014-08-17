class xerl_freebsd::checkout (
  $user,
  $xerl_root,
  $hosts_root,
  $giturl,
) {

  Exec {
    path   => [ '/bin', '/usr/bin', '/usr/local/bin' ],
  }

  exec { "sudo -u ${user} sh -c 'git clone ${giturl} -b hosts ${hosts_root}/hosts'":
    unless => "test -d ${hosts_root}/hosts"
  }

  exec { "sudo -u ${user} sh -c 'git clone ${giturl} ${xerl_root}/master'":
    unless => "test -d ${xerl_root}/master",
  }
}
