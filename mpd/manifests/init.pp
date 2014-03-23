# http://linuxaria.com/recensioni/play-your-music-on-linux-with-music-player-daemon

class mpd (
  $ensure = present,
  $music_directory,
  $config_template = 'mpd.conf.erb',
  $playlist_directory = '/var/lib/mpd/playlists',
  $db_file = '/var/lib/mpd/tag_cache',
  $log_file = '/var/log/mpd/mpd.log',
  $pid_file = '/var/run/mpd/pid',
  $state_file = '/var/lib/mpd/state',
  $sticker_file = '/var/lib/mpd/sticker.sql',
  $user = 'mpd',
  $bind_to_address = $::ipaddress,
  $mpd_port = '6600',
  $log_level = 'default',
  $http_stream_port = '8000',
  $http_stream_bitrate = '128', # Not used in the template ATM
  $http_stream_quality = '5',
) {

  package { [ 'mpd', 'mpc']:
    ensure => $ensure,
  }

  file { "${name}_config":
    ensure  => $ensure,
    content => template("mpd/${config_template}"),
    path    => '/etc/mpd.conf',
    owner   => root,
    group   => root,
    mode    => '0644',

    require => [
      Package['mpd'],
      Package['mpc'],
    ]
  }

  if $ensure == present {
    service { 'mpd':
      ensure    => running,
      enable    => true,
      hasstatus => true,

      require   => File["${name}_config"],
      subscribe => File["${name}_config"],
    }
  }
}
