Facter.add(:timedate) do
  setcode do
    Time.now.strftime("%Y%m%d%H%M%S")
  end
end
