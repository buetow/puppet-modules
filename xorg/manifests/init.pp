class xorg (
  $model = 'x240',
  $ensure = present,
) {
  File {
    owner => root,
    group => root,
  }
  file { '/etc/X11/xorg.conf':
    ensure => $ensure,
    source => "puppet:///modules/xorg/xorg.conf.${model}",
  }
}
