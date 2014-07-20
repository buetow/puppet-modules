class lxc::cgroup (
  $autoreboot = true
){
  ## Mount cgroup
  mount { '/sys/fs/cgroup':
    ensure  => mounted,
    device  => 'cgroup',
    atboot  => true,
    fstype  => 'cgroup',
    options => 'defaults',
  }

  ## Enable memory and swap accounting
  $grub_file = '/etc/default/grub'
  $grub_key = 'GRUB_CMDLINE_LINUX_DEFAULT'
  $grub_default = 'quiet cgroup_enable=memory swapaccount=1'
  $grub_line = "${grub_key}=\"${grub_default}\""

  exec { "${name}_reboot":
    command => '/bin/rm -f /REBOOT_NEXT_PUPPET_RUN_LXC && /sbin/reboot',
    onlyif  => '/usr/bin/test -f /REBOOT_NEXT_PUPPET_RUN_LXC',
  }

  exec { "${name}_kernel_param":
    command => "/bin/sed -i 's/.*${grub_key}.*/${grub_line}/' ${grub_file}",
    unless  => "/bin/grep '${grub_line}' ${grub_file}",
  }

  if $autoreboot {
    $autoreboot_flag = '&& /usr/bin/touch /REBOOT_NEXT_PUPPET_RUN_LXC'
  } else {
    $autoreboot_flag = ''
  }

  exec { "${name}_grub_mkconfig":
    command     => "/usr/sbin/grub-mkconfig ${autoreboot_flag}",
    subscribe   => Exec["${name}_kernel_param"],
    refreshonly => true,
  }
}
