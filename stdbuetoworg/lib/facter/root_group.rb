Facter.add(:root_group) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      'wheel'
    else
      'root'
    end
  end
end
