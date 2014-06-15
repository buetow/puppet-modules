Facter.add(:default_www) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      'www'
    else
      'www-run'
    end
  end
end
