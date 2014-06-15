class nfs::server_files (
  $ensure = present
) {
  File { owner => root, group => $root_group, mode => '0444', ensure => $ensure }

  file { '/etc/exports':
    source => "puppet:///modules/nfs/exports.${::hostname}",
  }
}
