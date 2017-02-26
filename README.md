Bunch of salt config files for setting up my workstation/laptop/desktop
environment/etc.

# Dotfiles #

If you don't want to dive into salt and just want to extract some dotfile config
from here, look at:
- `salt/profile/dotfiles/<whatever>/files/*`: a file tree that you could put
  right on to `~` with stow and the like
- `salt/profile/dotfiles/<whatever>/files/init.sls`: salt state to install
  dependencies, append environmental variables, aliases, process template and
  copy them where they correspond, etc
- `salt/profile/dotfiles/<whatever>/templates/*`: files that are processed by
  salt and copied into place

# Salt code pattern #

Debug salt on your client (the machine running the salt-minion) via:

 ```salt-call -l debug --state-output=mixed state.apply```

The code that describes the infrastructure is implementing the following pattern:

- Description of the infrastructure:

```
    []         Ids (identity of the machine. Eg: machine02)
   [] []       Roles (business logic. Eg: workstation, nas)
 [] [] []      Profiles (Configure whole stack. Eg: dns server)
[] [] [] []    Salt formulas (Configure part of the stack. eg: sshd)
```

- Data of the infrastructure: separated into the pillars.

This pattern is a best-practices one for Puppet, see [1] and [2].

[1]: https://docs.puppet.com/pe/2016.4/r_n_p_intro.html
[2]: https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern


# Building your own Debian Stretch image #

Until Debian Stretch is officially released, you can build your own Stretch lxc
image (following the official scripts) and use it for the Vagrantfile.

Inside this repo, do:

```
$ git clone https://anonscm.debian.org/git/cloud/debian-vm-templates.git
$ sudo make -C debian-vm-templates/custom-lxc-vagrant stretch
$ cp debian-vm-templates/custom-lxc-vagrant/stretch.box .
$ vagrant up
$ rm stretch.box
```
