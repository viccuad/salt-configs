The idea is to apply the Puppet code pattern to create Salt config files to
setup from a GUIless workstation, to laptop configs, Desktop Environments,
and later add NAS, router, media servers, Kodi, etc.


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
    https://docs.saltstack.com/en/latest/topics/sdb/

I [use][3] smartcard and I like encrypting everything with gpg and centralizing
everything with it as a 2SA.

I also want to apply the public part of the salt configs and not have binary
encrypted blobs breaking programs here and there (eg: blobs instead of config
files for weechat, or gnupg, or mail, etc).

I've chosen the git submodule option. I like the trade-off of having a git
submodule that contains all the private states and files, and submodule only
gets used if it has been initialized and populated


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
9. Profit


## From inside a system ##

1. Symlink:
   - `etc/workstation` to `/etc/salt/minion`
   - `pillar` to `/srv/pillar`
   - `salt` to `/srv/salt`
2. Install the needed dependencies by executing `bootstrap.sh`
3. Run the first phase of salt states, the public one:

```
workstation ~# salt-call -l debug --state-output=mixed state.apply
```

4. Connect the smartcard, do `git submodule init && git submodule update`
5. Rerun salt states


# Building an Stretch image #

Until Debian Stretch is officially released, you can build your own Stretch lxc
image (following the official scripts) and use it for the Vagrantfile.

Inside this repo, do:

```
$ git clone https://anonscm.debian.org/git/cloud/debian-vm-templates.git
$ sudo make -C debian-vm-templates/custom-lxc-vagrant stretch
$ vagrant up
```


# Salt code pattern #

The code that describes the infrastructure is implementing the following pattern:

- Description of the systems' infrastructure:

```
    []         Ids (identity of the machine. Eg: machine02)
   [] []       Roles (business logic. Eg: workstation, nas)
 [] [] []      Profiles (Configure whole stack. Eg: dns server)
[] [] [] []    Salt formulas (Configure part of the stack. eg: sshd)
```

- Data of the infrastructure: separated into the pillars, and salt `files` and
  `templates` folders

This pattern is a best-practices one for Puppet, see [1] and [2].

[1]: https://docs.puppet.com/pe/2016.4/r_n_p_intro.html
[2]: https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern
[3]:http://viccuad.me/blog/secure-yourself-part-1-airgapped-computer-and-GPG-smartcards
