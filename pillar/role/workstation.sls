{% set hostname = salt['grains.get']('host') %}

users:
  vic:
    fullname: Víctor Cuadrado Juan
    uid: 1001
    gid: 1001
    shell: /bin/zsh
    email: viccuad@localhost.{{ hostname }}
    user_dir_mode: 755
    sudouser: true
    groups:
      - users
