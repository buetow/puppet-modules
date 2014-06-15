class inter {
  case $operatingsystem {
    'FreeBSD': { 
      $rootgroup = 'wheel'
      $defaultprefix = '/usr/local'
    }
    default: { 
      $rootgroup = 'root'
      $defaultprefix = ''
    }
  }
}
