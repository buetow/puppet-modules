Facter.add(:zsh_path) do
  setcode do
    os = Facter.value('operatingsystem') 
    if os == 'FreeBSD'
      '/usr/local/bin/zsh'
    else
      '/usr/bin/zsh'
    end
  end
end
