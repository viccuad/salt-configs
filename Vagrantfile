# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "lxc" do |lxc|
      lxc.customize 'cgroup.memory.limit_in_bytes', '1024M'
  end

  # this hostnames' list get used by vagrant to populate the hostname (duh) of
  # the container, with gets read by salt as the `id` grain, which is then used
  # to set `role` grains, which get checked afterwards to apply the corresponding
  # configuration
  hostnames = ['aworkstation', 'aserver', 'anofflinepc','arouter']

  hostnames.each do |name|
    config.vm.define "#{name}" do |system|
      system.vm.box = "stretch"
      system.vm.host_name = "#{name}"
      system.vm.synced_folder "salt/", "/srv/salt"
      system.vm.synced_folder "pillar/", "/srv/pillar"
      # Don't set up private network:
      # system.vm.network "private_network", ip: "192.168.50.13" # bug https://github.com/mitchellh/vagrant/issues/7155
      system.vm.provision "shell", path: "bootstrap.sh"

      # # workaround to set up /etc/salt/minion, since vagrant doesn't allow to sync
      # # single files except by setting up rsync..
      system.vm.provision :salt do |salt|
        salt.masterless = true
        # don't bootstrap nor run the service, as we are masterless
        salt.no_minion = true
        salt.minion_config = "etc/minion"
        salt.run_highstate = false
        salt.verbose = true
        salt.colorize = true
      end
      system.vm.provision "shell",
                          inline: "salt-call -l debug --state-output=mixed state.apply"
    end
  end

end
