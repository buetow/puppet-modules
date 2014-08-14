class xbmc (
  $user_name = 'tv'
){

  include xbmc::packages

  s_user::create { 'xbmc_user':
    user_name      => $user_name,
    is_desktop     => true,
    user_fullname  => 'XBMC user',
    has_nfs_backup => true,
  }
}

