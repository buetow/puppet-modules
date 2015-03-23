Facter.add(:default_prefix) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      '/usr/local'
    elsif os == 'Darwin'
      '/opt/local'
    else
      ''
    end
  end
end
