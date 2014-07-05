define jail::create::debian_kfreebsd (
  $use_zfs = true
) {
  jail::create { $name:
    use_zfs => $use_zfs
  }
}
