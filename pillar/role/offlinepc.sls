{% set hostname = salt['grains.get']('host') %}

states:
  profile.offlinepc: true
  profile.dotfiles.gnupg: true
  profile.dotfiles.signing-party: true

users:
  vic:
    fullname: Víctor Cuadrado Juan
    uid: 1001
    gid: 1001
    shell: /bin/zsh
    email: vic@{{ hostname }}
    user_dir_mode: 755
    groups:
      - vic
      - users
      - tty
      - mail
      - sudo
      - cdrom
      - floppy
      - dip
      - plugdev
