define procmailrc (
  $procmail_rules = [[]],
  $home = '',
  $group = '',
  $ensure = present,
  $user_name = $name,
) {
  $procmail_maildir = "${homedir}/Maildir"

  if $home == '' {
    $homedir = "/home/${user_name}/"
  } else {
    $homedir = $home
  }

  if $group == '' {
    $mygroup = $user_name
  } else {
    $mygroup = $group
  }

  file { "${homedir}/.procmailrc":
    ensure  => $ensure,
    content => template('procmailrc/procmailrc.erb'),
    owner   => $user_name,
    group   => $mygroup,
    mode    => '0444',
  }
}
