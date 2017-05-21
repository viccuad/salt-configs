{% set hostname = salt['grains.get']('host') %}

states:
  profile.server: true

users:
  vic:
    fullname: Víctor Cuadrado Juan
    uid: 1000
    gid: 1000
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
