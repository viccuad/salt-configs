{% set hostname = salt['grains.get']('host') %}

users:
  vic:
    fullname: Víctor Cuadrado Juan
    uid: 1001
    gid: 1001
    shell: /bin/zsh
    email: vic@localhost.{{ hostname }}
    user_dir_mode: 755
    sudouser: true
    sudo_rules:
      - ALL=(ALL) NOPASSWD:ALL
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
