Facter.add(:home_prefix) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      '/usr/home'
    else
      '/home'
    end
  end
end
