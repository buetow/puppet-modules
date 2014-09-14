Facter.add(:ports_bootstrapdone) do
  setcode do
    if File.exists? '/usr/ports/.portsbootstrap/bootstrap.done'
      true
    else
      false
    end
  end
end
