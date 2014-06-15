Facter.add(:default_www) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      'www'
    else
      'www-data'
    end
  end
end
