class xerl::hosts (
  $user,
  $githostsurl,
  $githostsbranch,
  $hostsroot
) {

  exec { "/bin/su - ${user} /bin/sh -c 'git clone ${githostsurl} -b ${githostsbranch} ${hostsroot}'":
    unless => "/usr/bin/test -d ${hostsroot}",
  }
}

