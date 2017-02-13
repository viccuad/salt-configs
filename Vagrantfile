# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # config.vm.provider "virtualbox" do |vb|
  #   vb.memory = 1024
  # end

  config.vm.provider "lxc" do |lxc|
      lxc.customize 'cgroup.memory.limit_in_bytes', '1024M'
  end

  config.vm.define :workstation do |workstation_config|
    # workstation_config.vm.box = "ubuntu/yakkety64"
    # workstation_config.vm.box = "debian/jessie64"
    workstation_config.vm.box = "stretch"
    workstation_config.vm.box_url = "stretch.box"
    workstation_config.vm.host_name = 'workstation.local'
    workstation_config.vm.synced_folder "salt/", "/srv/salt"
    workstation_config.vm.synced_folder "pillar/", "/srv/pillar"
    # Don't set up private network:
    # workstation_config.vm.network "private_network", ip: "192.168.50.13" # bug https://github.com/mitchellh/vagrant/issues/7155

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

    # salt-minion service shouldn't be running, as we have no master:
    # workstation_config.vm.provision :shell, :inline => "sudo systemctl stop salt-minion && sudo systemctl disable salt-minion"

  end

  # config.vm.define :workstation do |workstation_config|
  #   workstation_config.vm.box = "debian/jessie64"
  #   # workstation_config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64/versions/8.3.0/providers/lxc.box"
  #   workstation_config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64/versions/8.7.0/providers/virtualbox.box"
  #   # workstation_config.vm.box_download_checksum = "98c5fb7aca0bdd427ae76a999e4a71d974113c3e3f899171f92e6e549ad54393" # lxc jessie64
  #   workstation_config.vm.box_download_checksum = "7ababe2bb1794939a406f15db7c4e84e4adf1bfe682c2ddb44b88b4a5a071ffc" # virtualbox jessie64
  #   workstation_config.vm.box_download_checksum_type = "sha256"
  #   # workstation_config.vm.network "private_network", ip: "192.168.50.13" # bug https://github.com/mitchellh/vagrant/issues/7155
  #   workstation_config.vm.host_name = 'workstation.local'

  #   # mount state tree and pillar
  #   workstation_config.vm.synced_folder "saltstack/salt/", "/srv/salt/", type: "rsync"
  #   workstation_config.vm.synced_folder "saltstack/pillar/", "/srv/pillar/", type: "rsync"

  #   # install gitpython instead of pygit2 to be able to use gitfs
  #   # See https://github.com/libgit2/pygit2/issues/644
  #   workstation_config.vm.provision :shell, :inline => "sudo apt-get -y install git-core python-git salt-minion"
  #   # salt-minion service shouldn't be running, as we have no master:
  #   workstation_config.vm.provision :shell, :inline => "sudo systemctl stop salt-minion && sudo systemctl disable salt-minion"

  #   workstation_config.vm.provision :salt do |salt|
  #     salt.minion_config = "saltstack/etc/minion"
  #     salt.masterless = true
  #     salt.run_highstate = false
  #     salt.verbose = true
  #     salt.colorize = true
  #   end
  # end

end
