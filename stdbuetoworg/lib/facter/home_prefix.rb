Facter.add(:home_prefix) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      '/usr/home'
    elsif os == 'Darwin'
      '/Users'
    else
      '/home'
    end
  end
end
