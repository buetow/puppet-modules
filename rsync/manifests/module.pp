define rsync::module (
  $path,
  $comment,
  $readonly = true,
  $writeonly = false,
  $list = true,
  $uid = 'nobody',
  $gid = 'nogroup',
  $incoming_chmod = 'u=rwX,g=rX,o=rX',
  $outgoing_chmod = 'u=rwX,g=rX,o=rX',
  $refuse_options = 'delete',
  $ensure = 'present',
  $max_connections = '200',
  $pre_xfer_exec = '/usr/local/bin/create_rsync_parent_directories.sh',
  $dirmode = '0755',
  $managepath = true
) {

  file { "/etc/rsyncd.d/${name}.fragment":
    ensure  => $ensure,
    content => template('rsync/etc.rsyncd.fragment.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $managepath {
    file { "Rsync Module Directory ${name}":
      ensure => directory,
      path   => $path,
      owner  => $uid,
      group  => $gid,
      mode   => $dirmode,
      notify => [
        Class['rsync::server'],
      ],
    }
  }
}

