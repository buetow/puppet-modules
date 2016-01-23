class mailman::files (
  $ensure = present
) {
  File { owner => root, group => root, ensure => $ensure }

  file { '/etc/mailman/mm_cfg.py':
    source => 'puppet:///modules/mailman/mm_cfg.py',
  }

  file { '/usr/local/mailman/bin/list_requests':
    source => 'puppet:///modules/mailman/list_requests',
    mode   => '0755',
  }

  file { '/etc/apache2/conf.d/my-mailman':
    source => 'puppet:///modules/mailman/my-mailman',
  }

  file { '/etc/apache2/mailman.conf':
    source => 'puppet:///modules/mailman/mailman.conf',
  }
}
