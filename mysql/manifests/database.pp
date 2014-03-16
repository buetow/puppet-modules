define mysql::database (
  $user,
  $password
) {
  exec { "${name}_create_db":
    unless  => "/usr/bin/mysql -u${user} -p${password} ${name}",
    command => "/usr/bin/mysql -uroot -p${mysql::mysqlpassword} -e \"create database ${name}; grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
  }
}
