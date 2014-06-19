class motd (
  $ensure = present,
  $template = '',
){
  if $template == '' {
    case $::operatingsystem {
      FreeBSD: { $template_file = 'motd.rantanplanbsd.erb' }
      NetBSD: { $template_file = 'motd.rantanplanbsd.erb' }
      OpenBSD: { $template_file = 'motd.rantanplanbsd.erb' }
      DragonFly: { $template_file = 'motd.rantanplanbsd.erb' }
      Debian: { $template_file = 'motd.rantanplanian.erb' }
      Ubuntu: { $template_file = 'motd.rantanplanian.erb' }
      default: { $template_file = 'motd.erb' }
    }
  } else {
    $template_file = $template
  }

  file { '/etc/motd':
    ensure  => $ensure,
    content => template("motd/${template_file}"),
    mode    => '0444',
    owner   => root,
    group   => $::root_group,
  }
}
