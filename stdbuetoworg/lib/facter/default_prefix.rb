Facter.add(:default_prefix) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      '/usr/local'
    else
      ''
    end
  end
end
