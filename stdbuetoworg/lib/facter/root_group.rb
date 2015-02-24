Facter.add(:root_group) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      'wheel'
    elsif os == 'Darwin'
      'wheel'
    else
      'root'
    end
  end
end
