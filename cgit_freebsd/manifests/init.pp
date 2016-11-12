class cgit_freebsd (
  $ensure = present,
  $root_title = 'cgit.buetow.org',
  $root_desc = 'The buetowdotorg git repos',
  $virtual_root = '/cgit/',
  $snapshots = '.tar.gz',
  $scan_path = '/git/',
  $enable_git_config = '1',
) {
  $apache_config_dir = '/usr/local/etc/apache'
  $apache_includes_dir = "${apache_config_dir}/Includes"

  case $ensure {
    present: { $ensure_directory = directory }
    absent: { $ensure_directory = absent }
    default: { fail("No such ensure: ${ensure}") }
  }

  package { 'cgit':
    ensure => $ensure,
  }

  file { '/usr/local/etc/cgitrc':
    ensure  => $ensure,
    content => template('cgit_freebsd/cgitrc.erb')
  }

  file { "${apache_includes_dir}/cgit.conf":
    ensure  => $ensure,
    content => template('cgit_freebsd/apache.cgit.conf.erb')
  }
}

