class inter {
  case $operatingsystem {
    'FreeBSD': { 
      $rootgroup = 'wheel'
    }
    default: { 
      $rootgroup = 'root'
    }
  }
}
