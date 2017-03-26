# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "lxc" do |lxc|
      lxc.customize 'cgroup.memory.limit_in_bytes', '1024M'
  end

  config.vm.define :workstation do |workstation_config|
    workstation_config.vm.box = "stretch"
    workstation_config.vm.host_name = 'workstation.local'
    workstation_config.vm.synced_folder "salt/", "/srv/salt"
    workstation_config.vm.synced_folder "pillar/", "/srv/pillar"
    # Don't set up private network:
    # workstation_config.vm.network "private_network", ip: "192.168.50.13" # bug https://github.com/mitchellh/vagrant/issues/7155

    # workaround to set up /etc/salt/minion, since vagrant doesn't allow to sync
    # single files except by setting up rsync..
    # install gitpython instead of pygit2 to be able to use gitfs
    # See https://github.com/libgit2/pygit2/issues/644
    workstation_config.vm.provision :shell, :inline => "sudo apt-get -y install git-core"
    workstation_config.vm.provision :shell, :inline => "sudo apt-get -y install python-git salt-minion"
    # salt-minion service shouldn't be running, as we have no master:
    workstation_config.vm.provision :shell, :inline => "sudo systemctl stop salt-minion && sudo systemctl disable salt-minion"

    workstation_config.vm.provision :salt do |salt|
      salt.masterless = true
      # don't bootstrap nor run the service, as we are masterless
      salt.no_minion = true
      salt.minion_config = "etc/workstation"
      salt.run_highstate = false
      salt.verbose = true
      salt.colorize = true
    end

  end

end
