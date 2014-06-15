Facter.add(:default_prefix) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      return '/usr/local'
    else
      return ''
    end
  end
end
