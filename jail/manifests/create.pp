define jail::create (
  $use_zfs = true,
  $mountpoint = "/jails/${name}/",
) {
  include jail


}
