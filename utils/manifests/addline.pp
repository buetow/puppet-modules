define utils::addline (
  $file,
  $line
) {
  exec { "/bin/bash -c 'echo \"${line}\" >> ${file}'":
    unless => "/bin/grep -qFx '${line}' ${file}",
  }
}

