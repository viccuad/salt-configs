{% set hostname = salt['grains.get']('host') %}

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
      - dialout
      - cdrom
      - floppy
      - audio
      - dip
      - video
      - plugdev
      - netdev
      - lpadmin
      - scanner
      - bluetooth
      - kvm
      - libvirt
      - vboxusers
      - docker
