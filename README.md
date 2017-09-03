# ABANDONED IN FAVOUR OF
# https://github.com/viccuad/ansible-configs

--------


New incarnation of my dotfiles, on steroids.

This salt configs implement Puppet's "Role" pattern to set up my dotfiles,
GUIless workstation, laptop setup, desktop environment, offline PC, router with
Freedombox and more.
Currently it contains already several hundred(!) states.


# Where are the dotfiles? #

If you don't want to dive into salt and just want to extract some dotfiles'
config from here, look at:

- `salt/profile/dotfiles/<whatever>/files/*`: a file tree that you could put
  right on to `~` with stow and the like
- `salt/profile/dotfiles/<whatever>/files/init.sls`: salt state to install
  dependencies, append environmental variables, aliases, process templates and
  copy them where they correspond, etc
- `salt/profile/dotfiles/<whatever>/templates/*`: files that are `sed'ed` by
  salt in some way and afterwards copied into place


# How is private info taken care of? #

I have contemplated several options:
  * git submodules or external repo
  * .gpg files decrypted by states
    - apply highstate twice, one to set up gpg/pass, the other to use both
  * git-crypt
  * salt gpg renderer:
    https://docs.saltstack.com/en/latest/ref/renderers/all/salt.renderers.gpg.html
  * salt sds:
    https://docs.saltstack.com/en/latest/topics/sdb

I [use][3] a smartcard and I like encrypting everything with gpg and
centralizing everything with it as a 2-factor auth.
I also want to apply the public part of the salt configs and not have binary
encrypted blobs breaking programs here and there (eg: blobs instead of config
files for weechat, or gnupg, or mail, etc).

With that in mind, I've chosen the git submodule option. I like the trade-off
of having a git submodule that contains all the private states and files, and
the submodule only gets used if it has been initialized and populated.


# Deploying the configs #

## Testing with vagrant (if you are me) ##

On the host, requires `lxc`, `vagrant`, `vagrant-lxc`, and `gnupg` 2.1+ for
gpg-agent forwarding (and therefore the private states).

1. Build your own debian Stretch image as explained below
2. `$ vagrant up workstation`
3. Ssh into the container and apply the first phase of salt states, the public
   one:

    ```
    workstation ~# salt-call -l debug --state-output=mixed state.apply
    ```

4. Start the forwarding of gpg from the host to the container: take
   `salt/profile/dotfiles/gnupg/files/.local/bin/remote-gpg`, execute it
   and leave it running:

   ```
   host ~$ remote-gpg <ip of lxc container>

   Perform remote GPG operations and hit enter
   ```

   If you get a warning, execute again the script to remove the gpg sockets

5. Connect the Yubikey, and now you have gpg working inside the container.
6. `git submodule init && git submodule update`
7. Rerun salt states now that the private submodules are checked out
8. ???
9. Profit!


## From inside a system ##

1. Symlink the needed folders and install the dependencies by executing
   `bootstrap.sh --symlink`
2. Run the first phase of salt states, the public one:

```
workstation ~# salt-call -l debug --state-output=mixed state.apply
```

4. Connect the smartcard, do `git submodule init && git submodule update`
5. Rerun salt states


# Building a Stretch image #

Until Debian Stretch is officially released, you can build your own Stretch lxc
image (following the official scripts) and use it for the Vagrantfile.

Inside this repo, do:

```
$ git clone https://anonscm.debian.org/git/cloud/debian-vm-templates.git
$ sudo make -C debian-vm-templates/custom-lxc-vagrant stretch
$ vagrant up
```


# "Roles" code pattern #

The code that describes the infrastructure follows the pattern:


```
    []         Ids (identity of the machine. Eg: machine02)
   [] []       Roles (business logic. Eg: workstation, nas). Implemented in pillars
 [] [] []      Profiles (Configure whole stack. Eg: dns server). Implemented in states
[] [] [] []    Salt formulas (Configure part of the stack. eg: sshd)
```

The targeting is based on pillar contents; the pillars contain a dictionary
called `states`, with the states to be applied. Since it's a dictionary, it gets
merged from all the pillars.

For more info, see [4] and [5].

The role pattern is a best-practices one for Puppet, see [1] and [2].

[1]: https://docs.puppet.com/pe/2016.4/r_n_p_intro.html
[2]: https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern
[3]:http://viccuad.me/blog/secure-yourself-part-1-airgapped-computer-and-GPG-smartcards
[4]: http://seedickcode.com/devops/saltstack/saltstack-a-better-salt-top-sls-part-2/
[5]: https://www.lutro.me/posts/dangers-of-targetting-grains-in-salt
