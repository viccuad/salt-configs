{% if grains['os_family'] == 'Debian' %}

{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

include:
  - profile.dotfiles.git
  - profile.dotfiles.lxc

debian_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore
    - keep_symlinks: True

debian_recurse_files_pbuilder:
  file.recurse:
    - name: /
    - source: salt://{{ slspath }}/pbuilder/
    - user: root
    - group: root
    - file_mode: keep # for pbuilder hooks
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore
    - keep_symlinks: True

debian_zshenv:
  file.append:
    - name: /home/{{ user }}/.zshenv
    - text: |
            # debian:
            # export DEBFULLNAME=""
            # export DEBEMAIL=""
            export DEB_BUILD_OPTIONS="parallel={{ grains['num_cpus'] - 1 }}"

debian_zshaliases:
  file.append:
    - name: /home/{{ user }}/.zsh/aliases.zsh
    - text: |
            # debian aliases:
            alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
            alias rebuild="${HOME}/debian/reproducible-misc/prebuilder/rebuild.sh -b ${HOME}/pbuilder/sid-amd64-base-reproducible.tgz"
            alias wrap-and-sort='wrap-and-sort -ast'
            alias pbuilder="sudo -E pbuilder"

debian_install:
  pkg.installed:
    - names:
      # normal usage:
      - reportbug
      - debsums
      - apt-listbugs
      - apt-listchanges
      - how-can-i-help
      - gdebi
      # build tools:
      - autoconf
      - automake
      - cmake
      - autotools-dev
      - dpkg-dev-el
      - devscripts-el
      - debian-el
      # debian tools:
      - debian-policy
      - debhelper
      - dh-make
      - dh-autoreconf
      - debian-goodies
      - debian-archive-keyring
      - debian-keyring
      - debianutils
      - debootstrap
      - deborphan
      - devscripts
      - fakeroot
      - patch
      - patchutils
      - pbuilder
      - cowbuilder
      - ccache
      - eatmydata
      - quilt
      - xutils-dev
      - diffoscope
      - lintian
      - dupload
      - dput-ng
      - git-buildpackage
      - python-notify
      - git-dpm
      # python packages:
      - python-all-dev
      - python3-all-dev
      - python-stdeb
      - python3-stdeb

debian_setup_autopkgtest:
  pkg.installed:
    - names:
      - apt-cacher-ng
      - debci
      - autopkgtest
  file.append:
    - name: /etc/sudoers.d/lxc
    - makedirs: True
      # TODO add rules with user's formula sudo rules, or with visudo directly
      # run lxc commands as root, preserving environment:
    - text: |
            {{ user }}  ALL = NOPASSWD:SETENV: /usr/bin/lxc-*
    - require:
      - sls: profile.dotfiles.lxc

debian_gitconfig:
  file.append:
    - name: /home/{{ user }}/.gitconfig
    - text: |
            # debian config:
            [dpm]
              pristineTarCommit = true
            [url "git://git.debian.org"]
              insteadOf = git+ssh://git.debian.org
            [url "git+ssh://git.debian.org"]
              pushInsteadOf = git+ssh://git.debian.org
    - require:
      - sls: profile.dotfiles.git

debian_ssh_config:
  file.append:
    - name: /home/{{ user }}/.ssh/config
    - makedirs: True
    - text: |
            # Debian:
            Host svn.debian.org git.debian.org bzr.debian.org hg.debian.org darcs.debian.org arch.debian.org alioth.debian.org
                User viccuad-guest

# TODO add rules with user's formula sudo rules, or with visudo directly
debian_sudoers_pbuilder:
  file.append:
    - name: /etc/sudoers.d/pbuilder
    - makedirs: True
    - text: |
            Cmnd_Alias  PBUILDERS = /usr/sbin/pbuilder, /usr/bin/pdebuild, /usr/bin/debuild-pbuilder, /usr/sbin/cowbuilder
            Defaults! PBUILDERS       setenv, env_keep+="HOME DIST ARCH"
            vic  ALL=(ALL) PBUILDERS

debian_clone_reproducible-misc:
  git.latest:
    - name: https://anonscm.debian.org/git/reproducible/misc.git
    - target: /home/{{ user }}/debian/reproducible-misc
    - user: {{ user }}
    - require:
      - pkg: git

{% endif %}
{% endfor %}

{% endif %}
