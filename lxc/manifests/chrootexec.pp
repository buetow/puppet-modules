define lxc::chrootexec (
  $lxc_name,
  $command = '',
  $refreshonly = false,
) {
  $rootfs = "/var/lib/lxc/${lxc_name}/rootfs"

  if $command == '' {
    $exec_command = $name
  } else {
    $exec_command = $command
  }

  exec { $name:
    command     => "/usr/sbin/chroot ${rootfs} ${exec_command}",
    refreshonly => $refreshonly
  }
}

