Facter.add(:root_group) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      return 'wheel'
    else
      return 'root'
    end
  end
end
