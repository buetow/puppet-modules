Facter.add(:has_restricted) do
  setcode do
    if File.exists?('/etc/puppet/has_restricted')
      true
    elsif File.exists?('/usr/local/etc/puppet/has_restricted')
      true
    else
      false
    end
  end
end
